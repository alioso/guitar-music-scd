"""
Drawing threshold — pushes the image toward high-contrast woodcut / linocut.

At silence: gentle posterize (4–5 tonal levels), natural colour.
Rising amplitude: tightens to 2–3 levels, shifts toward pure B&W adaptive threshold.
Peak: harsh binary ink-on-paper look.

Blended over the original so colours still bleed through at moderate levels.
"""
import numpy as np
import cv2

MEDIA = {'still'}

AMP_POWER = 1.6


def _posterize(gray, levels):
    step = max(1, 256 // levels)
    lut  = np.array([(v // step) * step + step // 2 for v in range(256)],
                    dtype=np.uint8)
    return cv2.LUT(gray, lut)


def setup(frame, osc_state):
    return {}


def render(frame, osc_state, state):
    amp  = osc_state['amp'] ** AMP_POWER
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    if amp < 0.35:
        levels = max(2, int(5 - amp * 6))
        result = _posterize(gray, levels)
    else:
        block  = max(11, int(51 - amp * 40)) | 1
        c      = 2 + amp * 6
        result = cv2.adaptiveThreshold(gray, 255,
                                       cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
                                       cv2.THRESH_BINARY, block, c)

    result_3 = cv2.cvtColor(result, cv2.COLOR_GRAY2BGR)
    alpha    = 0.20 + amp * 0.80
    return cv2.addWeighted(frame, 1.0 - alpha, result_3, alpha, 0)
