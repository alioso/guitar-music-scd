/*
Fan Fiction
Steve Reich-style phasing guitar piece
SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)
  Optional: metronome → output 2+3 (headphones, requires Scarlett 4i4+)

  Server setup — put this in your SC startup file (File > Open startup file):
    s.options.inDevice  = "Scarlett 2i2 USB";   // adjust to your model name
    s.options.outDevice = "Scarlett 2i2 USB";
    s.options.numOutputBusChannels = 4;          // for metronome headphone routing

STRUCTURE (bars counted from your first note)
  bar 1               → first note; the click re-syncs so its loop accent lands on it
  bars 7–8            → frozen into the 2-bar loop (play a steady 2-bar ostinato)
  +8 bars             → 4 guitar voices + 4 synth voices fade in over 8 bars
  +16 bars            → full mix begins archive recording; two-tone headphone cue fires
  +80 bars (~2:55)    → archive loops; voices stop; dry guitar stays live on top
  +236 bars           → rising two-tone cue: 4 bars to the fade
  +240 → +248 bars    → archive fades out over 8 bars (~9:00) — end

VOICES — all read the same frozen 2-bar loop
  G1: rate locked 1.0,           pan -1.0 (full left)  — stays in phase with you
  G2: ±0.8% over 12min cycle,    pan -0.5 (half left)
  G3: ±1.0% over 9min cycle,     pan  0.5 (half right)
  G4: ±0.6% over 15min cycle,    pan  1.0 (full right)
  Every drifting voice starts exactly in phase at entry and slides away from it.

SYNTH VOICES (amplitude-following sine oscillators — 4 pitched registers, each phasing)
  Each voice tracks the loop's amplitude envelope to drive a pure sine at a set pitch.
  Guitar attacks trigger sine swells; phase drift creates constantly shifting harmonics.
  S1: ±0.4% over 10.5min cycle,  pan -0.75,  synthRoot×1  (sub bass)
  S2: ±0.9% over  7.5min cycle,  pan -0.25,  synthRoot×2  (low-mid)
  S3: ±0.7% over   13min cycle,  pan  0.25,  synthRoot×3  (mid)
  S4: ±0.5% over   10min cycle,  pan  0.75,  synthRoot×4  (treble)

CLICK
  Beat pulse: 880 Hz every quarter note
  Loop boundary: 1200 Hz every 2 bars (aligned to your first note)
*/

// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 0 — EXTERNAL INPUT (optional — synth/DAW via BlackHole, no guitar)
// Evaluate INSTEAD of s.boot when practicing without the guitar rig, then
// continue to Block 1. Uses the SCD EXTERNAL aggregate for both in and out.
// ─────────────────────────────────────────────────────────────────────────────
(
s.options.inDevice  = "SCD EXTERNAL";
s.options.outDevice = "SCD EXTERNAL";
s.reboot;
"External input active — reading from BlackHole 2ch via SCD EXTERNAL.".postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION (Cmd+Return inside this block first)
// ─────────────────────────────────────────────────────────────────────────────
(
~ff = (
    bpm:           110,
    loopBars:      2,      // loop buffer = 2 bars (~4.4s), frozen from the bars just before entry
    entryBars:     8,      // bars after first note → voices start fading in
    fadeBars:      8,      // bars for fade-in (sine curve, feels gradual)
    recBars:       16,     // bars after first note → archive recording starts
    archBars:      64,     // bars to record (~2:20 of material, total ~2:55 to loop)
    endBars:       240,    // bars after first note → archive starts fading out
    endFadeBars:   8,      // bars for the final fade (~9:00 total)
    threshold:     0.015,  // first-note amplitude threshold (0..1)
    dryAmp:        0.65,   // dry guitar in mix
    voiceAmp:      0.52,   // per-voice level — 4 voices equal presence with dry

    voices: [
        // lfoDepth=0 → locked rate, no phase drift
        (lfoDepth: 0.000, lfoHz: 1/720,  pan: -1.0),  // G1 full left
        (lfoDepth: 0.008, lfoHz: 1/720,  pan: -0.5),  // G2 half left,  12min cycle
        (lfoDepth: 0.010, lfoHz: 1/540,  pan:  0.5),  // G3 half right,  9min cycle
        (lfoDepth: 0.006, lfoHz: 1/900,  pan:  1.0),  // G4 full right, 15min cycle
    ],

    // Amplitude-following sine voices — each tracks a phase-drifted copy of the loop
    // and drives a sine at synthRoot×1/2/3/4. Adjust synthRoot to your key.
    // E: 82.4 | A: 55.0 | D: 73.4 | G: 49.0 | B: 61.7
    synthRoot: 82.4,
    synthVoices: [
        (lfoDepth: 0.004, lfoHz: 1/630, pan: -0.75, mult: 1, amp: 1.8),  // S1 sub
        (lfoDepth: 0.009, lfoHz: 1/450, pan: -0.25, mult: 2, amp: 1.2),  // S2 low-mid
        (lfoDepth: 0.007, lfoHz: 1/780, pan:  0.25, mult: 3, amp: 0.9),  // S3 mid
        (lfoDepth: 0.005, lfoHz: 1/600, pan:  0.75, mult: 4, amp: 0.7),  // S4 treble
    ],
    synthVoiceAmp: 0.28,  // global scale; per-voice amp multipliers above

    // Reverb (GVerb, built-in)
    reverbMix:     0.07,   // 0=dry 1=wet — very subtle, just space not wash
    reverbRoom:    30,     // GVerb room size (m)
    reverbDecay:   4.5,
    reverbDamp:    0.4,

    // Metronome — beat click (880 Hz) + loop-boundary accent (1200 Hz) to headphones
    // Requires Scarlett 4i4+ with outputs 3+4 as headphones
    metronomeOn:   true,
    clickOutChan:  2,      // SC output channel (0-indexed, so ch 3 on device)

    preRoll:       0.005,  // seconds of audio kept before the detected attack
    latency:       0.05,   // server scheduling latency for sample-accurate events
);

// Derived timing
~ff.barDur    = 60 / ~ff.bpm * 4;
~ff.loopDur   = ~ff.barDur * ~ff.loopBars;
~ff.entryDur  = ~ff.barDur * ~ff.entryBars;
~ff.fadeDur   = ~ff.barDur * ~ff.fadeBars;
~ff.recDur    = ~ff.barDur * ~ff.recBars;
~ff.archDur   = ~ff.barDur * ~ff.archBars;
~ff.totalDur  = ~ff.recDur + ~ff.archDur;
~ff.endDur    = ~ff.barDur * ~ff.endBars;
~ff.endFade   = ~ff.barDur * ~ff.endFadeBars;

"Fan Fiction — config loaded".postln;
"  bar=% s | loop=% s | entry=% s | fade=% s".format(
    ~ff.barDur.round(0.01), ~ff.loopDur.round(0.01),
    ~ff.entryDur.round(0.01), ~ff.fadeDur.round(0.01)).postln;
"  archive starts at % s, loops at % s | end at % s (~% min)".format(
    ~ff.recDur.round(1), ~ff.totalDur.round(1),
    (~ff.endDur + ~ff.endFade).round(1),
    ((~ff.endDur + ~ff.endFade) / 60).round(0.1)).postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START (Cmd+Return inside this block)
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var ff = ~ff;
    var sr = s.sampleRate;

    // Private timeline clock — Block 3 stops it, cancelling every pending event
    ff.tclock = TempoClock(1);

    // ── Buffers & buses ───────────────────────────────────────────────────────
    // ringBuf: rolling capture of the input; the loop is copied out of it
    ff.ringBuf = Buffer.alloc(s, (sr * (ff.loopDur * 2 + 1)).ceil.asInteger, 1);
    ff.loopBuf = Buffer.alloc(s, (sr * ff.loopDur).round.asInteger, 1);
    ff.archBuf = Buffer.alloc(s, (sr * ff.archDur).round.asInteger, 2);
    ff.mixBus  = Bus.audio(s, 2);
    ff.posBus  = Bus.control(s, 1);

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Writes guitar into the ring buffer and publishes the write position
    SynthDef(\ffRing, { |ringBuf, posBus|
        var phase = Phasor.ar(0, 1, 0, BufFrames.kr(ringBuf));
        BufWr.ar(SoundIn.ar(0), ringBuf, phase);
        Out.kr(posBus, A2K.kr(phase));
    }).add;

    // Reports the ring position of the first attack, so the loop can be cut
    // exactly on your bar grid
    SynthDef(\ffListen, { |posBus, thresh=0.015|
        var amp   = A2K.kr(Amplitude.ar(SoundIn.ar(0), attackTime: 0.005, releaseTime: 0.1));
        var above = amp > thresh;
        var trig  = above * (1 - Delay1.kr(above));
        SendReply.kr(trig, '/ff/firstNote', [amp, In.kr(posBus)]);
    }).add;

    // One guitar loop voice — fades in on creation via Env.asr (sine curve)
    SynthDef(\ffVoice, {
        |out=0, bufnum, gate=1, fadeSecs=17.0, startPos=0,
         lfoDepth=0.0, lfoHz=0.001, pan=0.0, voiceAmp=0.5|
        var env  = EnvGen.kr(
            Env.asr(fadeSecs, 1.0, 2.0, curve: \sine), gate, doneAction: Done.freeSelf);
        var rate = 1.0 + (SinOsc.kr(lfoHz) * lfoDepth);
        var sig  = PlayBuf.ar(1, bufnum,
                       rate * BufRateScale.kr(bufnum), startPos: startPos, loop: 1);
        Out.ar(out, Pan2.ar(sig * env * voiceAmp, pan));
    }).add;

    // Amplitude-following sine — reads the loop with phase drift, extracts its envelope,
    // drives a pure sine at `freq`. Guitar attacks become pitched swells; different
    // phase rates per voice create a shifting harmonic shimmer across the 4 registers.
    SynthDef(\ffSynVoice, {
        |out=0, bufnum, gate=1, fadeSecs=17.0, startPos=0,
         lfoDepth=0.0, lfoHz=0.001, pan=0.0, voiceAmp=0.28, freq=82.4|
        var env    = EnvGen.kr(
            Env.asr(fadeSecs, 1.0, 2.0, curve: \sine), gate, doneAction: Done.freeSelf);
        var rate   = 1.0 + (SinOsc.kr(lfoHz) * lfoDepth);
        var buf    = PlayBuf.ar(1, bufnum,
                         rate * BufRateScale.kr(bufnum), startPos: startPos, loop: 1);
        var bufEnv = Amplitude.ar(buf, attackTime: 0.02, releaseTime: 1.0);
        var sig    = SinOsc.ar(freq) * bufEnv;
        Out.ar(out, Pan2.ar(sig * env * voiceAmp, pan));
    }).add;

    // Dry guitar passthrough
    SynthDef(\ffDry, { |out=0, amp=0.65|
        Out.ar(out, (SoundIn.ar(0) * amp).dup);
    }).add;

    // Records stereo mix bus to archive buffer (one-shot, no loop)
    SynthDef(\ffArchRec, { |bufnum, busIn=0|
        RecordBuf.ar(In.ar(busIn, 2), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 0);
    }).add;

    // Plays archive buffer, looping until released (gate 0 → fade out)
    SynthDef(\ffArchPlay, { |out=0, bufnum, gate=1, fadeSecs=17.0|
        var env = EnvGen.kr(
            Env.asr(0.01, 1.0, fadeSecs, curve: \sine), gate, doneAction: Done.freeSelf);
        var sig = PlayBuf.ar(2, bufnum,
                      BufRateScale.kr(bufnum), loop: 1);
        Out.ar(out, sig * env);
    }).add;

    // Master: mix bus → GVerb reverb → limiter → hardware out
    SynthDef(\ffMaster, {
        |busIn=0, out=0, reverbMix=0.07, reverbRoom=30, reverbDecay=4.5, reverbDamp=0.4|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry.sum * 0.5, roomsize: reverbRoom,
            revtime: reverbDecay, damping: reverbDamp, drylevel: 0);
        var sig  = (dry * (1 - reverbMix)) + (verb * reverbMix);
        Out.ar(out, Limiter.ar(sig, 0.95, 0.003));
    }).add;

    // Beat click (880 Hz every quarter note) + loop-boundary accent (1200 Hz every 2 bars)
    SynthDef(\ffClick, { |out=2, bpm=110, loopDur=8.73|
        var beatTrig = Impulse.kr(bpm / 60);
        var loopTrig = Impulse.kr(1 / loopDur);
        var beatSig  = SinOsc.ar(880,  0, EnvGen.kr(Env.perc(0.001, 0.05), beatTrig));
        var loopSig  = SinOsc.ar(1200, 0, EnvGen.kr(Env.perc(0.001, 0.12), loopTrig));
        Out.ar(out, ((beatSig + loopSig) * 0.7).dup);
    }).add;

    // One-shot cue tone — fires on creation, frees itself when done
    SynthDef(\ffBufCue, { |out=2, freq=1000|
        var sig = SinOsc.ar(freq, 0,
            EnvGen.kr(Env.perc(0.001, 0.12), 1, doneAction: Done.freeSelf));
        Out.ar(out, sig.dup);
    }).add;

    s.sync;

    // ── Groups (all inside one root group — Block 3 frees only this piece) ────
    ff.grpRoot   = Group.new(s);
    ff.grpRec    = Group.head(ff.grpRoot);
    ff.grpVoice  = Group.after(ff.grpRec);
    ff.grpDry    = Group.after(ff.grpVoice);
    ff.grpMaster = Group.after(ff.grpDry);

    // ── Start synths ──────────────────────────────────────────────────────────
    ff.ringSyn   = Synth(\ffRing,
        [ringBuf: ff.ringBuf, posBus: ff.posBus], ff.grpRec);
    ff.listenSyn = Synth(\ffListen,
        [posBus: ff.posBus, thresh: ff.threshold], ff.grpRec, \addToTail);
    ff.drySyn    = Synth(\ffDry,
        [out: ff.mixBus.index, amp: ff.dryAmp], ff.grpDry);
    ff.masterSyn = Synth(\ffMaster, [
        busIn:       ff.mixBus.index,
        out:         0,
        reverbMix:   ff.reverbMix,
        reverbRoom:  ff.reverbRoom,
        reverbDecay: ff.reverbDecay,
        reverbDamp:  ff.reverbDamp,
    ], ff.grpMaster);

    ff.startClick = {
        ff.clickSyn !? _.free;
        ff.clickSyn = Synth(\ffClick, [
            out:     ff.clickOutChan,
            bpm:     ff.bpm,
            loopDur: ff.loopDur,
        ], ff.grpMaster);
    };
    if(ff.metronomeOn, {
        ff[\startClick].value;
        "Metronome active on output channel % (beat 880Hz | loop boundary 1200Hz)".format(
            ff.clickOutChan).postln;
    });

    ff.cue = { |freqs|
        freqs.do { |freq, i|
            ff.tclock.sched(i * 0.18, {
                Synth(\ffBufCue, [out: ff.clickOutChan, freq: freq], ff.grpMaster);
                nil
            });
        };
    };

    // Freeze bars (entry − loopBars … entry) out of the ring buffer, then start all
    // voices at the loop position that corresponds to "now" on your bar grid
    ff.enterVoices = {
        Routine({
            var ringFrames = ff.ringBuf.numFrames;
            var loopFrames = ff.loopBuf.numFrames;
            var start = (ff.pos0 - (ff.preRoll * sr)
                + ((ff.entryBars - ff.loopBars) * ff.barDur * sr)).round.asInteger % ringFrames;
            var first = min(loopFrames, ringFrames - start);
            ff.ringBuf.copyData(ff.loopBuf, 0, start, first);
            if(first < loopFrames) {
                ff.ringBuf.copyData(ff.loopBuf, first, 0, loopFrames - first);
            };
            s.sync;
            ff.ringSyn.free;
            ff.listenSyn.free;

            { "Loop frozen. Voices fading in over % bars...".format(ff.fadeBars).postln; }.defer;
            s.makeBundle(ff.latency, {
                var startPos = ((thisThread.seconds + ff.latency - ff.tEntry)
                    % ff.loopDur * sr).round;
                ff.voiceSyns = ff.voices.collect({ |v|
                    Synth(\ffVoice, [
                        out:       ff.mixBus.index,
                        bufnum:    ff.loopBuf,
                        fadeSecs:  ff.fadeDur,
                        startPos:  startPos,
                        lfoDepth:  v[\lfoDepth],
                        lfoHz:     v[\lfoHz],
                        pan:       v[\pan],
                        voiceAmp:  ff.voiceAmp,
                    ], ff.grpVoice);
                });
                ff.synVoiceSyns = ff.synthVoices.collect({ |v|
                    Synth(\ffSynVoice, [
                        out:       ff.mixBus.index,
                        bufnum:    ff.loopBuf,
                        fadeSecs:  ff.fadeDur,
                        startPos:  startPos,
                        lfoDepth:  v[\lfoDepth],
                        lfoHz:     v[\lfoHz],
                        pan:       v[\pan],
                        voiceAmp:  ff.synthVoiceAmp * v[\amp],
                        freq:      ff.synthRoot * v[\mult],
                    ], ff.grpVoice);
                });
            });
        }).play(ff.tclock);
    };

    // ── First note handler ────────────────────────────────────────────────────
    ff.firstFired = false;

    OSCdef(\ffFirstNote, { |msg, time|
        if(ff.firstFired.not, {
            ff.firstFired = true;
            ff.pos0   = msg[4];
            ff.tEntry = time + ff.entryDur;

            // Restart the click on your first note so its loop accent marks the loop
            if(ff.metronomeOn, { ff[\startClick].value });

            { "First note! Loop freezes from bars %–%, voices enter in % bars (% sec)."
                .format(ff.entryBars - ff.loopBars + 1, ff.entryBars,
                    ff.entryBars, ff.entryDur.round(0.1)).postln; }.defer;

            // +8 bars: freeze the loop and fade all voices in (0.1 s margin so the
            // last frames of the loop are already recorded)
            ff.tclock.sched(ff.entryDur + 0.1, { ff[\enterVoices].value; nil });

            // +16 bars: start archive recording + fire two-tone headphone cue
            ff.tclock.sched(ff.recDur - ff.latency, {
                { "Archive recording (% bars = % sec)..."
                    .format(ff.archBars, ff.archDur.round(1)).postln; }.defer;
                s.makeBundle(ff.latency, {
                    ff.archRecSyn = Synth(\ffArchRec, [
                        bufnum: ff.archBuf,
                        busIn:  ff.mixBus.index,
                    ], ff.grpMaster);
                });
                ff[\cue].([1000, 650]);   // high → low: recording has started
                nil
            });

            // +80 bars: switch to archive loop — dry guitar stays live
            ff.tclock.sched(ff.totalDur - ff.latency, {
                { "Archive complete — looping. Keep playing on top.".postln; }.defer;
                s.makeBundle(ff.latency, {
                    ff.archRecSyn.free;
                    ff.voiceSyns.do(_.free);
                    ff.synVoiceSyns.do(_.free);
                    ff.archPlaySyn = Synth(\ffArchPlay, [
                        out:      ff.mixBus.index,
                        bufnum:   ff.archBuf,
                        fadeSecs: ff.endFade,
                    ], ff.grpVoice);
                });
                nil
            });

            // End: rising cue 4 bars before, then the archive fades out
            ff.tclock.sched(ff.endDur - (ff.barDur * 4), {
                { "Four bars to the end.".postln; }.defer;
                ff[\cue].([650, 1000]);
                nil
            });
            ff.tclock.sched(ff.endDur, {
                { "Fading out over % bars.".format(ff.endFadeBars).postln; }.defer;
                ff.archPlaySyn.set(\gate, 0);
                nil
            });
            ff.tclock.sched(ff.endDur + ff.endFade, {
                ff.clickSyn !? _.free;
                { "Fan Fiction — end. Evaluate Block 3 to clean up.".postln; }.defer;
                nil
            });
        });
    }, '/ff/firstNote');

    "".postln;
    "Fan Fiction — running. Play guitar when ready.".postln;
    "Amplitude threshold: %. Cmd+. or Block 3 to stop.".format(ff.threshold).postln;
    "Timeline from first note:".postln;
    "  bars %–%: frozen into the loop — play a steady 2-bar ostinato".format(
        ff.entryBars - ff.loopBars + 1, ff.entryBars).postln;
    "  +% bars (% s): voices fade in over % bars".format(
        ff.entryBars, ff.entryDur.round(1), ff.fadeBars).postln;
    "  +% bars (% s): archive recording starts (headphone cue fires)".format(
        ff.recBars, ff.recDur.round(1)).postln;
    "  +% bars (% s): archive loops; guitar stays live".format(
        ff.recBars + ff.archBars, ff.totalDur.round(1)).postln;
    "  +% bars (% s): archive fades out over % bars".format(
        ff.endBars, ff.endDur.round(1), ff.endFadeBars).postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP (Cmd+Return to end cleanly)
// ─────────────────────────────────────────────────────────────────────────────
(
~ff.tclock !? _.stop;
OSCdef(\ffFirstNote).free;
~ff.grpRoot !? _.free;
[~ff.ringBuf, ~ff.loopBuf, ~ff.archBuf, ~ff.mixBus, ~ff.posBus].do { |x| x !? _.free };
"Fan Fiction — stopped.".postln;
)
