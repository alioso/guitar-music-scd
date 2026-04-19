# Vanilla

Granular sampler for 5 partners. Duration ~5 min from first note.

## Concept

Three partners (P1–P3) granulate pre-recorded dry guitar files continuously, reading micro-fragments from across the buffer with position, rate, and duration all drifting autonomously. Two partners (P4–P5) capture the live input — heavily processed, never dry — in alternating 30-second windows, then granulate from those snapshots. The guitar is conceptually present throughout (P1–P3 source material is dry guitar), but nothing ever comes out dry. The piece is almost entirely not guitar.

P4 and P5 read from their capture buffers while those buffers are being overwritten on the next cycle. New material bleeds into live grains mid-playback — this overlap is intentional and produces the layered smearing texture that distinguishes P4/P5 from P1–P3.

## Structure

| Time | Event |
|---|---|
| 0:00 | First note above threshold → P1, P2, P3 begin cascading in (random within 30s) |
| 0:00 | P4 begins first capture (records input for 30s) |
| 0:30 | P4 starts granulating from its snapshot; P5 begins first capture |
| 1:00 | P5 starts granulating; P4 re-captures (overwrites its buffer) |
| 1:30 | P4 resumes granulating from new material; P5 re-captures |
| ... | P4/P5 alternate every 30s for the rest of the piece |
| 4:30 | P1, P2, P3 begin cascading out (random within ~24s) |
| 5:00 | P4, P5 fade out — piece ends |

## How the granular engine works

All five partners share one SynthDef (`van_grain`). Each voice has independently randomised grain parameters that drift continuously via slow LFOs — no parameter is ever static.

| Parameter | What it controls | Drift source |
|---|---|---|
| `pos` | Read position in buffer (0–1) | LFNoise1 at `posRate` Hz + LFNoise2 scatter |
| `rate` | Playback speed → pitch | LFNoise1 at 0.07 Hz, ±`rateDrift` semitones |
| `dur` | Grain duration | LFNoise1 at 0.18 Hz, min floor 80ms |
| `density` | Grains per second | LFNoise1 at 0.4 Hz around centre value |

The 80ms duration floor prevents crackle artifacts. The ±2 semitone default rate drift cap keeps pitch movement musical rather than glitchy — raise `rateDriftMax` in the config for more dissonance.

## Partners

| Voice | Source | Pan | Grain dur | Density | Fade |
|---|---|---|---|---|---|
| P1 | samp_1.wav | hard left (−0.8) | 80–220ms | 6–16/s | 6s asr |
| P2 | samp_2.wav | left (−0.4) | 80–220ms | 6–16/s | 6s asr |
| P3 | samp_3.wav | right (0.4) | 80–220ms | 6–16/s | 6s asr |
| P4 | live capture | hard right (0.8) | 100–280ms | 8–18/s | 8s asr |
| P5 | live capture | center (0.0) | 100–280ms | 8–18/s | 8s asr |

Uses `Pan2` (stereo). Adjust `~van.pans` to taste; values are −1 (left) to +1 (right).

## Key parameters (Block 1)

| Parameter | Default | Notes |
|---|---|---|
| `thresh` | 0.015 | Amplitude to start the piece |
| `pans` | [−0.8, −0.4, 0.4, 0.8, 0.0] | Pan2 positions: −1 (left) to +1 (right) |
| `grainDurMin` | 0.08 | Minimum grain duration in seconds — lower = crackle risk |
| `rateDriftMax` | 2.0 | Max semitone drift for all partners |
| `fadeTimeP123` | 6 | Fade envelope time (seconds) for P1–P3 |
| `fadeTimeP45` | 8 | Fade envelope time (seconds) for P4–P5 |

## Performance notes

**Before you play**
- Evaluate Block 1, then Block 2. Wait for `"Vanilla: ready"` in the post window.
- Evaluate Block 3 to arm. The piece does not start until input is detected — take your time.
- Your signal at input 0 should already be heavily processed before reaching SC. P4 and P5 capture exactly what comes in — the more interesting the processing, the more interesting the granular material.

**P1–P3 and what they use**
- P1–P3 read from pre-recorded dry guitar files (`samp_1/2/3.wav`). These are static — loaded at init and never updated. They provide a continuous grain bed from the first 30 seconds.
- The files can be any length. Longer files give the position LFO more range to wander.
- Each file is treated independently; they don't need to be harmonically related to each other or to what you play live.

**P4–P5 and the live input**
- P4 starts recording immediately on piece start. You will have 30 seconds of live material in P4 before it plays back anything. Use this time intentionally — what you play in the first 30s becomes P4's first texture layer.
- P5 doesn't start capturing until 0:30, so its first snapshot draws from a slightly different moment.
- Every 60 seconds each partner overwrites its 30s snapshot. The granular synth keeps playing from the buffer while it's being re-recorded — this creates a smearing transition effect. To hear a clean jump to new material, be doing something noticeably different when the capture window opens.
- Low density (8–10 grains/sec) on P4/P5 keeps the granulated-granulated texture open. If it turns to noise, reduce `density` in Block 1 or lower `~van.rateDriftMax`.

**The cascade in/out**
- P1–P3 enter randomly within the first 30s. You won't hear all three from the start; they appear one by one.
- P1–P3 begin fading at 4:30 and may drop out at any point before 5:00 depending on their random fade timer. Their exit is gradual and staggered, not simultaneous.
- P4 and P5 are the last sound in the piece. Plan your final 30 seconds of playing accordingly — whatever P4/P5 captured in their last window is what the piece ends on.

**What to play**
- This piece is not about rhythm or melody. Long, sustained tones or slow textures give the granular engine rich material to fragment — a chord held for 10 seconds yields far more interesting grains than a fast run.
- P1–P3 use pre-recorded material so your live playing only affects P4/P5. Playing sparsely in the first minute gives P4/P5 clear material; playing densely gives them layered chaos. Both work, but decide intentionally.
- You are not audible in the house mix (no dry signal passes through). The piece sounds identical whether you play quietly or loudly — dynamics only matter for what gets captured into the granular buffers.

## How to run

1. Place `samp_1.wav`, `samp_2.wav`, `samp_3.wav` in `vanilla/samples/`
2. Open `vanilla.scd`
3. Evaluate **Block 1** — sets `~numChans`, configures server channels
4. Boot the server if not already running (`s.boot`)
5. Evaluate **Block 2** — loads buffers, compiles SynthDefs; wait for `"Vanilla: ready"`
6. Evaluate **Block 3** — arms the piece; wait for `"Vanilla: armed"`
7. Play — piece starts on first note above threshold
8. Evaluate **STOP** block or `Cmd+.` to abort early

## Tweaking

All tunable values live in the `~van` dict in Block 1. Re-evaluate Block 1 only (not Block 2) to update them between runs without reloading buffers.

- `thresh` — raise if ambient noise triggers the piece early
- `numChans` — set before booting; server must be rebooted if changed
- `pans` — five values in -1..1; rearrange for your speaker layout
- `rateDriftMax` — lower (e.g. 0.5) for a more pitch-stable texture; raise (e.g. 4.0) for wilder pitch movement
- `grainDurMin` — raise to 0.15–0.20 if you hear crackle artifacts
- Density ranges are baked into Block 3 as `rrand` calls — edit those directly to change grain density per partner
