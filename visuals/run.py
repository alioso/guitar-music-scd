"""
Visual effects runner for live guitar performance.

Usage:
    python visuals/run.py --media visuals/stills/
    python visuals/run.py --media visuals/media/ --effects fx_grain,tf_blur_face
    python visuals/run.py --media visuals/media/ --min-dur 5 --max-dur 30
    python visuals/run.py --media visuals/stills/ --screen 1280x800

Controls:
    Esc / Q  — quit

Stacking:
    Each activation picks an optional compositor (comp_*) and 0–2 process
    effects (fx_*, tf_*, tp_*) chained on top. Probabilities are tunable
    via COMP_CHANCE and PROC_WEIGHTS in the config section below.
"""

import sys
import os
import time
import random
import inspect
import threading
import argparse
import importlib
import subprocess

import numpy as np
import cv2
from pythonosc import dispatcher, osc_server

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# ── Config ────────────────────────────────────────────────────────────────────
OSC_PORT     = 57200
AMP_SCALE    = 5.0
AMP_SMOOTH   = 0.12
MAX_DIM      = 1920
FPS          = 30

COMP_CHANCE  = 0.40          # probability of adding a compositor each activation
PROC_WEIGHTS = [0.3, 0.5, 0.2]  # weights for [0, 1, 2] stacked process effects

STILL_EXT = {'.jpg', '.jpeg', '.png', '.bmp', '.webp', '.tiff', '.tif'}
VIDEO_EXT  = {'.mp4', '.mov', '.avi', '.mkv', '.m4v'}

# ── Screen size detection ─────────────────────────────────────────────────────
def _detect_screen():
    try:
        r = subprocess.run(
            ['osascript', '-e',
             'tell application "Finder" to get bounds of window of desktop'],
            capture_output=True, text=True, timeout=2
        )
        parts = [int(x.strip()) for x in r.stdout.strip().split(',')]
        if len(parts) == 4:
            return parts[2], parts[3]
    except Exception:
        pass
    return 1920, 1080

# ── OSC ───────────────────────────────────────────────────────────────────────
_amp_raw  = 0.0
_osc_lock = threading.Lock()

def _on_amp(addr, value):
    global _amp_raw
    with _osc_lock:
        _amp_raw = float(value)

def _run_osc():
    d = dispatcher.Dispatcher()
    d.map('/amplitude', _on_amp)
    osc_server.ThreadingOSCUDPServer(('127.0.0.1', OSC_PORT), d).serve_forever()

threading.Thread(target=_run_osc, daemon=True).start()

# ── Args ──────────────────────────────────────────────────────────────────────
parser = argparse.ArgumentParser(description='Visual effects runner')
parser.add_argument('--media',   required=True,             help='folder of stills/videos')
parser.add_argument('--effects', default=None,              help='comma-separated effect names (default: all)')
parser.add_argument('--min-dur', type=float, default=3.0,  dest='min_dur')
parser.add_argument('--max-dur', type=float, default=60.0, dest='max_dur')
parser.add_argument('--screen',  default=None,              help='output resolution WxH (default: auto-detect)')
args = parser.parse_args()

if args.screen:
    SW, SH = (int(x) for x in args.screen.lower().split('x'))
else:
    SW, SH = _detect_screen()
print(f"  screen: {SW}×{SH}")

# ── Load effects ──────────────────────────────────────────────────────────────
effects_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'effects')
wanted      = set(args.effects.split(',')) if args.effects else None
comp_effects = {}   # TYPE = 'layout'
proc_effects = {}   # TYPE = 'process' (default)

for fname in sorted(os.listdir(effects_dir)):
    if not fname.endswith('.py') or fname.startswith('_'):
        continue
    name = fname[:-3]
    if wanted and name not in wanted:
        continue
    mod  = importlib.import_module(f'effects.{name}')
    kind = getattr(mod, 'TYPE', 'process')
    if kind == 'layout':
        comp_effects[name] = mod
    else:
        proc_effects[name] = mod
    print(f"  loaded [{kind}]: {name}  (media: {', '.join(sorted(mod.MEDIA))})")

if not comp_effects and not proc_effects:
    sys.exit('No effects loaded — check --effects names or add files to effects/.')

# ── Load media ────────────────────────────────────────────────────────────────
def scan_media(folder):
    items = []
    for fname in sorted(os.listdir(folder)):
        ext  = os.path.splitext(fname)[1].lower()
        path = os.path.join(folder, fname)
        if ext in STILL_EXT:
            items.append((path, 'still'))
        elif ext in VIDEO_EXT:
            items.append((path, 'video'))
    return items

media = scan_media(args.media)
if not media:
    sys.exit(f'No media found in {args.media}')
print(f"  found {len(media)} media item(s) in {args.media}")

# ── Helpers ───────────────────────────────────────────────────────────────────
def scale_down(frame):
    ih, iw = frame.shape[:2]
    s = min(MAX_DIM / iw, MAX_DIM / ih, 1.0)
    if s < 1.0:
        return cv2.resize(frame, (int(iw * s), int(ih * s)), interpolation=cv2.INTER_AREA)
    return frame

def fit_frame(frame, w, h):
    fh, fw  = frame.shape[:2]
    scale   = min(w / fw, h / fh)
    nw, nh  = int(fw * scale), int(fh * scale)
    interp  = cv2.INTER_AREA if scale < 1 else cv2.INTER_LINEAR
    resized = cv2.resize(frame, (nw, nh), interpolation=interp)
    canvas  = np.zeros((h, w, 3), dtype=np.uint8)
    canvas[(h-nh)//2:(h-nh)//2+nh, (w-nw)//2:(w-nw)//2+nw] = resized
    return canvas

def call_setup(emod, base_frame, osc_state, context):
    if 'context' in inspect.signature(emod.setup).parameters:
        return emod.setup(base_frame, osc_state, context)
    return emod.setup(base_frame, osc_state)

def call_teardown(emod, state):
    if hasattr(emod, 'teardown'):
        emod.teardown(state)

# ── Scheduler ────────────────────────────────────────────────────────────────
def next_activation():
    """Pick media, optional compositor, and a stack of process effects."""
    path, mtype = random.choice(media)
    duration    = random.uniform(args.min_dur, args.max_dur)

    # Compositor — optional
    comp_pool = [(n, m) for n, m in comp_effects.items() if mtype in m.MEDIA]
    compositor = random.choice(comp_pool) if comp_pool and random.random() < COMP_CHANCE else None

    # Process stack — 0, 1, or 2 effects; never two heavy effects in the same chain
    proc_pool  = [(n, m) for n, m in proc_effects.items() if mtype in m.MEDIA]
    n_proc     = random.choices([0, 1, 2], weights=PROC_WEIGHTS)[0]
    n_proc     = min(n_proc, len(proc_pool))
    processors = []
    remaining  = list(proc_pool)
    for _ in range(n_proc):
        if not remaining:
            break
        name, mod = random.choice(remaining)
        processors.append((name, mod))
        remaining.remove((name, mod))
        if getattr(mod, 'PERF', None) == 'heavy':
            remaining = [(n, m) for n, m in remaining if getattr(m, 'PERF', None) != 'heavy']

    return path, mtype, compositor, processors, duration

# ── Display ───────────────────────────────────────────────────────────────────
cv2.namedWindow('visuals', cv2.WINDOW_NORMAL)
cv2.setWindowProperty('visuals', cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

delay_ms   = int(1000 / FPS)
amp_smooth = 0.0

print(f"\nRunning — Esc/Q to quit | dur {args.min_dur:.0f}–{args.max_dur:.0f}s")

# ── Main loop ─────────────────────────────────────────────────────────────────
while True:
    media_path, media_type, compositor, processors, duration = next_activation()

    comp_name  = compositor[0]  if compositor  else None
    proc_names = [n for n, _ in processors]
    label      = ' + '.join(filter(None, [comp_name] + proc_names)) or 'passthrough'
    print(f"  [{label}]  {os.path.basename(media_path)}  ({duration:.1f}s)")

    # ── Open media ────────────────────────────────────────────────────────────
    cap = None
    if media_type == 'still':
        raw = cv2.imread(media_path)
        if raw is None:
            print(f"  ! could not load {media_path} — skipping")
            continue
        base_frame = scale_down(raw)
    else:
        cap = cv2.VideoCapture(media_path)
        if not cap.isOpened():
            print(f"  ! could not open {media_path} — skipping")
            continue
        total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        vid_fps      = cap.get(cv2.CAP_PROP_FPS) or 30
        # Seek to a random point, keeping at least min_dur seconds of content ahead
        margin       = int(vid_fps * args.min_dur)
        max_start    = max(0, total_frames - margin)
        start_frame  = random.randint(0, max_start)
        cap.set(cv2.CAP_PROP_POS_FRAMES, start_frame)
        ret, first = cap.read()
        if not ret:
            cap.release()
            continue
        base_frame = scale_down(first)
        cap.set(cv2.CAP_PROP_POS_FRAMES, start_frame)

    # ── Setup all active effects ───────────────────────────────────────────────
    osc_state  = {'amp': amp_smooth}
    context    = {'media': media, 'current_path': media_path, 'screen': (SW, SH)}

    comp_state  = call_setup(compositor[1], base_frame, osc_state, context) if compositor else None
    proc_states = [call_setup(m, base_frame, osc_state, context) for _, m in processors]

    # ── Render loop ───────────────────────────────────────────────────────────
    start = time.time()
    while time.time() - start < duration:
        if media_type == 'still':
            raw_frame = base_frame
        else:
            ret, raw_frame = cap.read()
            if not ret:
                cap.set(cv2.CAP_PROP_POS_FRAMES, 0)
                ret, raw_frame = cap.read()
                if not ret:
                    break
            raw_frame = scale_down(raw_frame)

        with _osc_lock:
            target = _amp_raw
        amp_smooth += AMP_SMOOTH * (min(target * AMP_SCALE, 1.0) - amp_smooth)
        osc_state['amp'] = amp_smooth

        # Chain: compositor → proc1 → proc2 → fit → display
        frame = compositor[1].render(raw_frame, osc_state, comp_state) if compositor else raw_frame
        for (_, pmod), pstate in zip(processors, proc_states):
            frame = pmod.render(frame, osc_state, pstate)
        output = fit_frame(frame, SW, SH)

        cv2.imshow('visuals', output)
        key = cv2.waitKey(delay_ms) & 0xFF
        if key in (27, ord('q')):
            if compositor:
                call_teardown(compositor[1], comp_state)
            for (_, pmod), pstate in zip(processors, proc_states):
                call_teardown(pmod, pstate)
            if cap:
                cap.release()
            cv2.destroyAllWindows()
            sys.exit(0)

    if compositor:
        call_teardown(compositor[1], comp_state)
    for (_, pmod), pstate in zip(processors, proc_states):
        call_teardown(pmod, pstate)
    if cap:
        cap.release()

cv2.destroyAllWindows()
