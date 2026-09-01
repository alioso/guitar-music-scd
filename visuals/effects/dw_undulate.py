"""
Drawing undulation — sinusoidal warp targeted to a zone, feathered at edges.

Zone mode chosen at activation:
  full    (30%) — whole image ripples
  h_band  (25%) — one horizontal strip: top / middle / bottom
  v_band  (25%) — one vertical strip: left / center / right
  rect    (20%) — random rectangle

Outside the zone the image is untouched. Amplitude drives intensity and speed.
"""
import time
import random
import numpy as np
import cv2

MEDIA = {'still'}

_SPEED_BASE    = 0.4    # rad/sec always-on gentle drift
_SPEED_AMP     = 2.8    # additional speed at peak amplitude
_STRENGTH_BASE = 4.0    # pixel displacement at silence
_STRENGTH_AMP  = 28.0   # additional displacement at peak
_FEATHER       = 30     # feather radius at zone edges (pixels)

_rng = np.random.default_rng()


def _choose_zone(h, w):
    """Returns (mode, x, y, zw, zh) describing the active zone."""
    r = random.random()
    if r < 0.30:
        return 'full', 0, 0, w, h
    elif r < 0.55:
        band_h = h // 3
        row    = random.randint(0, 2)
        return 'h_band', 0, row * band_h, w, band_h
    elif r < 0.80:
        band_w = w // 3
        col    = random.randint(0, 2)
        return 'v_band', col * band_w, 0, band_w, h
    else:
        fw = _rng.uniform(0.25, 0.60)
        fh = _rng.uniform(0.25, 0.60)
        zw = int(fw * w)
        zh = int(fh * h)
        x  = int(_rng.integers(0, max(1, w - zw)))
        y  = int(_rng.integers(0, max(1, h - zh)))
        return 'rect', x, y, zw, zh


def _zone_mask(mode, h, w, x, y, zw, zh):
    if mode == 'full':
        return None  # no mask needed
    mask = np.zeros((h, w), dtype=np.float32)
    cv2.rectangle(mask, (x, y), (x + zw - 1, y + zh - 1), 1.0, -1)
    f = min(_FEATHER, zw // 4, zh // 4)
    if f > 2:
        k    = f * 2 + 1
        mask = cv2.GaussianBlur(mask, (k, k), 0)
    return mask


def setup(frame, osc_state):
    h, w = frame.shape[:2]
    xs, ys = np.meshgrid(np.arange(w, dtype=np.float32),
                          np.arange(h, dtype=np.float32))
    mode, x, y, zw, zh = _choose_zone(h, w)
    return {
        'xs':     xs,
        'ys':     ys,
        'h':      h,
        'w':      w,
        'mode':   mode,
        'zone':   (x, y, zw, zh),
        'mask':   _zone_mask(mode, h, w, x, y, zw, zh),
        'phase':  float(_rng.uniform(0, 2 * np.pi)),
        'last':   time.monotonic(),
        'freq_x': float(_rng.uniform(2.0, 5.5)),
        'freq_y': float(_rng.uniform(1.5, 4.5)),
        'cross':  bool(_rng.random() > 0.5),
    }


def render(frame, osc_state, state):
    now = time.monotonic()
    dt  = now - state['last']
    state['last'] = now

    amp   = osc_state['amp']
    speed = _SPEED_BASE + amp * _SPEED_AMP
    state['phase'] += speed * dt
    phase = state['phase']

    h, w = frame.shape[:2]

    # Compositor may resize the frame relative to the base frame used at setup;
    # rebuild size-dependent caches whenever the shape changes.
    if h != state['h'] or w != state['w']:
        xs, ys = np.meshgrid(np.arange(w, dtype=np.float32),
                              np.arange(h, dtype=np.float32))
        mode, x, y, zw, zh = _choose_zone(h, w)
        state.update({'xs': xs, 'ys': ys, 'h': h, 'w': w,
                      'mode': mode, 'zone': (x, y, zw, zh),
                      'mask': _zone_mask(mode, h, w, x, y, zw, zh)})

    xs, ys = state['xs'], state['ys']
    fx, fy = state['freq_x'], state['freq_y']

    strength = _STRENGTH_BASE + amp * _STRENGTH_AMP

    if state['cross']:
        dx = strength * np.sin(2 * np.pi * ys / h * fy + phase)
        dy = strength * np.cos(2 * np.pi * xs / w * fx + phase)
    else:
        dx = strength * np.sin(2 * np.pi * ys / h * fy + phase)
        dy = strength * np.sin(2 * np.pi * xs / w * fx + phase * 0.7)

    map_x   = np.clip(xs + dx, 0, w - 1).astype(np.float32)
    map_y   = np.clip(ys + dy, 0, h - 1).astype(np.float32)
    warped  = cv2.remap(frame, map_x, map_y, cv2.INTER_LINEAR,
                        borderMode=cv2.BORDER_REFLECT_101)

    if state['mode'] == 'full':
        return warped

    mask = state['mask'][:, :, np.newaxis]
    return (warped.astype(np.float32) * mask +
            frame.astype(np.float32)  * (1.0 - mask)).astype(np.uint8)
