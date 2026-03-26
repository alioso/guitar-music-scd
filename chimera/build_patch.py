#!/usr/bin/env python3
"""
Build the Chimera ambient patch for Ableton Live 11 + Max for Live 8.x (MSP).
12-minute live piece: 1 input guitar + 4 ocean voices.

CONCEPT
=======
Two layers in permanent dialogue:

  THE MOTIVE  – 3 phasing delay taps (prime-ish lengths: 7.3s, 19.1s, 41.7s)
                Input guitar feeds all three continuously. Pitch-clean.
                Gentle lores~ filtering pushes taps slightly behind the live signal.

  THE OCEAN   – 4 slow groove~ voices, each reading a 20-second capture buffer.
                Only fed when the input is SWELLING (texture score → high).
                Pitch reference detected from input (yin~), locked after ~10s.
                4 harmonic presets shift the voices' pitch target mid-piece.
                Playback rates drift slowly via triangle LFOs (Eno breathing).

SWELL DETECTION
===============
  fast_env  = average~ … rms (~2205 smp ≈ 50ms @44.1k) — stock MSP (rms~ not always present)
  slow_env  = average~ … rms (44100 smp) + lores~
  texture   = clip(slow_env / (fast_env + epsilon) - threshold, 0, 1)
  → texture near 1 = sustained/swelling;  0 = angular/percussive
  texture feeds a vline~/crossfade into the ocean capture gate.

HARMONIC PRESETS (semitone offsets from detected root, voices G1..G4)
  0: 0, +7, +12, +19   open 5th / Mixolydian
  1: 0, +5, +12, +17   quartal / very Eno
  2: 0, +7, +14, +21   major-7th airy
  3: 0, +5, +10, +17   minor-7th darker

TIMELINE (12 minutes)
=====================
  0:00 – 0:45   Awakening   Ocean G1 fades in alone (no input yet)
  0:45 – 2:00   Entry       Guitarist enters; G2 joins ocean quietly
  2:00 – 5:00   Deepening   Swells captured into G3; motive phases
  5:00 – 9:00   Full ocean  G4 joins; all 4 ocean voices active
  9:00 – 10:30  Saturation  Capture gate closes; ocean plays held material
  10:30 – 12:00 Dissolution Voices fade G4→G3→G2→G1; motive thins

OCEAN VOICE PARAMETERS
  G1: rate_base=0.18, rate_lfo_depth=0.05, rate_lfo_period=90s,  entry=0s
  G2: rate_base=0.25, rate_lfo_depth=0.06, rate_lfo_period=110s, entry=45s
  G3: rate_base=0.35, rate_lfo_depth=0.08, rate_lfo_period=75s,  entry=120s
  G4: rate_base=0.55, rate_lfo_depth=0.10, rate_lfo_period=60s,  entry=300s

NOTES ON MAX OBJECTS USED
  yin~        – monophonic pitch detection → MIDI note → semitone offset
  groove~     – looping playback with variable rate
  pitchshift~ – pitch correction on top of slow-rate playback
  freqshift~  – gentle shimmer on ocean output
  lores~      – low-pass for motive taps (warmth without muddiness)
  average~ rms – sliding RMS (replaces rms~ where that external is missing)
  line~ / vline~ – smooth parameter interpolation

IMPORTANT: Max's expr does NOT support clip(). Use separate clip objects.
"""

import json
import os

# ============================================================
# HELPERS  (same conventions as anaerobes + lapopie)
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
# LAYOUT CONSTANTS
# ============================================================

COL_A   = 40    # input / ezdac / dry chain
COL_B   = 280   # timer / arc / swell detection
COL_C   = 560   # pitch detection
COL_D   = 820   # motive taps
COL_E   = 1100  # ocean capture buffers
COL_F   = 1400  # ocean playback voices
COL_G   = 1750  # harmonic presets
COL_MIX = 2050  # mix + output

ROW_TOP = 40

boxes = []
lines = []

# ============================================================
# SECTION 1: INPUT + DRY PATH + EZDAC
# ============================================================

boxes.append(comment("lbl_s1", "=== INPUT ===", COL_A, ROW_TOP-20, 120))

boxes.append(newobj("ezdac", "ezdac~", 2, 0, [],
                    COL_A+160, ROW_TOP, 50))
boxes.append(comment("lbl_ezdac", "<-- enable audio", COL_A+220, ROW_TOP+4, 130))

boxes.append(newobj("adc", "adc~ 1", 1, 1, ["signal"],
                    COL_A, ROW_TOP+40))

# Dry signal (input guitar heard clean at output)
boxes.append(newobj("dry_gain", "*~ 0.85", 2, 1, ["signal"],
                    COL_A, ROW_TOP+75))
boxes.append(comment("lbl_dry", "dry (center)", COL_A+65, ROW_TOP+75, 90))

# Input connections
lines.append(line("adc", 0, "dry_gain", 0))

# ============================================================
# SECTION 2: TIMER + ARC ENVELOPES
# ============================================================
#
# Piece = 720 seconds.
# evolution: 0..1 over full 720s (used by LFO depths etc.)
# ocean_depth: ramp 0→0.7 over 300s, hold, ramp 0.7→0 over last 90s
# capture_gate: 1 until t=540s (9:00), then 0
# dissolution: onset of per-voice fade-out in Dissolution phase

boxes.append(comment("lbl_s2", "=== TIMER + ARC (720s = 12min) ===",
                     COL_B, ROW_TOP-20, 240))

boxes.append(button("start_btn", COL_B, ROW_TOP))
boxes.append(comment("lbl_start", "START", COL_B+30, ROW_TOP+4, 50))

boxes.append(button("reset_btn", COL_B+80, ROW_TOP))
boxes.append(comment("lbl_reset", "RESET/STOP", COL_B+110, ROW_TOP+4, 80))

boxes.append(msg("msg_start", "1", COL_B, ROW_TOP+35))
boxes.append(msg("msg_stop",  "0", COL_B+80, ROW_TOP+35))

boxes.append(newobj("metro", "metro 50", 2, 1, ["bang"],
                    COL_B, ROW_TOP+65))
boxes.append(newobj("counter", "counter", 5, 4,
                    ["int", "", "", "int"],
                    COL_B, ROW_TOP+95))
boxes.append(newobj("ticks_ms", "* 50", 2, 1, ["int"],
                    COL_B, ROW_TOP+130))
boxes.append(newobj("ms_sec", "/ 1000.", 2, 1, ["float"],
                    COL_B, ROW_TOP+160))

boxes.append(flonum("t_disp", COL_B, ROW_TOP+195, 70))
boxes.append(comment("lbl_sec", "sec", COL_B+75, ROW_TOP+197, 30))
boxes.append(newobj("t_min", "/ 60.", 2, 1, ["float"], COL_B+120, ROW_TOP+195))
boxes.append(flonum("min_disp", COL_B+120, ROW_TOP+225, 60))
boxes.append(comment("lbl_min", "min", COL_B+185, ROW_TOP+227, 30))

# ---- evolution = t / 720, clip 0..1 ----
boxes.append(newobj("evo_div", "/ 720.", 2, 1, ["float"], COL_B, ROW_TOP+260))
boxes.append(newobj("evo_clip", "clip 0. 1.", 3, 1, ["float"], COL_B, ROW_TOP+290))
boxes.append(comment("lbl_evo", "evolution 0..1", COL_B+80, ROW_TOP+292, 110))

# ---- capture_gate: 1 while t < 540, else 0 ----
# (t < 540) => (540 - t) => clip 0 1 => int
boxes.append(newobj("cg_sub", "- 540.", 2, 1, ["float"], COL_B+160, ROW_TOP+260))
boxes.append(newobj("cg_sign", "clip 0. 1.", 3, 1, ["float"], COL_B+160, ROW_TOP+290))
boxes.append(comment("lbl_cg", "capture gate", COL_B+245, ROW_TOP+292, 100))

# ---- onset ramp: t/3 clip 0..1 (gentle 3s fade-in) ----
boxes.append(newobj("onset_div", "/ 3.", 2, 1, ["float"], COL_B, ROW_TOP+330))
boxes.append(newobj("onset_clip", "clip 0. 1.", 3, 1, ["float"], COL_B, ROW_TOP+360))
boxes.append(comment("lbl_onset", "onset 0..1", COL_B+80, ROW_TOP+362, 90))

# Timer wiring
lines.append(line("start_btn", 0, "msg_start", 0))
lines.append(line("reset_btn", 0, "msg_stop",  0))
lines.append(line("msg_start", 0, "metro", 0))
lines.append(line("msg_stop",  0, "metro", 0))
lines.append(line("msg_stop",  0, "counter", 3))
lines.append(line("metro",   0, "counter", 0))
lines.append(line("counter", 0, "ticks_ms", 0))
lines.append(line("ticks_ms", 0, "ms_sec", 0))
lines.append(line("ms_sec", 0, "t_disp",    0, 0))
lines.append(line("ms_sec", 0, "t_min",     0, 1))
lines.append(line("ms_sec", 0, "evo_div",   0, 2))
lines.append(line("ms_sec", 0, "cg_sub",    0, 3))
lines.append(line("ms_sec", 0, "onset_div", 0, 4))
lines.append(line("t_min",  0, "min_disp", 0))
lines.append(line("evo_div",  0, "evo_clip",  0))
lines.append(line("cg_sub",   0, "cg_sign",   0))
lines.append(line("onset_div", 0, "onset_clip", 0))

# ============================================================
# SECTION 3: SWELL DETECTION (texture score)
# ============================================================
#
# fast_env = average~ … rms @ ~50ms  → fast response (stock MSP)
# slow_env = long-window RMS; smoothed by lores~ → sustained level
# ratio    = slow_env / (fast_env + 0.001)
# texture  = clip( ratio - 0.4, 0., 0.6) / 0.6   → 0=angular, 1=full swell
# A sustained swell has slow_env ≈ fast_env → ratio ≈ 1.
# A pick/release has fast spikes → fast_env >> slow_env → ratio < 1 → texture low.

boxes.append(comment("lbl_s3", "=== SWELL DETECTION ===", COL_B, ROW_TOP+410, 200))

boxes.append(newobj("rms_fast", "average~ 2205 rms", 1, 1, ["signal"],
                    COL_B, ROW_TOP+440))
boxes.append(comment("lbl_rmsf", "fast RMS (~50ms)", COL_B+70, ROW_TOP+442, 120))

boxes.append(newobj("rms_slow_raw", "average~ 44100 rms", 1, 1, ["signal"],
                    COL_B, ROW_TOP+475))
boxes.append(newobj("rms_slow_lp", "lores~ 0.3", 2, 1, ["signal"],
                    COL_B, ROW_TOP+505))
boxes.append(comment("lbl_rmss", "slow rms (1s+lp)", COL_B+70, ROW_TOP+507, 120))

# Convert to control rate for ratio calculation
boxes.append(newobj("rms_fast_sig2ctl", "snapshot~ 10", 1, 1, ["float"],
                    COL_B, ROW_TOP+540))
boxes.append(newobj("rms_slow_sig2ctl", "snapshot~ 10", 1, 1, ["float"],
                    COL_B+110, ROW_TOP+540))

# ratio = slow / (fast + 0.001)
boxes.append(newobj("swell_add_eps", "+ 0.001", 2, 1, ["float"],
                    COL_B, ROW_TOP+575))
boxes.append(newobj("swell_ratio", "/ 1.", 2, 1, ["float"],
                    COL_B, ROW_TOP+605))
boxes.append(comment("lbl_ratio", "slow/fast ratio", COL_B+65, ROW_TOP+607, 110))

# texture = clip((ratio - 0.4) / 0.6, 0, 1)
boxes.append(newobj("tex_sub", "- 0.4", 2, 1, ["float"], COL_B, ROW_TOP+640))
boxes.append(newobj("tex_div", "/ 0.6", 2, 1, ["float"], COL_B, ROW_TOP+670))
boxes.append(newobj("tex_clip", "clip 0. 1.", 3, 1, ["float"], COL_B, ROW_TOP+700))
boxes.append(comment("lbl_tex", "texture (0=angular 1=swell)", COL_B+80, ROW_TOP+702, 200))

# Smooth texture score for capture gating
boxes.append(newobj("tex_line", "line 0. 200", 2, 1, ["float"], COL_B, ROW_TOP+735))
boxes.append(comment("lbl_texl", "smoothed texture", COL_B+80, ROW_TOP+737, 120))

# Swell wiring
lines.append(line("adc", 0, "rms_fast", 0))
lines.append(line("adc", 0, "rms_slow_raw", 0))
lines.append(line("rms_slow_raw", 0, "rms_slow_lp", 0))
lines.append(line("rms_fast",     0, "rms_fast_sig2ctl", 0))
lines.append(line("rms_slow_lp",  0, "rms_slow_sig2ctl", 0))
lines.append(line("rms_fast_sig2ctl", 0, "swell_add_eps", 0))
lines.append(line("rms_slow_sig2ctl", 0, "swell_ratio",   0))   # numerator → inlet 0
lines.append(line("swell_add_eps",    0, "swell_ratio",   1))   # denominator → inlet 1
lines.append(line("swell_ratio", 0, "tex_sub", 0))
lines.append(line("tex_sub",  0, "tex_div",  0))
lines.append(line("tex_div",  0, "tex_clip", 0))
lines.append(line("tex_clip", 0, "tex_line", 0))

# ============================================================
# SECTION 4: PITCH DETECTION (auto-tracking, no button needed)
# ============================================================
#
# yin~ detects fundamental pitch in MIDI cents continuously.
# AUTO-TRACKING strategy (no performer interaction required):
#   1. Filter by confidence > 0.7
#   2. Convert cents → int semitones (quantise to nearest note)
#   3. change object: only update when semitone actually changes
#   4. line object with 5000ms ramp smooths transitions so the ocean
#      shifts harmonically without any perceptible jump
#
# The result: the harmonic center of the ocean slowly follows
# whatever the performer is playing. Long sustained notes pull the
# ocean toward them; fast angular playing doesn't move it (confidence
# gate + slow line absorb micro-fluctuations).
#
# A READ-ONLY root_disp flonum shows the current detected root.
# No interaction required from the performer.

boxes.append(comment("lbl_s4", "=== PITCH AUTO-TRACK ===", COL_C, ROW_TOP-20, 200))

boxes.append(newobj("yin", "yin~ 2048 0.9", 1, 2, ["signal", "float"],
                    COL_C, ROW_TOP+40))
boxes.append(comment("lbl_yin", "yin~ (pitch, confidence)", COL_C+110, ROW_TOP+42, 190))

# Confidence gate: only pass pitch when yin confidence > 0.7
boxes.append(newobj("conf_thresh", "> 0.7", 2, 1, ["int"],
                    COL_C+110, ROW_TOP+75))
boxes.append(newobj("conf_gate", "gate 1", 2, 1, [""],
                    COL_C, ROW_TOP+110))
boxes.append(comment("lbl_cgate", "confidence gate", COL_C+65, ROW_TOP+112, 120))

# cents → float semitones
boxes.append(newobj("cents_div", "/ 100.", 2, 1, ["float"],
                    COL_C, ROW_TOP+145))

# Quantise to integer semitone so micro-pitch-wobbles don't retrigger
boxes.append(newobj("semi_int", "int", 2, 1, [""],
                    COL_C, ROW_TOP+175))

# Only retrigger when semitone actually changes
boxes.append(newobj("semi_change", "change", 1, 1, [""],
                    COL_C, ROW_TOP+205))

# Smooth the root shift over 5 seconds — ocean harmony glides, never snaps
boxes.append(newobj("root_line", "line 0. 5000", 2, 1, ["float"],
                    COL_C, ROW_TOP+235))
boxes.append(comment("lbl_rootline", "smoothed root (5s glide)", COL_C+80, ROW_TOP+237, 170))

# Read-only display (performer can glance at this)
boxes.append(flonum("root_disp", COL_C, ROW_TOP+270, 70))
boxes.append(comment("lbl_root", "current root st", COL_C+75, ROW_TOP+272, 110))

# Pitch wiring
lines.append(line("adc",         0, "yin",         0))
lines.append(line("yin",         0, "conf_gate",   0))  # pitch → gate data inlet
lines.append(line("yin",         1, "conf_thresh",  0)) # confidence → compare
lines.append(line("conf_thresh", 0, "conf_gate",   1))  # open/close gate
lines.append(line("conf_gate",   0, "cents_div",   0))
lines.append(line("cents_div",   0, "semi_int",    0))
lines.append(line("semi_int",    0, "semi_change", 0))
lines.append(line("semi_change", 0, "root_line",   0))
lines.append(line("root_line",   0, "root_disp",   0))

# ============================================================
# SECTION 5: HARMONIC PRESETS (time-scheduled, no interaction)
# ============================================================
#
# Presets are scheduled automatically by the arc timer.
# The performer never touches anything — the harmonic character
# shifts at natural moments in the piece's shape:
#
#   t=0      Preset 0: 0, +7, +12, +19   open 5th / Mixolydian (loaded at init)
#   t=270s   Preset 1: 0, +5, +12, +17   quartal — most Eno-like, deeper in
#   t=510s   Preset 2: 0, +7, +14, +21   major-7th airy — dissolution shimmer
#
# Each preset fires a message containing 4 semitone offsets (one per ocean voice).
# These route through → unpack → per-voice f stores → pitch adder chain.
# Transitions between presets are smoothed by the 5s root_line glide already in place.

PRESETS = [
    [0, 7, 12, 19],   # 0: open 5th
    [0, 5, 12, 17],   # 1: quartal
    [0, 7, 14, 21],   # 2: major-7th airy
    [0, 5, 10, 17],   # 3: minor-7th darker (available but not auto-scheduled)
]

boxes.append(comment("lbl_s5", "=== HARMONIC PRESETS (auto) ===", COL_G, ROW_TOP-20, 220))

# Preset messages (4 offsets each, fired by time comparators)
for p_idx, offsets in enumerate(PRESETS):
    ov = " ".join(str(o) for o in offsets)
    boxes.append(msg(f"preset_msg_{p_idx}",
                     f"preset {ov}",
                     COL_G, ROW_TOP + 20 + p_idx*25,
                     150))

# Time-based triggers for presets 1 and 2
# Preset 0 is fired at loadbang (see Section 10).
# change objects prevent re-firing if the timer stalls/resets.
boxes.append(newobj("pre1_cmp", "> 270.", 2, 1, ["int"],
                    COL_G, ROW_TOP+125))
boxes.append(newobj("pre1_once", "change", 1, 1, ["int"],
                    COL_G, ROW_TOP+150))
boxes.append(newobj("pre2_cmp", "> 510.", 2, 1, ["int"],
                    COL_G, ROW_TOP+185))
boxes.append(newobj("pre2_once", "change", 1, 1, ["int"],
                    COL_G, ROW_TOP+210))
boxes.append(comment("lbl_pre1", "4:30 → quartal",   COL_G+80, ROW_TOP+152, 110))
boxes.append(comment("lbl_pre2", "8:30 → airy",      COL_G+80, ROW_TOP+212, 80))

# Wire timer → comparators → preset messages
lines.append(line("ms_sec", 0, "pre1_cmp",  0, 14))
lines.append(line("ms_sec", 0, "pre2_cmp",  0, 15))
lines.append(line("pre1_cmp",  0, "pre1_once", 0))
lines.append(line("pre1_once", 0, "preset_msg_1", 0))
lines.append(line("pre2_cmp",  0, "pre2_once", 0))
lines.append(line("pre2_once", 0, "preset_msg_2", 0))

# Route "preset" → unpack 4 values → per-voice pitch offset stores
boxes.append(newobj("preset_route", "route preset", 1, 2, ["", ""],
                    COL_G, ROW_TOP+245))
boxes.append(newobj("preset_unpack", "unpack 0 0 0 0", 1, 4, ["", "", "", ""],
                    COL_G, ROW_TOP+275))

for p_idx in range(len(PRESETS)):
    lines.append(line(f"preset_msg_{p_idx}", 0, "preset_route", 0))
lines.append(line("preset_route", 0, "preset_unpack", 0))

# Per-voice pitch offset stores (f objects holding current semitone offset)
for v_idx in range(1, 5):
    boxes.append(newobj(f"poff_store_{v_idx}", "f", 2, 1, ["float"],
                        COL_G, ROW_TOP + 315 + (v_idx-1)*30))
    lines.append(line("preset_unpack", v_idx-1, f"poff_store_{v_idx}", 0))

# Voice pitch = root + offset → combined in Section 8 per voice

# ============================================================
# SECTION 6: MOTIVE TAPS (3 phasing delays)
# ============================================================
#
# Prime-ish delay lengths ensure natural phase drift (never align exactly).
# All 3 read from the same tapin~ buffer (60s max).
# Each tap → lores~ → vol control.
# No pitch shifting — keeps motive harmonically clean.
# A gentle master motive volume fades out slowly during Dissolution.

MOTIVE_DELAYS = [7300.0, 19100.0, 41700.0]  # ms

boxes.append(comment("lbl_s6", "=== MOTIVE TAPS ===", COL_D, ROW_TOP-20, 170))

boxes.append(newobj("tapin", "tapin~ 60000", 1, 1, ["tapconnect"],
                    COL_D, ROW_TOP+30))

lines.append(line("adc", 0, "tapin", 0))

# Motive master volume:
# onset_clip provides the 3-second fade-in at piece start (0→1 over 3s).
# mot_vol_line~ scales the taps' signal level; it starts at 0.7 and is
# driven lower during Dissolution by the od_fade chain.
# onset_clip (0..1 float) → sig~ → *~ against mot_vol_line~ to combine both.
boxes.append(newobj("mot_onset_sig", "sig~ 0.", 1, 1, ["signal"],
                    COL_D+150, ROW_TOP+30))
boxes.append(newobj("mot_vol_line", "line~ 0.7 500", 2, 2, ["signal", "bang"],
                    COL_D+150, ROW_TOP+60))
boxes.append(newobj("mot_vol_mult", "*~", 2, 1, ["signal"],
                    COL_D+150, ROW_TOP+90))
boxes.append(comment("lbl_mvol", "motive envelope", COL_D+215, ROW_TOP+92, 110))
lines.append(line("onset_clip",    0, "mot_onset_sig", 0))
lines.append(line("mot_onset_sig", 0, "mot_vol_mult",  0))
lines.append(line("mot_vol_line",  0, "mot_vol_mult",  1))

for t_idx, delay_ms in enumerate(MOTIVE_DELAYS):
    tx = COL_D + t_idx * 90
    ty = ROW_TOP + 100

    boxes.append(newobj(f"tapout_{t_idx}", f"tapout~ {delay_ms}", 1, 1, ["signal"],
                        tx, ty))
    boxes.append(newobj(f"tap_lp_{t_idx}", "lores~ 3000 0.3", 2, 1, ["signal"],
                        tx, ty+35))
    boxes.append(newobj(f"tap_vol_{t_idx}", "*~ 0.5", 2, 1, ["signal"],
                        tx, ty+70))

    lines.append(line("tapin", 0, f"tapout_{t_idx}", 0))
    lines.append(line(f"tapout_{t_idx}", 0, f"tap_lp_{t_idx}", 0))
    lines.append(line(f"tap_lp_{t_idx}", 0, f"tap_vol_{t_idx}", 0))
    lines.append(line("mot_vol_mult", 0, f"tap_vol_{t_idx}", 1))

# ============================================================
# SECTION 7: OCEAN CAPTURE BUFFERS + RECORD GATE
# ============================================================
#
# 4 × 20-second buffer~ / record~ pairs.
# capture_gate (from timer) AND texture (from swell) both gate recording.
# Combined gate = capture_gate * texture_clipped > 0.1
# record~ loops continuously within each buffer when gate is open.

OCEAN_VOICES = [
    {"name": "G1", "idx": 1, "buf_sec": 20.0, "rate_base": 0.18, "rate_depth": 0.05,
     "rate_period_ms": 90000, "entry_s": 0.0,   "fade_start_s": 630.0,
     "p_semitone_idx": 0},
    {"name": "G2", "idx": 2, "buf_sec": 18.0, "rate_base": 0.25, "rate_depth": 0.06,
     "rate_period_ms": 110000, "entry_s": 45.0,  "fade_start_s": 645.0,
     "p_semitone_idx": 1},
    {"name": "G3", "idx": 3, "buf_sec": 22.0, "rate_base": 0.35, "rate_depth": 0.08,
     "rate_period_ms": 75000, "entry_s": 120.0, "fade_start_s": 660.0,
     "p_semitone_idx": 2},
    {"name": "G4", "idx": 4, "buf_sec": 16.0, "rate_base": 0.55, "rate_depth": 0.10,
     "rate_period_ms": 60000, "entry_s": 300.0, "fade_start_s": 615.0,
     "p_semitone_idx": 3},
]

boxes.append(comment("lbl_s7", "=== OCEAN CAPTURE ===", COL_E, ROW_TOP-20, 180))

# Combined capture gate: texture * capture_gate (both 0..1 floats, mult → clip → int threshold)
boxes.append(newobj("cap_tex_line", "line 0. 200", 2, 1, ["float"],
                    COL_E, ROW_TOP+20))
boxes.append(newobj("cap_gate_float", "* 1.", 2, 1, ["float"],
                    COL_E, ROW_TOP+50))
boxes.append(newobj("cap_threshold", "> 0.1", 2, 1, ["int"],
                    COL_E, ROW_TOP+80))
boxes.append(comment("lbl_capgate", "combined capture gate", COL_E+60, ROW_TOP+82, 170))

lines.append(line("tex_line",  0, "cap_tex_line", 0))
lines.append(line("cap_tex_line", 0, "cap_gate_float", 0))
lines.append(line("cg_sign",   0, "cap_gate_float", 1))
lines.append(line("cap_gate_float", 0, "cap_threshold", 0))

for v in OCEAN_VOICES:
    idx = v["idx"]
    buf_ms = int(v["buf_sec"] * 1000)
    vx = COL_E + (idx-1) * 90

    # buffer~
    boxes.append(newobj(f"ocean_buf_{idx}",
                        f"buffer~ ocean{idx} {buf_ms}",
                        1, 1, ["bang"],
                        vx, ROW_TOP+120))

    # record~ for this buffer
    boxes.append(newobj(f"ocean_rec_{idx}",
                        f"record~ ocean{idx}",
                        2, 1, ["bang"],
                        vx, ROW_TOP+155))

    lines.append(line("cap_threshold", 0, f"ocean_rec_{idx}", 1))
    lines.append(line("adc",            0, f"ocean_rec_{idx}", 0))

# ============================================================
# SECTION 8: OCEAN PLAYBACK VOICES
# ============================================================
#
# Each voice:
#   groove~ ocean{n}                            – looping playback
#   rate = rate_base + rate_lfo (triangle LFO via phasor~ + expr)
#   pitchshift~ in semitones = root + preset_offset - (1 - rate)*12 compensation
#   freqshift~ 0.15 Hz for shimmer
#   *~ vol (slow envelope: entry fade-in + dissolution fade-out)
#   pan2 for stereo placement
#
# Rate compensation: groove~ at rate R transposes by log2(R)*12 semitones.
# pitchshift~ corrects this back to the preset target.
# compensation_semitones = -log2(rate) * 12  → added to preset offset.
# We approximate log2(rate) ≈ (rate-1)/ln(2) for small deviations.
# Stored in expr: expr -12. * log($f1) / 0.693
# (log() in Max expr = natural log)

boxes.append(comment("lbl_s8", "=== OCEAN PLAYBACK ===", COL_F, ROW_TOP-20, 180))

# Ocean master depth envelope:
# Ramp 0→0.7 from t=0 to t=300s, hold,  fade 0.7→0 from t=630s to t=720s
# Driven by evo_clip (0..1 over 720s):
#   phase1 ramp: clip(evo*2.4, 0, 0.7)      (0..1 at 300/720=0.416; *1.68→0.7)
#   fade:        applied per-voice based on fade_start_s
# Simpler: a single line~ driven from ms_sec trigger chain.
# We pre-bake into per-voice vol_line~ targets.
# For the master, we use a float that the timer updates via coll or thispatcher messages.
# SIMPLIFICATION: We drive ocean depth with a single flonum that the timer feeds via
# two line objects (ramp up => ramp down), triggered at the right second values.

# Piecewise ocean depth via timer comparisons
# At t>0: depth starts ramping to 0.7 over 300s → use a "when t>0 start ramp" approach
# We use the ms_sec feed → select → line objects for clean routing.

# t=0 trigger: ramp 0→0.7 in 300000ms (bang line inlet 1 errors; use message → inlet 0)
boxes.append(msg("msg_od_ramp_start", "0.7 300000", COL_F-200, ROW_TOP+40, 95))
boxes.append(newobj("od_ramp_up", "line 0. 300000", 2, 1, ["float"],
                    COL_F-80, ROW_TOP+40))
boxes.append(comment("lbl_odramp", "ocean depth", COL_F-5, ROW_TOP+42, 80))

# t=630s trigger compares (checked every 50ms in timer loop)
boxes.append(newobj("od_fade_cmp", "> 630.", 2, 1, ["int"],
                    COL_F-80, ROW_TOP+75))
boxes.append(newobj("od_fade_once", "change", 1, 1, ["int"],
                    COL_F-80, ROW_TOP+105))  # only fire on rising edge
boxes.append(msg("od_fade_msg", "0. 90000", COL_F-80, ROW_TOP+135, 80))
boxes.append(newobj("od_ramp_down", "line 0.7 90000", 2, 1, ["float"],
                    COL_F-80, ROW_TOP+165))

lines.append(line("ms_sec", 0, "od_fade_cmp",   0, 5))
lines.append(line("od_fade_cmp",  0, "od_fade_once",  0))
lines.append(line("od_fade_once", 0, "od_fade_msg",   0))
lines.append(line("od_fade_msg",  0, "od_ramp_down",  0))

# Start ramp up when START pressed (message into line left inlet)
lines.append(line("start_btn", 0, "msg_od_ramp_start", 0))
lines.append(line("msg_od_ramp_start", 0, "od_ramp_up", 0))

# Ocean depth = max of up-ramp and inverse of down-ramp
# Simplification: od_ramp_down starts at 0.7 and goes to 0; when it fires it takes over.
# We use a single "ocean_depth" flonum as the final depth value, updated by whichever is active.
# Use a trigger: ramp_up feeds until od_ramp_down fires; then od_ramp_down takes over.
# Implementation: od_ramp_down sends to ocean_depth_val; od_ramp_up also sends there,
# but od_ramp_down starts later and wins (last-write wins in Max for float stores).
boxes.append(flonum("ocean_depth_val", COL_F-80, ROW_TOP+200, 60))
boxes.append(comment("lbl_odval", "ocean depth 0..0.7", COL_F-15, ROW_TOP+202, 140))
lines.append(line("od_ramp_up",   0, "ocean_depth_val", 0))
lines.append(line("od_ramp_down", 0, "ocean_depth_val", 0))

for v in OCEAN_VOICES:
    idx  = v["idx"]
    name = v["name"]
    rate_base  = v["rate_base"]
    rate_depth = v["rate_depth"]
    period_ms  = v["rate_period_ms"]
    entry_s    = v["entry_s"]
    fade_s     = v["fade_start_s"]
    p_idx      = v["p_semitone_idx"]

    vx = COL_F + (idx-1) * 160
    vy = ROW_TOP

    boxes.append(comment(f"lbl_oc_{idx}", f"--- Ocean {name} ---", vx, vy, 120))

    # ---- Rate LFO ----
    # Triangle: 1 - abs(2p-1) without expr~ (M4L / some runtimes lack expr~)
    lfo_freq = 1.0 / (period_ms / 1000.0)
    boxes.append(newobj(f"lfo_phasor_{idx}",
                        f"phasor~ {lfo_freq:.6f}",
                        1, 1, ["signal"],
                        vx, vy+40))
    boxes.append(newobj(f"lfo_mul2_{idx}", "*~ 2.", 1, 1, ["signal"],
                        vx, vy+70))
    boxes.append(newobj(f"lfo_sub1_{idx}", "+~ -1.", 1, 1, ["signal"],
                        vx + 58, vy+70))
    boxes.append(newobj(f"lfo_abs_{idx}", "abs~", 1, 1, ["signal"],
                        vx + 116, vy+70))
    boxes.append(newobj(f"lfo_neg_{idx}", "*~ -1.", 1, 1, ["signal"],
                        vx + 154, vy+70))
    boxes.append(newobj(f"lfo_tri_{idx}", "+~ 1.", 1, 1, ["signal"],
                        vx + 212, vy+70))
    boxes.append(newobj(f"lfo_depth_{idx}", f"*~ {rate_depth}", 1, 1, ["signal"],
                        vx + 270, vy+70))
    boxes.append(newobj(f"lfo_base_{idx}", f"+~ {rate_base}", 1, 1, ["signal"],
                        vx + 338, vy+70))

    # ---- groove~ ----
    boxes.append(newobj(f"groove_{idx}",
                        f"groove~ ocean{idx} 0",
                        2, 2, ["signal", "signal"],
                        vx, vy+110))
    boxes.append(comment(f"lbl_gr_{idx}", "groove~", vx+65, vy+112, 50))

    # ---- Rate compensation: semitones = -12 * log(rate) / log(2) ----
    # Snapshot rate signal → expr
    boxes.append(newobj(f"rate_snap_{idx}", "snapshot~ 20", 1, 1, ["float"],
                        vx, vy+145))
    boxes.append(newobj(f"rate_comp_{idx}",
                        "expr -12. * log($f1 + 0.0001) / 0.6931",
                        1, 1, ["float"],
                        vx, vy+175))

    # ---- Pitch target: root + preset_offset + rate_comp ----
    # root comes from pitch_lock, preset offset from poff_store_{p_idx+1}
    # Sum via pack+expr or simple + chain
    boxes.append(newobj(f"ptch_add1_{idx}", "+ 0.", 2, 1, ["float"],
                        vx, vy+210))   # root + preset_offset
    boxes.append(newobj(f"ptch_add2_{idx}", "+ 0.", 2, 1, ["float"],
                        vx, vy+240))   # + rate_comp

    # Convert float semitones to signal for pitchshift~
    boxes.append(newobj(f"ptch_sig_{idx}", "sig~ 0.", 1, 1, ["signal"],
                        vx, vy+270))

    # pitchshift~
    boxes.append(newobj(f"pshift_{idx}", "pitchshift~ 4096", 2, 2, ["signal", "signal"],
                        vx, vy+305))

    # freqshift~ shimmer (0.15 Hz)
    boxes.append(newobj(f"fshift_{idx}", "freqshift~", 2, 2, ["signal", "signal"],
                        vx, vy+345))
    boxes.append(newobj(f"fshift_hz_{idx}", "sig~ 0.15", 1, 1, ["signal"],
                        vx+90, vy+320))

    # ---- Volume envelope ----
    # Entry fade-in: when t >= entry_s → ramp 0→1 over 10s
    # Dissolution fade-out: when t >= fade_s → ramp 1→0 over 30s
    # Combined with ocean_depth_val
    boxes.append(newobj(f"oc_env_cmp_{idx}", f"> {entry_s}", 2, 1, ["int"],
                        vx+90, vy+40))
    boxes.append(newobj(f"oc_env_once_{idx}", "change", 1, 1, ["int"],
                        vx+90, vy+70))
    boxes.append(msg(f"oc_entry_msg_{idx}", "1. 10000", vx+90, vy+100, 70))
    boxes.append(newobj(f"oc_env_line_{idx}", "line 0. 10000", 2, 1, ["float"],
                        vx+90, vy+135))

    boxes.append(newobj(f"oc_fade_cmp_{idx}", f"> {fade_s}", 2, 1, ["int"],
                        vx+90, vy+175))
    boxes.append(newobj(f"oc_fade_once_{idx}", "change", 1, 1, ["int"],
                        vx+90, vy+205))
    boxes.append(msg(f"oc_fade_msg_{idx}", "0. 30000", vx+90, vy+235, 70))

    # Combined vol = oc_env_line * ocean_depth_val
    boxes.append(newobj(f"oc_vol_mult_{idx}", "* 0.", 2, 1, ["float"],
                        vx+90, vy+270))
    boxes.append(newobj(f"oc_vol_sig_{idx}", "sig~ 0.", 1, 1, ["signal"],
                        vx+90, vy+300))
    boxes.append(newobj(f"oc_vol_mult2_{idx}", "*~", 2, 1, ["signal"],
                        vx, vy+385))

    # pan2
    pan_val = [-30., 30., -50., 50.][idx-1]
    boxes.append(newobj(f"oc_pan_{idx}", "pan2", 4, 2, ["signal", "signal"],
                        vx, vy+420))
    boxes.append(msg(f"oc_pan_msg_{idx}", str(pan_val),
                     vx+90, vy+420, 40))

    # ---- Wiring ----

    # LFO → groove rate (triangle)
    lines.append(line(f"lfo_phasor_{idx}", 0, f"lfo_mul2_{idx}", 0))
    lines.append(line(f"lfo_mul2_{idx}", 0, f"lfo_sub1_{idx}", 0))
    lines.append(line(f"lfo_sub1_{idx}", 0, f"lfo_abs_{idx}", 0))
    lines.append(line(f"lfo_abs_{idx}", 0, f"lfo_neg_{idx}", 0))
    lines.append(line(f"lfo_neg_{idx}", 0, f"lfo_tri_{idx}", 0))
    lines.append(line(f"lfo_tri_{idx}", 0, f"lfo_depth_{idx}", 0))
    lines.append(line(f"lfo_depth_{idx}", 0, f"lfo_base_{idx}", 0))
    lines.append(line(f"lfo_base_{idx}", 0, f"groove_{idx}", 1))

    # Rate compensation
    lines.append(line(f"lfo_base_{idx}",  0, f"rate_snap_{idx}", 0))
    lines.append(line(f"rate_snap_{idx}", 0, f"rate_comp_{idx}", 0))

    # Pitch chain: smoothed auto-tracked root → ptch_add1 inlet 0; poff_store → ptch_add1 inlet 1
    lines.append(line("root_line", 0, f"ptch_add1_{idx}", 0))
    lines.append(line(f"poff_store_{p_idx+1}", 0, f"ptch_add1_{idx}", 1))
    lines.append(line(f"ptch_add1_{idx}", 0, f"ptch_add2_{idx}", 0))
    lines.append(line(f"rate_comp_{idx}", 0, f"ptch_add2_{idx}", 1))
    lines.append(line(f"ptch_add2_{idx}", 0, f"ptch_sig_{idx}", 0))
    lines.append(line(f"ptch_sig_{idx}",  0, f"pshift_{idx}",   1))

    # groove → pitchshift
    lines.append(line(f"groove_{idx}", 0, f"pshift_{idx}", 0))

    # pitchshift → freqshift
    lines.append(line(f"pshift_{idx}",    0, f"fshift_{idx}", 0))
    lines.append(line(f"fshift_hz_{idx}", 0, f"fshift_{idx}", 1))

    # Volume envelope wiring
    lines.append(line("ms_sec", 0, f"oc_env_cmp_{idx}",  0, idx+5))
    lines.append(line("ms_sec", 0, f"oc_fade_cmp_{idx}", 0, idx+9))
    lines.append(line(f"oc_env_cmp_{idx}",  0, f"oc_env_once_{idx}",  0))
    lines.append(line(f"oc_env_once_{idx}", 0, f"oc_entry_msg_{idx}", 0))
    lines.append(line(f"oc_entry_msg_{idx}", 0, f"oc_env_line_{idx}", 0))
    lines.append(line(f"oc_fade_cmp_{idx}",  0, f"oc_fade_once_{idx}",  0))
    lines.append(line(f"oc_fade_once_{idx}", 0, f"oc_fade_msg_{idx}",   0))
    lines.append(line(f"oc_fade_msg_{idx}",  0, f"oc_env_line_{idx}",   0))

    # Combined vol: env_line * ocean_depth → sig~ → *~
    lines.append(line(f"oc_env_line_{idx}",  0, f"oc_vol_mult_{idx}", 0))
    lines.append(line("ocean_depth_val",     0, f"oc_vol_mult_{idx}", 1))
    lines.append(line(f"oc_vol_mult_{idx}",  0, f"oc_vol_sig_{idx}",  0))
    lines.append(line(f"oc_vol_sig_{idx}",   0, f"oc_vol_mult2_{idx}", 1))
    lines.append(line(f"fshift_{idx}",       0, f"oc_vol_mult2_{idx}", 0))

    # pan
    lines.append(line(f"oc_vol_mult2_{idx}", 0, f"oc_pan_{idx}", 0))
    lines.append(line(f"oc_pan_msg_{idx}",   0, f"oc_pan_{idx}", 1))

    # (onset_clip is used for the motive taps, not the ocean entry comparators)

# ============================================================
# SECTION 9: MIX + OUTPUT
# ============================================================

boxes.append(comment("lbl_s9", "=== MIX & OUTPUT ===", COL_MIX, ROW_TOP-20, 160))

# Motive taps → sum L/R (mono taps panned to center)
boxes.append(newobj("mot_sumL", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+30))
boxes.append(newobj("mot_sumL2", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+60))
boxes.append(newobj("mot_sumR", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+30))
boxes.append(newobj("mot_sumR2", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+60))

lines.append(line("tap_vol_0", 0, "mot_sumL",  0))
lines.append(line("tap_vol_1", 0, "mot_sumL",  1))
lines.append(line("tap_vol_0", 0, "mot_sumR",  0))
lines.append(line("tap_vol_1", 0, "mot_sumR",  1))
lines.append(line("tap_vol_2", 0, "mot_sumL2", 0))
lines.append(line("mot_sumL",  0, "mot_sumL2", 1))
lines.append(line("tap_vol_2", 0, "mot_sumR2", 0))
lines.append(line("mot_sumR",  0, "mot_sumR2", 1))

# Ocean voices → sum L/R
boxes.append(newobj("oc_sumL_12", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+110))
boxes.append(newobj("oc_sumL_34", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+140))
boxes.append(newobj("oc_sumL_all", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+170))

boxes.append(newobj("oc_sumR_12", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+110))
boxes.append(newobj("oc_sumR_34", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+140))
boxes.append(newobj("oc_sumR_all", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+170))

lines.append(line("oc_pan_1", 0, "oc_sumL_12",  0))
lines.append(line("oc_pan_1", 1, "oc_sumR_12",  0))
lines.append(line("oc_pan_2", 0, "oc_sumL_12",  1))
lines.append(line("oc_pan_2", 1, "oc_sumR_12",  1))
lines.append(line("oc_pan_3", 0, "oc_sumL_34",  0))
lines.append(line("oc_pan_3", 1, "oc_sumR_34",  0))
lines.append(line("oc_pan_4", 0, "oc_sumL_34",  1))
lines.append(line("oc_pan_4", 1, "oc_sumR_34",  1))
lines.append(line("oc_sumL_12",  0, "oc_sumL_all", 0))
lines.append(line("oc_sumL_34",  0, "oc_sumL_all", 1))
lines.append(line("oc_sumR_12",  0, "oc_sumR_all", 0))
lines.append(line("oc_sumR_34",  0, "oc_sumR_all", 1))

# Final L/R: dry + motive + ocean
boxes.append(newobj("final_L_1", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+220))
boxes.append(newobj("final_L_2", "+~", 2, 1, ["signal"], COL_MIX, ROW_TOP+255))
boxes.append(newobj("final_R_1", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+220))
boxes.append(newobj("final_R_2", "+~", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+255))

lines.append(line("dry_gain",     0, "final_L_1", 0))
lines.append(line("mot_sumL2",    0, "final_L_1", 1))
lines.append(line("dry_gain",     0, "final_R_1", 0))
lines.append(line("mot_sumR2",    0, "final_R_1", 1))
lines.append(line("final_L_1",   0, "final_L_2", 0))
lines.append(line("oc_sumL_all", 0, "final_L_2", 1))
lines.append(line("final_R_1",   0, "final_R_2", 0))
lines.append(line("oc_sumR_all", 0, "final_R_2", 1))

# Master gain
boxes.append(newobj("master_L", "*~ 0.5", 2, 1, ["signal"], COL_MIX, ROW_TOP+295))
boxes.append(newobj("master_R", "*~ 0.5", 2, 1, ["signal"], COL_MIX+80, ROW_TOP+295))

# Limiter
boxes.append(newobj("clip_L", "clip~ -1. 1.", 3, 1, ["signal"], COL_MIX, ROW_TOP+330))
boxes.append(newobj("clip_R", "clip~ -1. 1.", 3, 1, ["signal"], COL_MIX+80, ROW_TOP+330))

# DAC
boxes.append(newobj("dac", "dac~", 2, 0, [], COL_MIX+30, ROW_TOP+370, 40))

# Meters
boxes.append(newobj("meter_L", "meter~", 1, 1, ["float"], COL_MIX, ROW_TOP+410, 60))
boxes.append(newobj("meter_R", "meter~", 1, 1, ["float"], COL_MIX+80, ROW_TOP+410, 60))

lines.append(line("final_L_2", 0, "master_L", 0))
lines.append(line("final_R_2", 0, "master_R", 0))
lines.append(line("master_L",  0, "clip_L", 0))
lines.append(line("master_R",  0, "clip_R", 0))
lines.append(line("clip_L",    0, "dac",    0))
lines.append(line("clip_R",    0, "dac",    1))
lines.append(line("clip_L",    0, "meter_L", 0, 0))
lines.append(line("clip_R",    0, "meter_R", 0, 0))

# ============================================================
# SECTION 10: LOADBANG INIT
# ============================================================

boxes.append(comment("lbl_init", "=== INIT ===", COL_A, 900, 100))
boxes.append(newobj("loadbang", "loadbang", 1, 1, ["bang"],
                    COL_A, 930))
boxes.append(newobj("lb_delay", "delay 500", 2, 1, ["bang"],
                    COL_A, 960))
boxes.append(msg("msg_startwindow", "startwindow", COL_A, 990, 85))

lines.append(line("loadbang", 0, "lb_delay", 0))
lines.append(line("lb_delay", 0, "msg_startwindow", 0))
lines.append(line("msg_startwindow", 0, "dac", 0))

# Init groove~ voices to loop mode and fire preset 0 at startup
for v in OCEAN_VOICES:
    idx = v["idx"]
    boxes.append(msg(f"groove_loop_{idx}", "loop 1", COL_A, 1030 + (idx-1)*30, 55))
    lines.append(line("loadbang", 0, f"groove_loop_{idx}", 0))
    lines.append(line(f"groove_loop_{idx}", 0, f"groove_{idx}", 0))

# Fire preset 0 at loadbang so pitch offsets are initialised before any playing
boxes.append(newobj("lb_delay2", "delay 600", 2, 1, ["bang"],
                    COL_A, 1165))
lines.append(line("loadbang", 0, "lb_delay2", 0))
lines.append(line("lb_delay2", 0, "preset_msg_0", 0))

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
        "classnamespace": "dsp.toplevel",
        "rect": [0, 0, 2400, 1200],
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
        "description": "Chimera - ambient guitar piece with motive and ocean layers",
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

output_path = os.path.join(os.path.dirname(__file__), "chimera.maxpat")
with open(output_path, "w") as f:
    json.dump(patch, f, indent=2)

print(f"Written: {output_path}")
print(f"  Boxes: {len(boxes)}")
print(f"  Lines: {len(lines)}")
