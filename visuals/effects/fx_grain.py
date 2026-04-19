"""Additive Gaussian film grain scaled by guitar amplitude."""
import numpy as np

MEDIA = {'still', 'video'}

MAX_GRAIN = 55    # noise sigma (0–255) at amp=1.0
AMP_POWER = 2.0   # >1 = more headroom; normal playing stays subtle, peaks hit hard

_rng = np.random.default_rng()


def setup(frame, osc_state):
    return {}


def render(frame, osc_state, state):
    amp = osc_state['amp'] ** AMP_POWER
    if amp < 0.001:
        return frame
    img_f = frame.astype(np.float32)
    noise = _rng.standard_normal(img_f.shape, dtype=np.float32) * (amp * MAX_GRAIN)
    return np.clip(img_f + noise, 0, 255).astype(np.uint8)
