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
4. Evaluate blocks top to bottom: Block 1 (config) → Block 2 (start) → wait → play
5. Block 3 (stop) or `Cmd+.` to end early

Each piece posts status updates to the SuperCollider post window. Wait for the "running" or "armed" message before playing.

## Pieces

| Piece | What it does | Duration |
|---|---|---|
| [fan-fiction](fan-fiction/) | Records a 2-bar loop; eight voices (four guitar copies + four sine oscillators) read it at slightly different playback rates that slowly drift in and out of phase | ~9 min |
| [anaerobes](anaerobes/) | Builds a live pitch library from onset captures; four partners draw from it with independent rhythmic and register tendencies; two harmonic libraries swap mid-piece | ~8 min |
| [chimera](chimera/) | Locks onto a bowed pitch; builds a four-voice synthesis floor tuned to it; layers a granular blur of the live buffer; dissolves melodic notes into shimmer reverb | ~12 min |
| [tryphon](tryphon/) | Records a 4-bar loop; four partners replay fragments at irrational tempo ratios that never realign; a fifth voice processes the live guitar with pitch shifts and reversals; three recording cycles with a crescendo end | ~7 min |
| [armorika](armorika/) | Seven FM and additive instrument streams run continuously in natural minor; guitar pitch detection shifts the key center in real time across three harmonic passages | ~5 min |
| [vanilla](vanilla/) | Three partners granulate pre-recorded guitar files; two partners capture the live input in alternating 30s windows and granulate from those snapshots | ~5 min |
| [coronal](coronal/) | Seven prime-derived delay lines form a feedback network; guitar amplitude modulates feedback gain in real time; soft touch holds resonance, loud playing pushes toward instability | ~8 min |

## Visuals

Real-time visuals driven by guitar amplitude — see [VIDEO.md](VIDEO.md) for the full guide: media folders, effect descriptions, drawings, and performance commands.

## Dependencies

- SuperCollider 3.14.1
- sc3-plugins (`brew install sc3-plugins`) — required by anaerobes, chimera, tryphon
- Python 3.14+ and uv — required for visuals only
