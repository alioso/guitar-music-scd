# Tryphon

Euclidean polyrhythm guitar quintet. Duration ~7 min from first note.

## Concept

The guitarist plays a 4-bar loop in strict 4/4. SC records it, then four partner voices play it back in interlocking euclidean rhythms — each partner firing a 1-bar fragment of the recording at its own euclidean beat. Partners use prime-length step cycles (9, 11, 13 steps) so their patterns drift continuously against the 4/4 grid and never realign within the piece (~28 min LCM). The texture evolves through three cycles, each with a new recorded harmony. At each transition all but the simplest partner drop out, the input establishes new material, and the ensemble rebuilds from scratch.

## Structure

| Time from first note | Event |
|---|---|
| 0:00 | First note → loop recording starts (4 bars / 12s) |
| +12s | P1 enters — E(3,16) |
| +24s | P2 enters — E(4,11) |
| +36s | P3 enters — E(5,9) |
| +48s | P4 enters — E(6,13) — Cycle 1 full |
| 3:00 | P2–P4 drop. P1 holds. New loop re-recorded. |
| 3:12 | P1 switches to Cycle 2 pattern. Partners re-enter staggered. |
| 5:00 | P2–P4 drop. P1 holds. New loop re-recorded. |
| 5:12 | P1 switches to Cycle 3 pattern. Partners re-enter staggered. |
| 6:36 | P2–P4 drop — duo phase (input + P1 only) |
| 7:00 | Hard stop |

## Euclidean patterns

All patterns step at 16th-note rate (80 BPM → 0.1875s per step). Prime N values give cycle lengths of 1.7s (9), 2.1s (11), and 2.4s (13) — none a multiple of the 3s bar. P1 uses N=16 (bar-aligned) as a rhythmic anchor.

| Partner | Cycle 1 | Cycle 2 | Cycle 3 | N cycle | Role |
|---|---|---|---|---|---|
| P1 | E(3,16) | E(4,16) | E(5,16) | 3.0s (bar) | anchor — stays at all transitions |
| P2 | E(4,11) | E(5,11) | E(7,11) | 2.06s | syncopated drift |
| P3 | E(5,9) | E(6,9) | E(7,9) | 1.69s | faster cross-rhythm |
| P4 | E(6,13) | E(7,13) | E(9,13) | 2.44s | slow complex drift |

Each euclidean hit plays back 1 bar (~3s) of the recorded guitar loop, reading from the current position in the loop at the moment of the hit. Overlapping hits from the same partner create washes; overlapping partners create the quintet texture.

## Key levels

| Parameter | Value |
|---|---|
| `partnerAmp` | 0.22 per hit (washes accumulate) |
| `dryAmp` | 0.58 (live guitar through) |
| `reverbMix` | 0.15 (JPverb, subtle) |
| `threshold` | 0.015 |

## Performance notes

**Before you play**
- Evaluate Block 1, then Block 2. Wait for `"Tryphon — running."` in the post window.
- The click track starts immediately (headphones, output channel 3). Lock onto it before playing.
- The piece does not start until the first note above threshold — take your time.

**The initial loop (Cycle 1)**
- Play a clear 4/4 melodic or chordal phrase. Repetition and rhythmic definition help — the partners will replay fragments of exactly what you record.
- SC records exactly 4 bars from your first note. Keep the phrase consistent across those 4 bars; the material you play in that window is what every partner will use for the next 3 minutes.
- After 12s, partners begin entering. The texture builds over the next 36s. Continue playing your original phrase — you are the 5th voice in the quintet.

**Cycle transitions (3:00 and 5:00)**
- At T=3:00 and T=5:00 you will hear P2–P4 cut out suddenly. P1 keeps going on the old material.
- This is your cue: change harmony or phrasing. The new material you play in the next 12s becomes the source loop for Cycle 2 / Cycle 3.
- Play confidently and clearly — SC is recording your new material for exactly 4 bars starting from the moment of the drop. After that window, P1 switches to the new loop and partners re-enter one by one.
- P1 switching is a second signal that the new cycle has begun.

**Tempo**
- The tempo is rigid. The click provides a constant 80 BPM quarter-note pulse with a louder downbeat on beat 1. Trust it and lock in — the euclidean polyrhythm only works when the human voice is metronomically solid.
- If you rush or lag during the initial recording, the partners will replay that feel faithfully. This is a feature, not a problem, but consistency rewards listening.

**What to expect**
- Cycle 1: partners enter sparsely (E(3,16) and E(4,11) leave a lot of space). The texture will feel open and interlocking.
- Cycle 2: slightly denser patterns. The cross-rhythms become more audible as prime-length cycles drift further from alignment.
- Cycle 3: densest patterns (E(9,13) approaches a near-continuous wash). The texture shifts from rhythmic to textural.
- Duo phase: at 6:36 the texture clears to just you and P1. This is the coda — play freely until the hard stop at 7:00.

**Ending**
- The piece ends with a hard stop at T=7:00. This is automatic — no performer action needed. Be prepared for silence.

## Reverb

Uses **JPverb** from sc3-plugins (`brew install sc3-plugins`). GVerb fallback commented in source.

Settings: size 1.1, decay 3.5s, damp 0.5, mix 0.15.

## How to run

1. Open `tryphon.scd`
2. Evaluate **Block 1** (config) — `Cmd+Return` inside the block
3. Evaluate **Block 2** (start) — allocates buffers, starts listening
4. Wait for `"Tryphon — running."` in the post window
5. Play guitar — piece responds to first note above threshold
6. Evaluate **Block 3** to stop early, or `Cmd+.`

## Tweaking (all in Block 1)

- `bpm` — tempo; also updates all derived timing
- `threshold` — amplitude to trigger first note
- `recBars` — loop buffer length in bars (default 4)
- `buildStep` — automatically 4 bars; adjust `recBars` to change partner spacing
- `cycleTimes` — when Cycle 1→2 and 2→3 transitions happen (seconds from first note)
- `endDropBefore` — length of duo phase before hard stop
- `partnerAmp` / `dryAmp` — mix balance; if texture is too dense, lower `partnerAmp`
- `patterns` — euclidean [k, n] per partner per cycle
- `clickOn` — set `false` to disable metronome (not recommended for live performance)
