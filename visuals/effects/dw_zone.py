"""
Drawing zone effect — applies a sub-effect to one rectangular region while
leaving the rest of the image untouched. The zone has soft feathered edges.

Replaces the zoom concept: the full drawing stays visible, but one area is
treated with grain, inversion, saturation, distortion, or edge emphasis.
Amplitude drives sub-effect intensity and triggers zone shifts.
"""
import time
import random
import numpy as np
import cv2

MEDIA = {'still'}

_ZONE_MIN = 0.18   # minimum zone side as fraction of image dimension
_ZONE_MAX = 0.50   # maximum zone side fraction
_HOLD_MIN = 3.0    # minimum seconds between zone changes
_HOLD_MAX = 18.0
_ENERGY_LO = 0.5   # amp energy accumulator trigger range
_ENERGY_HI = 2.5
AMP_POWER  = 1.5
_FEATHER   = 24    # feather radius in pixels

_rng = np.random.default_rng()


def _pick_zone(h, w):
    fw = _rng.uniform(_ZONE_MIN, _ZONE_MAX)
    fh = _rng.uniform(_ZONE_MIN, _ZONE_MAX)
    zw = int(fw * w)
    zh = int(fh * h)
    x  = int(_rng.integers(0, max(1, w - zw)))
    y  = int(_rng.integers(0, max(1, h - zh)))
    return x, y, zw, zh


def _zone_mask(zh, zw):
    mask = np.zeros((zh, zw), dtype=np.float32)
    f    = min(_FEATHER, zh // 4, zw // 4)
    if f < 2:
        return np.ones((zh, zw), dtype=np.float32)
    cv2.rectangle(mask, (f, f), (zw - f - 1, zh - f - 1), 1.0, -1)
    k = f * 2 + 1
    mask = cv2.GaussianBlur(mask, (k, k), 0)
    return mask


# ── sub-effects ───────────────────────────────────────────────────────────────

def _grain(patch, amp):
    noise = _rng.standard_normal(patch.shape, dtype=np.float32) * (amp * 65)
    return np.clip(patch.astype(np.float32) + noise, 0, 255).astype(np.uint8)


def _invert(patch, amp):
    return 255 - patch


def _saturation(patch, amp):
    hsv = cv2.cvtColor(patch, cv2.COLOR_BGR2HSV).astype(np.float32)
    hsv[:, :, 1] = np.clip(hsv[:, :, 1] * (1.6 + amp * 2.2), 0, 255)
    return cv2.cvtColor(hsv.astype(np.uint8), cv2.COLOR_HSV2BGR)


def _distort(patch, amp):
    h, w = patch.shape[:2]
    xs, ys = np.meshgrid(np.arange(w, dtype=np.float32),
                          np.arange(h, dtype=np.float32))
    s  = amp * 22.0
    dx = s * np.sin(ys / max(h, 1) * np.pi * 3.5)
    dy = s * np.cos(xs / max(w, 1) * np.pi * 3.0)
    mx = np.clip(xs + dx, 0, w - 1).astype(np.float32)
    my = np.clip(ys + dy, 0, h - 1).astype(np.float32)
    return cv2.remap(patch, mx, my, cv2.INTER_LINEAR)


def _edges(patch, amp):
    gray  = cv2.cvtColor(patch, cv2.COLOR_BGR2GRAY)
    edges = cv2.Canny(gray, 25, 90)
    col   = np.zeros_like(patch)
    col[:, :, 2] = edges          # red channel
    col[:, :, 0] = edges // 3    # faint blue
    alpha = 0.35 + amp * 0.55
    return cv2.addWeighted(patch, 1.0 - alpha * 0.7, col, alpha, 0)


_SUBEFFECTS = [_grain, _invert, _saturation, _distort, _edges]


# ── effect contract ───────────────────────────────────────────────────────────

def setup(frame, osc_state):
    h, w  = frame.shape[:2]
    zone  = _pick_zone(h, w)
    x, y, zw, zh = zone
    return {
        'zone':      zone,
        'mask':      _zone_mask(zh, zw),
        'subeffect': random.choice(_SUBEFFECTS),
        'elapsed':   0.0,
        'energy':    0.0,
        'threshold': random.uniform(_ENERGY_LO, _ENERGY_HI),
        'last_ts':   time.monotonic(),
    }


def render(frame, osc_state, state):
    now = time.monotonic()
    dt  = now - state['last_ts']
    state['last_ts'] = now
    state['elapsed'] += dt

    amp = osc_state['amp'] ** AMP_POWER
    state['energy'] += amp * dt

    h, w = frame.shape[:2]

    # Rebuild zone if compositor changed the frame dimensions since setup
    if (h, w) != state.get('_shape'):
        x, y, zw, zh = _pick_zone(h, w)
        state['zone']   = (x, y, zw, zh)
        state['mask']   = _zone_mask(zh, zw)
        state['_shape'] = (h, w)

    fired = (
        state['energy'] >= state['threshold'] and state['elapsed'] >= _HOLD_MIN
    ) or state['elapsed'] >= _HOLD_MAX

    if fired:
        x, y, zw, zh = _pick_zone(h, w)
        state['zone']      = (x, y, zw, zh)
        state['mask']      = _zone_mask(zh, zw)
        state['subeffect'] = random.choice(_SUBEFFECTS)
        state['elapsed']   = 0.0
        state['energy']    = 0.0
        state['threshold'] = random.uniform(_ENERGY_LO, _ENERGY_HI)

    if amp < 0.02:
        return frame

    x, y, zw, zh = state['zone']
    patch     = frame[y:y+zh, x:x+zw]
    processed = state['subeffect'](patch, amp)

    mask3 = state['mask'][:, :, np.newaxis]
    blended = (processed.astype(np.float32) * mask3 +
               patch.astype(np.float32)     * (1.0 - mask3)).astype(np.uint8)

    out = frame.copy()
    out[y:y+zh, x:x+zw] = blended
    return out
