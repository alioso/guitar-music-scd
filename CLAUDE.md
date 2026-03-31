# guitar-music-scd — AI Instructions

## Project

A series of live solo guitar pieces. Input is a guitar through a Scarlett interface. Output is stereo speakers. All pieces run in **SuperCollider 3.14.1** (standalone, not Max for Live).

Each piece lives in its own directory with a `.scd` file and a `README.md`.

```
guitar-music-scd/
├── fan-fiction/fan-fiction.scd   ← Reich phasing piece
├── anaerobes/anaerobes.scd
├── chimera/chimera.scd
├── tryphon/tryphon.scd
```

## SuperCollider Conventions

**Audio I/O**
- Guitar input: `SoundIn.ar(0)` — mono, channel 0
- Output: `Out.ar(0, sig)` — stereo pair on channels 0+1
- Always `clip2(1.0)` before final hardware output

**SynthDef patterns**
```supercollider
// Fade-in via Lag (set targetAmp from language side)
SynthDef(\voice, {
    |out=0, bufnum, targetAmp=0.0, fadeSecs=8.0, pan=0.0|
    var sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 1);
    Out.ar(out, Pan2.ar(sig * Lag.kr(targetAmp, fadeSecs), pan));
}).add;

// Amplitude detection with rising-edge only
SynthDef(\detect, {
    |thresh=0.01|
    var amp   = Amplitude.kr(SoundIn.ar(0), attackTime: 0.005, releaseTime: 0.1);
    var above = amp > thresh;
    var trig  = above * (1 - Delay1.kr(above));   // rising edge only
    SendReply.kr(trig, '/myPiece/firstNote', amp);
}).add;
```

**Group execution order** (use this in every piece)
```supercollider
~grpRec    = Group.new(s);              // recorders, detectors
~grpVoice  = Group.after(~grpRec);     // playback voices
~grpDry    = Group.after(~grpVoice);   // dry guitar passthrough
~grpMaster = Group.after(~grpDry);     // master out, archive recorder
```

**Mix bus pattern** (for archive recording)
```supercollider
~mixBus = Bus.audio(s, 2);
// voices + dry → ~mixBus
// ffMaster reads ~mixBus → hardware out
// ffArchRec reads ~mixBus → archive buffer
```

**Timing**
- Use `SystemClock.sched(delaySeconds, { ... nil })` for one-shot events
- Always `nil` at end of sched block
- Convert bars: `barDur = 60 / bpm * 4`

**OSC handlers**
```supercollider
OSCdef(\myHandler, { |msg| ... }, '/myPiece/event');
// Free when done:
OSCdef(\myHandler).free;
```

**Stopping a piece**
Every piece ends with a clearly marked stop block:
```supercollider
( // STOP
OSCdef(\myHandler).free;
~myBuf.free;
~myBus.free;
s.freeAll;
)
```

**Buffer allocation**
```supercollider
~buf = Buffer.alloc(s, (s.sampleRate * durationSeconds).ceil.asInteger, numChannels);
```

## Do not
- Edit `.scd` files without understanding the piece structure
- Add features not requested

## Each piece has three code blocks

1. **Config block** `( ~pieceName = (...); )` — all parameters, no audio
2. **Boot block** `( s.waitForBoot({ ... }); )` — allocates buffers, adds SynthDefs, starts synths
3. **Stop block** `( // STOP ... s.freeAll; )` — always at the bottom, clearly marked
