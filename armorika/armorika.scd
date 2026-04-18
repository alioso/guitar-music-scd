// ==============================================================
// ARMORIKA
// Generative Synclavier bed + guitar melody
// Inspired by Zappa / Civilization Phaze III
// ==============================================================

( // CONFIG
~aCfg = (
    thresh:      0.015,
    refractory:  0.09,
    dryAmp:      0.2,
    bedAmp:      0.12,
    shadowAmp:   0.05,
    revMix:      0.3,
    revRoom:     0.88,

    // Lydian dominant — Zappa's characteristic mode
    mode: [0, 2, 4, 6, 7, 9, 10],

    // [synthName, octaveOffsetFromRoot, stepMin, stepMax, restProb, amp, decayMin, decayMax, panRange]
    // octaveOffset: semitones above rootMidi for this stream's register center
    streamDefs: [
        [\bedChime,  24,  0.10, 0.22, 0.20, 0.10, 0.30, 0.90, 0.7],
        [\bedReed,   12,  0.18, 0.38, 0.25, 0.08, 0.80, 2.00, 0.5],
        [\bedPad,   -12,  0.80, 2.50, 0.30, 0.06, 2.00, 5.00, 0.3],
        [\bedBrass,   0,  0.14, 0.28, 0.20, 0.09, 0.50, 1.20, 0.6],
        [\bedVibes,  19,  0.08, 0.25, 0.15, 0.08, 1.00, 3.00, 0.8],
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

    // High, fast, bright bell — passed between streams like hocketing fragments
    SynthDef(\bedChime, { |out=0, freq=440, amp=0.1, pan=0.0, decay=0.6|
        var mod = SinOsc.ar(freq * 3.5, 0, freq * 1.5);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.005, decay, curve: -5), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // Mid-high, reedy double-modulator FM — woodwind character
    SynthDef(\bedReed, { |out=0, freq=440, amp=0.1, pan=0.0, decay=1.5|
        var mod1 = SinOsc.ar(freq * 2.0, 0, freq * 0.7);
        var mod2 = SinOsc.ar(freq * 3.0, 0, freq * 0.3);
        var car  = SinOsc.ar(freq + mod1 + mod2);
        var env  = EnvGen.kr(Env.perc(0.02, decay, curve: -3), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // Low, additive, slow — harmonic foundation
    SynthDef(\bedPad, { |out=0, freq=440, amp=0.08, pan=0.0, decay=3.0|
        var sig = SinOsc.ar(freq)     * 0.50
                + SinOsc.ar(freq * 2) * 0.30
                + SinOsc.ar(freq * 3) * 0.15
                + SinOsc.ar(freq * 4) * 0.05;
        var env = EnvGen.kr(Env.perc(0.4, decay, curve: -2), doneAction: 2);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    // Mid, high modIndex FM — brass/horn character
    SynthDef(\bedBrass, { |out=0, freq=440, amp=0.1, pan=0.0, decay=0.9|
        var mod = SinOsc.ar(freq * 1.0, 0, freq * 2.5);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.08, decay, curve: -3), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // High-mid, metallic dual modulator — vibraphone/mallet character
    SynthDef(\bedVibes, { |out=0, freq=440, amp=0.08, pan=0.0, decay=2.0|
        var mod1 = SinOsc.ar(freq * 5.0, 0, freq * 0.8);
        var mod2 = SinOsc.ar(freq * 7.0, 0, freq * 0.3);
        var car  = SinOsc.ar(freq + mod1 + mod2);
        var env  = EnvGen.kr(Env.perc(0.005, decay, curve: -6), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // --- Guitar shadow (light FM triggered by each pluck) ---
    SynthDef(\armorikaVoiceA, { |out=0, freq=440, decay=0.6, amp=0.05, pan=0.0|
        var mod = SinOsc.ar(freq * 2.01, 0, freq * 0.5);
        var car = SinOsc.ar(freq + mod);
        var env = EnvGen.kr(Env.perc(0.04, decay, curve: -4), doneAction: 2);
        Out.ar(out, Pan2.ar(car * env * amp, pan));
    }).add;

    // --- Dry guitar ---
    SynthDef(\armorikaDry, { |out=0, amp=0.2|
        var sig = SoundIn.ar(0) * amp;
        Out.ar(out, Pan2.ar(sig, 0));
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

    ~ffDetect = Synth(\armorikaDetect, [thresh: ~aCfg.thresh], ~grpRec);
    ~ffDry    = Synth(\armorikaDry,    [out: ~mixBus.index, amp: ~aCfg.dryAmp], ~grpDry);
    ~ffMaster = Synth(\armorikaMaster, [out: 0, in: ~mixBus.index,
        revMix: ~aCfg.revMix, revRoom: ~aCfg.revRoom], ~grpMaster);

    // --- Root pitch state ---
    ~rootMidi       = 69;    // A4 default before guitar plays
    ~lastTrig       = 0.0;
    ~streamsRunning = false;
    ~streams        = [];

    // Bed stream routines — built here, started on first guitar note
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

        Routine {
            loop {
                var step     = stepMin.rrand(stepMax);
                var decay    = decMin.rrand(decMax);
                var interval = ~aCfg.mode.choose;
                // normalize guitar pitch to middle octave, then offset per stream
                var noteMidi = (~rootMidi.mod(12) + 60) + octOff + interval;
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

            // Update root — streams read this on their next step
            ~rootMidi = freq.cpsmidi.round(1).asInteger;

            // First note starts the bed
            if(~streamsRunning.not) {
                ~streamsRunning = true;
                ~streams.do { |r| r.play(TempoClock.default) };
                "Bed started.".postln;
            };

            // Light shadow on guitar note
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
