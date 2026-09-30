/*
Vanilla
Granular sampler for 5 partners — SuperCollider 3.14.1

SETUP
  Input:  heavily processed guitar → Scarlett input 0 (mono)
          (processing happens externally, before SC)
  Output: stereo output 0+1 (speakers)

  P1–3   pre-recorded dry guitar files (samp_1/2/3.wav, any length —
         the left channel is used, normalised on load)
         cascade in randomly over first 30s on first input detection
         cascade out randomly over last 30s (4:30–5:00)
         grain position, rate, and duration drift autonomously

  P4–5   live capture — input is already heavily processed
         P4 records min:00–:30, granulates from that snapshot
         P5 records min:30–1:00, granulates from that snapshot
         alternation repeats every 60s; snapshots refresh mid-flight
         (granulating a granulated signal is intentional — keep density low)

  Your live signal is only heard through a large, mostly-wet reverb.

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
  [STOP]              — stop (cancels everything, including pending entries)
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
~van = (
    inBus:        0,       // input channel (heavily processed guitar)
    thresh:       0.015,   // amplitude threshold to start the piece

    pieceDur:     300,     // 5 minutes in seconds
    outroStart:   270,     // 4:30 — P1–3 begin cascade out
    captureSecs:  30,      // P4/P5 capture window length

    sampleLevel:  0.5,     // P1–P3 source files are normalised to this peak on load

    // Pan2 positions: -1 (left) to +1 (right)
    pans:         [-0.8, -0.4, 0.4, 0.8, 0.0],

    // Grain bounds — min floor of 0.08s prevents crackle artifacts
    // Rate drift in semitones — capped at ±2 keeps it musical not glitchy
    grainDurMin:  0.08,
    rateDriftMax: 2.0,

    fadeTimeP123: 6,       // seconds — asr envelope
    fadeTimeP45:  8,

    // Dry input + reverb (GVerb, built-in)
    dryAmp:       0.5,
    reverbMix:    0.75,    // mostly wet — the verb is the point
    reverbDecay:  7.0,     // seconds
    reverbDamp:   0.4,
    reverbSize:   1.8,     // room size multiplier (~50m)
);
postln("Vanilla: config loaded.");
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — INIT
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot {
    var dir = thisProcess.nowExecutingPath.dirname;

    // Pre-recorded buffers — TGrains needs mono, so read the left channel only
    ~vanBufs = (1..3).collect { |i|
        Buffer.readChannel(s, dir +/+ "samples/samp_%.wav".format(i), channels: [0])
    };

    // Live capture buffers — mono, one per P4/P5
    ~vanLiveBufs = 2.collect { Buffer.alloc(s, (s.sampleRate * ~van.captureSecs).ceil, 1) };

    ~vanMixBus = Bus.audio(s, 2);

    s.sync;
    ~vanBufs.do { |b| b.normalize(~van.sampleLevel) };

    // ── one granular voice, all parameters autonomously drifting ──────────────
    SynthDef(\van_grain, {
        arg out=0, buf=0, amp=0.5, gate=1,
            posRate=0.05, posDev=0.06,
            grainDur=0.12, grainDurDev=0.04, grainDurMin=0.08,
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
        dur  = (grainDur + LFNoise1.kr(0.18).range(0, grainDurDev)).max(grainDurMin);

        // Density: drifts around center value
        trig = Impulse.kr((density + LFNoise1.kr(0.4).range(0, densityDev)).max(1));

        sig  = TGrains.ar(1, trig, buf, rate, pos, dur, 0, amp);
        env  = EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: 2);

        Out.ar(out, Pan2.ar(sig * env, panPos));
    }).add;

    // ── mono recorder — fills buffer once (loop:0), stays alive until freed ────
    SynthDef(\van_rec, {
        arg inBus=0, buf=0;
        RecordBuf.ar(SoundIn.ar(inBus), buf, loop: 0, doneAction: 0);
    }).add;

    // ── amplitude detector — fires OSC on first signal above threshold ─────────
    SynthDef(\van_detect, {
        arg inBus=0, thresh=0.015;
        var amp   = A2K.kr(Amplitude.ar(SoundIn.ar(inBus), 0.01, 0.3));
        var above = amp > thresh;
        var trig  = above * (1 - Delay1.kr(above));
        SendReply.kr(trig, '/vanilla/detected');
    }).add;

    // ── dry input + big reverb ────────────────────────────────────────────────
    SynthDef(\van_dry, {
        arg out=0, inBus=0, amp=0.5, reverbMix=0.75,
            reverbDecay=7.0, reverbDamp=0.4, reverbSize=1.8, gate=1;
        var sig  = SoundIn.ar(inBus) * amp;
        var room = (reverbSize * 28).clip(10, 300);
        var verb = GVerb.ar(sig, roomsize: room,
            revtime: reverbDecay, damping: reverbDamp, drylevel: 0);
        var wet  = Sanitize.ar(verb);
        var env  = EnvGen.kr(Env.asr(2, 1, 4), gate, doneAction: 2);
        Out.ar(out, ((sig ! 2) * (1 - reverbMix) + (wet * reverbMix)) * env);
    }).add;

    // ── master: everything → limiter → hardware out ───────────────────────────
    SynthDef(\van_master, { |busIn=0, out=0|
        Out.ar(out, Limiter.ar(In.ar(busIn, 2), 0.95, 0.003));
    }).add;

    s.sync;
    postln("Vanilla: ready — evaluate BLOCK 3 to arm.");
};
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — ARM
// ─────────────────────────────────────────────────────────────────────────────
(
var grain;

~vanSynths     = Array.newClear(5);   // P1–P5 granular voices
~vanRec        = Array.newClear(2);   // P4/P5 recorders
~vanDry        = nil;
~vanRunning    = false;
~vanClock      = TempoClock(1);       // stopping it cancels every pending entry/window

~vanGroup      = Group.new(s);
~vanGrains     = Group.head(~vanGroup);
~vanMaster     = Synth(\van_master, [\busIn, ~vanMixBus, \out, 0], ~vanGroup, \addToTail);
~vanDetector   = Synth(\van_detect, [\inBus, ~van.inBus, \thresh, ~van.thresh], ~vanGrains);

// One granular partner; `live` voices use the P4/P5 grain ranges
grain = { |i, buf, live|
    Synth(\van_grain, [
        \out,         ~vanMixBus,
        \buf,         buf,
        \amp,         if(live) { rrand(0.45, 0.60) } { rrand(0.40, 0.55) },
        \posRate,     if(live) { exprand(0.04, 0.10) } { exprand(0.03, 0.08) },
        \posDev,      if(live) { rrand(0.05, 0.12) } { rrand(0.04, 0.10) },
        \grainDur,    if(live) { rrand(0.10, 0.28) } { rrand(0.08, 0.22) },
        \grainDurDev, if(live) { rrand(0.04, 0.09) } { rrand(0.03, 0.07) },
        \grainDurMin, ~van.grainDurMin,
        \rateDrift,   rrand(if(live) { 1.0 } { 0.5 }, ~van.rateDriftMax),
        \density,     if(live) { rrand(8, 18) } { rrand(6, 16) },
        \densityDev,  if(live) { rrand(2, 6) } { rrand(2, 5) },
        \panPos,      ~van.pans[i],
        \fadeTime,    if(live) { ~van.fadeTimeP45 } { ~van.fadeTimeP123 },
    ], ~vanGrains);
};

OSCdef(\van_start, { |msg|
    if(~vanRunning.not) {
        ~vanRunning = true;
        ~vanDetector.free;
        postln("Vanilla: input detected — piece begins.");

        ~vanDry = Synth(\van_dry, [
            \out,         ~vanMixBus,
            \inBus,       ~van.inBus,
            \amp,         ~van.dryAmp,
            \reverbMix,   ~van.reverbMix,
            \reverbDecay, ~van.reverbDecay,
            \reverbDamp,  ~van.reverbDamp,
            \reverbSize,  ~van.reverbSize,
        ], ~vanGrains);

        // ── CASCADE P1–3 IN ─────────────────────────────────────────────────
        // Each partner enters at a random time within the first 30s.
        3.do { |i|
            ~vanClock.sched(rrand(0.0, 30.0), {
                postln("Vanilla: P% in".format(i + 1));
                ~vanSynths[i] = grain.(i, ~vanBufs[i], false);
                nil
            });
        };

        // ── P4–P5 ALTERNATING CAPTURE ───────────────────────────────────────
        // Each 60s cycle: P4 records first 30s, P5 records second 30s.
        // Recorders are freed after their window; granular synths persist
        // and read from the refreshed (overwritten) buffer next cycle.
        // When recording and granulating share the same buffer, new material
        // bleeds into live grains — the intended texture for P4/P5.
        Routine {
            var k = 0;
            loop {
                var p = k % 2;   // 0 = P4, 1 = P5
                ~vanRec[p] = Synth(\van_rec, [\inBus, ~van.inBus, \buf, ~vanLiveBufs[p]], ~vanGrains);
                postln("Vanilla: P% recording...".format(p + 4));
                ~van.captureSecs.wait;
                ~vanRec[p].free; ~vanRec[p] = nil;
                if(~vanSynths[p + 3].isNil) {
                    ~vanSynths[p + 3] = grain.(p + 3, ~vanLiveBufs[p], true);
                    postln("Vanilla: P% granulating.".format(p + 4));
                };
                k = k + 1;
            };
        }.play(~vanClock);

        // ── CASCADE P1–3 OUT ────────────────────────────────────────────────
        // Start at 4:30; each drops at a random time within the next ~24s,
        // leaving at least fadeTime before the hard end at 5:00.
        ~vanClock.sched(~van.outroStart, {
            postln("Vanilla: cascading P1–3 out...");
            3.do { |i|
                ~vanClock.sched(rrand(0.0, 24.0), {
                    ~vanSynths[i] !? { |s| s.set(\gate, 0) };
                    ~vanSynths[i] = nil;
                    postln("Vanilla: P% out".format(i + 1));
                    nil
                });
            };
            nil
        });

        // ── END ─────────────────────────────────────────────────────────────
        ~vanClock.sched(~van.pieceDur, {
            [3, 4].do { |i| ~vanSynths[i] !? { |s| s.set(\gate, 0) }; ~vanSynths[i] = nil };
            ~vanRec.do { |r, i| r !? { r.free; ~vanRec[i] = nil } };
            ~vanDry !? { |s| s.set(\gate, 0) }; ~vanDry = nil;
            postln("Vanilla: ended.");
            ~vanClock.clear;
            nil
        });
    };
}, '/vanilla/detected', s.addr);

postln("Vanilla: armed — play to begin.");
)


// ─────────────────────────────────────────────────────────────────────────────
// STOP
// ─────────────────────────────────────────────────────────────────────────────
(
~vanRunning = false;
~vanClock !? _.stop;
OSCdef(\van_start).free;
~vanGroup !? { |g|
    g.set(\gate, 0);                                     // voices + dry fade out
    AppClock.sched(~van.fadeTimeP45 + 0.5, { g.free; nil });
};
~vanSynths = Array.newClear(5);
~vanRec    = Array.newClear(2);
~vanDry    = nil;
postln("Vanilla: stopped.");
)
