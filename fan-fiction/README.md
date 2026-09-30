# Fan Fiction

Phasing guitar piece for live guitar and SuperCollider. Duration ~9 min.

## Concept

You play a steady 2-bar ostinato. Bars 7–8 after your first note are frozen into a 2-bar loop. Eight voices — four guitar copies and four synthesised sine oscillators — then read that frozen loop at slightly different playback rates, drifting slowly in and out of phase with each other and with you. G1 stays locked to your tempo; the others start exactly in phase at their entry and slide away from it. The sine voices use the loop's amplitude envelope to drive pitched oscillators across four registers (sub bass to treble), building a shimmering harmonic bed as the phase relationships evolve.

After a full mix is captured to an archive buffer, the piece loops autonomously. You keep playing on top of the archive until it fades out at ~9:00.

## Structure

| Time from first note | Event |
|---|---|
| 0:00 | First note. The click restarts on it, so its loop accent (1200 Hz) marks the loop |
| bars 7–8 | These two bars become the frozen loop — keep the ostinato steady |
| +8 bars (~17 s) | All 8 voices fade in over 8 bars |
| +16 bars (~35 s) | Archive recording starts; descending two-tone headphone cue |
| +80 bars (~2:55) | Archive loops; voices stop; guitar stays live for playing on top |
| +236 bars | Rising two-tone cue: 4 bars to the fade |
| +240 → +248 bars (~9:00) | Archive fades out over 8 bars — end |

## Guitar voices (G1–G4)

Four copies of the frozen loop, each at a playback rate controlled by a slow LFO. G1 is locked (no drift) and stays in phase with your playing; the others drift over 9–15 minute cycles. Every drifting voice starts in phase at its entry, so the separation grows gradually from unison.

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
- **1200 Hz** every 2 bars — loop boundary accent

The click runs from Block 2 so you can lock in, then restarts on your first note so the loop accent lines up with the loop. Set `metronomeOn: true` (default). Requires Scarlett 4i4+ or Aggregate Device with outputs 3+4 as headphones. SC startup must set `numOutputBusChannels = 4`.

Headphone cues: a descending two-tone (1000 → 650 Hz) when archive recording starts, a rising two-tone (650 → 1000 Hz) four bars before the final fade.

## Key levels

| Parameter | Value | Notes |
|---|---|---|
| `dryAmp` | 0.65 | dry guitar through mix |
| `voiceAmp` | 0.52 | per guitar voice |
| `synthVoiceAmp` | 0.28 | global synth scale (per-voice `amp` multipliers: 1.8 / 1.2 / 0.9 / 0.7) |
| `reverbMix` | 0.07 | subtle space |
| `threshold` | 0.015 | first-note detection |

## Reverb and output

GVerb (built-in): room 30, decay 4.5 s, damp 0.4, fed from both channels. A limiter (0.95) sits on the master.

## How to run

1. Open `fan-fiction.scd`
2. Evaluate **Block 1** — loads config
3. Evaluate **Block 2** — allocates buffers, starts the click, arms detection
4. Play guitar — piece starts on first note above threshold
5. The piece ends by itself at ~9:00; evaluate **Block 3** to clean up (or to stop early)

## Tweaking (all in Block 1)

- `bpm` — tempo reference for bar-length calculations
- `threshold` — amplitude to trigger entry
- `entryBars` / `fadeBars` — voice entry timing (the loop is the `loopBars` just before entry)
- `archBars` — material to capture before archive loop
- `endBars` / `endFadeBars` — when the final fade starts and how long it lasts
- `voiceAmp` / `dryAmp` / `synthVoiceAmp` — mix balance
- `synthRoot` — fundamental for synth voices; match to your key
- Per-voice `amp` in `synthVoices` — relative level per register
