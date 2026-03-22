#!/usr/bin/env python3
"""Automatic groove~/record~/buffer~ test. No buttons, no guitar needed.
Open patch, click ezdac~, wait 3 seconds -> should hear looping 440Hz tone.
Silence = groove~/record~/buffer~ broken on this install."""
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

def line(src, src_out, dst, dst_in):
    return {"patchline": {"source": [src, src_out], "destination": [dst, dst_in]}}

boxes = []
lines = []

boxes.append(newobj("tone",    "cycle~ 440",         1, 1, ["signal"],          40,  40))
boxes.append(newobj("buf",     "buffer~ tb 3000",    1, 1, ["bang"],            40,  80, 120))
boxes.append(newobj("rec",     "record~ tb",         2, 1, ["bang"],            40, 120, 100))
boxes.append(newobj("grv",     "groove~ tb 1 @loop 1", 1, 2, ["signal","signal"], 40, 165, 130))
boxes.append(newobj("rate",    "sig~ 1.",               1, 1, ["signal"],          190, 165,  55))
boxes.append(newobj("ezdac",   "ezdac~",              2, 0, [],                280,  40,  50))
boxes.append(newobj("dac",     "dac~",                2, 0, [],                 40, 230,  40))

boxes.append(newobj("lb",      "loadbang",            1, 1, ["bang"],          300,  80))
boxes.append(newobj("lb_sw",   "delay 100",           2, 1, ["bang"],          300, 110))
boxes.append(msg(   "msg_sw",  "startwindow",                                  300, 145))
boxes.append(newobj("lb_rec",  "delay 200",           2, 1, ["bang"],          300, 185))
boxes.append(newobj("lb_grv",  "delay 3100",          2, 1, ["bang"],          300, 225))
boxes.append(msg(   "rec_loop","loop 1",                                        300, 265, 55))
boxes.append(msg(   "rec_on",  "1",                                             370, 265, 30))
boxes.append(msg(   "grv_loop","loop 1",                                        300, 305, 55))  # explicit, in case @loop 1 attr is ignored
boxes.append(msg(   "grv_on",  "startloop",                                     370, 305, 70))
boxes.append(comment("lbl", "Click ezdac~ then wait 3s -- 440Hz tone should loop automatically",
                     40, 360, 520))

lines.append(line("lb",      0, "lb_sw",    0))
lines.append(line("lb_sw",   0, "msg_sw",   0))
lines.append(line("msg_sw",  0, "dac",      0))
lines.append(line("lb",      0, "lb_rec",   0))
lines.append(line("lb",      0, "lb_grv",   0))
lines.append(line("lb_rec",  0, "rec_loop", 0))
lines.append(line("lb_rec",  0, "rec_on",   0))
lines.append(line("rec_loop",0, "rec",      0))
lines.append(line("rec_on",  0, "rec",      0))
lines.append(line("lb_grv",  0, "grv_loop", 0))
lines.append(line("lb_grv",  0, "grv_on",   0))
lines.append(line("grv_loop",0, "grv",      0))
lines.append(line("grv_on",  0, "grv",      0))
lines.append(line("tone",    0, "rec",      0))
lines.append(line("rate",    0, "grv",      0))
lines.append(line("grv",     0, "dac",      0))
lines.append(line("grv",     0, "dac",      1))

patch = {
    "patcher": {
        "fileversion": 1,
        "appversion": {"major": 9, "minor": 0, "revision": 8, "architecture": "x64", "modernui": 1},
        "classnamespace": "dsp.toplevel",
        "rect": [0, 0, 700, 420],
        "gridsize": [15.0, 15.0],
        "boxes": boxes, "lines": lines,
        "dependency_cache": [], "autosave": 0
    }
}

out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "test_groove.maxpat")
with open(out, "w") as f:
    json.dump(patch, f, indent="\t")
print("Written: " + out)
print("  " + str(len(boxes)) + " boxes, " + str(len(lines)) + " lines")
