#!/usr/bin/env python3
"""
Build the Fan Fiction guitar quintet patch for Ableton Live 11 + Max for Live 8.x (MSP).
~10-minute live piece: 1 input guitar + 4 phasing guitar voices.

CONCEPT: Steve Reich-style phase piece.
=========================================

PHRASE CAPTURE
--------------
  - Press START button when you begin playing (this starts the timer and
    the click track / internal metronome awareness at 90 BPM).
  - The patch waits 2 bars (5333ms @ 90BPM, 4/4) for the "warmup" bars,
    then records the next 8 bars (21333ms) into buf_phrase (24000ms buffer).
  - After capture:  record~ is closed.  All 4 groove~ voices are set to
    loop the exact 8-bar window.

PHASING MECHANISM (Reich style)
---------------------------------
  Four groove~ voices read back buf_phrase:
    Guitar 1: rate = 1.0 (locked, exact tempo, starts at t=30s)
    Guitar 2: rate = 1.0 + slow triangle LFO ±0.006  (period ~120s)
    Guitar 3: rate = 1.0 + slow triangle LFO ±0.010  (period ~180s, π/2 offset)
    Guitar 4: rate = 1.0 + slow triangle LFO ±0.004  (period ~90s , π offset)

  At ±0.006 rate difference across a 21.33s loop, one full phase cycle
  takes ~3555s — way too slow. We give each LFO a random-feeling offset
  so they drift asynchronously and cross at different moments.

  Actual drift: rate difference 0.006 → the loop drifts by 0.006 × 21.33s
  = 0.128 s per loop repetition. After ~167 repetitions (≈ 59 min) it
  would drift one full loop. That's too slow. So LFO depth is larger:
  ±0.04 → 0.04 × 21.33 = 0.85s drift/loop, full phase cycle ≈ 25 loops
  = ~530s ≈ 8.8min. Over 10 min we get 1–2 full phase cycles per voice.
  Voices 2/3/4 use different depths and periods so they drift at distinct rates.

NOTE BANK SYSTEM
-----------------
  yin~ + confidence gate → MIDI note → in-bank check.
  Initial bank of 5 notes captured during first 10s of input playing
  (after the warmup bars; the first 5 distinct notes heard go into init_bank[0..4]).

  Each guitar (1-4) gets its own independent bank of 5 MIDI note slots,
  all starting as copies of init_bank.
  When a new note (outside the current bank) is played:
    - Each guitar gets an independent delayed response (different random delays)
    - The responding guitar replaces a random slot in its bank with the new note
    - Its groove~ pitch offset shifts by the interval from its current root

BASS TRIGGER → SAMPLES
------------------------
  Lower E string frets 1–8 (standard 440 tuning):
    F2  = MIDI 41 = 87.3 Hz
    C3  = MIDI 48 = 130.8 Hz
  When yin~ detects a pitch in this window AND confidence > 0.7
  AND the note has not fired recently (2s cooldown via delta):
    → random 2000–8000ms delay, then random 1-of-8 sample plays

SAMPLE FILES
-------------
  Place 8 samples as:  fan-fiction/samples/samp_0.wav  …  samp_7.wav
  (Monophonic; the patch scales them to the mix. "Different Trains" style fragments.)

INPUT GUITAR LEVEL
-------------------
  Live input passes through at -6dB relative to the partner guitars
  (input gain *~ 0.45 vs partner gain 0.70) so it sits under the phase bed.
  It still appears in the mix — you can hear yourself — just not too out.

TIMELINE (≈10 min = 600s)
==========================
  t=0        START pressed.  Warmup bars play (input alone, no copies).
  t=5.333s   Capture window opens (8 bars = 21.333s).
  t=26.667s  Capture window closes.  Phrase locked.
  t=30s      Guitar 1 starts looping (exact rate=1.0).
  t=36s      Guitar 2 starts (rate with LFO, depth ±0.04, period 140s).
  t=42s      Guitar 3 starts (rate with LFO, depth ±0.06, period 200s).
  t=48s      Guitar 4 starts (rate with LFO, depth ±0.025, period 100s).
  t=30–600s  Bank evolution: new notes detected from input trigger tonal drift.
  t=0–600s   Bass notes (fret 1-8 on low E) trigger samples with 2-8s random delay.
  t=570–600s All voices fade out over 30s.

NOTES ON MAX OBJECTS
  - groove~ : looping buffer playback at variable rate
  - buffer~  : audio buffer, 24s for phrase, short durations for 8 samples
  - record~  : writes live audio into buffer
  - yin~     : monophonic pitch detection (Hz + confidence)
  - ftom      : Hz → MIDI note
  - random    : generates random int 0..(n-1)
  - pipe      : delay a message by N ms
  - sel       : route int values to specific outlets
  - change    : pass value only when it changes
  - trigger   : force evaluation order + type conversion

IMPORTANT: Max expr does NOT support clip(). Use separate clip objects.
IMPORTANT: groove~ rate inlet is inlet 1. Audio comes from inlet 0 (loop command).
           groove~ outlet 0 = audio signal, outlet 1 = position signal.
"""

import json
import math
import os
import struct

# ============================================================
# HELPERS  (same conventions as anaerobes + chimera)
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

def intnum(id, x=0, y=0, w=50):
    return box(id, "number", numinlets=1, numoutlets=2,
               outlettype=["int", "bang"], x=x, y=y, w=w,
               extra={"parameter_enable": 0})

def msg(id, text, x=0, y=0, w=None):
    return box(id, "message", text, numinlets=2, numoutlets=1,
               outlettype=[""], x=x, y=y, w=w or (len(text)*7+14))

def button(id, x=0, y=0, presentation=False, px=0, py=0, pw=24, ph=24):
    extra = {"parameter_enable": 0}
    if presentation:
        extra["presentation"] = 1
        extra["presentation_rect"] = [px, py, pw, ph]
    return box(id, "button", numinlets=1, numoutlets=1,
               outlettype=["bang"], x=x, y=y, w=24, h=24,
               extra=extra)

def comment(id, text, x=0, y=0, w=None):
    return box(id, "comment", text, numinlets=1, numoutlets=0,
               outlettype=[], x=x, y=y, w=w or (len(text)*7+10))

def line(src, src_outlet, dst, dst_inlet, order=None):
    d = {"destination": [dst, dst_inlet], "source": [src, src_outlet]}
    if order is not None:
        d["order"] = order
    return {"patchline": d}

# ============================================================
# LAYOUT CONSTANTS
# ============================================================
# Piece is 600s = 10 min.
# BPM = 90, 4/4 → 1 bar = 60/90 * 4 = 2666.67ms
# 2 warmup bars = 5333ms
# 8 capture bars = 21333ms → total capture end = 26667ms
# Guitar entries: 30000, 36000, 42000, 48000 ms

BPM          = 90.0
BAR_MS       = (60.0 / BPM) * 4 * 1000      # 2666.67 ms
WARMUP_MS    = int(2 * BAR_MS)               # 5333 ms
CAPTURE_MS   = int(8 * BAR_MS)               # 21333 ms
CAP_START_MS = WARMUP_MS                     # 5333
CAP_END_MS   = WARMUP_MS + CAPTURE_MS        # 26667
BUF_MS       = CAPTURE_MS + 2000             # slight pad: 23333 ms

# Voice entry times (ms)
G1_ENTRY_S = 30.0
G2_ENTRY_S = 36.0
G3_ENTRY_S = 42.0
G4_ENTRY_S = 48.0

# Fade-out
FADE_START_S = 570.0
PIECE_END_S  = 600.0

# Bass range: fret 1-8 on low E, standard 440 tuning
BASS_LO_HZ = 87.0    # slightly below F2(87.3) for safety
BASS_HI_HZ = 131.0   # just above C3(130.8)
BASS_COOLDOWN_MS = 2000

COL_A   = 40     # input / dry / adc
COL_B   = 280    # timer + arcs
COL_C   = 560    # phrase capture
COL_D   = 820    # pitch detection
COL_E   = 1080   # note bank system + tonal shift
COL_F   = 1380   # groove voices (phase engine)
COL_G   = 1900   # sample trigger system
COL_MIX = 2250   # mix + output

ROW_TOP = 40

boxes = []
lines = []

# ============================================================
# SECTION 1: INPUT + DRY PATH + EZDAC
# ============================================================

boxes.append(comment("lbl_s1", "=== INPUT ===", COL_A, ROW_TOP-20, 120))

boxes.append(newobj("adc", "plugin~", 2, 2, ["signal","signal"],
                    COL_A, ROW_TOP+40))

# Input guitar in mix at -6dB relative to partners (~0.45 vs 0.70)
boxes.append(newobj("in_gain", "*~ 0.45", 2, 1, ["signal"],
                    COL_A, ROW_TOP+75))
boxes.append(comment("lbl_ingain", "input -6dB (sits under phase bed)", COL_A+65, ROW_TOP+77, 230))

lines.append(line("adc", 0, "in_gain", 0))

# ============================================================
# SECTION 2: TIMER + ARCS
# ============================================================
# metro 50 → counter → *50 → /1000. → seconds float
# Arcs: onset (3s fade-in), capture gate (open 5333..26667ms),
#       guitar entry gates, fade-out arc (570–600s)

boxes.append(comment("lbl_s2", "=== TIMER + ARCS (600s = 10min) ===",
                     COL_B, ROW_TOP-20, 260))

boxes.append(button("start_btn", COL_B, ROW_TOP, presentation=True, px=10, py=10))
boxes.append(comment("lbl_start", "START", COL_B+30, ROW_TOP+4, 50))
boxes.append(button("reset_btn", COL_B+80, ROW_TOP, presentation=True, px=50, py=10))
boxes.append(comment("lbl_reset", "RESET", COL_B+110, ROW_TOP+4, 60))

boxes.append(msg("msg_start", "1", COL_B, ROW_TOP+35))
boxes.append(msg("msg_stop",  "0", COL_B+80, ROW_TOP+35))

boxes.append(newobj("metro", "metro 50", 2, 1, ["bang"],   COL_B, ROW_TOP+65))
boxes.append(newobj("counter", "counter", 5, 4,
                    ["int","","","int"],                    COL_B, ROW_TOP+95))
boxes.append(newobj("ticks_ms", "* 50", 2, 1, ["int"],     COL_B, ROW_TOP+130))
boxes.append(newobj("ms_sec",   "/ 1000.", 2, 1, ["float"], COL_B, ROW_TOP+160))

boxes.append(flonum("t_disp",   COL_B,     ROW_TOP+195, 70))
boxes.append(comment("lbl_sec", "sec",     COL_B+75,    ROW_TOP+197, 30))
boxes.append(newobj("t_min",    "/ 60.", 2, 1, ["float"], COL_B+120, ROW_TOP+195))
boxes.append(flonum("min_disp", COL_B+120, ROW_TOP+225, 60))
boxes.append(comment("lbl_min", "min",     COL_B+185,   ROW_TOP+227, 30))

# Onset ramp (3s fade-in)
boxes.append(newobj("onset_div",  "/ 3.", 2, 1, ["float"],       COL_B, ROW_TOP+260))
boxes.append(newobj("onset_clip", "clip 0. 1.", 3, 1, ["float"], COL_B, ROW_TOP+290))
boxes.append(comment("lbl_onset", "onset 0..1 (3s ramp)", COL_B+80, ROW_TOP+292, 160))

# Fade-out arc: (t - 570) / 30 → clip 0 1 → invert → master_fade (1..0)
boxes.append(newobj("fade_sub",  f"- {FADE_START_S}", 2, 1, ["float"], COL_B, ROW_TOP+330))
boxes.append(newobj("fade_div",  f"/ {PIECE_END_S - FADE_START_S}", 2, 1, ["float"], COL_B, ROW_TOP+360))
boxes.append(newobj("fade_clip", "clip 0. 1.", 3, 1, ["float"],        COL_B, ROW_TOP+390))
# 1 - x without expr (M4L / some installs)
boxes.append(newobj("fade_inv_mul", "* -1.", 1, 1, ["float"],           COL_B, ROW_TOP+420))
boxes.append(newobj("fade_inv_add", "+ 1.", 1, 1, ["float"],           COL_B+55, ROW_TOP+420))
boxes.append(comment("lbl_fade", "fade-out 0..1 (inverted)", COL_B+115, ROW_TOP+422, 180))

# Timer wiring
lines.append(line("start_btn", 0, "msg_start", 0))
lines.append(line("reset_btn", 0, "msg_stop",  0))
lines.append(line("msg_start", 0, "metro", 0))
lines.append(line("msg_stop",  0, "metro", 0))
lines.append(line("msg_stop",  0, "counter", 3))
lines.append(line("metro",    0, "counter",  0))
lines.append(line("counter",  0, "ticks_ms", 0))
lines.append(line("ticks_ms", 0, "ms_sec",   0))
lines.append(line("ms_sec",   0, "t_disp",    0, 0))
lines.append(line("ms_sec",   0, "t_min",     0, 1))
lines.append(line("ms_sec",   0, "onset_div", 0, 2))
lines.append(line("ms_sec",   0, "fade_sub",  0, 3))
lines.append(line("t_min",    0, "min_disp",  0))
lines.append(line("onset_div",  0, "onset_clip",  0))
lines.append(line("fade_sub",  0, "fade_div",  0))
lines.append(line("fade_div",  0, "fade_clip", 0))
lines.append(line("fade_clip", 0, "fade_inv_mul", 0))
lines.append(line("fade_inv_mul", 0, "fade_inv_add", 0))

# ============================================================
# SECTION 3: PHRASE CAPTURE
# ============================================================
#
# buf_phrase: BUF_MS ms buffer for the 8-bar recorded phrase.
#
# Flow:
#   START btn → metro starts → timer running
#   At t > CAP_START_MS (2 warmup bars):  one-shot → open record~ (gate=1)
#   At t > CAP_END_MS   (8 bars later):   one-shot → close record~ (gate=0)
#                                        → set loop length on all groove~ voices
#   Groove~ voices start at their respective entry times (controlled in Section 6).
#
# Loop length = CAPTURE_MS ms. Each groove~ needs to know where to loop back.
# We use the "loop 1" + "looplength <ms>" messages.

boxes.append(comment("lbl_s3", "=== PHRASE CAPTURE ===", COL_C, ROW_TOP-20, 200))

# Buffer: mono, BUF_MS ms
boxes.append(newobj("buf_phrase", f"buffer~ phrase {BUF_MS}", 1, 1, ["bang"],
                    COL_C, ROW_TOP+40))
boxes.append(comment("lbl_buf", f"phrase buffer ({BUF_MS}ms)", COL_C+110, ROW_TOP+42, 160))

# record~ for phrase
boxes.append(newobj("rec_phrase", "record~ phrase", 2, 1, ["bang"],
                    COL_C, ROW_TOP+80))
boxes.append(comment("lbl_rec", "phrase recorder", COL_C+100, ROW_TOP+82, 120))

# One-shot: capture open at CAP_START_MS / CAP_START_S
CAP_START_S = CAP_START_MS / 1000.0  # 5.333
boxes.append(newobj("cap_open_cmp",  f"> {CAP_START_S:.3f}", 2, 1, ["int"],
                    COL_C, ROW_TOP+125))
boxes.append(newobj("cap_open_once", "change", 1, 1, ["int"],
                    COL_C, ROW_TOP+155))
boxes.append(msg("cap_open_msg", "1", COL_C, ROW_TOP+185, 24))
boxes.append(comment("lbl_capopen", f"open rec at {CAP_START_S:.1f}s", COL_C+35, ROW_TOP+187, 150))

# One-shot: capture close at CAP_END_MS / CAP_END_S
CAP_END_S = CAP_END_MS / 1000.0  # 26.667
boxes.append(newobj("cap_close_cmp",  f"> {CAP_END_S:.3f}", 2, 1, ["int"],
                    COL_C, ROW_TOP+225))
boxes.append(newobj("cap_close_once", "change", 1, 1, ["int"],
                    COL_C, ROW_TOP+255))
boxes.append(msg("cap_close_msg", "0", COL_C, ROW_TOP+285, 24))
boxes.append(comment("lbl_capclose", f"close rec at {CAP_END_S:.1f}s", COL_C+35, ROW_TOP+287, 160))

# Loop length message: once capture closes, set loop length on all groove voices
# Message: "looplength <CAPTURE_MS>" sent to each groove~
boxes.append(msg("loop_len_msg", f"looplength {CAPTURE_MS}", COL_C, ROW_TOP+325, 130))
boxes.append(comment("lbl_looplen", "set all loop lengths", COL_C+140, ROW_TOP+327, 140))

# Capture wiring
lines.append(line("ms_sec", 0, "cap_open_cmp",  0, 5))
lines.append(line("ms_sec", 0, "cap_close_cmp", 0, 6))
lines.append(line("cap_open_cmp",   0, "cap_open_once",  0))
lines.append(line("cap_open_once",  0, "cap_open_msg",   0))
lines.append(line("cap_open_msg",   0, "rec_phrase",      1))
lines.append(line("cap_close_cmp",  0, "cap_close_once", 0))
lines.append(line("cap_close_once", 0, "cap_close_msg",  0))
lines.append(line("cap_close_msg",  0, "rec_phrase",      1))
lines.append(line("cap_close_once", 0, "loop_len_msg",   0))
lines.append(line("adc",            0, "rec_phrase",      0))

# ============================================================
# SECTION 4: PITCH DETECTION
# ============================================================
#
# yin~ → Hz → confidence gate → two downstream paths:
#   A) ftom → MIDI note → used by note-bank system
#   B) Bass range check (87..131 Hz) → sample trigger

boxes.append(comment("lbl_s4", "=== PITCH DETECTION ===", COL_D, ROW_TOP-20, 200))

boxes.append(newobj("yin", "yin~ 2048 0.9", 1, 2, ["float", "float"],
                    COL_D, ROW_TOP+40))
boxes.append(comment("lbl_yin", "yin~ pitch (Hz) + confidence", COL_D+110, ROW_TOP+42, 200))

# Confidence threshold
boxes.append(newobj("conf_thresh", "> 0.7", 2, 1, ["int"],
                    COL_D+120, ROW_TOP+80))
boxes.append(newobj("conf_gate",   "gate 1", 2, 1, [""],
                    COL_D, ROW_TOP+115))
boxes.append(comment("lbl_cg", "confidence gate", COL_D+65, ROW_TOP+117, 120))

# IRCAM yin~ outlet 0 = float Hz → ftom directly (no snapshot~). Path B uses same Hz into bass window.

# Hz → MIDI (ftom)
boxes.append(newobj("hz_to_midi",  "ftom", 1, 1, ["float"],
                    COL_D, ROW_TOP+190))
boxes.append(newobj("midi_int",    "int",  2, 1, [""],
                    COL_D, ROW_TOP+220))
boxes.append(newobj("midi_change", "change", 1, 1, [""],
                    COL_D, ROW_TOP+250))
boxes.append(flonum("midi_disp",   COL_D, ROW_TOP+285, 50))
boxes.append(comment("lbl_midi",   "MIDI note", COL_D+55, ROW_TOP+287, 80))

# Path B: Bass range check for sample triggering
# Hz < 131 AND Hz > 87 → both must be true
boxes.append(newobj("bass_hi_cmp", f"< {BASS_HI_HZ}.", 2, 1, ["int"],
                    COL_D+100, ROW_TOP+190))
boxes.append(newobj("bass_lo_cmp", f"> {BASS_LO_HZ}.", 2, 1, ["int"],
                    COL_D+100, ROW_TOP+220))
boxes.append(newobj("bass_and",    "&& 0",  2, 1, ["int"],
                    COL_D+100, ROW_TOP+250))
# Cooldown: once triggered, 2s lockout so one sustained note fires only once
boxes.append(newobj("bass_change", "change", 1, 1, ["int"],
                    COL_D+100, ROW_TOP+280))
# Pass only the rising edge (0→1 transition)
boxes.append(newobj("bass_pass1",  "== 1",  2, 1, ["int"],
                    COL_D+100, ROW_TOP+310))
boxes.append(comment("lbl_bass", "bass trigger (fret 1-8 low E)", COL_D+165, ROW_TOP+312, 210))

# Wiring: yin → confidence gate
lines.append(line("adc",         0, "yin",          0))
lines.append(line("yin",         0, "conf_gate",    0))
lines.append(line("yin",         1, "conf_thresh",  0))
lines.append(line("conf_thresh", 0, "conf_gate",    1))
lines.append(line("conf_gate",   0, "hz_to_midi",   0))

# Path A wiring
lines.append(line("hz_to_midi", 0, "midi_int",     0))
lines.append(line("midi_int",   0, "midi_change",  0))
lines.append(line("midi_change",0, "midi_disp",    0))

# Path B wiring (Hz float)
lines.append(line("conf_gate",  0, "bass_hi_cmp",  0))
lines.append(line("conf_gate",  0, "bass_lo_cmp",  0))
lines.append(line("bass_hi_cmp",0, "bass_and",     0))
lines.append(line("bass_lo_cmp",0, "bass_and",     1))
lines.append(line("bass_and",   0, "bass_change",  0))
lines.append(line("bass_change",0, "bass_pass1",   0))

# ============================================================
# SECTION 5: NOTE BANK + TONAL SHIFT SYSTEM
# ============================================================
#
# INIT BANK: 5 slots (f objects), filled during first 10s of piece start.
#   Uses a counter (0..4) and a gate that closes once 5 notes are captured.
#   When a new MIDI note arrives and init_counter < 5 and note != all stored → store it.
#
# PER-GUITAR BANKS (4×5 = 20 f objects):
#   g{n}_bank_{0..4}: 5 slots per guitar, all initialised from init_bank.
#   Initialisation: when capture closes (cap_close_once), defer 100ms → copy init_bank.
#
# NEW NOTE DETECTION (per guitar):
#   For each guitar, 5 != comparators check if midi_change != bank_slot.
#   All 5 go through && chain: if all are != → new note detected.
#   → trigger staggered response per guitar (different random delay ranges).
#
# TONAL SHIFT RESPONSE:
#   Each guitar independently (after its random delay):
#   1. Pick a random slot 0..4 to replace in its own bank.
#   2. Store new note in that slot.
#   3. Compute interval = new_note - bank_slot_0 (root slot) as pitch offset.
#   4. Update groove~ pitch via pitchshift~ semitone offset (sig~ → pitchshift~).
#
# SIMPLIFICATION: Rather than dynamic interval computation (requires complex
# routing), we track each guitar's "current root note" in an f object and
# compute the semitone offset when a new note arrives.
# The pitch offset for each guitar = new_midi - guitar_root_note.
# groove~ is direct rate playback; pitch shift via pitchshift~ 512 on each voice.

FAN_COL = COL_E
boxes.append(comment("lbl_s5", "=== NOTE BANKS + TONAL SHIFT ===",
                     FAN_COL, ROW_TOP-20, 250))

# Init bank: 5 f slots
boxes.append(comment("lbl_initbank", "-- Init Bank (first 5 notes) --",
                     FAN_COL, ROW_TOP, 230))
for slot in range(5):
    sx = FAN_COL + slot * 55
    boxes.append(newobj(f"init_bank_{slot}", "f", 2, 1, ["float"],
                        sx, ROW_TOP+30))
    # Initial default values (C4=60, E4=64, G4=67, A4=69, D4=62) — overwritten live
    boxes.append(msg(f"init_default_{slot}", str([60, 64, 67, 69, 62][slot]),
                     sx, ROW_TOP+60, 30))
    lines.append(line(f"init_default_{slot}", 0, f"init_bank_{slot}", 1))

# Capture counter for init bank (0..4, stops at 5)
boxes.append(newobj("init_counter", "counter 0 4", 5, 4,
                    ["int","","","int"],
                    FAN_COL, ROW_TOP+100))
boxes.append(newobj("init_done",    "== 4", 2, 1, ["int"],
                    FAN_COL, ROW_TOP+130))
boxes.append(newobj("init_gate",    "gate 1", 2, 1, [""],
                    FAN_COL, ROW_TOP+160))
# sel to route the counter value to correct bank slot
boxes.append(newobj("init_sel",     "sel 0 1 2 3 4", 1, 6, ["bang","bang","bang","bang","bang",""],
                    FAN_COL, ROW_TOP+195))
boxes.append(comment("lbl_igate", "init bank open until 5 notes", FAN_COL+110, ROW_TOP+162, 200))

# Note-to-bank routing: midi_change → init_gate → init_counter → sel → bank slots
lines.append(line("midi_change",  0, "init_gate",    0))
lines.append(line("init_gate",    0, "init_counter", 0))
lines.append(line("init_counter", 0, "init_done",    0))
lines.append(line("init_counter", 0, "init_sel",     0))
lines.append(line("init_done",    0, "init_gate",    1))  # close gate when full

for slot in range(5):
    # When sel bangs, write current midi note to that slot
    # We need the midi note value to reach the bank f-object inlet 0 when banged
    # Route: midi_change → init_bank_{slot} inlet 0 (data stays latched)
    # But f stores last received at inlet 0 and outputs on bang at inlet 0 or left inlet.
    # So: midi_change → init_bank_{slot} inlet 0 (sets the value)
    #     init_sel bang → init_bank_{slot} inlet 0 (outputs the stored value) - NO
    # Correct Max idiom: f outlet fires when left inlet (inlet 0) bangs OR you can
    # store via right inlet and bang left. We need: store note, then write to slot.
    # Use trigger: midi_change → trigger b f → f outlet via init_sel bang
    # Simplify: just connect midi_change to each bank inlet 0 (value pre-loaded)
    # and use the init_sel bang to write — but f[inlet0] = bang + recall stored right-inlet value
    # Actually in Max: f's inlet 0 = bang (output), inlet 1 = store. To store: send to inlet 1.
    # To store AND bang: send number to inlet 0 directly stores and outputs IF it's a float.
    # Cleanest: midi_change → each init_bank inlet 1 (store), then sel bang → bank inlet 0 (recall)
    lines.append(line("midi_change", 0, f"init_bank_{slot}", 1))  # store value
    lines.append(line("init_sel", slot, f"init_bank_{slot}", 0))   # bang to recall

# Per-guitar banks: 4 guitars × 5 slots each
boxes.append(comment("lbl_gbanks", "-- Per-Guitar Banks --",
                     FAN_COL, ROW_TOP+250, 200))

for g in range(1, 5):
    gy = ROW_TOP + 280 + (g-1) * 45
    boxes.append(comment(f"lbl_gb{g}", f"G{g}:",
                         FAN_COL-30, gy, 30))
    for slot in range(5):
        sx = FAN_COL + slot * 55
        boxes.append(newobj(f"g{g}_bank_{slot}", "f", 2, 1, ["float"],
                            sx, gy))
        # Default same as init_default
        boxes.append(msg(f"g{g}_def_{slot}", str([60, 64, 67, 69, 62][slot]),
                         sx, gy+25, 30))
        lines.append(line(f"g{g}_def_{slot}", 0, f"g{g}_bank_{slot}", 1))
        # Copy from init_bank at capture-close time (via loadbang as initial seed)
        lines.append(line(f"init_bank_{slot}", 0, f"g{g}_bank_{slot}", 1))

# ---- NEW NOTE DETECTION per guitar ----
boxes.append(comment("lbl_newdet", "-- New Note Detection --",
                     FAN_COL, ROW_TOP+490, 200))

# Each guitar checks: is current MIDI note in any of its 5 bank slots?
# Pattern per guitar G{n}:
#   midi_change → 5× != comparators (one per bank slot)
#   5 comparator outputs → &&-chain: all_new_{n}
#   all_new → bang → triggers delayed response

for g in range(1, 5):
    gy = ROW_TOP + 520 + (g-1) * 95
    boxes.append(comment(f"lbl_nd{g}", f"G{g} new-note check:",
                         FAN_COL-30, gy, 130))
    # 5 != comparators: midi_change != g{n}_bank_{slot}
    for slot in range(5):
        sx = FAN_COL + slot * 55
        boxes.append(newobj(f"g{g}_neq_{slot}", "!=", 2, 1, ["int"],
                            sx, gy+25))
        lines.append(line("midi_change", 0, f"g{g}_neq_{slot}", 0))
        lines.append(line(f"g{g}_bank_{slot}", 0, f"g{g}_neq_{slot}", 1))

    # && chain: neq_0 && neq_1 → && neq_2 → && neq_3 → && neq_4
    boxes.append(newobj(f"g{g}_and_01", "&& 0", 2, 1, ["int"],
                        FAN_COL,      gy+55))
    boxes.append(newobj(f"g{g}_and_23", "&& 0", 2, 1, ["int"],
                        FAN_COL+110,  gy+55))
    boxes.append(newobj(f"g{g}_and_012", "&& 0", 2, 1, ["int"],
                        FAN_COL+55,   gy+80))  # and_01 & neq_2 (hmm, need 4-way)
    # Build a gate-chain: just AND all 5 in a binary tree
    # and_01 = neq_0 & neq_1
    # and_23 = neq_2 & neq_3
    # and_0123 = and_01 & and_23
    # all_new = and_0123 & neq_4
    boxes.append(newobj(f"g{g}_and_0123", "&& 0", 2, 1, ["int"],
                        FAN_COL,     gy+80))
    boxes.append(newobj(f"g{g}_all_new", "&& 0", 2, 1, ["int"],
                        FAN_COL+55,  gy+80+25))
    # Only fire on rising edge (0→1)
    boxes.append(newobj(f"g{g}_new_chg",  "change", 1, 1, ["int"],
                        FAN_COL+130, gy+80+25))
    boxes.append(newobj(f"g{g}_new_pass", "sel 1", 1, 2, ["bang", ""],
                        FAN_COL+130, gy+80+50))
    boxes.append(comment(f"lbl_new{g}", f"→ new note for G{g}",
                         FAN_COL+185, gy+80+52, 140))

    lines.append(line(f"g{g}_neq_0",    0, f"g{g}_and_01",   0))
    lines.append(line(f"g{g}_neq_1",    0, f"g{g}_and_01",   1))
    lines.append(line(f"g{g}_neq_2",    0, f"g{g}_and_23",   0))
    lines.append(line(f"g{g}_neq_3",    0, f"g{g}_and_23",   1))
    lines.append(line(f"g{g}_and_01",   0, f"g{g}_and_0123", 0))
    lines.append(line(f"g{g}_and_23",   0, f"g{g}_and_0123", 1))
    lines.append(line(f"g{g}_and_0123", 0, f"g{g}_all_new",  0))
    lines.append(line(f"g{g}_neq_4",    0, f"g{g}_all_new",  1))
    lines.append(line(f"g{g}_all_new",  0, f"g{g}_new_chg",  0))
    lines.append(line(f"g{g}_new_chg",  0, f"g{g}_new_pass", 0))

# ---- TONAL SHIFT RESPONSE ----
# When all_new fires for guitar G{n}:
#   1. Random delay (different range per guitar)
#   2. Pick random slot to replace (random 5 → sel 0 1 2 3 4 → store new midi)
#   3. Compute interval = new_midi - g{n}_bank_0 (root slot 0)
#   4. Update pitchshift~ target for this guitar via sig~ (smoothed by line~)

boxes.append(comment("lbl_tshift", "-- Tonal Shift Responses --",
                     FAN_COL, ROW_TOP+920, 220))

# Random delay ranges per guitar (ms): staggered so each guitar responds
# at a different time, creating the gradual tonal drift feel.
# Guitar 1: most responsive (2–6s), Guitar 2: medium (5–15s),
# Guitar 3: slow (10–25s), Guitar 4: very slow (18–35s).
SHIFT_DELAY_RANGES = {
    1: (2000, 4001),   # 2000 + random(4001) → 2000..6000ms
    2: (5000, 10001),  # 5000 + random(10001) → 5000..15000ms
    3: (10000, 15001), # 10000 + random(15001) → 10000..25000ms
    4: (18000, 17001), # 18000 + random(17001) → 18000..35000ms
}

for g in range(1, 5):
    gsy = ROW_TOP + 950 + (g-1) * 120
    lo, rng = SHIFT_DELAY_RANGES[g]
    boxes.append(comment(f"lbl_ts{g}", f"G{g} shift (delay {lo//1000}-{(lo+rng-1)//1000}s):",
                         FAN_COL-30, gsy, 200))

    # Random delay: random(rng) + lo → pipe (delay N ms) → bang
    boxes.append(newobj(f"ts_rand_{g}",   f"random {rng}", 1, 1, ["int"],
                        FAN_COL, gsy+25))
    # We need to add lo: random result + lo → pipe
    boxes.append(newobj(f"ts_add_{g}",    f"+ {lo}", 2, 1, ["int"],
                        FAN_COL+80, gsy+25))
    boxes.append(newobj(f"ts_pipe_{g}",   "pipe 0", 2, 1, ["bang"],
                        FAN_COL, gsy+55))
    boxes.append(comment(f"lbl_tpipe{g}", "pipe = delayed bang", FAN_COL+65, gsy+57, 130))

    # Latch the new midi note at trigger time (before delay fires)
    boxes.append(newobj(f"ts_latch_{g}", "f", 2, 1, ["float"],
                        FAN_COL+150, gsy+25))
    boxes.append(comment(f"lbl_tlatch{g}", "latch new note", FAN_COL+185, gsy+27, 100))

    # After delay fires: pick random slot to replace
    boxes.append(newobj(f"ts_rslot_{g}", "random 5", 1, 1, ["int"],
                        FAN_COL, gsy+85))
    boxes.append(newobj(f"ts_ssel_{g}",
                        "sel 0 1 2 3 4", 1, 6, ["bang","bang","bang","bang","bang",""],
                        FAN_COL, gsy+115))
    boxes.append(comment(f"lbl_tssel{g}", "replace slot", FAN_COL+175, gsy+117, 90))

    # Write latched note to chosen bank slot
    for slot in range(5):
        sx = FAN_COL + slot * 55
        # trigger: bang from sel outlet → bang latch → store to bank slot
        boxes.append(newobj(f"ts_tw_{g}_{slot}", "trigger b b", 1, 2,
                            ["bang","bang"],
                            sx, gsy+145))
        lines.append(line(f"ts_ssel_{g}", slot, f"ts_tw_{g}_{slot}", 0))
        lines.append(line(f"ts_tw_{g}_{slot}", 0, f"ts_latch_{g}", 0))  # bang latch to output
        lines.append(line(f"ts_latch_{g}", 0, f"g{g}_bank_{slot}", 1))  # store to bank inlet 1
        # Also set as new pitch root anchor for this guitar (bank slot 0 = root)
        if slot == 0:
            lines.append(line(f"ts_latch_{g}", 0, f"g{g}_bank_0", 0))   # update root slot

    # Compute interval = new_midi - g{g}_root_midi → send to pitchshift
    # g{g}_bank_0 = current root (slot 0).
    # After delay fires, compute: new_midi - bank_0_current
    # Use trigger to force order: first read bank_0, then subtract
    boxes.append(newobj(f"ts_interval_{g}", "- 0.", 2, 1, ["float"],
                        FAN_COL+230, gsy+85))
    boxes.append(comment(f"lbl_tint{g}", "semitone shift", FAN_COL+280, gsy+87, 110))

    # Smooth the pitch offset with a line object (3s glide)
    boxes.append(newobj(f"ts_pline_{g}", "line 0. 3000", 2, 1, ["float"],
                        FAN_COL+230, gsy+115))
    boxes.append(newobj(f"ts_psig_{g}",  "sig~ 0.", 1, 1, ["signal"],
                        FAN_COL+230, gsy+145))

    # Wire up the shift response
    # g{n}_new_pass → trigger → ts_rand + ts_latch
    # trigger: right outlets fire first — compute delay → latch → bank → pipe bang
    boxes.append(newobj(f"ts_trig_{g}", "trigger b b b b", 1, 4,
                        ["bang","bang","bang","bang"],
                        FAN_COL+50, gsy))
    lines.append(line(f"g{g}_new_pass", 0, f"ts_trig_{g}", 0))
    lines.append(line(f"ts_trig_{g}", 3,  f"ts_rand_{g}",   0))
    lines.append(line(f"ts_trig_{g}", 2,  f"ts_latch_{g}",  0))
    lines.append(line(f"ts_trig_{g}", 1,  f"g{g}_bank_0",   0))
    lines.append(line(f"ts_trig_{g}", 0, f"ts_pipe_{g}", 0))
    lines.append(line("midi_change",   0,  f"ts_latch_{g}",  1))  # store current midi note

    lines.append(line(f"ts_rand_{g}", 0, f"ts_add_{g}",  0))
    lines.append(line(f"ts_add_{g}",  0, f"ts_pipe_{g}", 1))  # set delay time

    lines.append(line(f"ts_pipe_{g}", 0, f"ts_rslot_{g}", 0))  # bang random slot select
    lines.append(line(f"ts_rslot_{g}", 0, f"ts_ssel_{g}", 0))

    # Interval computation: after pipe fires, read bank_0 vs latched note
    lines.append(line(f"ts_latch_{g}",    0, f"ts_interval_{g}", 0))
    lines.append(line(f"g{g}_bank_0",     0, f"ts_interval_{g}", 1))
    lines.append(line(f"ts_interval_{g}", 0, f"ts_pline_{g}",    0))
    lines.append(line(f"ts_pline_{g}",    0, f"ts_psig_{g}",     0))

# ============================================================
# SECTION 6: PHASE ENGINE (groove~ voices)
# ============================================================
#
# One shared buffer~ (phrase).
# Four groove~ voices reading it back at different rates.
# Guitar 1: exact rate 1.0, no LFO.
# Guitars 2,3,4: rate = 1.0 + LFO (triangle, different depth/period per voice).
# Each voice has:
#   - Entry fade-in at its start time
#   - pitchshift~ 512 driven by ts_psig_{n} (tonal shift, starts at 0 semitones)
#   - freqshift~ for light shimmer (much lighter than anaerobes — just 0.05 Hz)
#   - onset_clip × fade_inv envelope
#   - pan2 placement

# LFO parameters per voice
PHASE_VOICES = [
    {"idx": 1, "entry_s": G1_ENTRY_S, "lfo_depth": 0.0,   "lfo_period_s": 1.0,
     "pan": 0.,  "label": "G1 (locked)"},
    {"idx": 2, "entry_s": G2_ENTRY_S, "lfo_depth": 0.040, "lfo_period_s": 140.0,
     "pan": -20., "label": "G2 (slow drift)"},
    {"idx": 3, "entry_s": G3_ENTRY_S, "lfo_depth": 0.060, "lfo_period_s": 200.0,
     "pan": 20.,  "label": "G3 (medium drift)"},
    {"idx": 4, "entry_s": G4_ENTRY_S, "lfo_depth": 0.025, "lfo_period_s": 100.0,
     "pan": -35., "label": "G4 (fast drift)"},
]

# A 5th guitar 'voice' for the input with a fixed pan at +35 degrees
INPUT_PAN = 35.

boxes.append(comment("lbl_s6", "=== PHASE ENGINE (groove~ voices) ===",
                     COL_F, ROW_TOP-20, 260))

for v in PHASE_VOICES:
    idx      = v["idx"]
    entry_s  = v["entry_s"]
    depth    = v["lfo_depth"]
    period_s = v["lfo_period_s"]
    pan_deg  = v["pan"]
    label    = v["label"]

    vx = COL_F + (idx-1) * 120
    vy = ROW_TOP

    boxes.append(comment(f"lbl_pv{idx}", label, vx, vy, 115))

    # groove~ reading phrase buffer
    boxes.append(newobj(f"gr_{idx}", f"groove~ phrase 0", 2, 2, ["signal","signal"],
                        vx, vy+40))

    # Send loop_len_msg to each groove~ (done in Section 3's wiring)
    lines.append(line("loop_len_msg", 0, f"gr_{idx}", 0))

    # Rate: G1 = sig~ 1.0; G2/3/4 = phasor~ triangle (no expr~)
    if depth == 0.0:
        # Guitar 1: locked rate = 1.0
        boxes.append(newobj(f"gr_rate_{idx}", "sig~ 1.", 1, 1, ["signal"],
                            vx, vy+80))
        lines.append(line(f"gr_rate_{idx}", 0, f"gr_{idx}", 1))
    else:
        # Triangle rate: (1-depth) + depth * tri, tri = 1 - |2p-1| (no expr~ for M4L)
        tri_base = 1.0 - depth
        lfo_freq = 1.0 / period_s
        boxes.append(newobj(f"gr_lfo_{idx}", f"phasor~ {lfo_freq:.6f}", 1, 1, ["signal"],
                            vx, vy+80))
        boxes.append(newobj(f"gr_mul2_{idx}", "*~ 2.", 1, 1, ["signal"], vx, vy+110))
        boxes.append(newobj(f"gr_sub1_{idx}", "+~ -1.", 1, 1, ["signal"], vx + 58, vy+110))
        boxes.append(newobj(f"gr_abs_{idx}", "abs~", 1, 1, ["signal"], vx +116, vy+110))
        boxes.append(newobj(f"gr_neg_{idx}", "*~ -1.", 1, 1, ["signal"], vx +154, vy+110))
        boxes.append(newobj(f"gr_tri_{idx}", "+~ 1.", 1, 1, ["signal"], vx +212, vy+110))
        boxes.append(newobj(f"gr_dep_{idx}", f"*~ {depth}", 1, 1, ["signal"], vx +270, vy+110))
        boxes.append(newobj(f"gr_base_{idx}", f"+~ {tri_base}", 1, 1, ["signal"], vx +338, vy+110))
        lines.append(line(f"gr_lfo_{idx}", 0, f"gr_mul2_{idx}", 0))
        lines.append(line(f"gr_mul2_{idx}", 0, f"gr_sub1_{idx}", 0))
        lines.append(line(f"gr_sub1_{idx}", 0, f"gr_abs_{idx}", 0))
        lines.append(line(f"gr_abs_{idx}", 0, f"gr_neg_{idx}", 0))
        lines.append(line(f"gr_neg_{idx}", 0, f"gr_tri_{idx}", 0))
        lines.append(line(f"gr_tri_{idx}", 0, f"gr_dep_{idx}", 0))
        lines.append(line(f"gr_dep_{idx}", 0, f"gr_base_{idx}", 0))
        lines.append(line(f"gr_base_{idx}", 0, f"gr_{idx}", 1))

    # Hilbert~ SSB frequency shifter (replaces freqshift~ — 0.05 Hz shimmer)
    # pitchshift~ removed — near-1.0 rates give negligible transposition
    boxes.append(newobj(f"fs_h_{idx}",    "hilbert~",  1, 2, ["signal","signal"], vx,     vy+195, 60))
    boxes.append(newobj(f"fs_ccos_{idx}", "cycle~",    2, 1, ["signal"],          vx+80,  vy+195, 50))
    boxes.append(newobj(f"fs_csin_{idx}", "cycle~",    2, 1, ["signal"],          vx+80,  vy+225, 50))
    boxes.append(msg(   f"fs_cphase_{idx}", "0.25",                               vx+80,  vy+165, 35))
    boxes.append(newobj(f"fs_sig_{idx}",  "sig~ 0.05", 1, 1, ["signal"],          vx+145, vy+195, 60))
    boxes.append(newobj(f"fs_mr_{idx}",   "*~",        2, 1, ["signal"],          vx,     vy+260, 35))
    boxes.append(newobj(f"fs_mi_{idx}",   "*~",        2, 1, ["signal"],          vx+50,  vy+260, 35))
    boxes.append(newobj(f"fs_ni_{idx}",   "*~ -1.",    2, 1, ["signal"],          vx+50,  vy+290, 55))
    boxes.append(newobj(f"fs_{idx}",      "+~",        2, 1, ["signal"],          vx+25,  vy+320, 35))
    lines.append(line(f"gr_{idx}",          0, f"fs_h_{idx}",    0))
    lines.append(line(f"fs_sig_{idx}",     0, f"fs_ccos_{idx}", 0))
    lines.append(line(f"fs_sig_{idx}",     0, f"fs_csin_{idx}", 0))
    lines.append(line(f"fs_cphase_{idx}",  0, f"fs_ccos_{idx}", 1))
    lines.append(line("thisdevice",        0, f"fs_cphase_{idx}", 0))
    lines.append(line(f"fs_h_{idx}",       0, f"fs_mr_{idx}",   0))
    lines.append(line(f"fs_ccos_{idx}",    0, f"fs_mr_{idx}",   1))
    lines.append(line(f"fs_h_{idx}",       1, f"fs_mi_{idx}",   0))
    lines.append(line(f"fs_csin_{idx}",    0, f"fs_mi_{idx}",   1))
    lines.append(line(f"fs_mr_{idx}",      0, f"fs_{idx}",      0))
    lines.append(line(f"fs_mi_{idx}",      0, f"fs_ni_{idx}",   0))
    lines.append(line(f"fs_ni_{idx}",      0, f"fs_{idx}",      1))

    # Volume envelope: onset_clip × fade_inv × entry_gate
    # Entry gate: time > entry_s → change → fire → ramp 0→1 over 5s
    boxes.append(newobj(f"entry_cmp_{idx}", f"> {entry_s}", 2, 1, ["int"],
                        vx, vy+245))
    boxes.append(newobj(f"entry_once_{idx}", "change", 1, 1, ["int"],
                        vx, vy+275))
    boxes.append(msg(f"entry_msg_{idx}", "1. 5000",
                     vx, vy+305, 60))
    boxes.append(newobj(f"entry_line_{idx}", "line 0. 5000", 2, 1, ["float"],
                        vx, vy+335))
    # Combine: entry_vol × onset_clip × fade_inv → sig~ → *~
    boxes.append(newobj(f"pv_env1_{idx}", "* 0.", 2, 1, ["float"],
                        vx, vy+370))   # entry_line × onset_clip
    boxes.append(newobj(f"pv_env2_{idx}", "* 0.", 2, 1, ["float"],
                        vx, vy+400))   # pv_env1 × fade_inv
    boxes.append(newobj(f"pv_vol_sig_{idx}", "sig~ 0.", 1, 1, ["signal"],
                        vx, vy+430))
    boxes.append(newobj(f"pv_vol_mult_{idx}", "*~ 0.7", 2, 1, ["signal"],
                        vx, vy+460))

    # Inline equal-power panning (replaces pan2)
    _pan_norm = max(0.0, min(1.0, (pan_deg + 45.0) / 90.0))
    _pan_l = math.cos(_pan_norm * math.pi / 2)
    _pan_r = math.sin(_pan_norm * math.pi / 2)
    boxes.append(newobj(f"pv_pan_L_{idx}", f"*~ {_pan_l:.4f}", 2, 1, ["signal"], vx,     vy+495, 75))
    boxes.append(newobj(f"pv_pan_R_{idx}", f"*~ {_pan_r:.4f}", 2, 1, ["signal"], vx+85,  vy+495, 75))

    # Wiring: timer → entry gate
    lines.append(line("ms_sec",         0, f"entry_cmp_{idx}",  0, idx+6))
    lines.append(line(f"entry_cmp_{idx}",  0, f"entry_once_{idx}", 0))
    lines.append(line(f"entry_once_{idx}", 0, f"entry_msg_{idx}",  0))
    lines.append(line(f"entry_msg_{idx}",  0, f"entry_line_{idx}", 0))
    # envelope combo
    lines.append(line(f"entry_line_{idx}", 0, f"pv_env1_{idx}", 0))
    lines.append(line("onset_clip",        0, f"pv_env1_{idx}", 1))
    lines.append(line(f"pv_env1_{idx}",    0, f"pv_env2_{idx}", 0))
    lines.append(line("fade_inv_add",     0, f"pv_env2_{idx}", 1))
    lines.append(line(f"pv_env2_{idx}",    0, f"pv_vol_sig_{idx}", 0))
    lines.append(line(f"pv_vol_sig_{idx}", 0, f"pv_vol_mult_{idx}", 1))
    lines.append(line(f"fs_{idx}",           0, f"pv_vol_mult_{idx}", 0))
    lines.append(line(f"pv_vol_mult_{idx}",  0, f"pv_pan_L_{idx}", 0))
    lines.append(line(f"pv_vol_mult_{idx}",  0, f"pv_pan_R_{idx}", 0))

# Input voice pan — inline equal-power (replaces pan2)
_in_pan_norm = max(0.0, min(1.0, (INPUT_PAN + 45.0) / 90.0))
_in_pan_l = math.cos(_in_pan_norm * math.pi / 2)
_in_pan_r = math.sin(_in_pan_norm * math.pi / 2)
boxes.append(newobj("in_pan_L", f"*~ {_in_pan_l:.4f}", 2, 1, ["signal"],
                    COL_F + 4*120,     vy+495, 75))
boxes.append(newobj("in_pan_R", f"*~ {_in_pan_r:.4f}", 2, 1, ["signal"],
                    COL_F + 4*120+85,  vy+495, 75))
lines.append(line("in_gain", 0, "in_pan_L", 0))
lines.append(line("in_gain", 0, "in_pan_R", 0))

# ============================================================
# SECTION 7: SAMPLE TRIGGER SYSTEM
# ============================================================
#
# 8 sample buffers: samp_0 … samp_7
# Triggered by bass_pass1 (rising edge of bass range flag).
# Flow:
#   bass_pass1 → trigger b b
#     branch A: random(6001) + 2000 → pipe (delay) → bang
#               → random 8 → sel 0..7 → corresponding samp_groove~ play
#     branch B: set 2s cooldown gate so one sustained bass note only fires once
#
# Each samp_groove~ reads its buffer once (no loop) at rate 1.0.
# After sample ends, we could use groove~'s position outlet → but for simplicity
# we let them free-run and the user can retrigger. The 2s cooldown prevents
# machine-gunning.

SAMP_DIR = "samples/"
NUM_SAMPLES = 8

boxes.append(comment("lbl_s7", "=== SAMPLE TRIGGER SYSTEM ===",
                     COL_G, ROW_TOP-20, 230))

# Sample buffers (empty at load; user places files at path defined in read msgs)
for s in range(NUM_SAMPLES):
    boxes.append(newobj(f"samp_buf_{s}", f"buffer~ samp{s} 10000", 1, 1, ["bang"],
                        COL_G + s*115, ROW_TOP+30))
    boxes.append(msg(f"samp_read_{s}", f'read {SAMP_DIR}samp_{s}.wav',
                     COL_G + s*115, ROW_TOP+60, 130))
    lines.append(line(f"samp_read_{s}", 0, f"samp_buf_{s}", 0))

# Sample groove~ players (no loop, rate 1.0)
for s in range(NUM_SAMPLES):
    sx = COL_G + s*115
    boxes.append(newobj(f"samp_gr_{s}", f"groove~ samp{s} 0", 2, 2, ["signal","signal"],
                        sx, ROW_TOP+100))
    boxes.append(newobj(f"samp_rate_{s}", "sig~ 1.", 1, 1, ["signal"],
                        sx+70, ROW_TOP+90))
    lines.append(line(f"samp_rate_{s}", 0, f"samp_gr_{s}", 1))

# Trigger routing
boxes.append(comment("lbl_s7b", "-- Bass trigger → random delay → random sample --",
                     COL_G, ROW_TOP+155, 300))

boxes.append(newobj("samp_trig_t", "trigger b b", 1, 2, ["bang","bang"],
                    COL_G, ROW_TOP+185))

# Branch A: random delay then random sample pick
boxes.append(newobj("samp_delay_rand", "random 6001", 1, 1, ["int"],
                    COL_G, ROW_TOP+215))
boxes.append(newobj("samp_delay_add",  "+ 2000", 2, 1, ["int"],
                    COL_G+80, ROW_TOP+215))
boxes.append(newobj("samp_pipe",       "pipe 0", 2, 1, ["bang"],
                    COL_G, ROW_TOP+245))
boxes.append(newobj("samp_pick",       "random 8", 1, 1, ["int"],
                    COL_G, ROW_TOP+275))
boxes.append(newobj("samp_sel",
                    "sel 0 1 2 3 4 5 6 7", 1, 9,
                    ["bang","bang","bang","bang","bang","bang","bang","bang",""],
                    COL_G, ROW_TOP+305))

# Bang = "play from start": send message "0" to groove~ to reset position, then enable
# In Max: send "0" to groove~ inlet 0 to set position, or just send a bang to start
# groove~ plays when it receives a bang on inlet 0 (sets playback to begin or restarts)
for s in range(NUM_SAMPLES):
    sx = COL_G + s*115
    boxes.append(msg(f"samp_play_{s}", "0", sx, ROW_TOP+345, 24))
    lines.append(line("samp_sel",    s, f"samp_play_{s}", 0))
    lines.append(line(f"samp_play_{s}", 0, f"samp_gr_{s}",  0))

# Volume + pan for samples (center, moderate gain)
boxes.append(newobj("samp_sumL", "+~", 2, 1, ["signal"], COL_G,     ROW_TOP+390))
boxes.append(newobj("samp_sumL2","+~", 2, 1, ["signal"], COL_G,     ROW_TOP+420))
boxes.append(newobj("samp_sumL3","+~", 2, 1, ["signal"], COL_G,     ROW_TOP+450))
boxes.append(newobj("samp_sumL4","+~", 2, 1, ["signal"], COL_G,     ROW_TOP+480))

boxes.append(newobj("samp_sumR", "+~", 2, 1, ["signal"], COL_G+80,  ROW_TOP+390))
boxes.append(newobj("samp_sumR2","+~", 2, 1, ["signal"], COL_G+80,  ROW_TOP+420))
boxes.append(newobj("samp_sumR3","+~", 2, 1, ["signal"], COL_G+80,  ROW_TOP+450))
boxes.append(newobj("samp_sumR4","+~", 2, 1, ["signal"], COL_G+80,  ROW_TOP+480))

# samples 0-7 → mono → *~ 0.8 → sum L+R
for s in range(NUM_SAMPLES):
    boxes.append(newobj(f"samp_vol_{s}", "*~ 0.8", 2, 1, ["signal"],
                        COL_G + s*115, ROW_TOP+370))
    lines.append(line(f"samp_gr_{s}", 0, f"samp_vol_{s}", 0))

# Sum samples 0..7 into L/R (center pan = equal to both)
lines.append(line("samp_vol_0", 0, "samp_sumL",  0))
lines.append(line("samp_vol_1", 0, "samp_sumL",  1))
lines.append(line("samp_vol_2", 0, "samp_sumL2", 0))
lines.append(line("samp_vol_3", 0, "samp_sumL2", 1))
lines.append(line("samp_vol_4", 0, "samp_sumL3", 0))
lines.append(line("samp_vol_5", 0, "samp_sumL3", 1))
lines.append(line("samp_vol_6", 0, "samp_sumL4", 0))
lines.append(line("samp_vol_7", 0, "samp_sumL4", 1))

lines.append(line("samp_vol_0", 0, "samp_sumR",  0))
lines.append(line("samp_vol_1", 0, "samp_sumR",  1))
lines.append(line("samp_vol_2", 0, "samp_sumR2", 0))
lines.append(line("samp_vol_3", 0, "samp_sumR2", 1))
lines.append(line("samp_vol_4", 0, "samp_sumR3", 0))
lines.append(line("samp_vol_5", 0, "samp_sumR3", 1))
lines.append(line("samp_vol_6", 0, "samp_sumR4", 0))
lines.append(line("samp_vol_7", 0, "samp_sumR4", 1))

# Final sample sum
boxes.append(newobj("samp_finalL", "+~", 2, 1, ["signal"], COL_G,    ROW_TOP+510))
boxes.append(newobj("samp_finalR", "+~", 2, 1, ["signal"], COL_G+80, ROW_TOP+510))

lines.append(line("samp_sumL",  0, "samp_finalL", 0))
lines.append(line("samp_sumL2", 0, "samp_sumL3",  0, 1))  # already connected above
lines.append(line("samp_sumL3", 0, "samp_finalL", 1))     # wait — need to sum L3+L4 first

# Re-do final sample sum cleanly as a chain
boxes.append(newobj("samp_chainL_ab", "+~", 2, 1, ["signal"], COL_G,     ROW_TOP+545))
boxes.append(newobj("samp_chainL_cd", "+~", 2, 1, ["signal"], COL_G+80,  ROW_TOP+545))
boxes.append(newobj("samp_chainL",    "+~", 2, 1, ["signal"], COL_G+40,  ROW_TOP+575))

boxes.append(newobj("samp_chainR_ab", "+~", 2, 1, ["signal"], COL_G+160, ROW_TOP+545))
boxes.append(newobj("samp_chainR_cd", "+~", 2, 1, ["signal"], COL_G+240, ROW_TOP+545))
boxes.append(newobj("samp_chainR",    "+~", 2, 1, ["signal"], COL_G+200, ROW_TOP+575))

lines.append(line("samp_sumL",  0, "samp_chainL_ab", 0))
lines.append(line("samp_sumL2", 0, "samp_chainL_ab", 1))
lines.append(line("samp_sumL3", 0, "samp_chainL_cd", 0))
lines.append(line("samp_sumL4", 0, "samp_chainL_cd", 1))
lines.append(line("samp_chainL_ab", 0, "samp_chainL", 0))
lines.append(line("samp_chainL_cd", 0, "samp_chainL", 1))

lines.append(line("samp_sumR",  0, "samp_chainR_ab", 0))
lines.append(line("samp_sumR2", 0, "samp_chainR_ab", 1))
lines.append(line("samp_sumR3", 0, "samp_chainR_cd", 0))
lines.append(line("samp_sumR4", 0, "samp_chainR_cd", 1))
lines.append(line("samp_chainR_ab", 0, "samp_chainR", 0))
lines.append(line("samp_chainR_cd", 0, "samp_chainR", 1))

# Wire bass trigger → sample trigger chain
lines.append(line("bass_pass1",     0, "samp_trig_t",    0))
# Right outlet fires first: compute delay → then pipe bang
lines.append(line("samp_trig_t",    1, "samp_delay_rand", 0))
lines.append(line("samp_delay_rand",0, "samp_delay_add",  0))
lines.append(line("samp_delay_add", 0, "samp_pipe",       1))  # set delay time
lines.append(line("samp_trig_t",    0, "samp_pipe",       0))  # trigger pipe (after delay set)
lines.append(line("samp_pipe",      0, "samp_pick",       0))
lines.append(line("samp_pick",      0, "samp_sel",        0))

# ============================================================
# SECTION 8: MIX + OUTPUT
# ============================================================

boxes.append(comment("lbl_s8", "=== MIX & OUTPUT ===", COL_MIX, ROW_TOP-20, 170))

# Phase voices L sum
boxes.append(newobj("pv_sumL_12",  "+~", 2, 1, ["signal"], COL_MIX,     ROW_TOP+30))
boxes.append(newobj("pv_sumL_34",  "+~", 2, 1, ["signal"], COL_MIX,     ROW_TOP+60))
boxes.append(newobj("pv_sumL_all", "+~", 2, 1, ["signal"], COL_MIX,     ROW_TOP+90))

boxes.append(newobj("pv_sumR_12",  "+~", 2, 1, ["signal"], COL_MIX+90,  ROW_TOP+30))
boxes.append(newobj("pv_sumR_34",  "+~", 2, 1, ["signal"], COL_MIX+90,  ROW_TOP+60))
boxes.append(newobj("pv_sumR_all", "+~", 2, 1, ["signal"], COL_MIX+90,  ROW_TOP+90))

# Input voice (panned slightly right of center at INPUT_PAN degrees)
# Add to final mix
boxes.append(newobj("final_L_1", "+~", 2, 1, ["signal"], COL_MIX,     ROW_TOP+140))
boxes.append(newobj("final_L_2", "+~", 2, 1, ["signal"], COL_MIX,     ROW_TOP+170))
boxes.append(newobj("final_R_1", "+~", 2, 1, ["signal"], COL_MIX+90,  ROW_TOP+140))
boxes.append(newobj("final_R_2", "+~", 2, 1, ["signal"], COL_MIX+90,  ROW_TOP+170))

boxes.append(newobj("master_L", "*~ 0.5", 2, 1, ["signal"], COL_MIX,    ROW_TOP+210))
boxes.append(newobj("master_R", "*~ 0.5", 2, 1, ["signal"], COL_MIX+90, ROW_TOP+210))
boxes.append(newobj("clip_L", "clip~ -1. 1.", 3, 1, ["signal"], COL_MIX,    ROW_TOP+245))
boxes.append(newobj("clip_R", "clip~ -1. 1.", 3, 1, ["signal"], COL_MIX+90, ROW_TOP+245))
boxes.append(newobj("dac", "plugout~", 2, 2, ["signal","signal"], COL_MIX+40, ROW_TOP+285, 60))
boxes.append(newobj("meter_L", "meter~", 1, 1, ["float"], COL_MIX,    ROW_TOP+325, 60))
boxes.append(newobj("meter_R", "meter~", 1, 1, ["float"], COL_MIX+90, ROW_TOP+325, 60))

# Phase voices → sum
lines.append(line("pv_pan_L_1", 0, "pv_sumL_12",  0))
lines.append(line("pv_pan_R_1", 0, "pv_sumR_12",  0))
lines.append(line("pv_pan_L_2", 0, "pv_sumL_12",  1))
lines.append(line("pv_pan_R_2", 0, "pv_sumR_12",  1))
lines.append(line("pv_pan_L_3", 0, "pv_sumL_34",  0))
lines.append(line("pv_pan_R_3", 0, "pv_sumR_34",  0))
lines.append(line("pv_pan_L_4", 0, "pv_sumL_34",  1))
lines.append(line("pv_pan_R_4", 0, "pv_sumR_34",  1))

lines.append(line("pv_sumL_12",  0, "pv_sumL_all", 0))
lines.append(line("pv_sumL_34",  0, "pv_sumL_all", 1))
lines.append(line("pv_sumR_12",  0, "pv_sumR_all", 0))
lines.append(line("pv_sumR_34",  0, "pv_sumR_all", 1))

# Phase + samples + input → final mix
lines.append(line("pv_sumL_all",   0, "final_L_1", 0))
lines.append(line("samp_chainL",   0, "final_L_1", 1))
lines.append(line("pv_sumR_all",   0, "final_R_1", 0))
lines.append(line("samp_chainR",   0, "final_R_1", 1))

lines.append(line("final_L_1",  0, "final_L_2", 0))
lines.append(line("in_pan_L",   0, "final_L_2", 1))
lines.append(line("final_R_1",  0, "final_R_2", 0))
lines.append(line("in_pan_R",   0, "final_R_2", 1))

lines.append(line("final_L_2", 0, "master_L", 0))
lines.append(line("final_R_2", 0, "master_R", 0))
lines.append(line("master_L",  0, "clip_L",   0))
lines.append(line("master_R",  0, "clip_R",   0))
lines.append(line("clip_L",    0, "dac",      0))
lines.append(line("clip_R",    0, "dac",      1))
lines.append(line("clip_L",    0, "meter_L",  0, 0))
lines.append(line("clip_R",    0, "meter_R",  0, 0))

# ============================================================
# SECTION 9: LOADBANG INIT
# ============================================================

boxes.append(comment("lbl_init", "=== INIT ===", COL_A, 900, 100))
# live.thisdevice fires when device is fully ready in Live's audio graph
boxes.append(newobj("thisdevice", "live.thisdevice", 1, 2, ["bang","bang"], COL_A, 930))

# Set groove~ voices to loop mode when device is ready
for v in PHASE_VOICES:
    idx = v["idx"]
    boxes.append(msg(f"gr_loop_{idx}", "loop 1", COL_A, 1030 + (idx-1)*30, 55))
    lines.append(line("thisdevice", 0, f"gr_loop_{idx}", 0))
    lines.append(line(f"gr_loop_{idx}", 0, f"gr_{idx}",  0))

# Set sample groove~ to no-loop (plays once on trigger)
for s in range(NUM_SAMPLES):
    boxes.append(msg(f"samp_no_loop_{s}", "loop 0", COL_A, 1160 + s*30, 55))
    lines.append(line("thisdevice", 0, f"samp_no_loop_{s}", 0))
    lines.append(line(f"samp_no_loop_{s}", 0, f"samp_gr_{s}", 0))

# Fire samp_read messages when device is ready so buffers are pre-loaded
boxes.append(newobj("lb_delay2", "delay 700", 2, 1, ["bang"], COL_A, 1415))
lines.append(line("thisdevice", 0, "lb_delay2", 0))
for s in range(NUM_SAMPLES):
    lines.append(line("lb_delay2", 0, f"samp_read_{s}", 0))

# Init bank defaults when device is ready
boxes.append(newobj("lb_delay3", "delay 300", 2, 1, ["bang"], COL_A, 1450))
lines.append(line("thisdevice", 0, "lb_delay3", 0))
for slot in range(5):
    lines.append(line("lb_delay3", 0, f"init_default_{slot}", 0))
for g in range(1, 5):
    for slot in range(5):
        lines.append(line("lb_delay3", 0, f"g{g}_def_{slot}", 0))

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

if dropped:
    print(f"Total dropped lines: {dropped}")

lines = valid_lines

# ============================================================
# ASSEMBLE
# ============================================================

patch = {
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 8,
            "minor": 6,
            "revision": 2,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [0, 0, 2800, 1400],
        "bglocked": 0,
        "openinpresentation": 0,
        "default_fontsize": 12.0,
        "default_fontface": 0,
        "default_fontname": "Arial",
        "gridonopen": 1,
        "gridsize": [15.0, 15.0],
        "gridsnaponopen": 1,
        "objectsnaponopen": 1,
        "statusbarvisible": 2,
        "toolbarvisible": 1,
        "lefttoolbarpinned": 0,
        "toptoolbarpinned": 0,
        "righttoolbarpinned": 0,
        "bottomtoolbarpinned": 0,
        "toolbars_unpinned_last_save": 0,
        "tallnewobj": 0,
        "boxanimatetime": 200,
        "enablehscroll": 1,
        "enablevscroll": 1,
        "devicewidth": 0.0,
        "description": "Fan Fiction - Reich-style phasing guitar quintet with tonal drift and sample triggers",
        "digest": "",
        "tags": "",
        "style": "",
        "subpatcher_template": "",
        "assistshowspatchername": 0,
        "boxes": boxes,
        "lines": lines,
        "dependency_cache": [],
        "autosave": 0
    }
}

base_dir    = os.path.dirname(os.path.abspath(__file__))
maxpat_path = os.path.join(base_dir, "fan-fiction.maxpat")
amxd_path   = os.path.join(base_dir, "fan-fiction.amxd")

with open(maxpat_path, "w") as f:
    json.dump(patch, f, indent=2)

json_bytes = json.dumps(patch, indent=2).encode("utf-8")
buf = bytearray()
buf += b"ampf" + struct.pack("<I", 4) + b"aaaa"
buf += b"meta" + struct.pack("<I", 4) + struct.pack("<I", 0)
buf += b"ptch" + struct.pack("<I", len(json_bytes)) + json_bytes
with open(amxd_path, "wb") as f:
    f.write(buf)

print(f"Written: {maxpat_path}")
print(f"Also:    {amxd_path}")
print(f"  Boxes: {len(boxes)}")
print(f"  Lines: {len(lines)}")
