"""
Composition — two media items side by side, each filling half the screen.
Left/right assignment is randomised each activation.
Amplitude drives a subtle grain across both panels.
"""
import random
import cv2
import numpy as np

TYPE  = 'layout'
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
        return cv2.imread(path), None, mtype
    cap         = cv2.VideoCapture(path)
    total       = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    start       = random.randint(0, max(0, int(total * 0.9)))
    cap.set(cv2.CAP_PROP_POS_FRAMES, start)
    ret, frame  = cap.read()
    if not ret:
        cap.release()
        return None, None, mtype
    cap.set(cv2.CAP_PROP_POS_FRAMES, start)
    return frame, cap, mtype


def _fit_panel(frame, w, h):
    """Scale frame to fill (w, h), centred on black."""
    fh, fw  = frame.shape[:2]
    scale   = min(w / fw, h / fh)
    nw, nh  = int(fw * scale), int(fh * scale)
    resized = cv2.resize(frame, (nw, nh), interpolation=cv2.INTER_AREA if scale < 1 else cv2.INTER_LINEAR)
    canvas  = np.zeros((h, w, 3), dtype=np.uint8)
    canvas[(h-nh)//2:(h-nh)//2+nh, (w-nw)//2:(w-nw)//2+nw] = resized
    return canvas


def setup(frame, osc_state, context=None):
    sw, sh   = context['screen'] if context else (1920, 1080)
    pw, ph   = sw // 2, sh

    if context is None:
        return {'f2': frame.copy(), 'cap2': None, 'type2': 'still',
                'swap': False, 'pw': pw, 'ph': ph}

    f2, cap2, type2 = _load_second(context, context.get('current_path', ''))
    if f2 is None:
        f2 = frame.copy()
        cap2, type2 = None, 'still'

    return {'f2': f2, 'cap2': cap2, 'type2': type2,
            'swap': random.random() > 0.5, 'pw': pw, 'ph': ph}


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

    pw, ph = state['pw'], state['ph']
    p1 = _fit_panel(frame, pw, ph)
    p2 = _fit_panel(f2,    pw, ph)

    left, right = (p2, p1) if state['swap'] else (p1, p2)
    out = np.concatenate([left, right], axis=1)

    amp = osc_state['amp'] ** _AMP_POWER
    if amp > 0.001:
        noise = _rng.standard_normal(out.shape, dtype=np.float32) * (amp * _MAX_GRAIN)
        out   = np.clip(out.astype(np.float32) + noise, 0, 255).astype(np.uint8)

    return out
