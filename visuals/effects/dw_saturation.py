"""
Drawing saturation — boosts colour saturation and drifts hue driven by amplitude.

At silence the drawing stays near its natural colour.
At peak amplitude saturation pushes vivid and hue slowly shifts.
"""
import time
import numpy as np
import cv2

MEDIA = {'still'}

_SAT_BASE  = 1.05   # saturation multiplier at silence (almost natural)
_SAT_MAX   = 1.9    # saturation multiplier at full amplitude
_HUE_DRIFT = 7.5     # degrees/sec of hue shift at peak amplitude
AMP_POWER  = 1.4


def setup(frame, osc_state):
    return {'hue_offset': 0.0, 'last': time.monotonic()}


def render(frame, osc_state, state):
    now = time.monotonic()
    dt  = now - state['last']
    state['last'] = now

    amp = osc_state['amp'] ** AMP_POWER
    state['hue_offset'] = (state['hue_offset'] + amp * _HUE_DRIFT * dt) % 180

    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV).astype(np.float32)

    sat_mul = _SAT_BASE + amp * (_SAT_MAX - _SAT_BASE)
    hsv[:, :, 1] = np.clip(hsv[:, :, 1] * sat_mul, 0, 255)

    if amp > 0.04:
        hsv[:, :, 0] = (hsv[:, :, 0] + state['hue_offset']) % 180

    return cv2.cvtColor(hsv.astype(np.uint8), cv2.COLOR_HSV2BGR)
