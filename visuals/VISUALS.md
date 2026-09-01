# Visuals — developer reference

For the performance guide (commands, media folders, drawings, quick start) see [VIDEO.md](../VIDEO.md).

This file covers the effect API, naming conventions, and how to add new effects.

---

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

# Override screen resolution (default: auto-detected via osascript)
python visuals/run.py --media visuals/stills/ --screen 1280x800
```

Each activation is built from three independent random draws:
1. **Media** — one item from the folder (repeats allowed)
2. **Compositor** (`comp_*`) — picked with `COMP_CHANCE` probability (default 40%), or skipped
3. **Process stack** — 0, 1, or 2 `fx_*`/`tf_*`/`tp_*` effects chained on top (tunable via `PROC_WEIGHTS`)

Chain order: compositor → proc1 → proc2 → fit_frame → display.
The terminal prints the full stack label each activation, e.g. `[comp_dual + fx_grain + tf_blur_face]`.

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

Drop stills (`.jpg`, `.png`, `.webp`, etc.) or video clips (`.mp4`, `.mov`, `.avi`) into any folder and point `--media` at it. Stills and videos can be mixed. Effects declare which types they accept and the scheduler filters automatically.

**Long videos are fine.** OpenCV streams frame-by-frame — a 12-minute film uses the same memory as a 30-second clip. On each activation the runner seeks to a random point in the video, always leaving at least `--min-dur` seconds of content ahead. If the activation duration runs past the end of the file, it loops. Secondary videos in `comp_dual` and `comp_super` also seek randomly (within the first 90% of the file).

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

### `dw_undulate`
**Media:** still (intended for `visuals/drawings/`)  
Sinusoidal `cv2.remap` warp confined to a zone chosen at activation — full image (30%), horizontal band (25%), vertical band (25%), or random rectangle (20%) — feathered at the zone edges. Amplitude drives ripple speed and pixel displacement. Rebuilds its size-dependent caches (meshgrid, zone, mask) if the frame shape changes mid-activation, so it can sit downstream of a compositor.  
Tune: `_SPEED_BASE`/`_SPEED_AMP`, `_STRENGTH_BASE`/`_STRENGTH_AMP`, `_FEATHER`.

---

### `dw_zone`
**Media:** still (intended for `visuals/drawings/`)  
Applies one randomly chosen sub-effect (grain, invert, saturation, distortion, edge emphasis) to a single feathered rectangular zone; the rest of the image is untouched. Sound energy accumulates and, once past a random threshold (and `_HOLD_MIN`), relocates the zone and re-rolls the sub-effect. Also rebuilds its zone/mask if the frame shape changes mid-activation.  
Tune: `_ZONE_MIN`/`_ZONE_MAX`, `_HOLD_MIN`/`_HOLD_MAX`, `_ENERGY_LO`/`_ENERGY_HI`, `AMP_POWER`, `_FEATHER`.

---

### `dw_ink`
**Media:** still (intended for `visuals/drawings/`)  
Detects dark ink lines (pixel value below `_INK_THRESH`) and blooms a coloured glow outward from them; hue drifts slowly over time. Crisp/clean at silence.  
Tune: `_INK_THRESH`, `_GLOW_MAX`, `_HUE_DRIFT`, `AMP_POWER`.

---

### `dw_mirror`
**Media:** still (intended for `visuals/drawings/`) — `TYPE = 'layout'`  
Mirrors one half of the image onto the other for perfect bilateral symmetry. Mode (`fold_left`/`fold_right`/`fold_top`/`fold_bottom`) is randomised each activation. Amplitude adds a subtle grain overlay.  
Tune: `_MAX_GRAIN`, `_AMP_POWER`.

---

### `dw_saturation`
**Media:** still (intended for `visuals/drawings/`)  
Boosts saturation and drifts hue with amplitude — near-natural colour at silence, vivid and hue-shifting at peak.  
Tune: `_SAT_BASE`/`_SAT_MAX`, `_HUE_DRIFT`, `AMP_POWER`.

---

### `dw_scanlines`
**Media:** still (intended for `visuals/drawings/`)  
Darkens every Nth row or column (orientation randomised per activation) for a photocopier/CRT look. Amplitude controls line spacing (denser when louder) and opacity.  
Tune: `_SPACING_MIN`/`_SPACING_MAX`, `_OPACITY_MIN`/`_OPACITY_MAX`, `AMP_POWER`.

---

### `dw_threshold`
**Media:** still (intended for `visuals/drawings/`)  
Pushes toward a high-contrast woodcut/linocut look: gentle posterize (4–5 levels) at silence, tightening to 2–3 levels then adaptive B&W threshold as amplitude rises, blended over the original.  
Tune: `AMP_POWER`.

---

### `tf_blur_face`
**Media:** still — **`PERF = 'heavy'`**  
Detects faces with OpenCV's DNN detector (downloaded once to `visuals/models/`, ~10 MB). Applies a feathered elliptical Gaussian blur to each face. Amplitude drives blur intensity.  
Tune: `_MIN_BLUR`, `_MAX_BLUR`, `_CONFIDENCE` (detection threshold, lower = more detections), `AMP_POWER`.  
*For a hard rectangular blockout version, see `tf_block_face` (not yet implemented).*

---

### `tp_bw`
**Media:** video — **`PERF = 'heavy'`**  
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

TYPE  = 'process'            # 'process' (default) or 'layout' for comp_* effects
MEDIA = {'still', 'video'}   # restrict as needed
# PERF = 'heavy'             # REQUIRED if render() runs ML inference — see rule below

def setup(frame, osc_state):
    """Called once per activation. Expensive work goes here (detection, model load)."""
    return {}

def render(frame, osc_state, state):
    """Called every frame. Must return a uint8 BGR image. Do not modify frame in place."""
    amp = osc_state['amp']   # smoothed, scaled, 0.0–1.0
    return frame
```

### The `PERF = 'heavy'` rule

**Always set `PERF = 'heavy'` if `render()` calls a neural network** — OpenCV DNN, YOLO, MediaPipe, or any per-frame model inference. The scheduler uses this to guarantee two heavy effects never share the same activation chain.

| Type | Cost/frame | Stack freely? | Set `PERF`? |
|---|---|---|---|
| Pure math — grain, blur, colour | 2–5ms | Yes | No |
| ML inference per frame | 40–80ms | No | **Yes** |

Two heavy effects in one chain = ~8fps. This is enforced automatically once the flag is set — no manual coordination needed.

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
    dw_undulate.py
    dw_zone.py
    dw_ink.py
    dw_mirror.py
    dw_saturation.py
    dw_scanlines.py
    dw_threshold.py
    tf_blur_face.py
    tp_bw.py
    comp_dual.py
    comp_super.py
  models/              auto-downloaded model weights (gitignored)
  .venv/               Python virtual environment (gitignored)
```
