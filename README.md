# guitar-music-scd

Live solo guitar compositions in SuperCollider 3.14.1.

## Setup

- Guitar → Scarlett interface → input 0
- Stereo output channels 0+1 → speakers
- Open SuperCollider 3.14.1
- Boot the server: `s.boot`
- Open the piece `.scd` file, run blocks top to bottom

## Pieces

| Piece | Concept | Duration |
|---|---|---|
| [fan-fiction](fan-fiction/) | Phasing, 4 voices | ~9 min |
| [anaerobes](anaerobes/) | Risset guitar quartet, delay + frequency shift | ~8 min |
| [chimera](chimera/) | Ambient, swell detection + groove voices | ~12 min |
| [tryphon](tryphon/) | Polyrhythm, 4 drifting partners + live processing | ~7 min |
| [armorika](armorika/) | TBD | TBD |
| [vanilla](vanilla/) | Granular sampler, 5 partners, pre-recorded + live capture | ~5 min |
| [coronal](coronal/) | Feedback resonance network, 7 delay lines, touch-controlled | ~8 min |

## Workflow

Each `.scd` file has three blocks — run them in order:

```
1. Config block   — set parameters (no audio)
2. Boot block     — start the piece
3. Stop block     — clean shutdown (Cmd+. also works)
```
