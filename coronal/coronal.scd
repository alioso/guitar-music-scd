/*
Coronal
Feedback resonance network for live guitar — SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)

  Server startup file:
    s.options.inDevice  = "Scarlett 2i2 USB";
    s.options.outDevice = "Scarlett 2i2 USB";

CONCEPT
  Seven CombL delay lines (97–443 ms, prime-derived) form a feedback
  network. Each line is slowly chorus-drifted by an independent LFO —
  the modes beat against each other at rates no score could specify.
  Guitar amplitude modulates the feedback gain directly: soft touch keeps
  the system in stable resonance; loud playing pushes it toward the edge
  of instability. No pitch detection. Touch is the compositional gesture.

STRUCTURE (~7 min from first note)
  0:00   First note → EXCITATION. Play freely to prime the resonators.
         Feedback gain ramps 0.15 → 0.84 over 2:30.
         CombL decay ramps 3.0 s → 8.0 s. The network remembers everything.
  2:30   SUSTAINING. Network self-runs.
         Barely play — slow swells, isolated taps, long bows.
         Amplitude still modulates the feedback edge.
         Loud surges push toward the edge; silence lets it settle.
  5:00   DISSOLVING. Do not play. Feedback ramps to zero over 2:00.
         The network rings out in its own physics — no fade button.
         Some delay lines will outlast others.
  7:00   Silence. Evaluate Block 3 to stop.

NETWORK
  Delay times: 97, 137, 181, 239, 307, 389, 443 ms.
  Each line LFO-modulated at 9–27 mHz (independent, incommensurable) —
  slow chorus drift creates beating patterns between modes.
  Each line tanh-clipped before re-entering the feedback path.
  Feedback gain = the loop gain of each line: the external path only adds
  what the comb's own decay doesn't supply (a line never rings shorter than
  the CombL decay). 1.0 would sustain forever; the hard ceiling of 0.94 keeps
  every line decaying, however loud you play.
  Touch boost: guitar amplitude adds up to 0.08 to the feedback gain.

PERFORMANCE NOTES
  The edge zone is feedback gain 0.88–0.94: rings of 25–50 s on the long
  lines (never shorter than the CombL decay on any line). During Act 1 the system stays below it. During Act 2 a sustained
  loud attack pushes into it — that near-instability IS the piece. If it
  rings too long, release all strings immediately.
  If the dissolution (Act 3) is not silent enough by the end, evaluate:
    ~cor.netSyn.set(\decayTime, 1.0)
  to force the delay lines to drain quickly.
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
~cor = (
    // Timing (seconds from first note)
    totalDur:  420,   // 7 min total
    act1Dur:   150,   // excitation  — gain and decay ramp up
    act2Dur:   150,   // sustain     — network self-runs
    act3Dur:   120,   // dissolution — gain ramps to 0; network decays naturally

    // Feedback gain arc (total loop gain per line; 1.0 = never decays)
    gainStart:  0.15,  // feedback gain at first note — the combs' own decay dominates
    gainPeak:   0.84,  // peak gain — long, singing resonance
    touchMax:   0.08,  // max amplitude-driven boost (peak total: 0.92 — inside the edge zone)
    gainCeiling: 0.94, // hard ceiling (server-side clip)

    // CombL decay arc
    decayStart:  3.0,  // seconds at first note
    decayPeak:   8.0,  // seconds at peak

    // Mix
    dryAmp:   0.70,    // guitar gain entering the network (no dry bypass)
    outGain:  3.0,     // master output from network SynthDef — set at sound check (limiter protects)

    // Reverb
    reverbMix:   0.40,
    reverbDecay: 5.0,
    reverbDamp:  0.30,

    rampStep:  4.0,    // arc update interval (seconds)
    threshold: 0.012,
);
"Coronal — config loaded".postln;
"  7 delay lines (97–443 ms) | Acts: %s / %s / %s | End: %s".format(
    ~cor.act1Dur, ~cor.act2Dur, ~cor.act3Dur, ~cor.totalDur).postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var cor = ~cor;

    // Private timeline clock — stopping it cancels everything this piece scheduled
    cor.tclock = TempoClock(1);

    // ── Bus ───────────────────────────────────────────────────────────────────
    cor.mixBus = Bus.audio(s, 2);

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Amplitude detector — fires /cor/firstNote once on first note above threshold
    SynthDef(\corDetect, { |thresh=0.012|
        var sig, amp, above, trig;
        sig   = SoundIn.ar(0);
        amp   = A2K.kr(Amplitude.ar(sig, attackTime: 0.005, releaseTime: 0.1));
        above = amp > thresh;
        trig  = above * (1 - Delay1.kr(above));
        SendReply.kr(trig, '/cor/firstNote', [amp]);
    }).add;

    // Feedback resonance network.
    // Seven CombL lines with LFO-modulated delay times create slow beating
    // between incommensurable modes. tanh per line bounds the level.
    // Loop gain per line = the larger of fbkGain and the comb's own feedback
    // (from decayTime): the external path supplies only the remainder. Guitar amplitude
    // (touch) boosts fbkGain in real time; baseGain and decayTime are ramped
    // from the language side during the arc.
    SynthDef(\corNet, {
        |out=0, dryAmp=0.35, outGain=0.78,
         baseGain=0.70, decayTime=3.0, touchMax=0.08, ceiling=0.94|
        var sig, amp, touchBoost, fbkGain;
        var fbk, dryIn, decaySmooth;
        var dts, rates, pans, combs, sat, ext, stereo;

        sig = SoundIn.ar(0);
        amp = A2K.kr(Amplitude.ar(sig, attackTime: 0.01, releaseTime: 1.2));

        touchBoost  = (amp * 0.80).clip(0, touchMax);
        fbkGain     = (Lag.kr(baseGain, 2.0) + touchBoost).clip(0, ceiling);
        dryIn       = sig * Lag.kr(dryAmp, 1.0);
        decaySmooth = Lag.kr(decayTime, 3.0);

        dts   = [0.097, 0.137, 0.181, 0.239, 0.307, 0.389, 0.443];
        rates = [0.011, 0.017, 0.013, 0.019, 0.023, 0.009, 0.027];
        pans  = [-0.88, -0.55, -0.22,  0.0,  0.22,  0.55,  0.88];

        // Each line has its own feedback channel
        fbk = LocalIn.ar(7, 0.0);

        combs = dts.collect { |dt, i|
            var modded = dt * (1.0 + (SinOsc.kr(rates[i]) * 0.025));
            modded = modded.clip(0.001, dt * 1.02);
            CombL.ar(dryIn + fbk[i], dt * 1.02, modded, decaySmooth)
        };

        sat = combs.collect { |c| c.tanh * 0.85 };

        // External gain per line: what's left of fbkGain after the comb's own
        // feedback coefficient (0.001 ** (dt / decay)), undoing the 0.85 above
        ext = dts.collect { |dt| ((fbkGain - (0.001 ** (dt / decaySmooth))).max(0) / 0.85) };
        LocalOut.ar(sat * ext);

        stereo = Mix.ar(sat.collect { |c, i| Pan2.ar(c, pans[i]) }) * (0.60 / 7);
        Out.ar(out, stereo * Lag.kr(outGain, 1.0));
    }).add;

    // Mix bus → GVerb → limiter → hardware out
    SynthDef(\corVerb, {
        |busIn=0, out=0, mix=0.40, decay=5.0, damp=0.30|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry.sum * 0.5, roomsize: 60, revtime: decay, damping: damp, drylevel: 0);
        var sig  = (dry * (1 - mix)) + (verb * mix);
        Out.ar(out, Limiter.ar(sig, 0.95, 0.003));
    }).add;

    s.sync;

    // ── Groups (all inside one root group — Block 3 frees only this piece) ────
    cor.grpRoot = Group.new(s);
    cor.grpRec  = Group.head(cor.grpRoot);
    cor.grpNet  = Group.after(cor.grpRec);
    cor.grpVerb = Group.after(cor.grpNet);

    // ── Amplitude detector ────────────────────────────────────────────────────
    cor.detectSyn  = Synth(\corDetect, [thresh: cor.threshold], cor.grpRec);
    cor.netSyn     = nil;
    cor.verbSyn    = nil;
    cor.firstFired = false;

    // Ramp baseGain (and optionally decayTime) linearly over `dur` seconds
    cor.ramp = { |dur, g0, g1, d0, d1|
        var steps = (dur / cor.rampStep).ceil.asInteger;
        Routine({
            steps.do { |i|
                var frac = ((i + 1) / steps).clip(0, 1);
                cor.rampStep.wait;
                cor.netSyn.set(\baseGain, g0 + (frac * (g1 - g0)));
                if(d0.notNil) { cor.netSyn.set(\decayTime, d0 + (frac * (d1 - d0))) };
            };
        }).play(cor.tclock);
    };

    // ── OSC — first note fires the arc ────────────────────────────────────────
    OSCdef(\corFirstNote, { |msg|
        if(cor.firstFired.not, {
            cor.firstFired = true;
            cor.detectSyn.free;

            { "CORONAL — STARTED".postln;
              "EXCITATION — play freely to prime the network".postln; }.defer;

            // Start network and reverb
            cor.netSyn = Synth(\corNet, [
                out:       cor.mixBus.index,
                dryAmp:    cor.dryAmp,
                outGain:   cor.outGain,
                baseGain:  cor.gainStart,
                decayTime: cor.decayStart,
                touchMax:  cor.touchMax,
                ceiling:   cor.gainCeiling,
            ], cor.grpNet);

            cor.verbSyn = Synth(\corVerb, [
                busIn: cor.mixBus.index, out: 0,
                mix:   cor.reverbMix,
                decay: cor.reverbDecay,
                damp:  cor.reverbDamp,
            ], cor.grpVerb);

            // Act 1: ramp gain and decay up toward peak over act1Dur
            cor.arcRoutine = cor[\ramp].(cor.act1Dur,
                cor.gainStart, cor.gainPeak, cor.decayStart, cor.decayPeak);

            // Act 2 start
            cor.tclock.sched(cor.act1Dur, {
                { "\nSUSTAINING — barely play. Network self-runs.".postln }.defer;
                nil
            });

            // Act 3: dissolution — ramp gain to 0, let network die in its own physics
            cor.tclock.sched(cor.act1Dur + cor.act2Dur, {
                { "\nDISSOLVING — do not play. Let it die.".postln }.defer;
                cor.arcRoutine.stop;
                cor.arcRoutine = cor[\ramp].(cor.act3Dur, cor.gainPeak, 0);
                nil
            });

            // End cue
            cor.tclock.sched(cor.totalDur, {
                { "\nCORONAL — silence. Evaluate Block 3 to stop.".postln }.defer;
                nil
            });
        });
    }, '/cor/firstNote');

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Coronal — running. Play guitar when ready.".postln;
    "  Threshold: % | Gain arc: % → % | Touch boost: 0 → % (ceiling: %)".format(
        cor.threshold, cor.gainStart, cor.gainPeak, cor.touchMax, cor.gainCeiling).postln;
    "  Excitation: 0–%s | Sustain: %s–%s | Dissolve: %s–%s | End: %ss".format(
        cor.act1Dur,
        cor.act1Dur, cor.act1Dur + cor.act2Dur,
        cor.act1Dur + cor.act2Dur, cor.act1Dur + cor.act2Dur + cor.act3Dur,
        cor.totalDur).postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP
// ─────────────────────────────────────────────────────────────────────────────
(
~cor.tclock !? _.stop;
OSCdef(\corFirstNote).free;
~cor.grpRoot !? _.free;
~cor.mixBus !? _.free;
"Coronal — stopped.".postln;
)
