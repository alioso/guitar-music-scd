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

STRUCTURE (~8 min from first note)
  0:00   First note → EXCITATION. Play freely to prime the resonators.
         Feedback gain ramps 0.70 → 0.84 over 2:30.
         CombL decay ramps 3.0 s → 6.5 s. The network remembers everything.
  2:30   SUSTAINING. Network self-runs.
         Barely play — slow swells, isolated taps, long bows.
         Amplitude still modulates the feedback edge.
         Loud surges push toward resonant chaos; silence lets it settle.
  5:00   DISSOLVING. Do not play. Feedback ramps to zero over 2:00.
         The network rings out in its own physics — no fade button.
         Some delay lines will outlast others.
  7:00   Silence. Evaluate Block 3 to stop.
"/Users/albanbailly/Documents/guitar-music-scd/coronal/README.md"
NETWORK
  Delay times: 97, 137, 181, 239, 307, 389, 443 ms.
  Each line LFO-modulated at 9–27 mHz (independent, incommensurable) —
  slow chorus drift creates beating patterns between modes.
  Each line tanh-clipped before re-entering the feedback path.
  Touch boost: guitar amplitude adds up to 0.08 to feedback gain
  (hard ceiling 0.94 — prevents runaway even if you play very loud).

PERFORMANCE NOTES
  The dangerous zone is baseGain 0.88–0.94. During Act 1, the system
  stays safely below that. During Act 2, a sustained loud attack can push
  it there briefly — that instability IS the piece. If it stays chaotic
  too long, release all strings immediately.
  If the dissolution (Act 3) is not silent enough by the end, evaluate:
    ~cor.netSyn.set(\decayTime, 1.0)
  to force the delay lines to drain quickly.
*/


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION
// ─────────────────────────────────────────────────────────────────────────────
(
~cor = (
    // Timing (seconds from first note)
    totalDur:  480,   // 8 min total
    act1Dur:   150,   // excitation  — gain and decay ramp up
    act2Dur:   150,   // sustain     — network self-runs
    act3Dur:   120,   // dissolution — gain ramps to 0; network decays naturally

    // Feedback gain arc
    gainStart:  0.15,  // feedback gain at first note — all 7 lines decaying (loop gain < 1)
    gainPeak:   0.84,  // peak gain — all lines self-oscillating by end of Act 1
    touchMax:   0.08,  // max amplitude-driven boost (peak total: 0.92 — edge of dangerous zone)

    // CombL decay arc
    decayStart:  3.0,  // seconds at first note
    decayPeak:   8.0,  // seconds at peak

    // Mix
    dryAmp:   0.70,    // guitar gain entering the network (no dry bypass)
    outGain:  1.80,    // master output from network SynthDef

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

    // ── Bus ───────────────────────────────────────────────────────────────────
    cor.mixBus = Bus.audio(s, 2);

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Amplitude detector — fires /cor/firstNote once on first note above threshold
    SynthDef(\corDetect, { |thresh=0.012|
        var sig, amp, above, trig;
        sig   = SoundIn.ar(0);
        amp   = Amplitude.kr(sig, attackTime: 0.005, releaseTime: 0.1);
        above = amp > thresh;
        trig  = above * (1 - Delay1.kr(above));
        SendReply.kr(trig, '/cor/firstNote', [amp]);
    }).add;

    // Feedback resonance network.
    // Seven CombL lines with LFO-modulated delay times create slow beating
    // between incommensurable modes. tanh per line prevents runaway.
    // Guitar amplitude (touch) boosts fbkGain in real time.
    // baseGain and decayTime are ramped from the language side during the arc.
    SynthDef(\corNet, {
        |out=0, dryAmp=0.35, outGain=0.78,
         baseGain=0.70, decayTime=3.0, touchMax=0.08|
        var sig, amp, touchBoost, fbkGain;
        var fbk, dryIn, decaySmooth;
        var dts, rates, pans, combs, sat, stereo;

        sig = SoundIn.ar(0);
        amp = Amplitude.kr(sig, attackTime: 0.01, releaseTime: 1.2);

        touchBoost  = (amp * 0.80).clip(0, touchMax);
        fbkGain     = (Lag.kr(baseGain, 2.0) + touchBoost).clip(0, 0.94);
        dryIn       = sig * Lag.kr(dryAmp, 1.0);
        decaySmooth = Lag.kr(decayTime, 3.0);

        dts   = [0.097, 0.137, 0.181, 0.239, 0.307, 0.389, 0.443];
        rates = [0.011, 0.017, 0.013, 0.019, 0.023, 0.009, 0.027];
        pans  = [-0.88, -0.55, -0.22,  0.0,  0.22,  0.55,  0.88];

        // Each line has its own feedback channel — self-oscillates independently.
        // With a shared single-channel sum, loop gain per line = fbkGain×0.85/7,
        // which is always < 1 and can never self-sustain.
        fbk = LocalIn.ar(7, 0.0);

        combs = dts.collect { |dt, i|
            var modded = dt * (1.0 + (SinOsc.kr(rates[i]) * 0.025));
            modded = modded.clip(0.001, dt * 1.02);
            CombL.ar(dryIn + fbk[i], dt * 1.02, modded, decaySmooth)
        };

        sat = combs.collect { |c| c.tanh * 0.85 };
        LocalOut.ar(sat * fbkGain);

        stereo = Mix.ar(sat.collect { |c, i| Pan2.ar(c, pans[i]) }) * (0.60 / 7);
        Out.ar(out, stereo * Lag.kr(outGain, 1.0));
    }).add;

    // Mix bus → GVerb → hardware out
    SynthDef(\corVerb, {
        |busIn=0, out=0, mix=0.40, decay=5.0, damp=0.30|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry[0], roomsize: 60, revtime: decay, damping: damp, drylevel: 0);
        var wet  = [verb[0], verb[1]];
        Out.ar(out, ((dry * (1 - mix)) + (wet * mix)).clip2(1.0));
    }).add;

    s.sync;

    // ── Groups ────────────────────────────────────────────────────────────────
    cor.grpRec  = Group.new(s);
    cor.grpNet  = Group.after(cor.grpRec);
    cor.grpVerb = Group.after(cor.grpNet);

    // ── Amplitude detector ────────────────────────────────────────────────────
    cor.detectSyn  = Synth(\corDetect, [thresh: cor.threshold], cor.grpRec);
    cor.netSyn     = nil;
    cor.verbSyn    = nil;
    cor.arcRoutine = nil;
    cor.firstFired = false;
    cor.alive      = false;

    // ── OSC — first note fires the arc ────────────────────────────────────────
    OSCdef(\corFirstNote, { |msg|
        if(cor.firstFired.not, {
            cor.firstFired = true;
            cor.alive      = true;
            { cor.detectSyn.free }.defer(0.01);

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
            ], cor.grpNet);

            cor.verbSyn = Synth(\corVerb, [
                busIn: cor.mixBus.index, out: 0,
                mix:   cor.reverbMix,
                decay: cor.reverbDecay,
                damp:  cor.reverbDamp,
            ], cor.grpVerb);

            // Act 1: ramp gain and decay up toward peak over act1Dur
            cor.arcRoutine = Routine({
                var steps = (cor.act1Dur / cor.rampStep).ceil.asInteger;
                steps.do { |i|
                    cor.rampStep.wait;
                    if(cor.alive, {
                        var frac = ((i + 1) / steps).clip(0, 1);
                        var g = cor.gainStart + (frac * (cor.gainPeak - cor.gainStart));
                        var d = cor.decayStart + (frac * (cor.decayPeak - cor.decayStart));
                        cor.netSyn.set(\baseGain, g, \decayTime, d);
                    });
                };
            });
            { cor.arcRoutine.play(SystemClock) }.defer(0.001);

            // Act 2 start
            SystemClock.sched(cor.act1Dur, {
                if(cor.alive, {
                    { "\nSUSTAINING — barely play. Network self-runs.".postln }.defer;
                });
                nil
            });

            // Act 3: dissolution — ramp gain to 0, let network die in its own physics
            SystemClock.sched(cor.act1Dur + cor.act2Dur, {
                if(cor.alive, {
                    { "\nDISSOLVING — do not play. Let it die.".postln }.defer;
                    if(cor.arcRoutine.notNil, { cor.arcRoutine.stop });
                    cor.arcRoutine = Routine({
                        var steps3 = (cor.act3Dur / cor.rampStep).ceil.asInteger;
                        steps3.do { |i|
                            cor.rampStep.wait;
                            if(cor.alive, {
                                var frac = ((i + 1) / steps3).clip(0, 1);
                                cor.netSyn.set(\baseGain, cor.gainPeak * (1 - frac));
                            });
                        };
                    });
                    cor.arcRoutine.play(SystemClock);
                });
                nil
            });

            // End cue
            SystemClock.sched(cor.totalDur, {
                if(cor.alive, {
                    { "\nCORONAL — silence. Evaluate Block 3 to stop.".postln }.defer;
                });
                nil
            });
        });
    }, '/cor/firstNote');

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Coronal — running. Play guitar when ready.".postln;
    "  Threshold: % | Gain arc: % → % | Touch boost: 0 → % (ceiling: %)".format(
        cor.threshold, cor.gainStart, cor.gainPeak, cor.touchMax, (cor.gainPeak + cor.touchMax).round(0.01)).postln;
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
~cor.alive = false;
OSCdef(\corFirstNote).free;
if(~cor.arcRoutine.notNil, { ~cor.arcRoutine.stop; ~cor.arcRoutine = nil });
~cor.mixBus.free;
s.freeAll;
"Coronal — stopped.".postln;
)
