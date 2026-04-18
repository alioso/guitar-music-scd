# Tryphon

LFO-polyrhythm guitar sextet. Duration ~7 min from first note.

## Concept

The guitarist plays a 4-bar loop in strict 4/4. SC records it, normalises it, then four partner voices (P1–P4) replay fragments of the recording at independent, continuously drifting tempos — never realigning. A fifth voice (P5) processes the live guitar input in real time with pitch transposition, reversal, and saturation. The texture evolves through three cycles, each with a new recorded source loop. The piece ends with a 48-second crescendo and a hard stop.

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
| 3:00 | Cycle 2 — P2–P4 drop, new 4-bar loop records |
| 3:12 | P1 restarts on loop 2; P2–P4 rebuild staggered |
| 4:57 | Voice countdown: 4–3–2–1 |
| 5:00 | Cycle 3 — P2–P4 drop, new 4-bar loop records |
| 5:12 | P1 restarts on loop 3; P2–P4 rebuild staggered |
| 6:12 | Crescendo begins — all partners ramp to peak over 16 bars |
| 6:36 | Slow countdown: "four…three…two…one" (one word per bar) |
| 6:48 | Slow countdown repeats |
| 7:00 | Hard stop |

## How the polyrhythm works

Each partner runs an independent Routine with its own drifting clock. On every tick it rolls a probability check; if it fires, it spawns a 0.75s slice from the recorded buffer starting near the current playhead position. The tick interval is:

```
wait = stepDur × stepMul × (1 + sin(2π × driftHz × t) × driftDepth)
```

`stepMul` values are irrational ratios so the four voices never realign. A second slow LFO (`evolveHz`) drifts hit probability up and down, creating long fill and space phases that are independent across voices. The outer voices (P1, P4) also have mild saturation for warmth and grit.

| Voice | Pan | Tempo ratio | Hit prob | Saturation | Character |
|---|---|---|---|---|---|
| P1 | −0.75 | 1.000 | 0.22 | 0.40 | anchor, left, gritty |
| P2 | −0.25 | 1.063 | 0.28 | — | syncopated drift |
| P3 | +0.25 | 0.940 | 0.25 | — | faster cross-rhythm |
| P4 | +0.75 | 1.110 | 0.20 | 0.40 | slow drift, right, gritty |
| P5 | random | — | — | optional | live processing |

P5 reads from an 8-second circular buffer of the live guitar and fires random effects: forward, reverse, down-4th, down-5th, down-octave, reverse+octave, saturation.

## Key levels

| Parameter | Value |
|---|---|
| `partnerAmp` | 0.16 per slice (ramps to 0.50 in last 16 bars) |
| `liveAmp` | 0.24 for P5 (ramps to 0.60 in last 16 bars) |
| `dryAmp` | 0.32 live guitar through |
| `reverbMix` | 0.15 (GVerb, subtle) |
| `threshold` | 0.015 |

Each buffer is normalised to 0.7 after recording, so partner level is consistent regardless of how loudly you played.

## Performance notes

**Before you play**
- Evaluate Block 1, then Block 2. Wait for `"Tryphon — running"` in the post window.
- The click starts immediately (headphones, output channel 2). Lock in before playing.
- The piece does not start until the first note above threshold — take your time.

**The initial loop (Cycle 1)**
- Play your first note on a click downbeat. All cycle transitions and voice countdowns are bar-aligned from that moment; starting off-beat will shift the countdowns relative to the click.
- SC records exactly 4 bars from your first note. That material becomes the source pool for all four partners for the next 3 minutes.
- After 12s, partners begin entering one per 12s. Continue playing — you are the sixth voice.

**Cycle transitions (3:00 and 5:00)**
- You will hear a fast "4–3–2–1" in your headphones (four beats, one bar) immediately before the transition. That is your cue to prepare a new harmony.
- At the downbeat: P2–P4 cut suddenly. P1 keeps going on the old material. Start playing your new phrase — SC is recording for exactly 4 bars from that moment.
- After the 4-bar window, P1 switches to the new loop and partners rebuild.
- Play confidently and clearly during the recording window. Hesitation or silence will be recorded.

**Ending**
- At 6:12 a slow crescendo begins. Partners get steadily louder over 16 bars.
- At 6:36 a slow voice countdown begins in headphones: "four" (one word per bar) counting down 8 bars to the hard stop.
- The piece ends at 7:00 with a hard stop. No performer action needed — be prepared for silence.

## Playing suggestions

**What works well**

- **Quarter notes and half notes.** The partners slice 0.75s fragments. Slow, held notes give them clean attack + sustain to work with. Each fragment will have a clear, identifiable attack transient.
- **Simple chords — power chords, triads, open shapes.** P5 transposes down a 4th, 5th, and octave. Harmonically complex voicings can create awkward intervals when transposed; simple chords sit cleanly across all three intervals.
- **Consistent dynamics within each 4-bar loop.** The buffer is normalised before partners use it, so your overall volume doesn't matter. But wild dynamic swings *inside* the phrase (very quiet then very loud) will be replayed in random order by partners, which can sound incoherent. A steady moderate level per cycle sounds best.
- **Strong rhythmic definition on beat 1.** Partners are playhead-anchored — they tend to read from positions near the current loop position. A clear downbeat attack at the top of each bar gives them the best chance of firing on an actual note.

**What to avoid**

- **Dense 16th-note lines.** Many short attacks close together means partners can't distinguish note boundaries, and fragments tend to catch mid-transient sounds. The artifact character increases.
- **Starting between beats.** If your first note lands off the click, all voice countdowns will be slightly offset from the metronome for the whole piece.
- **Silence in the recording window.** If you hesitate during the 4-bar loop, that silence is in the buffer. Partners will replay it and the texture will thin at random.

**What P5 does with your playing**

P5 reads from a continuously updating 8-second buffer of your live guitar. The louder and more actively you play, the richer the material P5 has to work with. P5 does not track your rhythm — it fires at exponentially-distributed random intervals (roughly 0.3–6s) and picks random fragments. Sustained held notes give P5 long, warm fragments; fast lines give it busy, layered ones.

## Reverb

Uses **GVerb** (built-in). Settings: room ~31m, decay 3.5s, damping 0.5, mix 0.15.

## How to run

1. Open `tryphon.scd`
2. Evaluate **Block 1** (config) — `Cmd+Return` inside the block
3. Evaluate **Block 2** (start) — allocates buffers, pre-renders voice cues (~6s), starts listening
4. Wait for `"Tryphon — running"` in the post window
5. Play guitar — piece responds to first note above threshold
6. Evaluate **Block 3** to stop early, or `Cmd+.`

## Tweaking (all in Block 1)

- `bpm` — tempo; updates all derived timing (stepDur, barDur, loopDur)
- `threshold` — amplitude to trigger first note; raise if click bleeds into mic
- `recBars` — loop buffer length in bars (default 4 = 12s)
- `cycleTimes` — when Cycle 1→2 and 2→3 transitions happen (seconds from first note)
- `totalDur` — piece length in seconds (default 420 = 7 min)
- `partnerAmp` / `dryAmp` — mix balance; lower `partnerAmp` if texture is too dense
- `liveAmp` — P5 processing level; raise for more prominent live effects
- `partnerVoices` — per-voice `stepMul`, `hitProb`, `satAmt`, drift LFO parameters
- `clickOn` — set `false` to disable metronome (not recommended live)
- `cueVoice` — macOS TTS voice for countdowns (default `"Samantha"`)
