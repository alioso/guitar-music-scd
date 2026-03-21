# guitar-music-msp — AI Context & Instructions

## Project Overview

This repository contains **four Max/MSP patches for live solo guitar performance**, each implementing a distinct compositional concept. The project uses a **Python-first build workflow**: the `.maxpat` files are **generated build artifacts** — the authoritative source of truth is the Python build scripts.

**Never edit `.maxpat` files directly.** Always modify `build_patch.py`, then regenerate.

```
guitar-music-msp/
├── check_patches.py          ← integrity checker (run after every build)
├── anaerobes/build_patch.py  → anaerobes/anaerobes.maxpat
├── chimera/build_patch.py    → chimera/chimera.maxpat
├── fan-fiction/build_patch.py → fan-fiction/fan-fiction.maxpat
└── lapopie/build_patch.py   → lapopie/lapopie.maxpat
```

## Workflow

```bash
# Build a patch
python3 <name>/build_patch.py

# Validate all patches
python3 check_patches.py
```

`check_patches.py` exits with code 1 on errors. Always run it after any build change.

---

## .maxpat File Format

A `.maxpat` is a **JSON file** with this top-level structure:

```json
{
  "patcher": {
    "fileversion": 1,
    "appversion": { "major": 9, "minor": 0, "revision": 8, "architecture": "x64", "modernui": 1 },
    "classnamespace": "dsp.toplevel",
    "rect": [0, 0, 1800, 1000],
    "gridsize": [15.0, 15.0],
    "boxes": [ ...box objects... ],
    "lines": [ ...patchline objects... ],
    "dependency_cache": [ ...external abstractions... ],
    "autosave": 0
  }
}
```

### Box Schema

```json
{
  "box": {
    "id": "unique_string_id",
    "maxclass": "newobj",
    "numinlets": 1,
    "numoutlets": 1,
    "patching_rect": [x, y, width, height],
    "outlettype": ["signal"],
    "text": "object~ arg1 arg2"
  }
}
```

**`maxclass` values:**

| maxclass | Purpose | outlettype |
|----------|---------|------------|
| `"newobj"` | Any Max DSP/control object; `text` = name + args | `["signal"]` (DSP) or `[""]` (control) |
| `"comment"` | Visual label only — no function | `[]` |
| `"message"` | Message box | `[""]` |
| `"button"` | Bang button | `["bang"]` |
| `"toggle"` | On/off toggle | `["int"]` |
| `"flonum"` | Floating-point number | `["", "bang"]` |
| `"number"` | Integer number | `["int", "bang"]` |

### Patchline Schema

```json
{
  "patchline": {
    "source": ["src_box_id", outlet_index],
    "destination": ["dst_box_id", inlet_index],
    "order": 0
  }
}
```

`"order"` is optional; used when multiple wires arrive at the same inlet (controls execution order).

### `dependency_cache`

Lists external Max abstractions. The `pan2` abstraction appears in all patches:

```json
{
  "name": "pan2.maxpat",
  "bootpath": "~/Library/Application Support/Cycling '74/Max 9/Examples/spatialization/panning/lib",
  "type": "JSON",
  "implicit": 1
}
```

---

## Build Script Conventions

All `build_patch.py` files share an **identical helper function set** and build pattern.

### Helper Functions

```python
def box(id, maxclass, text=None, numinlets=1, numoutlets=1,
        outlettype=None, x=0, y=0, w=None, h=22, extra=None):
    """Creates a {'box': {...}} dict."""

def newobj(id, text, numinlets=1, numoutlets=1, outlettype=None, x=0, y=0, w=None, extra=None):
    """maxclass='newobj'; defaults outlettype to ['signal']*numoutlets."""

def flonum(id, x=0, y=0, w=50):
    """Floating-point display (numoutlets=2: value + bang)."""

def intnum(id, x=0, y=0, w=50):
    """Integer display (numoutlets=2: int + bang)."""

def msg(id, text, x=0, y=0, w=None):
    """Message box. Width auto-computed: len(text)*7+14."""

def button(id, x=0, y=0):
    """Bang button (24×24, outlettype=['bang'])."""

def comment(id, text, x=0, y=0, w=None):
    """Visual label. Width auto-computed: len(text)*7+10."""

def toggle_box(id, x=0, y=0):
    """On/off toggle (24×24, outlettype=['int'])."""

def line(src, src_outlet, dst, dst_inlet, order=None):
    """Creates a {'patchline': {...}} dict."""
```

### Build Pattern

```python
boxes = []
lines = []

# ... append boxes and lines ...

# Validate: drop lines with missing box IDs (always include this)
box_ids = set(b["box"]["id"] for b in boxes)
valid_lines = []
dropped = 0
for l in lines:
    src = l["patchline"]["source"][0]
    dst = l["patchline"]["destination"][0]
    if src in box_ids and dst in box_ids:
        valid_lines.append(l)
    else:
        missing = src if src not in box_ids else dst
        print(f"WARNING: Dropping line {src} -> {dst} (missing: {missing})")
        dropped += 1
lines = valid_lines

# Assemble and write
patch = {"patcher": {..., "boxes": boxes, "lines": lines, ...}}
output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "name.maxpat")
with open(output_path, "w") as f:
    json.dump(patch, f, indent="\t")
```

---

## Universal Architectural Patterns

Every patch implements these invariants — `check_patches.py` validates them all.

### Init Chain

```
loadbang → delay 100–500 → msg("startwindow") → dac~
```

### Timer Architecture (`metro 50` ms tick)

```
start_btn → msg("1") ─┐
                       └→ metro("metro 50") → counter → *~ 50 → / 1000. → seconds_float
reset_btn → msg("0") ─→ counter (inlet 3 = reset)
```

The `counter` object has 5 inlets: inlet 0 = bang (count), inlet 3 = reset.

### Output Chain

```
wet signals → +~ tree → *~ <gain> → clip~ -1. 1. → dac~ inlet 0 (L)
                                                   → dac~ inlet 1 (R)
                                  → meter~ (L+R monitoring)
```

Both `dac~` inlets must be connected. `clip~` before `dac~` is mandatory for safety.

### ezdac~ + dac~ Coexistence

All patches include both:
- `ezdac~` — user-clickable audio toggle in the UI
- `dac~` — receives `startwindow` from init chain for programmatic DSP start

---

## Critical Max Constraints

### `expr~` is NOT available

The signal-rate `expr~` object is not present on this install. Replace any `expr~ <formula>` with equivalent `*~` / `+~` / `-~` chains.

```python
# WRONG:
newobj("x", "expr~ 1. + $v1 * 3.")

# CORRECT:
newobj("x_scale", "*~ 3.")
newobj("x_add", "+~ 1.")
```

### `expr` does NOT support `clip()`

```python
# WRONG — will fail silently in Max:
newobj("x", "expr clip($f1, 0., 1.)")

# CORRECT — always use a separate clip object:
newobj("x_expr", "expr $f1 * $f2")
newobj("x_clip", "clip 0. 1.", 3, 1)
line("x_expr", 0, "x_clip", 0)
```

### One-Shot Time Events

Use `change` to fire only once at a threshold crossing:

```python
# seconds_float → > threshold → change → event_message
newobj("cap_open_cmp", "> 30.", 1, 1, [""])
newobj("cap_open_once", "change", 1, 1, [""])
line("seconds", 0, "cap_open_cmp", 0)
line("cap_open_cmp", 0, "cap_open_once", 0)
```

### Signal vs Control Rate

| Type | Object suffix | outlettype |
|------|--------------|------------|
| Audio (DSP) | `~` (e.g. `*~`, `delay~`) | `["signal"]` |
| Control | no `~` (e.g. `*`, `delay`) | `[""]` / `["int"]` |
| Signal→Control | `snapshot~ 10` | `[""]` |
| Control→Signal | `sig~ 0.` | `["signal"]` |

---

## Naming Conventions

| Pattern | Example |
|---------|---------|
| `lbl_<section>` | `lbl_input`, `lbl_timer` |
| `msg_<purpose>` | `msg_start`, `msg_startwindow` |
| `<role>_<N>` (1-indexed voices) | `tapout_1`, `freqshift_2`, `pan_3` |
| `<stage>_<suffix>` | `evo_sub`, `evo_div`, `evo_clip` |
| `cap_<event>_<once\|cmp\|msg>` | `cap_open_cmp`, `cap_close_once` |

Section headers in the patch UI use comment boxes:
```python
boxes.append(comment("lbl_input", "=== INPUT ===", x, y))
```

Box IDs checked by `check_patches.py` **must be exact** (see checker source for full list). Key IDs across all patches:
- `"dac"`, `"adc"`, `"loadbang"`, `"ezdac"`, `"ms_sec"` or `"ms_to_sec"`

---

## The Four Patches

### `anaerobes` — Risset Guitar Quartet (8 min)
**Concept:** 4 delay+freqshift voices creating a quintet-echo illusion, then diverging into a Risset-style psychoacoustic arch.  
**Input:** `adc~ 1` (mono guitar)  
**Voices:** 4 voices via `tapin~ 30000` → `tapout~` → `freqshift~` → `*~` (vol) → `pan2`  
**Key IDs:** `tapin`, `tapout_1..4`, `freqshift_1..4`, `vol_mult_1..4`, `pan_1..4`, `evo_clip`, `onset_clip`

### `chimera` — Ambient Guitar (12 min)
**Concept:** Two permanent layers — prime-length phasing motive delays (7.3s, 19.1s, 41.7s) + slow `groove~` voices fed during sustained swells.  
**Input:** `adc~ 1`  
**Swell detection:** `rms~ 2205` (fast) + `rms~ 44100` + `lores~` (slow) → texture score  
**Pitch tracking:** `yin~ 2048 0.9` → confidence gate → quantize → `line 5000` (5s glide)  
**Harmonic presets** (4 presets, time-scheduled): `[0,7,12,19]`, `[0,5,12,17]`, `[0,7,14,21]`, `[0,5,10,17]`  
**Key IDs:** `tapin`, `yin`, `groove_1..4`, `pshift_1..4`, `ms_sec`, `rms_fast`, `rms_slow_raw`

### `fan-fiction` — Steve Reich Phase Piece (~10 min, BPM 90)
**Concept:** 8-bar phrase captured at start, looped by 4 `groove~` voices at slightly different rates (Reich phasing).  
**Timing:** warmup 2 bars → capture 8 bars → phase diverges → fade at 9:30  
**Phase rates:** G1=1.0 (locked), G2/G3/G4 each with independent LFO depth/period  
**Note bank system:** `yin~` → confidence gate → `ftom` → `change` → 5-slot note banks → `pitchshift~`  
**Key IDs:** `buf_phrase`, `rec_phrase`, `yin`, `conf_gate`, `ms_sec`, `gr_1..4`, `pshift_1..4`, `init_bank_0..4`

### `lapopie` — (unspecified duration)
**Concept:** Looping-based texture with `groove~` + `record~`, `yin~` for pitch tracking, `coll` for data storage.  
**Key IDs:** `yin`, `record`, `ms_to_sec`, metro/counter objects, `pan2` objects, `coll` objects

---

## When Adding a New Patch

1. Create `<name>/build_patch.py` copying the helper function set and build pattern verbatim
2. Add patch-specific checker in `check_patches.py` (follow the `_check_<name>()` pattern)
3. Add the patch path to the `PATCHES` list in `check_patches.py`
4. Build: `python3 <name>/build_patch.py`
5. Validate: `python3 check_patches.py`

## When Modifying an Existing Patch

1. Edit `<name>/build_patch.py` only
2. Rebuild: `python3 <name>/build_patch.py`
3. Validate: `python3 check_patches.py`
4. If `check_patches.py` reports new box ID mismatches, update both the build script and the checker together

## Common Pitfalls

- **Forgetting `clip~` before `dac~`** — checker will flag it; never skip this
- **Using `expr clip(...)` — doesn't work in Max**; use a separate `clip` object
- **Timer chain discontinuity** — `metro` → `counter` → `* 50` → `/ 1000.` must be complete; checker verifies connectivity
- **Orphaned patchlines** — the build script's validation loop will warn and drop them, but fix the root cause
- **ID collisions** — box IDs must be unique within a patch; checker detects duplicates
- **Outlet/inlet index off by one** — Max uses 0-based outlet numbering; `counter` outlet 0 = count value
