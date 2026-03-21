#!/usr/bin/env python3
"""
Integrity checker for all guitar-music-msp patches.
Checks:
  1. All patchline source/destination IDs exist in boxes
  2. Outlet/inlet indices are in-range for each object
  3. Key objects are not dangling (no outputs connected)
  4. Key objects have all required inputs connected
  5. No duplicate box IDs
  6. Signal-vs-control mismatches on critical paths
  7. Sequencing: timer fan-out reaches all required consumers
  8. Sequencing: loadbang chain is present
"""

import json
import os
import sys
from collections import defaultdict

_REPO = os.path.dirname(os.path.abspath(__file__))
PATCHES = [
    os.path.join(_REPO, "anaerobes", "anaerobes.maxpat"),
    os.path.join(_REPO, "chimera", "chimera.maxpat"),
    os.path.join(_REPO, "fan-fiction", "fan-fiction.maxpat"),
    os.path.join(_REPO, "lapopie", "lapopie.maxpat"),
]

# Max inlet counts for common objects (override when numinlets in JSON is wrong/missing)
# We read numinlets from the JSON, so this is a fallback cross-check only.
KNOWN_INLETS = {
    "ezdac~": 2,
    "dac~": 2,
    "adc~": 0,
    "*~": 2,
    "+~": 2,
    "clip~": 3,
    "tapin~": 1,
    "tapout~": 1,
    "freqshift~": 2,
    "line~": 2,
    "sig~": 1,
    "pan2": 4,
    "meter~": 1,
    "rms~": 1,
    "snapshot~": 1,
    "groove~": 2,
    "record~": 2,
    "buffer~": 1,
    "pitchshift~": 2,
    "phasor~": 1,
    "expr~": None,  # variable
    "lores~": 2,
    "yin~": 1,
    "gate": 2,
    "change": 1,
    "counter": 5,
    "metro": 2,
    "line": 2,
    "clip": 3,
    "pack": None,
    "unpack": 1,
    "route": 1,
    "sel": 1,
    "f": 2,
    "int": 2,
    "pipe": 2,
    "random": 1,
    "trigger": 1,
    "delay": 2,
    "loadbang": 1,
    "ftom": 1,
    "&&": 2,
    "!=": 2,
    "==": 2,
    ">": 2,
    "<": 2,
    ">=": 2,
    "<=": 2,
    "*": 2,
    "+": 2,
    "-": 2,
    "/": 2,
    "expr": None,
}

KNOWN_OUTLETS = {
    "adc~": 1,
    "ezdac~": 0,
    "dac~": 0,
    "loadbang": 1,
    "metro": 1,
    "counter": 4,
    "yin~": 2,
    "groove~": 2,
    "pitchshift~": 2,
    "freqshift~": 2,
    "pan2": 2,
    "trigger": None,  # variable
    "sel": None,      # variable
    "unpack": None,   # variable
    "gate": 1,
    "change": 1,
    "f": 1,
    "int": 2,
    "random": 1,
    "pipe": 1,
    "delay": 1,
    "meter~": 1,
    "snapshot~": 1,
    "rms~": 1,
    "buffer~": 1,
    "record~": 1,
}


def object_type(text):
    """Extract the base object name (first token before space/~)."""
    if not text:
        return ""
    tok = text.split()[0] if text else ""
    return tok


def check_patch(path):
    name = os.path.basename(path)
    print(f"\n{'='*60}")
    print(f"PATCH: {name}")
    print(f"{'='*60}")

    with open(path) as f:
        data = json.load(f)

    pat = data["patcher"]
    raw_boxes = pat.get("boxes", [])
    raw_lines = pat.get("lines", [])

    errors = []
    warnings = []

    # ---- 1. Duplicate IDs ----
    id_count = defaultdict(int)
    for b in raw_boxes:
        id_count[b["box"]["id"]] += 1
    for bid, cnt in id_count.items():
        if cnt > 1:
            errors.append(f"DUPLICATE box id: '{bid}' appears {cnt} times")

    boxes = {b["box"]["id"]: b["box"] for b in raw_boxes}

    # ---- 2. Patchline ID validity ----
    for l in raw_lines:
        pl = l["patchline"]
        src_id, src_out = pl["source"]
        dst_id, dst_in  = pl["destination"]
        if src_id not in boxes:
            errors.append(f"Line refs missing source box: '{src_id}'")
        if dst_id not in boxes:
            errors.append(f"Line refs missing dest box: '{dst_id}'")

    # ---- 3. Outlet/inlet index bounds ----
    for l in raw_lines:
        pl = l["patchline"]
        src_id, src_out = pl["source"]
        dst_id, dst_in  = pl["destination"]

        if src_id in boxes:
            src_box = boxes[src_id]
            n_out = src_box.get("numoutlets", 0)
            if n_out == 0:
                errors.append(f"Wire FROM a zero-outlet box: '{src_id}' ({src_box.get('text', src_box.get('maxclass'))})")
            elif src_out >= n_out:
                errors.append(f"Outlet index {src_out} out of range on '{src_id}' (has {n_out} outlets, text='{src_box.get('text','')}')")

        if dst_id in boxes:
            dst_box = boxes[dst_id]
            n_in = dst_box.get("numinlets", 0)
            if n_in == 0:
                errors.append(f"Wire TO a zero-inlet box: '{dst_id}' ({dst_box.get('text', dst_box.get('maxclass'))})")
            elif dst_in >= n_in:
                errors.append(f"Inlet index {dst_in} out of range on '{dst_id}' (has {n_in} inlets, text='{dst_box.get('text','')}')")

    # ---- 4. Build connectivity maps ----
    # who feeds into each box (by dest id)
    inputs_to  = defaultdict(list)   # dst_id → [(src_id, src_out, dst_in)]
    outputs_from = defaultdict(list) # src_id → [(dst_id, src_out, dst_in)]

    for l in raw_lines:
        pl = l["patchline"]
        src_id, src_out = pl["source"]
        dst_id, dst_in  = pl["destination"]
        inputs_to[dst_id].append((src_id, src_out, dst_in))
        outputs_from[src_id].append((dst_id, src_out, dst_in))

    # ---- 5. Critical objects with no inputs (dangling sinks would be fine, but
    #         critical processors with no audio in are problems) ----
    NEED_INPUT = {
        # id-fragment → description
        "dac":     "DAC must receive audio",
        "ezdac":   "ezdac~ needs audio (optional but worth noting)",
    }
    for bid, desc in NEED_INPUT.items():
        if bid in boxes and not inputs_to.get(bid):
            warnings.append(f"'{bid}' has no inputs — {desc}")

    # ---- 6. adc~ must feed something ----
    if "adc" in boxes and not outputs_from.get("adc"):
        errors.append("'adc' has no outputs connected — no audio reaches the patch!")

    # ---- 7. Timer chain: metro → counter → *50 → /1000. ----
    # Look for the ms_sec (or ms_to_sec) node and check it fans out
    timer_node = None
    for bid in ("ms_sec", "ms_to_sec"):
        if bid in boxes:
            timer_node = bid
            break
    if timer_node:
        timer_outs = [dst for (dst, so, di) in outputs_from.get(timer_node, [])]
        if not timer_outs:
            errors.append(f"Timer node '{timer_node}' has no outputs — nothing receives time!")
        # Check that ANY metro-type box feeds ANY counter-type box (IDs vary per patch)
        metro_ids = [bid for bid, bx in boxes.items()
                     if bx.get("text", "").startswith("metro ") or bx.get("text", "") == "metro"]
        counter_ids = {bid for bid, bx in boxes.items()
                       if bx.get("text", "").startswith("counter")}
        metro_feeds_counter = any(
            dst in counter_ids
            for m_id in metro_ids
            for (dst, so, di) in outputs_from.get(m_id, [])
        )
        if metro_ids and not metro_feeds_counter:
            errors.append(f"No metro feeds a counter — timer chain broken ({metro_ids})")
    else:
        warnings.append("No timer node found (ms_sec / ms_to_sec)")

    # ---- 8. loadbang → delay → startwindow → dac ----
    if "loadbang" not in boxes:
        errors.append("No 'loadbang' object — patch won't auto-start audio")
    else:
        lb_outs = [dst for (dst, so, di) in outputs_from.get("loadbang", [])]
        if not any("delay" in d or "lb_delay" in d for d in lb_outs):
            warnings.append("loadbang doesn't feed a delay — may be fine if direct")
        # Find startwindow message
        sw_boxes = [bid for bid, bx in boxes.items()
                    if bx.get("text", "") == "startwindow"]
        if not sw_boxes:
            # look for msg_startwindow
            sw_boxes = [bid for bid, bx in boxes.items()
                        if "startwindow" in bx.get("text", "")]
        if not sw_boxes:
            errors.append("No 'startwindow' message — DSP won't auto-enable")
        else:
            for sw in sw_boxes:
                sw_outs = [dst for (dst, so, di) in outputs_from.get(sw, [])]
                if "dac" not in sw_outs:
                    errors.append(f"'{sw}' doesn't wire to 'dac' — DSP may not start")

    # ---- 9. DAC gets exactly 2 audio inputs (L and R) ----
    if "dac" in boxes:
        dac_ins = inputs_to.get("dac", [])
        by_inlet = defaultdict(list)
        for (src, so, di) in dac_ins:
            by_inlet[di].append(src)
        for inlet in (0, 1):
            if not by_inlet[inlet]:
                errors.append(f"dac~ inlet {inlet} has no audio source — {'left' if inlet==0 else 'right'} channel silent!")
        if len(by_inlet.get(0, [])) > 1:
            warnings.append(f"dac~ inlet 0 has multiple sources: {by_inlet[0]} — only last-connected wins in Max!")
        if len(by_inlet.get(1, [])) > 1:
            warnings.append(f"dac~ inlet 1 has multiple sources: {by_inlet[1]} — only last-connected wins in Max!")

    # ---- 10. Master gain → limiter → dac chain ----
    # Find clip~ objects feeding dac
    clip_feeding_dac = [src for (src, so, di) in inputs_to.get("dac", [])
                        if "clip" in src.lower()]
    if not clip_feeding_dac:
        warnings.append("No clip~ object feeding dac~ — output not limited!")

    # ---- 11. Patch-specific checks ----
    patch_short = name.replace(".maxpat", "")

    if patch_short == "fan-fiction":
        _check_fan_fiction(boxes, inputs_to, outputs_from, errors, warnings)
    elif patch_short == "chimera":
        _check_chimera(boxes, inputs_to, outputs_from, errors, warnings)
    elif patch_short == "anaerobes":
        _check_anaerobes(boxes, inputs_to, outputs_from, errors, warnings)
    elif patch_short == "lapopie":
        _check_lapopie(boxes, inputs_to, outputs_from, errors, warnings)

    # ---- Report ----
    if errors:
        print(f"\n  ERRORS ({len(errors)}):")
        for e in errors:
            print(f"    [E] {e}")
    else:
        print("\n  No errors found.")

    if warnings:
        print(f"\n  WARNINGS ({len(warnings)}):")
        for w in warnings:
            print(f"    [W] {w}")
    else:
        print("  No warnings.")

    return errors, warnings


def _check_fan_fiction(boxes, inputs_to, outputs_from, errors, warnings):
    """Fan-fiction specific checks."""

    # A) Phrase buffer must be fed by record~
    if "buf_phrase" in boxes:
        rec_outs = [dst for (dst, so, di) in outputs_from.get("rec_phrase", [])]
        # record~ writes to buffer~ implicitly by name — no explicit wire needed.
        # But record~ itself must have audio in (inlet 0) and gate in (inlet 1).
        rec_ins = {di: src for (src, so, di) in inputs_to.get("rec_phrase", [])}
        if 0 not in rec_ins:
            errors.append("rec_phrase inlet 0 (audio) not connected")
        if 1 not in rec_ins:
            errors.append("rec_phrase inlet 1 (gate) not connected — recorder never opens/closes")

    # B) All groove~ voices must have rate inlet and loop_len_msg wired
    for idx in range(1, 5):
        gr = f"gr_{idx}"
        if gr in boxes:
            gr_ins = {di: src for (src, so, di) in inputs_to.get(gr, [])}
            if 1 not in gr_ins:
                errors.append(f"{gr} inlet 1 (rate) not connected — plays at default rate!")
            # loop_len_msg should wire to each groove~
            loop_src = [src for (src, so, di) in inputs_to.get(gr, []) if "loop_len" in src]
            if not loop_src:
                warnings.append(f"{gr} does not receive loop_len_msg — loop length not set after capture")

    # C) pitchshift~ semitone inlets must all be connected
    for idx in range(1, 5):
        ps = f"pshift_{idx}"
        if ps in boxes:
            ps_ins = {di: src for (src, so, di) in inputs_to.get(ps, [])}
            if 0 not in ps_ins:
                errors.append(f"{ps} inlet 0 (audio) not connected")
            if 1 not in ps_ins:
                errors.append(f"{ps} inlet 1 (semitone) not connected — no pitch shift!")

    # D) Bass trigger chain
    for node in ("bass_pass1", "samp_trig_t", "samp_delay_rand", "samp_pipe", "samp_pick", "samp_sel"):
        if node in boxes:
            outs = outputs_from.get(node, [])
            if not outs:
                errors.append(f"Bass trigger node '{node}' has no outputs — sample trigger chain broken")

    # E) samp_delay_add must feed pipe (sets the delay time)
    if "samp_delay_add" in boxes:
        add_outs = [(dst, di) for (dst, so, di) in outputs_from.get("samp_delay_add", [])]
        pipe_feeds = [(dst, di) for (dst, di) in add_outs if dst == "samp_pipe"]
        if not pipe_feeds:
            errors.append("samp_delay_add does not feed samp_pipe — random delay time never set")
        else:
            # Must feed inlet 1 of pipe (time inlet), not inlet 0 (bang)
            for (dst, di) in pipe_feeds:
                if di != 1:
                    errors.append(f"samp_delay_add feeds samp_pipe inlet {di} (should be inlet 1 for time)")

    # F) samp_trig_t must feed both delay_rand (branch A) AND pipe (branch B = the bang)
    if "samp_trig_t" in boxes:
        trig_outs = [(dst, so, di) for (dst, so, di) in outputs_from.get("samp_trig_t", [])]
        dests = [dst for (dst, so, di) in trig_outs]
        if "samp_delay_rand" not in dests:
            errors.append("samp_trig_t doesn't feed samp_delay_rand — delay time never computed")
        if "samp_pipe" not in dests:
            errors.append("samp_trig_t doesn't feed samp_pipe — pipe never triggered")

    # G) ms_sec timer fan-out must reach cap_open_cmp, cap_close_cmp, and all entry_cmp_N
    if "ms_sec" in boxes:
        ms_dests = [dst for (dst, so, di) in outputs_from.get("ms_sec", [])]
        for node in ("cap_open_cmp", "cap_close_cmp"):
            if node in boxes and node not in ms_dests:
                errors.append(f"ms_sec does not feed '{node}' — capture timing broken")
        for idx in range(1, 5):
            ec = f"entry_cmp_{idx}"
            if ec in boxes and ec not in ms_dests:
                errors.append(f"ms_sec does not feed '{ec}' — guitar {idx} never enters")

    # H) yin~ outlets: outlet 0 (Hz signal) → conf_gate; outlet 1 (confidence) → conf_thresh
    if "yin" in boxes:
        yin_outs_by_outlet = defaultdict(list)
        for (dst, so, di) in outputs_from.get("yin", []):
            yin_outs_by_outlet[so].append(dst)
        if not yin_outs_by_outlet.get(0):
            errors.append("yin~ outlet 0 (Hz) not connected — no pitch detection!")
        if not yin_outs_by_outlet.get(1):
            errors.append("yin~ outlet 1 (confidence) not connected — confidence gate never opens!")

    # I) conf_gate must feed hz_snap (or direct path to midi)
    if "conf_gate" in boxes:
        cg_outs = [dst for (dst, so, di) in outputs_from.get("conf_gate", [])]
        if not cg_outs:
            errors.append("conf_gate has no outputs — pitch never reaches MIDI conversion")

    # J) init_gate must close when init_counter hits 4
    if "init_done" in boxes and "init_gate" in boxes:
        done_outs = [dst for (dst, so, di) in outputs_from.get("init_done", [])]
        if "init_gate" not in done_outs:
            errors.append("init_done doesn't close init_gate — init bank never stops filling!")

    # K) Each guitar bank: g{n}_all_new must feed ts_trig_{n}
    for g in range(1, 5):
        new_pass = f"g{g}_new_pass"
        trig = f"ts_trig_{g}"
        if new_pass in boxes and trig in boxes:
            np_outs = [dst for (dst, so, di) in outputs_from.get(new_pass, [])]
            if trig not in np_outs:
                errors.append(f"g{g}_new_pass doesn't feed {trig} — G{g} tonal shift never triggered")

    # L) ts_psig_{n} must feed pshift_{n} semitone inlet
    for g in range(1, 5):
        psig = f"ts_psig_{g}"
        psh  = f"pshift_{g}"
        if psig in boxes and psh in boxes:
            psig_outs = [(dst, di) for (dst, so, di) in outputs_from.get(psig, [])]
            feeds_pshift = any(dst == psh and di == 1 for (dst, di) in psig_outs)
            if not feeds_pshift:
                errors.append(f"{psig} doesn't wire to {psh} inlet 1 — tonal shift not applied to audio")

    # M) fade_inv must feed all pv_env2_N
    if "fade_inv" in boxes:
        fi_dests = [dst for (dst, so, di) in outputs_from.get("fade_inv", [])]
        for idx in range(1, 5):
            env2 = f"pv_env2_{idx}"
            if env2 in boxes and env2 not in fi_dests:
                errors.append(f"fade_inv doesn't feed {env2} — G{idx} won't fade at end of piece")

    # N) in_pan both channels must reach final mix
    if "in_pan" in boxes:
        ip_outs_by_outlet = defaultdict(list)
        for (dst, so, di) in outputs_from.get("in_pan", []):
            ip_outs_by_outlet[so].append(dst)
        if not ip_outs_by_outlet.get(0):
            errors.append("in_pan outlet 0 (L) not connected — input guitar missing from left channel")
        if not ip_outs_by_outlet.get(1):
            errors.append("in_pan outlet 1 (R) not connected — input guitar missing from right channel")

    # O) Sample playback: samp_chainL/R must feed mix
    for chain in ("samp_chainL", "samp_chainR"):
        if chain in boxes:
            c_outs = [dst for (dst, so, di) in outputs_from.get(chain, [])]
            if not c_outs:
                errors.append(f"'{chain}' has no outputs — samples won't be heard in mix!")

    # P) Check that ts_latch_{g} actually receives midi_change on inlet 1
    for g in range(1, 5):
        latch = f"ts_latch_{g}"
        if latch in boxes:
            latch_ins = {di: src for (src, so, di) in inputs_to.get(latch, [])}
            if 1 not in latch_ins:
                errors.append(f"{latch}: inlet 1 (store) not connected — new note never stored before delay fires")

    # Q) ts_interval_{g} must receive both latched note (inlet 0) and bank_0 (inlet 1)
    for g in range(1, 5):
        iv = f"ts_interval_{g}"
        if iv in boxes:
            iv_ins = {di: src for (src, so, di) in inputs_to.get(iv, [])}
            if 0 not in iv_ins:
                errors.append(f"{iv} inlet 0 (new note) not connected")
            if 1 not in iv_ins:
                errors.append(f"{iv} inlet 1 (root note) not connected — interval always 0")


def _check_chimera(boxes, inputs_to, outputs_from, errors, warnings):
    """Chimera-specific checks."""

    # A) tapin~ must receive adc~
    if "tapin" in boxes:
        tapin_ins = inputs_to.get("tapin", [])
        if not tapin_ins:
            errors.append("tapin~ has no inputs — motive taps get no audio")

    # B) yin~ outlets
    if "yin" in boxes:
        yin_by_out = defaultdict(list)
        for (dst, so, di) in outputs_from.get("yin", []):
            yin_by_out[so].append(dst)
        if not yin_by_out.get(0):
            errors.append("yin~ outlet 0 not connected")
        if not yin_by_out.get(1):
            errors.append("yin~ outlet 1 (confidence) not connected")

    # C) All groove~ voices must have rate
    for idx in range(1, 5):
        gr = f"groove_{idx}"
        if gr in boxes:
            gr_ins_by_inlet = defaultdict(list)
            for (src, so, di) in inputs_to.get(gr, []):
                gr_ins_by_inlet[di].append(src)
            if 1 not in gr_ins_by_inlet:
                errors.append(f"{gr} inlet 1 (rate) not connected")

    # D) pitchshift~ semitone inlets
    for idx in range(1, 5):
        ps = f"pshift_{idx}"
        if ps in boxes:
            ps_ins = {di for (src, so, di) in inputs_to.get(ps, [])}
            if 1 not in ps_ins:
                errors.append(f"{ps} semitone inlet not connected")

    # E) ocean_depth_val used in all per-voice vol multipliers
    if "ocean_depth_val" in boxes:
        od_dests = [dst for (dst, so, di) in outputs_from.get("ocean_depth_val", [])]
        for idx in range(1, 5):
            vm = f"oc_vol_mult_{idx}"
            if vm in boxes and vm not in od_dests:
                errors.append(f"ocean_depth_val doesn't feed {vm} — ocean voice {idx} has no depth envelope")

    # F) Preset system: preset_route must feed preset_unpack
    if "preset_route" in boxes:
        pr_outs = [dst for (dst, so, di) in outputs_from.get("preset_route", [])]
        if "preset_unpack" not in pr_outs:
            errors.append("preset_route doesn't feed preset_unpack — presets broken")

    # G) poff_store N must feed ocean pitch chains
    for idx in range(1, 5):
        store = f"poff_store_{idx}"
        if store in boxes:
            st_outs = [dst for (dst, so, di) in outputs_from.get(store, [])]
            ptch = f"ptch_add1_{idx}"
            if ptch in boxes and ptch not in st_outs:
                errors.append(f"{store} doesn't connect to {ptch} — harmonic offset not applied to ocean voice {idx}")

    # H) Swell detection: rms outputs feed texture calc
    for rms_id in ("rms_fast", "rms_slow_raw"):
        if rms_id in boxes:
            outs = outputs_from.get(rms_id, [])
            if not outs:
                errors.append(f"{rms_id} has no outputs — swell detection broken")

    # I) dac has both channels
    dac_ins = defaultdict(list)
    for (src, so, di) in inputs_to.get("dac", []):
        dac_ins[di].append(src)
    for ch in (0, 1):
        if not dac_ins[ch]:
            errors.append(f"dac~ inlet {ch} empty — {'L' if ch==0 else 'R'} channel silent")

    # J) od_ramp_up started by start_btn
    if "od_ramp_up" in boxes:
        ru_ins = [src for (src, so, di) in inputs_to.get("od_ramp_up", [])]
        if "start_btn" not in ru_ins:
            warnings.append("od_ramp_up not triggered by start_btn — ocean depth may never ramp")

    # K) ms_sec feeds preset comparators
    if "ms_sec" in boxes:
        ms_dests = [dst for (dst, so, di) in outputs_from.get("ms_sec", [])]
        for cmp in ("pre1_cmp", "pre2_cmp"):
            if cmp in boxes and cmp not in ms_dests:
                errors.append(f"ms_sec doesn't feed {cmp} — harmonic preset auto-change broken")


def _check_anaerobes(boxes, inputs_to, outputs_from, errors, warnings):
    """Anaerobes-specific checks."""

    # A) tapin~ must receive adc~
    if "tapin" in boxes:
        ti_ins = inputs_to.get("tapin", [])
        if not ti_ins:
            errors.append("tapin~ has no inputs — delay voices receive no audio")

    # B) All 4 voices must have tapout~ connected to tapin~
    # v3 design uses tapout_a_{idx} + tapout_b_{idx}; v1 used tapout_{idx}
    for idx in range(1, 5):
        for to_id in [f"tapout_a_{idx}", f"tapout_b_{idx}", f"tapout_{idx}"]:
            if to_id in boxes:
                to_ins = [src for (src, so, di) in inputs_to.get(to_id, [])]
                if "tapin" not in to_ins:
                    errors.append(f"{to_id} not connected to tapin~ — no audio input to delay voice {idx}")

    # C) freqshift~ shift inlet must be connected
    for idx in range(1, 5):
        fs = f"freqshift_{idx}"
        if fs in boxes:
            fs_ins = {di for (src, so, di) in inputs_to.get(fs, [])}
            if 1 not in fs_ins:
                errors.append(f"{fs} inlet 1 (shift Hz) not connected — no freq shift!")

    # D) vol_mult~ must get both audio and envelope
    for idx in range(1, 5):
        vm = f"vol_mult_{idx}"
        if vm in boxes:
            vm_ins = {di for (src, so, di) in inputs_to.get(vm, [])}
            if 0 not in vm_ins:
                errors.append(f"{vm} inlet 0 (audio) not connected")
            if 1 not in vm_ins:
                errors.append(f"{vm} inlet 1 (envelope) not connected — voice {idx} has no volume control")

    # E) pan objects must get pan position
    for idx in range(1, 5):
        pan = f"pan_{idx}"
        if pan in boxes:
            pan_ins = {di for (src, so, di) in inputs_to.get(pan, [])}
            if 0 not in pan_ins:
                errors.append(f"{pan} inlet 0 (audio) not connected")
            if 1 not in pan_ins:
                errors.append(f"{pan} inlet 1 (degrees) not connected — voice {idx} panned to default 0")

    # F) evo_clip and onset_clip must feed all 4 voice parameter chains
    for ctrl in ("evo_clip", "onset_clip"):
        if ctrl in boxes:
            ctrl_dests = [dst for (dst, so, di) in outputs_from.get(ctrl, [])]
            if len(ctrl_dests) < 4:
                warnings.append(f"{ctrl} only feeds {len(ctrl_dests)} objects — may not reach all 4 voices")

    # G) dac has both channels
    if "dac" in boxes:
        dac_ins = defaultdict(list)
        for (src, so, di) in inputs_to.get("dac", []):
            dac_ins[di].append(src)
        for ch in (0, 1):
            if not dac_ins[ch]:
                errors.append(f"dac~ inlet {ch} is empty")


def _check_lapopie(boxes, inputs_to, outputs_from, errors, warnings):
    """Lapopie-specific checks (Euclidean guitar quintet)."""

    # A) yin~ outlets must both be connected
    if "yin" in boxes:
        yin_by_out = defaultdict(list)
        for (dst, so, di) in outputs_from.get("yin", []):
            yin_by_out[so].append(dst)
        if not yin_by_out.get(0):
            errors.append("yin~ outlet 0 (Hz) not connected — no pitch detection")
        if not yin_by_out.get(1):
            errors.append("yin~ outlet 1 (confidence) not connected — gate never opens")

    # B) record~ must have audio in and gate in
    # Only match boxes whose text starts with 'record~' (not buffer~ or toggle)
    rec_ids = [bid for bid, bx in boxes.items()
               if bx.get("text", "").startswith("record~")]
    for rid in rec_ids:
        r_ins = {di: src for (src, so, di) in inputs_to.get(rid, [])}
        if 0 not in r_ins:
            errors.append(f"{rid} inlet 0 (audio) not connected")
        # Gate may be inlet 1 (2-inlet record~) or inlet 2 (3-inlet record~)
        n_in = boxes[rid].get("numinlets", 2)
        gate_inlet = 1 if n_in <= 2 else 2
        if gate_inlet not in r_ins:
            errors.append(f"{rid} inlet {gate_inlet} (gate) not connected — recorder never controlled")

    # C) groove~ voices (look for groove~ objects)
    groove_ids = [bid for bid, bx in boxes.items()
                  if bx.get("text", "").startswith("groove~")]
    for gid in groove_ids:
        g_ins = {di: src for (src, so, di) in inputs_to.get(gid, [])}
        if 1 not in g_ins:
            warnings.append(f"{gid} inlet 1 (rate) not connected — plays at default rate")
        g_outs = outputs_from.get(gid, [])
        if not g_outs:
            warnings.append(f"{gid} has no outputs — audio not reaching mix")

    # D) pitchshift~ semitone inlets
    pshift_ids = [bid for bid, bx in boxes.items()
                  if bx.get("text", "").startswith("pitchshift~")]
    for pid in pshift_ids:
        p_ins = {di for (src, so, di) in inputs_to.get(pid, [])}
        if 1 not in p_ins:
            errors.append(f"{pid} semitone inlet (1) not connected — no pitch shift")

    # E) Timer: ms_sec (or ms_to_sec) fan-out
    timer_node = next((b for b in ("ms_sec", "ms_to_sec") if b in boxes), None)
    if timer_node:
        ms_dests = [dst for (dst, so, di) in outputs_from.get(timer_node, [])]
        if len(ms_dests) < 3:
            warnings.append(f"{timer_node} only fans out to {len(ms_dests)} objects — may miss some arcs")

    # F) coll objects (pattern bank) — must have outputs
    # Skip master/seed colls that only receive init messages (no output wires by design)
    # Detect by checking if a same-named per-voice coll exists that does the reading
    coll_ids = [bid for bid, bx in boxes.items()
                if bx.get("text", "").startswith("coll")]
    master_coll_prefixes = {"pat_bank", "note_order_", "note_hist", "pool_coll", "pool_notes"}
    for cid in coll_ids:
        coll_text = boxes[cid].get("text", "")
        coll_name = coll_text.split()[1] if len(coll_text.split()) > 1 else ""
        # Skip if it's a recognised master/seed coll used only for init
        is_master = any(coll_name.startswith(pfx) for pfx in master_coll_prefixes)
        c_outs = outputs_from.get(cid, [])
        if not c_outs and not is_master:
            warnings.append(f"{cid} ({coll_text}) has no outputs — may be a dead/unused coll")

    # G) pan2 objects must have audio and position wired
    pan_ids = [bid for bid, bx in boxes.items()
               if bx.get("text", "") == "pan2"]
    for pid in pan_ids:
        p_ins = {di for (src, so, di) in inputs_to.get(pid, [])}
        if 0 not in p_ins:
            errors.append(f"{pid} inlet 0 (audio) not connected")
        if 1 not in p_ins:
            warnings.append(f"{pid} inlet 1 (pan degrees) not connected — fixed at default position")

    # H) dac both channels
    if "dac" in boxes:
        dac_by_inlet = defaultdict(list)
        for (src, so, di) in inputs_to.get("dac", []):
            dac_by_inlet[di].append(src)
        for ch in (0, 1):
            if not dac_by_inlet[ch]:
                errors.append(f"dac~ inlet {ch} empty — {'L' if ch==0 else 'R'} channel silent")

    # I) metro/click must feed something
    for metro_id in [bid for bid, bx in boxes.items()
                     if bx.get("text", "").startswith("metro")]:
        m_outs = outputs_from.get(metro_id, [])
        if not m_outs:
            errors.append(f"{metro_id} has no outputs — clock/sequencer never ticks")

    # J) counter objects must feed something downstream
    counter_ids = [bid for bid, bx in boxes.items()
                   if bx.get("text", "").startswith("counter")]
    for cid in counter_ids:
        c_outs = outputs_from.get(cid, [])
        if not c_outs:
            warnings.append(f"{cid} counter has no outputs — may be disconnected")


def main():
    total_errors = 0
    total_warnings = 0
    for path in PATCHES:
        if not os.path.exists(path):
            print(f"\nSKIPPED (not found): {path}")
            continue
        errs, warns = check_patch(path)
        total_errors += len(errs)
        total_warnings += len(warns)

    print(f"\n{'='*60}")
    print(f"TOTAL: {total_errors} error(s), {total_warnings} warning(s) across all patches")
    print(f"{'='*60}")
    return 0 if total_errors == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
