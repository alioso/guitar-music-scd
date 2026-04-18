// ==============================================================
// ARMORIKA
// Generative Synclavier bed + guitar melody
// Inspired by Zappa / Civilization Phaze III
// ==============================================================

( // CONFIG
~aCfg = (
    thresh:      0.015,
    refractory:  0.09,
    blendAmp:    0.08,    // processed guitar blend (soft-saturated, not dry)
    bedAmp:      0.16,    // +30% from previous
    shadowAmp:   0.08,
    revMix:      0.3,
    revRoom:     0.88,

    // Lydian dominant — Zappa's characteristic mode
    mode: [0, 2, 4, 6, 7, 9, 10],

    // [synthName, octOff, stepMin, stepMax, restProb, amp, decMin, decMax, panRange, octVar]
    // octOff: semitones from root center for this stream's register
    // octVar: random ±N octave jumps (in units of 12 semitones) — 0 = fixed register
    streamDefs: [
        [\bedOrgan,  0,   0.60, 2.00, 0.25, 0.08, 2.0, 6.0, 0.4, 1],  // wide-ranging, the loved one
        [\bedBass,  -24,  0.40, 1.50, 0.15, 0.12, 1.0, 3.0, 0.2, 0],  // anchored low
        [\bedString,  0,  0.30, 0.80, 0.30, 0.07, 2.0, 5.0, 0.6, 0],  // mid, slow attack
        [\bedFlute,  12,  0.15, 0.35, 0.25, 0.07, 0.5, 1.5, 0.5, 0],  // mid-high, clean
        [\bedChime,  12,  0.10, 0.22, 0.35, 0.07, 0.3, 0.9, 0.7, 0],  // sparser, lower than before
        [\bedBrass,   0,  0.14, 0.28, 0.20, 0.09, 0.5, 1.2, 0.6, 0],  // mid, punchy
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

    // Additive sines, slow attack — organ/pipe character (KEEP AS-IS, loved)
    SynthDef(\bedOrgan, { |out=0, freq=440, amp=0.08, pan=0.0, decay=3.0|
        var sig = SinOsc.ar(freq)     * 0.50
                + SinOsc.ar(freq * 2) * 0.30
                + SinOsc.ar(freq * 3) * 0.15
                + SinOsc.ar(freq * 4) * 0.05;
        var env = EnvGen.kr(Env.perc(0.4, decay, curve: -2), doneAction: 2);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    // Sub-octave FM, warm — bass/cello register
    SynthDef(\bedBass, { |out=0, freq=440, amp=0.12, pan=0.0, decay=2.0|
        var mod = SinOsc.ar(freq * 0.5, 0, freq * 0.4);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.1, decay, curve: -2), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // Two detuned sines, slow attack — string section warmth
    SynthDef(\bedString, { |out=0, freq=440, amp=0.08, pan=0.0, decay=4.0|
        var sig = SinOsc.ar(freq)         * 0.60
                + SinOsc.ar(freq * 1.003) * 0.40;
        var env = EnvGen.kr(Env.perc(0.3, decay, curve: -2), doneAction: 2);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    // Low modIndex FM — flute/pipe breath character
    SynthDef(\bedFlute, { |out=0, freq=440, amp=0.08, pan=0.0, decay=1.2|
        var mod = SinOsc.ar(freq * 4.0, 0, freq * 0.12);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.06, decay, curve: -4), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // High FM bell — now mid register, sparser (was +24 dominant, now +12 accent)
    SynthDef(\bedChime, { |out=0, freq=440, amp=0.1, pan=0.0, decay=0.6|
        var mod = SinOsc.ar(freq * 3.5, 0, freq * 1.5);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.005, decay, curve: -5), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // High modIndex FM — brass/horn punch
    SynthDef(\bedBrass, { |out=0, freq=440, amp=0.1, pan=0.0, decay=0.9|
        var mod = SinOsc.ar(freq * 1.0, 0, freq * 2.5);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.08, decay, curve: -3), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // --- Guitar shadow (FM echo of each pluck) ---
    SynthDef(\armorikaVoiceA, { |out=0, freq=440, decay=0.6, amp=0.05, pan=0.0|
        var mod = SinOsc.ar(freq * 2.01, 0, freq * 0.5);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.04, decay, curve: -4), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // --- Processed guitar blend (soft saturation — not dry) ---
    SynthDef(\armorikaBlend, { |out=0, amp=0.08|
        var sig = SoundIn.ar(0);
        var sat = (sig * 2.5).tanh * amp;
        Out.ar(out, Pan2.ar(sat, 0));
    }).add;

    // --- Master: reverb + soft limit ---
    SynthDef(\armorikaMaster, { |out=0, in=0, revMix=0.3, revRoom=0.88|
        var sig = In.ar(in, 2);
        var wet = FreeVerb2.ar(sig[0], sig[1], mix: revMix, room: revRoom, damp: 0.4);
        Out.ar(out, Limiter.ar(wet, 0.95));
    }).add;

    s.sync;

    // --- Groups + bus ---
    ~grpRec    = Group.new(s);
    ~grpVoice  = Group.after(~grpRec);
    ~grpDry    = Group.after(~grpVoice);
    ~grpMaster = Group.after(~grpDry);

    ~mixBus = Bus.audio(s, 2);

    ~ffDetect = Synth(\armorikaDetect,  [thresh: ~aCfg.thresh], ~grpRec);
    ~ffBlend  = Synth(\armorikaBlend,   [out: ~mixBus.index, amp: ~aCfg.blendAmp], ~grpDry);
    ~ffMaster = Synth(\armorikaMaster,  [out: 0, in: ~mixBus.index,
        revMix: ~aCfg.revMix, revRoom: ~aCfg.revRoom], ~grpMaster);

    // --- Root pitch state ---
    ~rootMidi       = 69;
    ~lastTrig       = 0.0;
    ~streamsRunning = false;
    ~streams        = [];

    // Bed stream routines — started on first guitar note
    ~streams = ~aCfg.streamDefs.collect { |def|
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

        Routine {
            loop {
                var step     = stepMin.rrand(stepMax);
                var decay    = decMin.rrand(decMax);
                var interval = ~aCfg.mode.choose;
                var octShift = ((-octVar)..octVar).choose * 12;
                var noteMidi = (~rootMidi.mod(12) + 60) + octOff + interval + octShift;
                noteMidi = noteMidi.clip(28, 104);

                if(restProb.coin.not) {
                    Synth(synthName, [
                        out:   ~mixBus.index,
                        freq:  noteMidi.midicps,
                        amp:   amp * ~aCfg.bedAmp,
                        pan:   panRange.neg.rrand(panRange),
                        decay: decay,
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
            ~lastTrig = now;

            ~rootMidi = freq.cpsmidi.round(1).asInteger;

            if(~streamsRunning.not) {
                ~streamsRunning = true;
                ~streams.do { |r| r.play(TempoClock.default) };
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
~mixBus.free;
s.freeAll;
)
