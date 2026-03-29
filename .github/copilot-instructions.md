# guitar-music-msp — AI Context

Live solo guitar pieces in **SuperCollider 3.14.1**.
See CLAUDE.md at the project root for full conventions.

Key facts:
- Guitar input: `SoundIn.ar(0)`
- Stereo output: `Out.ar(0, stereoSig)`
- No Max for Live, no .maxpat files (those are in archived/)
- Each piece: config block → boot block → stop block
- Groups: grpRec → grpVoice → grpDry → grpMaster (execution order)
- Mix bus for archive recording
- `Lag.kr(targetAmp, fadeSecs)` for fade-ins triggered from language side
- `SystemClock.sched` for compositional timers
