# Fan Fiction

Steve Reich-style phasing guitar piece for live guitar and SuperCollider.

## Concept

Guitar input feeds a 2-bar loop buffer. Eight voices — four guitar loops and four synthesised sine oscillators — read that buffer at slightly different playback rates, drifting slowly in and out of phase with each other. The sine voices use the loop's amplitude envelope to drive pitched oscillators across four registers (sub bass → treble), building a shimmering harmonic bed as the phase relationships evolve.

After a full mix is captured to an archive buffer, the piece loops autonomously. The guitarist keeps playing on top of the archive for the remainder of the piece.

## Structure

| Time from first note | Event |
|---|---|
| 0:00 | Timer starts; loop buffer already filling |
| +8 bars (~17 s) | All 8 voices open, fade in over 8 bars (sine curve) |
| +16 bars (~35 s) | Archive recording starts; two-tone headphone cue fires |
| +80 bars (~2:55) | Archive loops; guitar stays live for playing on top |

## Guitar voices (G1–G4)

Four copies of the 2-bar loop, each at a slightly different playback rate controlled by a slow LFO. G1 is locked (no drift); the others drift over 9–15 minute cycles.

| Voice | LFO depth | LFO period | Pan |
|---|---|---|---|
| G1 | locked (0%) | — | full left (−1.0) |
| G2 | ±0.8% | 720 s (~12 min) | half left (−0.5) |
| G3 | ±1.0% | 540 s (~9 min) | half right (+0.5) |
| G4 | ±0.6% | 900 s (~15 min) | full right (+1.0) |

## Synth voices (S1–S4)

Four sine oscillators, each tracking the amplitude envelope of a phase-drifted copy of the loop. Guitar attacks trigger pitched swells; because each voice is at a different phase offset, the swells bloom at different moments — a continuously shifting harmonic shimmer.

Set `synthRoot` in Block 1 to your piece's fundamental (E=82.4, A=55.0, D=73.4, G=49.0).

| Voice | Register | Freq (E root) | LFO depth | LFO period | Pan |
|---|---|---|---|---|---|
| S1 | sub bass | E2 (82.4 Hz) | ±0.4% | 630 s | −0.75 |
| S2 | low-mid | E3 (164.8 Hz) | ±0.9% | 450 s | −0.25 |
| S3 | mid | B3 (246.9 Hz) | ±0.7% | 780 s | +0.25 |
| S4 | treble | E4 (329.6 Hz) | ±0.5% | 600 s | +0.75 |

## Click (headphones)

Two-tier click routed to `clickOutChan` (default: SC output 2 = device ch 3):
- **880 Hz** every quarter note — tempo pulse
- **1200 Hz** every 2 bars — loop boundary accent (tells you when the 2-bar phrase resets)

Set `metronomeOn: true` (default). Requires Scarlett 4i4+ or Aggregate Device with outputs 3+4 as headphones. SC startup must set `numOutputBusChannels = 4`.

A two-tone descending cue (1000 Hz → 650 Hz) fires in the headphones when archive recording starts.

## Key levels

| Parameter | Value | Notes |
|---|---|---|
| `dryAmp` | 0.65 | dry guitar through mix |
| `voiceAmp` | 0.52 | per guitar voice |
| `synthVoiceAmp` | 0.28 | global synth scale (per-voice `amp` multipliers: 1.8 / 1.2 / 0.9 / 0.7) |
| `reverbMix` | 0.07 | subtle space |
| `threshold` | 0.015 | first-note detection |

## Reverb

GVerb: size 30, decay 4.5 s, damp 0.4.

## How to run

1. Open `fan-fiction.scd` in SuperCollider
2. Evaluate **Block 1** — loads config
3. Evaluate **Block 2** — allocates buffers, arms detection
4. Play guitar — piece starts on first note above threshold
5. Evaluate **Block 3** to stop, or `Cmd+.`

## Tweaking (all in Block 1)

- `bpm` — tempo reference for bar-length calculations
- `threshold` — amplitude to trigger entry
- `entryBars` / `fadeBars` — voice entry timing
- `archBars` — material to capture (64 bars ≈ 2:20)
- `voiceAmp` / `dryAmp` / `synthVoiceAmp` — mix balance
- `synthRoot` — fundamental for synth voices; match to your key
- Per-voice `amp` in `synthVoices` — relative level per register
