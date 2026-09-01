# Video

Real-time visuals for live performance. SuperCollider streams guitar amplitude via OSC; Python picks media and effects and drives them with the audio signal.

## Quick start

```bash
# 1. Install dependencies (once)
cd visuals
uv venv
source .venv/bin/activate.fish
uv pip install -r requirements.txt

# 2. Run with stills
python visuals/run.py --media visuals/stills/

# 3. Run with drawings (zoom animator)
python visuals/run.py --media visuals/drawings/

# 4. Run with mixed media (stills + video)
python visuals/run.py --media visuals/media/

# 5. Limit to specific effects
python visuals/run.py --media visuals/stills/ --effects fx_grain,tf_blur_face

# 6. Tune activation timing (seconds)
python visuals/run.py --media visuals/stills/ --min-dur 5 --max-dur 30

# 7. Override screen resolution (default: auto-detected)
python visuals/run.py --media visuals/stills/ --screen 1280x800
```

Controls: `Esc` or `Q` to quit. Each activation prints its effect stack to the terminal.

---

## SuperCollider bridge

Run `visuals/visual-osc.scd` alongside any piece. It streams guitar amplitude to Python on OSC port 57200 at 30 fps.

- **Block A** — evaluate after the piece boots to start streaming
- **Block B** — evaluate to stop streaming

### Auto-launch from a piece

To start visuals automatically when the piece starts, add to its `firstNote` handler:

```supercollider
"cd /path/to/guitar-music-scd && visuals/.venv/bin/python visuals/run.py --media visuals/stills/".unixCmd;
```

And to its stop block:

```supercollider
"pkill -f run.py".unixCmd;
```

---

## Media folders

Three folders ship with the project. Point `--media` at any of them (or your own).

| Folder | Contents | Best for |
|---|---|---|
| `visuals/stills/` | Static images (`.jpg`, `.png`, `.webp`) | Clean, controlled look; any effect works |
| `visuals/media/` | Mixed stills + video clips | Full variety; compositional and motion effects |
| `visuals/drawings/` | Scanned drawings or sketches | Use with `dw_zoom` — zooming microregions of the image |

Drop new files into any folder and they are picked up on the next run — no config changes needed. Stills and videos can be mixed in the same folder; effects declare which types they accept and the scheduler filters automatically.

**Long videos are fine.** OpenCV streams frame-by-frame — a 12-minute film uses the same memory as a 30-second clip. Each activation seeks to a random point in the video, always leaving at least `--min-dur` seconds of content ahead. If the activation runs past the end of the file, it loops.

---

## Drawings

The `visuals/drawings/` folder is specifically designed for use with the `dw_*` effect family — see [Effect library](#effect-library) below for `dw_undulate`, `dw_zone`, `dw_ink`, `dw_mirror`, `dw_saturation`, `dw_scanlines`, and `dw_threshold`.

**What to put here:** any flat scanned or photographed image works — sketches, diagrams, textures, handwriting. These effects reward images with local detail: dense cross-hatching, fine lines, watercolour washes.

```bash
# Run with drawings only, all dw_ effects
python visuals/run.py --media visuals/drawings/ --effects dw_undulate,dw_zone,dw_ink,dw_mirror,dw_saturation,dw_scanlines,dw_threshold
```

---

## How activations work

Each activation draws independently from three pools:

1. **Media** — one item from `--media` folder (repeats allowed)
2. **Compositor** (`comp_*`) — picked with `COMP_CHANCE` probability (default 40%), or skipped
3. **Process stack** — 0, 1, or 2 `fx_*` / `tf_*` / `tp_*` / `dw_*` effects chained on top

Chain order: compositor → proc1 → proc2 → fit_frame → display.

The terminal prints the full stack label each activation, e.g. `[comp_dual + fx_grain + tf_blur_face]`.

---

## Effect library

### `fx_grain`
**Media:** still + video

Additive Gaussian film grain. Silence = clean image. Loud playing = heavy grain. Tune `MAX_GRAIN` (noise intensity) and `AMP_POWER` in the effect file.

---

### `dw_undulate`
**Media:** still (intended for drawings)

Sinusoidal warp applied to a zone (full image / horizontal band / vertical band / rectangle, feathered at edges). Amplitude drives ripple speed and displacement strength.

---

### `dw_zone`
**Media:** still (intended for drawings)

Applies one sub-effect (grain, invert, saturation boost, distortion, or edge emphasis) to a single feathered rectangular zone while the rest of the image stays untouched. Sound energy drives when the zone relocates and re-rolls its sub-effect.

---

### `dw_ink`
**Media:** still (intended for drawings)

Detects dark ink lines and blooms a coloured glow around them, hue drifting slowly. Crisp and clean at silence; glows harder as you play.

---

### `dw_mirror`
**Media:** still (intended for drawings) — layout effect

Mirrors one half of the image onto the other (fold left/right/top/bottom, randomised per activation), producing bilateral symmetry. Amplitude adds a subtle grain overlay.

---

### `dw_saturation`
**Media:** still (intended for drawings)

Boosts colour saturation and drifts hue with amplitude. Near-natural at silence; vivid and hue-shifting at peak.

---

### `dw_scanlines`
**Media:** still (intended for drawings)

Burns horizontal or vertical lines into the image (photocopier / CRT look), orientation randomised per activation. Amplitude controls line density and darkness.

---

### `dw_threshold`
**Media:** still (intended for drawings)

Pushes the image toward a high-contrast woodcut/linocut look — gentle posterize at silence, tightening toward adaptive B&W threshold as amplitude rises. Blended over the original so colour bleeds through at moderate levels.

---

### `tf_blur_face`
**Media:** still — `PERF = 'heavy'`

Detects faces with OpenCV's DNN detector (model downloaded once to `visuals/models/`, ~10 MB). Applies a feathered elliptical Gaussian blur to each face. Amplitude drives blur intensity. Tune `_MIN_BLUR`, `_MAX_BLUR`, `_CONFIDENCE`.

---

### `tp_bw`
**Media:** video — `PERF = 'heavy'`

Segments people per frame using YOLOv8n-seg. People render in greyscale; background keeps its colour with a saturation boost driven by amplitude. Tune `_SAT_BASE`, `_SAT_MAX`. Requires `ultralytics` — model downloads automatically on first use (~6 MB).

---

### `comp_dual`
**Media:** still + video

Picks two media items and places them side by side. Left/right assignment is randomised each activation. Amplitude drives subtle grain across both panels.

---

### `comp_super`
**Media:** still + video

Picks two media items and superimposes them with complementary opacities. Alpha split is randomised each activation (0.30–0.70). Amplitude gently drifts the split toward the main frame.

---

## Amplitude response

Two knobs control how strongly audio drives each effect:

- **`AMP_SCALE`** in `run.py` — global multiplier mapping SC amplitude (typically 0–0.3) to 0–1. Default `5.0`. Lower if effects are always maxed out.
- **`AMP_POWER`** in each effect file — exponent applied after scaling. Default `2.0`. Higher = more headroom; normal playing stays subtle, loud peaks drive hard. `1.0` = linear.

---

## File layout

```
visuals/
  run.py               main runner
  visual-osc.scd       SuperCollider OSC bridge
  requirements.txt     Python dependencies
  VIDEO.md             this file (performance guide)
  VISUALS.md           developer reference (adding effects, effect API)
  effects/
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
  drawings/            images for dw_zoom
  stills/              static images for general effects
  media/               mixed stills + video clips
  models/              auto-downloaded model weights (gitignored)
  .venv/               Python virtual environment (gitignored)
```
