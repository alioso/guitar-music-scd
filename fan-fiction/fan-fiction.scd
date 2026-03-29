/*
Fan Fiction
Steve Reich-style phasing guitar piece
SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1

STRUCTURE
  Guitar enters → amplitude detection fires
  8 bars later  → 4 loop voices fade in over 4 bars
  12 bars later → full mix recorded for 16 bars (archive)
  After archive → live processing stops, archive loops until end (~8-9 min)

VOICES (all read same 2-bar loop buffer at slightly different rates)
  G1: rate 1.0 locked — no drift
  G2: rate = 1.0 + 0.008 * sin(2π * t / 480s)   — 8-min phase cycle
  G3: rate = 1.0 + 0.010 * sin(2π * t / 360s)   — 6-min phase cycle
  G4: rate = 1.0 + 0.006 * sin(2π * t / 600s)   — 10-min phase cycle

RUN: evaluate each block top to bottom (Cmd+Return)
STOP: evaluate the stop block at the bottom, or Cmd+.
*/

// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION (evaluate first, no audio)
// ─────────────────────────────────────────────────────────────────────────────
(
~ff = (
    bpm:        110,
    loopBars:   2,       // loop buffer length in bars
    entryBars:  8,       // bars after first note → voices start fading in
    fadeBars:   4,       // bars for fade-in 0→1
    recBars:    12,      // bars after first note → start archive recording
    archBars:   16,      // bars to record for archive (then loop forever)
    threshold:  0.015,   // amplitude threshold for first-note detection (0..1)
    dryAmp:     0.7,     // dry guitar level in mix
    voiceAmp:   0.28,    // per-voice level (4 voices × 0.28 ≈ 1.1 headroom)

    voices: [
        (lfoDepth: 0.000, lfoHz: 0.001,  pan:  0.0),   // G1 locked
        (lfoDepth: 0.008, lfoHz: 1/480,  pan: -0.5),   // G2
        (lfoDepth: 0.010, lfoHz: 1/360,  pan:  0.5),   // G3
        (lfoDepth: 0.006, lfoHz: 1/600,  pan: -0.8),   // G4
    ],
);

// Derived timing
~ff.barDur   = 60 / ~ff.bpm * 4;
~ff.loopDur  = ~ff.barDur * ~ff.loopBars;
~ff.entryDur = ~ff.barDur * ~ff.entryBars;
~ff.fadeDur  = ~ff.barDur * ~ff.fadeBars;
~ff.recDur   = ~ff.barDur * ~ff.recBars;
~ff.archDur  = ~ff.barDur * ~ff.archBars;

"Fan Fiction config:".postln;
"  bar=% s  loop=% s  entry=% s  fade=% s  archive=% s".format(
    ~ff.barDur.round(0.01),
    ~ff.loopDur.round(0.01),
    ~ff.entryDur.round(0.01),
    ~ff.fadeDur.round(0.01),
    ~ff.archDur.round(0.01)
).postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — BOOT (evaluate to start piece)
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var ff = ~ff;

    // ── Buffers & bus ─────────────────────────────────────────────────────────
    ff.loopBuf = Buffer.alloc(s, (s.sampleRate * ff.loopDur).ceil.asInteger,  1);
    ff.archBuf = Buffer.alloc(s, (s.sampleRate * ff.archDur).ceil.asInteger, 2);
    ff.mixBus  = Bus.audio(s, 2);   // internal stereo mix bus

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Continuously records guitar into loop buffer
    SynthDef(\ffRec, {
        |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 1);
    }).add;

    // One loop voice — reads loop buffer with LFO-modulated playback rate
    // targetAmp controlled from language side via .set(\targetAmp, 1.0)
    SynthDef(\ffVoice, {
        |out=0, bufnum, targetAmp=0.0, fadeSecs=8.0,
         lfoDepth=0.0, lfoHz=0.001, pan=0.0, voiceAmp=0.28|
        var rate = 1.0 + (SinOsc.kr(lfoHz) * lfoDepth);
        var sig  = PlayBuf.ar(1, bufnum,
                       rate * BufRateScale.kr(bufnum), loop: 1);
        var amp  = Lag.kr(targetAmp, fadeSecs) * voiceAmp;
        Out.ar(out, Pan2.ar(sig * amp, pan));
    }).add;

    // Dry guitar passthrough
    SynthDef(\ffDry, {
        |out=0, amp=0.7|
        Out.ar(out, (SoundIn.ar(0) * amp).dup);
    }).add;

    // Amplitude detector — OSC on first rising edge above threshold
    SynthDef(\ffDetect, {
        |thresh=0.015|
        var amp   = Amplitude.kr(SoundIn.ar(0),
                        attackTime: 0.005, releaseTime: 0.1);
        var above = amp > thresh;
        var trig  = above * (1 - Delay1.kr(above));   // rising edge only
        SendReply.kr(trig, '/ff/firstNote', amp);
    }).add;

    // Records stereo mix bus to archive buffer (one-shot)
    SynthDef(\ffArchRec, {
        |bufnum, busIn|
        RecordBuf.ar(In.ar(busIn, 2), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 0);
    }).add;

    // Plays archive buffer, looping forever
    SynthDef(\ffArchPlay, {
        |out=0, bufnum|
        var sig = PlayBuf.ar(2, bufnum,
                      BufRateScale.kr(bufnum), loop: 1);
        Out.ar(out, sig.clip2(1.0));
    }).add;

    // Master: reads mix bus, clips, sends to hardware
    SynthDef(\ffMaster, {
        |busIn, out=0|
        Out.ar(out, In.ar(busIn, 2).clip2(1.0));
    }).add;

    s.sync;

    // ── Groups (execution order: rec → voice → dry → master) ─────────────────
    ff.grpRec    = Group.new(s);
    ff.grpVoice  = Group.after(ff.grpRec);
    ff.grpDry    = Group.after(ff.grpVoice);
    ff.grpMaster = Group.after(ff.grpDry);

    // ── Start synths ──────────────────────────────────────────────────────────

    // Recorder always runs from the start
    ff.recSyn = Synth(\ffRec, [bufnum: ff.loopBuf], ff.grpRec);

    // 4 voices, all silent (targetAmp=0)
    ff.voiceSyns = ff.voices.collect({ |v|
        Synth(\ffVoice, [
            out:       ff.mixBus.index,
            bufnum:    ff.loopBuf,
            targetAmp: 0.0,
            fadeSecs:  ff.fadeDur,
            lfoDepth:  v[\lfoDepth],
            lfoHz:     v[\lfoHz],
            pan:       v[\pan],
            voiceAmp:  ff.voiceAmp,
        ], ff.grpVoice);
    });

    // Dry guitar and master output
    ff.drySyn    = Synth(\ffDry,    [out: ff.mixBus.index, amp: ff.dryAmp], ff.grpDry);
    ff.masterSyn = Synth(\ffMaster, [busIn: ff.mixBus.index, out: 0],       ff.grpMaster);

    // Amplitude detector
    ff.detectSyn = Synth(\ffDetect, [thresh: ff.threshold], ff.grpRec);

    // ── First note handler ────────────────────────────────────────────────────
    ff.firstFired = false;

    OSCdef(\ffFirstNote, { |msg|
        if(ff.firstFired.not, {
            ff.firstFired = true;
            ff.detectSyn.free;

            {
                "First note detected. Voices enter in % bars (% sec).".format(
                    ff.entryBars, ff.entryDur.round(0.1)).postln;
            }.defer;

            // 8 bars: fade all 4 voices in over 4 bars
            SystemClock.sched(ff.entryDur, {
                "Voices fading in over % bars...".format(ff.fadeBars).postln;
                ff.voiceSyns.do({ |syn| syn.set(\targetAmp, 1.0) });
                nil;
            });

            // 12 bars: start recording archive
            SystemClock.sched(ff.recDur, {
                "Archive recording started (% bars = % sec).".format(
                    ff.archBars, ff.archDur.round(0.1)).postln;

                ff.archRecSyn = Synth(\ffArchRec, [
                    bufnum: ff.archBuf,
                    busIn:  ff.mixBus.index,
                ], ff.grpMaster);

                // After archive duration: switch to archive playback
                SystemClock.sched(ff.archDur, {
                    "Archive complete. Switching to loop playback.".postln;
                    "Guitar input no longer needed.".postln;

                    ff.archRecSyn.free;
                    ff.recSyn.free;
                    ff.voiceSyns.do(_.free);
                    ff.drySyn.free;
                    ff.masterSyn.free;

                    ff.archPlaySyn = Synth(\ffArchPlay, [
                        out:    0,
                        bufnum: ff.archBuf,
                    ], ff.grpMaster);
                    nil;
                });
                nil;
            });
        });
    }, '/ff/firstNote');

    "Fan Fiction running. Play guitar when ready.".postln;
    "Threshold: %. Cmd+. or evaluate stop block to end.".format(ff.threshold).postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP (evaluate to end piece cleanly)
// ─────────────────────────────────────────────────────────────────────────────
(
OSCdef(\ffFirstNote).free;
~ff.loopBuf.free;
~ff.archBuf.free;
~ff.mixBus.free;
s.freeAll;
"Fan Fiction stopped.".postln;
)
