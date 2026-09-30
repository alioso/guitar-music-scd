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
  ~1:30   6 distinct pitch classes played OR 90s elapsed → bed locks and rises.
  2:30    FEED 1 — play swells/harmonics. Bed nudges toward your pitches.
  3:00    MOTIVE MODE — play phrases. Companion echoes.
  5:30    FEED 2
  6:00    MOTIVE MODE
  8:00    FEED 3 / ending swell
  8:30    Fade — bed dissolves over 35s
  9:00    Silence

NOTES
  A "note" is a pitch held steady for ~0.3 s (stableFrames × 100 ms), so
  slides, vibrato and octave glitches from the tracker don't count.

BED (P1–P4 — the ocean)
  3 synthesized additive voices + 1 restless P4 voice, tuned from calibration:
  root = the pitch class you played most, plus the two most-played pitch
  classes that sit consonantly (3rds, 4ths, 5ths, 6ths) against the root and
  each other — fifth/octave fill in if there aren't enough.
  Harmonics breathe independently via LFNoise — never static, never sudden.
  Slow pitch drift. Separate long reverb bus. Self-sustaining: does not echo input.
  During feed windows only: each note you hold pulls the nearest bed voice
  toward it (Lag 45s).

COMPANION (the ghost guitarist)
  Granular cloud: live input written to a looping buffer, TGrains reads it back
  with wandering position, density (6–20 grains/s), grain duration, and pitch scatter.
  Pans around the stereo field independently.
  Short room reverb — textural rather than a straight echo.
  Starts when the bed locks. Completely autonomous: no phrase detection.
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
~ch = (
    // Timing (seconds from first note)
    totalDur:    540,    // 9 min
    calibDur:     90,    // calibration window
    calibNotes:    6,    // distinct pitch classes to lock bed
    stableFrames:  3,    // pitch frames (100 ms each) a note must hold to count
    bedRiseSecs:  55,    // bed amplitude fade-in duration
    bedFadeSecs:  35,    // bed fade-out duration at the end
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

    // Companion — granular cloud, self-contained
    // Starts when bed locks (not before — silent during calibration)
    companionAmp:     0.65,
    companionBufSecs: 8.0,

    threshold:     0.015,
);
"Chimera — config loaded".postln;
"  Calibration: % pitch classes in first % s | Fade at % s | End at % s".format(
    ~ch.calibNotes, ~ch.calibDur, ~ch.fadeSec, ~ch.totalDur).postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var ch = ~ch;

    // Private timeline clock — stopping it cancels everything this piece scheduled
    ch.tclock = TempoClock(1);

    // ── Helpers ───────────────────────────────────────────────────────────────

    ch.normalizeHz = { |hz|
        var h = hz;
        while({ h < 80  }, { h = h * 2 });
        while({ h >= 320 }, { h = h / 2 });
        h
    };

    // Root = most-played pitch class; then the most-played pitch classes that are
    // consonant (interval class 3, 4 or 5) with the root and with each other.
    // Voiced within the octave above a root in 110–220 Hz.
    ch.lockBedFreqs = { |notes|
        var counts = Dictionary.new;
        var sorted, rootPc, chosen, rootHz, ic;
        ic = { |a, b| var d = (a - b) % 12; min(d, 12 - d) };
        notes.do { |m| counts[m % 12] = (counts[m % 12] ? 0) + 1 };
        sorted = counts.keys.asArray.sort { |a, b| counts[a] > counts[b] };
        rootPc = sorted[0] ? 9;
        chosen = [];
        sorted.drop(1).do { |pc|
            if((chosen.size < 2) and: {
                ([rootPc] ++ chosen).every { |c| [3, 4, 5].includes(ic.(pc, c)) }
            }) { chosen = chosen.add(pc) };
        };
        rootHz = (45 + ((rootPc - 9) % 12)).midicps;   // A2 (110 Hz) … G#3 (208 Hz)
        [rootHz] ++ chosen.collect { |pc| rootHz * (2 ** (((pc - rootPc) % 12) / 12)) }
            ++ [rootHz * 1.5, rootHz * 2].drop(chosen.size)
    };

    // ── Buses ─────────────────────────────────────────────────────────────────
    ch.bedBus    = Bus.audio(s, 2);
    ch.motiveBus = Bus.audio(s, 2);
    ch.masterBus = Bus.audio(s, 2);

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Pitch detector — fires firstNote once; streams pitch for calibration/feed
    SynthDef(\chDetect, { |thresh=0.015|
        var sig, amp, pitch, freq, hasFreq, above, onset;
        sig     = SoundIn.ar(0);
        amp     = A2K.kr(Amplitude.ar(sig, attackTime: 0.005, releaseTime: 0.15));
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

    // Companion — granular cloud with its own short room, straight to the master.
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
        verb = GVerb.ar(cloud.sum * 0.5, roomsize: 35, revtime: 3.5, damping: 0.4, drylevel: 0);
        mix  = (cloud * 0.55) + (verb * 0.45);
        Out.ar(out, mix * Lag.kr(amp, 8.0));
    }).add;

    // Bus reverb (used twice: bed = long ambient room, motive = shorter room)
    SynthDef(\chVerb, {
        |busIn=0, out=0, mix=0.52, room=80, decay=6.5, damp=0.35|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry.sum * 0.5, roomsize: room,
            revtime: decay, damping: damp, drylevel: 0);
        Out.ar(out, (dry * (1 - mix)) + (verb * mix));
    }).add;

    // Master: bed + motive + companion → limiter → hardware out
    SynthDef(\chMaster, { |busIn=0, out=0|
        Out.ar(out, Limiter.ar(In.ar(busIn, 2), 0.95, 0.003));
    }).add;

    s.sync;

    // ── Companion buffer ──────────────────────────────────────────────────────
    ch.companionBuf = Buffer.alloc(s,
        (s.sampleRate * ch.companionBufSecs).ceil.asInteger, 1);

    s.sync;

    // ── Groups (all inside one root group — Block 3 frees only this piece) ────
    ch.grpRoot   = Group.new(s);
    ch.grpRec    = Group.head(ch.grpRoot);
    ch.grpBed    = Group.after(ch.grpRec);
    ch.grpMotive = Group.after(ch.grpBed);
    ch.grpVerb   = Group.after(ch.grpMotive);
    ch.grpComp   = Group.after(ch.grpVerb);   // companion: fully independent
    ch.grpMaster = Group.after(ch.grpComp);

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
        out:    ch.masterBus.index,
        amp:    0.0,
        bufnum: ch.companionBuf.bufnum,
    ], ch.grpComp);

    ch.bedVerbSyn = Synth(\chVerb, [
        busIn: ch.bedBus.index, out: ch.masterBus.index, room: 80,
        mix: ch.bedReverbMix, decay: ch.bedReverbDecay, damp: ch.bedReverbDamp,
    ], ch.grpVerb);
    ch.motiveVerbSyn = Synth(\chVerb, [
        busIn: ch.motiveBus.index, out: ch.masterBus.index, room: 40,
        mix: ch.motiveReverbMix, decay: ch.motiveReverbDecay, damp: ch.motiveReverbDamp,
    ], ch.grpVerb);
    ch.masterSyn = Synth(\chMaster, [busIn: ch.masterBus.index, out: 0], ch.grpMaster);

    // ── State ─────────────────────────────────────────────────────────────────
    ch.phase        = \waiting;
    ch.mode         = \motiveMode;
    ch.firstFired   = false;
    ch.calibDone    = false;
    ch.calibSamples = [];      // MIDI notes of stable notes played during calibration
    ch.bedFreqs     = [220, 330, 440];
    ch.lastSemi     = nil;     // note tracker: current pitch and how long it has held
    ch.semiFrames   = 0;

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
        ch.tclock.sched(40, {
            ch.bedSyns.do({ |syn| syn.set(\freqLag, ch.freqLag) });
            ch.p4BedSyn.set(\freqLag, 20);
            nil
        });
        // Companion wakes up now — 8s fade-in via Lag inside SynthDef
        ch.companionSyn.set(\amp, ch.companionAmp);
        { "BED LOCKED → % / % / % Hz".format(
            freqs[0].round(0.1), freqs[1].round(0.1), freqs[2].round(0.1)).postln;
          "COMPANION active — granular cloud (% s buffer)".format(
            ch.companionBufSecs).postln; }.defer;
    };

    ch.lockBed = {
        ch.calibDone = true;
        ch.phase     = \running;
        if(ch.calibSamples.size >= 1, {
            ch.bedFreqs = ch[\lockBedFreqs].(ch.calibSamples);
        });
        ch[\startBed].value;
    };

    // Called once per stable note (a pitch held for stableFrames)
    ch.onNote = { |midi|
        var hz, dists, nearestIdx, target;
        if((ch.phase == \calibrating) && ch.calibDone.not, {
            ch.calibSamples = ch.calibSamples.add(midi);
            if(ch.calibSamples.collect(_ % 12).asSet.size >= ch.calibNotes, {
                ch[\lockBed].value;
            });
        });

        // Feed: pull the bed voice closest to this pitch class onto it, in that voice's octave
        if(ch.mode == \feedMode, {
            hz = midi.midicps;
            target = ch.bedFreqs.collect { |b| hz * (2 ** (hz / b).log2.round.neg) };
            dists  = ch.bedFreqs.collect { |b, i| (target[i] / b).log2.abs };
            nearestIdx = dists.minIndex;
            ch.bedFreqs[nearestIdx] = target[nearestIdx];
            ch.bedSyns[nearestIdx].set(\freq, target[nearestIdx]);
        });
    };

    // Free everything this piece owns
    ch.cleanup = {
        OSCdef(\chFirstNote).free;
        OSCdef(\chPitch).free;
        ch.tclock.stop;
        ch.grpRoot.free;
        ch.bedBus.free;
        ch.motiveBus.free;
        ch.masterBus.free;
        ch.companionBuf.free;
    };

    // ── OSC handlers ──────────────────────────────────────────────────────────

    OSCdef(\chFirstNote, { |msg|
        if(ch.firstFired.not, {
            ch.firstFired = true;
            ch.phase      = \calibrating;
            { "CHIMERA — STARTED".postln;
              "CALIBRATING — hold % distinct pitch classes to define the bed".format(
                ch.calibNotes).postln; }.defer;

            // Auto-close calibration after calibDur even if not enough notes
            ch.tclock.sched(ch.calibDur, {
                if(ch.calibDone.not, { ch[\lockBed].value });
                nil;
            });

            // Feed windows
            ch.feedWindows.do({ |win, i|
                ch.tclock.sched(win[0], {
                    ch.mode = \feedMode;
                    { "FEED % — play swells/harmonics".format(i + 1).postln; }.defer;
                    nil;
                });
                ch.tclock.sched(win[1], {
                    ch.mode = \motiveMode;
                    { "MOTIVE MODE".postln; }.defer;
                    nil;
                });
            });

            // Fade and end
            ch.tclock.sched(ch.fadeSec, {
                ch.bedSyns.do({ |syn| syn.set(\ampLag, ch.bedFadeSecs, \amp, 0) });
                ch.p4BedSyn.set(\ampLag, ch.bedFadeSecs, \amp, 0);
                ch.companionSyn.set(\amp, 0);
                { "FADING...".postln; }.defer;
                nil;
            });
            ch.tclock.sched(ch.totalDur, {
                { "SILENCE — evaluate Block 3 to stop".postln; }.defer;
                nil;
            });

            OSCdef(\chFirstNote).free;
        });
    }, '/ch/firstNote');

    OSCdef(\chPitch, { |msg|
        var freq, hasFreq, amp, semi;
        freq    = msg[3];
        hasFreq = msg[4];
        amp     = msg[5];

        if((hasFreq > 0.5) && (amp > ch.threshold)
                && (freq > 50) && (freq < 3000), {
            semi = freq.cpsmidi.round.asInteger;
            if(semi == ch.lastSemi, {
                ch.semiFrames = ch.semiFrames + 1;
            }, {
                ch.lastSemi   = semi;
                ch.semiFrames = 1;
            });
            // Register the note exactly once, when it has held long enough
            if(ch.semiFrames == ch.stableFrames, { ch[\onNote].(semi) });
        }, {
            ch.lastSemi = nil;
        });
    }, '/ch/pitch');

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Chimera — running. Play guitar when ready.".postln;
    "  Calibration: % pitch classes in first % s".format(ch.calibNotes, ch.calibDur).postln;
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
~ch[\cleanup].value;
"Chimera — stopped.".postln;
)
