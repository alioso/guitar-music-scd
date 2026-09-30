# Tryphon

LFO-polyrhythm guitar sextet. Duration ~7 min from first note.

## Concept

The guitarist plays a 4-bar loop in strict 4/4. SC records it, marks every attack in it, normalises it, then four partner voices (P1–P4) replay slices of the recording at independent, continuously drifting tempos — never realigning. Every slice starts on one of your attacks. A fifth voice (P5) processes the live guitar input in real time with pitch transposition, reversal, and saturation. The texture evolves through three cycles, each with a new recorded source loop. The piece ends with a crescendo and a hard stop.

## Structure

| Time | Event |
|---|---|
| 0:00 | First note → 4-bar loop records (12s) |
| 0:12 | P1 enters |
| 0:24 | P2 enters |
| 0:36 | P3 enters |
| 0:48 | P4 enters — Cycle 1 full bed |
| 1:18 | P5 (live processing) enters |
| 2:57 | Voice countdown in headphones: 4–3–2–1 |
| 3:00 | Cycle 2 — P2–P4 drop, new 4-bar loop records (P1 keeps the old loop) |
| 3:12 | P1 moves to loop 2; P2–P4 rebuild staggered |
| 4:57 | Voice countdown: 4–3–2–1 |
| 5:00 | Cycle 3 — P2–P4 drop, new 4-bar loop records |
| 5:12 | P1 moves to loop 3; P2–P4 rebuild staggered |
| 6:12 | Crescendo — P1–P4 and P5 ramp to peak over 16 bars |
| 6:36 | Slow countdown: "four…three…two…one" (one word per bar) |
| 6:48 | Slow countdown repeats |
| 7:00 | Hard stop |

## How the polyrhythm works

Each partner runs an independent Routine with its own drifting clock. On every tick it rolls a probability check; if it fires, it plays a quarter-note slice (0.75 s at 80 BPM) from the recorded buffer. The tick interval is:

```
wait = stepDur × stepMul × (1 + sin(2π × driftHz × t) × driftDepth)
```

`stepMul` values are irrational ratios (1, 2^(1/12), √2·⅔, 2^(1/7)), so the voices' average tempos never realign; the drift LFO then breathes each voice's tempo by ±9–12%. A second slow LFO (`evolveHz`) drifts hit probability up and down, creating long fill and space phases that are independent across voices. The outer voices (P1, P4) also have mild saturation for warmth and grit.

**Where slices start.** While each loop records, SC marks every attack in it. Each partner reads from the position that lines up with "now" on the recording's bar grid, offset by one bar per voice (P1 reads bar 1, P2 bar 2, …) and jittered by up to ±2 sixteenths — then starts the slice at the next marked attack after that point. Fragments keep your note beginnings and stay rhythmically related to the loop.

| Voice | Pan | Tempo ratio | Hit prob | Saturation | Character |
|---|---|---|---|---|---|
| P1 | −0.75 | 1 | 0.22 | 0.40 | anchor, left, gritty |
| P2 | −0.25 | 2^(1/12) ≈ 1.059 | 0.28 | — | syncopated drift |
| P3 | +0.25 | √2·⅔ ≈ 0.943 | 0.25 | — | faster cross-rhythm |
| P4 | +0.75 | 2^(1/7) ≈ 1.104 | 0.20 | 0.40 | slow drift, right, gritty |
| P5 | random | — | — | optional | live processing |

P5 reads from an 8-second circular buffer of the live guitar and fires random effects: forward, reverse, down-4th, down-5th, down-octave, reverse+octave, saturation.

## Key levels

| Parameter | Value |
|---|---|
| `partnerAmp` | 0.16 per slice (ramps to `partnerPeak` 0.50 in the last 16 bars) |
| `liveAmp` | 0.24 for P5 (ramps to `livePeak` 0.60 in the last 16 bars) |
| `dryAmp` | 0.32 live guitar through |
| `reverbMix` | 0.15 (GVerb, subtle, fed from both channels) |
| `threshold` | 0.015 |

Each buffer is normalised to 0.7 after recording, so partner level is consistent regardless of how loudly you played. A limiter (0.95) sits on the master.

## Performance notes

**Before you play**
- Evaluate Block 1, then Block 2. Block 2 renders the countdown words (a second or two); wait for `"Tryphon — running"` in the post window.
- The click starts immediately (headphones, output channel 2). Lock in before playing.
- The piece does not start until the first note above threshold — take your time.

**The initial loop (Cycle 1)**
- Play your first note on a click downbeat. All cycle transitions and voice countdowns are timed from that moment; starting off-beat will shift the countdowns relative to the click.
- SC records exactly 4 bars from your first note. That material becomes the source pool for all four partners for the next 3 minutes.
- After 12s, partners begin entering one per 12s. Continue playing — you are the sixth voice.

**Cycle transitions (3:00 and 5:00)**
- You will hear a fast "4–3–2–1" in your headphones (four beats, one bar) immediately before the transition. That is your cue to prepare a new harmony.
- At the downbeat: P2–P4 cut suddenly. P1 keeps going on the old material. Start playing your new phrase — SC is recording for exactly 4 bars from that moment.
- After the 4-bar window, P1 switches to the new loop and partners rebuild.
- Play confidently and clearly during the recording window. Hesitation or silence will be recorded.

**Ending**
- At 6:12 a crescendo begins. All five partners get steadily louder over 16 bars.
- At 6:36 a slow voice countdown begins in headphones: "four" (one word per bar) counting down 8 bars to the hard stop.
- The piece ends at 7:00 with a hard stop. No performer action needed — be prepared for silence.

## Playing suggestions

**What works well**

- **Quarter notes and half notes.** The partners play quarter-note slices starting on your attacks. Slow, held notes give them clean attack + sustain to work with.
- **Simple chords — power chords, triads, open shapes.** P5 transposes down a 4th, 5th, and octave. Harmonically complex voicings can create awkward intervals when transposed; simple chords sit cleanly across all three intervals.
- **Consistent dynamics within each 4-bar loop.** The buffer is normalised before partners use it, so your overall volume doesn't matter. But wild dynamic swings *inside* the phrase (very quiet then very loud) will be replayed in random order by partners, which can sound incoherent. A steady moderate level per cycle sounds best.
- **Clear attacks.** Slices start on the attacks SC finds in the loop (the post window shows how many: `Loop 1 ready (N attacks)`). Articulate notes give the partners more starting points.

**What to avoid**

- **Dense 16th-note lines.** Slices are a quarter note long, so each one overlaps several of your notes; the texture turns to smear.
- **Starting between beats.** If your first note lands off the click, all voice countdowns will be slightly offset from the metronome for the whole piece.
- **Silence in the recording window.** If you hesitate during the 4-bar loop, that silence is in the buffer — and a loop with no attacks leaves the partners reading from arbitrary positions.

**What P5 does with your playing**

P5 reads from a continuously updating 8-second buffer of your live guitar. The louder and more actively you play, the richer the material P5 has to work with. P5 does not track your rhythm — it fires at exponentially-distributed random intervals (roughly 0.3–6s) and picks random fragments. Sustained held notes give P5 long, warm fragments; fast lines give it busy, layered ones.

## How to run

1. Open `tryphon.scd`
2. Evaluate **Block 1** (config) — `Cmd+Return` inside the block
3. Evaluate **Block 2** (start) — allocates buffers, renders voice cues, starts listening
4. Wait for `"Tryphon — running"` in the post window
5. Play guitar — piece responds to first note above threshold
6. The piece stops itself at 7:00; evaluate **Block 3** to stop early

## Tweaking (all in Block 1)

- `bpm` — tempo; updates all derived timing (stepDur, barDur, loopDur)
- `threshold` — amplitude to trigger first note; raise if click bleeds into mic
- `onsetSens` — attack detection inside the loop (lower = more attacks found)
- `recBars` — loop buffer length in bars (default 4 = 12s)
- `cycleTimes` — when Cycle 1→2 and 2→3 transitions happen (seconds from first note)
- `totalDur` — piece length in seconds (default 420 = 7 min)
- `partnerAmp` / `partnerPeak` / `dryAmp` — mix balance; lower `partnerAmp` if texture is too dense
- `liveAmp` / `livePeak` — P5 processing level
- `jitterSteps` — how far (in 16ths) a partner may wander from its playhead before snapping to an attack
- `partnerVoices` — per-voice `stepMul`, `hitProb`, `satAmt`, drift LFO parameters
- `clickOn` — set `false` to disable metronome (not recommended live)
- `cueVoice` — macOS TTS voice for countdowns (default `"Samantha"`)
