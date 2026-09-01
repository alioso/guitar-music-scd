# External

Bare server boot for external audio sources — no guitar, no piece-level audio processing. Use it in place of one of the guitar pieces when you want to drive [visuals](../VIDEO.md) from a synth or DAW instead of the guitar rig, e.g. practicing over headphones with no guitar plugged in.

## How it works

SuperCollider boots with both input and output set to **`SCD EXTERNAL`** — an Aggregate Device built in Audio MIDI Setup (Applications → Utilities), not a Multi-Output Device. It combines:

- `BlackHole 2ch` — clock source, provides aggregate input channels 1–2
- `External Headphones` — provides aggregate output channels 1–2 (BlackHole's own output channels sit at 3–4, unused here)

CoreAudio requires input and output to share one clocked aggregate; pointing `inDevice` and `outDevice` at two independent devices (e.g. `BlackHole 2ch` in + `External Headphones` out separately) fails to boot with a `kAudioDevicePropertyStreamFormat` error. One combined aggregate is the fix.

SC runs one thing on top of that: a straight monitor passthrough (`SoundIn.ar(0) → Out.ar(0)`), so you can hear your synth/DAW while SC also reads its amplitude for `visuals/visual-osc.scd`.

This exists because some apps (Jerrican included) can only send audio to one output destination at a time — they can't fan out to both your headphones and BlackHole simultaneously via a Multi-Output Device (that only works if the app itself can send to multiple channel groups of the aggregate, which not every app supports). Routing your synth to BlackHole alone and letting SC echo it back out sidesteps that: one clean source (BlackHole) feeds both your ears (via SC's passthrough) and the visuals, and later a screen recorder can also tap that same BlackHole feed independently.

**Rebuilding `SCD EXTERNAL` on another machine:** Audio MIDI Setup → `+` → New Aggregate Device → check `External Headphones` (or your actual output device) and `BlackHole 2ch` → set Clock Source to `BlackHole 2ch`. Rename it, and update the device-name string in `external.scd` and each piece's Block 0 to match.

## How to run

1. Set your synth/DAW's audio output to `BlackHole 2ch`.
2. Open `external.scd`, evaluate **Block 1** (boot).
3. Open `visuals/visual-osc.scd`, evaluate **Block A** to start streaming amplitude to Python.
4. Run the visuals: `visuals/.venv/bin/python visuals/run.py --media visuals/drawings/`
5. Play.
6. Evaluate **Block 2** in `external.scd` and **Block B** in `visual-osc.scd` when done.

## Switching an existing piece to external input

Each piece (`fan-fiction`, `anaerobes`, `chimera`, `tryphon`, `armorika`, `vanilla`, `coronal`) also has its own **Block 0 — External input** near the top, for when you want that piece's own audio processing to run against a synth instead of the guitar, rather than using this bare piece.
