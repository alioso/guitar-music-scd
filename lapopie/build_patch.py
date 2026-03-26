#!/usr/bin/env python3
"""
Build the Euclidean Guitar Quintet patch "lapopie" for Max/MSP 9.
9-minute live piece: 1 input guitar + 4 partner voices.

ARCHITECTURE
============
1. TIMER / CLICK      – global 80bpm clock, quarter-note audio click
2. PITCH DETECTION    – yin~ during 0-30s window, top-5 MIDI notes into coll
3. RECORD             – record~ into buffer~ during 0-30s (captures material)
4. EUCLIDEAN ENGINE   – 10-pattern coll bank, per-voice step sequencer
5. VOICE SCHEDULER    – entry times, section durations, break logic per voice
6. PLAYBACK           – groove~ rate-shifted to target pitch, panned stereo
7. MIX / OUTPUT       – sum, master gain, dac~

TIMELINE (80bpm, quarter = 750ms)
==================================
0:00   Solo guitar. Pitch detection + recording active.
0:30   G1 enters. Pool locked. Sections: 4 × 90s + 30s breaks + 30s taper = 8:30 stop
1:00   G2 enters. Sections: 210s + 60s break + 210s finish at 9:00
1:30   G3 enters. Sections: 3 × 150s contiguous finish at 9:00
2:00   G4 enters. 1 section of 360s, taper at 8:00, gone at 8:30
9:00   Piece ends (G2 + G3 close simultaneously)

VOICE SCHEDULES (all times in seconds from 0:00)
  G1: ON 30, OFF 120, ON 150, OFF 240, ON 270, OFF 360, ON 390, OFF 480, TAPER→510
  G2: ON 60, OFF 270, ON 330, OFF 540
  G3: ON 90, OFF 240, ON 240, OFF 390, ON 390, OFF 540
  G4: ON 120, OFF 480, TAPER→510

NOTE: "OFF" here means section ends / break starts (voice silences).

EUCLIDEAN PATTERN BANK (stored in coll, 0/1 strings over 8th-note grid)
  0: E(3,8)  = 1 0 0 1 0 0 1 0    tresillo
  1: E(5,8)  = 1 0 1 0 1 0 1 1    cinquillo
  2: E(2,5)  = 1 0 0 1 0          sparse 5
  3: E(3,5)  = 1 0 1 0 1          dense 5
  4: E(3,7)  = 1 0 0 1 0 0 1      sparse 7
  5: E(4,7)  = 1 0 1 0 1 0 1      medium 7
  6: E(5,7)  = 1 1 0 1 0 1 1      dense 7
  7: E(4,9)  = 1 0 0 1 0 0 1 0 0  sparse 9
  8: E(5,9)  = 1 0 1 0 1 0 1 0 1  medium 9
  9: E(7,12) = 1 0 1 0 1 0 1 0 1 0 1 1   dense compound
"""

import json
import os

# ============================================================
# HELPERS  (same conventions as anaerobes/build_patch.py)
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

def flonum(id, x=0, y=0, w=50):
    return box(id, "flonum", numinlets=1, numoutlets=2,
               outlettype=["", "bang"], x=x, y=y, w=w,
               extra={"format": 6, "parameter_enable": 0})

def intnum(id, x=0, y=0, w=50):
    return box(id, "number", numinlets=1, numoutlets=2,
               outlettype=["", "bang"], x=x, y=y, w=w,
               extra={"parameter_enable": 0})

def msg(id, text, x=0, y=0, w=None):
    return box(id, "message", text, numinlets=2, numoutlets=1,
               outlettype=[""], x=x, y=y, w=w or (len(text)*7+14))

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
# EUCLIDEAN PATTERNS  (pre-computed binary strings)
# ============================================================

PATTERNS = [
    (3, 8,  "1 0 0 1 0 0 1 0"),           # 0 E(3,8)  tresillo
    (5, 8,  "1 0 1 0 1 0 1 1"),           # 1 E(5,8)  cinquillo
    (2, 5,  "1 0 0 1 0"),                  # 2 E(2,5)  sparse5
    (3, 5,  "1 0 1 0 1"),                  # 3 E(3,5)  dense5
    (3, 7,  "1 0 0 1 0 0 1"),             # 4 E(3,7)  sparse7
    (4, 7,  "1 0 1 0 1 0 1"),             # 5 E(4,7)  medium7
    (5, 7,  "1 1 0 1 0 1 1"),             # 6 E(5,7)  dense7
    (4, 9,  "1 0 0 1 0 0 1 0 0"),         # 7 E(4,9)  sparse9
    (5, 9,  "1 0 1 0 1 0 1 0 1"),         # 8 E(5,9)  medium9
    (7, 12, "1 0 1 0 1 0 1 0 1 0 1 1"),   # 9 E(7,12) dense12
]
NUM_PATTERNS = len(PATTERNS)

# Voice section schedules { voice_idx: [(on_s, off_s, has_taper), ...] }
# on_s = section start in seconds, off_s = section end in seconds
# has_taper: if True the voice fades over 12s before going silent
VOICE_SCHEDULES = {
    1: [   # G1 enters 0:30, 4 sections × 90s, 30s breaks, taper at 8:00
        (30,  120, False),   # sec1: 0:30 → 2:00
        (150, 240, False),   # sec2: 2:30 → 4:00
        (270, 360, False),   # sec3: 4:30 → 6:00
        (390, 480, True),    # sec4: 6:30 → 8:00 (taper)
    ],
    2: [   # G2 enters 1:00, two 3:30 sections with 1:00 break
        (60,  270, False),   # secA: 1:00 → 4:30
        (330, 540, False),   # secB: 5:30 → 9:00 (no taper, hard close at 9:00)
    ],
    3: [   # G3 enters 1:30, three 2:30 sections, no gaps
        (90,  240, False),   # secA: 1:30 → 4:00
        (240, 390, False),   # secB: 4:00 → 6:30
        (390, 540, False),   # secC: 6:30 → 9:00
    ],
    4: [   # G4 enters 2:00, one 6:00 section, taper at 8:00
        (120, 480, True),    # sec1: 2:00 → 8:00 (taper)
    ],
}


# ============================================================
# BUILD PATCH
# ============================================================

boxes = []
lines = []

# Layout columns
COL_INPUT   =   50
COL_TIMER   =  300
COL_DETECT  =  600
COL_RECORD  =  900
COL_SCHED   = 1150
COL_ENGINE  = 1450
COL_PLAY    = 1750
COL_MIX     = 2050

ROW_HDR     =  20
ROW_TOP     =  50
VOICE_H     = 160   # vertical space per voice in scheduler section

# ============================================================
# SECTION 0: INIT / LOADBANG
# ============================================================

boxes.append(newobj("loadbang", "loadbang", 0, 1, ["bang"],
                     COL_INPUT, ROW_HDR, 70))
boxes.append(newobj("lb_delay", "delay 100", 2, 1, ["bang"],
                     COL_INPUT, ROW_HDR+30, 70))
boxes.append(msg("msg_startwindow", "startwindow", COL_INPUT, ROW_HDR+60, 90))
lines.append(line("loadbang", 0, "lb_delay", 0))
lines.append(line("lb_delay", 0, "msg_startwindow", 0))
lines.append(line("msg_startwindow", 0, "ezdac", 0))

# ============================================================
# SECTION 1: INPUT + AUDIO OUTPUT TOGGLE
# ============================================================

boxes.append(comment("lbl_input", "=== INPUT ===", COL_INPUT, ROW_TOP-10, 120))
boxes.append(newobj("ezdac", "ezdac~", 2, 0, [], COL_INPUT+150, ROW_TOP, 50))
boxes.append(comment("lbl_ezdac", "<-- enable audio", COL_INPUT+210, ROW_TOP+4, 120))

boxes.append(newobj("adc", "adc~ 1", 1, 1, ["signal"], COL_INPUT, ROW_TOP+30, 62))
boxes.append(comment("lbl_adc", "guitar in", COL_INPUT+70, ROW_TOP+34, 70))

# Dry pass-through (soft, center)
boxes.append(newobj("dry_gain", "*~ 0.3", 2, 1, ["signal"],
                     COL_INPUT, ROW_TOP+60, 60))
boxes.append(comment("lbl_dry", "dry (monitor)", COL_INPUT+70, ROW_TOP+64, 100))

lines.append(line("adc", 0, "dry_gain", 0))

# ============================================================
# SECTION 2: TIMER / CLICK
# ============================================================

boxes.append(comment("lbl_timer", "=== TIMER 80bpm / 9min ===", COL_TIMER, ROW_TOP-10, 200))

# START / STOP buttons
boxes.append(button("start_btn", COL_TIMER, ROW_TOP))
boxes.append(comment("lbl_start", "START", COL_TIMER+30, ROW_TOP+4, 50))
boxes.append(button("stop_btn", COL_TIMER+80, ROW_TOP))
boxes.append(comment("lbl_stop", "STOP", COL_TIMER+110, ROW_TOP+4, 50))

boxes.append(msg("msg_start", "1", COL_TIMER, ROW_TOP+32, 27))
boxes.append(msg("msg_stop",  "0", COL_TIMER+80, ROW_TOP+32, 27))

# Metro at quarter-note interval: 80bpm → 750ms
boxes.append(newobj("metro_qn", "metro 750", 2, 1, ["bang"],
                     COL_TIMER, ROW_TOP+60, 80))

# Subdivide to 8th note (×2) for Euclidean step resolution
boxes.append(newobj("metro_8th", "metro 375", 2, 1, ["bang"],
                     COL_TIMER+100, ROW_TOP+60, 80))

# Counter to track elapsed quarter notes
boxes.append(newobj("qn_counter", "counter", 5, 4,
                     ["int", "", "", "int"],
                     COL_TIMER, ROW_TOP+90, 70))

# Elapsed seconds display: quarter_notes * 750ms / 1000
boxes.append(newobj("qn_to_ms", "* 750", 2, 1, ["int"],
                     COL_TIMER, ROW_TOP+120, 60))
boxes.append(newobj("ms_to_sec", "/ 1000.", 2, 1, ["float"],
                     COL_TIMER, ROW_TOP+150, 70))
boxes.append(flonum("time_disp", COL_TIMER, ROW_TOP+180, 65))
boxes.append(comment("lbl_tsec", "seconds", COL_TIMER+70, ROW_TOP+184, 60))

# Also show minutes
boxes.append(newobj("sec_to_min", "/ 60.", 2, 1, ["float"],
                     COL_TIMER+150, ROW_TOP+150, 55))
boxes.append(flonum("min_disp", COL_TIMER+150, ROW_TOP+180, 60))
boxes.append(comment("lbl_tmin", "min", COL_TIMER+215, ROW_TOP+184, 30))

# BPM display / edit
# FIX 5a: bpm_num was disconnected. Wire it so changing it updates both metros.
# bpm_num holds ms-per-quarter-note (750 = 80bpm). Right inlet of metro sets interval.
boxes.append(comment("lbl_bpm", "BPM (ms/qn):", COL_TIMER, ROW_TOP+215, 90))
boxes.append(intnum("bpm_num", COL_TIMER+95, ROW_TOP+215, 50))
boxes.append(msg("msg_bpm_init", "750", COL_TIMER+95, ROW_TOP+243, 40))  # default at loadbang
boxes.append(msg("msg_bpm_qn",  "750", COL_TIMER+38, ROW_TOP+243, 40))
boxes.append(msg("msg_bpm_8th", "375", COL_TIMER+85, ROW_TOP+243, 40))
boxes.append(newobj("bpm_half", "/ 2", 2, 1, ["int"],
                     COL_TIMER+95, ROW_TOP+270, 35))

# ------- AUDIO CLICK (quarter note) -------
# Short sine burst at 880Hz on each quarter note
boxes.append(newobj("click_cycle", "cycle~ 880", 1, 1, ["signal"],
                     COL_TIMER, ROW_TOP+280, 90))
boxes.append(newobj("click_env", "adsr~ 2 20 0. 10", 4, 1, ["signal"],
                     COL_TIMER, ROW_TOP+310, 140))
boxes.append(newobj("click_mult", "*~", 2, 1, ["signal"],
                     COL_TIMER, ROW_TOP+340, 40))
boxes.append(newobj("click_gain", "*~ 0.15", 2, 1, ["signal"],
                     COL_TIMER, ROW_TOP+370, 70))
# trigger adsr on each quarter beat
boxes.append(msg("msg_click_trig", "880", COL_TIMER+50, ROW_TOP+280, 45))
# click level toggle
boxes.append(toggle_box("click_toggle", COL_TIMER+100, ROW_TOP+370))
boxes.append(comment("lbl_click_tog", "click on/off", COL_TIMER+130, ROW_TOP+374, 90))

# Timer wiring
lines.append(line("start_btn",  0, "msg_start", 0))
lines.append(line("stop_btn",   0, "msg_stop",  0))
lines.append(line("msg_start",  0, "metro_qn",  0))
lines.append(line("msg_stop",   0, "metro_qn",  0))
lines.append(line("msg_start",  0, "metro_8th", 0))
lines.append(line("msg_stop",   0, "metro_8th", 0))
lines.append(line("msg_stop",   0, "qn_counter", 3))
lines.append(line("metro_qn",   0, "qn_counter", 0))
lines.append(line("qn_counter", 0, "qn_to_ms", 0))
lines.append(line("qn_to_ms",   0, "ms_to_sec", 0))
lines.append(line("ms_to_sec",  0, "time_disp", 0))
lines.append(line("ms_to_sec",  0, "sec_to_min", 0))
lines.append(line("sec_to_min", 0, "min_disp",  0))

# Click audio wiring
lines.append(line("metro_qn",    0, "click_env",   0))
lines.append(line("click_cycle", 0, "click_mult",  0))
lines.append(line("click_env",   0, "click_mult",  1))
lines.append(line("click_mult",  0, "click_gain",  0))
lines.append(line("click_toggle",0, "click_gain",  1))
# FIX 5a: bpm_num -> both metros; default 750 fired at loadbang
lines.append(line("bpm_num",      0, "bpm_half",     0))
lines.append(line("bpm_num",      0, "metro_qn",     1))  # right inlet sets interval
lines.append(line("bpm_half",     0, "metro_8th",    1))
lines.append(line("loadbang",     0, "msg_bpm_init", 0))
lines.append(line("msg_bpm_init", 0, "bpm_num",      0))

# ============================================================
# SECTION 3: PITCH DETECTION  (active 0–30s)
# ============================================================

boxes.append(comment("lbl_detect", "=== PITCH DETECTION (0-30s) ===",
                      COL_DETECT, ROW_TOP-10, 230))

# Gate: only pass signal while time < 30s
boxes.append(newobj("detect_lt", "< 30.", 2, 1, ["int"],
                     COL_DETECT, ROW_TOP+20, 55))
boxes.append(newobj("detect_gate", "*~", 2, 1, ["signal"],
                     COL_DETECT, ROW_TOP+50, 40))

# yin~ for monophonic pitch detection (IRCAM / Max Sound Box):
# outlet 0 = Hz (control-rate float), outlet 1 = confidence (float).
# Do not use ftom~/snapshot~ on pitch — those expect MSP signal; yin~ Hz is not signal-rate here.
boxes.append(newobj("yin", "yin~ 2048 0.9", 1, 2, ["float", "float"],
                     COL_DETECT, ROW_TOP+80, 110))

# Hz → MIDI note (control-rate)
boxes.append(newobj("ftom_detect", "ftom", 1, 1, ["float"],
                     COL_DETECT, ROW_TOP+110, 50))

# Only pass MIDI keys into histogram when confidence > 0.85
boxes.append(newobj("conf_gt", "> 0.85", 2, 1, ["int"],
                     COL_DETECT+110, ROW_TOP+140, 65))
boxes.append(newobj("gate_hist", "gate", 2, 1, [""],
                     COL_DETECT+60, ROW_TOP+200, 45))

# Round to nearest semitone (int) and store freq
boxes.append(newobj("round_midi", "round", 2, 1, ["float"],
                     COL_DETECT, ROW_TOP+170, 55))
boxes.append(newobj("int_midi", "int", 1, 2, ["int", "bang"],
                     COL_DETECT, ROW_TOP+200, 35))

# Two colls share storage name "note_hist": read without write feedback; write list key count.
# Histogram: lookup count (0 if missing), +1, send "list key newcount" to single coll inlet.
boxes.append(newobj("note_hist_r", "coll note_hist", 1, 3, ["", "", ""],
                     COL_DETECT, ROW_TOP+230, 120))
boxes.append(newobj("note_hist_w", "coll note_hist", 1, 3, ["", "", ""],
                     COL_DETECT+135, ROW_TOP+230, 120))
boxes.append(newobj("hist_t_a", "trigger i i", 1, 2, ["", ""],
                     COL_DETECT+265, ROW_TOP+200, 70))
boxes.append(newobj("hist_t_b", "trigger i b", 1, 2, ["", "bang"],
                     COL_DETECT+350, ROW_TOP+200, 75))
boxes.append(newobj("hist_t_c", "trigger b i", 1, 2, ["bang", ""],
                     COL_DETECT+435, ROW_TOP+200, 75))
boxes.append(msg("hist_f_zero", "0.", COL_DETECT+435, ROW_TOP+228, 32))
boxes.append(newobj("hist_delay", "delay 0", 2, 1, ["bang"],
                     COL_DETECT+525, ROW_TOP+228, 65))
boxes.append(newobj("hist_f", "f", 2, 1, ["float"],
                     COL_DETECT+435, ROW_TOP+255, 45))
boxes.append(newobj("hist_inc", "+ 1", 2, 1, ["int"],
                     COL_DETECT+600, ROW_TOP+255, 35))
boxes.append(newobj("hist_join", "join @triggers 2", 2, 1, [""],
                     COL_DETECT+535, ROW_TOP+285, 120))

# Status display
boxes.append(comment("lbl_detect_st", "pitch→MIDI→histogram",
                      COL_DETECT, ROW_TOP+290, 160))

# "LOCK POOL" button – manually triggered at 30s (also auto-fires from scheduler)
boxes.append(button("lock_pool_btn", COL_DETECT+170, ROW_TOP+20))
boxes.append(comment("lbl_lock", "LOCK POOL (auto@30s)", COL_DETECT+200, ROW_TOP+24, 150))

# The 5-note pool: top 5 detected notes stored in pool_coll
boxes.append(newobj("pool_coll", "coll pool_notes", 1, 3, ["", "", ""],
                     COL_DETECT+170, ROW_TOP+80, 120))

# FIX 1b: wire pool_coll and ref_hz.
# At lock: dump note_hist -> route first 5 items into pool_coll (indices 0-4).
# Then fetch pool_coll key 0 -> mtof -> ref_hz (most-detected note as reference pitch).
boxes.append(msg("msg_hist_dump", "dump", COL_DETECT+170, ROW_TOP+55, 45))
boxes.append(newobj("pool_count", "counter 0 4", 5, 4, ["int", "", "", "int"],
                     COL_DETECT+230, ROW_TOP+80, 80))
boxes.append(newobj("pool_store_pack", "pak 0 0", 2, 1, [""],
                     COL_DETECT+320, ROW_TOP+80, 60))
boxes.append(newobj("pool_store_msg", "prepend store", 1, 1, [""],
                     COL_DETECT+390, ROW_TOP+80, 90))
boxes.append(msg("msg_fetch_ref", "0", COL_DETECT+170, ROW_TOP+115, 27))
boxes.append(newobj("mtof_ref", "mtof", 1, 1, ["float"],
                     COL_DETECT+210, ROW_TOP+115, 45))
lines.append(line("lock_pool_btn",   0, "msg_hist_dump",   0))
lines.append(line("msg_hist_dump",   0, "note_hist_r",     0))
lines.append(line("note_hist_r",     0, "pool_count",      0))
lines.append(line("pool_count",      0, "pool_store_pack", 0))
lines.append(line("note_hist_r",     0, "pool_store_pack", 1))
lines.append(line("pool_store_pack", 0, "pool_store_msg",  0))
lines.append(line("pool_store_msg",  0, "pool_coll",       0))
lines.append(line("lock_pool_btn",   0, "msg_fetch_ref",   0))
lines.append(line("msg_fetch_ref",   0, "pool_coll",       0))
lines.append(line("pool_coll",       0, "mtof_ref",        0))
lines.append(line("mtof_ref",        0, "ref_hz",          0))

# Detection wiring
lines.append(line("ms_to_sec",   0, "detect_lt",   0))
lines.append(line("detect_lt",   0, "detect_gate", 1))
lines.append(line("adc",         0, "detect_gate", 0))
lines.append(line("detect_gate", 0, "yin",         0))
lines.append(line("yin",         0, "ftom_detect", 0))
lines.append(line("yin",         1, "conf_gt",     0))
lines.append(line("ftom_detect", 0, "round_midi",  0))
lines.append(line("round_midi",  0, "int_midi",    0))
# Histogram only when confidence gate opens (same tick as int_midi updates).
lines.append(line("int_midi",    0, "gate_hist",   0))
lines.append(line("conf_gt",     0, "gate_hist",   1))
lines.append(line("gate_hist",   0, "hist_t_a",    0))
lines.append(line("hist_t_a",    1, "hist_join",   0))   # K -> join inlet 0 (fires first)
lines.append(line("hist_t_a",    0, "hist_t_b",    0))
lines.append(line("hist_t_b",    1, "hist_f_zero", 0))   # reset tally: f := 0 before lookup
lines.append(line("hist_f_zero", 0, "hist_f",      1))
lines.append(line("hist_t_b",    0, "hist_t_c",    0))
lines.append(line("hist_t_c",    1, "note_hist_r", 0))   # recall count (missing key -> no write to f)
lines.append(line("hist_t_c",    0, "hist_delay",  0))   # then bang f after stack clears
lines.append(line("note_hist_r", 0, "hist_f",      1))   # hit -> f := C
lines.append(line("hist_delay",  0, "hist_f",      0))   # output tally (0 if miss)
lines.append(line("hist_f",      0, "hist_inc",    0))
lines.append(line("hist_inc",    0, "hist_join",   1))
lines.append(line("hist_join",   0, "note_hist_w", 0))

# ============================================================
# SECTION 4: RECORD BUFFER (0–30s)
# ============================================================

boxes.append(comment("lbl_record", "=== RECORD BUFFER (0-30s) ===",
                      COL_RECORD, ROW_TOP-10, 220))

# buffer~ to hold 30s mono recording
# 30000ms @ 44100Hz
boxes.append(newobj("rec_buf", "buffer~ lapopie_rec 30000",
                     1, 0, [], COL_RECORD, ROW_TOP+20, 200))

# record~ writes when gate is open
boxes.append(newobj("record", "record~ lapopie_rec", 3, 1, [""],
                     COL_RECORD, ROW_TOP+55, 160))

# Gate from detect (same < 30s gate reused)
# record~ inlet 0 = signal, inlet 2 = on/off
boxes.append(msg("msg_rec_on",  "1", COL_RECORD+170, ROW_TOP+20, 27))
boxes.append(msg("msg_rec_off", "0", COL_RECORD+205, ROW_TOP+20, 27))
boxes.append(comment("lbl_rec_gate", "auto-gated via scheduler",
                      COL_RECORD+170, ROW_TOP+50, 170))

# Display: recording indicator
boxes.append(toggle_box("rec_indicator", COL_RECORD, ROW_TOP+90))
boxes.append(comment("lbl_rec_ind", "REC active", COL_RECORD+30, ROW_TOP+94, 70))

# wiring
lines.append(line("adc",    0, "record", 0))  # signal
lines.append(line("detect_lt", 0, "record", 2)) # gate: 1 while time<30

# ============================================================
# SECTION 5: VOICE SCHEDULER
# ============================================================

boxes.append(comment("lbl_sched", "=== VOICE SCHEDULER ===",
                      COL_SCHED, ROW_TOP-10, 180))

# The scheduler checks elapsed seconds against each voice's section table.
# For each voice we use a sel to detect the exact second thresholds.
# Approach: ms_to_sec rounded to int -> compare via == for each boundary second.
boxes.append(newobj("sched_round", "round", 2, 1, ["float"],
                     COL_SCHED, ROW_TOP+20, 55))
boxes.append(newobj("sched_int", "int", 1, 2, ["int", "bang"],
                     COL_SCHED, ROW_TOP+50, 35))
# Only fire on new integer value (change object)
boxes.append(newobj("sched_change", "change", 1, 1, ["int"],
                     COL_SCHED, ROW_TOP+80, 60))

lines.append(line("ms_to_sec",    0, "sched_round",  0))
lines.append(line("sched_round",  0, "sched_int",    0))
lines.append(line("sched_int",    0, "sched_change", 0))

# Collect ALL boundary seconds across all voices
# Format: set of (second, voice_idx, event_type)
# event_type: "on" = section start (pick new pattern, new note order)
#             "off" = section end (silence voice)
#             "taper" = begin fade-out

all_events = {}   # second -> [(voice, type)]
for vidx, sections in VOICE_SCHEDULES.items():
    for (on_s, off_s, has_taper) in sections:
        all_events.setdefault(on_s,  []).append((vidx, "on"))
        if has_taper:
            all_events.setdefault(off_s - 12, []).append((vidx, "taper"))
        all_events.setdefault(off_s, []).append((vidx, "off"))

# Auto-lock pitch pool at 30s
all_events.setdefault(30, []).append((0, "lock_pool"))

# Auto-stop at 540s (9:00)
all_events.setdefault(540, []).append((0, "stop"))

# Build sel for all unique seconds
all_seconds = sorted(all_events.keys())
sel_args = " ".join(str(s) for s in all_seconds)
boxes.append(newobj("sched_sel", f"sel {sel_args}",
                     1, len(all_seconds) + 1, ["bang"] * (len(all_seconds) + 1),
                     COL_SCHED, ROW_TOP+110, max(200, len(sel_args)*7+30)))

lines.append(line("sched_change", 0, "sched_sel", 0))

# For each event, wire sel outlet to appropriate voice control message
for outlet_idx, second in enumerate(all_seconds):
    events = all_events[second]
    for (vidx, etype) in events:
        if etype == "lock_pool":
            boxes.append(msg(f"msg_lock_{second}", "bang",
                             COL_SCHED + 200, ROW_TOP + 110 + outlet_idx * 22, 40))
            lines.append(line("sched_sel", outlet_idx, f"msg_lock_{second}", 0))
            lines.append(line(f"msg_lock_{second}", 0, "lock_pool_btn", 0))
        elif etype == "stop":
            boxes.append(msg(f"msg_auto_stop", "0",
                             COL_SCHED + 260, ROW_TOP + 110 + outlet_idx * 22, 27))
            lines.append(line("sched_sel", outlet_idx, "msg_auto_stop", 0))
            lines.append(line("msg_auto_stop", 0, "metro_qn",  0))
            lines.append(line("msg_auto_stop", 0, "metro_8th", 0))
        elif etype == "on":
            boxes.append(msg(f"msg_v{vidx}_on_{second}", f"on {vidx}",
                             COL_SCHED + 200 + vidx * 50,
                             ROW_TOP + 110 + outlet_idx * 22, 50))
            lines.append(line("sched_sel", outlet_idx, f"msg_v{vidx}_on_{second}", 0))
            lines.append(line(f"msg_v{vidx}_on_{second}", 0, f"voice_ctrl_{vidx}", 0))
        elif etype == "off":
            boxes.append(msg(f"msg_v{vidx}_off_{second}", f"off {vidx}",
                             COL_SCHED + 200 + vidx * 50,
                             ROW_TOP + 150 + outlet_idx * 22, 55))
            lines.append(line("sched_sel", outlet_idx, f"msg_v{vidx}_off_{second}", 0))
            lines.append(line(f"msg_v{vidx}_off_{second}", 0, f"voice_ctrl_{vidx}", 0))
        elif etype == "taper":
            boxes.append(msg(f"msg_v{vidx}_taper_{second}", f"taper {vidx}",
                             COL_SCHED + 200 + vidx * 50,
                             ROW_TOP + 190 + outlet_idx * 22, 60))
            lines.append(line("sched_sel", outlet_idx, f"msg_v{vidx}_taper_{second}", 0))
            lines.append(line(f"msg_v{vidx}_taper_{second}", 0, f"voice_ctrl_{vidx}", 0))

# ============================================================
# SECTION 6: EUCLIDEAN ENGINE + VOICE CONTROLLERS
# ============================================================
#
# Per voice:
#   voice_ctrl_N  – route receives "on N" / "off N" / "taper N"
#   On "on":
#     1. pick random pattern from bank (not same as last)
#     2. shuffle 5-note pool order (send to note_order coll for this voice)
#     3. enable step sequencer (toggle)
#   On "off": disable step sequencer, silence voice
#   On "taper": ramp volume to 0 over 12s
#
# Step sequencer:
#   metro_8th -> step_counter -> index into current pattern (coll)
#   if step == 1: fire note (index into note_order, wrap via mod 5)
#   note -> mtof -> groove~ playback-rate calculation

boxes.append(comment("lbl_engine", "=== EUCLIDEAN ENGINE ===",
                      COL_ENGINE, ROW_TOP-10, 200))

# Pattern bank coll (shared, read-only after init)
# Storage scheme: key = pat_id * 100 + step_idx, value = 0 or 1
# e.g. pattern 0 step 3 -> key 3, pattern 2 step 1 -> key 201
# This allows direct lookup: step_key expr = cur_pat*100 + step_idx -> coll -> 0 or 1
boxes.append(newobj("pat_bank", "coll pat_bank",
                     1, 3, ["", "", ""],
                     COL_ENGINE, ROW_TOP+20, 100))

# Also store pattern lengths separately: key = pat_id + 900, value = length (n)
# Used to set the step counter range when a new pattern is chosen.

# Build individual step store messages for each pattern
# Format: "key, value ;" sent to pat_bank
all_pat_msgs = []
for pidx, (k, n, bits) in enumerate(PATTERNS):
    steps = [int(x) for x in bits.split()]
    for sidx, val in enumerate(steps):
        key = pidx * 100 + sidx
        mid = COL_ENGINE + 110 + (pidx % 5) * 200
        miy = ROW_TOP + 20 + (pidx * len(steps) + sidx) * 14
        mid_id = f"msg_step_{pidx}_{sidx}"
        boxes.append(msg(mid_id, f"{key}, {val} ;", mid, miy, 80))
        all_pat_msgs.append(mid_id)
    # Store pattern length under key 900+pidx
    len_id = f"msg_patlen_{pidx}"
    boxes.append(msg(len_id, f"{900 + pidx}, {n} ;",
                     COL_ENGINE + 110, ROW_TOP + 20 + pidx * 14, 80))
    all_pat_msgs.append(len_id)

# Loadbang-driven init: one trigger outlet per store message, fired right-to-left
n_msgs = len(all_pat_msgs)
trig_args = " ".join(["bang"] * n_msgs)
boxes.append(newobj("pat_init_lb", "loadbang", 0, 1, ["bang"],
                     COL_ENGINE + 400, ROW_TOP + 20, 70))
boxes.append(newobj("pat_init_delay", "delay 200", 2, 1, ["bang"],
                     COL_ENGINE + 400, ROW_TOP + 50, 70))
boxes.append(newobj("pat_init_trig", f"trigger {trig_args}",
                     1, n_msgs, ["bang"] * n_msgs,
                     COL_ENGINE + 400, ROW_TOP + 80, min(600, n_msgs * 45 + 60)))
lines.append(line("pat_init_lb",    0, "pat_init_delay", 0))
lines.append(line("pat_init_delay", 0, "pat_init_trig",  0))
for i, mid_id in enumerate(all_pat_msgs):
    # trigger fires right-to-left, so outlet (n_msgs-1-i) fires msg i
    lines.append(line("pat_init_trig", n_msgs - 1 - i, mid_id, 0))
    lines.append(line(mid_id, 0, "pat_bank", 0))

# NOTE POOL coll (pool_coll already defined in DETECT section)
# Voice-specific note-order colls
for vidx in range(1, 5):
    boxes.append(newobj(f"note_order_{vidx}", f"coll note_order_{vidx}",
                         1, 3, ["", "", ""],
                         COL_ENGINE, ROW_TOP + 250 + (vidx-1) * VOICE_H, 140))

# ============================================================
# Per-voice control + step sequencer
# ============================================================

VOICE_PANS  = {1: 25., 2: -25., 3: 50., 4: -50.}
VOICE_VOLS  = {1: 0.82, 2: 0.78, 3: 0.72, 4: 0.68}

for vidx in range(1, 5):
    vx  = COL_ENGINE
    vy  = ROW_TOP + 250 + (vidx - 1) * VOICE_H
    pan = VOICE_PANS[vidx]
    vol = VOICE_VOLS[vidx]

    boxes.append(comment(f"lbl_vc_{vidx}", f"--- VOICE G{vidx} (pan={pan}, vol={vol}) ---",
                          vx, vy - 18, 220))

    # voice_ctrl: route "on N" / "off N" / "taper N" → correct voice
    boxes.append(newobj(f"voice_ctrl_{vidx}",
                         f"route on off taper",
                         1, 4, ["", "", "", ""],
                         vx, vy, 110))

    # Random pattern selector (0..9, no immediate repeat)
    boxes.append(newobj(f"rand_pat_{vidx}", f"random {NUM_PATTERNS}",
                         1, 1, ["int"],
                         vx + 120, vy, 70))
    boxes.append(newobj(f"pat_last_{vidx}", "i",
                         1, 1, ["int"],
                         vx + 200, vy, 30))  # stores last pattern idx
    # If rand == last: subtract (gives 0 when equal) -> sel 0 detects match
    boxes.append(newobj(f"pat_eq_{vidx}", "==",
                         2, 1, ["int"],
                         vx + 240, vy, 40))
    boxes.append(newobj(f"pat_dedup_{vidx}", "sel 1",
                         2, 2, ["bang", ""],
                         vx + 290, vy, 50))
    boxes.append(newobj(f"pat_inc_{vidx}", f"+ 1",
                         2, 1, ["int"],
                         vx + 300, vy, 40))
    boxes.append(newobj(f"pat_mod_{vidx}", f"% {NUM_PATTERNS}",
                         2, 1, ["int"],
                         vx + 345, vy, 55))

    # Chosen pattern index stored in int, then fetch from pat_bank
    boxes.append(newobj(f"cur_pat_{vidx}", "i",
                         1, 1, ["int"],
                         vx + 405, vy, 30))
    boxes.append(newobj(f"pat_fetch_{vidx}", "route",
                         1, 2, ["", ""],
                         vx + 440, vy, 55))

    # Step counter (8th-note driven) – upper bound set from pattern length at "on" time
    # Default 0 7 (length 8) matching E(3,8); overwritten per pattern.
    boxes.append(newobj(f"step_ctr_{vidx}", f"counter 0 7",
                         5, 4, ["int", "", "", "int"],
                         vx + 505, vy, 85))

    # When a new pattern is chosen, fetch its length from pat_bank (key 900+pat_idx)
    # and set the step counter upper bound. key = 900 + cur_pat.
    boxes.append(newobj(f"patlen_key_{vidx}", f"+ 900",
                         2, 1, ["int"],
                         vx + 405, vy + 30, 55))
    boxes.append(newobj(f"patlen_fetch_{vidx}", "coll pat_bank",
                         1, 3, ["", "", ""],
                         vx + 465, vy + 30, 100))
    # step counter "setmax N" message: prepend "setmax"
    boxes.append(newobj(f"patlen_sub1_{vidx}", "- 1",
                         2, 1, ["int"],
                         vx + 570, vy + 30, 40))
    boxes.append(newobj(f"patlen_setmax_{vidx}", "prepend setmax",
                         1, 1, [""],
                         vx + 618, vy + 30, 90))

    # Gate toggle: on/off controlled by scheduler
    boxes.append(toggle_box(f"step_gate_{vidx}", vx + 600, vy))
    boxes.append(comment(f"lbl_sg_{vidx}", "gate", vx + 630, vy + 4, 35))

    # Pattern step lookup: fetch current step from note_order coll
    # step_ctr -> fetch pattern step from stored pattern list
    boxes.append(newobj(f"step_fetch_{vidx}", "coll pat_bank",
                         1, 3, ["", "", ""],
                         vx + 505, vy + 30, 100))

    # Parse the retrieved step bits — the coll returns the full symbol string
    # We use a js helper OR we store patterns already indexed.
    # SIMPLER: we store each individual step directly:
    #   pat_bank key=(pat_id * 100 + step) value=(0 or 1)
    # The step counter just outputs step_idx, we compute the coll key via expr.
    boxes.append(newobj(f"step_key_{vidx}",
                         f"expr $i1 * 100 + $i2",
                         2, 1, ["int"],
                         vx + 505, vy + 60, 140))
    # cur_pat stored in int for use in expr
    boxes.append(newobj(f"cur_pat_i_{vidx}", "i",
                         1, 1, ["int"],
                         vx + 405, vy + 60, 30))

    # Fetch the 0/1 value from pat_bank using computed key
    boxes.append(newobj(f"step_lookup_{vidx}", "coll pat_bank",
                         1, 3, ["", "", ""],
                         vx + 650, vy + 30, 100))
    boxes.append(newobj(f"step_sel_{vidx}", "sel 1",
                         2, 2, ["bang", ""],
                         vx + 760, vy + 30, 50))

    # Note index cycles 0..4 per hit
    boxes.append(newobj(f"note_ctr_{vidx}", "counter 0 4",
                         5, 4, ["int", "", "", "int"],
                         vx + 820, vy + 30, 85))
    boxes.append(newobj(f"note_key_{vidx}", "i",
                         1, 1, ["int"],
                         vx + 910, vy + 30, 30))

    # Fetch MIDI note from note_order coll
    boxes.append(newobj(f"note_fetch_{vidx}", f"coll note_order_{vidx}",
                         1, 3, ["", "", ""],
                         vx + 950, vy + 30, 130))

    # MIDI → Hz (mtof)
    boxes.append(newobj(f"mtof_{vidx}", "mtof",
                         1, 1, ["float"],
                         vx + 1085, vy + 30, 50))

    boxes.append(comment(f"lbl_v{vidx}_end", f"→ to playback G{vidx}",
                          vx + 1140, vy + 30, 120))

    # ---- Voice on/off/taper routing ----
    # FIX 2+3: route strips its selector and passes the bare voice-index int (1..4).
    # Sending that int to a toggle sets it to 1 regardless of on/off (both non-zero).
    # Sending it to random's left inlet sets its upper bound instead of triggering it.
    # Fix: split "on" through a trigger to get a clean bang for rand and a 1-msg for toggle.
    boxes.append(newobj(f"on_trig_{vidx}", "trigger bang bang",
                         1, 2, ["bang", "bang"],
                         vx, vy + 25, 110))
    boxes.append(msg(f"msg_gate_on_{vidx}",  "1", vx + 120, vy + 25, 27))
    boxes.append(msg(f"msg_gate_off_{vidx}", "0", vx + 120, vy + 50, 27))

    lines.append(line(f"voice_ctrl_{vidx}",  0, f"on_trig_{vidx}",    0))  # on -> trigger
    lines.append(line(f"on_trig_{vidx}",     1, f"msg_gate_on_{vidx}", 0)) # R outlet: 1
    lines.append(line(f"msg_gate_on_{vidx}", 0, f"step_gate_{vidx}",   0))
    lines.append(line(f"on_trig_{vidx}",     0, f"rand_pat_{vidx}",    0)) # L outlet: bang

    lines.append(line(f"rand_pat_{vidx}",   0, f"pat_eq_{vidx}",    0))  # rand result -> ==
    lines.append(line(f"pat_last_{vidx}",   0, f"pat_eq_{vidx}",    1))  # last -> == right
    lines.append(line(f"pat_eq_{vidx}",     0, f"pat_dedup_{vidx}", 0))  # 1=match->bang
    # duplicate (sel 1 outlet 0 = bang): increment and mod-wrap
    lines.append(line(f"pat_dedup_{vidx}",  0, f"pat_inc_{vidx}",   0))
    lines.append(line(f"pat_inc_{vidx}",    0, f"pat_mod_{vidx}",   0))
    lines.append(line(f"pat_mod_{vidx}",    0, f"cur_pat_{vidx}",   0))
    # not duplicate (sel 1 outlet 1 = passthrough int): use directly
    lines.append(line(f"pat_dedup_{vidx}",  1, f"cur_pat_{vidx}",   0))
    # save chosen pattern as last
    lines.append(line(f"cur_pat_{vidx}",    0, f"pat_last_{vidx}",  0))
    lines.append(line(f"cur_pat_{vidx}",    0, f"cur_pat_i_{vidx}", 0))
    # fetch pattern length and update step counter upper bound
    lines.append(line(f"cur_pat_{vidx}",    0, f"patlen_key_{vidx}",   0))
    lines.append(line(f"patlen_key_{vidx}", 0, f"patlen_fetch_{vidx}", 0))
    lines.append(line(f"patlen_fetch_{vidx}",0,f"patlen_sub1_{vidx}",  0))
    lines.append(line(f"patlen_sub1_{vidx}", 0,f"patlen_setmax_{vidx}",0))
    lines.append(line(f"patlen_setmax_{vidx}",0,f"step_ctr_{vidx}",    0))

    # off -> send 0 to toggle, reset step counter
    lines.append(line(f"voice_ctrl_{vidx}",   1, f"msg_gate_off_{vidx}", 0))
    lines.append(line(f"msg_gate_off_{vidx}", 0, f"step_gate_{vidx}",    0))
    lines.append(line(f"voice_ctrl_{vidx}",   1, f"step_ctr_{vidx}",     3))  # reset

    # metro_8th → gate → step counter
    # (gate = multiply by 0/1 via *; simpler: use gate object)
    boxes.append(newobj(f"gate_obj_{vidx}", "gate 1",
                         2, 1, ["bang"],
                         vx + 600, vy + 30, 55))
    lines.append(line(f"step_gate_{vidx}", 0, f"gate_obj_{vidx}", 0))
    lines.append(line("metro_8th",         0, f"gate_obj_{vidx}", 1))
    lines.append(line(f"gate_obj_{vidx}",  0, f"step_ctr_{vidx}", 0))

    # step counter → key calc
    lines.append(line(f"step_ctr_{vidx}",  0, f"step_key_{vidx}", 1))
    lines.append(line(f"cur_pat_i_{vidx}", 0, f"step_key_{vidx}", 0))
    lines.append(line(f"step_key_{vidx}",  0, f"step_lookup_{vidx}", 0))
    lines.append(line(f"step_lookup_{vidx}",0, f"step_sel_{vidx}",   0))

    # hit → note counter → note fetch → mtof
    lines.append(line(f"step_sel_{vidx}",  0, f"note_ctr_{vidx}",   0))
    lines.append(line(f"note_ctr_{vidx}",  0, f"note_key_{vidx}",   0))
    lines.append(line(f"note_key_{vidx}",  0, f"note_fetch_{vidx}", 0))
    lines.append(line(f"note_fetch_{vidx}",0, f"mtof_{vidx}",       0))

# ============================================================
# SECTION 7: PLAYBACK via groove~ (rate-shifted buffer)
# ============================================================
#
# Reference pitch: stored at pool_coll index 0 (most-common note →Hz)
# Rate = target_hz / reference_hz
# groove~ plays the 30s buffer at computed rate producing looping
# Short grain windows (400ms) via start point randomization.
# Volume modulated by gate status.

boxes.append(comment("lbl_play", "=== PLAYBACK ===",
                      COL_PLAY, ROW_TOP-10, 160))

# Reference pitch box (set at pool-lock time)
boxes.append(flonum("ref_hz", COL_PLAY, ROW_TOP+20, 70))
boxes.append(comment("lbl_ref", "ref hz (pool[0])",
                      COL_PLAY+80, ROW_TOP+24, 110))

for vidx in range(1, 5):
    vx  = COL_PLAY
    vy  = ROW_TOP + 60 + (vidx - 1) * VOICE_H
    pan = VOICE_PANS[vidx]
    vol = VOICE_VOLS[vidx]

    boxes.append(comment(f"lbl_play_{vidx}", f"G{vidx}",
                          vx, vy - 18, 30))

    # Rate calculation: target_hz / ref_hz
    boxes.append(newobj(f"rate_div_{vidx}", "/ 1.",
                         2, 1, ["float"],
                         vx, vy, 55))
    # ref_hz feeds right inlet
    boxes.append(newobj(f"rate_pack_{vidx}", "pack 0. 50",
                         2, 1, [""],
                         vx, vy + 30, 70))
    boxes.append(newobj(f"rate_line_{vidx}", "line 1. 50",
                         2, 1, ["signal"],
                         vx, vy + 60, 80))

    # groove~ plays lapopie_rec buffer
    boxes.append(newobj(f"groove_{vidx}", "groove~ lapopie_rec",
                         2, 2, ["signal", "signal"],
                         vx, vy + 95, 150))

    # Random start position for each hit (0 to 20000ms to avoid edge)
    boxes.append(newobj(f"start_rand_{vidx}", "random 20000",
                         1, 1, ["int"],
                         vx + 160, vy, 90))
    boxes.append(newobj(f"start_float_{vidx}", "i",
                         1, 1, ["int"],
                         vx + 160, vy + 30, 30))
    # Set loop start: message "loopstart <n>"
    boxes.append(msg(f"msg_loopst_{vidx}", "loopstart $1",
                      vx + 160, vy + 60, 110))
    # Set loop duration: 400ms grain
    boxes.append(msg(f"msg_loopdur_{vidx}", "loopdur 400",
                      vx + 160, vy + 90, 100))
    # Trigger new start on each Euclidean hit
    lines.append(line(f"step_sel_{vidx}",   0, f"start_rand_{vidx}",  0))
    lines.append(line(f"start_rand_{vidx}", 0, f"start_float_{vidx}", 0))
    lines.append(line(f"start_float_{vidx}",0, f"msg_loopst_{vidx}",  0))
    lines.append(line(f"msg_loopst_{vidx}",  0, f"groove_{vidx}",      0))
    lines.append(line(f"msg_loopdur_{vidx}", 0, f"groove_{vidx}",      0))
    # FIX 4: msg_loopdur was never triggered. Fire it at loadbang so the
    # 400ms grain window is set before any playback begins.
    boxes.append(newobj(f"lb_loopdur_{vidx}", "loadbang", 0, 1, ["bang"],
                         vx + 160, vy + 115, 70))
    lines.append(line(f"lb_loopdur_{vidx}", 0, f"msg_loopdur_{vidx}", 0))

    # Rate line → groove
    lines.append(line(f"rate_line_{vidx}",  0, f"groove_{vidx}",      1))

    # mtof output → rate_div right inlet
    lines.append(line(f"mtof_{vidx}",       0, f"rate_div_{vidx}",    0))
    lines.append(line("ref_hz",             0, f"rate_div_{vidx}",    1))
    lines.append(line(f"rate_div_{vidx}",   0, f"rate_pack_{vidx}",   0))
    lines.append(line(f"rate_pack_{vidx}",  0, f"rate_line_{vidx}",   0))

    # Volume with gate-driven envelope and taper
    boxes.append(newobj(f"vol_sig_{vidx}", f"*~ {vol}",
                         2, 1, ["signal"],
                         vx, vy + 130, 65))
    # Gate envelope: line~ for smooth on/off
    boxes.append(newobj(f"vol_env_{vidx}", "line~ 0.",
                         2, 2, ["signal", "bang"],
                         vx + 80, vy + 130, 70))
    boxes.append(msg(f"msg_vol_on_{vidx}",    f"{vol} 30",
                      vx + 80, vy + 105, 60))
    boxes.append(msg(f"msg_vol_off_{vidx}",   "0. 50",
                      vx + 150, vy + 105, 55))
    boxes.append(msg(f"msg_vol_taper_{vidx}", "0. 12000",
                      vx + 215, vy + 105, 75))

    # wire on/off/taper → vol messages
    lines.append(line(f"voice_ctrl_{vidx}", 0, f"msg_vol_on_{vidx}",    0))
    lines.append(line(f"msg_vol_on_{vidx}", 0, f"vol_env_{vidx}",       0))
    lines.append(line(f"voice_ctrl_{vidx}", 1, f"msg_vol_off_{vidx}",   0))
    lines.append(line(f"msg_vol_off_{vidx}",0, f"vol_env_{vidx}",       0))
    lines.append(line(f"voice_ctrl_{vidx}", 2, f"msg_vol_taper_{vidx}", 0))
    lines.append(line(f"msg_vol_taper_{vidx}",0,f"vol_env_{vidx}",      0))

    lines.append(line(f"groove_{vidx}",     0, f"vol_sig_{vidx}",       0))
    lines.append(line(f"vol_env_{vidx}",    0, f"vol_sig_{vidx}",       1))

    # Panning
    boxes.append(newobj(f"pan_{vidx}", "pan2",
                         4, 2, ["signal", "signal"],
                         vx, vy + 165, 50))
    boxes.append(msg(f"msg_pan_{vidx}", f"{pan}",
                      vx + 60, vy + 165, max(40, len(str(pan))*8+10)))
    lines.append(line(f"vol_sig_{vidx}",  0, f"pan_{vidx}",  0))
    lines.append(line(f"msg_pan_{vidx}", 0, f"pan_{vidx}",   1))

# ============================================================
# SECTION 8: MIX + OUTPUT
# ============================================================

boxes.append(comment("lbl_mix", "=== MIX / OUTPUT ===",
                      COL_MIX, ROW_TOP-10, 160))

# Sum L/R from all 4 voices + dry
boxes.append(newobj("mix_L", "+~ 0.",
                     2, 1, ["signal"],
                     COL_MIX, ROW_TOP+30, 55))
boxes.append(newobj("mix_R", "+~ 0.",
                     2, 1, ["signal"],
                     COL_MIX+80, ROW_TOP+30, 55))

boxes.append(newobj("mix_L2", "+~ 0.",
                     2, 1, ["signal"],
                     COL_MIX, ROW_TOP+60, 55))
boxes.append(newobj("mix_R2", "+~ 0.",
                     2, 1, ["signal"],
                     COL_MIX+80, ROW_TOP+60, 55))

boxes.append(newobj("mix_L3", "+~ 0.",
                     2, 1, ["signal"],
                     COL_MIX, ROW_TOP+90, 55))
boxes.append(newobj("mix_R3", "+~ 0.",
                     2, 1, ["signal"],
                     COL_MIX+80, ROW_TOP+90, 55))

# Dry + click into mix
boxes.append(newobj("mix_dry_L", "+~ 0.",
                     2, 1, ["signal"],
                     COL_MIX, ROW_TOP+120, 55))
boxes.append(newobj("mix_dry_R", "+~ 0.",
                     2, 1, ["signal"],
                     COL_MIX+80, ROW_TOP+120, 55))

# Master limiter / gain
boxes.append(newobj("master_L", "*~ 0.7",
                     2, 1, ["signal"],
                     COL_MIX, ROW_TOP+155, 65))
boxes.append(newobj("master_R", "*~ 0.7",
                     2, 1, ["signal"],
                     COL_MIX+80, ROW_TOP+155, 65))

boxes.append(newobj("clip_L", "clip~ -1. 1.",
                     3, 1, ["signal"],
                     COL_MIX, ROW_TOP+185, 90))
boxes.append(newobj("clip_R", "clip~ -1. 1.",
                     3, 1, ["signal"],
                     COL_MIX+80, ROW_TOP+185, 90))

boxes.append(newobj("dac", "dac~",
                     2, 0, [],
                     COL_MIX, ROW_TOP+215, 44))

# Metering
boxes.append(newobj("meter_L", "meter~",
                     1, 1, ["signal"],
                     COL_MIX, ROW_TOP+250, 60))
boxes.append(newobj("meter_R", "meter~",
                     1, 1, ["signal"],
                     COL_MIX+80, ROW_TOP+250, 60))

# Voice → mix wiring
lines.append(line("pan_1", 0, "mix_L",  0))
lines.append(line("pan_1", 1, "mix_R",  0))
lines.append(line("pan_2", 0, "mix_L",  1))
lines.append(line("pan_2", 1, "mix_R",  1))
lines.append(line("mix_L", 0, "mix_L2", 0))
lines.append(line("mix_R", 0, "mix_R2", 0))
lines.append(line("pan_3", 0, "mix_L2", 1))
lines.append(line("pan_3", 1, "mix_R2", 1))
lines.append(line("mix_L2",0, "mix_L3", 0))
lines.append(line("mix_R2",0, "mix_R3", 0))
lines.append(line("pan_4", 0, "mix_L3", 1))
lines.append(line("pan_4", 1, "mix_R3", 1))

# Dry + click → mix_dry
lines.append(line("mix_L3",     0, "mix_dry_L", 0))
lines.append(line("mix_R3",     0, "mix_dry_R", 0))
lines.append(line("dry_gain",   0, "mix_dry_L", 1, 0))
lines.append(line("dry_gain",   0, "mix_dry_R", 1, 1))
lines.append(line("click_gain", 0, "mix_dry_L", 1, 2))
lines.append(line("click_gain", 0, "mix_dry_R", 1, 3))

lines.append(line("mix_dry_L", 0, "master_L", 0))
lines.append(line("mix_dry_R", 0, "master_R", 0))
lines.append(line("master_L",  0, "clip_L",   0))
lines.append(line("master_R",  0, "clip_R",   0))
lines.append(line("clip_L",    0, "dac",      0))
lines.append(line("clip_R",    0, "dac",      1))
lines.append(line("clip_L",    0, "meter_L",  0, 0))
lines.append(line("clip_R",    0, "meter_R",  0, 0))

# ezdac wired to dac (share outlet)
lines.append(line("msg_startwindow", 0, "dac", 0))

# ============================================================
# ASSEMBLE & WRITE PATCH
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
        "rect": [50.0, 80.0, 2300.0, 1000.0],
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

out_path = os.path.join(os.path.dirname(__file__), "lapopie.maxpat")
with open(out_path, "w") as f:
    json.dump(patch, f, indent="\t")

print(f"Written {out_path}")
print(f"  {len(boxes)} boxes, {len(lines)} patch lines")

# ---- Verify: check for duplicate IDs ----
ids = [list(b["box"].keys())[0] if "box" not in b else b["box"]["id"] for b in boxes]
ids = [b["box"]["id"] for b in boxes]
seen = {}
dupes = []
for id_ in ids:
    if id_ in seen:
        dupes.append(id_)
    seen[id_] = True
if dupes:
    print(f"WARNING: duplicate box IDs: {dupes}")
else:
    print("  No duplicate IDs found.")

# ---- Verify: check for wires to non-existent IDs ----
id_set = set(ids)
bad_lines = []
for l in lines:
    pl = l["patchline"]
    src, dst = pl["source"][0], pl["destination"][0]
    if src not in id_set:
        bad_lines.append(f"  missing src: {src}")
    if dst not in id_set:
        bad_lines.append(f"  missing dst: {dst}")
if bad_lines:
    print("WARNING: wires to missing objects:")
    for b in bad_lines[:20]:
        print(b)
else:
    print("  All wire endpoints exist.")
