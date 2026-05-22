"""
Drawing zoom animator — crops micro-regions of a still drawing, applies one
of 12 sub-effects per region, uses sound energy to drive transition timing.

Drop images into visuals/drawings/ and point the scheduler at that folder.

Zoom crops: 2–25% of each image dimension (linear), biased toward the small
end. P_FULL controls how often the full image is shown for context instead.

Sound: an energy accumulator fills with amp each frame; when it crosses a
random threshold (and HOLD_MIN has elapsed), a transition fires. Hard max
at HOLD_MAX regardless. Transitions are randomly hard cuts or crossfades.
"""
import time
import random
import cv2
import numpy as np

MEDIA = {'still'}

# --- tuning ---
P_FULL       = 0.20   # probability of full-image context shot on each transition
P_CROSSFADE  = 0.55   # probability of crossfade vs hard cut
FADE_DUR_MIN = 0.3    # crossfade duration range (seconds)
FADE_DUR_MAX = 1.5
HOLD_MIN     = 2.0    # minimum seconds between transitions
HOLD_MAX     = 30.0   # maximum seconds between transitions
ZOOM_MIN     = 0.02   # min crop fraction of each dimension
ZOOM_MAX     = 0.25   # max crop fraction of each dimension
ENERGY_LO    = 0.4    # random threshold range for accumulator trigger
ENERGY_HI    = 2.0
AMP_POWER    = 1.5    # >1 = peaks drive harder, normal playing stays subtle
INTRO_DUR    = 5.0    # seconds of bare full image before first effect kicks in

_rng = np.random.default_rng()


# ---------------------------------------------------------------------------
# sub-effects — each takes (patch uint8 BGR, amp 0–1) → uint8 BGR
# ---------------------------------------------------------------------------

def _hue_spin(patch, amp):
    hsv = cv2.cvtColor(patch, cv2.COLOR_BGR2HSV).astype(np.float32)
    hsv[:, :, 0] = (hsv[:, :, 0] + amp * 120) % 180
    return cv2.cvtColor(np.clip(hsv, 0, 255).astype(np.uint8), cv2.COLOR_HSV2BGR)


def _channel_shift(patch, amp):
    shift = int(amp * 30)
    if shift == 0:
        return patch
    out = patch.copy()
    out[:, :, 0] = np.roll(patch[:, :, 0],  shift, axis=1)
    out[:, :, 2] = np.roll(patch[:, :, 2], -shift, axis=0)
    return out


def _liquify(patch, amp):
    h, w = patch.shape[:2]
    strength = amp * 20.0
    xs2d, ys2d = np.meshgrid(np.arange(w, dtype=np.float32),
                              np.arange(h, dtype=np.float32))
    dx = strength * np.sin(ys2d / h * np.pi * 4 + amp * 6)
    dy = strength * np.cos(xs2d / w * np.pi * 4 + amp * 4)
    map_x = np.clip(xs2d + dx, 0, w - 1).astype(np.float32)
    map_y = np.clip(ys2d + dy, 0, h - 1).astype(np.float32)
    return cv2.remap(patch, map_x, map_y, cv2.INTER_LINEAR)


def _edge_glow(patch, amp):
    gray  = cv2.cvtColor(patch, cv2.COLOR_BGR2GRAY)
    edges = cv2.Canny(gray, 40, 120)
    hsv_edge = np.zeros((*gray.shape, 3), dtype=np.uint8)
    hsv_edge[:, :, 0] = int(amp * 120) % 180
    hsv_edge[:, :, 1] = 255
    hsv_edge[:, :, 2] = edges
    colored = cv2.cvtColor(hsv_edge, cv2.COLOR_HSV2BGR)
    alpha = np.clip(amp * 1.5, 0.3, 1.0)
    return cv2.addWeighted(patch, 1.0 - alpha * 0.6, colored, alpha, 0)


def _posterize(patch, amp):
    levels = max(2, int(8 - amp * 6))
    step   = 256 // levels
    lut    = np.array([min(255, (v // step) * step + step // 2)
                       for v in range(256)], dtype=np.uint8)
    return cv2.LUT(patch, lut)


def _chromatic_aberration(patch, amp):
    shift = int(amp * 20) + 1
    b, g, r = cv2.split(patch)
    r = np.roll(r,  shift, axis=1)
    b = np.roll(b, -shift, axis=0)
    return cv2.merge([b, g, r])


def _pixel_sort(patch, amp):
    gray  = cv2.cvtColor(patch, cv2.COLOR_BGR2GRAY)
    order = np.argsort(gray, axis=0)
    if amp > 0.5:
        order = order[::-1]
    col_idx = np.arange(patch.shape[1])
    return patch[order, col_idx[np.newaxis, :], :]


def _halftone(patch, amp):
    h, w    = patch.shape[:2]
    spacing = max(4, int(20 - amp * 15))
    gray    = cv2.cvtColor(patch, cv2.COLOR_BGR2GRAY)
    py, px  = np.mgrid[0:h, 0:w]
    cy_idx  = np.minimum(py // spacing, h // spacing)
    cx_idx  = np.minimum(px // spacing, w // spacing)
    cy      = cy_idx * spacing
    cx      = cx_idx * spacing
    # clamp center sample coords to image bounds
    sample_y = np.clip(cy, 0, h - 1)
    sample_x = np.clip(cx, 0, w - 1)
    brightness = gray[sample_y, sample_x] / 255.0
    dist       = np.sqrt((py - cy).astype(np.float32) ** 2 +
                         (px - cx).astype(np.float32) ** 2)
    dot_mask   = dist <= (brightness * spacing * 0.5)
    out        = patch.copy()
    out[dot_mask] = 255
    return out


def _mirror(patch, amp):
    axis = 1 if amp < 0.5 else 0
    out  = patch.copy()
    if axis == 1:
        half = patch.shape[1] // 2
        out[:, half:] = out[:, :half][:, ::-1][:, :patch.shape[1] - half]
    else:
        half = patch.shape[0] // 2
        out[half:] = out[:half][::-1][:patch.shape[0] - half]
    return out


def _bloom(patch, amp):
    blur_k = max(3, int(amp * 40) | 1)
    bright = np.clip(patch.astype(np.float32) - 128, 0, None)
    glow   = cv2.GaussianBlur(bright, (blur_k, blur_k), 0)
    return np.clip(patch.astype(np.float32) + glow * amp, 0, 255).astype(np.uint8)


def _invert_tint(patch, amp):
    inv = 255 - patch
    hsv = cv2.cvtColor(inv, cv2.COLOR_BGR2HSV).astype(np.float32)
    hsv[:, :, 0] = (hsv[:, :, 0] + amp * 90) % 180
    return cv2.cvtColor(np.clip(hsv, 0, 255).astype(np.uint8), cv2.COLOR_HSV2BGR)


def _smear(patch, amp):
    k      = max(3, int(amp * 20) | 1)
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (k, k))
    return cv2.dilate(patch, kernel) if amp > 0.5 else cv2.erode(patch, kernel)


_SUBEFFECTS = [
    _hue_spin, _channel_shift, _liquify, _edge_glow, _posterize,
    _chromatic_aberration, _pixel_sort, _halftone, _mirror,
    _bloom, _invert_tint, _smear,
]


# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

def _pick_region(h, w):
    """Returns (x, y, cw, ch) or None for full image."""
    if random.random() < P_FULL:
        return None
    # squared random biases toward smaller zooms
    frac_w = ZOOM_MIN + (random.random() ** 1.8) * (ZOOM_MAX - ZOOM_MIN)
    frac_h = ZOOM_MIN + (random.random() ** 1.8) * (ZOOM_MAX - ZOOM_MIN)
    cw = max(2, int(frac_w * w))
    ch = max(2, int(frac_h * h))
    x  = random.randint(0, max(0, w - cw))
    y  = random.randint(0, max(0, h - ch))
    return (x, y, cw, ch)


def _extract_patch(full, region, out_h, out_w):
    if region is None:
        return cv2.resize(full, (out_w, out_h), interpolation=cv2.INTER_LINEAR)
    x, y, cw, ch = region
    fh, fw = full.shape[:2]
    # probability of pixelated upscale scales with how extreme the zoom is
    avg_frac   = ((cw / fw) + (ch / fh)) * 0.5
    p_nearest  = 1.0 - (avg_frac / ZOOM_MAX)
    interp     = cv2.INTER_NEAREST if random.random() < p_nearest else cv2.INTER_LINEAR
    patch = full[y:y + ch, x:x + cw]
    return cv2.resize(patch, (out_w, out_h), interpolation=interp)


def _new_threshold():
    return random.uniform(ENERGY_LO, ENERGY_HI)


# ---------------------------------------------------------------------------
# effect contract
# ---------------------------------------------------------------------------

def setup(frame, osc_state):
    fh, fw = frame.shape[:2]
    return {
        'full':      frame.copy(),
        'out_h':     fh,
        'out_w':     fw,
        'intro':     True,     # bare full image shown until INTRO_DUR elapses
        'region':    None,
        'subeffect': random.choice(_SUBEFFECTS),
        'hold':      random.uniform(HOLD_MIN, HOLD_MAX),
        'elapsed':   0.0,
        'energy':    0.0,
        'threshold': _new_threshold(),
        'last_ts':   time.monotonic(),
        'blend_from': None,
        'blend_t':    0.0,
        'blend_dur':  0.0,
    }


def render(frame, osc_state, state):
    now = time.monotonic()
    dt  = now - state['last_ts']
    state['last_ts'] = now
    state['elapsed'] += dt

    amp  = osc_state['amp'] ** AMP_POWER
    full = state['full']
    oh, ow = state['out_h'], state['out_w']

    # intro: show bare full image, then crossfade into first effect
    if state['intro']:
        if state['elapsed'] < INTRO_DUR:
            return cv2.resize(full, (ow, oh), interpolation=cv2.INTER_LINEAR)
        # intro over — set up crossfade from bare image into first effect
        state['intro']      = False
        state['elapsed']    = 0.0
        state['region']     = None   # first moment is always full image
        state['blend_from'] = cv2.resize(full, (ow, oh), interpolation=cv2.INTER_LINEAR)
        state['blend_t']    = 0.0
        state['blend_dur']  = random.uniform(FADE_DUR_MIN, FADE_DUR_MAX)

    fh, fw = full.shape[:2]
    state['energy'] += amp * dt

    fired = (
        state['energy'] >= state['threshold'] and state['elapsed'] >= HOLD_MIN
    ) or state['elapsed'] >= HOLD_MAX

    if fired:
        old_patch  = _extract_patch(full, state['region'], oh, ow)
        old_render = state['subeffect'](old_patch, amp)

        state['region']    = _pick_region(fh, fw)
        state['subeffect'] = random.choice(_SUBEFFECTS)
        state['hold']      = random.uniform(HOLD_MIN, HOLD_MAX)
        state['elapsed']   = 0.0
        state['energy']    = 0.0
        state['threshold'] = _new_threshold()

        if random.random() < P_CROSSFADE:
            state['blend_from'] = old_render
            state['blend_t']    = 0.0
            state['blend_dur']  = random.uniform(FADE_DUR_MIN, FADE_DUR_MAX)
        else:
            state['blend_from'] = None

    patch  = _extract_patch(full, state['region'], oh, ow)
    result = state['subeffect'](patch, amp)

    if state['blend_from'] is not None:
        state['blend_t'] += dt
        t      = min(state['blend_t'] / state['blend_dur'], 1.0)
        result = cv2.addWeighted(state['blend_from'], 1.0 - t, result, t, 0)
        if t >= 1.0:
            state['blend_from'] = None

    return result
