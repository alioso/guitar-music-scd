"""
Drawing paper fold — mirrors one half to create perfect bilateral symmetry,
as if the drawing were folded along the centre axis.

Modes (chosen randomly each activation):
  fold_left   — left half mirrored rightward
  fold_right  — right half mirrored leftward
  fold_top    — top half mirrored downward
  fold_bottom — bottom half mirrored upward

Amplitude drives a subtle grain overlay.
"""
import random
import numpy as np
import cv2

TYPE  = 'layout'
MEDIA = {'still'}

_MAX_GRAIN = 20
_AMP_POWER = 2.0
_rng       = np.random.default_rng()

_MODES = ['fold_left', 'fold_right', 'fold_top', 'fold_bottom']


def setup(frame, osc_state, context=None):
    return {'mode': random.choice(_MODES)}


def render(frame, osc_state, state):
    h, w = frame.shape[:2]
    mode  = state['mode']

    if mode == 'fold_left':
        half = frame[:, :w // 2]
        out  = np.concatenate([half, np.fliplr(half)], axis=1)

    elif mode == 'fold_right':
        half = frame[:, w - w // 2:]
        out  = np.concatenate([np.fliplr(half), half], axis=1)

    elif mode == 'fold_top':
        half = frame[:h // 2]
        out  = np.concatenate([half, np.flipud(half)], axis=0)

    else:  # fold_bottom
        half = frame[h - h // 2:]
        out  = np.concatenate([np.flipud(half), half], axis=0)

    out = cv2.resize(out, (w, h), interpolation=cv2.INTER_LINEAR)

    amp = osc_state['amp'] ** _AMP_POWER
    if amp > 0.001:
        noise = _rng.standard_normal(out.shape, dtype=np.float32) * (amp * _MAX_GRAIN)
        out   = np.clip(out.astype(np.float32) + noise, 0, 255).astype(np.uint8)

    return out
