# Anaerobes

Generative guitar quintet — live note library, four independent partner voices. Duration ~8 min.

## Concept

The guitarist builds a live library by playing: SC detects each onset, captures ~3s of audio into a named buffer slot indexed by MIDI pitch. Four partner voices draw independently from this library, making weighted decisions about register, rhythm, and harmony to create autonomous counterpoint. The piece has two harmonic libraries — A and B — and navigates between them mid-piece, shifting the harmonic world beneath all five voices simultaneously.

## Structure

| Time from first note | Event |
|---|---|
| 0:00–1:30 | Library A seeding — guitarist plays alone. All material played here becomes partner source material. |
| 1:30 | P1 enters (low, long notes, contemplative) |
| 2:00 | P2 enters (mid-low, melodic) |
| 2:30 | P3 enters (mid-high, restless, triplet-leaning) |
| 3:00 | Coord 1 — group attack window. P4 enters (high, energetic). All active partners forced to play simultaneously for one beat. |
| 3:30 | Coord 2 — forte swell. All partners amp → 1.0. |
| 3:45 | Voice: "slow down in four bars" → decelerando begins after four bars (76 → 66 BPM over 16 bars) |
| 4:20 | Voice: "record new harmony in four bars" |
| 4:32 | Dry guitar muted. Library B seeding begins (8 bars). Partners continue drawing from Library A. |
| ~5:05 | Library B ready — all partners switch to Library B. Dry guitar returns. Voice: "new harmony". |
| 5:15 | Coord 3 — rhythmic lock. All partners play quarter-note pulse for 4 bars. |
| 6:10 | Voice: "speed up in four bars" → accelerando begins (66 → 84 BPM over 12 bars) |
| 6:47 | Voice: "returning in four bars" → Library A returns, bias updates staggered by partner |
| 7:20 | Coord 4 — piano drop. All partners amp → 0.45. |
| ~7:28 | Voice: "end of piece in four bars" |
| 8:00 | Final bar — all partners attack beat 1 simultaneously, 1-bar fade. Hard cutoff. |

## Partner personalities

| Partner | Register | Character | Rhythm tendency |
|---|---|---|---|
| P1 | MIDI 40–60 (E2–C4) | Contemplative, spare. Long notes, frequent rests. | Weighted toward whole and half notes. Rarely plays 16th-note territory. |
| P2 | MIDI 52–69 (E3–A4) | Melodic, mid-low. Balanced presence. | Balanced across note lengths; favors quarter and eighth values. |
| P3 | MIDI 62–79 (D4–G5) | Restless, mid-high. Dense activity, triplet feel. | Weights favor 8th-triplet, 16th, 16th-triplet territory. |
| P4 | MIDI 69–90 (A4–F#6) | Energetic, high. Rarely rests. Fast activity. | Strongly weights fast note values. Rarely produces whole notes. |

## Note library

Each onset triggers a ~3s capture into the pool of 96 pre-allocated buffers (round-robin reuse). SC extracts MIDI pitch via `Pitch.kr` and stores the buffer under that pitch class in the active library. Partners look up buffers by MIDI note, filtered to their register, then filtered by harmonic bias (pitch class whitelist), then weighted by interval distance from the last note played. Up to 3 takes per MIDI pitch are retained; older takes are dropped as new ones arrive.

Two libraries exist in parallel: **Library A** (seeded in the opening 90 seconds) and **Library B** (seeded during the harmonic shift section around 4:32). Partners can only draw from the active library. The harmonic bias is derived automatically from whichever pitches you played most during each seeding window.

Partners P3 and P4 receive bias updates with a 16-beat and 32-beat lag respectively, so the harmonic shift propagates across the ensemble gradually rather than simultaneously.

## Key levels

| Parameter | Value |
|---|---|
| `partnerAmp` | 0.26 per note (before groupAmp and ampBase scaling) |
| `dryAmp` | 0.55 |
| `reverbMix` | 0.16 (JPverb, 3.8s decay) |
| `onsetThreshold` | 0.015 |
| `captureDur` | 3.0 s per note |
| `bufPoolSize` | 96 capture buffers |

## Performance notes

### Pre-performance setup

1. Run Block 1 (config). Confirm the timeline prints in the post window.
2. Run Block 2 (start). Wait for "Anaerobes — running" in the post window before playing. The click will start immediately if `clickOn: true`.
3. The server allocates 96 capture buffers and pre-renders six voice cue AIFF files via macOS `say`. This takes 1–2 seconds. Do not play until the post window confirms readiness.

### The opening composition (most important preparation)

The 90-second seeding window is the most important part of the piece. Everything the four partners play for the next eight minutes comes from what you record here. Aim for:

- **Wide pitch range**: play in all registers. P1 lives in the low range, P4 in the high. If you never play below the 5th fret or above the 12th, the low and high partners will have nothing to draw from.
- **Variety of note lengths**: single plucks, let-ring notes, short stabs, harmonics. Partners draw the audio verbatim — a pool of only short stabs means all partners will staccato.
- **Variety of timbres**: normal picking, near-bridge, sul tasto, harmonics. The partners replay the captured audio at pitch — their timbre is your timbre.
- **Cover all the pitches in your intended harmony**: the bias detection at the end of seeding finds which pitch classes appear most often and uses that as the harmonic filter. If you only play tonic and fifth, the bias narrows to two pitch classes and the partners become very monotonous. Seven or more distinct pitch classes gives the richest counterpoint.
- **Do not fill every moment**: leave some silence. The detector has a 250ms refractory period, so fast runs register as fewer captures than slow, deliberate notes.

The post window shows "Library A:N B:0 pitches" every five notes. Aim for 15–30 Library A entries before partners enter.

### Click track

The click plays on SC output channel 2 (device output 3+4 = headphones). Kick on beat 1, rim shot on beats 2, 3, 4. The click follows all tempo changes automatically via a control bus. At 76 BPM the bar is approximately 3.16 seconds.

### Voice cues

All voice cues play through the headphone output only (channel 2). Four bars' warning is always given before the event fires.

| Voice cue | Meaning | What to do |
|---|---|---|
| "slow down in four bars" | Decelerando begins in 4 bars | Continue playing; the click will guide you down to 66 BPM over 16 bars. Follow the click. |
| "record new harmony in four bars" | Library B seeding begins in 4 bars | Prepare to shift harmonic language. In four bars your dry guitar will mute. |
| "new harmony" | Library B is ready; partners have switched | Your dry guitar has returned. Partners are now in the new harmonic world. Continue in the new language. |
| "speed up in four bars" | Accelerando begins in 4 bars | Continue playing; the click will guide you up to 84 BPM over 12 bars. Follow the click. |
| "returning in four bars" | Library A returns in 4 bars | Prepare to shift back to the opening harmony. Begin gravitating back to Library A pitch territory. |
| "end of piece in four bars" | Final bar in 4 bars | Prepare a final note or phrase. All partners will attack simultaneously on beat 1 of the final bar. |

### Harmonic shift procedure (most critical moment)

The harmonic shift around 4:20 is the structurally central event of the piece. The sequence:

1. You hear "record new harmony in four bars". You have four bars to mentally prepare the new harmonic material. Decide on the new pitch world now — it should contrast meaningfully with Library A.
2. Four bars later, your dry guitar signal is muted in the mix. You will not hear yourself. This is intentional — it allows you to play the new material freely without it bleeding into the existing texture. Partners continue drawing from Library A.
3. Play the new harmony for exactly 8 bars (the `shiftSeedBars` count). Play in the same spirit as the opening: wide range, varied lengths, varied timbres. The post window will show Library B building up.
4. You hear "new harmony". Your dry guitar returns immediately. All four partners switch to Library B. Partners P3 and P4 will lag 16 and 32 beats behind P1 and P2 in adopting the new bias — the shift cascades through the ensemble over about one minute.
5. You are now in the new harmonic world. Play as if continuing the piece from the opening, but in the new language.

Confidence matters during the muted phase. You cannot hear yourself, but SC is capturing every onset. Play as if the audience can hear you — that material determines what the next two minutes of ensemble counterpoint will sound like.

### Tempo changes

Both tempo changes (decelerando at 3:45, accelerando at 6:10) are gradual, one-beat-at-a-time ramps. The click follows the ramp in real time. Your role is simply to follow the click — do not try to change tempo gradually on your own, let the click lead you. The decelerando takes approximately 40 seconds (16 bars at diminishing tempo). The accelerando takes approximately 25 seconds (12 bars at increasing tempo).

### Final bar

At 8:00, all four partner routines are stopped and each partner fires one final `\anaHit` synth with a decay equal to one full bar minus 10ms. The amplitude is set to `groupAmp * ampBase * partnerAmp` (no randomization). This is the one moment all five voices move together. Play a final note on beat 1 — a sustained ring or a firm pluck — and fade out with your volume pedal over the bar. The hard cutoff fires automatically four beats later, stopping all synths.

### Library limitations

Partners can only play what you gave them. A sparse or register-limited library produces sparse, register-limited counterpoint. There is no synthesis or pitch transposition — the partners replay your captures at original pitch. The quality of the piece is proportional to the richness of the opening 90 seconds.

## Reverb

Uses **JPverb** from sc3-plugins (`brew install sc3-plugins`). GVerb fallback is commented in the `\anaMaster` SynthDef source. Settings: size 1.2, decay 3.8 s, damp 0.45, early diffusion 0.72.

## How to run

1. Open `anaerobes.scd`
2. Evaluate **Block 1** (config) — `Cmd+Return` inside the block
3. Evaluate **Block 2** (start) — allocates buffers, renders voice cues, starts synths
4. Wait for "Anaerobes — running" in the post window
5. Play guitar — piece responds to first note above threshold (0.015)
6. Piece ends with hard cutoff at 8 min + 4 beats; evaluate **Block 3** if stopped early

## Tweaking (all in Block 1)

- `bpm` — starting tempo (default 76); all derived durations recalculate automatically
- `seedDur` — Library A seeding window in seconds (default 90)
- `partnerEntryTimes` — when each partner enters from first note
- `onsetThreshold` — detection sensitivity; raise in noisy environments
- `onsetRefractory` — minimum gap between captures (default 0.25 s); raise to avoid double-triggers on one note
- `partnerAmp` / `dryAmp` — mix balance between partners and live guitar
- `reverbMix` / `reverbDecay` — master reverb wetness and tail length
- `partners[i].playProb` — how often each partner chooses to play vs rest
- `partners[i].ringProb` — probability of letting a note ring vs cutting short
- `harmonicBias` — fallback pitch class whitelist if auto-detection finds fewer than 3 classes
- `clickOn` — set `false` to disable click
- `cueVoice` — macOS TTS voice name for spoken cues (default "Samantha")
