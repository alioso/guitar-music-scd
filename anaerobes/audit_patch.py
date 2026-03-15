#!/usr/bin/env python3
"""Audit the risset.maxpat patch for completeness and correctness."""
import json

with open("/Users/abailly/Repos/guitar-music-msp/risset.maxpat") as f:
    patch = json.load(f)

boxes = {b["box"]["id"]: b["box"] for b in patch["patcher"]["boxes"]}
lines = patch["patcher"]["lines"]

# Build adjacency
outgoing = {}  # id -> [(outlet, dest_id, dest_inlet)]
incoming = {}  # id -> [(inlet, src_id, src_outlet)]
for l in lines:
    src_id, src_out = l["patchline"]["source"]
    dst_id, dst_in = l["patchline"]["destination"]
    outgoing.setdefault(src_id, []).append((src_out, dst_id, dst_in))
    incoming.setdefault(dst_id, []).append((dst_in, src_id, src_out))

print("=== OBJECTS WITH NO OUTGOING CONNECTIONS ===")
for bid, b in sorted(boxes.items()):
    mc = b["maxclass"]
    if mc in ("comment",):
        continue
    if bid not in outgoing and b.get("numoutlets", 0) > 0:
        text = b.get("text", "")
        print(f"  {bid} ({text or mc})")

print("\n=== OBJECTS WITH NO INCOMING CONNECTIONS ===")
for bid, b in sorted(boxes.items()):
    mc = b["maxclass"]
    if mc in ("comment",):
        continue
    if bid not in incoming and b.get("numinlets", 0) > 0:
        text = b.get("text", "")
        if mc not in ("button", "flonum", "number"):
            print(f"  {bid} ({text or mc})")

print("\n=== SIGNAL FLOW: adc → dac trace ===")
# Trace from adc through the full graph
visited = set()
def trace(node, path="", depth=0):
    if depth > 20:
        return
    if node in visited and depth > 2:
        return
    visited.add(node)
    text = boxes.get(node, {}).get("text", "")
    mc = boxes.get(node, {}).get("maxclass", "")
    if node == "dac":
        print(f"  {'  '*depth}{node} ({text}) ✓ REACHED DAC")
        return
    for out, dst, inp in outgoing.get(node, []):
        if "lbl" not in dst:
            trace(dst, f"{path} → {dst}", depth+1)

print("From adc:")
trace("adc")

print("\n=== PER-VOICE SIGNAL CHAIN CHECK ===")
for i in range(1, 5):
    print(f"\n  Voice {i}:")
    chain = [f"tapout_{i}", f"freqshift_{i}", f"vol_mult_{i}", f"pan_{i}"]
    for j, obj in enumerate(chain):
        if obj in boxes:
            has_in = obj in incoming
            has_out = obj in outgoing
            text = boxes[obj].get("text", "")
            status = "OK" if (has_in and (has_out or obj == chain[-1])) else "ISSUE"
            ins = [f"{s}[{o}]" for (i2, s, o) in incoming.get(obj, [])]
            outs = [f"{d}[{i2}]" for (o, d, i2) in outgoing.get(obj, [])]
            print(f"    {obj} ({text}): in={ins}, out={outs} [{status}]")
    
    # Check parameter feeds
    params = [f"delay_line_msg_{i}", f"vol_line_{i}", f"fs_line_{i}", f"pan_expr_{i}"]
    for p in params:
        if p in boxes:
            has_in = p in incoming
            has_out = p in outgoing
            text = boxes[p].get("text", "")
            ins = [f"{s}" for (i2, s, o) in incoming.get(p, [])]
            outs = [f"{d}" for (o, d, i2) in outgoing.get(p, [])]
            print(f"    {p} ({text}): in={ins}, out={outs}")

print("\n=== MIX PATH CHECK ===")
mix_chain = ["sum_L_12", "sum_L_all", "mix_L", "master_gain_L", "clip_L", "dac"]
for obj in mix_chain:
    if obj in boxes:
        ins = [f"{s}" for (i2, s, o) in incoming.get(obj, [])]
        outs = [f"{d}" for (o, d, i2) in outgoing.get(obj, [])]
        text = boxes[obj].get("text", "")
        print(f"  {obj} ({text}): in={ins}, out={outs}")
