"""
Drawing ink pulse — detects dark ink lines and adds a coloured halo that
blooms with guitar amplitude.

At silence lines are crisp and clean.
As you play the ink lines gain a coloured glow whose hue drifts slowly,
giving the drawing a sense of energy concentrated in its marks.
"""
import time
import numpy as np
import cv2

MEDIA = {'still'}

_INK_THRESH  = 85    # pixel value below which a pixel is considered ink
_GLOW_MAX    = 0.90  # max glow alpha at peak amplitude
_HUE_DRIFT   = 8.0   # degrees/sec of hue shift at peak amplitude
AMP_POWER    = 1.3

_rng = np.random.default_rng()


def setup(frame, osc_state):
    return {
        'hue':  float(_rng.uniform(0, 180)),
        'last': time.monotonic(),
    }


def render(frame, osc_state, state):
    now = time.monotonic()
    dt  = now - state['last']
    state['last'] = now

    amp = osc_state['amp'] ** AMP_POWER
    state['hue'] = (state['hue'] + amp * _HUE_DRIFT * dt) % 180

    if amp < 0.02:
        return frame

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Detect ink: dark pixels
    ink_mask = (gray < _INK_THRESH).astype(np.float32)

    # Spread the glow outward from ink pixels
    k        = max(3, int(amp * 35) | 1)
    glow_map = cv2.GaussianBlur(ink_mask, (k, k), 0)

    # Build a solid colour from the drifting hue
    hsv_pixel   = np.array([[[int(state['hue']), 230, 255]]], dtype=np.uint8)
    glow_colour = cv2.cvtColor(hsv_pixel, cv2.COLOR_HSV2BGR)[0, 0].astype(np.float32)

    glow_layer = glow_map[:, :, np.newaxis] * glow_colour  # (h, w, 3)

    result = np.clip(frame.astype(np.float32) + glow_layer * amp * _GLOW_MAX,
                     0, 255).astype(np.uint8)
    return result
