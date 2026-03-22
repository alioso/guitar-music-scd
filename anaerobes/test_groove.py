#!/usr/bin/env python3
"""
Minimal groove~/record~/buffer~ proof of concept.

Signal chain:
  adc~ 1  →  record~ test_buf  (writes guitar into 5-second buffer)
  groove~ test_buf 0            (plays buffer back in a loop)
  → dac~

Controls:
  ezdac~        : enable audio
  [START] btn   : arm recording + start groove playback (200ms delay)
  [LOOP 1] msg  : sent at loadbang to set loop mode on both objects
"""

import json, os

def box(id, maxclass, text=None, numinlets=1, numoutlets=1,
        outlettype=None, x=0, y=0, w=None, h=22, extra=None):
    b = {"id": id, "maxclass": maxclass, "numinlets": numinlets, "numoutlets": numoutlets,
         "patching_rect": [x, y, w if w else (len(text)*7+20 if text else 60), h]}
    if outlettype is not None: b["outlettype"] = outlettype
    if text is not None:       b["text"] = text
    if extra:                  b.update(extra)
    return {"box": b}

def newobj(id, text, numinlets=1, numoutlets=1, outlettype=None, x=0, y=0, w=None):
    ot = outlettype if outlettype is not None else (["signal"] * numoutlets)
    return box(id, "newobj", text, numinlets, numoutlets, ot, x, y, w)

def msg(id, text, x=0, y=0, w=None):
    return box(id, "message", text, numinlets=2, numoutlets=1, outlettype=[""], x=x, y=y,
               w=w or (len(text)*7+14))

def comment(id, text, x=0, y=0, w=None):
    return box(id, "comment", text, numinlets=1, numoutlets=0, outlettype=[],
               x=x, y=y, w=w or (len(text)*7+10))

def btn(id, x=0, y=0):
    return box(id, "button", numinlets=1, numoutlets=1, outlettype=["bang"],
               x=x, y=y, w=24, h=24, extra={"parameter_enable": 0})

def line(src, src_out, dst, dst_in):
    return {"patchline": {"source": [src, src_out], "destination": [dst, dst_in]}}

# ============================================================
boxes = []
lines = []

# --- AUDIO OBJECTS ---
boxes.append(newobj("adc",    "adc~ 1",         1, 1, ["signal"],          40, 40))
boxes.append(newobj("buf",    "buffer~ test_buf 5000", 1, 1, ["bang"],     40, 80,  140))
boxes.append(newobj("rec",    "record~ test_buf",2, 1, ["bang"],            40, 120, 120))
boxes.append(newobj("grv",    "groove~ test_buf 0", 2, 2, ["signal","signal"], 40, 175, 130))
boxes.append(newobj("ezdac",  "ezdac~",          2, 0, [],                 280, 40,  50))
boxes.append(newobj("dac",    "dac~",            2, 0, [],                 40,  240, 40))

# --- CONTROLS ---
boxes.append(btn(    "start_btn",                40,  300))
boxes.append(comment("lbl_start", "START",       70,  304))
boxes.append(newobj("start_delay", "delay 200",  2, 1, ["bang"],           40,  335))

# "loop 1" messages — sent at loadbang
boxes.append(newobj("lb",     "loadbang",        1, 1, ["bang"],           220, 80))
boxes.append(msg(   "rec_loop", "loop 1",        220, 120, 60))
boxes.append(msg(   "grv_loop", "loop 1",        220, 160, 60))

# "1" messages — sent 200ms after START
boxes.append(msg(   "rec_start", "1",            130, 370, 20))  # record~ gate
boxes.append(msg(   "grv_start", "1",            165, 370, 20))  # groove~ start

# Status labels
boxes.append(comment("lbl_info",
    "Open patch → loadbang sets loop mode. Press START → waits 200ms → starts recording + playback.",
    40, 430, 600))
boxes.append(comment("lbl_info2",
    "You will hear the looping guitar after ~5 seconds (buffer fills). Pitch/timing may drift slightly — that is normal.",
    40, 455, 600))

# --- WIRING ---
# loadbang → loop mode
lines.append(line("lb",         0, "rec_loop",    0))
lines.append(line("lb",         0, "grv_loop",    0))
lines.append(line("rec_loop",   0, "rec",         0))   # "loop 1" → record~ inlet 0
lines.append(line("grv_loop",   0, "grv",         0))   # "loop 1" → groove~ inlet 0

# START button chain
lines.append(line("start_btn",  0, "start_delay", 0))
lines.append(line("start_delay",0, "rec_start",   0))
lines.append(line("start_delay",0, "grv_start",   0))
lines.append(line("rec_start",  0, "rec",         1))   # "1" → record~ gate (inlet 1)
lines.append(line("grv_start",  0, "grv",         0))   # "1" → groove~ start (inlet 0)

# ADC → record~
lines.append(line("adc",        0, "rec",         0))

# groove~ → dac~
lines.append(line("grv",        0, "dac",         0))   # L
lines.append(line("grv",        0, "dac",         1))   # R (mono out to both channels)

# ============================================================
patch = {
    "patcher": {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 8, "architecture": "x64", "modernui": 1},
        "classnamespace": "dsp.toplevel",
        "rect": [0, 0, 800, 520],
        "gridsize": [15.0, 15.0],
        "boxes": boxes,
        "lines": lines,
        "dependency_cache": [],
        "autosave": 0
    }
}

out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "test_groove.maxpat")
with open(out, "w") as f:
    json.dump(patch, f, indent="\t")
print(f"Written: {out}")
print(f"  Boxes: {len(boxes)}, Lines: {len(lines)}")
