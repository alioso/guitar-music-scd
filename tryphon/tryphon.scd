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

    partnerAmp: 0.09,   // per spawned slice; 4 voices × ~3 overlapping = ~12 simultaneous
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

    // ── Per-voice metadata (independent evolution) ──────────────────────────
    // stepMul: base vs global 16th (≠1 ⇒ immediate polyrhythm vs grid)
    // driftHz / driftDepth: breathing of the step interval (living tempo)
    // evolveHz / evolveDepth: second slow LFO on top of stepMul
    // mutateSec: how often this voice nudges k / rotation / stochastic bias
    // patternMode: \euclid | \stoch | \blend
    // stochHit: baseline hit chance per step when stoch/blend
    // euclidByCycle: [[k,n], ...] for cycles 1..3
    partnerVoices: [
        (
            pan: -0.75, readQuarter: 0,
            stepMul: 1.0, driftHz: 0.055, driftDepth: 0.09,
            evolveHz: 0.0027, evolveDepth: 0.045,
            mutateSec: 16.0,
            patternMode: \blend,
            stochHit: 0.34,
            euclidByCycle: [[3, 16], [4, 16], [5, 16]],
        ),
        (
            pan: -0.25, readQuarter: 1,
            stepMul: 1.063, driftHz: 0.048, driftDepth: 0.11,
            evolveHz: 0.0038, evolveDepth: 0.052,
            mutateSec: 21.0,
            patternMode: \blend,
            stochHit: 0.38,
            euclidByCycle: [[4, 11], [5, 11], [7, 11]],
        ),
        (
            pan: 0.25, readQuarter: 2,
            stepMul: 0.94, driftHz: 0.062, driftDepth: 0.10,
            evolveHz: 0.0044, evolveDepth: 0.048,
            mutateSec: 13.0,
            patternMode: \stoch,
            stochHit: 0.42,
            euclidByCycle: [[5, 9], [6, 9], [7, 9]],
        ),
        (
            pan: 0.75, readQuarter: 3,
            stepMul: 1.11, driftHz: 0.041, driftDepth: 0.12,
            evolveHz: 0.0031, evolveDepth: 0.06,
            mutateSec: 26.0,
            patternMode: \euclid,
            stochHit: 0.30,
            euclidByCycle: [[6, 13], [7, 13], [9, 13]],
        ),
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
    trp.recFinished = [nil, nil, nil];
    trp.recSyns     = [nil, nil, nil];
    trp.routines    = [nil, nil, nil, nil];
    trp.partnerSyns = [nil, nil, nil, nil];
    trp.mixBus      = Bus.audio(s, 2);
    trp.partnerT0   = [0, 0, 0, 0];

    s.sync;

    trp.euclidean = { |k, n|
        var pattern = [], bucket = 0;
        n.do {
            bucket = bucket + k;
            if(bucket >= n) { bucket = bucket - n; pattern = pattern.add(1) }
            { pattern = pattern.add(0) };
        };
        pattern
    };

    // Loop playhead in frames (0 .. numFrames-1), synced to when recording ended.
    // Integer buffer index only — nested Routines must not close over arg names
    // like cycleIdx/partnerIdx: they can resolve via Event parent (~trp) and break.
    trp.playheadFrames = { |bufIdx|
        var bi, done, bf;
        bi = case
            { bufIdx.isKindOf(SimpleNumber) } { bufIdx.asInteger }
            { bufIdx.isKindOf(ArrayedCollection) && (bufIdx.size > 0) } { bufIdx[0].asInteger }
            { true } { 0 };
        bi = bi.clip(0, 2);
        done = trp.recFinished[bi];
        bf = trp.bufs[bi].numFrames.max(1);
        // No ^ (non-local return) — ^ from inside a Routine crashes with
        // "Return from non-local block" because waitForBoot already returned.
        if(done.isNil,
            { 0 },
            { (((Main.elapsedTime - done) / trp.loopDur).frac * bf).floor.asInteger.clip(0, bf - 1) }
        )
    };

    trp.startPartner = { |partnerIdx, cycleIdx|
        var voice, spec, k, n, pat, rot, buf, qOff, mode, stoch;
        var pIdx, cIdx, strataBufSlot, strataPartnerSlot, oldR, newR;
        var mixBusSlot, bufNumSlot, stepDurSlot, ampSlot;
        pIdx = partnerIdx.asInteger.clip(0, 3);
        cIdx = cycleIdx.asInteger.clip(0, 2);
        strataBufSlot = [cIdx];
        strataPartnerSlot = [pIdx];
        voice = trp.partnerVoices[pIdx].copy;
        spec  = voice[\euclidByCycle][cIdx];
        k     = spec[0];
        n     = spec[1];
        pat   = trp[\euclidean].(k, n).asArray;
        rot   = (pIdx * 4 + (cIdx * 2)) % n;
        pat   = pat.rotate(rot);
        buf   = trp.bufs[cIdx];
        qOff  = (buf.numFrames * (voice[\readQuarter] ? 0) / 4).asInteger;
        mode  = (voice[\patternMode] ? \blend).asSymbol;
        stoch = voice[\stochHit] ? 0.35;
        mixBusSlot = [trp.mixBus.index];
        bufNumSlot = [buf.bufnum];
        stepDurSlot = [trp.stepDur];
        ampSlot = [trp.partnerAmp];

        if(trp.routines[pIdx].notNil, {
            oldR = trp.routines[pIdx];
            trp.routines[pIdx] = nil;
            AppClock.sched(0.02, { if(oldR.isPlaying, { oldR.stop }); nil });
        });
        if(trp.partnerSyns[pIdx].notNil, {
            trp.partnerSyns[pIdx].free;
            trp.partnerSyns[pIdx] = nil;
        });

        trp.partnerT0[pIdx] = Main.elapsedTime;

        // Never Routine.play(SystemClock) from inside SystemClock.sched (loop
        // callback) — re-entrancy → "Tried to resume the running thread".
        // .defer breaks the stack; then play is safe.
        newR = Routine({
            var step, nextMutate, kk, nn, pattern, st, slc, amp, pan, mulB;
            var dh, dd, eh, ed, t0, now, dt, w, hit, ph, msec, nf, stFr;
            step = 0;
            nextMutate = Main.elapsedTime + (voice[\mutateSec] ? 18) * rrand(0.75, 1.25);
            kk = k;
            nn = n;
            pattern = pat;
            st = stoch;
            slc = voice[\sliceSecs] ? trp.barDur;  // default = 1 bar (3s at 80 BPM)
            amp = ampSlot[0];
            pan = voice[\pan] ? 0;
            mulB = voice[\stepMul] ? 1;
            dh = voice[\driftHz] ? 0.05;
            dd = voice[\driftDepth] ? 0.08;
            eh = voice[\evolveHz] ? 0.003;
            ed = voice[\evolveDepth] ? 0.05;
            t0 = trp.partnerT0[strataPartnerSlot[0]];
            while { ~trp.alive } {
                now = Main.elapsedTime;
                dt = now - t0;
                w = stepDurSlot[0] * mulB
                    * (1 + (sin(2pi * dh * dt) * dd))
                    * (1 + (sin(2pi * eh * dt) * ed));
                hit = false;

                if(now >= nextMutate, {
                    msec = voice[\mutateSec] ? 18;
                    nextMutate = now + msec * rrand(0.7, 1.3);
                    kk = (kk + [-1, 0, 1].choose).clip(2, nn - 1);
                    pattern = trp[\euclidean].(kk, nn).asArray.rotate(rrand(0, nn - 1));
                    st = (st + rrand(-0.08, 0.08)).clip(0.12, 0.62);
                });

                case { mode == \euclid } {
                    hit = pattern[step % nn] == 1;
                }
                { mode == \stoch } {
                    hit = 1.0.rand < st;
                }
                { true } {
                    hit = (pattern[step % nn] == 1) or: { 1.0.rand < st };
                };

                if(hit, {
                    ph = (trp[\playheadFrames].(strataBufSlot) + qOff) % buf.numFrames.max(1);
                    nf = (slc * s.sampleRate).asInteger.max(8);
                    nf = min(nf, buf.numFrames - ph).max(8);
                    stFr = ph;
                    Synth(\trpSlice, [
                        out: mixBusSlot[0], bufnum: bufNumSlot[0],
                        startFrame: stFr, numFrames: nf,
                        amp: amp, pan: pan,
                    ], trp.grpVoice);
                });

                w.max(0.02).wait;
                step = step + 1;
            };
        });
        trp.routines[pIdx] = newR;
        { newR.play(SystemClock) }.defer(0.001);

        { "  P% — strata on (cycle %) | mode %".format(
            pIdx + 1, cIdx + 1, mode).postln; }.defer;
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

    s.sync;

    trp.grpRec    = Group.new(s);
    trp.grpVoice  = Group.after(trp.grpRec);
    trp.grpDry    = Group.after(trp.grpVoice);
    trp.grpMaster = Group.after(trp.grpDry);

    trp.detectSyn = Synth(\trpDetect, [thresh: trp.threshold], trp.grpRec);
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

            SystemClock.sched(trp.totalDur - trp.endDropBefore, {
                if(trp.alive, {
                    { "\n─── Duo — P2–P4 off.".postln; }.defer;
                    [1, 2, 3].do { |i| trp[\stopPartner].(i) };
                });
                nil
            });

            SystemClock.sched(trp.totalDur, {
                if(trp.alive, {
                    { "Tryphon — hard stop.".postln; }.defer;
                    trp.alive = false;
                    OSCdef(\trpFirstNote).free;
                    Routine({
                        0.35.wait;
                        trp.partnerSyns.do { |syn| if(syn.notNil, { syn.free }) };
                        trp.bufs.do { |b| if(b.notNil, { b.free }) };
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
 "  +%s  duo | +%s  stop".format(
        trp.totalDur - trp.endDropBefore, trp.totalDur).postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP
// ─────────────────────────────────────────────────────────────────────────────
(
~trp.alive = false;
OSCdef(\trpFirstNote).free;
Routine({
    0.35.wait;
    if(~trp.partnerSyns.notNil, { ~trp.partnerSyns.do { |s| if(s.notNil, { s.free }) } });
    if(~trp.bufs.notNil, { ~trp.bufs.do { |b| if(b.notNil, { b.free }) } });
    if(~trp.mixBus.notNil, { ~trp.mixBus.free });
    s.freeAll;
    ~trp.routines = [nil, nil, nil, nil];
    "Tryphon — stopped.".postln;
}).play(AppClock);
"Tryphon — stopping (routines exit on alive flag; cleanup deferred)…".postln;
)
