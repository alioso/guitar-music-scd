/*
Vanilla
Granular sampler for 5 partners — SuperCollider 3.14.1

SETUP
  Input:  heavily processed guitar → Scarlett input 0 (mono)
          (never dry — processing happens externally before SC)
  Output: 8-channel multichannel (adjust ~numChans in BLOCK 1)

  P1–3   pre-recorded dry guitar files (samp_1/2/3.wav, any length)
         cascade in randomly over first 30s on first input detection
         cascade out randomly over last 30s (4:30–5:00)
         grain position, rate, and duration drift autonomously

  P4–5   live capture — input is already heavily processed
         P4 records min:00–:30, granulates from that snapshot
         P5 records min:30–1:00, granulates from that snapshot
         alternation repeats every 60s; snapshots refresh mid-flight
         (granulating a granulated signal is intentional — keep density low)

SAMPLE FILES
  Place in vanilla/samples/:
    samp_1.wav   samp_2.wav   samp_3.wav

STRUCTURE (~5 min from first note)
  t=0       first input detected → P1, P2, P3 cascade in (random within 30s)
            P4 begins first capture immediately
  t=0:30    P4 starts granulating; P5 begins first capture
  t=1:00    P5 starts granulating; P4 re-captures
  ...       alternation continues
  t=4:30    P1, P2, P3 cascade out (random within ~24s)
  t=5:00    P4, P5 fade out — piece ends

BLOCKS
  [1] Configuration   — evaluate once
  [2] Init            — evaluate after server boots
  [3] Arm             — evaluate when ready to perform
  [STOP]              — emergency stop
*/


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION
// ─────────────────────────────────────────────────────────────────────────────
(
~van = (
    inBus:        0,       // input channel (heavily processed guitar)
    thresh:       0.015,   // amplitude threshold to start the piece

    pieceDur:     300,     // 5 minutes in seconds
    outroStart:   270,     // 4:30 — P1–3 begin cascade out

    // Pan2 positions: -1 (left) to +1 (right)
    pans:         [-0.8, -0.4, 0.4, 0.8, 0.0],

    // Grain bounds — min floor of 0.08s prevents crackle artifacts
    // Rate drift in semitones — capped at ±2 keeps it musical not glitchy
    grainDurMin:  0.08,
    rateDriftMax: 2.0,

    fadeTimeP123: 6,       // seconds — asr envelope
    fadeTimeP45:  8,

    // Dry input + reverb (GVerb — requires sc3-plugins)
    dryAmp:       0.5,
    reverbMix:    0.75,    // mostly wet — the verb is the point
    reverbDecay:  7.0,     // seconds
    reverbDamp:   0.4,
    reverbSize:   1.8,     // room size multiplier (~50m)
);
s.options.numInputBusChannels = 1;
postln("Vanilla: config loaded.");
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — INIT
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot {
    var dir = thisProcess.nowExecutingPath.dirname;

    // Pre-recorded buffers — place samp_1/2/3.wav in vanilla/samples/
    ~vanBufs = [
        Buffer.read(s, dir +/+ "samples/samp_1.wav"),
        Buffer.read(s, dir +/+ "samples/samp_2.wav"),
        Buffer.read(s, dir +/+ "samples/samp_3.wav"),
    ];

    // Live capture buffers — 30s mono, one per P4/P5
    ~vanLiveBufs = 2.collect { Buffer.alloc(s, (s.sampleRate * 30).ceil, 1) };

    s.sync;

    // ── one granular voice, all parameters autonomously drifting ──────────────
    SynthDef(\van_grain, {
        arg buf=0, amp=0.5, gate=1,
            posRate=0.05, posDev=0.06,
            grainDur=0.12, grainDurDev=0.04,
            rateDrift=1.5,
            density=10, densityDev=3,
            panPos=0.0, fadeTime=6;

        var pos, rate, dur, trig, sig, env;

        // Position: slow wander (LFNoise1) + grain-level scatter (LFNoise2)
        // TGrains centerPos is in seconds, so multiply normalized 0-1 by buffer duration
        pos  = (LFNoise1.kr(posRate).range(0, 1)
               + LFNoise2.kr(1.5).bipolar(posDev)).clip(0, 1) * BufDur.kr(buf);

        // Rate: pitch drift ±rateDrift semitones, very slow
        rate = 2 ** (LFNoise1.kr(0.07).bipolar(rateDrift) / 12);

        // Duration: drifts above minimum floor (no crackle)
        dur  = (grainDur + LFNoise1.kr(0.18).range(0, grainDurDev))
               .max(~van.grainDurMin);

        // Density: drifts around center value
        trig = Impulse.kr((density + LFNoise1.kr(0.4).range(0, densityDev)).max(1));

        sig  = TGrains.ar(1, trig, buf, rate, pos, dur, 0, amp);
        env  = EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: 2);

        Out.ar(0, Pan2.ar(sig * env, panPos));
    }).add;

    // ── 30s mono recorder — fills buffer once (loop:0), stays alive until freed ─
    SynthDef(\van_rec, {
        arg inBus=0, buf=0;
        RecordBuf.ar(SoundIn.ar(inBus), buf, loop: 0, doneAction: 0);
    }).add;

    // ── amplitude detector — fires OSC on first signal above threshold ─────────
    SynthDef(\van_detect, {
        arg inBus=0, thresh=0.015;
        var amp = Amplitude.kr(SoundIn.ar(inBus), 0.01, 0.3);
        SendReply.kr(amp > thresh, '/vanilla/detected');
    }).add;

    s.sync;
    postln("Vanilla: ready — evaluate BLOCK 3 to arm.");
};
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — ARM
// ─────────────────────────────────────────────────────────────────────────────
(
~vanSynths     = Array.newClear(5);   // P1–P5 granular voices
~vanRec        = Array.newClear(2);   // P4/P5 recorders
~vanRunning    = false;
~vanRoutine    = nil;

~vanDetector   = Synth(\van_detect, [\inBus, ~van.inBus, \thresh, ~van.thresh]);

OSCdef(\van_start, { |msg|
    if(~vanRunning.not) {
        ~vanRunning = true;
        ~vanDetector.free;
        postln("Vanilla: input detected — piece begins.");

        ~vanRoutine = fork {

            // ── CASCADE P1–3 IN ─────────────────────────────────────────────
            // Each partner enters at a random time within the first 30s.
            3.do { |i|
                fork {
                    rrand(0.0, 30.0).wait;
                    postln("Vanilla: P% in".format(i + 1));
                    ~vanSynths[i] = Synth(\van_grain, [
                        \buf,         ~vanBufs[i],
                        \amp,         rrand(0.40, 0.55),
                        \posRate,     exprand(0.03, 0.08),
                        \posDev,      rrand(0.04, 0.10),
                        \grainDur,    rrand(0.08, 0.22),
                        \grainDurDev, rrand(0.03, 0.07),
                        \rateDrift,   rrand(0.5,  ~van.rateDriftMax),
                        \density,     rrand(6,    16).asInteger,
                        \densityDev,  rrand(2,    5).asInteger,
                        \panPos,      ~van.pans[i],
                        \fadeTime,    ~van.fadeTimeP123,
                    ]);
                };
            };

            // ── P4–P5 ALTERNATING CAPTURE ───────────────────────────────────
            // Each 60s cycle: P4 records first 30s, P5 records second 30s.
            // Recorders are freed after their window; granular synths persist
            // and read from the refreshed (overwritten) buffer next cycle.
            // When recording and granulating share the same buffer, new material
            // bleeds into live grains — the intended texture for P4/P5.
            fork {
                { ~vanRunning }.while {
                    // P4 window
                    ~vanRec[0] = Synth(\van_rec, [\inBus, ~van.inBus, \buf, ~vanLiveBufs[0]]);
                    postln("Vanilla: P4 recording...");
                    30.wait;
                    ~vanRec[0].free;
                    if(~vanSynths[3].isNil) {
                        ~vanSynths[3] = Synth(\van_grain, [
                            \buf,         ~vanLiveBufs[0],
                            \amp,         rrand(0.45, 0.60),
                            \posRate,     exprand(0.04, 0.10),
                            \posDev,      rrand(0.05, 0.12),
                            \grainDur,    rrand(0.10, 0.28),
                            \grainDurDev, rrand(0.04, 0.09),
                            \rateDrift,   rrand(1.0,  ~van.rateDriftMax),
                            \density,     rrand(8,    18).asInteger,
                            \densityDev,  rrand(2,    6).asInteger,
                            \panPos,      ~van.pans[3],
                            \fadeTime,    ~van.fadeTimeP45,
                        ]);
                        postln("Vanilla: P4 granulating.");
                    };

                    // P5 window
                    ~vanRec[1] = Synth(\van_rec, [\inBus, ~van.inBus, \buf, ~vanLiveBufs[1]]);
                    postln("Vanilla: P5 recording...");
                    30.wait;
                    ~vanRec[1].free;
                    if(~vanSynths[4].isNil) {
                        ~vanSynths[4] = Synth(\van_grain, [
                            \buf,         ~vanLiveBufs[1],
                            \amp,         rrand(0.45, 0.60),
                            \posRate,     exprand(0.04, 0.10),
                            \posDev,      rrand(0.05, 0.12),
                            \grainDur,    rrand(0.10, 0.28),
                            \grainDurDev, rrand(0.04, 0.09),
                            \rateDrift,   rrand(1.0,  ~van.rateDriftMax),
                            \density,     rrand(8,    18).asInteger,
                            \densityDev,  rrand(2,    6).asInteger,
                            \panPos,      ~van.pans[4],
                            \fadeTime,    ~van.fadeTimeP45,
                        ]);
                        postln("Vanilla: P5 granulating.");
                    };
                };
            };

            // ── CASCADE P1–3 OUT ────────────────────────────────────────────
            // Start at 4:30; each drops at a random time within the next ~24s,
            // leaving at least fadeTime before the hard end at 5:00.
            ~van.outroStart.wait;
            postln("Vanilla: cascading P1–3 out...");
            3.do { |i|
                fork {
                    rrand(0.0, 24.0).wait;
                    ~vanSynths[i] !? { |s| s.set(\gate, 0) };
                    postln("Vanilla: P% out".format(i + 1));
                };
            };

            // ── END ─────────────────────────────────────────────────────────
            30.wait;
            ~vanRunning = false;
            [3, 4].do { |i| ~vanSynths[i] !? { |s| s.set(\gate, 0) } };
            ~vanRec.do  { |r| r !? _.free };
            postln("Vanilla: ended.");
        };
    };
}, '/vanilla/detected', s.addr);

postln("Vanilla: armed — play to begin.");
)


// ─────────────────────────────────────────────────────────────────────────────
// STOP — emergency
// ─────────────────────────────────────────────────────────────────────────────
(
~vanRunning = false;
~vanRoutine  !? _.stop;
~vanSynths.do { |s| s !? { |x| x.set(\gate, 0) } };
~vanRec.do    { |s| s !? _.free };
~vanDetector  !? _.free;
OSCdef(\van_start).free;
postln("Vanilla: stopped.");
)
