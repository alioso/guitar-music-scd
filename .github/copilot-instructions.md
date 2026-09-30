# guitar-music-scd — AI Context

Live solo guitar pieces in **SuperCollider 3.14.1**.
See CLAUDE.md at the project root for general coding guidelines.

Key facts:
- Guitar input: `SoundIn.ar(0)`
- Stereo output: `Out.ar(0, stereoSig)`; click and voice cues on output 2 (headphones)
- Each piece: optional Block 0 (external input) → config block → start block → stop block
- Each piece keeps its state in one Event (`~ff`, `~ana`, `~ch`, `~trp`, `~arm`, `~cor`; vanilla uses `~van*` globals)
- Timelines run on a private `TempoClock` per piece (never `SystemClock` / `TempoClock.default`), so the stop block cancels everything by stopping that clock
- Groups live inside one root group per piece: grpRec → grpVoice → grpDry → grpMaster (execution order). Stop blocks free that root group — never `s.freeAll`
- Mix bus → master with a `Limiter` (reverbs take `dry.sum * 0.5`, not one channel)
- Amplitude of an audio signal: `A2K.kr(Amplitude.ar(sig))` — `Amplitude.kr` on audio input chatters
- Keep `BufWr` and `Pitch` in separate SynthDefs (sharing one stops `Pitch` tracking); ring writers publish their write position on a control bus
- `Lag.kr(targetAmp, fadeSecs)` for fade-ins triggered from language side
- Avoid Event keys that are Object methods/setters (e.g. `clock`, `play`, `stop`, `next`, `group`)
