# guitar-music-scd

Live solo guitar compositions in SuperCollider 3.14.1. Each piece is a standalone file; guitar input is processed, responded to, and transformed by SC in real time.

## Hardware setup

- Guitar → Scarlett interface → input 0 (mono)
- Stereo output channels 0+1 → speakers
- Headphone output channels 2+3 → click track and voice cues (Scarlett 4i4+)

## Running a piece

1. Open SuperCollider 3.14.1
2. Boot the server: `s.boot`
3. Open the piece `.scd` file
4. Evaluate blocks top to bottom: Block 1 (config) → Block 2 (start) → wait → play (vanilla has an extra Block 3 to arm)
5. The last block (stop) ends the piece early or cleans up after it; `Cmd+.` also works

Each piece posts status updates to the SuperCollider post window. Wait for the "running" or "armed" message before playing.

**Running pieces back to back:** every piece keeps its timeline on its own private clock and its synths in its own group. Its stop block cancels everything it still had scheduled and frees only its own nodes, buffers and buses — so you can go straight from one piece to the next without rebooting, and anything else on the server (such as the visuals bridge) keeps running. Each piece ends in a limiter, so no piece can clip the outputs.

**Practicing without the guitar rig:** each piece has an optional Block 0 to swap its input source from the Scarlett to a synth/DAW via BlackHole (`brew install blackhole-2ch`). See [external/](external/) for a bare piece (BlackHole in, monitored straight back to headphones, no other processing) that just feeds the visuals from an external source.

## Pieces

| Piece | What it does | Duration |
|---|---|---|
| [fan-fiction](fan-fiction/) | Freezes a 2-bar loop of your ostinato; eight voices (four guitar copies + four sine oscillators) read it at slightly different playback rates that slowly drift in and out of phase with you; the mix is archived and looped under you | ~9 min |
| [anaerobes](anaerobes/) | Builds a live pitch library from note captures; four partners draw from it with independent rhythmic and register tendencies; two harmonic libraries swap mid-piece; click, cues and tempo ramps share one clock | ~8 min |
| [chimera](chimera/) | Tunes a four-voice synthesized bed from the notes you hold; a granular companion made of the live input wanders underneath; feed windows let your notes pull the bed to new pitches | ~9 min |
| [tryphon](tryphon/) | Records a 4-bar loop; four partners replay slices starting on your attacks at irrational tempo ratios that never realign; a fifth voice processes the live guitar with pitch shifts and reversals; three recording cycles with a crescendo end | ~7 min |
| [armorika](armorika/) | Seven FM and additive instrument streams run continuously; the structure sets the mode (minor → Dorian → minor → major), the guitar sets the key center in real time | ~5 min |
| [vanilla](vanilla/) | Three partners granulate pre-recorded guitar files; two partners capture the live input in alternating 30s windows and granulate from those snapshots | ~5 min |
| [coronal](coronal/) | Seven prime-derived delay lines form a feedback network; guitar amplitude modulates feedback gain in real time; soft touch holds resonance, loud playing pushes it to the edge of instability | ~7 min |

## Visuals

Real-time visuals driven by guitar amplitude — see [VIDEO.md](VIDEO.md) for the full guide: media folders, effect descriptions, drawings, and performance commands.

## Dependencies

- SuperCollider 3.14.1 (core UGens only — sc3-plugins is not needed)
- macOS `say` — spoken headphone cues in anaerobes and tryphon
- Python 3.14+ and uv — required for visuals only
