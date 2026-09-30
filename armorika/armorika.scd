/*
Armorika
Generative Synclavier bed + guitar melody
Inspired by Zappa / Civilization Phaze III
SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)

HARMONY
  The structure owns the MODE (natural minor → Dorian → natural minor → major).
  The guitar owns the ROOT: each detected note moves the key center to that
  note — unless your last notes all fit the current mode on one root (4 notes
  in a row, 5+ distinct pitch classes), in which case the key center locks to
  that root until your playing leaves it.

STRUCTURE (from first note)
  0:00  streams enter one by one, 8s apart (full ensemble at ~48s)
  2:00  Dorian — brass and chime pulled back; organ, string, flute boosted
  3:00  natural minor, full texture
  4:00  major — bright lift
  5:00  streams stop; master fades to silence over 20s
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
~arm = (
    thresh:      0.015,
    onsetSens:   0.4,     // spectral onset threshold — lower catches softer legato notes
    pitchDelay:  0.08,    // seconds after the attack before the pitch is read
    refractory:  0.09,
    resAmp:      0.28,    // resonator bank driven by guitar
    ringAmp:     0.20,    // ring-modulated dry guitar
    bedAmp:      0.42,    // bed is part of the piece, not background
    shadowAmp:   0.08,
    revMix:      0.32,
    revRoom:     0.88,

    // Structure (seconds from first note): Dorian, natural minor, major, fade
    passageTimes: [120, 180, 240, 300],
    fadeSecs:     20,
    streamGap:    8,       // seconds between stream entries

    // Structural modes
    minor:  [0, 2, 3, 5, 7, 8, 10],   // natural minor — default harmonic world
    dorian: [0, 2, 3, 5, 7, 9, 10],
    major:  [0, 2, 4, 5, 7, 9, 11],

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
"Armorika — config loaded".postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var arm = ~arm;

    // Private clock (seconds) — streams, structure and entries all run on it,
    // so stopping it cancels everything this piece has scheduled
    arm.tclock = TempoClock(1);

    // --- Detection: attack (spectral onset or rise from silence), then the pitch
    //     once it has settled, sent only when the tracker is confident ---
    SynthDef(\armorikaDetect, { |thresh=0.015, sens=0.4, pitchDelay=0.08|
        var in       = SoundIn.ar(0);
        var amp      = A2K.kr(Amplitude.ar(in, attackTime: 0.005, releaseTime: 0.1));
        var pitchArr = Pitch.kr(in, execFreq: 100, median: 7);
        var above    = Schmidt.kr(amp, thresh * 0.5, thresh);
        var rise     = above * (1 - Delay1.kr(above));
        var onset    = Onsets.kr(FFT(LocalBuf(512), in), sens, \rcomplex) * above;
        var hold     = Trig1.kr((rise + onset) > 0, 0.08);
        var trig     = TDelay.kr(hold * (1 - Delay1.kr(hold)), pitchDelay);
        SendReply.kr(trig * pitchArr[1], '/armorika/note', [pitchArr[0], amp]);
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

    // Granular guitar — TGrains from the last ~1s of live input, transposed so the
    // note you last played (srcFreq) sounds at this stream's pitch (freq)
    SynthDef(\bedGranGuitar, { |out=0, bufnum=0, posBus=0, freq=440, srcFreq=440,
        amp=0.08, decay=3.0, atk=0.4, pan=0|
        var rate = (freq / srcFreq).clip(0.25, 4);
        var dur  = BufDur.kr(bufnum);
        var pos  = ((In.kr(posBus) / BufSampleRate.kr(bufnum))
                    - LFNoise1.kr(0.3).range(0.15, 1.0)).wrap(0, dur);
        var sig  = TGrains.ar(2, Impulse.ar(12), bufnum, rate, pos, 0.12,
                              (LFNoise1.kr(0.5) * 0.3 + pan).clip2(1), amp);
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
        var ampEnv = A2K.kr(Amplitude.ar(in, 0.005, 0.6)).linlin(0, 0.2, 0, 1).clip(0, 1);
        Out.ar(out, spread * amp * ampEnv);
    }).add;

    // --- Ring-modulated guitar — carrier at root, slight saturation for body ---
    SynthDef(\armorikaRingMod, { |out=0, amp=0.20, carrierFreq=440|
        var in      = SoundIn.ar(0);
        var carrier = SinOsc.ar(carrierFreq);
        var ring    = (in * carrier * 3.0).tanh * 0.7;
        Out.ar(out, Pan2.ar(ring * Lag.kr(amp, 0.5), 0));
    }).add;

    // --- FM shadow on each pluck ---
    SynthDef(\armorikaVoiceA, { |out=0, freq=440, decay=0.6, amp=0.05, pan=0.0|
        var mod = SinOsc.ar(freq * 2.01, 0, freq * 0.5);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.04, decay, curve: -4), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // --- Continuous capture for the granular stream; publishes its write position ---
    SynthDef(\armorikaCapture, { |bufnum=0, posBus=0|
        var pos = Phasor.ar(0, 1, 0, BufFrames.kr(bufnum));
        BufWr.ar(SoundIn.ar(0), bufnum, pos);
        Out.kr(posBus, A2K.kr(pos));
    }).add;

    // --- Master: reverb + soft limit ---
    SynthDef(\armorikaMaster, { |out=0, in=0, revMix=0.32, revRoom=0.88, amp=1, fadeTime=1|
        var sig = In.ar(in, 2);
        var wet = FreeVerb2.ar(sig[0], sig[1], mix: revMix, room: revRoom, damp: 0.4);
        Out.ar(out, Limiter.ar(wet * Lag.kr(amp, fadeTime), 0.95));
    }).add;

    // Guitar capture buffer (8 seconds) + buses
    arm.gBuf   = Buffer.alloc(s, (s.sampleRate * 8).asInteger, 1);
    arm.mixBus = Bus.audio(s, 2);
    arm.posBus = Bus.control(s, 1);

    s.sync;

    // --- Groups (all inside one root group — Block 3 frees only this piece) ---
    arm.grpRoot   = Group.new(s);
    arm.grpRec    = Group.head(arm.grpRoot);
    arm.grpVoice  = Group.after(arm.grpRec);
    arm.grpDry    = Group.after(arm.grpVoice);
    arm.grpMaster = Group.after(arm.grpDry);

    // --- State ---
    arm.rootMidi   = 69;
    arm.srcFreq    = 440;      // last played pitch — the granular stream transposes from it
    arm.mode       = arm.minor;
    arm.bedAmpMods = Array.fill(7, 1.0);  // per-stream multiplier, set by the structure
    arm.lastTrig   = 0.0;
    arm.started    = false;
    arm.pcHistory  = [];   // last 10 pitch classes played
    arm.matchHistory = [];   // last 4 key-center detections (root or nil)

    arm.captureSyn = Synth(\armorikaCapture, [bufnum: arm.gBuf, posBus: arm.posBus], arm.grpRec);
    arm.detectSyn  = Synth(\armorikaDetect, [
        thresh: arm.thresh, sens: arm.onsetSens, pitchDelay: arm.pitchDelay,
    ], arm.grpRec, \addToTail);
    arm.resSyn = Synth(\armorikaResonator, [out: arm.mixBus.index, amp: arm.resAmp], arm.grpDry);
    arm.ringSyn = Synth(\armorikaRingMod, [out: arm.mixBus.index, amp: arm.ringAmp], arm.grpDry);
    arm.masterSyn = Synth(\armorikaMaster, [out: 0, in: arm.mixBus.index,
        revMix: arm.revMix, revRoom: arm.revRoom], arm.grpMaster);

    // Resonator + ring mod follow the current root and mode
    arm.updateResonator = {
        var r = arm.mode.collect { |i| (arm.rootMidi + 12 + i).midicps };
        arm.resSyn.set(\f0, r[0], \f1, r[1], \f2, r[2], \f3, r[3],
                       \f4, r[4], \f5, r[5], \f6, r[6]);
        arm.ringSyn.set(\carrierFreq, arm.rootMidi.midicps);
    };
    arm[\updateResonator].value;

    // Structural passage: mode + per-stream balance + guitar layer levels
    arm.setPassage = { |name, mode, mods, shadow, ring|
        arm.mode       = mode;
        arm.bedAmpMods = mods;
        arm.shadowNow  = shadow;
        arm.ringSyn.set(\amp, ring);
        arm.matchHistory = [];   // re-evaluate the key center against the new mode
        arm[\updateResonator].value;
        { "Structure: %".format(name).postln; }.defer;
    };
    arm.shadowNow = arm.shadowAmp;

    // Stream index → instrument: 0=organ 1=bass 2=string 3=flute 4=chime 5=brass 6=granGuitar
    arm.startStructure = {
        var t = arm.tclock, pt = arm.passageTimes;
        t.sched(pt[0], { arm[\setPassage].("harmonious 1 (Dorian)", arm.dorian,
            [1.5, 1.0, 1.5, 1.4, 0.05, 0.05, 0.6], 0.02, 0.05); nil });
        t.sched(pt[1], { arm[\setPassage].("natural minor", arm.minor,
            Array.fill(7, 1.0), arm.shadowAmp, arm.ringAmp); nil });
        t.sched(pt[2], { arm[\setPassage].("harmonious 2 (major)", arm.major,
            [1.6, 1.0, 1.6, 1.5, 0.05, 0.05, 0.5], 0.02, 0.05); nil });
        t.sched(pt[3], {
            arm.streams.do(_.stop);
            arm.masterSyn.set(\fadeTime, arm.fadeSecs, \amp, 0);
            { "Structure: fade out".postln; }.defer;
            nil
        });
        t.sched(pt[3] + arm.fadeSecs + 1, { { "Armorika — end. Evaluate Block 3 to clean up.".postln; }.defer; nil });
    };

    // Root that makes every recent pitch class fit the current mode (most-played
    // candidates first), or nil
    arm.findKeyCenter = { |pcs|
        var counts = Dictionary.new, order;
        pcs.do { |pc| counts[pc] = (counts[pc] ? 0) + 1 };
        order = counts.keys.asArray.sort { |a, b| counts[a] > counts[b] }
            ++ (0..11).reject { |r| counts[r].notNil };
        order.detect { |root|
            var scalePCs = arm.mode.collect { |i| (root + i) % 12 };
            pcs.every { |pc| scalePCs.includes(pc) }
        };
    };

    // Bed stream routines — started on first guitar note
    arm.streams = arm.streamDefs.collect { |def, streamIdx|
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
                var interval = arm.mode.choose;
                var octShift = (octVar.neg..octVar).choose * 12;
                var noteMidi = ((arm.rootMidi.mod(12) + 60) + octOff + interval + octShift).clip(28, 104);

                if(restProb.coin.not) {
                    Synth(synthName, [
                        out:     arm.mixBus.index,
                        bufnum:  arm.gBuf.bufnum,
                        posBus:  arm.posBus.index,
                        srcFreq: arm.srcFreq,
                        freq:    noteMidi.midicps,
                        amp:     amp * arm.bedAmp * 0.35.rrand(1.0) * arm.bedAmpMods[streamIdx],
                        atk:     atkMin.rrand(atkMax),
                        pan:     panRange.neg.rrand(panRange),
                        decay:   decMin.rrand(decMax),
                    ], arm.grpVoice);
                };

                step.wait;
            };
        };
    };

    // Free everything this piece owns
    arm.cleanup = {
        OSCdef(\armorikaNote).free;
        arm.tclock.stop;
        arm.grpRoot.free;
        arm.gBuf.free;
        arm.mixBus.free;
        arm.posBus.free;
    };

    // --- Guitar note handler ---
    OSCdef(\armorikaNote, { |msg|
        var now  = Main.elapsedTime;
        var freq = msg[3];
        var midi, uniquePCs, found, stable;

        if((now - arm.lastTrig) > arm.refractory) {
            arm.lastTrig = now;
            midi = freq.cpsmidi.round(1).asInteger;
            arm.srcFreq = freq;

            // Key center: locks when the last 4 detections agree on one root that
            // fits the current mode; otherwise it follows the note just played
            arm.pcHistory = ([midi % 12] ++ arm.pcHistory).keep(10);
            uniquePCs     = arm.pcHistory.asSet.asArray;
            found = if(uniquePCs.size >= 5) { arm[\findKeyCenter].(arm.pcHistory) } { nil };
            arm.matchHistory = ([found] ++ arm.matchHistory).keep(4);
            stable = (arm.matchHistory.size >= 4) && {
                arm.matchHistory[0].notNil and: {
                    arm.matchHistory.every { |m| m == arm.matchHistory[0] }
                }
            };

            if(stable) {
                if(arm.rootMidi != (found + 60)) {
                    { "Key center locked: %".format(found).postln; }.defer;
                };
                arm.rootMidi = found + 60;
            } {
                arm.rootMidi = midi;
            };
            arm[\updateResonator].value;

            if(arm.started.not) {
                arm.started = true;
                arm.streams.do { |r, i|
                    arm.tclock.sched(i * arm.streamGap, { r.play(arm.tclock); nil });
                };
                arm[\startStructure].value;
                { "Bed started.".postln; }.defer;
            };

            Synth(\armorikaVoiceA, [
                out:   arm.mixBus.index,
                freq:  freq,
                decay: 0.5.rrand(1.2),
                amp:   arm.shadowNow,
                pan:   -0.2.rrand(0.2),
            ], arm.grpVoice);
        };
    }, '/armorika/note');

    "Armorika ready — play to start the bed.".postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP
// ─────────────────────────────────────────────────────────────────────────────
(
~arm[\cleanup].value;
"Armorika — stopped.".postln;
)
