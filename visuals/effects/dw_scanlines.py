"""
Drawing scanlines — horizontal or vertical lines burned into the image,
like a photocopier, darkroom contact sheet, or old CRT monitor.

Line orientation is randomised per activation.
Amplitude controls opacity and spacing: louder = denser and darker lines.
"""
import random
import numpy as np
import cv2

MEDIA = {'still'}

AMP_POWER    = 1.4
_SPACING_MIN = 3    # px between lines at peak amplitude
_SPACING_MAX = 10   # px between lines at silence
_OPACITY_MIN = 0.08
_OPACITY_MAX = 0.55

_rng = np.random.default_rng()


def setup(frame, osc_state):
    return {'horizontal': random.random() > 0.5}


def render(frame, osc_state, state):
    amp     = osc_state['amp'] ** AMP_POWER
    h, w    = frame.shape[:2]
    spacing = max(_SPACING_MIN, int(_SPACING_MAX - amp * (_SPACING_MAX - _SPACING_MIN)))
    opacity = _OPACITY_MIN + amp * (_OPACITY_MAX - _OPACITY_MIN)

    out  = frame.astype(np.float32)
    dark = 1.0 - opacity

    if state['horizontal']:
        out[::spacing, :] *= dark
    else:
        out[:, ::spacing] *= dark

    return np.clip(out, 0, 255).astype(np.uint8)
