"""
Target-face blur — detects faces once on activation, blurs them each frame.
Amplitude drives blur intensity: silence = subtle, loud = unrecognisable.

Uses OpenCV's DNN face detector (much more accurate than Haar cascades on
artistic, historical, or non-frontal portraits). Model files are downloaded
automatically on first use (~10 MB total) into visuals/models/.

For a hard rectangular blockout version, see tf_block_face.py.
"""
import os
import urllib.request
import cv2
import numpy as np

MEDIA = {'still'}

_MIN_BLUR   = 11
_MAX_BLUR   = 101
_CONFIDENCE = 0.45   # lower = more detections, higher = stricter
AMP_POWER   = 2.0    # >1 = more headroom; peaks drive hard blur, normal playing stays subtle

_MODELS_DIR   = os.path.join(os.path.dirname(__file__), '..', 'models')
_PROTOTXT     = os.path.join(_MODELS_DIR, 'deploy.prototxt')
_CAFFEMODEL   = os.path.join(_MODELS_DIR, 'res10_300x300_ssd.caffemodel')

_PROTOTXT_URL   = "https://raw.githubusercontent.com/opencv/opencv/master/samples/dnn/face_detector/deploy.prototxt"
_CAFFEMODEL_URL = "https://github.com/opencv/opencv_3rdparty/raw/dnn_samples_face_detector_20170830/res10_300x300_ssd_iter_140000.caffemodel"

_net = None


def _ensure_model():
    global _net
    if _net is not None:
        return
    os.makedirs(_MODELS_DIR, exist_ok=True)
    for path, url in ((_PROTOTXT, _PROTOTXT_URL), (_CAFFEMODEL, _CAFFEMODEL_URL)):
        if not os.path.exists(path):
            print(f"  tf_blur_face: downloading {os.path.basename(path)} ...")
            urllib.request.urlretrieve(url, path)
    _net = cv2.dnn.readNetFromCaffe(_PROTOTXT, _CAFFEMODEL)


def _detect_faces(frame):
    h, w = frame.shape[:2]
    blob = cv2.dnn.blobFromImage(
        cv2.resize(frame, (300, 300)), 1.0,
        (300, 300), (104.0, 177.0, 123.0)
    )
    _net.setInput(blob)
    detections = _net.forward()

    faces = []
    for i in range(detections.shape[2]):
        conf = detections[0, 0, i, 2]
        if conf < _CONFIDENCE:
            continue
        box = detections[0, 0, i, 3:7] * np.array([w, h, w, h])
        x1, y1, x2, y2 = box.astype(int)
        x1, y1 = max(0, x1), max(0, y1)
        x2, y2 = min(w, x2), min(h, y2)
        if x2 > x1 and y2 > y1:
            faces.append((x1, y1, x2 - x1, y2 - y1))
    return faces


def setup(frame, osc_state):
    _ensure_model()
    faces = _detect_faces(frame)
    print(f"  tf_blur_face: {len(faces)} face(s) detected")
    return {'faces': faces}


def render(frame, osc_state, state):
    faces = state['faces']
    if not faces:
        return frame

    amp = osc_state['amp'] ** AMP_POWER
    k   = int(_MIN_BLUR + amp * (_MAX_BLUR - _MIN_BLUR))
    k   = k if k % 2 == 1 else k + 1

    blurred = cv2.GaussianBlur(frame, (k, k), 0)
    orig_f  = frame.astype(np.float32)
    blur_f  = blurred.astype(np.float32)
    out_f   = orig_f.copy()

    for (x, y, w, h) in faces:
        cx, cy = x + w // 2, y + h // 2
        ax     = int(w * 0.58)
        ay     = int(h * 0.72)

        ellipse_mask = np.zeros(frame.shape[:2], dtype=np.float32)
        cv2.ellipse(ellipse_mask, (cx, cy), (ax, ay), 0, 0, 360, 1.0, -1)
        feather      = max(w, h) // 5
        feather      = feather if feather % 2 == 1 else feather + 1
        ellipse_mask = cv2.GaussianBlur(ellipse_mask, (feather, feather), 0)

        m3    = ellipse_mask[:, :, np.newaxis]
        out_f = out_f * (1.0 - m3) + blur_f * m3

    return out_f.astype(np.uint8)
