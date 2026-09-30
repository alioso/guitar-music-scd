# Chimera

Ambient guitar — a synthesized bed tuned from your playing, plus a granular companion. Duration ~9 min.

## Concept

The guitarist opens by calibrating: SC listens for held notes and builds a harmonic bed from them — three additive voices plus a restless fourth, tuned to the pitch class you played most and the two most-played pitch classes that sit consonantly with it. The bed breathes on its own and never echoes the input. A granular "companion" made of the live guitar wanders underneath from the moment the bed locks. Three short feed windows let your held notes pull the bed voices toward new pitches; between them you play phrases over it. The piece fades autonomously at 8:30.

## Structure

| Time from first note | Event |
|---|---|
| 0:00 | Calibration begins — hold notes; each counts once it has held ~0.3 s |
| up to 1:30 | Bed locks once you've held 6 distinct pitch classes (or at 1:30 regardless); bed rises over 55 s, companion fades in over 8 s |
| 2:30–3:00 | FEED 1 — hold swells/harmonics; each pulls the nearest bed voice toward it |
| 3:00 | MOTIVE MODE — play phrases over the bed |
| 5:30–6:00 | FEED 2 |
| 6:00 | MOTIVE MODE |
| 8:00–8:30 | FEED 3 / ending swell |
| 8:30 | Fade — bed dissolves over 35 s, companion fades out |
| 9:00 | Silence — evaluate Block 3 to stop |

## Calibration and tuning

- A **note** is a pitch held steady for `stableFrames` × 100 ms (default 0.3 s). Slides, vibrato and the pitch tracker's octave glitches don't count.
- Once 6 distinct pitch classes have been held (octaves count as one), the bed locks. If you hold fewer by 1:30, it locks on what it has.
- **Root** = the pitch class you held most often, voiced between A2 and G#3 (110–208 Hz).
- **Two more voices** = the next most-held pitch classes that form a 3rd, 4th/5th or 6th with the root *and* with each other, voiced within the octave above the root. If there aren't two, the fifth and then the octave fill in.
- **P4** doubles the second voice, detuned by +1% (slow beating).

## Bed voices

| Voice | Character | Breath | Pan |
|---|---|---|---|
| P1 | additive, static, chorused | 13 s | −0.88 |
| P2 | additive, static, chorused | 17 s | +0.88 |
| P3 | additive, active (vibrato, wandering pan, extra harmonics) | 19 s | centre, wandering |
| P4 | restless: faster drift, stronger vibrato, 7 s breath | 7 s | wandering ±0.9 |

Harmonics breathe independently via LFNoise — never static, never sudden. During feed windows, each held note pulls the bed voice closest to it (in that voice's own octave) onto its pitch over 45 s.

## Companion

A granular cloud: the live input is written into an 8 s looping buffer and TGrains reads it back with wandering position, density (6–20 grains/s), grain duration (60–400 ms), rate (±8%) and pan, through a short room reverb. Fully autonomous — no phrase detection.

## Key levels

| Parameter | Value |
|---|---|
| `bedAmp` | 0.58 per voice (P4: `p4Amp` 0.38) |
| `bedReverbMix` | 0.52, 6.5 s decay (room 80) |
| `dryAmp` | 0.42 |
| `motiveReverbMix` | 0.52, 4.0 s decay (room 40) |
| `companionAmp` | 0.65 |

All reverbs are GVerb (built-in), fed from both channels. Bed, motive and companion meet on a master bus with a limiter (0.95).

## How to run

1. Open `chimera.scd`
2. Evaluate **Block 1** (config) — `Cmd+Return` inside the block
3. Evaluate **Block 2** (start)
4. Play — hold notes to calibrate the bed (post window: `BED LOCKED → … Hz`)
5. Play phrases in motive mode; hold swells in the feed windows
6. Piece fades autonomously from 8:30
7. Evaluate **Block 3** when silence is complete

## Tweaking (all in Block 1)

- `calibNotes` — distinct pitch classes needed to lock the bed (default 6)
- `stableFrames` — how long a pitch must hold to count as a note (× 100 ms)
- `calibDur` — calibration deadline (default 90 s)
- `feedWindows` — [start, end] pairs in seconds
- `freqLag` — how slowly the bed moves toward fed pitches (default 45 s)
- `bedRiseSecs` / `bedFadeSecs` — bed fade-in and fade-out times
- `fadeSec` / `totalDur` — timing of the fade and the end
