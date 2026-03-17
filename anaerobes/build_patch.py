#!/usr/bin/env python3
"""
Build the Risset Guitar Quartet patch for Max/MSP 9.
8-minute live piece: 4 partner guitars + dry input.

Phase 1 (0:00-1:00): Quintet echo - short delays, sounds like 5 real guitarists
Phase 2 (1:00-8:00): Risset evolution - delays diverge, volumes evolve, psychoacoustic effect

IMPORTANT: Max's expr does NOT support clip(). We use separate clip objects.
"""

import json
import os

# ============================================================
# HELPERS
# ============================================================

def box(id, maxclass, text=None, numinlets=1, numoutlets=1,
        outlettype=None, x=0, y=0, w=None, h=22, extra=None):
    b = {
        "id": id,
        "maxclass": maxclass,
        "numinlets": numinlets,
        "numoutlets": numoutlets,
        "patching_rect": [x, y, w if w else (len(text)*7+20 if text else 60), h],
    }
    if outlettype is not None:
        b["outlettype"] = outlettype
    if text is not None:
        b["text"] = text
    if extra:
        b.update(extra)
    return {"box": b}

def newobj(id, text, numinlets=1, numoutlets=1, outlettype=None, x=0, y=0, w=None, extra=None):
    ot = outlettype if outlettype else (["signal"] if numoutlets == 1 else ["signal"]*numoutlets)
    return box(id, "newobj", text, numinlets, numoutlets, ot, x, y, w, extra=extra)

def flonum(id, x=0, y=0, w=50):
    return box(id, "flonum", numinlets=1, numoutlets=2,
               outlettype=["", "bang"], x=x, y=y, w=w,
               extra={"format": 6, "parameter_enable": 0})

def msg(id, text, x=0, y=0, w=None):
    return box(id, "message", text, numinlets=2, numoutlets=1,
               outlettype=[""], x=x, y=y, w=w)

def button(id, x=0, y=0):
    return box(id, "button", numinlets=1, numoutlets=1,
               outlettype=["bang"], x=x, y=y, w=24, h=24,
               extra={"parameter_enable": 0})

def comment(id, text, x=0, y=0, w=None):
    return box(id, "comment", text, numinlets=1, numoutlets=0,
               outlettype=[], x=x, y=y, w=w or (len(text)*7+10))

def toggle_box(id, x=0, y=0):
    return box(id, "toggle", numinlets=1, numoutlets=1,
               outlettype=["int"], x=x, y=y, w=24, h=24,
               extra={"parameter_enable": 0})

def line(src, src_outlet, dst, dst_inlet, order=None):
    d = {"destination": [dst, dst_inlet], "source": [src, src_outlet]}
    if order is not None:
        d["order"] = order
    return {"patchline": d}


# ============================================================
# BUILD PATCH
# ============================================================

boxes = []
lines = []

COL_INPUT     = 50
COL_TIMER     = 250
COL_PHASE     = 500
COL_VOICE     = 750
COL_MIX       = 1350

ROW_TOP       = 40

# ============================================================
# SECTION 1: INPUT + EZDAC
# ============================================================

boxes.append(comment("lbl_input", "=== INPUT ===", COL_INPUT, ROW_TOP-20, 120))

# ezdac~ toggle for audio on/off
boxes.append(newobj("ezdac", "ezdac~", 2, 0, [],
                     COL_INPUT+150, ROW_TOP, 50))
boxes.append(comment("lbl_ezdac", "<-- click to enable audio", COL_INPUT+210, ROW_TOP+4, 170))

boxes.append(newobj("adc", "adc~ 1", 1, 1, ["signal"],
                     COL_INPUT, ROW_TOP+40))

# Dry signal path
boxes.append(newobj("dry_gain", "*~ 0.85", 2, 1, ["signal"],
                     COL_INPUT, ROW_TOP+80))
boxes.append(comment("lbl_dry", "dry guitar (center)", COL_INPUT+80, ROW_TOP+80, 140))

# Delay buffer - 30 seconds
boxes.append(newobj("tapin", "tapin~ 30000", 1, 1, ["tapconnect"],
                     COL_INPUT, ROW_TOP+120))

# Input connections
lines.append(line("adc", 0, "dry_gain", 0, 0))
lines.append(line("adc", 0, "tapin", 0, 1))

# ============================================================
# SECTION 2: TIMER & TIMELINE
# ============================================================

boxes.append(comment("lbl_timer", "=== TIMER (8min = 480s) ===", COL_TIMER, ROW_TOP-20, 200))

boxes.append(button("start_btn", COL_TIMER, ROW_TOP))
boxes.append(comment("lbl_start", "START", COL_TIMER+30, ROW_TOP+4, 50))

boxes.append(button("reset_btn", COL_TIMER+80, ROW_TOP))
boxes.append(comment("lbl_reset", "RESET/STOP", COL_TIMER+110, ROW_TOP+4, 80))

boxes.append(msg("msg_start", "1", COL_TIMER, ROW_TOP+35))
boxes.append(msg("msg_stop", "0", COL_TIMER+80, ROW_TOP+35))

boxes.append(newobj("metro", "metro 50", 2, 1, ["bang"],
                     COL_TIMER, ROW_TOP+65))

boxes.append(newobj("counter", "counter", 5, 4,
                     ["int", "", "", "int"],
                     COL_TIMER, ROW_TOP+95))

# counter ticks -> ms -> seconds
boxes.append(newobj("ticks_to_ms", "* 50", 2, 1, ["int"],
                     COL_TIMER, ROW_TOP+130))
boxes.append(newobj("ms_to_sec", "/ 1000.", 2, 1, ["float"],
                     COL_TIMER, ROW_TOP+160))

# Time display
boxes.append(flonum("time_display", COL_TIMER, ROW_TOP+195, 70))
boxes.append(comment("lbl_seconds", "seconds", COL_TIMER+75, ROW_TOP+195, 60))

# Minutes display
boxes.append(newobj("sec_to_min", "/ 60.", 2, 1, ["float"],
                     COL_TIMER+140, ROW_TOP+195))
boxes.append(flonum("min_display", COL_TIMER+140, ROW_TOP+225, 60))
boxes.append(comment("lbl_minutes", "minutes", COL_TIMER+205, ROW_TOP+225, 60))

# ---- EVOLUTION AMOUNT ----
# (time - 60) / 420  ->  clip 0 1  ->  evolution (0 during phase1, ramps 0..1 during phase2)
boxes.append(newobj("evo_sub", "- 60.", 2, 1, ["float"],
                     COL_TIMER, ROW_TOP+260))
boxes.append(newobj("evo_div", "/ 420.", 2, 1, ["float"],
                     COL_TIMER, ROW_TOP+290))
boxes.append(newobj("evo_clip", "clip 0. 1.", 3, 1, ["float"],
                     COL_TIMER, ROW_TOP+320))
boxes.append(comment("lbl_evo", "evolution (0..1)", COL_TIMER+80, ROW_TOP+320, 110))

# ---- ONSET RAMP ----
# time / 3  ->  clip 0 1  ->  onset (gentle fade-in first 3 seconds)
boxes.append(newobj("onset_div", "/ 3.", 2, 1, ["float"],
                     COL_TIMER+160, ROW_TOP+260))
boxes.append(newobj("onset_clip", "clip 0. 1.", 3, 1, ["float"],
                     COL_TIMER+160, ROW_TOP+290))
boxes.append(comment("lbl_onset", "onset (0..1)", COL_TIMER+240, ROW_TOP+290, 90))

# Timer connections
lines.append(line("start_btn", 0, "msg_start", 0))
lines.append(line("reset_btn", 0, "msg_stop", 0))
lines.append(line("msg_start", 0, "metro", 0))
lines.append(line("msg_stop", 0, "metro", 0))
lines.append(line("msg_stop", 0, "counter", 3))  # reset counter
lines.append(line("metro", 0, "counter", 0))
lines.append(line("counter", 0, "ticks_to_ms", 0))
lines.append(line("ticks_to_ms", 0, "ms_to_sec", 0))

# ms_to_sec fan-out
lines.append(line("ms_to_sec", 0, "time_display", 0, 0))
lines.append(line("ms_to_sec", 0, "sec_to_min", 0, 1))
lines.append(line("ms_to_sec", 0, "evo_sub", 0, 2))
lines.append(line("ms_to_sec", 0, "onset_div", 0, 3))
lines.append(line("sec_to_min", 0, "min_display", 0))

# Evolution chain
lines.append(line("evo_sub", 0, "evo_div", 0))
lines.append(line("evo_div", 0, "evo_clip", 0))

# Onset chain
lines.append(line("onset_div", 0, "onset_clip", 0))


# ============================================================
# SECTION 3: PER-VOICE PARAMETER CALCULATION
# ============================================================
#
# Strategy: NO clip() inside expr. Instead:
#   1. Per voice: compute voice_phase = (evolution - offset) / period -> clip 0 1
#   2. Compute risset_env = 1 - abs(2*phase - 1) using expr (abs IS supported)
#   3. Compute delay = base + risset_env * evolution * delta using expr
#   4. Compute volume = onset * (base_vol - 0.25 * risset_env * evolution) using expr
#   5. Compute freqshift = fs_base + evolution * fs_delta using expr
#   6. Compute pan = pan_base + evolution * pan_drift using expr
#

voices = [
    {"name": "G1", "idx": 1, "p1_delay": 12.,  "p2_delay": 1500., "vol": 0.82, "fs_base": 0.3,  "fs_max": 1.2,  "pan": 25.,  "pan_drift": 5.},
    {"name": "G2", "idx": 2, "p1_delay": 23.,  "p2_delay": 2800., "vol": 0.78, "fs_base": -0.5, "fs_max": -1.5, "pan": -25., "pan_drift": -5.},
    {"name": "G3", "idx": 3, "p1_delay": 37.,  "p2_delay": 4200., "vol": 0.72, "fs_base": 0.7,  "fs_max": 1.8,  "pan": 50.,  "pan_drift": 10.},
    {"name": "G4", "idx": 4, "p1_delay": 48.,  "p2_delay": 5500., "vol": 0.68, "fs_base": -0.8, "fs_max": -2.0, "pan": -50., "pan_drift": -10.},
]

phase_offsets = [0.0, 0.15, 0.35, 0.55]
phase_periods = [1.0, 0.85, 0.7, 0.55]

boxes.append(comment("lbl_voices", "=== VOICE PARAMETERS ===", COL_PHASE, ROW_TOP-20, 200))

for i, v in enumerate(voices):
    vx = COL_PHASE
    vy = ROW_TOP + i * 250
    idx = v["idx"]
    off = phase_offsets[i]
    per = phase_periods[i]
    p1d = v["p1_delay"]
    delta_d = v["p2_delay"] - p1d
    base_vol = v["vol"]
    fs_b = v["fs_base"]
    fs_delta = v["fs_max"] - fs_b
    pan_b = v["pan"]
    pan_dr = v["pan_drift"]
    
    boxes.append(comment(f"lbl_v{idx}", f"--- {v['name']}: pan={v['pan']}, vol={v['vol']} ---",
                         vx, vy, 250))
    
    # ---- STEP 1: Voice phase = (evolution - offset) / period -> clip 0 1 ----
    boxes.append(newobj(f"ph_sub_{idx}", f"- {off}", 2, 1, ["float"],
                        vx, vy+25, 60))
    boxes.append(newobj(f"ph_div_{idx}", f"/ {per}", 2, 1, ["float"],
                        vx, vy+50, 60))
    boxes.append(newobj(f"ph_clip_{idx}", "clip 0. 1.", 3, 1, ["float"],
                        vx, vy+75, 75))
    
    # ---- STEP 2: Risset envelope = 1 - abs(2*phase - 1) ----
    boxes.append(newobj(f"risset_env_{idx}", "expr 1. - abs(2. * $f1 - 1.)", 1, 1, [""],
                        vx, vy+105, 200))
    
    # ---- STEP 3: Delay = p1_delay + risset_env * evolution * delta ----
    # $f1 = risset_env, $f2 = evolution
    boxes.append(newobj(f"delay_expr_{idx}",
                        f"expr {p1d} + $f1 * $f2 * {delta_d}",
                        2, 1, [""],
                        vx, vy+140, 220))
    
    # Pack delay value + ramp time (50ms smooth), then message-rate line -> tapout~
    boxes.append(newobj(f"delay_pack_{idx}", "pack 0. 50", 2, 1, [""],
                        vx, vy+170, 80))
    boxes.append(newobj(f"delay_line_{idx}", f"line {p1d} 50", 2, 1, [""],
                        vx, vy+200, 85))
    
    # ---- STEP 4: Volume = onset * (base_vol - 0.25 * risset_env * evolution) ----
    # $f1 = risset_env, $f2 = evolution, $f3 = onset
    boxes.append(newobj(f"vol_expr_{idx}",
                        f"expr $f3 * ({base_vol} - 0.25 * $f1 * $f2)",
                        3, 1, [""],
                        vx+230, vy+140, 250))
    
    # Smooth volume -> line~ -> *~
    boxes.append(newobj(f"vol_pack_{idx}", "pack 0. 50", 2, 1, [""],
                        vx+230, vy+170, 80))
    boxes.append(newobj(f"vol_line_{idx}", "line~ 0.", 2, 2, ["signal", "bang"],
                        vx+230, vy+200, 70))
    
    # ---- STEP 5: Freq shift = fs_base + evolution * fs_delta ----
    boxes.append(newobj(f"fs_expr_{idx}",
                        f"expr {fs_b} + $f1 * {fs_delta}",
                        1, 1, [""],
                        vx+230, vy+25, 180))
    boxes.append(newobj(f"fs_pack_{idx}", "pack 0. 100", 2, 1, [""],
                        vx+230, vy+50, 85))
    boxes.append(newobj(f"fs_line_{idx}", "line~ 0.", 2, 2, ["signal", "bang"],
                        vx+230, vy+75, 70))
    
    # ---- STEP 6: Pan = pan_base + evolution * pan_drift ----
    boxes.append(newobj(f"pan_expr_{idx}",
                        f"expr {pan_b} + $f1 * {pan_dr}",
                        1, 1, [""],
                        vx+420, vy+25, 160))
    
    # ==== WIRING ====
    
    # evo_clip -> ph_sub (evolution into voice phase calc)
    lines.append(line("evo_clip", 0, f"ph_sub_{idx}", 0))
    # ph_sub -> ph_div -> ph_clip -> risset_env
    lines.append(line(f"ph_sub_{idx}", 0, f"ph_div_{idx}", 0))
    lines.append(line(f"ph_div_{idx}", 0, f"ph_clip_{idx}", 0))
    lines.append(line(f"ph_clip_{idx}", 0, f"risset_env_{idx}", 0))
    
    # risset_env -> delay_expr inlet 0, vol_expr inlet 0
    lines.append(line(f"risset_env_{idx}", 0, f"delay_expr_{idx}", 0))
    lines.append(line(f"risset_env_{idx}", 0, f"vol_expr_{idx}", 0))
    
    # evo_clip -> delay_expr inlet 1, vol_expr inlet 1, fs_expr, pan_expr
    lines.append(line("evo_clip", 0, f"delay_expr_{idx}", 1))
    lines.append(line("evo_clip", 0, f"vol_expr_{idx}", 1))
    lines.append(line("evo_clip", 0, f"fs_expr_{idx}", 0))
    lines.append(line("evo_clip", 0, f"pan_expr_{idx}", 0))
    
    # onset_clip -> vol_expr inlet 2
    lines.append(line("onset_clip", 0, f"vol_expr_{idx}", 2))
    
    # delay_expr -> delay_pack -> delay_line
    lines.append(line(f"delay_expr_{idx}", 0, f"delay_pack_{idx}", 0))
    lines.append(line(f"delay_pack_{idx}", 0, f"delay_line_{idx}", 0))
    
    # vol_expr -> vol_pack -> vol_line
    lines.append(line(f"vol_expr_{idx}", 0, f"vol_pack_{idx}", 0))
    lines.append(line(f"vol_pack_{idx}", 0, f"vol_line_{idx}", 0))
    
    # fs_expr -> fs_pack -> fs_line
    lines.append(line(f"fs_expr_{idx}", 0, f"fs_pack_{idx}", 0))
    lines.append(line(f"fs_pack_{idx}", 0, f"fs_line_{idx}", 0))


# ============================================================
# SECTION 4: VOICE AUDIO PROCESSING
# ============================================================

boxes.append(comment("lbl_audio", "=== AUDIO PROCESSING ===", COL_VOICE, ROW_TOP-20, 200))

for i, v in enumerate(voices):
    ax = COL_VOICE + i * 150
    ay = ROW_TOP
    idx = v["idx"]
    p1d = v["p1_delay"]
    
    boxes.append(comment(f"lbl_a{idx}", f"{v['name']}", ax+20, ay, 40))
    
    # tapout~ - initial delay is phase1 value
    boxes.append(newobj(f"tapout_{idx}", f"tapout~ {p1d}", 1, 1, ["signal"],
                        ax, ay+30, 90))
    
    # freqshift~ for artifact-free micro-detuning
    boxes.append(newobj(f"freqshift_{idx}", "freqshift~", 2, 2, ["signal", "signal"],
                        ax, ay+70, 80))
    
    # Volume control
    boxes.append(newobj(f"vol_mult_{idx}", "*~ 0.", 2, 1, ["signal"],
                        ax, ay+110, 55))
    
    # Panner
    boxes.append(newobj(f"pan_{idx}", "pan2", 4, 2, ["signal", "signal"],
                        ax, ay+150, 50))
    
    # ---- Audio wiring ----
    
    # tapin -> tapout
    lines.append(line("tapin", 0, f"tapout_{idx}", 0))
    
    # delay_line (message-rate) -> tapout (sets delay time)
    lines.append(line(f"delay_line_{idx}", 0, f"tapout_{idx}", 0))
    
    # tapout -> freqshift
    lines.append(line(f"tapout_{idx}", 0, f"freqshift_{idx}", 0))
    
    # fs_line~ -> freqshift inlet 1 (shift amount)
    lines.append(line(f"fs_line_{idx}", 0, f"freqshift_{idx}", 1))
    
    # freqshift -> vol_mult
    lines.append(line(f"freqshift_{idx}", 0, f"vol_mult_{idx}", 0))
    
    # vol_line~ -> vol_mult inlet 1 (volume envelope)
    lines.append(line(f"vol_line_{idx}", 0, f"vol_mult_{idx}", 1))
    
    # vol_mult -> pan
    lines.append(line(f"vol_mult_{idx}", 0, f"pan_{idx}", 0))
    
    # pan_expr -> pan position inlet 1
    lines.append(line(f"pan_expr_{idx}", 0, f"pan_{idx}", 1))


# ============================================================
# SECTION 5: MIXING & OUTPUT
# ============================================================

boxes.append(comment("lbl_mix", "=== MIX & OUTPUT ===", COL_MIX, ROW_TOP-20, 160))

# Sum L channels
boxes.append(newobj("sum_L_12", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+30))
boxes.append(newobj("sum_L_34", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+60))
boxes.append(newobj("sum_L_all", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+90))

# Sum R channels
boxes.append(newobj("sum_R_12", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+30))
boxes.append(newobj("sum_R_34", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+60))
boxes.append(newobj("sum_R_all", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+90))

# Add dry signal (center = equal L+R)
boxes.append(newobj("mix_L", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+130))
boxes.append(newobj("mix_R", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+130))

# Master gain
boxes.append(newobj("master_gain_L", "*~ 0.5", 2, 1, ["signal"], COL_MIX, ROW_TOP+165))
boxes.append(newobj("master_gain_R", "*~ 0.5", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+165))

# Safety limiter
boxes.append(newobj("clip_L", "clip~ -1. 1.", 3, 1, ["signal"], COL_MIX, ROW_TOP+200))
boxes.append(newobj("clip_R", "clip~ -1. 1.", 3, 1, ["signal"], COL_MIX+80, ROW_TOP+200))

# DAC
boxes.append(newobj("dac", "dac~", 2, 0, [], COL_MIX+30, ROW_TOP+240, 40))

# Meters
boxes.append(newobj("meter_L", "meter~", 1, 1, ["float"], COL_MIX, ROW_TOP+280, 60))
boxes.append(newobj("meter_R", "meter~", 1, 1, ["float"], COL_MIX+80, ROW_TOP+280, 60))

# Pan -> sum wiring
lines.append(line("pan_1", 0, "sum_L_12", 0))
lines.append(line("pan_1", 1, "sum_R_12", 0))
lines.append(line("pan_2", 0, "sum_L_12", 1))
lines.append(line("pan_2", 1, "sum_R_12", 1))
lines.append(line("pan_3", 0, "sum_L_34", 0))
lines.append(line("pan_3", 1, "sum_R_34", 0))
lines.append(line("pan_4", 0, "sum_L_34", 1))
lines.append(line("pan_4", 1, "sum_R_34", 1))

lines.append(line("sum_L_12", 0, "sum_L_all", 0))
lines.append(line("sum_L_34", 0, "sum_L_all", 1))
lines.append(line("sum_R_12", 0, "sum_R_all", 0))
lines.append(line("sum_R_34", 0, "sum_R_all", 1))

# Wet + dry
lines.append(line("sum_L_all", 0, "mix_L", 0))
lines.append(line("sum_R_all", 0, "mix_R", 0))
lines.append(line("dry_gain", 0, "mix_L", 1, 0))
lines.append(line("dry_gain", 0, "mix_R", 1, 1))

# Master gain -> limiter -> dac
lines.append(line("mix_L", 0, "master_gain_L", 0))
lines.append(line("mix_R", 0, "master_gain_R", 0))
lines.append(line("master_gain_L", 0, "clip_L", 0))
lines.append(line("master_gain_R", 0, "clip_R", 0))
lines.append(line("clip_L", 0, "dac", 0))
lines.append(line("clip_R", 0, "dac", 1))
lines.append(line("clip_L", 0, "meter_L", 0, 0))
lines.append(line("clip_R", 0, "meter_R", 0, 0))


# ============================================================
# SECTION 6: LOADBANG INIT
# ============================================================

boxes.append(comment("lbl_init", "=== INIT ===", COL_INPUT, 520, 100))
boxes.append(newobj("loadbang", "loadbang", 1, 1, ["bang"],
                     COL_INPUT, 550))

# loadbang -> short delay -> startwindow to enable DSP
boxes.append(newobj("lb_delay", "delay 500", 2, 1, ["bang"],
                     COL_INPUT, 580))
boxes.append(msg("msg_startwindow", "startwindow", COL_INPUT, 610, 85))

# startwindow message goes to dac~ to start audio processing
lines.append(line("loadbang", 0, "lb_delay", 0))
lines.append(line("lb_delay", 0, "msg_startwindow", 0))
lines.append(line("msg_startwindow", 0, "dac", 0))


# ============================================================
# VALIDATE
# ============================================================

box_ids = set()
for b in boxes:
    box_ids.add(b["box"]["id"])

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

# ============================================================
# ASSEMBLE
# ============================================================

patch = {
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 9,
            "minor": 0,
            "revision": 8,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "dsp.toplevel",
        "rect": [50.0, 80.0, 1600.0, 950.0],
        "gridsize": [15.0, 15.0],
        "boxes": boxes,
        "lines": lines,
        "dependency_cache": [
            {
                "name": "pan2.maxpat",
                "bootpath": "~/Library/Application Support/Cycling '74/Max 9/Examples/spatialization/panning/lib",
                "patcherrelativepath": "../../../Library/Application Support/Cycling '74/Max 9/Examples/spatialization/panning/lib",
                "type": "JSON",
                "implicit": 1
            }
        ],
        "autosave": 0
    }
}

output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "anaerobes.maxpat")
with open(output_path, "w") as f:
    json.dump(patch, f, indent="\t")

print(f"Patch written to {output_path}")
print(f"  Boxes: {len(boxes)}")
print(f"  Lines: {len(lines)}")
if dropped:
    print(f"  DROPPED: {dropped} invalid connections")
else:
    print(f"  All connections valid")
