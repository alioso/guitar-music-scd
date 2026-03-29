# Fan Fiction

Steve Reich-style phasing guitar piece. Duration ~8-9 minutes.

## Concept

Guitar input feeds a 2-bar loop buffer. Four voices read that buffer continuously at slightly different playback rates, causing them to gradually drift in and out of phase — the "Music for 18 Musicians" effect. At bar 12 the full mix is captured and looped autonomously, freeing the guitarist.

## Structure

| Time | Event |
|---|---|
| 0:00 | Guitar plays, loop buffer fills silently |
| First note detected | Timer starts |
| +8 bars | 4 voices fade in over 4 bars |
| +12 bars | Full mix recorded for 16 bars |
| +28 bars | Archive loops until end of piece |

## Voice parameters

| Voice | Rate drift | Pan | Phase cycle |
|---|---|---|---|
| G1 | none (locked) | centre | — |
| G2 | ±0.8% | L | ~8 min |
| G3 | ±1.0% | R | ~6 min |
| G4 | ±0.6% | far L | ~10 min |

## How to run

1. Boot SuperCollider, connect guitar to input 0
2. `s.boot`
3. Open `fan-fiction.scd`
4. Evaluate **Block 1** (config)
5. Evaluate **Block 2** (start piece)
6. Play guitar — piece responds to first note
7. Evaluate **Block 3** to stop, or Cmd+.

## Tweaking

All parameters are in Block 1:
- `bpm` — tempo reference (affects bar lengths only, not actual playback speed)
- `threshold` — amplitude to trigger entry (0.015 = quiet note)
- `entryBars` / `fadeBars` — timing of voice entry
- `voiceAmp` — level of each loop voice
