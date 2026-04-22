"""
Person B&W — people rendered in greyscale, background keeps its natural colour
with a subtle amplitude-driven saturation boost.

The world gets more vivid as you play; the people drain of colour.
Uses YOLOv8n-seg (model downloads automatically on first use, ~6 MB).
"""
import cv2
import numpy as np

MEDIA = {'video'}
PERF  = 'heavy'   # uses YOLO inference per frame — scheduler won't pair with another heavy effect

_SAT_BASE = 1.20   # background saturation multiplier at silence
_SAT_MAX  = 1.55   # at full amplitude

_model = None


def setup(frame, osc_state):
    global _model
    if _model is None:
        from ultralytics import YOLO
        _model = YOLO('yolov8n-seg.pt')
        print("  person_bw: YOLO model ready")
    return {}


def render(frame, osc_state, state):
    results = _model(frame, classes=[0], verbose=False)   # class 0 = person

    # Build float mask: 1.0 where person, 0.0 where background
    mask = np.zeros(frame.shape[:2], dtype=np.float32)
    if results[0].masks is not None:
        for m in results[0].masks.data:
            m_np     = m.cpu().numpy()
            m_scaled = cv2.resize(m_np, (frame.shape[1], frame.shape[0]))
            mask     = np.maximum(mask, m_scaled)
    mask = np.clip(mask, 0.0, 1.0)

    # People → greyscale
    gray   = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray_3 = cv2.cvtColor(gray, cv2.COLOR_GRAY2BGR)

    # Background → natural colour, saturation nudged upward
    amp     = osc_state['amp']
    sat_mul = _SAT_BASE + amp * (_SAT_MAX - _SAT_BASE)
    hsv     = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV).astype(np.float32)
    hsv[:, :, 1] = np.clip(hsv[:, :, 1] * sat_mul, 0, 255)
    bg      = cv2.cvtColor(hsv.astype(np.uint8), cv2.COLOR_HSV2BGR)

    # Composite: blend at mask edges for a soft border
    m3     = mask[:, :, np.newaxis]
    result = (gray_3.astype(np.float32) * m3 +
              bg.astype(np.float32)     * (1.0 - m3))
    return result.astype(np.uint8)
