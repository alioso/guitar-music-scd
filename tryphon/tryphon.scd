/*
Tryphon
Living polyrhythmic guitar bed — SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)
  Click:  metronome → output 2+3 (headphones, Scarlett 4i4+)

  Four partners = tight one-shots sliced from the loop (no pitch shift).
  Each voice has its own clock drift, mutation rate, and pattern logic.
  Euclidean is optional; polyrhythm comes from independent evolving strata.

  Input tip: clear harmony + simple rhythm (e.g. quarters) fills the buffer
  with a readable “pool”; complexity comes from the four strata, not from
  you playing dense rhythm.

STRUCTURE (~7 min from first note) — unchanged
  t=0        first note → record 4 bars
  t=12s      P1 · P2 · P3 · P4 stagger by 12s
  t=3m / 5m  cycle change, re-record, rebuild
  t=6m36s    duo (input + P1)
  t=7m       hard stop

REQUIRES sc3-plugins note in README; master uses GVerb like other pieces.
*/


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION
// ─────────────────────────────────────────────────────────────────────────────
(
~trp = (
    bpm:     80,
    recBars: 4,

    partnerAmp: 0.16,   // per spawned slice; 4 voices × ~2 overlapping = ~8 simultaneous
    dryAmp:     0.32,

    // Master
    reverbMix:   0.15,
    reverbDecay: 3.5,
    reverbSize:  1.1,
    reverbDamp:  0.5,

    threshold: 0.015,

    totalDur:       420,
    endDropBefore:  24,

    clickOn:      true,
    clickOutChan: 2,
    cueVoice:     "Samantha",

    // Live-input processing voice (P5) — separate circular buffer, random effects
    liveAmp:      0.24,   // amplitude; dynamics come directly from your playing
    liveBufSecs:  8.0,    // how many seconds of recent input are kept

    // Per-voice drifting rhythm — two LFOs per voice, no euclidean math.
    // stepMul:    base tempo vs global 16th (irrational → voices never realign)
    // driftHz/driftDepth:   LFO 1 — breathes the step interval (living tempo)
    // evolveHz/evolveDepth: LFO 2 — breathes the hit probability (fills & spaces)
    // hitProb:    base probability of firing on any step (drifts via evolve LFO)
    partnerVoices: [
        (pan: -0.75, stepMul: 1.0,   driftHz: 0.055, driftDepth: 0.09,
                     evolveHz: 0.0027, evolveDepth: 0.30, hitProb: 0.22),
        (pan: -0.25, stepMul: 1.063, driftHz: 0.048, driftDepth: 0.11,
                     evolveHz: 0.0038, evolveDepth: 0.28, hitProb: 0.28),
        (pan:  0.25, stepMul: 0.94,  driftHz: 0.062, driftDepth: 0.10,
                     evolveHz: 0.0044, evolveDepth: 0.32, hitProb: 0.25),
        (pan:  0.75, stepMul: 1.11,  driftHz: 0.041, driftDepth: 0.12,
                     evolveHz: 0.0031, evolveDepth: 0.35, hitProb: 0.20),
    ],
);

~trp.barDur    = 60 / ~trp.bpm * 4;
~trp.stepDur   = ~trp.barDur / 16;
~trp.loopDur   = ~trp.barDur * ~trp.recBars;
~trp.buildStep = ~trp.barDur * 4;
~trp.cycleTimes = [180, 300];

"Tryphon — config loaded (living strata)".postln;
"  bpm=% |16th=% s | loop=% s".format(
    ~trp.bpm, ~trp.stepDur.round(0.001), ~trp.loopDur.round(0.01)).postln;
)
// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var trp       = ~trp;
    var bufFrames = (s.sampleRate * trp.loopDur).ceil.asInteger;

    trp.bufs = 3.collect { Buffer.alloc(s, bufFrames, 1) };
    // Circular live buffer — always contains the most recent liveBufSecs of input
    trp.liveBuf     = Buffer.alloc(s, (s.sampleRate * trp.liveBufSecs).ceil.asInteger, 1);
    trp.recFinished = [nil, nil, nil];
    trp.recSyns     = [nil, nil, nil];
    trp.routines    = [nil, nil, nil, nil];
    trp.partnerSyns = [nil, nil, nil, nil];
    trp.mixBus      = Bus.audio(s, 2);
    trp.partnerT0   = [0, 0, 0, 0];
    trp.liveRoutine = nil;
    trp.liveRecSyn  = nil;

    s.sync;

    trp.startPartner = { |partnerIdx, cycleIdx|
        var voice, buf, pIdx, cIdx, oldR, newR;
        var mixBusSlot, bufNumSlot, stepDurSlot, ampSlot;
        pIdx = partnerIdx.asInteger.clip(0, 3);
        cIdx = cycleIdx.asInteger.clip(0, 2);
        voice = trp.partnerVoices[pIdx];
        buf   = trp.bufs[cIdx];
        mixBusSlot  = [trp.mixBus.index];
        bufNumSlot  = [buf.bufnum];
        stepDurSlot = [trp.stepDur];
        ampSlot     = [trp.partnerAmp];

        if(trp.routines[pIdx].notNil, {
            oldR = trp.routines[pIdx];
            trp.routines[pIdx] = nil;
            AppClock.sched(0.02, { if(oldR.isPlaying, { oldR.stop }); nil });
        });

        trp.partnerT0[pIdx] = Main.elapsedTime;

        // .defer avoids re-entrancy when called from SystemClock.sched
        newR = Routine({
            var dh, dd, eh, ed, hp, mulB, slc, amp, pan, t0;
            var now, dt, w, nf, stFr, prob;
            dh   = voice[\driftHz]    ? 0.05;
            dd   = voice[\driftDepth] ? 0.08;
            eh   = voice[\evolveHz]   ? 0.003;
            ed   = voice[\evolveDepth]? 0.30;
            hp   = voice[\hitProb]    ? 0.25;
            mulB = voice[\stepMul]    ? 1.0;
            slc  = voice[\sliceSecs]  ? (trp.barDur / 4);  // 1 quarter note = natural note length
            amp  = ampSlot[0];
            pan  = voice[\pan] ? 0.0;
            t0   = trp.partnerT0[pIdx];

            while { ~trp.alive } {
                now  = Main.elapsedTime;
                dt   = now - t0;
                // LFO 1: breathes the step interval — each voice has its own drifting tempo
                w    = stepDurSlot[0] * mulB * (1 + (sin(2pi * dh * dt) * dd));
                // LFO 2: breathes the hit probability — creates natural fills and spaces
                prob = hp * (1 + (sin(2pi * eh * dt) * ed)).clip(0.3, 1.7);
                if(1.0.rand < prob, {
                    var ph, voiceOff, jitter, bf;
                    nf      = (slc * s.sampleRate).asInteger.max(8);
                    bf      = buf.numFrames;
                    // Anchor to the recording playhead so fragments start near note onsets.
                    // Pure random positions always land mid-sustain (guitar attack = ~5% of note).
                    ph      = if(trp.recFinished[cIdx].isNil, 0, {
                        (((Main.elapsedTime - trp.recFinished[cIdx]) / trp.loopDur).frac * bf).asInteger
                    });
                    voiceOff = (bf * pIdx / 4).asInteger;    // each voice reads different quarter
                    jitter   = (bf * 0.12.rand2).asInteger;  // ±12% ≈ ±1.4s — keeps it moving
                    stFr    = ((ph + voiceOff + jitter + bf) % bf).min(bf - nf).max(0);
                    Synth(\trpSlice, [
                        out:        mixBusSlot[0],
                        bufnum:     bufNumSlot[0],
                        startFrame: stFr,
                        numFrames:  nf,
                        amp:        amp,
                        pan:        pan,
                    ], trp.grpVoice);
                });
                w.max(0.02).wait;
            };
        });
        trp.routines[pIdx] = newR;
        { newR.play(SystemClock) }.defer(0.001);
        { "  P% — drifting (cycle %)".format(pIdx + 1, cIdx + 1).postln; }.defer;
    };

    trp.stopPartner = { |partnerIdx|
        var ix, oldR;
        ix = partnerIdx.asInteger.clip(0, 3);
        oldR = trp.routines[ix];
        if(oldR.notNil, {
            trp.routines[ix] = nil;
            AppClock.sched(0.02, { if(oldR.isPlaying, { oldR.stop }); nil });
        });
        if(trp.partnerSyns[ix].notNil, {
            trp.partnerSyns[ix].free;
            trp.partnerSyns[ix] = nil;
        });
    };

    SynthDef(\trpRec, { |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 0, doneAction: 2);
    }).add;

    SynthDef(\trpDetect, { |thresh=0.015|
        var amp   = Amplitude.kr(SoundIn.ar(0), attackTime: 0.005, releaseTime: 0.1);
        var above = amp > thresh;
        var trig  = above * (1 - Delay1.kr(above));
        SendReply.kr(trig, '/trp/firstNote', amp);
    }).add;

    // Slice: reads numFrames frames from buffer starting at startFrame.
    // Duration is derived from numFrames so envelope always matches audio length.
    // Attack 50ms / release 1.5s gives natural overlapping guitar wash.
    SynthDef(\trpSlice, { |out=0, bufnum=0, startFrame=0, numFrames=132300, amp=0.5, pan=0|
        var dur      = (numFrames / SampleRate.ir).max(0.001);
        var releaseT = 1.5.min(dur * 0.45);
        var attackT  = 0.05.min(dur * 0.1);
        var pos      = startFrame + Line.ar(0, (numFrames - 1).max(0), dur);
        var sig      = BufRd.ar(1, bufnum, pos, 0, 4);
        var env      = EnvGen.kr(
            Env.linen(attackT, (dur - attackT - releaseT).max(0.001), releaseT, 1, \sine),
            doneAction: 2);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    // Continuously writes guitar input into circular buffer (loop:1 = overwrite)
    SynthDef(\trpLiveRec, { |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum, recLevel: 1.0, preLevel: 0.0, loop: 1);
    }).add;

    // Live-input processing: pitch (via rate), reverse, and saturation.
    // startPos/endPos define read direction — reverse = endPos < startPos.
    // dur = numFrames/sampleRate/rate so slower sweep = lower pitch.
    SynthDef(\trpLiveProc, { |out=0, bufnum=0, startPos=0.0, endPos=22050.0, dur=0.75,
        satAmt=0.0, amp=0.18, pan=0.0|
        var nFrames  = BufFrames.ir(bufnum);
        var pos      = Line.ar(startPos, endPos, dur) % nFrames;
        var sig      = BufRd.ar(1, bufnum, pos, 1, 4);
        var gain     = 1 + (satAmt * 5);       // tanh drive
        var sat_sig  = (sig * gain).tanh / gain.sqrt;  // compensated soft-clip
        var out_sig  = sig + ((sat_sig - sig) * satAmt);
        var releaseT = 0.25.min(dur * 0.35);
        var attackT  = 0.03.min(dur * 0.08);
        var env      = EnvGen.kr(
            Env.linen(attackT, (dur - attackT - releaseT).max(0.001), releaseT, 1, \sine),
            doneAction: 2);
        Out.ar(out, Pan2.ar(out_sig * env * amp, pan));
    }).add;

    SynthDef(\trpDry, { |out=0, amp=0.58|
        Out.ar(out, (SoundIn.ar(0) * amp).dup);
    }).add;

    SynthDef(\trpMaster, {
        |busIn=0, out=0, reverbMix=0.15, reverbDecay=3.5, reverbDamp=0.5, reverbSize=1.1|
        var dry  = In.ar(busIn, 2);
        var safe = dry.clip2(0.7);
        var room = (reverbSize * 28).clip(10, 100);
        var verb = GVerb.ar(safe[0], roomsize: room,
            revtime: reverbDecay, damping: reverbDamp, drylevel: 0);
        var wet  = Sanitize.ar([verb[0], verb[1]]);
        Out.ar(out, ((dry * (1 - reverbMix)) + (wet * reverbMix)).clip2(1.0));
    }).add;

    SynthDef(\trpClick, { |out=2, bpm=80|
        var trig   = Impulse.kr(bpm / 60);
        var count  = PulseCount.kr(trig) % 4;
        var isDown = count < 1;
        var freq   = Select.kr(isDown, [880, 1200]);
        var sig    = SinOsc.ar(freq, 0, EnvGen.kr(Env.perc(0.001, 0.06), trig));
        Out.ar(out, sig.dup);
    }).add;

    SynthDef(\trpVoice, { |out=2, bufnum=0, amp=0.88|
        var sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 0, doneAction: 2);
        Out.ar(out, sig.dup * amp);
    }).add;

    s.sync;

    // Pre-render voice cue words (async — done well before any countdown fires at ~168s+)
    trp.cueBufs = ();
    {
        var words = [\four, \three, \two, \one];
        var texts = ["four", "three", "two", "one"];
        words.do { |key, i|
            var path = "/tmp/trp_cue_" ++ key ++ ".aiff";
            ("say -v " ++ trp.cueVoice ++ " -o " ++ path.shellQuote ++ " " ++ texts[i].shellQuote).unixCmd;
            1.5.wait;
            trp.cueBufs[key] = Buffer.read(s, path);
        };
        { "Voice cues loaded.".postln }.defer;
    }.fork(AppClock);

    trp.grpRec    = Group.new(s);
    trp.grpVoice  = Group.after(trp.grpRec);
    trp.grpDry    = Group.after(trp.grpVoice);
    trp.grpMaster = Group.after(trp.grpDry);

    trp.detectSyn  = Synth(\trpDetect, [thresh: trp.threshold], trp.grpRec);
    // Live circular recorder starts immediately — needs 8s of material before P5 enters
    trp.liveRecSyn = Synth(\trpLiveRec, [bufnum: trp.liveBuf], trp.grpRec);
    trp.drySyn    = Synth(\trpDry,
        [out: trp.mixBus.index, amp: trp.dryAmp], trp.grpDry);
    trp.masterSyn = Synth(\trpMaster, [
        busIn: trp.mixBus.index, out: 0,
        reverbMix: trp.reverbMix, reverbDecay: trp.reverbDecay,
        reverbSize: trp.reverbSize, reverbDamp: trp.reverbDamp,
    ], trp.grpMaster);

    if(trp.clickOn, {
        trp.clickSyn = Synth(\trpClick,
            [out: trp.clickOutChan, bpm: trp.bpm], trp.grpMaster);
        "Click on bus %".format(trp.clickOutChan).postln;
    });

    trp.firstFired = false;
    trp.alive      = true;

    // Live processing voice (P5): reads from circular live buffer, random effects.
    // Fires at exponentially-distributed random intervals (0.4–9s) → never a delay.
    // Effects: forward, reverse, down-4th (5 st), down-5th (7 st), down-octave,
    //          reverse+octave, and random saturation combos.
    trp.startLive = {
        var lBuf    = trp.liveBuf;
        var outSlot = [trp.mixBus.index];
        var ampSlot = [trp.liveAmp];
        var sr      = s.sampleRate;

        trp.liveRoutine = Routine({
            var nf, rPos, effect, rate, rev, sat, startPos, endPos, dur, pan;
            while { ~trp.alive } {
                exprand(0.3, 6.0).wait;  // exponential = more short gaps, rare long silences
                effect = #[\fwd, \rev, \down4, \down5, \down8, \rev8, \sat].choose;
                nf     = (rrand(0.4, 3.5) * sr).asInteger;
                rPos   = ((lBuf.numFrames - nf).max(1) * 1.0.rand).asInteger;
                rate   = 1.0; rev = false; sat = 0.0;
                case
                { effect == \fwd  } { /* defaults */ }
                { effect == \rev  } { rev = true }
                { effect == \down4 } { rate = 2.0 ** (-5.0/12) }           // down a 4th
                { effect == \down5 } { rate = 2.0 ** (-7.0/12) }           // down a 5th
                { effect == \down8 } { rate = 0.5 }                         // down an octave
                { effect == \rev8  } { rate = 0.5; rev = true; sat = 0.15 } // reverse octave
                { true } { rate = rrand(0.45, 1.3); rev = (1.0.rand < 0.35); sat = rrand(0.25, 0.65) };
                startPos = if(rev, { rPos + nf - 1 }, { rPos }).asFloat;
                endPos   = if(rev, { rPos },           { rPos + nf - 1 }).asFloat;
                dur      = (nf / sr / rate).max(0.05);
                pan      = 1.0.rand2;
                Synth(\trpLiveProc, [
                    out:      outSlot[0],
                    bufnum:   lBuf.bufnum,
                    startPos: startPos,
                    endPos:   endPos,
                    dur:      dur,
                    satAmt:   sat,
                    amp:      ampSlot[0],
                    pan:      pan,
                ], trp.grpVoice);
            };
        });
        { trp.liveRoutine.play(SystemClock) }.defer(0.001);
        { "  P5 live proc — started".postln; }.defer;
    };

    // Play "4 3 2 1" countdown on cue output, bar-aligned, delayFromNow seconds from first note
    trp.playCountdown = { |delayFromNow|
        var words = [\four, \three, \two, \one];
        4.do { |i|
            SystemClock.sched(delayFromNow + (i * trp.barDur), {
                if(~trp.alive, {
                    var buf = trp.cueBufs[words[i]];
                    if(buf.notNil, {
                        Synth(\trpVoice, [out: trp.clickOutChan, bufnum: buf.bufnum], trp.grpMaster);
                    });
                });
                nil
            });
        };
    };

    OSCdef(\trpFirstNote, { |msg|
        if(trp.firstFired.not, {
            trp.firstFired = true;
            trp.detectSyn.free;

            { "Tryphon — first note. Recording % bars...".format(trp.recBars).postln; }.defer;

            trp.recSyns[0] = Synth(\trpRec, [bufnum: trp.bufs[0]], trp.grpRec);

            SystemClock.sched(trp.loopDur, {
                if(trp.alive, {
                    trp.recFinished[0] = Main.elapsedTime;
                    { "Loop 1 ready — strata build...".postln; }.defer;
                    trp[\startPartner].(0, 0);
                    // P5 enters 30s after full bed (full bed = loopDur + buildStep×3 from first note)
                    SystemClock.sched(trp.buildStep * 3 + 30, {
                        if(trp.alive, {
                            trp[\startLive].();
                            { "P5 live proc — entering.".postln; }.defer;
                        });
                        nil
                    });
                    SystemClock.sched(trp.buildStep, { if(trp.alive, { trp[\startPartner].(1, 0) }); nil });
                    SystemClock.sched(trp.buildStep * 2, { if(trp.alive, { trp[\startPartner].(2, 0) }); nil });
                    SystemClock.sched(trp.buildStep * 3, {
                        if(trp.alive, {
                            trp[\startPartner].(3, 0);
                            { "Cycle 1 — full bed.".postln; }.defer;
                        });
                        nil
                    });
                });
                nil
            });

            // Countdowns: 4 bars = 12s before each transition
            trp[\playCountdown].(trp.cycleTimes[0] - (trp.barDur * 4));
            trp[\playCountdown].(trp.cycleTimes[1] - (trp.barDur * 4));
            trp[\playCountdown].(trp.totalDur - (trp.barDur * 4));

            SystemClock.sched(trp.cycleTimes[0], {
                if(trp.alive, {
                    { "\n─── Cycle 2 — re-record; P2–P4 drop...".postln; }.defer;
                    [1, 2, 3].do { |i| trp[\stopPartner].(i) };
                    trp.recSyns[1] = Synth(\trpRec, [bufnum: trp.bufs[1]], trp.grpRec);
                    SystemClock.sched(trp.loopDur, {
                        if(trp.alive, {
                            trp.recFinished[1] = Main.elapsedTime;
                            { "Loop 2 ready.".postln; }.defer;
                            trp[\startPartner].(0, 1);
                            SystemClock.sched(trp.buildStep, { if(trp.alive, { trp[\startPartner].(1, 1) }); nil });
                            SystemClock.sched(trp.buildStep * 2, { if(trp.alive, { trp[\startPartner].(2, 1) }); nil });
                            SystemClock.sched(trp.buildStep * 3, {
                                if(trp.alive, {
                                    trp[\startPartner].(3, 1);
                                    { "Cycle 2 — full bed.".postln; }.defer;
                                });
                                nil
                            });
                        });
                        nil
                    });
                });
                nil
            });

            SystemClock.sched(trp.cycleTimes[1], {
                if(trp.alive, {
                    { "\n─── Cycle 3 — re-record; P2–P4 drop...".postln; }.defer;
                    [1, 2, 3].do { |i| trp[\stopPartner].(i) };
                    trp.recSyns[2] = Synth(\trpRec, [bufnum: trp.bufs[2]], trp.grpRec);
                    SystemClock.sched(trp.loopDur, {
                        if(trp.alive, {
                            trp.recFinished[2] = Main.elapsedTime;
                            { "Loop 3 ready.".postln; }.defer;
                            trp[\startPartner].(0, 2);
                            SystemClock.sched(trp.buildStep, { if(trp.alive, { trp[\startPartner].(1, 2) }); nil });
                            SystemClock.sched(trp.buildStep * 2, { if(trp.alive, { trp[\startPartner].(2, 2) }); nil });
                            SystemClock.sched(trp.buildStep * 3, {
                                if(trp.alive, {
                                    trp[\startPartner].(3, 2);
                                    { "Cycle 3 — full bed.".postln; }.defer;
                                });
                                nil
                            });
                        });
                        nil
                    });
                });
                nil
            });

            SystemClock.sched(trp.totalDur, {
                if(trp.alive, {
                    { "Tryphon — hard stop.".postln; }.defer;
                    trp.alive = false;
                    OSCdef(\trpFirstNote).free;
                    if(trp.liveRoutine.notNil, { trp.liveRoutine.stop; trp.liveRoutine = nil });
                    Routine({
                        0.35.wait;
                        trp.partnerSyns.do { |syn| if(syn.notNil, { syn.free }) };
                        trp.bufs.do { |b| if(b.notNil, { b.free }) };
                        if(trp.liveBuf.notNil, { trp.liveBuf.free; trp.liveBuf = nil });
                        if(trp.liveRecSyn.notNil, { trp.liveRecSyn.free; trp.liveRecSyn = nil });
                        if(trp.mixBus.notNil, { trp.mixBus.free });
                        s.freeAll;
                        trp.routines = [nil, nil, nil, nil];
                    }).play(AppClock);
                });
                nil
            });

        });
    }, '/trp/firstNote');

    "".postln;
    "Tryphon — running (living strata). Threshold %.".format(trp.threshold).postln;
    "  +%s  partners begin after loop 1".format(trp.loopDur.round(1)).postln;
    "  +%s  cycle 2 | +%s  cycle 3".format(trp.cycleTimes[0], trp.cycleTimes[1]).postln;
    "  +%s  hard stop".format(trp.totalDur).postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP
// ─────────────────────────────────────────────────────────────────────────────
(
~trp.alive = false;
OSCdef(\trpFirstNote).free;
if(~trp.liveRoutine.notNil, { ~trp.liveRoutine.stop; ~trp.liveRoutine = nil });
Routine({
    0.35.wait;
    if(~trp.partnerSyns.notNil, { ~trp.partnerSyns.do { |s| if(s.notNil, { s.free }) } });
    if(~trp.bufs.notNil, { ~trp.bufs.do { |b| if(b.notNil, { b.free }) } });
    if(~trp.liveBuf.notNil, { ~trp.liveBuf.free });
    if(~trp.liveRecSyn.notNil, { ~trp.liveRecSyn.free });
    if(~trp.mixBus.notNil, { ~trp.mixBus.free });
    s.freeAll;
    ~trp.routines = [nil, nil, nil, nil];
    "Tryphon — stopped.".postln;
}).play(AppClock);
"Tryphon — stopping (routines exit on alive flag; cleanup deferred)…".postln;
)
