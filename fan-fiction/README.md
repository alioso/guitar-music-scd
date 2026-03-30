# Fan Fiction

Steve Reich-style phasing guitar piece. Duration ~2:55 (from first note to loop handoff).

## Concept

Guitar input feeds a 2-bar loop buffer. Four voices read that buffer at slightly different playback rates, drifting slowly in and out of phase. After the full mix is captured, the archive loops autonomously and the guitarist can stop playing.

## Structure

| Time from first note | Event |
|---|---|
| 0:00 | Timer starts; loop buffer already filling |
| +8 bars (~17 s) | 4 voices open, fade in over 8 bars (sine curve) |
| +16 bars (~35 s) | Archive recording starts (64 bars of full mix) |
| +80 bars (~2:55) | Live input stops; archive loops forever |

## Voice parameters

| Voice | LFO depth | LFO period | Pan | Phase cycle |
|---|---|---|---|---|
| G1 | locked (0%) | — | full left (−1.0) | — |
| G2 | ±0.8% | 720 s | half left (−0.5) | ~12 min |
| G3 | ±1.0% | 540 s | half right (+0.5) | ~9 min |
| G4 | ±0.6% | 900 s | full right (+1.0) | ~15 min |

## Key levels

| Parameter | Value |
|---|---|
| `dryAmp` | 0.65 |
| `voiceAmp` | 0.52 (per voice, 4 voices equal presence with dry) |
| `reverbMix` | 0.22 (JPverb, subtle space) |
| `threshold` | 0.015 |

## Reverb

Uses **JPverb** from sc3-plugins (`brew install sc3-plugins`). GVerb fallback is commented in the source if sc3-plugins not available.

Settings: size 1.2, decay 4.5 s, damp 0.4.

## Metronome (optional)

Set `metronomeOn: true` in Block 1. Requires Scarlett 4i4+ (or Aggregate Device) with outputs 3+4 mapped to headphones. SC startup file must set `numOutputBusChannels = 4`.

## How to run

1. Boot SuperCollider — server auto-starts on `s.waitForBoot`
2. Open `fan-fiction.scd`
3. Evaluate **Block 1** (config) — `Cmd+Return` inside the block
4. Evaluate **Block 2** (start) — allocates buffers, starts listening
5. Play guitar — piece responds to first note above threshold
6. Evaluate **Block 3** to stop cleanly, or `Cmd+.`

## Tweaking (all in Block 1)

- `bpm` — tempo reference for bar-length calculations
- `threshold` — amplitude to trigger entry
- `entryBars` / `fadeBars` — voice entry timing
- `archBars` — how much material to capture (default 64 bars ≈ 2:20)
- `voiceAmp` / `dryAmp` — mix balance
