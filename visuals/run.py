"""
Visual effects runner for live guitar performance.

Usage:
    python visuals/run.py --media visuals/stills/
    python visuals/run.py --media visuals/media/ --effects fx_grain,tf_blur_face
    python visuals/run.py --media visuals/media/ --min-dur 5 --max-dur 30

Controls:
    Esc / Q  — quit
"""

import sys
import os
import time
import random
import inspect
import threading
import argparse
import importlib

import numpy as np
import cv2
from pythonosc import dispatcher, osc_server

# effects/ lives next to run.py
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# ── Config ────────────────────────────────────────────────────────────────────
OSC_PORT   = 57200
AMP_SCALE  = 5.0    # maps SC amplitude to 0–1 (tune to your gain stage)
AMP_SMOOTH = 0.12   # lerp factor per frame
MAX_DIM    = 1920   # cap processing resolution
FPS        = 30

STILL_EXT = {'.jpg', '.jpeg', '.png', '.bmp', '.webp', '.tiff', '.tif'}
VIDEO_EXT  = {'.mp4', '.mov', '.avi', '.mkv', '.m4v'}

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
parser.add_argument('--media',   required=True,      help='folder of stills/videos')
parser.add_argument('--effects', default=None,        help='comma-separated effect names (default: all)')
parser.add_argument('--min-dur', type=float, default=3.0,  dest='min_dur', help='min seconds per activation')
parser.add_argument('--max-dur', type=float, default=60.0, dest='max_dur', help='max seconds per activation')
args = parser.parse_args()

# ── Load effects ──────────────────────────────────────────────────────────────
effects_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'effects')
wanted      = set(args.effects.split(',')) if args.effects else None
effects     = {}

for fname in sorted(os.listdir(effects_dir)):
    if not fname.endswith('.py') or fname.startswith('_'):
        continue
    name = fname[:-3]
    if wanted and name not in wanted:
        continue
    mod = importlib.import_module(f'effects.{name}')
    effects[name] = mod
    print(f"  loaded effect: {name}  (media: {', '.join(sorted(mod.MEDIA))})")

if not effects:
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

def call_setup(emod, base_frame, osc_state, context):
    """Call setup() with context only if the effect declares it."""
    if 'context' in inspect.signature(emod.setup).parameters:
        return emod.setup(base_frame, osc_state, context)
    return emod.setup(base_frame, osc_state)

def call_teardown(emod, state):
    if hasattr(emod, 'teardown'):
        emod.teardown(state)

def pick_next(last_media):
    """Pick a random effect and a random compatible media item independently.
    Only constraint: avoid the same media file two activations in a row."""
    effect_list = list(effects.items())
    random.shuffle(effect_list)
    for ename, emod in effect_list:
        compatible = [(p, t) for p, t in media if t in emod.MEDIA]
        if not compatible:
            continue
        pool        = [m for m in compatible if m[0] != last_media] or compatible
        path, mtype = random.choice(pool)
        duration    = random.uniform(args.min_dur, args.max_dur)
        return ename, emod, path, mtype, duration
    sys.exit('No compatible effect+media combinations — check MEDIA declarations in effects.')

# ── Display ───────────────────────────────────────────────────────────────────
cv2.namedWindow('visuals', cv2.WINDOW_NORMAL | cv2.WINDOW_KEEPRATIO)
cv2.setWindowProperty('visuals', cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

delay_ms   = int(1000 / FPS)
amp_smooth = 0.0
last_media = None

print(f"\nRunning — Esc/Q to quit | dur {args.min_dur:.0f}–{args.max_dur:.0f}s")

# ── Main loop ─────────────────────────────────────────────────────────────────
while True:
    ename, emod, media_path, media_type, duration = pick_next(last_media)
    last_media = media_path
    print(f"  [{ename}]  {os.path.basename(media_path)}  ({duration:.1f}s)")

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
        ret, first = cap.read()
        if not ret:
            cap.release()
            continue
        base_frame = scale_down(first)
        cap.set(cv2.CAP_PROP_POS_FRAMES, 0)

    # ── Setup effect ──────────────────────────────────────────────────────────
    osc_state = {'amp': amp_smooth}
    context   = {'media': media, 'current_path': media_path}
    state     = call_setup(emod, base_frame, osc_state, context)

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

        frame = emod.render(raw_frame, osc_state, state)

        cv2.imshow('visuals', frame)
        key = cv2.waitKey(delay_ms) & 0xFF
        if key in (27, ord('q')):
            call_teardown(emod, state)
            if cap:
                cap.release()
            cv2.destroyAllWindows()
            sys.exit(0)

    call_teardown(emod, state)
    if cap:
        cap.release()

cv2.destroyAllWindows()
