// ==============================================================
// ARMORIKA
// Generative Synclavier bed + guitar melody
// Inspired by Zappa / Civilization Phaze III
// ==============================================================

( // CONFIG
~aCfg = (
    thresh:      0.015,
    refractory:  0.09,
    resAmp:      0.28,    // resonator bank driven by guitar
    ringAmp:     0.20,    // ring-modulated dry guitar
    bedAmp:      0.42,    // bed is part of the piece, not background
    shadowAmp:   0.08,
    revMix:      0.32,
    revRoom:     0.88,

    // Natural minor — default harmonic world
    mode: [0, 2, 3, 5, 7, 8, 10],

    // [synthName, octOff, stepMin, stepMax, restProb, amp, decMin, decMax, panRange, octVar, atkMin, atkMax]
    streamDefs: [
        [\bedOrgan,      0,  0.55, 1.80, 0.12, 0.17, 2.0, 6.0, 0.4, 1, 0.05, 0.12],
        [\bedBass,      -24, 0.60, 2.00, 0.25, 0.20, 1.0, 3.0, 0.2, 0, 0.02, 0.08],
        [\bedString,     0,  0.50, 1.20, 0.40, 0.12, 2.0, 5.0, 0.6, 0, 0.03, 0.12],
        [\bedFlute,      12, 0.30, 0.70, 0.45, 0.11, 0.5, 1.5, 0.5, 0, 0.01, 0.05],
        [\bedChime,      12, 0.22, 0.55, 0.55, 0.14, 0.3, 0.9, 0.7, 0, 0.002, 0.01],
        [\bedBrass,      0,  0.28, 0.65, 0.40, 0.16, 0.5, 1.2, 0.6, 0, 0.02, 0.07],
        [\bedGranGuitar, 0,  0.70, 2.00, 0.35, 0.14, 2.0, 5.0, 0.7, 0, 0.10, 0.30],
    ],
);
)

( // BOOT
s.waitForBoot({

    // --- Detection ---
    SynthDef(\armorikaDetect, { |thresh=0.015|
        var in       = SoundIn.ar(0);
        var amp      = Amplitude.kr(in, attackTime: 0.005, releaseTime: 0.1);
        var pitchArr = Pitch.kr(in, execFreq: 100, median: 7);
        var pitch    = pitchArr[0];
        var hasPitch = pitchArr[1];
        var above    = amp > thresh;
        var trig     = above * (1 - Delay1.kr(above));
        SendReply.kr(trig * hasPitch, '/armorika/note', [pitch, amp]);
    }).add;

    // --- Bed instruments ---

    // Additive organ — the loved one, kept clean (just adds atk param)
    SynthDef(\bedOrgan, { |out=0, freq=440, amp=0.08, pan=0.0, decay=3.0, atk=0.4|
        var sig = SinOsc.ar(freq)     * 0.50
                + SinOsc.ar(freq * 2) * 0.30
                + SinOsc.ar(freq * 3) * 0.15
                + SinOsc.ar(freq * 4) * 0.05;
        var env = EnvGen.kr(Env.perc(atk, decay, curve: -2), doneAction: 2);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    // Warm FM bass — subtle wobble + noise grain
    SynthDef(\bedBass, { |out=0, freq=440, amp=0.12, pan=0.0, decay=2.0, atk=0.1|
        var wobble = LFNoise1.kr(2).range(0.997, 1.003);
        var mod    = SinOsc.ar(freq * 0.5 * wobble, 0, freq * 0.4);
        var car    = SinOsc.ar(freq * wobble + mod);
        var noise  = HPF.ar(PinkNoise.ar(0.012), 300);
        var sat    = ((car + noise) * 1.6).tanh;
        var env    = EnvGen.kr(Env.perc(atk, decay, curve: -2), doneAction: 2);
        Out.ar(out, Pan2.ar(sat * env * amp, pan));
    }).add;

    // Detuned string pair — two independent wobbles create natural beating
    SynthDef(\bedString, { |out=0, freq=440, amp=0.08, pan=0.0, decay=4.0, atk=0.3|
        var w1  = LFNoise1.kr(1.5).range(0.997, 1.003);
        var w2  = LFNoise1.kr(1.7).range(0.997, 1.003);
        var sig = SinOsc.ar(freq * w1)         * 0.60
                + SinOsc.ar(freq * 1.003 * w2) * 0.40;
        var noise = HPF.ar(PinkNoise.ar(0.012), 400);
        var sat   = ((sig + noise) * 1.3).tanh;
        var env   = EnvGen.kr(Env.perc(atk, decay, curve: -2), doneAction: 2);
        Out.ar(out, Pan2.ar(sat * env * amp, pan));
    }).add;

    // Flute — low modIndex FM + breath noise
    SynthDef(\bedFlute, { |out=0, freq=440, amp=0.08, pan=0.0, decay=1.2, atk=0.06|
        var wobble = LFNoise1.kr(4).range(0.996, 1.004);
        var breath = HPF.ar(PinkNoise.ar(0.03), 800);
        var mod    = SinOsc.ar(freq * 4.0 * wobble, 0, freq * 0.12);
        var car    = SinOsc.ar(freq * wobble + mod);
        var sig    = (car * 0.85) + (breath * 0.15);
        var sat    = (sig * 1.2).tanh;
        var env    = EnvGen.kr(Env.perc(atk, decay, curve: -4), doneAction: 2);
        Out.ar(out, Pan2.ar(sat * env * amp, pan));
    }).add;

    // Bell/chime — bright FM + mallet click transient
    SynthDef(\bedChime, { |out=0, freq=440, amp=0.1, pan=0.0, decay=0.6, atk=0.005|
        var wobble = LFNoise1.kr(5).range(0.998, 1.002);
        var mod    = SinOsc.ar(freq * 3.5 * wobble, 0, freq * 1.5);
        var car    = SinOsc.ar(freq * wobble + mod);
        var click  = HPF.ar(PinkNoise.ar(0.05), 2000) * EnvGen.kr(Env.perc(0.001, 0.015));
        var env    = EnvGen.kr(Env.perc(atk, decay, curve: -5), doneAction: 2);
        Out.ar(out, Pan2.ar((car + click) * env * amp, pan));
    }).add;

    // Brass — high modIndex FM + aggressive saturation
    SynthDef(\bedBrass, { |out=0, freq=440, amp=0.1, pan=0.0, decay=0.9, atk=0.08|
        var wobble = LFNoise1.kr(2).range(0.995, 1.005);
        var mod    = SinOsc.ar(freq * 1.0 * wobble, 0, freq * 2.5);
        var car    = SinOsc.ar(freq * wobble + mod);
        var noise  = HPF.ar(PinkNoise.ar(0.02), 600);
        var sat    = ((car + noise) * 2.2).tanh;
        var env    = EnvGen.kr(Env.perc(atk, decay, curve: -3), doneAction: 2);
        Out.ar(out, Pan2.ar(sat * env * amp, pan));
    }).add;

    // Granular guitar — TGrains from live input buffer, pitched to root
    SynthDef(\bedGranGuitar, { |out=0, bufnum=0, freq=440, amp=0.08, decay=3.0, atk=0.4|
        var rate = freq / 440.0;
        var pos  = LFNoise1.kr(0.3).range(0, BufDur.kr(bufnum));
        var sig  = TGrains.ar(2, Impulse.ar(12), bufnum, rate, pos, 0.12,
                              LFNoise1.kr(0.5).range(-0.8, 0.8), amp);
        var env  = EnvGen.kr(Env.perc(atk, decay, curve: -2), doneAction: 2);
        Out.ar(out, sig * env);
    }).add;

    // --- Guitar input: resonator bank — 7 narrow Resonz filters tuned to current mode,
    //     excited by live guitar. Responds to playing energy, not pitch.
    //     Sounds like bowed metal tines. Frequencies updated on root/mode change.
    SynthDef(\armorikaResonator, { |out=0, amp=0.28,
        f0=880, f1=988, f2=1109, f3=1245, f4=1319, f5=1480, f6=1568|
        var in     = SoundIn.ar(0);
        var exc    = HPF.ar(in, 100);
        var drift  = LFNoise1.kr([0.07, 0.05, 0.09, 0.06, 0.08, 0.05, 0.07]).range(0.995, 1.005);
        var res    = Resonz.ar(exc, [f0, f1, f2, f3, f4, f5, f6] * drift, 0.008);
        var pans   = [-0.6, -0.3, 0.1, -0.5, 0.4, 0.2, 0.6];
        var spread = res.collect { |r, i| Pan2.ar(r, pans[i]) }.sum;
        var ampEnv = Amplitude.kr(in, 0.005, 0.6).linlin(0, 0.2, 0, 1).clip(0, 1);
        Out.ar(out, spread * amp * ampEnv);
    }).add;

    // --- Ring-modulated guitar — carrier at root, slight saturation for body ---
    SynthDef(\armorikaRingMod, { |out=0, amp=0.20, carrierFreq=440|
        var in      = SoundIn.ar(0);
        var carrier = SinOsc.ar(carrierFreq);
        var ring    = (in * carrier * 3.0).tanh * 0.7;
        Out.ar(out, Pan2.ar(ring * amp, 0));
    }).add;

    // --- FM shadow on each pluck ---
    SynthDef(\armorikaVoiceA, { |out=0, freq=440, decay=0.6, amp=0.05, pan=0.0|
        var mod = SinOsc.ar(freq * 2.01, 0, freq * 0.5);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.04, decay, curve: -4), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // --- Master: reverb + soft limit ---
    SynthDef(\armorikaMaster, { |out=0, in=0, revMix=0.32, revRoom=0.88, amp=1|
        var sig = In.ar(in, 2);
        var wet = FreeVerb2.ar(sig[0], sig[1], mix: revMix, room: revRoom, damp: 0.4);
        Out.ar(out, Limiter.ar(wet * amp.lag(1.0), 0.95));
    }).add;

    // Allocate guitar capture buffer (8 seconds)
    ~gBuf = Buffer.alloc(s, (s.sampleRate * 8).asInteger, 1);

    s.sync;

    // --- Groups + bus ---
    ~grpRec    = Group.new(s);
    ~grpVoice  = Group.after(~grpRec);
    ~grpDry    = Group.after(~grpVoice);
    ~grpMaster = Group.after(~grpDry);

    ~mixBus = Bus.audio(s, 2);

    // Continuously record guitar into capture buffer (DC.ar(0) = no hardware output)
    ~gRec = {
        var pos = Phasor.ar(0, 1, 0, BufFrames.kr(~gBuf.bufnum));
        BufWr.ar(SoundIn.ar(0), ~gBuf.bufnum, pos);
        DC.ar(0)
    }.play(~grpRec);

    ~rootMidi = 69;

    ~ffDetect = Synth(\armorikaDetect, [thresh: ~aCfg.thresh], ~grpRec);
    ~ffInput  = Synth(\armorikaResonator, [
        out: ~mixBus.index, amp: ~aCfg.resAmp,
        f0: (~rootMidi + 12 + ~aCfg.mode[0]).midicps,
        f1: (~rootMidi + 12 + ~aCfg.mode[1]).midicps,
        f2: (~rootMidi + 12 + ~aCfg.mode[2]).midicps,
        f3: (~rootMidi + 12 + ~aCfg.mode[3]).midicps,
        f4: (~rootMidi + 12 + ~aCfg.mode[4]).midicps,
        f5: (~rootMidi + 12 + ~aCfg.mode[5]).midicps,
        f6: (~rootMidi + 12 + ~aCfg.mode[6]).midicps,
    ], ~grpDry);
    ~ffRingMod = Synth(\armorikaRingMod, [
        out: ~mixBus.index, amp: ~aCfg.ringAmp,
        carrierFreq: ~rootMidi.midicps,
    ], ~grpDry);
    ~ffMaster = Synth(\armorikaMaster, [out: 0, in: ~mixBus.index,
        revMix: ~aCfg.revMix, revRoom: ~aCfg.revRoom], ~grpMaster);

    // --- Root pitch state ---
    ~lastTrig       = 0.0;
    ~streamsRunning = false;
    ~streams        = [];

    // --- Scale recognition ---
    ~defaultMode     = [0, 2, 3, 5, 7, 8, 10];  // natural minor
    ~knownScales     = [
        [0, 2, 4, 5, 7, 9, 11],  // major
        [0, 2, 3, 5, 7, 8, 10],  // natural minor
    ];
    ~pcHistory       = [];   // rolling unique-pitch-class evidence (last 10 notes)
    ~matchHistory    = [];   // last 4 detection results (nil or event)
    ~scaleRevertTask = nil;
    ~bedAmpMods      = Array.fill(7, 1.0);  // per-stream multiplier, live-writable

    ~updateResonator = {
        var r = ~aCfg.mode.collect { |i| (~rootMidi + 12 + i).midicps };
        ~ffInput.set(\f0, r[0], \f1, r[1], \f2, r[2], \f3, r[3],
                     \f4, r[4], \f5, r[5], \f6, r[6]);
        ~ffRingMod.set(\carrierFreq, ~rootMidi.midicps);
    };

    // Structure timeline — runs from first guitar note
    // Stream index → instrument: 0=organ 1=bass 2=string 3=flute 4=chime 5=brass 6=granGuitar
    ~startStructure = {
        Routine {
            // t=2min: harmonious passage 1 — Dorian (minor with sweet 6th)
            //   boost melodic voices, silence brass+chime, pull back ring mod
            120.wait;
            ~scaleRevertTask.isNil.not.if { ~scaleRevertTask.stop; ~scaleRevertTask = nil };
            ~aCfg.mode    = [0, 2, 3, 5, 7, 9, 10];  // Dorian
            ~bedAmpMods   = [1.5, 1.0, 1.5, 1.4, 0.05, 0.05, 0.6];
            ~aCfg.shadowAmp = 0.02;
            ~ffRingMod.set(\amp, 0.05);
            ~updateResonator.();
            "Structure: harmonious 1 (Dorian)".postln;

            // t=3min: back to natural minor, full texture
            60.wait;
            ~aCfg.mode    = ~defaultMode;
            ~bedAmpMods   = Array.fill(7, 1.0);
            ~aCfg.shadowAmp = 0.08;
            ~ffRingMod.set(\amp, ~aCfg.ringAmp);
            ~updateResonator.();
            "Structure: natural minor".postln;

            // t=4min: harmonious passage 2 — major (bright lift)
            60.wait;
            ~scaleRevertTask.isNil.not.if { ~scaleRevertTask.stop; ~scaleRevertTask = nil };
            ~aCfg.mode    = [0, 2, 4, 5, 7, 9, 11];  // major
            ~bedAmpMods   = [1.6, 1.0, 1.6, 1.5, 0.05, 0.05, 0.5];
            ~aCfg.shadowAmp = 0.02;
            ~ffRingMod.set(\amp, 0.05);
            ~updateResonator.();
            "Structure: harmonious 2 (major)".postln;

            // t=5min: stop streams, fade master over 20s
            60.wait;
            ~scaleRevertTask.isNil.not.if { ~scaleRevertTask.stop };
            ~streams.do { |r| r.stop };
            "Structure: fade out".postln;
            20.do { |i|
                ~ffMaster.set(\amp, 1.0 - ((i + 1) / 20.0));
                1.0.wait;
            };
        }.play(SystemClock);
    };

    // Check if a set of unique pitch classes fits a known scale — returns event or nil
    ~detectScale = { |uniquePCs|
        var found = nil;
        (0..11).do { |root|
            ~knownScales.do { |scale|
                if(found.isNil) {
                    var scalePCs = scale.collect { |i| (root + i) % 12 };
                    var mismatch = uniquePCs.detect { |pc| scalePCs.includes(pc).not };
                    if(mismatch.isNil) { found = (root: root, intervals: scale) };
                };
            };
        };
        found
    };

    // Bed stream routines — started on first guitar note
    ~streams = ~aCfg.streamDefs.collect { |def, streamIdx|
        var synthName = def[0];
        var octOff    = def[1];
        var stepMin   = def[2];
        var stepMax   = def[3];
        var restProb  = def[4];
        var amp       = def[5];
        var decMin    = def[6];
        var decMax    = def[7];
        var panRange  = def[8];
        var octVar    = def[9];
        var atkMin    = def[10];
        var atkMax    = def[11];

        Routine {
            loop {
                var step     = stepMin.rrand(stepMax);
                var decay    = decMin.rrand(decMax);
                var atk      = atkMin.rrand(atkMax);
                var accent   = 0.35.rrand(1.0);
                var interval = ~aCfg.mode.choose;
                var octShift = (octVar.neg..octVar).choose * 12;
                var noteMidi = (~rootMidi.mod(12) + 60) + octOff + interval + octShift;
                noteMidi = noteMidi.clip(28, 104);

                if(restProb.coin.not) {
                    Synth(synthName, [
                        out:    ~mixBus.index,
                        bufnum: ~gBuf.bufnum,
                        freq:   noteMidi.midicps,
                        amp:    amp * ~aCfg.bedAmp * accent * ~bedAmpMods[streamIdx],
                        atk:    atk,
                        pan:    panRange.neg.rrand(panRange),
                        decay:  decay,
                    ], ~grpVoice);
                };

                step.wait;
            };
        };
    };

    // --- Guitar note handler ---
    OSCdef(\armorikaNote, { |msg|
        var now  = SystemClock.seconds;
        var freq = msg[3];

        if((now - ~lastTrig) > ~aCfg.refractory) {
            var pc        = freq.cpsmidi.round(1).asInteger.mod(12);
            var uniquePCs = nil;
            var found     = nil;
            var stable    = false;

            ~lastTrig = now;

            // Build rolling pitch-class evidence (keep last 10, deduplicated)
            ~pcHistory = ([pc] ++ ~pcHistory).keep(10);
            uniquePCs  = ~pcHistory.asSet.asArray;

            // Only attempt detection once we have 5 distinct pitch classes
            if(uniquePCs.size >= 5) { found = ~detectScale.(uniquePCs) };

            // Require 4 consecutive detections on the same root before committing
            ~matchHistory = ([found] ++ ~matchHistory).keep(4);
            stable = (~matchHistory.size >= 4)
                && { ~matchHistory[0].notNil }
                && {
                    ~matchHistory.detect { |m|
                        m.isNil || { m[\root] != ~matchHistory[0][\root] }
                    }.isNil
                };

            if(stable) {
                var newRoot = ~matchHistory[0][\root] + 60;
                if(newRoot != ~rootMidi) {
                    ("Scale locked: root=" ++ ~matchHistory[0][\root]).postln;
                };
                ~aCfg.mode = ~matchHistory[0][\intervals];
                ~rootMidi  = newRoot;
                ~updateResonator.();
                ~scaleRevertTask.isNil.not.if { ~scaleRevertTask.stop };
                ~scaleRevertTask = Routine {
                    8.0.wait;
                    ~aCfg.mode = ~defaultMode;
                    ~updateResonator.();
                    "Reverted to natural minor.".postln;
                }.play(SystemClock);
            } {
                ~rootMidi = freq.cpsmidi.round(1).asInteger;
                ~updateResonator.();
            };

            if(~streamsRunning.not) {
                ~streamsRunning = true;
                ~streams.do { |r, i|
                    Routine { (i * 8).wait; r.play(TempoClock.default) }.play(SystemClock);
                };
                ~startStructure.();
                "Bed started.".postln;
            };

            Synth(\armorikaVoiceA, [
                out:   ~mixBus.index,
                freq:  freq,
                decay: 0.5.rrand(1.2),
                amp:   ~aCfg.shadowAmp,
                pan:   -0.2.rrand(0.2),
            ], ~grpVoice);
        };
    }, '/armorika/note');

    "Armorika ready — play to start the bed.".postln;
});
)

( // STOP
OSCdef(\armorikaNote).free;
~streams.do { |r| r.stop };
if(~scaleRevertTask.notNil) { ~scaleRevertTask.stop };
~gBuf.free;
~mixBus.free;
s.freeAll;
)
