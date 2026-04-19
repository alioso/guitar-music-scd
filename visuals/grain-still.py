"""
grain-still.py
Still image with film grain driven by live guitar amplitude via OSC.

SuperCollider → OSC port 57200 → this script → fullscreen projection

Run:
    python grain-still.py path/to/image.jpg

Controls:
    Esc / Q  — quit
    +  /  -  — increase / decrease grain sensitivity at runtime
"""

import sys
import threading
import argparse
import numpy as np
import cv2
from pythonosc import dispatcher, osc_server

# ── Config ────────────────────────────────────────────────────────────────────
OSC_PORT   = 57200     # must match visual-osc.scd
MAX_GRAIN  = 55        # noise sigma (0-255) at full amplitude — tune to taste
AMP_SCALE  = 5.0       # multiply SC amplitude to fill 0–1 range (tune to your gain)
AMP_SMOOTH = 0.12      # lerp factor per frame — lower = slower, dreamier response
FPS        = 30
MAX_DIM    = 1920      # cap image processing size; cv2 fullscreen scales display

# ── OSC receiver (background thread) ─────────────────────────────────────────
_amp  = 0.0
_lock = threading.Lock()

def _on_amp(addr, value):
    global _amp
    with _lock:
        _amp = float(value)

def _run_osc():
    d = dispatcher.Dispatcher()
    d.map("/amplitude", _on_amp)
    osc_server.ThreadingOSCUDPServer(("127.0.0.1", OSC_PORT), d).serve_forever()

threading.Thread(target=_run_osc, daemon=True).start()

# ── Args ──────────────────────────────────────────────────────────────────────
parser = argparse.ArgumentParser()
parser.add_argument("image", help="path to still image (jpg, png, etc.)")
args = parser.parse_args()

# ── Image — load, cap at MAX_DIM for performance ──────────────────────────────
raw = cv2.imread(args.image)
if raw is None:
    sys.exit(f"Cannot load image: {args.image}")

ih, iw = raw.shape[:2]
scale  = min(MAX_DIM / iw, MAX_DIM / ih, 1.0)
if scale < 1.0:
    raw = cv2.resize(raw, (int(iw * scale), int(ih * scale)), interpolation=cv2.INTER_AREA)

img = raw.astype(np.float32)   # keep BGR — cv2 native

# ── Display ───────────────────────────────────────────────────────────────────
cv2.namedWindow("grain-still", cv2.WINDOW_NORMAL | cv2.WINDOW_KEEPRATIO)
cv2.setWindowProperty("grain-still", cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

rng        = np.random.default_rng()
amp_smooth = 0.0
max_grain  = float(MAX_GRAIN)
delay_ms   = int(1000 / FPS)

print(f"grain-still — listening on OSC port {OSC_PORT}")
print("Esc/Q to quit  |  +/- to adjust grain sensitivity")

while True:
    key = cv2.waitKey(delay_ms) & 0xFF
    if key in (27, ord('q')):
        break
    elif key in (ord('+'), ord('=')):
        max_grain = min(max_grain + 5, 120)
        print(f"  MAX_GRAIN → {max_grain:.0f}")
    elif key == ord('-'):
        max_grain = max(max_grain - 5, 5)
        print(f"  MAX_GRAIN → {max_grain:.0f}")

    with _lock:
        target = _amp
    amp_smooth += AMP_SMOOTH * (min(target * AMP_SCALE, 1.0) - amp_smooth)

    sigma = amp_smooth * max_grain
    noise = rng.standard_normal(img.shape, dtype=np.float32) * sigma
    frame = np.clip(img + noise, 0, 255).astype(np.uint8)

    cv2.imshow("grain-still", frame)

cv2.destroyAllWindows()
