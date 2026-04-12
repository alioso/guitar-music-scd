/*
Chimera
Generative guitar — synthesized partner bed + live companion echo
SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)

  Server startup file:
    s.options.inDevice  = "Scarlett 2i2 USB";
    s.options.outDevice = "Scarlett 2i2 USB";

STRUCTURE (times from first note)
  0:00    First note → calibration. Post: CALIBRATING.
  ~1:30   6 unique pitches detected OR 90s elapsed → bed locks and rises.
  2:30    FEED 1 — play swells/harmonics. Bed nudges toward your pitches.
  3:00    MOTIVE MODE — play phrases. Companion echoes.
  5:30    FEED 2
  6:00    MOTIVE MODE
  8:00    FEED 3 / ending swell
  8:30    Fade — bed dissolves over 35s
  9:00    Silence

BED (P1–P4 — the ocean)
  3 synthesized additive voices + 1 restless P4 voice,
  frequencies locked from calibration pitches.
  Harmonics breathe independently via LFNoise — never static, never sudden.
  Slow pitch drift. Separate long reverb bus. Self-sustaining: does not echo input.
  During feed windows only: your pitches slowly nudge the bed (Lag 45s).

COMPANION (the ghost guitarist)
  Granular cloud: live input written to a looping buffer, TGrains reads it back
  with wandering position, density (6–20 grains/s), grain duration, and pitch scatter.
  Pans around the stereo field independently.
  Short room reverb — textural rather than a straight echo.
  Starts when the bed locks. Completely autonomous: no phrase detection.
*/


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION
// ─────────────────────────────────────────────────────────────────────────────
(
~ch = (
    // Timing (seconds from first note)
    totalDur:    540,    // 9 min
    calibDur:     90,    // calibration window
    calibNotes:    6,    // unique pitch classes to lock bed
    bedRiseSecs:  55,    // bed amplitude fade-in duration
    feedWindows: [[150, 180], [330, 360], [480, 510]],
    fadeSec:     510,    // fade at 8:30

    // Bed (P1–P3)
    bedAmp:          0.58,
    bedReverbMix:    0.52,
    bedReverbDecay:  6.5,
    bedReverbDamp:   0.35,
    freqLag:         45.0,   // pitch nudge transition time during feed

    // P4 bed voice (restless 4th bed voice)
    p4Amp:           0.38,

    // Motive bus — dry guitar
    dryAmp:             0.42,
    motiveReverbMix:    0.52,
    motiveReverbDecay:  4.0,
    motiveReverbDamp:   0.30,

    // Companion — granular cloud, self-contained, direct to hardware
    // Starts when bed locks (not before — silent during calibration)
    companionAmp:     0.65,
    companionBufSecs: 8.0,

    threshold:     0.015,
);
"Chimera — config loaded".postln;
"  Calibration: % pitches in first % s | Fade at % s | End at % s".format(
    ~ch.calibNotes, ~ch.calibDur, ~ch.fadeSec, ~ch.totalDur).postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var ch = ~ch;

    // ── Helpers ───────────────────────────────────────────────────────────────

    ch.normalizeHz = { |hz|
        var h = hz;
        while({ h < 80  }, { h = h * 2 });
        while({ h >= 320 }, { h = h / 2 });
        h
    };

    ch.lockBedFreqs = { |samples|
        var normSamples, buckets, sortedSemis, top3Hz, root;
        normSamples = samples.collect({ |hz| ch[\normalizeHz].(hz) });
        buckets     = Dictionary.new;
        normSamples.do({ |hz|
            var semi = ((hz / 440).log2 * 12).round(1).asInteger;
            buckets[semi] = (buckets[semi] ? 0) + 1;
        });
        sortedSemis = buckets.keys.asArray.sort({ |a, b| buckets[b] < buckets[a] });
        top3Hz      = sortedSemis.collect({ |s| ch[\normalizeHz].(440 * (2 ** (s / 12))) });
        root        = top3Hz[0] ? 220;
        [
            top3Hz[0] ? root,
            top3Hz[1] ? (root * 1.5),
            top3Hz[2] ? (root * 2.0),
        ]
    };

    // ── Buses ─────────────────────────────────────────────────────────────────
    ch.bedBus    = Bus.audio(s, 2);
    ch.motiveBus = Bus.audio(s, 2);

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Pitch detector — fires firstNote once; streams pitch for calibration/feed
    SynthDef(\chDetect, { |thresh=0.015|
        var sig, amp, pitch, freq, hasFreq, above, onset;
        sig     = SoundIn.ar(0);
        amp     = Amplitude.kr(sig, attackTime: 0.005, releaseTime: 0.15);
        pitch   = Pitch.kr(sig, ampThreshold: 0.015, median: 7);
        freq    = pitch[0];
        hasFreq = pitch[1];
        above   = amp > thresh;
        onset   = above * (1 - Delay1.kr(above));
        SendReply.kr(onset,          '/ch/firstNote', [amp]);
        SendReply.kr(Impulse.kr(10), '/ch/pitch',     [freq, hasFreq, amp]);
    }).add;

    // Bed voice — additive synthesis, harmonics breathe independently via LFNoise
    // active=0: slow, static. active=1: more motion + vibrato + wandering pan
    SynthDef(\chBed, {
        |out=0, freq=220, amp=0.0, ampLag=35, freqLag=45,
         breathRate=0.07, breathPhase=0.0, pan=0.0,
         active=0, panMove=0, chorus=0|
        var fSmooth, drift, vibrato, f, fChorus;
        var h1, h2, h3, h4, h5, sub, sig, breath, ampSmooth, panSig;
        fSmooth = Lag.kr(freq, freqLag);
        fChorus = fSmooth * (1 + (chorus * LFNoise1.kr(0.008).range(-0.003, 0.003)));
        drift   = LFNoise1.kr(0.015).range(-0.002, 0.002)
                + (active * LFNoise1.kr(0.05).range(-0.005, 0.005));
        vibrato = active * SinOsc.kr(LFNoise1.kr(0.025).range(3.2, 5.8)) * 0.0025;
        f       = fChorus * (1 + drift + vibrato);
        h1  = SinOsc.ar(f)       * LFNoise1.kr(0.04 + (active * 0.07)).range(0.55, 1.0);
        h2  = SinOsc.ar(f * 2)   * LFNoise1.kr(0.03 + (active * 0.08)).range(0.10, 0.65) * 0.45;
        h3  = SinOsc.ar(f * 3)   * LFNoise1.kr(0.05 + (active * 0.09)).range(0.00, 0.45 + (active * 0.30)) * 0.22;
        h4  = SinOsc.ar(f * 5)   * (active * LFNoise1.kr(0.018).range(0.0, 0.28)) * 0.14;
        sub = SinOsc.ar(f * 0.5) * LFNoise1.kr(0.02 + (active * 0.03)).range(0.18, 0.72) * 0.38;
        sig = (h1 + h2 + h3 + h4 + sub) * 0.34;
        sig = (sig * 2.2).tanh * 0.52;
        sig = LPF.ar(sig, f * 7);
        breath    = SinOsc.kr(breathRate, breathPhase).linlin(-1, 1, 0.15, 1.0);
        ampSmooth = Lag.kr(amp, ampLag);
        panSig    = pan + (panMove * LFNoise1.kr(0.035).range(-0.60, 0.60));
        Out.ar(out, Pan2.ar(sig * breath * ampSmooth, panSig));
    }).add;

    // P4 bed voice — persistent, more restless than the static bed voices
    SynthDef(\chP4Bed, {
        |out=0, freq=220, amp=0.0, ampLag=18, freqLag=20|
        var fSmooth, f, drift, vibrato;
        var h1, h2, h3, sub, sig, breath, ampSmooth, pan;
        fSmooth  = Lag.kr(freq, freqLag);
        drift    = LFNoise1.kr(0.08).range(-0.007, 0.007);
        vibrato  = SinOsc.kr(LFNoise1.kr(0.05).range(3.0, 7.0)) * 0.004;
        f        = fSmooth * (1 + drift + vibrato);
        h1       = SinOsc.ar(f)       * LFNoise1.kr(0.14).range(0.30, 1.0);
        h2       = SinOsc.ar(f * 2)   * LFNoise1.kr(0.11).range(0.00, 0.80) * 0.50;
        h3       = SinOsc.ar(f * 3)   * LFNoise1.kr(0.09).range(0.00, 0.55) * 0.28;
        sub      = SinOsc.ar(f * 0.5) * LFNoise1.kr(0.06).range(0.10, 0.75) * 0.42;
        sig      = (h1 + h2 + h3 + sub) * 0.32;
        sig      = (sig * 2.4).tanh * 0.50;
        sig      = LPF.ar(sig, f * 7);
        breath   = SinOsc.kr(1/7, LFNoise0.kr(0.02).range(0, 2pi)).linlin(-1, 1, 0.05, 1.0);
        pan      = LFNoise1.kr(0.025).range(-0.90, 0.90);
        ampSmooth = Lag.kr(amp, ampLag);
        Out.ar(out, Pan2.ar(sig * breath * ampSmooth, pan));
    }).add;

    // Dry guitar → motive bus
    SynthDef(\chDry, { |out=0, amp=0.42|
        Out.ar(out, (SoundIn.ar(0) * amp).dup);
    }).add;

    // Companion — granular cloud, outputs directly to hardware (not through buses).
    // Starts silent (amp=0); activated from startBed when the piece is running.
    // BufWr records live input; TGrains reads it back as a scattered cloud.
    SynthDef(\chCompanion, {
        |out=0, amp=0.0, bufnum=0|
        var sig, density, grainDur, rate, pos, grainPan, cloud, verb, mix;
        sig = SoundIn.ar(0);
        // Write live guitar continuously into the buffer
        BufWr.ar(sig, bufnum, Phasor.ar(0, BufRateScale.kr(bufnum), 0, BufFrames.kr(bufnum)));
        // Granular readout — all parameters wander slowly and independently
        density  = LFNoise1.kr(0.07).range(6, 20);
        grainDur = LFNoise1.kr(0.04).range(0.06, 0.40);
        rate     = LFNoise1.kr(0.02).range(0.92, 1.08);
        pos      = LFNoise1.kr(0.02).range(0.05, 0.95) * BufDur.kr(bufnum);
        grainPan = LFNoise1.kr(0.035).range(-0.85, 0.85);
        cloud = TGrains.ar(2,
            trigger:   Impulse.ar(density),
            bufnum:    bufnum,
            rate:      rate,
            centerPos: pos,
            dur:       grainDur,
            pan:       grainPan,
            amp:       0.15,
            interp:    2
        );
        verb = GVerb.ar(cloud[0], roomsize: 35, revtime: 3.5, damping: 0.4, drylevel: 0);
        mix  = (cloud * 0.55) + ([verb[0], verb[1]] * 0.45);
        Out.ar(out, (mix * Lag.kr(amp, 8.0)).clip2(1.0));
    }).add;

    // Bed reverb: bed bus → GVerb → hardware out (long, ambient)
    SynthDef(\chBedVerb, {
        |busIn=0, out=0, mix=0.52, decay=6.5, damp=0.35|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry[0], roomsize: 80,
            revtime: decay, damping: damp, drylevel: 0);
        var wet  = [verb[0], verb[1]];
        Out.ar(out, ((dry * (1 - mix)) + (wet * mix)).clip2(1.0));
    }).add;

    // Motive reverb: motive bus (dry guitar) → GVerb → hardware out
    SynthDef(\chMotiveVerb, {
        |busIn=0, out=0, mix=0.52, decay=4.0, damp=0.30|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry[0], roomsize: 40,
            revtime: decay, damping: damp, drylevel: 0);
        var wet  = [verb[0], verb[1]];
        Out.ar(out, ((dry * (1 - mix)) + (wet * mix)).clip2(1.0));
    }).add;

    s.sync;

    // ── Companion buffer ──────────────────────────────────────────────────────
    ch.companionBuf = Buffer.alloc(s,
        (s.sampleRate * ch.companionBufSecs).ceil.asInteger, 1);

    s.sync;

    // ── Groups ────────────────────────────────────────────────────────────────
    ch.grpRec    = Group.new(s);
    ch.grpBed    = Group.after(ch.grpRec);
    ch.grpMotive = Group.after(ch.grpBed);
    ch.grpVerb   = Group.after(ch.grpMotive);
    ch.grpComp   = Group.after(ch.grpVerb);   // companion: fully independent

    // ── Synths ────────────────────────────────────────────────────────────────
    ch.detectSyn = Synth(\chDetect, [thresh: ch.threshold], ch.grpRec);

    // Bed voices — silent until calibration locks
    ch.bedSyns = [
        Synth(\chBed, [out: ch.bedBus.index, amp: 0,
            breathRate: 1/13, breathPhase: 0.00, pan: -0.88,
            active: 0, panMove: 0, chorus: 1,
            ampLag: ch.bedRiseSecs, freqLag: ch.freqLag], ch.grpBed),
        Synth(\chBed, [out: ch.bedBus.index, amp: 0,
            breathRate: 1/17, breathPhase: 2.09, pan:  0.88,
            active: 0, panMove: 0, chorus: 1,
            ampLag: ch.bedRiseSecs, freqLag: ch.freqLag], ch.grpBed),
        Synth(\chBed, [out: ch.bedBus.index, amp: 0,
            breathRate: 1/19, breathPhase: 4.19, pan:  0.00,
            active: 1, panMove: 1, chorus: 0,
            ampLag: ch.bedRiseSecs, freqLag: ch.freqLag], ch.grpBed),
    ];
    ch.p4BedSyn = Synth(\chP4Bed, [out: ch.bedBus.index, amp: 0], ch.grpBed);

    ch.drySyn = Synth(\chDry, [out: ch.motiveBus.index, amp: ch.dryAmp], ch.grpMotive);

    // Companion starts SILENT — activated by startBed when bed locks
    ch.companionSyn = Synth(\chCompanion, [
        out:    0,
        amp:    0.0,
        bufnum: ch.companionBuf.bufnum,
    ], ch.grpComp);

    ch.bedVerbSyn = Synth(\chBedVerb, [
        busIn: ch.bedBus.index, out: 0,
        mix: ch.bedReverbMix, decay: ch.bedReverbDecay, damp: ch.bedReverbDamp,
    ], ch.grpVerb);
    ch.motiveVerbSyn = Synth(\chMotiveVerb, [
        busIn: ch.motiveBus.index, out: 0,
        mix: ch.motiveReverbMix, decay: ch.motiveReverbDecay, damp: ch.motiveReverbDamp,
    ], ch.grpVerb);

    // ── State ─────────────────────────────────────────────────────────────────
    ch.phase        = \waiting;
    ch.mode         = \motiveMode;
    ch.firstFired   = false;
    ch.calibDone    = false;
    ch.calibSamples = [];
    ch.bedFreqs     = [220, 330, 440];

    // ── startBed ─────────────────────────────────────────────────────────────
    ch.startBed = {
        var freqs = ch.bedFreqs;
        // Step 1: snap to correct pitches while still silent (freqLag → 0, amp still 0)
        // This prevents the dissonant pitch-glide from 220 Hz being audible during fade-in
        ch.bedSyns[0].set(\freq, freqs[0], \freqLag, 0.0);
        ch.bedSyns[1].set(\freq, freqs[1], \freqLag, 0.0);
        ch.bedSyns[2].set(\freq, freqs[2], \freqLag, 0.0);
        ch.p4BedSyn.set(\freq, freqs[1] * 1.01, \freqLag, 0.0);
        // Step 2: start amplitude rise — bed blooms on the correct pitches
        ch.bedSyns[0].set(\amp, ch.bedAmp);
        ch.bedSyns[1].set(\amp, ch.bedAmp);
        ch.bedSyns[2].set(\amp, ch.bedAmp);
        ch.p4BedSyn.set(\amp, ch.p4Amp);
        // Step 3: restore freqLag ~40s from now, before first feed window (~60s away)
        SystemClock.sched(40, {
            if(ch.alive, {
                ch.bedSyns.do({ |syn| syn.set(\freqLag, ch.freqLag) });
                ch.p4BedSyn.set(\freqLag, 20);
            });
            nil
        });
        // Companion wakes up now — 8s fade-in via Lag inside SynthDef
        ch.companionSyn.set(\amp, ch.companionAmp);
        "BED LOCKED → % / % / % Hz".format(
            freqs[0].round(0.1), freqs[1].round(0.1), freqs[2].round(0.1)).postln;
        "COMPANION active — granular cloud (% s buffer)".format(
            ch.companionBufSecs).postln;
    };

    // ── OSC handlers ──────────────────────────────────────────────────────────

    OSCdef(\chFirstNote, { |msg|
        if(ch.firstFired.not, {
            ch.firstFired = true;
            ch.phase      = \calibrating;
            "CHIMERA — STARTED".postln;
            "CALIBRATING — play % distinct harmonics to define the bed".format(
                ch.calibNotes).postln;

            // Auto-close calibration after calibDur even if not enough notes
            SystemClock.sched(ch.calibDur, {
                if(ch.alive && ch.calibDone.not, {
                    ch.calibDone = true;
                    ch.phase     = \running;
                    if(ch.calibSamples.size >= 3, {
                        ch.bedFreqs = ch[\lockBedFreqs].(ch.calibSamples);
                    });
                    ch[\startBed].value;
                });
                nil;
            });

            // Feed windows
            ch.feedWindows.do({ |win, i|
                SystemClock.sched(win[0], {
                    if(ch.alive, {
                        ch.mode = \feedMode;
                        "FEED % — play swells/harmonics".format(i + 1).postln;
                    });
                    nil;
                });
                SystemClock.sched(win[1], {
                    if(ch.alive, {
                        ch.mode = \motiveMode;
                        "MOTIVE MODE".postln;
                    });
                    nil;
                });
            });

            // Fade and end
            SystemClock.sched(ch.fadeSec, {
                if(ch.alive, {
                    ch.bedSyns.do({ |syn| syn.set(\amp, 0) });
                    ch.p4BedSyn.set(\amp, 0);
                    ch.companionSyn.set(\amp, 0);
                    "FADING...".postln;
                });
                nil;
            });
            SystemClock.sched(ch.totalDur, {
                if(ch.alive, {
                    "SILENCE — evaluate Block 3 to stop".postln;
                });
                nil;
            });

            OSCdef(\chFirstNote).free;
        });
    }, '/ch/firstNote');

    OSCdef(\chPitch, { |msg|
        var freq, hasFreq, amp, normHz, dists, nearestIdx, uniquePCs;
        freq    = msg[3];
        hasFreq = msg[4];
        amp     = msg[5];

        if((hasFreq > 0.5) && (amp > ch.threshold)
                && (freq > 50) && (freq < 3000), {

            if((ch.phase == \calibrating) && ch.calibDone.not, {
                ch.calibSamples = ch.calibSamples.add(freq);
                uniquePCs = ch.calibSamples.collect({ |hz|
                    var h = ch[\normalizeHz].(hz);
                    ((h / 440).log2 * 12).round(1).asInteger
                }).asSet.size;
                if(uniquePCs >= ch.calibNotes, {
                    ch.calibDone = true;
                    ch.phase     = \running;
                    ch.bedFreqs  = ch[\lockBedFreqs].(ch.calibSamples);
                    ch[\startBed].value;
                });
            });

            if(ch.mode == \feedMode, {
                normHz     = ch[\normalizeHz].(freq);
                dists      = ch.bedFreqs.collect({ |bHz| (normHz - bHz).abs });
                nearestIdx = dists.minIndex;
                ch.bedFreqs[nearestIdx] = normHz;
                ch.bedSyns[nearestIdx].set(\freq, normHz);
            });
        });
    }, '/ch/pitch');

    ch.alive = true;

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Chimera — running. Play guitar when ready.".postln;
    "  Calibration: % harmonics in first % s".format(ch.calibNotes, ch.calibDur).postln;
    "  Feed windows: 2:30–3:00 | 5:30–6:00 | 8:00–8:30".postln;
    "  Companion: granular cloud (% s buffer), starts when bed locks".format(
        ch.companionBufSecs).postln;
    "  Fade at 8:30 | Silence at 9:00".postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP
// ─────────────────────────────────────────────────────────────────────────────
(
~ch.alive = false;
OSCdef(\chFirstNote).free;
OSCdef(\chPitch).free;
~ch.bedBus.free;
~ch.motiveBus.free;
~ch.companionBuf.free;
s.freeAll;
"Chimera — stopped.".postln;
)
