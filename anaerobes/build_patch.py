#!/usr/bin/env python3
"""
anaerobes v2 — 4-voice looper ensemble, 8-minute arc
build_patch.py  →  generates anaerobes/anaerobes.maxpat

Runtime: Ableton Live 11 + Max for Live 8.x (MSP), not Max 9 standalone.

CONCEPT
=======
  Four partner guitars reading from their OWN looping buffers (4.7s / 7.3s /
  11.1s / 13.9s) — incommensurate lengths → they are always out of phase
  with each other and with the live input.  This is structural independence,
  not simulated via volume LFOs on a shared delay.

  All 4 start at rate ~1.0 and drift apart via per-voice slow oscillators.
  Rate can momentarily dip negative (reverse) during the last 2 minutes.

PIECE ARC (480s = 8 min)
========================
  Phase 1  0:00 – 2:00   Unison halo
    All voices looping at rate ≈ 1.0, freqshift = 0.3–0.6 Hz (barely
    perceptible beating), swells very slow, no saturation.

  Phase 2  2:00 – 4:45   Divergence / chaos rising
    Chaos arc rises → rate drift grows (voices pull apart) → freqshift grows
    to 3–6 Hz per voice → microtonal wobble activates → swells more dramatic.

  Phase 3  4:45 – 5:30   Peak / apex
    Maximum chaos. Strongest detuning and saturation. Rate drift sometimes
    tips a voice into negative territory (brief reverse texture).

  Phase 4  5:30 – 8:00   Resolution / ghostly halo
    Chaos recedes. Rates drift back toward 1.0 but voices carry different
    loop positions — they never re-sync. Reverse gates open on outer voices
    (G3/G4) from t=6:00. Piece ends with a spectral hollow texture.

SIGNAL CHAIN PER VOICE
======================
  ADC → record~ v{N}_buf (continuous, looping)
  groove~ v{N}_buf [rate = rate_sig]
      → freqshift~ [Hz = fs_sig]
      → *~ onset_hold (3s fade-in)
      → *~ sat_mult   (chaos saturation: 1.0 + chaos*boost at peak)
      → clip~ -1. 1.  (per-voice soft clip before sum)
      → *~ dyn_env    (swell_a × swell_b × breath: autonomous dynamics)
      → pan2

  rate_sig   = 1.0 + chaos*drift_osc*depth  +  rev_gate*(-2.0)
  fs_sig     = fs_base + chaos*(fs_max-fs_base) + chaos*wobble_osc*depth
  swell_env  = (swell_a_01 * swell_b_01) * breath  — all incommensurate

CONFIRMED MAX OBJECTS USED
===========================
  adc~ dac~ ezdac~ buffer~ record~ groove~ freqshift~
  cycle~ *~ +~ clip~ sig~ pan2 meter~
  metro counter loadbang delay
  msg button flonum comment expr (control-rate ONLY, no clip())

IMPORTANT: expr~ NOT available — use *~ / +~ chains.
           clip() in expr NOT supported — use separate clip objects.
"""

import json
import math
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
    ot = outlettype if outlettype is not None else (["signal"] * numoutlets)
    return box(id, "newobj", text, numinlets, numoutlets, ot, x, y, w, extra=extra)

def flonum(id, x=0, y=0, w=60):
    return box(id, "flonum", numinlets=1, numoutlets=2,
               outlettype=["", "bang"], x=x, y=y, w=w,
               extra={"format": 6, "parameter_enable": 0})

def msg(id, text, x=0, y=0, w=None):
    return box(id, "message", text, numinlets=2, numoutlets=1,
               outlettype=[""], x=x, y=y, w=w or (len(text)*7+14))

def button(id, x=0, y=0, presentation=False, px=0, py=0, pw=24, ph=24):
    extra = {"parameter_enable": 0}
    if presentation:
        extra["presentation"] = 1
        extra["presentation_rect"] = [px, py, pw, ph]
    return box(id, "button", numinlets=1, numoutlets=1,
               outlettype=["bang"], x=x, y=y, w=24, h=24, extra=extra)

def comment(id, text, x=0, y=0, w=None):
    return box(id, "comment", text, numinlets=1, numoutlets=0,
               outlettype=[], x=x, y=y, w=w or (len(text)*7+10))

def line(src, src_outlet, dst, dst_inlet, order=None):
    d = {"destination": [dst, dst_inlet], "source": [src, src_outlet]}
    if order is not None:
        d["order"] = order
    return {"patchline": d}

# ============================================================
# LAYOUT
# ============================================================

COL_INPUT  = 40
COL_TIMER  = 300
COL_CTRL   = 600    # per-voice modulation (Section 3)
COL_VOICE  = 1250   # per-voice audio (Section 4)
COL_MIX    = 2050

ROW_TOP = 40

boxes = []
lines = []

# ============================================================
# VOICE DEFINITIONS
# ============================================================
#
# buf_ms        : loop buffer length — incommensurate → voices always out of phase
# drift_rate    : rate drift LFO Hz — each voice unique
# drift_depth   : max rate offset at chaos=1  (0.03 = ±3%)
# fs_base       : freqshift Hz at chaos=0 (quiet beating)
# fs_max        : freqshift Hz at chaos=1 (Δ added on top of base)
# fs_sign       : +1 or -1 — voices detune in opposite directions
# wobble_rate   : fast microtonal flutter LFO Hz
# wobble_depth  : ±Hz flutter at chaos=1
# swell_a_rate  : swell gate oscillator A Hz (fast, ~8-12s period)
# swell_b_rate  : swell gate oscillator B Hz (slow, ~60-90s silent gate)
# breath_rate   : subtle quiver Hz
# rev_rate      : reverse gate oscillator Hz (active only after t=6min)
# sat_boost     : chaos saturation multiplier (2.0 → up to 3× gain at peak)
# pan           : stereo position 0.0 (hard L) .. 1.0 (hard R)
#
# All 16 oscillator periods are incommensurate — never align in 8 minutes.

voices = [
    {"name": "G1", "idx": 1,
     "buf_ms": 4700,
     "drift_rate": 0.019, "drift_depth": 0.025,
     "fs_base": 0.3,  "fs_max": 3.0,  "fs_sign": +1,
     "wobble_rate": 0.37, "wobble_depth": 0.4,
     "swell_a_rate": 0.10,  "swell_b_rate": 0.013, "breath_rate": 0.11,
     "rev_rate": 0.019, "sat_boost": 1.5,
     "pan": 0.66},

    {"name": "G2", "idx": 2,
     "buf_ms": 7300,
     "drift_rate": 0.027, "drift_depth": 0.020,
     "fs_base": 0.4,  "fs_max": 4.5,  "fs_sign": -1,
     "wobble_rate": 0.53, "wobble_depth": 0.5,
     "swell_a_rate": 0.13,  "swell_b_rate": 0.017, "breath_rate": 0.17,
     "rev_rate": 0.023, "sat_boost": 1.5,
     "pan": 0.36},

    {"name": "G3", "idx": 3,
     "buf_ms": 11100,
     "drift_rate": 0.033, "drift_depth": 0.032,
     "fs_base": 0.5,  "fs_max": 5.5,  "fs_sign": +1,
     "wobble_rate": 0.67, "wobble_depth": 0.6,
     "swell_a_rate": 0.083, "swell_b_rate": 0.011, "breath_rate": 0.07,
     "rev_rate": 0.031, "sat_boost": 2.0,
     "pan": 0.89},

    {"name": "G4", "idx": 4,
     "buf_ms": 13900,
     "drift_rate": 0.041, "drift_depth": 0.038,
     "fs_base": 0.6,  "fs_max": 6.5,  "fs_sign": -1,
     "wobble_rate": 0.43, "wobble_depth": 0.7,
     "swell_a_rate": 0.11,  "swell_b_rate": 0.015, "breath_rate": 0.13,
     "rev_rate": 0.027, "sat_boost": 2.0,
     "pan": 0.13},
]

# ============================================================
# SECTION 1: INPUT + STARTUP
# ============================================================

boxes.append(comment("lbl_input", "=== INPUT ===", COL_INPUT, ROW_TOP-20, 120))

# M4L audio input — outlet 0 = L, outlet 1 = R
boxes.append(newobj("adc", "plugin~", 2, 2, ["signal","signal"], COL_INPUT, ROW_TOP+40))

# Dry guitar — slightly under the looper voices
boxes.append(newobj("dry_gain", "*~ 0.4", 2, 1, ["signal"], COL_INPUT, ROW_TOP+80))
boxes.append(comment("lbl_dry", "dry guitar (center)", COL_INPUT+70, ROW_TOP+82, 150))

# live.thisdevice: outlet 0 fires when device is fully ready in Live's audio graph
boxes.append(newobj("thisdevice", "live.thisdevice", 1, 2, ["bang","bang"], COL_INPUT+180, ROW_TOP+40))

lines.append(line("adc", 0, "dry_gain", 0))

# ============================================================
# SECTION 2: TIMER + ARCS
# ============================================================
#
# Arcs (signal-rate where possible, control-rate where only control is needed):
#   onset_clip  : clip(t/3, 0, 1)                  — 3s fade-in
#   chaos_sig   : bell curve: rises 2min→4:45,      — signal-rate
#                 falls 4:45→7min
#   rev_sig     : clip((t-360)/30, 0, 1)            — signal-rate, active last 2min

boxes.append(comment("lbl_timer", "=== TIMER (480s = 8min) ===", COL_TIMER, ROW_TOP-20, 220))

boxes.append(button("start_btn", COL_TIMER,    ROW_TOP, presentation=True, px=10, py=10))
boxes.append(comment("lbl_start", "START",      COL_TIMER+30,  ROW_TOP+4, 50))
boxes.append(button("reset_btn", COL_TIMER+80, ROW_TOP, presentation=True, px=50, py=10))
boxes.append(comment("lbl_reset", "RESET/STOP", COL_TIMER+110, ROW_TOP+4, 90))

boxes.append(msg("msg_start", "1", COL_TIMER,    ROW_TOP+35))
boxes.append(msg("msg_stop",  "0", COL_TIMER+80, ROW_TOP+35))

boxes.append(newobj("metro",    "metro 50",  2, 1, ["bang"],          COL_TIMER, ROW_TOP+65))
boxes.append(newobj("counter",  "counter",   5, 4, ["int","","","int"], COL_TIMER, ROW_TOP+95))
boxes.append(newobj("ticks_ms", "* 50",      2, 1, ["int"],            COL_TIMER, ROW_TOP+130))
boxes.append(newobj("ms_to_sec","/ 1000.",   2, 1, ["float"],          COL_TIMER, ROW_TOP+160))

boxes.append(flonum("time_display", COL_TIMER,     ROW_TOP+195, 70))
boxes.append(comment("lbl_sec", "seconds",          COL_TIMER+75,  ROW_TOP+197, 60))
boxes.append(newobj("sec_to_min", "/ 60.", 2, 1, ["float"], COL_TIMER+140, ROW_TOP+195))
boxes.append(flonum("min_display", COL_TIMER+140,   ROW_TOP+225, 60))
boxes.append(comment("lbl_min", "minutes",           COL_TIMER+205, ROW_TOP+227, 60))

# Onset boxes removed — voices are no longer gated by a timed ramp.
# Audio starts as soon as groove~ fills its buffer (~5-14s after START).
# (onset_div/clip/sig removed to prevent vol_mult zeroing all voices)

# Chaos arc: bell, peak at 285s (4:45), active 120s..420s
# max()/min() valid in Max expr; clip() is NOT
boxes.append(newobj("chaos_expr",
    "expr max(0., min(1., ($f1-120.)/165.)) * (1. - max(0., min(1., ($f1-285.)/135.)))",
    1, 1, [""], COL_TIMER, ROW_TOP+360, 510))
boxes.append(newobj("chaos_sig", "sig~ 0.", 1, 1, ["signal"], COL_TIMER, ROW_TOP+390, 55))
boxes.append(comment("lbl_chaos", "chaos 0..1 (peaks 4:45)", COL_TIMER+520, ROW_TOP+362, 180))

# Reverse arc: clip((t-360)/30, 0, 1) — last 2 minutes
boxes.append(newobj("rev_sub",  "- 360.",      2, 1, ["float"],  COL_TIMER+180, ROW_TOP+260))
boxes.append(newobj("rev_div",  "/ 30.",       2, 1, ["float"],  COL_TIMER+180, ROW_TOP+290))
boxes.append(newobj("rev_clip", "clip 0. 1.",  3, 1, ["float"],  COL_TIMER+180, ROW_TOP+320))
boxes.append(newobj("rev_sig",  "sig~ 0.",     1, 1, ["signal"], COL_TIMER+180, ROW_TOP+350, 55))
boxes.append(comment("lbl_rev", "reverse arc (t>6min)", COL_TIMER+240, ROW_TOP+322, 160))

# Timer wiring
lines.append(line("start_btn",  0, "msg_start",  0))
lines.append(line("reset_btn",  0, "msg_stop",   0))
lines.append(line("msg_start",  0, "metro",      0))
lines.append(line("msg_stop",   0, "metro",      0))
lines.append(line("msg_stop",   0, "counter",    3))
lines.append(line("metro",      0, "counter",    0))
lines.append(line("counter",    0, "ticks_ms",   0))
lines.append(line("ticks_ms",   0, "ms_to_sec",  0))

lines.append(line("ms_to_sec",  0, "time_display", 0, 0))
lines.append(line("ms_to_sec",  0, "sec_to_min",   0, 1))
lines.append(line("ms_to_sec",  0, "chaos_expr",   0, 2))
lines.append(line("ms_to_sec",  0, "rev_sub",      0, 3))

lines.append(line("sec_to_min", 0, "min_display",  0))
lines.append(line("chaos_expr", 0, "chaos_sig",    0))
lines.append(line("rev_sub",    0, "rev_div",      0))
lines.append(line("rev_div",    0, "rev_clip",     0))
lines.append(line("rev_clip",   0, "rev_sig",      0))

# ============================================================
# SECTION 3: PER-VOICE MODULATION SIGNALS
# ============================================================
#
# Everything signal-rate. Only confirmed objects: cycle~ *~ +~
#
# RATE SIGNAL per voice:
#   drift_osc   = cycle~(drift_rate)              — slow sine (-1..1)
#   drift_cx    = drift_osc *~ chaos_sig          — gates drift by chaos
#   drift_amp   = drift_cx *~ drift_depth         — scales to ±depth
#   base_rate   = drift_amp +~ 1.0               — rate around 1.0
#   rev_osc     = cycle~(rev_rate)               — slow reverse gate (-1..1)
#   rev_scale   = rev_osc *~ 0.5 → +~ 0.5        — 0..1
#   rev_gated   = rev_scale *~ rev_sig            — zero before t=6min
#   rev_flip    = rev_gated *~ -2.0              — 0 → -2.0 when gated
#   rate_sig    = base_rate +~ rev_flip           — ≈1.0 fwd, ≈-1.0 rev
#
# FREQSHIFT SIGNAL per voice:
#   fs_chaos    = chaos_sig *~ (fs_sign*(fs_max-fs_base))  — chaos Δ
#   fs_base_s   = fs_chaos +~ (fs_sign*fs_base)            — base + chaos
#   wobble_raw  = cycle~(wobble_rate) *~ chaos_sig         — flutter × chaos
#   wobble_hz   = wobble_raw *~ wobble_depth               — ±Hz
#   fs_sig      = fs_base_s +~ wobble_hz                   — final Hz
#
# SWELL ENVELOPE per voice:
#   swell_a_sig = cycle~(swell_a_rate) *~0.5 +~0.5        — 0..1 (8-12s)
#   swell_b_sig = cycle~(swell_b_rate) *~0.5 +~0.5        — 0..1 (60-90s gate)
#   swell_prod  = swell_a_sig *~ swell_b_sig              — irregular swell
#   breath_sig  = cycle~(breath_rate) *~0.15 +~1.0        — 0.85..1.15
#   dyn_env     = swell_prod *~ breath_sig                 — full envelope

boxes.append(comment("lbl_ctrl", "=== PER-VOICE MODULATION ===", COL_CTRL, ROW_TOP-20, 230))

for v in voices:
    idx = v["idx"]
    vx  = COL_CTRL + (idx-1) * 160
    vy  = ROW_TOP

    boxes.append(comment(f"lbl_c{idx}", v["name"], vx+50, vy, 40))

    # ---- RATE ----
    boxes.append(comment(f"lbl_rate{idx}", "rate", vx, vy+18, 35))
    boxes.append(newobj(f"drift_osc_{idx}",      f"cycle~ {v['drift_rate']}",  2, 1, ["signal"], vx,    vy+35,  90))
    boxes.append(newobj(f"drift_cx_{idx}",        "*~",                        2, 1, ["signal"], vx,    vy+65,  40))
    boxes.append(newobj(f"drift_amp_{idx}",       f"*~ {v['drift_depth']}",    2, 1, ["signal"], vx,    vy+95,  75))
    boxes.append(newobj(f"base_rate_{idx}",       "+~ 1.0",                    2, 1, ["signal"], vx,    vy+125, 60))
    boxes.append(newobj(f"rev_osc_{idx}",         f"cycle~ {v['rev_rate']}",   2, 1, ["signal"], vx+85, vy+35,  90))
    boxes.append(newobj(f"rev_osc_scale_{idx}",   "*~ 0.5",                    2, 1, ["signal"], vx+85, vy+65,  55))
    boxes.append(newobj(f"rev_osc_bias_{idx}",    "+~ 0.5",                    2, 1, ["signal"], vx+85, vy+95,  55))
    boxes.append(newobj(f"rev_gated_{idx}",       "*~",                        2, 1, ["signal"], vx+85, vy+125, 40))
    boxes.append(newobj(f"rev_flip_{idx}",        "*~ -2.0",                   2, 1, ["signal"], vx+85, vy+155, 65))
    boxes.append(newobj(f"rate_sig_{idx}",        "+~",                        2, 1, ["signal"], vx+40, vy+185, 40))

    lines.append(line(f"drift_osc_{idx}",     0, f"drift_cx_{idx}",      0))
    lines.append(line("chaos_sig",             0, f"drift_cx_{idx}",      1))
    lines.append(line(f"drift_cx_{idx}",      0, f"drift_amp_{idx}",      0))
    lines.append(line(f"drift_amp_{idx}",     0, f"base_rate_{idx}",      0))
    lines.append(line(f"rev_osc_{idx}",       0, f"rev_osc_scale_{idx}",  0))
    lines.append(line(f"rev_osc_scale_{idx}", 0, f"rev_osc_bias_{idx}",   0))
    lines.append(line(f"rev_osc_bias_{idx}",  0, f"rev_gated_{idx}",      0))
    lines.append(line("rev_sig",               0, f"rev_gated_{idx}",      1))
    lines.append(line(f"rev_gated_{idx}",     0, f"rev_flip_{idx}",        0))
    lines.append(line(f"base_rate_{idx}",     0, f"rate_sig_{idx}",        0))
    lines.append(line(f"rev_flip_{idx}",      0, f"rate_sig_{idx}",        1))

    # ---- FREQSHIFT ----
    boxes.append(comment(f"lbl_fs{idx}", "freqshift", vx, vy+215, 70))
    fs_delta = v["fs_sign"] * (v["fs_max"] - v["fs_base"])
    fs_b     = v["fs_sign"] * v["fs_base"]
    boxes.append(newobj(f"fs_chaos_{idx}",   f"*~ {fs_delta}",           2, 1, ["signal"], vx,    vy+235, 80))
    boxes.append(newobj(f"fs_base_s_{idx}",  f"+~ {fs_b}",               2, 1, ["signal"], vx,    vy+265, 70))
    boxes.append(newobj(f"wobble_osc_{idx}", f"cycle~ {v['wobble_rate']}",2, 1, ["signal"], vx+85, vy+235, 90))
    boxes.append(newobj(f"wobble_cx_{idx}",   "*~",                       2, 1, ["signal"], vx+85, vy+265, 40))
    boxes.append(newobj(f"wobble_hz_{idx}",  f"*~ {v['wobble_depth']}",   2, 1, ["signal"], vx+85, vy+295, 75))
    boxes.append(newobj(f"fs_sig_{idx}",      "+~",                       2, 1, ["signal"], vx+40, vy+325, 40))

    lines.append(line("chaos_sig",           0, f"fs_chaos_{idx}",   0))
    lines.append(line(f"fs_chaos_{idx}",     0, f"fs_base_s_{idx}",  0))
    lines.append(line(f"wobble_osc_{idx}",   0, f"wobble_cx_{idx}",  0))
    lines.append(line("chaos_sig",           0, f"wobble_cx_{idx}",  1))
    lines.append(line(f"wobble_cx_{idx}",    0, f"wobble_hz_{idx}",  0))
    lines.append(line(f"fs_base_s_{idx}",    0, f"fs_sig_{idx}",     0))
    lines.append(line(f"wobble_hz_{idx}",    0, f"fs_sig_{idx}",     1))

    # ---- SWELL ENVELOPE ----
    boxes.append(comment(f"lbl_sw{idx}", "swell", vx, vy+355, 40))
    boxes.append(newobj(f"swell_a_{idx}",       f"cycle~ {v['swell_a_rate']}", 2, 1, ["signal"], vx,    vy+375, 90))
    boxes.append(newobj(f"swell_a_scale_{idx}", "*~ 0.4",                      2, 1, ["signal"], vx,    vy+405, 55))
    boxes.append(newobj(f"swell_a_bias_{idx}",  "+~ 0.6",                      2, 1, ["signal"], vx,    vy+435, 55))
    boxes.append(newobj(f"swell_b_{idx}",       f"cycle~ {v['swell_b_rate']}", 2, 1, ["signal"], vx+85, vy+375, 90))
    boxes.append(newobj(f"swell_b_scale_{idx}", "*~ 0.4",                      2, 1, ["signal"], vx+85, vy+405, 55))
    boxes.append(newobj(f"swell_b_bias_{idx}",  "+~ 0.6",                      2, 1, ["signal"], vx+85, vy+435, 55))
    boxes.append(newobj(f"swell_prod_{idx}",    "*~",                          2, 1, ["signal"], vx+40, vy+465, 40))
    boxes.append(newobj(f"breath_{idx}",        f"cycle~ {v['breath_rate']}",  2, 1, ["signal"], vx,    vy+495, 90))
    boxes.append(newobj(f"breath_scale_{idx}",  "*~ 0.15",                     2, 1, ["signal"], vx,    vy+525, 65))
    boxes.append(newobj(f"breath_bias_{idx}",   "+~ 1.0",                      2, 1, ["signal"], vx,    vy+555, 55))
    boxes.append(newobj(f"dyn_env_{idx}",       "*~",                          2, 1, ["signal"], vx+40, vy+585, 40))

    lines.append(line(f"swell_a_{idx}",       0, f"swell_a_scale_{idx}", 0))
    lines.append(line(f"swell_a_scale_{idx}", 0, f"swell_a_bias_{idx}",  0))
    lines.append(line(f"swell_b_{idx}",       0, f"swell_b_scale_{idx}", 0))
    lines.append(line(f"swell_b_scale_{idx}", 0, f"swell_b_bias_{idx}",  0))
    lines.append(line(f"swell_a_bias_{idx}",  0, f"swell_prod_{idx}",    0))
    lines.append(line(f"swell_b_bias_{idx}",  0, f"swell_prod_{idx}",    1))
    lines.append(line(f"breath_{idx}",        0, f"breath_scale_{idx}",  0))
    lines.append(line(f"breath_scale_{idx}",  0, f"breath_bias_{idx}",   0))
    lines.append(line(f"swell_prod_{idx}",    0, f"dyn_env_{idx}",       0))
    lines.append(line(f"breath_bias_{idx}",   0, f"dyn_env_{idx}",       1))

# ============================================================
# SECTION 4: PER-VOICE AUDIO  (tapin~/tapout~ — no init required)
# ============================================================
#
# Shared delay line (tapin~ 15000) continuously records plugin~ input.
# tapout~ reads at each voice's incommensurate delay time (4700/7300/11100/13900 ms).
# No buffer~/record~/groove~ — tapin~/tapout~ are always running.
#
# grv_gate (sig~ 0.) mutes all voices until START is pressed.
# START → "1." → grv_gate → voices unmuted.
# RESET → "0." → grv_gate → voices muted again.
#
# SSB frequency shifting (replaces broken freqshift~):
#   hilbert~ → real (outlet 0) + imag (outlet 1) quadrature
#   fs_ccos: cycle~ (freq = fs_sig, phase = 0.25 → cosine)
#   fs_csin: cycle~ (freq = fs_sig)
#   output = real * cos(2π·fs·t) − imag * sin(2π·fs·t)  (SSB shift)
#
# Panning: inline equal-power *~ (no external pan2 needed).

boxes.append(comment("lbl_audio", "=== VOICE AUDIO ===", COL_VOICE, ROW_TOP-20, 150))

# Shared delay line — always running, no init required
boxes.append(newobj("tapin_main", "tapin~ 15000", 1, 1, ["signal"], COL_VOICE, ROW_TOP))

# Multi-tap: one outlet per voice (4700, 7300, 11100, 13900 ms)
boxes.append(newobj("tapout_all", "tapout~ 4700. 7300. 11100. 13900.",
                     1, 4, ["signal","signal","signal","signal"], COL_VOICE, ROW_TOP+40, 215))

# Gate signal: 0. → muted, 1. → active (set by START/RESET buttons)
boxes.append(newobj("grv_gate",    "sig~ 0.", 1, 1, ["signal"], COL_VOICE+230, ROW_TOP))
boxes.append(msg(   "grv_gate_on",  "1.",     COL_VOICE+230, ROW_TOP+30, 25))
boxes.append(msg(   "grv_gate_off", "0.",     COL_VOICE+230, ROW_TOP+60, 25))

lines.append(line("adc",           0, "tapin_main",   0))   # plugin~ L → delay line
lines.append(line("tapin_main",    0, "tapout_all",   0))
lines.append(line("start_btn",     0, "grv_gate_on",  0))
lines.append(line("reset_btn",     0, "grv_gate_off", 0))
lines.append(line("grv_gate_on",   0, "grv_gate",     0))
lines.append(line("grv_gate_off",  0, "grv_gate",     0))

for v in voices:
    idx     = v["idx"]
    tap_out = idx - 1       # tapout_all outlet index (0-based)
    ax  = COL_VOICE + (idx-1) * 195
    ay  = ROW_TOP + 90

    boxes.append(comment(f"lbl_a{idx}", v["name"], ax+80, ay, 40))

    # Gate multiplier — mutes voice until START
    boxes.append(newobj(f"tap_gate_{idx}", "*~", 2, 1, ["signal"], ax, ay+20, 40))

    # Hilbert~ SSB frequency shifting
    boxes.append(newobj(f"fs_h_{idx}",    "hilbert~", 1, 2, ["signal","signal"], ax,    ay+60,  60))
    boxes.append(newobj(f"fs_ccos_{idx}", "cycle~",   2, 1, ["signal"],           ax+80, ay+60,  50))
    boxes.append(newobj(f"fs_csin_{idx}", "cycle~",   2, 1, ["signal"],           ax+80, ay+90,  50))
    boxes.append(msg(   f"fs_cphase_{idx}", "0.25",                               ax+80, ay+30,  35))
    boxes.append(newobj(f"fs_mr_{idx}",   "*~",       2, 1, ["signal"],           ax,    ay+100, 35))
    boxes.append(newobj(f"fs_mi_{idx}",   "*~",       2, 1, ["signal"],           ax+50, ay+100, 35))
    boxes.append(newobj(f"fs_ni_{idx}",   "*~ -1.",   2, 1, ["signal"],           ax+50, ay+130, 55))
    boxes.append(newobj(f"fs_{idx}",      "+~",       2, 1, ["signal"],           ax+25, ay+160, 35))

    # Saturation: chaos_sig → *~ sat_boost → +~ 1.0 → multiplies voice signal
    boxes.append(newobj(f"sat_boost_{idx}", f"*~ {v['sat_boost']}", 2, 1, ["signal"], ax+55, ay+200, 80))
    boxes.append(newobj(f"sat_add_{idx}",    "+~ 1.0",              2, 1, ["signal"], ax+55, ay+230, 55))
    boxes.append(newobj(f"sat_mult_{idx}",   "*~",                  2, 1, ["signal"], ax,    ay+230, 40))

    # Per-voice soft clip
    boxes.append(newobj(f"vclip_{idx}", "clip~ -1. 1.", 3, 1, ["signal"], ax, ay+265, 85))

    # Dynamic envelope (swell)
    boxes.append(newobj(f"dyn_mult_{idx}", "*~", 2, 1, ["signal"], ax, ay+305, 40))

    # Inline equal-power panning (no external pan2 needed)
    pan_L = math.cos(v["pan"] * math.pi / 2)
    pan_R = math.sin(v["pan"] * math.pi / 2)
    boxes.append(newobj(f"pan_L_{idx}", f"*~ {pan_L:.4f}", 2, 1, ["signal"], ax,    ay+345, 75))
    boxes.append(newobj(f"pan_R_{idx}", f"*~ {pan_R:.4f}", 2, 1, ["signal"], ax+85, ay+345, 75))

    # ---- Audio wiring ----
    lines.append(line("tapout_all",      tap_out, f"tap_gate_{idx}", 0))
    lines.append(line("grv_gate",        0,       f"tap_gate_{idx}", 1))

    lines.append(line(f"tap_gate_{idx}", 0, f"fs_h_{idx}",    0))
    lines.append(line(f"fs_sig_{idx}",   0, f"fs_ccos_{idx}", 0))
    lines.append(line(f"fs_sig_{idx}",   0, f"fs_csin_{idx}", 0))
    lines.append(line(f"fs_cphase_{idx}", 0, f"fs_ccos_{idx}", 1))    # phase 0.25 → cosine
    lines.append(line("thisdevice",      0, f"fs_cphase_{idx}", 0))   # trigger on device ready

    lines.append(line(f"fs_h_{idx}",    0, f"fs_mr_{idx}", 0))
    lines.append(line(f"fs_ccos_{idx}", 0, f"fs_mr_{idx}", 1))
    lines.append(line(f"fs_h_{idx}",    1, f"fs_mi_{idx}", 0))
    lines.append(line(f"fs_csin_{idx}", 0, f"fs_mi_{idx}", 1))
    lines.append(line(f"fs_mr_{idx}",   0, f"fs_{idx}",    0))
    lines.append(line(f"fs_mi_{idx}",   0, f"fs_ni_{idx}", 0))
    lines.append(line(f"fs_ni_{idx}",   0, f"fs_{idx}",    1))

    lines.append(line("chaos_sig",          0, f"sat_boost_{idx}", 0))
    lines.append(line(f"sat_boost_{idx}",   0, f"sat_add_{idx}",   0))
    lines.append(line(f"fs_{idx}",          0, f"sat_mult_{idx}",  0))
    lines.append(line(f"sat_add_{idx}",     0, f"sat_mult_{idx}",  1))
    lines.append(line(f"sat_mult_{idx}",    0, f"vclip_{idx}",     0))
    lines.append(line(f"vclip_{idx}",       0, f"dyn_mult_{idx}",  0))
    lines.append(line(f"dyn_env_{idx}",     0, f"dyn_mult_{idx}",  1))
    lines.append(line(f"dyn_mult_{idx}",    0, f"pan_L_{idx}",     0))
    lines.append(line(f"dyn_mult_{idx}",    0, f"pan_R_{idx}",     0))

# ============================================================
# SECTION 5: MIX & OUTPUT
# ============================================================
#
# Master gain calibration (worst case: all 4 voices at swell peak + dry):
#   Voice peak amplitude (before master): ~1.0 (groove output)
#   Through: *~ onset(1.0) → *~ sat(1.0 at chaos=0) → clip~ → *~ swell(1.0) = 1.0
#   4 voices summed: 4.0 L + 4.0 R (before pan, varies by position)
#   Dry: 0.4
#   Master *~ 0.20 → 4.0 * 0.20 = 0.80 peak. Safe under 1.0.
#   At chaos peak sat_mult can reach 3.0 but per-voice clip~ caps at 1.0.

boxes.append(comment("lbl_mix", "=== MIX & OUTPUT ===", COL_MIX, ROW_TOP-20, 160))

boxes.append(newobj("sum_L_12",  "+~", 2, 1, ["signal"], COL_MIX,    ROW_TOP+30))
boxes.append(newobj("sum_L_34",  "+~", 2, 1, ["signal"], COL_MIX,    ROW_TOP+60))
boxes.append(newobj("sum_L_all", "+~", 2, 1, ["signal"], COL_MIX,    ROW_TOP+90))
boxes.append(newobj("sum_R_12",  "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+30))
boxes.append(newobj("sum_R_34",  "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+60))
boxes.append(newobj("sum_R_all", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+90))

boxes.append(newobj("mix_L", "+~", 2, 1, ["signal"], COL_MIX,    ROW_TOP+130))
boxes.append(newobj("mix_R", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+130))

boxes.append(newobj("master_gain_L", "*~ 0.20", 2, 1, ["signal"], COL_MIX,    ROW_TOP+165))
boxes.append(newobj("master_gain_R", "*~ 0.20", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+165))

boxes.append(newobj("clip_L", "clip~ -1. 1.", 3, 1, ["signal"], COL_MIX,    ROW_TOP+200))
boxes.append(newobj("clip_R", "clip~ -1. 1.", 3, 1, ["signal"], COL_MIX+80, ROW_TOP+200))

boxes.append(newobj("dac", "plugout~", 2, 2, ["signal","signal"], COL_MIX+30, ROW_TOP+240, 60))

boxes.append(newobj("meter_L", "meter~", 1, 1, ["float"], COL_MIX,    ROW_TOP+280, 60))
boxes.append(newobj("meter_R", "meter~", 1, 1, ["float"], COL_MIX+80, ROW_TOP+280, 60))

# pan_L/R_{N} → sum (inline equal-power pan, no pan2 external)
lines.append(line("pan_L_1", 0, "sum_L_12",  0))
lines.append(line("pan_R_1", 0, "sum_R_12",  0))
lines.append(line("pan_L_2", 0, "sum_L_12",  1))
lines.append(line("pan_R_2", 0, "sum_R_12",  1))
lines.append(line("pan_L_3", 0, "sum_L_34",  0))
lines.append(line("pan_R_3", 0, "sum_R_34",  0))
lines.append(line("pan_L_4", 0, "sum_L_34",  1))
lines.append(line("pan_R_4", 0, "sum_R_34",  1))

lines.append(line("sum_L_12", 0, "sum_L_all", 0))
lines.append(line("sum_L_34", 0, "sum_L_all", 1))
lines.append(line("sum_R_12", 0, "sum_R_all", 0))
lines.append(line("sum_R_34", 0, "sum_R_all", 1))

lines.append(line("sum_L_all", 0, "mix_L", 0))
lines.append(line("sum_R_all", 0, "mix_R", 0))
lines.append(line("dry_gain",  0, "mix_L", 1))
lines.append(line("dry_gain",  0, "mix_R", 1))

lines.append(line("mix_L", 0, "master_gain_L", 0))
lines.append(line("mix_R", 0, "master_gain_R", 0))
lines.append(line("master_gain_L", 0, "clip_L", 0))
lines.append(line("master_gain_R", 0, "clip_R", 0))
lines.append(line("clip_L", 0, "dac",     0))
lines.append(line("clip_R", 0, "dac",     1))
lines.append(line("clip_L", 0, "meter_L", 0))
lines.append(line("clip_R", 0, "meter_R", 0))

# ============================================================
# VALIDATE & WRITE
# ============================================================

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

patch = {
    "boxes": boxes,
    "lines": lines,
    "appversion": {"major": 8, "minor": 1, "revision": 11, "architecture": "x64", "modernui": 1},
    "classnamespace": "box"
}

output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "anaerobes.maxpat")
with open(output_path, "w") as f:
    json.dump(patch, f, indent="\t")

print(f"Patch written to {output_path}")
print(f"  Boxes: {len(boxes)}")
print(f"  Lines: {len(lines)}")
if dropped:
    print(f"  WARNING: Dropped {dropped} invalid lines")
else:
    print("  All connections valid")
