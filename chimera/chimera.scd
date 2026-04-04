/*
Chimera
Generative guitar — synthesized partner bed + motive echo partner
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
  3:00    MOTIVE MODE — play phrases. P4 responds.
  5:30    FEED 2
  6:00    MOTIVE MODE
  8:00    FEED 3 / ending swell
  8:30    Fade — bed dissolves over 35s
  9:00    Silence

BED (P1–P3 — the ocean)
  3 synthesized additive voices, frequencies locked from calibration pitches.
  Harmonics breathe independently via LFNoise — never static, never sudden.
  Slow pitch drift. Separate long reverb bus. Self-sustaining: does not echo input.
  During feed windows only: your pitches slowly nudge the bed (Lag 45s).

MOTIVE PARTNER (P4)
  Only active in motive mode. Captures notes shorter than 3s.
  When phrase ends (2s silence): plays 1–all notes, randomly delayed 0–4s or 20–60s.
  Routed through same reverb bus as dry guitar (more present, shorter tail).
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
    bedRiseSecs:  35,    // bed amplitude fade-in duration
    feedWindows: [[150, 180], [330, 360], [480, 510]],
    fadeSec:     510,    // fade at 8:30

    // Bed (P1–P3)
    bedAmp:          0.44,   // per voice at full
    bedReverbMix:    0.52,
    bedReverbDecay:  6.5,
    bedReverbDamp:   0.35,
    freqLag:         45.0,   // pitch nudge transition time during feed

    // Motive bus — dry guitar + P4
    dryAmp:             0.42,
    p4Amp:              0.34,
    motiveReverbMix:    0.52,
    motiveReverbDecay:  4.0,
    motiveReverbDamp:   0.30,

    // P4 response
    motiveMaxDur:  3.0,  // notes longer than this ignored by P4
    phraseEndGap:  2.0,  // silence gap to trigger phrase response
    noteBufDur:    4.0,  // max capture duration per note buffer
    noteBufCount:  4,    // round-robin note buffers

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

    // Normalize Hz into 80–320 Hz (bass/mid range for bed voices)
    ch.normalizeHz = { |hz|
        var h = hz;
        while({ h < 80  }, { h = h * 2 });
        while({ h >= 320 }, { h = h / 2 });
        h
    };

    // Pick top 3 pitch-class buckets from calibration samples → 3 bed Hz values
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

    // ── Buffers & buses ───────────────────────────────────────────────────────
    ch.bedBus    = Bus.audio(s, 2);
    ch.motiveBus = Bus.audio(s, 2);
    ch.noteBufs  = Array.fill(ch.noteBufCount, {
        Buffer.alloc(s, (s.sampleRate * ch.noteBufDur).ceil.asInteger, 1)
    });

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Onset / release / continuous pitch detector
    SynthDef(\chDetect, { |thresh=0.015|
        var sig, amp, pitch, freq, hasFreq, above, onset, release;
        sig     = SoundIn.ar(0);
        amp     = Amplitude.kr(sig, attackTime: 0.005, releaseTime: 0.15);
        pitch   = Pitch.kr(sig, ampThreshold: 0.015, median: 7);
        freq    = pitch[0];
        hasFreq = pitch[1];
        above   = amp > thresh;
        onset   = above * (1 - Delay1.kr(above));
        release = (1 - above) * Delay1.kr(above);
        SendReply.kr(onset,          '/ch/firstNote', [amp]);
        SendReply.kr(onset,          '/ch/onset',     [amp, freq, hasFreq]);
        SendReply.kr(release,        '/ch/release',   [amp]);
        SendReply.kr(Impulse.kr(10), '/ch/pitch',     [freq, hasFreq, amp]);
    }).add;

    // Bed voice — additive synthesis, harmonics breathe independently via LFNoise
    // active=0: slow, static character. active=1: more harmonic movement + vibrato + wandering pan
    SynthDef(\chBed, {
        |out=0, freq=220, amp=0.0, ampLag=35, freqLag=45,
         breathRate=0.07, breathPhase=0.0, pan=0.0,
         active=0, panMove=0|
        var fSmooth, drift, vibrato, f, h1, h2, h3, sub, sig, breath, ampSmooth, panSig;
        fSmooth   = Lag.kr(freq, freqLag);
        // Active voice: wider drift + slow vibrato for life
        drift     = LFNoise1.kr(0.015).range(-0.002, 0.002)
                  + (active * LFNoise1.kr(0.06).range(-0.004, 0.004));
        vibrato   = active * SinOsc.kr(LFNoise1.kr(0.03).range(3.5, 6.5)) * 0.003;
        f         = fSmooth * (1 + drift + vibrato);
        // Active voice: harmonics move faster and reach higher amplitudes
        h1   = SinOsc.ar(f)       * LFNoise1.kr(0.04 + (active * 0.08)).range(0.40, 1.0);
        h2   = SinOsc.ar(f * 2)   * LFNoise1.kr(0.03 + (active * 0.09)).range(0.00, 0.60 + (active * 0.25)) * 0.42;
        h3   = SinOsc.ar(f * 3)   * LFNoise1.kr(0.05 + (active * 0.10)).range(0.00, 0.35 + (active * 0.30)) * 0.20;
        sub  = SinOsc.ar(f * 0.5) * LFNoise1.kr(0.02 + (active * 0.04)).range(0.08, 0.65) * 0.32;
        sig  = (h1 + h2 + h3 + sub) * 0.28;
        sig  = (sig * 1.8).tanh * 0.55;
        sig  = LPF.ar(sig, f * 6);
        breath    = SinOsc.kr(breathRate, breathPhase).linlin(-1, 1, 0.12, 1.0);
        ampSmooth = Lag.kr(amp, ampLag);
        // panMove=1: slow wandering pan over ~25s cycle
        panSig    = pan + (panMove * LFNoise1.kr(0.04).range(-0.55, 0.55));
        Out.ar(out, Pan2.ar(sig * breath * ampSmooth, panSig));
    }).add;

    // Records one note into a buffer (fills once then doneAction:2)
    SynthDef(\chRecord, { |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 0, doneAction: 0);
    }).add;

    // Plays a captured note — atk/rel control envelope shape (swell: long atk/rel)
    SynthDef(\chPlay, { |out=0, bufnum, dur=1.0, rate=1.0, amp=0.35, pan=0.0, atk=0.01, rel=0.08|
        var sig = PlayBuf.ar(1, bufnum,
            rate * BufRateScale.kr(bufnum), loop: 0, doneAction: 2);
        var env = EnvGen.kr(
            Env.linen(atk, (dur - atk - rel).max(0.01), rel),
            doneAction: 2);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    // Dry guitar → motive bus
    SynthDef(\chDry, { |out=0, amp=0.42|
        Out.ar(out, (SoundIn.ar(0) * amp).dup);
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

    // Motive reverb: motive bus (dry guitar + P4) → GVerb → hardware out (more present)
    SynthDef(\chMotiveVerb, {
        |busIn=0, out=0, mix=0.52, decay=4.0, damp=0.30|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry[0], roomsize: 40,
            revtime: decay, damping: damp, drylevel: 0);
        var wet  = [verb[0], verb[1]];
        Out.ar(out, ((dry * (1 - mix)) + (wet * mix)).clip2(1.0));
    }).add;

    s.sync;

    // ── Groups ────────────────────────────────────────────────────────────────
    ch.grpRec    = Group.new(s);
    ch.grpBed    = Group.after(ch.grpRec);
    ch.grpMotive = Group.after(ch.grpBed);
    ch.grpVerb   = Group.after(ch.grpMotive);

    // ── Synths ────────────────────────────────────────────────────────────────
    ch.detectSyn = Synth(\chDetect, [thresh: ch.threshold], ch.grpRec);

    // Bed voices — silent (amp=0) until calibration locks
    // P1: static, hard left. P2: static, hard right. P3: active + slow wandering pan (centre→sides)
    // breathRate periods 13/17/19s are prime → never align
    ch.bedSyns = [
        Synth(\chBed, [out: ch.bedBus.index, amp: 0,
            breathRate: 1/13, breathPhase: 0.00, pan: -0.88,
            active: 0, panMove: 0,
            ampLag: ch.bedRiseSecs, freqLag: ch.freqLag], ch.grpBed),
        Synth(\chBed, [out: ch.bedBus.index, amp: 0,
            breathRate: 1/17, breathPhase: 2.09, pan:  0.88,
            active: 0, panMove: 0,
            ampLag: ch.bedRiseSecs, freqLag: ch.freqLag], ch.grpBed),
        Synth(\chBed, [out: ch.bedBus.index, amp: 0,
            breathRate: 1/19, breathPhase: 4.19, pan:  0.00,
            active: 1, panMove: 1,
            ampLag: ch.bedRiseSecs, freqLag: ch.freqLag], ch.grpBed),
    ];

    ch.drySyn = Synth(\chDry, [out: ch.motiveBus.index, amp: ch.dryAmp], ch.grpMotive);

    ch.bedVerbSyn = Synth(\chBedVerb, [
        busIn: ch.bedBus.index, out: 0,
        mix: ch.bedReverbMix, decay: ch.bedReverbDecay, damp: ch.bedReverbDamp,
    ], ch.grpVerb);
    ch.motiveVerbSyn = Synth(\chMotiveVerb, [
        busIn: ch.motiveBus.index, out: 0,
        mix: ch.motiveReverbMix, decay: ch.motiveReverbDecay, damp: ch.motiveReverbDamp,
    ], ch.grpVerb);

    // ── State ─────────────────────────────────────────────────────────────────
    ch.phase         = \waiting;     // waiting / calibrating / running
    ch.mode          = \motiveMode;  // motiveMode / feedMode
    ch.firstFired    = false;
    ch.calibDone     = false;
    ch.calibSamples  = [];
    ch.bedFreqs      = [220, 330, 440];  // placeholder until calibration

    ch.nextBuf       = 0;
    ch.recordSyn     = nil;
    ch.currentRecBuf = nil;
    ch.onsetTime     = nil;
    ch.currentPhrase = [];
    ch.phraseSeq     = 0;   // incremented on each onset to cancel pending phrase timers

    // ── startBed ─────────────────────────────────────────────────────────────
    ch.startBed = {
        var freqs = ch.bedFreqs;
        ch.bedSyns[0].set(\freq, freqs[0], \amp, ch.bedAmp);
        ch.bedSyns[1].set(\freq, freqs[1], \amp, ch.bedAmp);
        ch.bedSyns[2].set(\freq, freqs[2], \amp, ch.bedAmp);
        "BED LOCKED → % / % / % Hz — rising over % s".format(
            freqs[0].round(0.1), freqs[1].round(0.1), freqs[2].round(0.1),
            ch.bedRiseSecs).postln;
        "MOTIVE MODE — play phrases".postln;
    };

    // ── triggerP4 ────────────────────────────────────────────────────────────
    ch.triggerP4 = {
        var phrase = ch.currentPhrase.copy;
        var delay;
        ch.currentPhrase = [];
        if(phrase.size > 0, {
            // Pick 1 or 2 notes from phrase
            [1, 1, 1, 2].choose.min(phrase.size).do({
                var noteData = phrase.choose;
                // Colour: 80% clean, 10% half-speed swell, 10% slight warp
                var colour   = [0,0,0,0,0,0,0,0,1,2].choose;
                var rate     = if(colour == 1, { 0.5 }, { if(colour == 2, { rrand(0.82, 1.18) }, { 1.0 }) });
                var durScale = if(colour == 1, { 2.0 }, { 1.0 });
                var atk      = if(colour == 1, { 0.6 }, { 0.01 });
                var rel      = if(colour == 1, { 0.8 }, { 0.08 });
                // Immediate (0–4s) or late (20–60s), equal weight
                delay        = if(0.5.coin, { rrand(0.0, 4.0) }, { rrand(20.0, 60.0) });
                SystemClock.sched(delay, {
                    Synth(\chPlay, [
                        out:    ch.motiveBus.index,
                        bufnum: noteData[\buf],
                        dur:    noteData[\dur] * durScale,
                        rate:   rate,
                        amp:    ch.p4Amp,
                        pan:    rrand(-0.75, 0.75),
                        atk:    atk,
                        rel:    rel,
                    ], ch.grpMotive);
                    "P4 → colour:% delay:% s".format(
                        [\clean,\swell,\warp][colour], delay.round(0.1)).postln;
                    nil;
                });
            });
        });
    };

    // ── OSC handlers ──────────────────────────────────────────────────────────

    // First note — start timeline, schedule feed windows and fade
    OSCdef(\chFirstNote, { |msg|
        if(ch.firstFired.not, {
            ch.firstFired = true;
            ch.phase      = \calibrating;
            "CHIMERA — STARTED".postln;
            "CALIBRATING — play % distinct harmonics to define the bed".format(
                ch.calibNotes).postln;

            // Auto-close calibration after calibDur even if not enough notes
            SystemClock.sched(ch.calibDur, {
                if(ch.calibDone.not, {
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
                    ch.mode = \feedMode;
                    "FEED % — play swells/harmonics".format(i + 1).postln;
                    nil;
                });
                SystemClock.sched(win[1], {
                    ch.mode = \motiveMode;
                    "MOTIVE MODE — play phrases".postln;
                    nil;
                });
            });

            // Fade and end
            SystemClock.sched(ch.fadeSec, {
                ch.bedSyns.do({ |syn| syn.set(\amp, 0) });
                "FADING...".postln;
                nil;
            });
            SystemClock.sched(ch.totalDur, {
                "SILENCE — evaluate Block 3 to stop".postln;
                nil;
            });

            OSCdef(\chFirstNote).free;
        });
    }, '/ch/firstNote');

    // Onset — start recording, reset phrase timer
    OSCdef(\chOnset, { |msg|
        var amp = msg[3];
        // Increment sequence to cancel any pending phrase timer
        ch.phraseSeq = ch.phraseSeq + 1;
        ch.onsetTime = Main.elapsedTime;

        // Stop any previous recording
        if(ch.recordSyn.notNil, { ch.recordSyn.free; ch.recordSyn = nil });

        ch.currentRecBuf = ch.noteBufs[ch.nextBuf];
        ch.nextBuf       = (ch.nextBuf + 1) % ch.noteBufCount;
        ch.recordSyn     = Synth(\chRecord, [bufnum: ch.currentRecBuf], ch.grpRec);
    }, '/ch/onset');

    // Release — stop recording, classify note, start phrase timer
    OSCdef(\chRelease, { |msg|
        var dur, mySeq;
        if(ch.recordSyn.notNil, { ch.recordSyn.free; ch.recordSyn = nil });

        if(ch.onsetTime.notNil, {
            dur          = Main.elapsedTime - ch.onsetTime;
            ch.onsetTime = nil;

            // Add to phrase if motive note (short) and in correct state/mode
            if((ch.mode == \motiveMode) && (dur < ch.motiveMaxDur)
                    && (ch.phase == \running), {
                ch.currentPhrase = ch.currentPhrase.add((
                    buf: ch.currentRecBuf,
                    dur: dur,
                ));
                // Schedule phrase-end — fires only if phraseSeq unchanged
                mySeq = ch.phraseSeq;
                SystemClock.sched(ch.phraseEndGap, {
                    if(ch.phraseSeq == mySeq, {
                        ch[\triggerP4].value;
                    });
                    nil;
                });
            });
        });
    }, '/ch/release');

    // Pitch — calibration collection + feed window pitch nudging
    OSCdef(\chPitch, { |msg|
        var freq, hasFreq, amp, normHz, dists, nearestIdx, uniquePCs;
        freq    = msg[3];
        hasFreq = msg[4];
        amp     = msg[5];

        if((hasFreq > 0.5) && (amp > ch.threshold)
                && (freq > 50) && (freq < 3000), {

            // Calibration: collect samples, count unique pitch classes
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

            // Feed window: nudge the nearest bed voice toward this pitch
            if(ch.mode == \feedMode, {
                normHz     = ch[\normalizeHz].(freq);
                dists      = ch.bedFreqs.collect({ |bHz| (normHz - bHz).abs });
                nearestIdx = dists.minIndex;
                ch.bedFreqs[nearestIdx] = normHz;
                ch.bedSyns[nearestIdx].set(\freq, normHz);
            });
        });
    }, '/ch/pitch');

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Chimera — running. Play guitar when ready.".postln;
    "  Calibration: % harmonics in first % s".format(ch.calibNotes, ch.calibDur).postln;
    "  Feed windows: 2:30–3:00 | 5:30–6:00 | 8:00–8:30".postln;
    "  Fade at 8:30 | Silence at 9:00".postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP
// ─────────────────────────────────────────────────────────────────────────────
(
OSCdef(\chFirstNote).free;
OSCdef(\chOnset).free;
OSCdef(\chRelease).free;
OSCdef(\chPitch).free;
~ch.noteBufs.do(_.free);
~ch.bedBus.free;
~ch.motiveBus.free;
s.freeAll;
"Chimera — stopped.".postln;
)
