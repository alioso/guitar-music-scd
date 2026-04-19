# Visuals

Real-time visual effects for live guitar performance. SuperCollider streams amplitude via OSC; a Python runner picks random effects from a media folder and drives them with the audio signal.

---

## Running

```bash
# All effects, random media from a folder
python visuals/run.py --media visuals/stills/

# Specific effects only
python visuals/run.py --media visuals/media/ --effects fx_grain,tf_blur_face

# Tune timing (seconds per activation)
python visuals/run.py --media visuals/stills/ --min-dur 5 --max-dur 30
```

**Controls:** `Esc` / `Q` to quit. The runner prints each activation to the terminal.

### SuperCollider bridge

Run `visuals/visual-osc.scd` alongside any piece (evaluate Block A after the piece boots). It streams guitar amplitude to Python on OSC port 57200 at 30 fps. Evaluate Block B to stop.

To wire a piece so visuals start automatically, add to its `firstNote` handler:
```supercollider
"cd /path/to/guitar-music-scd && visuals/.venv/bin/python visuals/run.py --media visuals/stills/".unixCmd;
```
And to Block 3:
```supercollider
"pkill -f run.py".unixCmd;
```

### Setup

```bash
cd visuals
uv venv
source .venv/bin/activate.fish
uv pip install -r requirements.txt
```

---

## Media

Drop stills (`.jpg`, `.png`, `.webp`, etc.) or short video clips (`.mp4`, `.mov`, `.avi`) into any folder and point `--media` at it. Stills and videos can be mixed in the same folder — effects declare which types they accept and the scheduler filters automatically.

---

## Amplitude response

Two knobs control how strongly audio drives each effect:

- **`AMP_SCALE`** in `run.py` — global multiplier mapping SC amplitude (typically 0–0.3) to 0–1. Default `5.0`. Lower if effects are always maxed out.
- **`AMP_POWER`** in each effect file — exponent applied after scaling. Default `2.0`. Higher = more headroom; normal playing stays subtle, only true peaks drive hard. `1.0` = linear.

---

## Effect library

### `fx_grain`
**Media:** still + video  
Additive Gaussian film grain. Silence = clean image. Loud playing = heavy grain.  
Tune: `MAX_GRAIN` (noise intensity), `AMP_POWER`.

---

### `tf_blur_face`
**Media:** still  
Detects faces with OpenCV's DNN detector (downloaded once to `visuals/models/`, ~10 MB). Applies a feathered elliptical Gaussian blur to each face. Amplitude drives blur intensity.  
Tune: `_MIN_BLUR`, `_MAX_BLUR`, `_CONFIDENCE` (detection threshold, lower = more detections), `AMP_POWER`.  
*For a hard rectangular blockout version, see `tf_block_face` (not yet implemented).*

---

### `tp_bw`
**Media:** video  
Uses YOLOv8n-seg to segment people per frame. People render in greyscale; background keeps its natural colour with a subtle saturation boost. Amplitude drives the saturation intensity.  
Tune: `_SAT_BASE`, `_SAT_MAX`.  
*Requires `ultralytics` — model downloads automatically on first use (~6 MB).*

---

### `comp_dual`
**Media:** still + video  
Picks two media items and places them side by side. Left/right assignment is randomised each activation. Amplitude drives a subtle grain across both panels.  
Tune: `_MAX_GRAIN`, `_AMP_POWER`.

---

### `comp_super`
**Media:** still + video  
Picks two media items and superimposes them with complementary opacities. The alpha split is randomised each activation (range 0.30–0.70). Amplitude gently drifts the split toward the main frame.  
Tune: `_ALPHA_MIN`, `_ALPHA_MAX`, `_AMP_DRIFT`.

---

## Naming convention

```
{category}_{action}[_{variant}].py
```

| Prefix | Domain |
|--------|--------|
| `fx_`  | General image effect — no detection |
| `tf_`  | Target face — detection + action on face regions |
| `tp_`  | Target person — detection + action on body |
| `to_`  | Target object — YOLO object classes |
| `comp_`| Composition — multi-media layout or blend |
| `col_` | Colour treatment (hue, tint, invert…) |
| `mot_` | Motion — video-only (slow, freeze, reverse…) |

Examples: `fx_vignette`, `tf_block_face`, `tp_ghost`, `col_tint`, `mot_freeze`.

---

## Adding a new effect

Create `visuals/effects/{name}.py` — the runner picks it up automatically.

```python
"""One-line description of what the effect does."""
import cv2
import numpy as np

MEDIA = {'still', 'video'}   # restrict as needed

def setup(frame, osc_state):
    """Called once per activation. Expensive work goes here (detection, model load).
    Return a state dict passed to every render() call."""
    return {}

def render(frame, osc_state, state):
    """Called every frame. Must return a uint8 BGR image.
    Do not modify frame in place."""
    amp = osc_state['amp']   # smoothed, scaled, 0.0–1.0
    return frame
```

**Effects that need a second media item** (like `comp_` effects) declare `context` in `setup()`:

```python
def setup(frame, osc_state, context=None):
    # context['media']        — full list of (path, type) tuples
    # context['current_path'] — the main media item already picked
    ...
```

The runner detects the `context` parameter via `inspect` and passes it automatically. Old effects without it are unaffected.

**Effects that open resources** (e.g. a second `VideoCapture`) define `teardown()`:

```python
def teardown(state):
    if state.get('cap2'):
        state['cap2'].release()
```

Then document the new effect in this file under **Effect library**.

---

## File layout

```
visuals/
  run.py               main runner
  visual-osc.scd       SuperCollider OSC bridge
  requirements.txt     Python dependencies
  VISUALS.md           this file
  effects/
    __init__.py        interface contract (comments only)
    fx_grain.py
    tf_blur_face.py
    tp_bw.py
    comp_dual.py
    comp_super.py
  models/              auto-downloaded model weights (gitignored)
  .venv/               Python virtual environment (gitignored)
```
