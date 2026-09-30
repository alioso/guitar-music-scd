/*
Tryphon
Living polyrhythmic guitar bed — SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)
  Click:  metronome → output 2+3 (headphones, Scarlett 4i4+)

  Four partners = tight one-shots sliced from the loop (no pitch shift).
  Each voice has its own drifting clock and density; every slice starts on
  an attack detected while the loop was recorded.

  Input tip: clear harmony + simple rhythm (e.g. quarters) fills the buffer
  with a readable “pool”; complexity comes from the four strata, not from
  you playing dense rhythm.

STRUCTURE (~7 min from first note)
  t=0        first note → record 4 bars
  t=12s      P1 · P2 · P3 · P4 stagger by 12s
  t=1:18     P5 (live processing) enters
  t=3m / 5m  cycle change, re-record, rebuild
  t=6m12s    crescendo — all partners ramp to peak over 16 bars
  t=7m       hard stop
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
// BLOCK 1 — CONFIGURATION
// ─────────────────────────────────────────────────────────────────────────────
(
~trp = (
    bpm:     80,
    recBars: 4,

    partnerAmp: 0.16,   // per spawned slice; 4 voices × ~2 overlapping = ~8 simultaneous
    partnerPeak: 0.50,  // partner level at the top of the crescendo
    dryAmp:     0.32,

    // Master
    reverbMix:   0.15,
    reverbDecay: 3.5,
    reverbSize:  1.1,
    reverbDamp:  0.5,

    threshold: 0.015,
    onsetSens: 0.4,     // attack detection inside the recorded loop (lower = more attacks)

    totalDur:       420,
    cycleTimes:     [180, 300],

    clickOn:      true,
    clickOutChan: 2,
    cueVoice:     "Samantha",

    // Live-input processing voice (P5) — separate circular buffer, random effects
    liveAmp:      0.24,   // amplitude; dynamics come directly from your playing
    livePeak:     0.60,   // P5 level at the top of the crescendo
    liveBufSecs:  8.0,    // how many seconds of recent input are kept

    // Per-voice drifting rhythm — two LFOs per voice, no euclidean math.
    // stepMul:    base tempo vs global 16th — irrational ratios, so the voices never realign
    // driftHz/driftDepth:   LFO 1 — breathes the step interval (living tempo)
    // evolveHz/evolveDepth: LFO 2 — breathes the hit probability (fills & spaces)
    // hitProb:    base probability of firing on any step (drifts via evolve LFO)
    // slice:      the next attack at or after (playhead + this voice's bar offset
    //             ± jitterSteps 16ths) — slices always begin on a played note
    jitterSteps: 2,
    partnerVoices: [
        (pan: -0.75, stepMul: 1.0,              driftHz: 0.055, driftDepth: 0.09,
                     evolveHz: 0.0027, evolveDepth: 0.30, hitProb: 0.22, satAmt: 0.40),
        (pan: -0.25, stepMul: 2 ** (1/12),      driftHz: 0.048, driftDepth: 0.11,
                     evolveHz: 0.0038, evolveDepth: 0.28, hitProb: 0.28),
        (pan:  0.25, stepMul: 2.sqrt * (2/3),   driftHz: 0.062, driftDepth: 0.10,
                     evolveHz: 0.0044, evolveDepth: 0.32, hitProb: 0.25),
        (pan:  0.75, stepMul: 2 ** (1/7),       driftHz: 0.041, driftDepth: 0.12,
                     evolveHz: 0.0031, evolveDepth: 0.35, hitProb: 0.20, satAmt: 0.40),
    ],
);

~trp.barDur    = 60 / ~trp.bpm * 4;
~trp.stepDur   = ~trp.barDur / 16;
~trp.loopDur   = ~trp.barDur * ~trp.recBars;
~trp.buildStep = ~trp.barDur * 4;

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
    var sr        = s.sampleRate;
    var bufFrames = (sr * trp.loopDur).ceil.asInteger;

    // Private timeline clock — stopping it cancels everything this piece scheduled
    trp.tclock = TempoClock(1);

    trp.bufs = 3.collect { Buffer.alloc(s, bufFrames, 1) };
    // Circular live buffer — always contains the most recent liveBufSecs of input
    trp.liveBuf     = Buffer.alloc(s, (sr * trp.liveBufSecs).ceil.asInteger, 1);
    trp.recFinished = [nil, nil, nil];
    trp.onsets      = [List[], List[], List[]];   // attack frames found in each loop
    trp.routines    = [nil, nil, nil, nil];
    trp.mixBus      = Bus.audio(s, 2);
    trp.partnerAmpNow = trp.partnerAmp;   // crescendo ramps these; voices read them per hit
    trp.liveAmpNow    = trp.liveAmp;

    s.sync;

    // First attack at or after `frame` in cycle cIdx's loop (wrapping); falls back
    // to `frame` itself when no attacks were detected
    trp.nextOnset = { |cIdx, frame|
        var list = trp.onsets[cIdx];
        if(list.isEmpty) { frame } {
            list.detect { |f| f >= frame } ? list[0]
        };
    };

    trp.startPartner = { |partnerIdx, cycleIdx|
        var voice = trp.partnerVoices[partnerIdx];
        var cIdx  = cycleIdx;
        var buf   = trp.bufs[cIdx];

        trp.routines[partnerIdx] !? _.stop;

        trp.routines[partnerIdx] = Routine({
            var dh   = voice[\driftHz]    ? 0.05;
            var dd   = voice[\driftDepth] ? 0.08;
            var eh   = voice[\evolveHz]   ? 0.003;
            var ed   = voice[\evolveDepth]? 0.30;
            var hp   = voice[\hitProb]    ? 0.25;
            var mulB = voice[\stepMul]    ? 1.0;
            var slc  = voice[\sliceSecs]  ? (trp.barDur / 4);  // 1 quarter note = natural note length
            var pan  = voice[\pan]    ? 0.0;
            var sat  = voice[\satAmt] ? 0.0;
            var t0   = thisThread.seconds;
            var bf   = buf.numFrames;
            var nf   = (slc * sr).asInteger.max(8);
            var voiceOff = (bf * partnerIdx / 4).asInteger;    // each voice reads a different bar
            var jitMax   = trp.stepDur * trp.jitterSteps * sr;
            var dt, w, prob, ph, stFr;

            loop {
                dt   = thisThread.seconds - t0;
                // LFO 1: breathes the step interval — each voice has its own drifting tempo
                w    = trp.stepDur * mulB * (1 + (sin(2pi * dh * dt) * dd));
                // LFO 2: breathes the hit probability — creates natural fills and spaces
                prob = hp * (1 + (sin(2pi * eh * dt) * ed)).clip(0.3, 1.7);
                if(1.0.rand < prob, {
                    // Loop position that lines up with "now" on the recording's bar grid
                    ph   = ((thisThread.seconds - trp.recFinished[cIdx]) / trp.loopDur).frac * bf;
                    stFr = trp[\nextOnset].(cIdx,
                        ((ph + voiceOff + jitMax.rand2).round.asInteger % bf));
                    stFr = stFr.min(bf - nf).max(0);
                    Synth(\trpSlice, [
                        out:        trp.mixBus.index,
                        bufnum:     buf.bufnum,
                        startFrame: stFr,
                        numFrames:  nf,
                        amp:        trp.partnerAmpNow,
                        pan:        pan,
                        satAmt:     sat,
                    ], trp.grpVoice);
                });
                w.max(0.02).wait;
            };
        }).play(trp.tclock);
        { "  P% — drifting (cycle %)".format(partnerIdx + 1, cIdx + 1).postln; }.defer;
    };

    trp.stopPartner = { |partnerIdx|
        trp.routines[partnerIdx] !? _.stop;
        trp.routines[partnerIdx] = nil;
    };

    // Free everything this piece owns (Block 3 and the automatic hard stop)
    trp.cleanup = {
        if(trp.cleanedUp.not) {
            trp.cleanedUp = true;
            OSCdef(\trpFirstNote).free;
            OSCdef(\trpMark).free;
            trp.tclock.stop;
            trp.grpRoot.free;
            trp.bufs.do(_.free);
            trp.liveBuf.free;
            trp.cueBufs.do(_.free);
            trp.mixBus.free;
        };
    };

    SynthDef(\trpRec, { |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 0, doneAction: 2);
    }).add;

    // Runs alongside \trpRec for exactly one loop: reports the time of each attack
    // (Schmidt = hysteresis, so a decaying note can't re-trigger; attacks ≥ 60 ms apart)
    SynthDef(\trpMark, { |thresh=0.015, sens=0.4, dur=12, cycle=0|
        var sig   = SoundIn.ar(0);
        var amp   = A2K.kr(Amplitude.ar(sig, attackTime: 0.005, releaseTime: 0.1));
        var above = Schmidt.kr(amp, thresh * 0.5, thresh);
        var rise  = above * (1 - Delay1.kr(above));
        var onset = Onsets.kr(FFT(LocalBuf(512), sig), sens, \rcomplex) * above;
        var hold  = Trig1.kr((rise + onset) > 0, 0.06);
        var t     = Sweep.kr(0, 1);
        Line.kr(0, 0, dur, doneAction: 2);
        SendReply.kr(hold * (1 - Delay1.kr(hold)), '/trp/mark', [t], cycle);
    }).add;

    SynthDef(\trpDetect, { |thresh=0.015|
        var amp   = A2K.kr(Amplitude.ar(SoundIn.ar(0), attackTime: 0.005, releaseTime: 0.1));
        var above = amp > thresh;
        var trig  = above * (1 - Delay1.kr(above));
        SendReply.kr(trig, '/trp/firstNote', amp);
    }).add;

    // Slice: reads numFrames frames from buffer starting at startFrame.
    // Duration is derived from numFrames so envelope always matches audio length.
    // Short attack keeps the note's transient; release gives natural overlap.
    SynthDef(\trpSlice, { |out=0, bufnum=0, startFrame=0, numFrames=132300, amp=0.5, pan=0, satAmt=0.0|
        var dur      = (numFrames / SampleRate.ir).max(0.001);
        var releaseT = 1.5.min(dur * 0.45);
        var attackT  = 0.005.min(dur * 0.1);
        var pos      = startFrame + Line.ar(0, (numFrames - 1).max(0), dur);
        var sig      = BufRd.ar(1, bufnum, pos, 0, 4);
        var gain     = 1 + (satAmt * 5);
        var sat_sig  = (sig * gain).tanh / gain.sqrt;
        var out_sig  = sig + ((sat_sig - sig) * satAmt);
        var env      = EnvGen.kr(
            Env.linen(attackT, (dur - attackT - releaseT).max(0.001), releaseT, 1, \sine),
            doneAction: 2);
        Out.ar(out, Pan2.ar(out_sig * env * amp, pan));
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
        var verb = GVerb.ar(safe.sum * 0.5, roomsize: room,
            revtime: reverbDecay, damping: reverbDamp, drylevel: 0);
        var wet  = Sanitize.ar(verb);
        var sig  = (dry * (1 - reverbMix)) + (wet * reverbMix);
        Out.ar(out, Limiter.ar(sig, 0.95, 0.003));
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

    // Pre-render voice cue words (blocking — takes a second or two)
    trp.cueBufs = ();
    [\four, \three, \two, \one].do { |key|
        var path = "/tmp/trp_cue_" ++ key ++ ".aiff";
        ("say -v " ++ trp.cueVoice ++ " -o " ++ path.shellQuote ++ " " ++ key.asString.shellQuote).systemCmd;
        trp.cueBufs[key] = Buffer.read(s, path);
    };

    s.sync;
    "Voice cues loaded.".postln;

    trp.grpRoot   = Group.new(s);
    trp.grpRec    = Group.head(trp.grpRoot);
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
    trp.cleanedUp  = false;

    // Live processing voice (P5): reads from circular live buffer, random effects.
    // Fires at exponentially-distributed random intervals (0.3–6s) → never a delay.
    // Effects: forward, reverse, down-4th (5 st), down-5th (7 st), down-octave,
    //          reverse+octave, and random saturation combos.
    trp.startLive = {
        var lBuf = trp.liveBuf;

        trp.liveRoutine = Routine({
            var nf, rPos, effect, rate, rev, sat, startPos, endPos, dur, pan;
            loop {
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
                    out:      trp.mixBus.index,
                    bufnum:   lBuf.bufnum,
                    startPos: startPos,
                    endPos:   endPos,
                    dur:      dur,
                    satAmt:   sat,
                    amp:      trp.liveAmpNow,
                    pan:      pan,
                ], trp.grpVoice);
            };
        }).play(trp.tclock);
        { "  P5 live proc — started".postln; }.defer;
    };

    // Play "4 3 2 1" countdown on cue output, delayFromNow seconds from first note
    trp.playCountdown = { |delayFromNow, beatSpacing|
        var words = [\four, \three, \two, \one];
        var spc   = beatSpacing ? (trp.barDur / 4);  // default: quarter-note cue; pass barDur for slow
        4.do { |i|
            trp.tclock.sched(delayFromNow + (i * spc), {
                var buf = trp.cueBufs[words[i]];
                if((buf.numFrames ? 0) > 0, {
                    Synth(\trpVoice, [out: trp.clickOutChan, bufnum: buf.bufnum], trp.grpMaster);
                });
                nil
            });
        };
    };

    // Record one 4-bar loop (and mark its attacks); partners rebuild when it's done
    trp.recordCycle = { |cIdx|
        var preRoll = 0.01 * sr;   // start slices just before the detected attack
        trp.onsets[cIdx] = List[];
        OSCdef(\trpMark, { |msg|
            var c = msg[2];
            trp.onsets[c].add(((msg[3] * sr) - preRoll).max(0).round.asInteger);
        }, '/trp/mark');
        s.makeBundle(nil, {
            Synth(\trpRec, [bufnum: trp.bufs[cIdx]], trp.grpRec);
            Synth(\trpMark, [thresh: trp.threshold, sens: trp.onsetSens,
                dur: trp.loopDur, cycle: cIdx], trp.grpRec);
        });

        trp.tclock.sched(trp.loopDur, {
            trp.recFinished[cIdx] = thisThread.seconds;
            trp.bufs[cIdx].normalize(0.7);
            { "Loop % ready (% attacks).".format(cIdx + 1, trp.onsets[cIdx].size).postln; }.defer;
            trp[\startPartner].(0, cIdx);
            3.do { |k|
                trp.tclock.sched(trp.buildStep * (k + 1), {
                    trp[\startPartner].(k + 1, cIdx);
                    if(k == 2) { { "Cycle % — full bed.".format(cIdx + 1).postln; }.defer };
                    nil
                });
            };
            nil
        });
    };

    OSCdef(\trpFirstNote, { |msg|
        if(trp.firstFired.not, {
            trp.firstFired = true;
            trp.detectSyn.free;

            { "Tryphon — first note. Recording % bars...".format(trp.recBars).postln; }.defer;

            trp[\recordCycle].(0);

            // P5 enters 30s after full bed (full bed = loopDur + buildStep×3 from first note)
            trp.tclock.sched(trp.loopDur + (trp.buildStep * 3) + 30, {
                trp[\startLive].value;
                nil
            });

            // Cycle countdowns: 1 bar before (quarter-note spacing = 4 beats in 1 bar)
            trp[\playCountdown].(trp.cycleTimes[0] - trp.barDur);
            trp[\playCountdown].(trp.cycleTimes[1] - trp.barDur);
            // Hard-stop countdown: two slow 4/3/2/1 (one word per bar) across 8 bars
            trp[\playCountdown].(trp.totalDur - (trp.barDur * 8), trp.barDur);
            trp[\playCountdown].(trp.totalDur - (trp.barDur * 4), trp.barDur);

            // Crescendo: last 16 bars — every partner and P5 ramp to peak for the cliff
            trp.tclock.sched(trp.totalDur - (trp.barDur * 16), {
                var dur = trp.barDur * 16;
                var t0  = thisThread.seconds;
                { "Crescendo.".postln; }.defer;
                Routine({
                    loop {
                        var frac = ((thisThread.seconds - t0) / dur).clip(0.0, 1.0);
                        trp.partnerAmpNow = trp.partnerAmp + ((trp.partnerPeak - trp.partnerAmp) * frac);
                        trp.liveAmpNow    = trp.liveAmp + ((trp.livePeak - trp.liveAmp) * frac);
                        0.25.wait;
                    };
                }).play(trp.tclock);
                nil
            });

            // Cycle changes: P2–P4 drop, P1 keeps the old loop until the new one is ready
            trp.cycleTimes.do { |time, i|
                trp.tclock.sched(time, {
                    { "\n─── Cycle % — re-record; P2–P4 drop...".format(i + 2).postln; }.defer;
                    [1, 2, 3].do { |k| trp[\stopPartner].(k) };
                    trp[\recordCycle].(i + 1);
                    nil
                });
            };

            trp.tclock.sched(trp.totalDur, {
                { "Tryphon — hard stop.".postln; }.defer;
                AppClock.sched(0, { trp[\cleanup].value; nil });
                nil
            });
        });
    }, '/trp/firstNote');

    "".postln;
    "Tryphon — running (living strata). Threshold %.".format(trp.threshold).postln;
    "  +%s  partners begin after loop 1".format(trp.loopDur.round(1)).postln;
    "  +%s  cycle 2 | +%s  cycle 3".format(trp.cycleTimes[0], trp.cycleTimes[1]).postln;
    "  +%s  crescendo | +%s  hard stop".format(
        (trp.totalDur - (trp.barDur * 16)).round(1), trp.totalDur).postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP
// ─────────────────────────────────────────────────────────────────────────────
(
~trp[\cleanup].value;
"Tryphon — stopped.".postln;
)
