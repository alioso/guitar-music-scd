/*
Chimera
Ambient guitar — autonomous partner bed, shimmer reverb
SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)

  Server setup — put this in your SC startup file (File > Open startup file):
    s.options.inDevice  = "Scarlett 2i2 USB";   // adjust to your model
    s.options.outDevice = "Scarlett 2i2 USB";

STRUCTURE
  t=0         First sound → capture buffer starts filling. Partners begin scanning.
  t~1–2 min   Root locks after 3 confirmed swells → shimmer activates.
  t=6 min     Mid-section: reverb expands 4.5→8s, partner breath slows.
  t=10 min    Fade begins — partners dissolve one by one over 2 min.
  t~12 min    Silence — evaluate Block 3 to stop cleanly.

PARTNER BED (5 voices — the ocean)
  A 90s circular buffer records the guitar continuously.
  5 partners each read from it using a Phasor at slightly different rates —
  they drift apart over time, never returning to the same relative position.
  Each partner breathes with its own LFO (prime-ish periods: 13/17/19/23/29s).
  The input grazes the surface. The ocean was already there.

SHIMMER REVERB (melodic surface)
  In-key notes only → PitchShift up octave + octave+5th → long reverb tail.
  Key = Aeolian on detected root.

ROOT DETECTION
  First 3 confirmed swells (slow amp + pitch confidence) vote by majority.
  Pitch normalized to 130–260 Hz (C3–C4). Locked for entire piece.

Uses GVerb (built-in). No external plugins required.
*/

// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION (Cmd+Return inside this block first)
// ─────────────────────────────────────────────────────────────────────────────
(
~ch = (
    // Timing (seconds from first sound)
    totalDur:     720,    // 12 min arc
    fadeDur:      120,    // 2 min fade, starts at t=600s
    midShiftTime: 360,    // 6 min: reverb expands, partner breath slows

    // Detection
    threshold:    0.015,  // first-sound amplitude (0..1)
    swellThresh:  0.020,  // slow-envelope amplitude for swell detection
    swellsNeeded: 3,      // confirmed swells to lock root

    // Levels
    dryAmp:       0.38,   // dry guitar — grazing the surface
    shimmerAmp:   0.34,   // shimmer reverb — in-key sparkle

    // Capture buffer — guitar is always being recorded here (90s circular)
    capBufDur: 90,

    // Partner bed — 5 autonomous buffer scanners
    // startFrac: where in buffer each partner begins (spread across 90s)
    // rateMul:   near 1.0 — tiny pitch drift, partners slowly diverge over the piece
    // breathRate: amplitude LFO Hz — prime-ish periods, never align (13/17/19/23/29s)
    // breathPhase: LFO start phase so partners breathe independently from bar 1
    // ampLag: controls fade-out smoothness (set amp=0 to fade)
    partners: [
        (startFrac: 0.00, rateMul: 1.000, breathRate: 1/13, breathPhase: 0.00, pan: -0.75, amp: 0.34, ampLag: 25),
        (startFrac: 0.20, rateMul: 0.998, breathRate: 1/17, breathPhase: 2.09, pan: -0.35, amp: 0.32, ampLag: 35),
        (startFrac: 0.40, rateMul: 1.002, breathRate: 1/19, breathPhase: 4.19, pan:  0.35, amp: 0.32, ampLag: 40),
        (startFrac: 0.60, rateMul: 0.999, breathRate: 1/23, breathPhase: 1.05, pan:  0.75, amp: 0.30, ampLag: 50),
        (startFrac: 0.80, rateMul: 1.001, breathRate: 1/29, breathPhase: 3.14, pan:  0.00, amp: 0.28, ampLag: 60),
    ],

    // Master reverb — decay ramps 4.5→8.0s at mid-section via Lag
    reverbMix:    0.16,
    reverbDecay:  4.5,
    reverbDamp:   0.30,

    // Guitar reverb (dry path)
    guitarReverbMix:   0.28,
    guitarReverbDecay: 2.5,

    // Shimmer
    shimmerDecay: 9.0,
);

"Chimera — config loaded".postln;
"  arc: % min | fade at % s | mid-shift at % s".format(
    (~ch.totalDur / 60).round(0.1),
    ~ch.totalDur - ~ch.fadeDur,
    ~ch.midShiftTime).postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START (Cmd+Return inside this block)
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var ch = ~ch;

    // ── Helper functions ──────────────────────────────────────────────────────

    // Fold Hz into 130–260 Hz (C3–C4)
    ch.normalizeHz = { |hz|
        var h = hz;
        while({ h < 130  }, { h = h * 2 });
        while({ h >= 260 }, { h = h / 2 });
        h
    };

    // Majority-vote root Hz from array of raw detected Hz values
    ch.computeRoot = { |hzArray|
        var midiNotes, counts, best;
        midiNotes = hzArray.collect({ |hz|
            var h = ch[\normalizeHz].(hz);
            ((h / 440).log2 * 12 + 69).round(1)
        });
        counts = Dictionary.new;
        midiNotes.do({ |n| counts[n] = (counts[n] ? 0) + 1 });
        best = counts.keys.maxItem({ |k| counts[k] });
        ch[\normalizeHz].(440 * (2 ** ((best - 69) / 12)))
    };

    // Aeolian scale pitch classes from root Hz (intervals: 0 2 3 5 7 8 10)
    ch.computeScalePCs = { |rootHz|
        var rootMidi = ((rootHz / 440).log2 * 12 + 69).round(1).asInteger;
        [0, 2, 3, 5, 7, 8, 10].collect({ |i| (rootMidi + i) % 12 })
    };

    // Is detected Hz within one semitone of any scale tone?
    ch.isInKey = { |hz|
        if(ch.scalePCs.isNil, { false }, {
            var pc = ((hz / 440).log2 * 12 + 69).round(1).asInteger % 12;
            ch.scalePCs.includes(pc)
        })
    };

    // ── Buffers & buses ───────────────────────────────────────────────────────
    ch.capBuf = Buffer.alloc(s,
        (s.sampleRate * ch.capBufDur).ceil.asInteger, 1);
    ch.mixBus   = Bus.audio(s, 2);
    ch.inKeyBus = Bus.control(s, 1);
    ch.inKeyBus.set(0);

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Amplitude + pitch detector
    // Fires: /ch/firstSound on first fast transient
    //        /ch/swell on slow swell with pitch confidence
    //        /ch/pitch at 10 Hz for shimmer gating
    SynthDef(\chDetect, { |fastThresh=0.015, swellThresh=0.020|
        var sig, fastAmp, slowAmp, pitch, freq, hasFreq, fastAbove, swellAbove;
        sig        = SoundIn.ar(0);
        fastAmp    = Amplitude.kr(sig, attackTime: 0.005, releaseTime: 0.10);
        slowAmp    = Amplitude.kr(sig, attackTime: 0.50,  releaseTime: 2.00);
        pitch      = Pitch.kr(sig, ampThreshold: 0.02, median: 7);
        freq       = pitch[0];
        hasFreq    = pitch[1];
        fastAbove  = fastAmp > fastThresh;
        swellAbove = (slowAmp > swellThresh) * hasFreq;

        // First sound — rising edge on fast amp
        SendReply.kr(fastAbove * (1 - Delay1.kr(fastAbove)), '/ch/firstSound', fastAmp);

        // Swell — rising edge on slow amp + pitch confident
        SendReply.kr(swellAbove * (1 - Delay1.kr(swellAbove)), '/ch/swell',
            [freq, hasFreq, slowAmp]);

        // Continuous pitch at 10 Hz for shimmer key-gate
        SendReply.kr(Impulse.kr(10), '/ch/pitch', [freq, hasFreq]);
    }).add;

    // Rolling capture — always recording guitar into circular buffer
    SynthDef(\chCapture, { |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum, recLevel: 1.0, preLevel: 0.0, loop: 1);
    }).add;

    // Autonomous partner — reads buffer at its own rate, breathes with its own LFO
    // Partners start at different positions (startFrac) and drift apart over time (rateMul)
    // ampLag controls fade-out: set(\amp, 0) fades over ampLag seconds
    SynthDef(\chPartner, {
        |out=0, bufnum, amp=0.30, pan=0.0,
         startFrac=0.0, rateMul=1.0,
         breathRate=0.07, breathPhase=0.0,
         ampLag=30.0|
        var frames    = BufFrames.kr(bufnum);
        var rate      = BufRateScale.kr(bufnum) * rateMul;
        var phase     = Phasor.ar(0, rate, 0, frames, startFrac * frames);
        var sig       = BufRd.ar(1, bufnum, phase, loop: 1, interpolation: 4);
        var breath    = SinOsc.kr(breathRate, breathPhase).linlin(-1, 1, 0.04, 1.0);
        var ampSmooth = Lag.kr(amp, ampLag);
        Out.ar(out, Pan2.ar(sig * breath * ampSmooth, pan));
    }).add;

    // Dry guitar with its own short reverb — separate from the floor's deep space
    SynthDef(\chDry, {
        |out=0, amp=0.52, reverbMix=0.32, reverbDecay=2.5|
        var sig  = SoundIn.ar(0);
        var verb = GVerb.ar(sig, roomsize: 20, revtime: reverbDecay, damping: 0.50, drylevel: 0);
        var wet  = [verb[0], verb[1]];
        Out.ar(out, ((sig.dup * (1 - reverbMix)) + (wet * reverbMix)) * amp);
    }).add;

    // Shimmer reverb — in-key notes only, pitch-shifted up 1 octave + octave+5th
    // inKeyBus smoothly gates input (80ms lag to avoid clicks)
    SynthDef(\chShimmer, {
        |out=0, inKeyBusIdx=0, amp=0.32, reverbDecay=9.0|
        var gate = Lag.kr(In.kr(inKeyBusIdx), 0.08);
        var sig  = SoundIn.ar(0) * gate;
        var up1  = PitchShift.ar(sig, 0.2, 2.0, 0.0, 0.01);   // +1 octave
        var up2  = PitchShift.ar(sig, 0.2, 3.0, 0.0, 0.01);   // +1 octave + 5th
        var feed = up1 + (up2 * 0.45);
        var verb = GVerb.ar(feed, roomsize: 100, revtime: reverbDecay, damping: 0.25, drylevel: 0);
        Out.ar(out, [verb[0], verb[1]] * amp);
    }).add;

    // Master: mix bus → GVerb → clip → hardware out
    // reverbDecay uses Lag so mid-section ramp is smooth (set decayLag=120 at t=6min)
    SynthDef(\chMaster, {
        |busIn=0, out=0, reverbMix=0.18, reverbDecay=4.5, reverbDecayLag=1.0, reverbDamp=0.30|
        var dry         = In.ar(busIn, 2);
        var decayLagged = Lag.kr(reverbDecay, reverbDecayLag);
        var verb        = GVerb.ar(dry[0], roomsize: 50,
            revtime: decayLagged, damping: reverbDamp, drylevel: 0);
        var wet         = [verb[0], verb[1]];
        Out.ar(out, ((dry * (1 - reverbMix)) + (wet * reverbMix)).clip2(1.0));
    }).add;

    s.sync;

    // ── Groups ────────────────────────────────────────────────────────────────
    ch.grpRec    = Group.new(s);
    ch.grpVoice  = Group.after(ch.grpRec);
    ch.grpDry    = Group.after(ch.grpVoice);
    ch.grpMaster = Group.after(ch.grpDry);

    // ── Start synths ──────────────────────────────────────────────────────────
    ch.capSyn    = Synth(\chCapture, [bufnum: ch.capBuf], ch.grpRec);
    ch.detectSyn = Synth(\chDetect,
        [fastThresh: ch.threshold, swellThresh: ch.swellThresh], ch.grpRec);

    // Partner bed — all running from boot, amp=0 until first note opens them
    ch.partnerSyns = ch.partners.collect({ |p|
        Synth(\chPartner, [
            out:         ch.mixBus.index,
            bufnum:      ch.capBuf,
            amp:         0,
            pan:         p[\pan],
            startFrac:   p[\startFrac],
            rateMul:     p[\rateMul],
            breathRate:  p[\breathRate],
            breathPhase: p[\breathPhase],
            ampLag:      p[\ampLag],
        ], ch.grpVoice);
    });

    ch.drySyn = Synth(\chDry, [
        out:         ch.mixBus.index,
        amp:         ch.dryAmp,
        reverbMix:   ch.guitarReverbMix,
        reverbDecay: ch.guitarReverbDecay,
    ], ch.grpDry);

    ch.shimmerSyn = Synth(\chShimmer, [
        out:         ch.mixBus.index,
        inKeyBusIdx: ch.inKeyBus.index,
        amp:         ch.shimmerAmp,
        reverbDecay: ch.shimmerDecay,
    ], ch.grpDry);

    ch.masterSyn = Synth(\chMaster, [
        busIn:       ch.mixBus.index,
        out:         0,
        reverbMix:   ch.reverbMix,
        reverbDecay: ch.reverbDecay,
        reverbDamp:  ch.reverbDamp,
    ], ch.grpMaster);

    // ── State ─────────────────────────────────────────────────────────────────
    ch.firstFired   = false;
    ch.rootLocked   = false;
    ch.swellSamples = [];
    ch.scalePCs     = nil;

    // ── First sound handler ───────────────────────────────────────────────────
    OSCdef(\chFirstSound, { |msg|
        if(ch.firstFired.not, {
            ch.firstFired = true;

            { "Chimera — first sound. Timer started.".postln;
              "Play % slow swells to lock root pitch.".format(ch.swellsNeeded).postln;
            }.defer;

            // Open partner bed — each partner's ampLag controls its fade-in speed
            ch.partners.do({ |p, i|
                ch.partnerSyns[i].set(\amp, p[\amp]);
            });

            // ── Mid-section at t=6 min ────────────────────────────────────────
            SystemClock.sched(ch.midShiftTime, {
                { "Mid-section — space expanding...".postln; }.defer;

                // A: master reverb decay 4.5 → 8.0s, ramped over 120s
                ch.masterSyn.set(\reverbDecay, 8.0, \reverbDecayLag, 120);

                // B: all partners breathe slower — period roughly doubles (more sustained)
                ch.partners.do({ |p, i|
                    ch.partnerSyns[i].set(\breathRate, p[\breathRate] * 0.5);
                });

                nil;
            });

            // ── Fade at t=10 min ──────────────────────────────────────────────
            // Set all partner amps to 0 — each has its own ampLag so they dissolve
            // at different rates (25/35/40/50/60s), staggering naturally
            SystemClock.sched(ch.totalDur - ch.fadeDur, {
                { "Chimera — fading...".postln; }.defer;
                ch.partnerSyns.do({ |syn| syn.set(\amp, 0) });
                { "Fading to silence...".postln; }.defer;
                nil;
            });
        });
    }, '/ch/firstSound');

    // ── Swell handler — root detection + lazy floor reactions ─────────────────
    OSCdef(\chSwell, { |msg|
        var freq    = msg[3];
        var hasFreq = msg[4];

        // Root collection phase
        if(ch.rootLocked.not && (hasFreq > 0.5) && (freq > 50) && (freq < 2000), {
            ch.swellSamples = ch.swellSamples.add(freq);
            { "  Swell % / %: % Hz".format(
                ch.swellSamples.size, ch.swellsNeeded, freq.round(0.1)).postln;
            }.defer;

            if(ch.swellSamples.size >= ch.swellsNeeded, {
                ch.rootHz   = ch[\computeRoot].(ch.swellSamples);
                ch.scalePCs = ch[\computeScalePCs].(ch.rootHz);
                ch.rootLocked = true;

                { "ROOT LOCKED → % Hz | Aeolian PCs: % — shimmer active".format(
                    ch.rootHz.round(0.1), ch.scalePCs).postln; }.defer;
            });
        });
    }, '/ch/swell');

    // ── Pitch monitor — shimmer key-gate (10 Hz) ──────────────────────────────
    OSCdef(\chPitch, { |msg|
        var freq    = msg[3];
        var hasFreq = msg[4];
        ch.inKeyBus.set(
            (ch.rootLocked && (hasFreq > 0.5) && (freq > 50) && (freq < 5000)
                && ch[\isInKey].(freq)).binaryValue
        );
    }, '/ch/pitch');

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Chimera — running. Play guitar when ready.".postln;
    "Threshold: %. Bow/swell % notes to lock root.".format(
        ch.threshold, ch.swellsNeeded).postln;
    "Timeline from first sound:".postln;
    "  ~1–2 min : root locks — shimmer activates on in-key notes".postln;
    "  % s      : mid-section — reverb expands, partners breathe slower".format(
        ch.midShiftTime).postln;
    "  % s      : fade begins (2 min)".format(ch.totalDur - ch.fadeDur).postln;
    "  ~% min   : silence — evaluate Block 3 to stop".format(
        ((ch.totalDur + 140) / 60).round(0.5)).postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP (Cmd+Return to end cleanly)
// ─────────────────────────────────────────────────────────────────────────────
(
OSCdef(\chFirstSound).free;
OSCdef(\chSwell).free;
OSCdef(\chPitch).free;
~ch.capBuf.free;
~ch.mixBus.free;
~ch.inKeyBus.free;
s.freeAll;
"Chimera — stopped.".postln;
)
