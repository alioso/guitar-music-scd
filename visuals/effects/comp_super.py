"""
Composition — two media items superimposed with complementary opacities.
Alpha split is randomised each activation (0.30–0.70 / remainder).
Amplitude gently drifts the split toward the louder end.
"""
import random
import cv2
import numpy as np

TYPE  = 'layout'
MEDIA = {'still', 'video'}

_ALPHA_MIN = 0.30
_ALPHA_MAX = 0.70
_AMP_DRIFT = 0.12   # max alpha shift driven by amplitude


def _load_second(context, main_path):
    pool = [(p, t) for p, t in context['media'] if p != main_path]
    if not pool:
        pool = context['media']
    path, mtype = random.choice(pool)
    if mtype == 'still':
        return cv2.imread(path), None, mtype
    cap        = cv2.VideoCapture(path)
    total      = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    start      = random.randint(0, max(0, int(total * 0.9)))
    cap.set(cv2.CAP_PROP_POS_FRAMES, start)
    ret, frame = cap.read()
    if not ret:
        cap.release()
        return None, None, mtype
    cap.set(cv2.CAP_PROP_POS_FRAMES, start)
    return frame, cap, mtype


def setup(frame, osc_state, context=None):
    if context is None:
        return {'f2': frame.copy(), 'cap2': None, 'type2': 'still', 'alpha': 0.5}
    f2, cap2, type2 = _load_second(context, context.get('current_path', ''))
    if f2 is None:
        f2 = frame.copy()
    return {
        'f2':    f2,
        'cap2':  cap2,
        'type2': type2,
        'alpha': random.uniform(_ALPHA_MIN, _ALPHA_MAX),
    }


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

    h, w = frame.shape[:2]
    f2   = cv2.resize(f2, (w, h), interpolation=cv2.INTER_AREA)

    # Amplitude nudges alpha toward the main frame
    alpha = float(np.clip(state['alpha'] + osc_state['amp'] * _AMP_DRIFT, 0.0, 1.0))
    return cv2.addWeighted(frame, alpha, f2, 1.0 - alpha, 0)
