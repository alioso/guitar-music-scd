"""
Composition — two media items side by side.
Which item lands left vs right is randomised each activation.
Amplitude drives a subtle grain across both panels.
"""
import random
import cv2
import numpy as np

MEDIA = {'still', 'video'}

_MAX_GRAIN = 28
_AMP_POWER = 2.0
_rng       = np.random.default_rng()


def _load_second(context, main_path):
    pool = [(p, t) for p, t in context['media'] if p != main_path]
    if not pool:
        pool = context['media']
    path, mtype = random.choice(pool)
    if mtype == 'still':
        frame = cv2.imread(path)
        return frame, None, mtype
    cap = cv2.VideoCapture(path)
    ret, frame = cap.read()
    if not ret:
        cap.release()
        return None, None, mtype
    cap.set(cv2.CAP_PROP_POS_FRAMES, 0)
    return frame, cap, mtype


def setup(frame, osc_state, context=None):
    if context is None:
        return {'f2': frame.copy(), 'cap2': None, 'type2': 'still', 'swap': False}
    f2, cap2, type2 = _load_second(context, context.get('current_path', ''))
    if f2 is None:
        f2 = frame.copy()
    return {'f2': f2, 'cap2': cap2, 'type2': type2, 'swap': random.random() > 0.5}


def teardown(state):
    if state.get('cap2') is not None:
        state['cap2'].release()


def render(frame, osc_state, state):
    if state['type2'] == 'video' and state['cap2'] is not None:
        ret, f2 = state['cap2'].read()
        if not ret:
            state['cap2'].set(cv2.CAP_PROP_POS_FRAMES, 0)
            _, f2 = state['cap2'].read()
    else:
        f2 = state['f2']

    # Resize both panels to same height, equal width
    h = frame.shape[0]
    f2 = cv2.resize(f2, (int(f2.shape[1] * h / f2.shape[0]), h))
    w  = min(frame.shape[1], f2.shape[1])
    f1 = cv2.resize(frame, (w, h))
    f2 = cv2.resize(f2,    (w, h))

    left, right = (f2, f1) if state['swap'] else (f1, f2)
    out = np.concatenate([left, right], axis=1)

    amp = osc_state['amp'] ** _AMP_POWER
    if amp > 0.001:
        noise = _rng.standard_normal(out.shape, dtype=np.float32) * (amp * _MAX_GRAIN)
        out   = np.clip(out.astype(np.float32) + noise, 0, 255).astype(np.uint8)

    return out
