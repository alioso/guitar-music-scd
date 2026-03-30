/*
Chimera
Ambient guitar — granular floor, harmonic synthesis, shimmer reverb
SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)

  Server setup — put this in your SC startup file (File > Open startup file):
    s.options.inDevice  = "Scarlett 2i2 USB";   // adjust to your model
    s.options.outDevice = "Scarlett 2i2 USB";

STRUCTURE
  t=0         First sound detected — timer starts, granular seeding begins
  t~1–2 min   Root locks after 3 confirmed swells — floor voices bloom one by one
  t~4 min     All 4 floor voices fully present
  t=6 min     Mid-section: reverb expands 4.5→8s, one LFO doubles, grains stretch
  t=10 min    Fade begins — voices drop out one by one
  t=11:30     Root voice alone
  t~12:20     Silence — evaluate Block 3 to stop cleanly

FLOOR VOICES (synthesis backbone — sine oscillators, LFO amplitude)
  V1: root,     LFO 47s,  pan −0.8 (last to fade)
  V2: 5th,      LFO 61s,  pan  0.8
  V3: octave,   LFO 83s,  pan −0.4
  V4: flat 7th, LFO 103s, pan  0.4
  LFO periods are prime-ish — voices never align, constant interlacing (Eno).

GRANULAR LAYER
  TGrains reads from a 30s rolling capture buffer (your live guitar).
  Long grains (1.2→2.5s over piece), scattered position.
  Reacts to swells with lazy nudges (4–20s random delay).

SHIMMER REVERB (melodic path)
  In-key notes only → PitchShift up octave + octave+5th → long JPverb tail.
  Chromatic notes pass through dry only. Key = Aeolian on locked root.

ROOT DETECTION
  First 3 confirmed swells (slow amp + pitch confidence) vote by majority.
  Pitch normalized to 130–260 Hz (C3–C4). Locked for the entire piece.

REQUIRES sc3-plugins for JPverb (brew install sc3-plugins)
  Fallback: replace JPverb with GVerb (see comments in master section)
*/

// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION (Cmd+Return inside this block first)
// ─────────────────────────────────────────────────────────────────────────────
(
~ch = (
    // Timing (seconds from first sound)
    totalDur:     720,    // 12 min arc
    fadeDur:      120,    // 2 min fade, starts at t=600s
    midShiftTime: 360,    // 6 min: space expands, texture dissolves

    // Detection
    threshold:    0.015,  // first-sound amplitude (0..1)
    swellThresh:  0.020,  // slow-envelope amplitude for swell detection
    swellsNeeded: 3,      // confirmed swells to lock root

    // Levels
    floorAmp:     0.28,   // per floor voice peak amplitude
    granAmp:      0.11,   // granular layer base amplitude
    dryAmp:       0.52,   // dry guitar in mix
    shimmerAmp:   0.32,   // shimmer reverb level

    // Floor voices — interval (semitones), LFO Hz, initial phase (radians), pan
    // Phases spaced ~pi/2 apart so voices start offset in their LFO cycles
    voices: [
        (interval:  0, lfoHz: 1/47,  lfoPhase: 0.00, pan: -0.8),  // root
        (interval:  7, lfoHz: 1/61,  lfoPhase: 1.57, pan:  0.8),  // perfect 5th
        (interval: 12, lfoHz: 1/83,  lfoPhase: 3.14, pan: -0.4),  // octave
        (interval: 10, lfoHz: 1/103, lfoPhase: 4.71, pan:  0.4),  // flat 7th
    ],

    // Floor entry stagger from root lock (seconds) + individual fade-in duration
    voiceEntryDelays: [0, 60, 120, 180],
    voiceFadeSecs:    60,

    // Granular
    capBufDur:    30,     // rolling capture buffer (seconds)
    grainDur:     1.2,    // initial grain duration (s) — stretches to 2.5s at mid-section
    grainDensity: 2.5,    // grains per second

    // Master reverb — decay ramps 4.5→8.0s at mid-section via Lag
    reverbMix:    0.18,
    reverbDecay:  4.5,
    reverbDamp:   0.30,
    reverbSize:   1.4,

    // Guitar reverb (dry path — distinct from floor space, shorter)
    guitarReverbMix:   0.32,
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
        var midiNotes = hzArray.collect({ |hz|
            var h = ch.normalizeHz.(hz);
            ((h / 440).log2 * 12 + 69).round(1)
        });
        var counts = Dictionary.new;
        midiNotes.do({ |n| counts[n] = (counts[n] ? 0) + 1 });
        var best = counts.keys.maxItem({ |k| counts[k] });
        ch.normalizeHz.(440 * (2 ** ((best - 69) / 12)))
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
    ch.capBuf   = Buffer.alloc(s,
        (s.sampleRate * ch.capBufDur).ceil.asInteger, 1);
    ch.mixBus   = Bus.audio(s, 2);
    ch.inKeyBus = Bus.control(s, 1);
    ch.inKeyBus.set(0);

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Continuously records guitar into rolling capture buffer (for granular)
    SynthDef(\chCapture, { |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 1);
    }).add;

    // Amplitude + pitch detector
    // Fires: /ch/firstSound on first fast transient
    //        /ch/swell on slow swell with pitch confidence
    //        /ch/pitch at 10 Hz for shimmer gating
    SynthDef(\chDetect, { |fastThresh=0.015, swellThresh=0.020|
        var sig     = SoundIn.ar(0);
        var fastAmp = Amplitude.kr(sig, attackTime: 0.005, releaseTime: 0.10);
        var slowAmp = Amplitude.kr(sig, attackTime: 0.50,  releaseTime: 2.00);
        var pitch   = Pitch.kr(sig, ampThreshold: 0.02, median: 7);
        var freq    = pitch[0];
        var hasFreq = pitch[1];

        // First sound — rising edge on fast amp
        var fastAbove = fastAmp > fastThresh;
        SendReply.kr(fastAbove * (1 - Delay1.kr(fastAbove)), '/ch/firstSound', fastAmp);

        // Swell — rising edge on slow amp + pitch confident
        var swellAbove = (slowAmp > swellThresh) * hasFreq;
        SendReply.kr(swellAbove * (1 - Delay1.kr(swellAbove)), '/ch/swell',
            [freq, hasFreq, slowAmp]);

        // Continuous pitch at 10 Hz for shimmer key-gate
        SendReply.kr(Impulse.kr(10), '/ch/pitch', [freq, hasFreq]);
    }).add;

    // Synthesis floor voice — sine + quiet 2nd harmonic, LFO on amplitude
    // LFO never goes fully silent (min 15%) — ensures always some floor presence
    SynthDef(\chFloor, {
        |out=0, freq=220, gate=0, fadeSecs=60.0,
         lfoHz=0.02, lfoHzLag=30.0, lfoPhase=0.0,
         pan=0.0, amp=0.28|
        var lfoSmooth = Lag.kr(lfoHz, lfoHzLag);
        var lfo       = SinOsc.kr(lfoSmooth, lfoPhase).linlin(-1, 1, 0.15, 1.0);
        var env       = EnvGen.kr(
            Env.asr(fadeSecs, 1.0, fadeSecs * 0.5, curve: \sine),
            gate, doneAction: 2);
        var sig = SinOsc.ar(freq) + (SinOsc.ar(freq * 2) * 0.12);
        Out.ar(out, Pan2.ar(sig * env * lfo * amp, pan));
    }).add;

    // Granular layer — TGrains from rolling guitar capture buffer
    // grainDur ramps via Lag (mid-section stretch: 1.2 → 2.5s over 120s)
    SynthDef(\chGranular, {
        |out=0, bufnum, gate=0, fadeSecs=40.0, amp=0.11,
         grainDur=1.2, grainDurLag=60.0, density=2.5|
        var durSmooth = Lag.kr(grainDur, grainDurLag);
        var pos  = LFNoise1.kr(0.03).range(0.05, 0.95) * BufDur.kr(bufnum);
        var trig = Impulse.ar(density + LFNoise1.kr(0.05).range(-0.5, 0.5));
        var env  = EnvGen.kr(
            Env.asr(fadeSecs, 1.0, fadeSecs * 0.5, curve: \sine),
            gate, doneAction: 2);
        var sig  = TGrains.ar(2, trig, bufnum, 1.0, pos, durSmooth,
            LFNoise0.kr(0.08).range(-0.7, 0.7), amp * env);
        Out.ar(out, sig);
    }).add;

    // Dry guitar with its own short reverb — separate from the floor's deep space
    SynthDef(\chDry, {
        |out=0, amp=0.52, reverbMix=0.32, reverbDecay=2.5|
        var sig = SoundIn.ar(0);
        var wet = JPverb.ar(sig.dup,
            t60:       reverbDecay,
            damp:      0.50,
            size:      0.9,
            earlyDiff: 0.65,
            modDepth:  0.02,
            modFreq:   0.30);
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
        var wet  = JPverb.ar(feed.dup,
            t60:       reverbDecay,
            damp:      0.25,
            size:      1.8,
            earlyDiff: 0.95,
            modDepth:  0.08,
            modFreq:   0.08);
        Out.ar(out, wet * amp);
    }).add;

    // Master: mix bus → JPverb → clip → hardware out
    // reverbDecay uses Lag so mid-section ramp is smooth (set decayLag=120 at t=6min)
    SynthDef(\chMaster, {
        |busIn=0, out=0,
         reverbMix=0.18, reverbDecay=4.5, reverbDecayLag=1.0,
         reverbDamp=0.30, reverbSize=1.4|
        var dry         = In.ar(busIn, 2);
        var decayLagged = Lag.kr(reverbDecay, reverbDecayLag);
        var wet         = JPverb.ar(dry,
            t60:       decayLagged,
            damp:      reverbDamp,
            size:      reverbSize,
            earlyDiff: 0.80,
            modDepth:  0.03,
            modFreq:   0.12);
        Out.ar(out, ((dry * (1 - reverbMix)) + (wet * reverbMix)).clip2(1.0));
    }).add;

    /* GVerb fallback — uncomment and replace chMaster above if sc3-plugins not installed:
    SynthDef(\chMaster, {
        |busIn=0, out=0, reverbMix=0.18, reverbDecay=4.5, reverbDamp=0.30|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry[0], roomsize: 50,
            revtime: reverbDecay, damping: reverbDamp, drylevel: 0);
        var wet  = [verb[0], verb[1]];
        Out.ar(out, ((dry * (1 - reverbMix)) + (wet * reverbMix)).clip2(1.0));
    }).add;
    */

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

    // Floor voices — silent (gate: 0) until root locks, placeholder freq
    ch.floorSyns = ch.voices.collect({ |v|
        Synth(\chFloor, [
            out:       ch.mixBus.index,
            freq:      220,
            gate:      0,
            fadeSecs:  ch.voiceFadeSecs,
            lfoHz:     v[\lfoHz],
            lfoPhase:  v[\lfoPhase],
            pan:       v[\pan],
            amp:       ch.floorAmp,
        ], ch.grpVoice);
    });

    // Granular — gate fires at first sound (barely perceptible, Env.asr fades in over 40s)
    ch.granSyn = Synth(\chGranular, [
        out:       ch.mixBus.index,
        bufnum:    ch.capBuf,
        gate:      0,
        fadeSecs:  40,
        amp:       ch.granAmp,
        grainDur:  ch.grainDur,
        density:   ch.grainDensity,
    ], ch.grpVoice);

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
        reverbSize:  ch.reverbSize,
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

            // Seed granular immediately — subliminal at first (Env.asr 40s fade-in)
            ch.granSyn.set(\gate, 1);

            // ── Mid-section at t=6 min ────────────────────────────────────────
            SystemClock.sched(ch.midShiftTime, {
                { "Mid-section — space expanding...".postln; }.defer;

                // A (dominant): reverb decay 4.5 → 8.0s, ramped over 120s via Lag
                ch.masterSyn.set(\reverbDecay, 8.0, \reverbDecayLag, 120);

                // B: floor V3 (octave) LFO period doubles, transitions over 60s
                ch.floorSyns[2].set(\lfoHz, ch.voices[2][\lfoHz] * 0.5, \lfoHzLag, 60);

                // C: grain duration stretches 1.2 → 2.5s over 120s
                ch.granSyn.set(\grainDur, 2.5, \grainDurLag, 120);

                nil;
            });

            // ── Fade at t=10 min ──────────────────────────────────────────────
            // Stagger: flat7 → 5th → granular → octave → (root alone) → root
            SystemClock.sched(ch.totalDur - ch.fadeDur, {
                { "Chimera — fading...".postln; }.defer;

                ch.floorSyns[3].set(\gate, 0);       // flat 7th (release 30s)

                SystemClock.sched(30, {
                    ch.floorSyns[1].set(\gate, 0);   // 5th
                    nil;
                });
                SystemClock.sched(50, {
                    ch.granSyn.set(\gate, 0);         // granular (release 20s)
                    nil;
                });
                SystemClock.sched(70, {
                    ch.floorSyns[2].set(\gate, 0);   // octave
                    { "Root voice holding...".postln; }.defer;
                    nil;
                });
                SystemClock.sched(110, {
                    ch.floorSyns[0].set(\gate, 0);   // root — final fade (release 30s)
                    { "Root fading to silence.".postln; }.defer;
                    nil;
                });

                nil;
            });
        });
    }, '/ch/firstSound');

    // ── Swell handler — root detection + lazy floor reactions ─────────────────
    OSCdef(\chSwell, { |msg|
        var freq    = msg[3];
        var hasFreq = msg[4];

        // Root collection phase
        if(ch.rootLocked.not && (hasFreq > 0.5) && freq > 50 && freq < 2000, {
            ch.swellSamples = ch.swellSamples.add(freq);
            { "  Swell % / %: % Hz".format(
                ch.swellSamples.size, ch.swellsNeeded, freq.round(0.1)).postln;
            }.defer;

            if(ch.swellSamples.size >= ch.swellsNeeded, {
                ch.rootHz   = ch.computeRoot.(ch.swellSamples);
                ch.scalePCs = ch.computeScalePCs.(ch.rootHz);
                ch.rootLocked = true;

                { "ROOT LOCKED → % Hz | Aeolian PCs: %".format(
                    ch.rootHz.round(0.1), ch.scalePCs).postln; }.defer;

                // Bloom floor voices with staggered entry
                ch.voices.do({ |v, i|
                    var vFreq = ch.rootHz * (2 ** (v[\interval] / 12));
                    SystemClock.sched(ch.voiceEntryDelays[i], {
                        ch.floorSyns[i].set(\freq, vFreq, \gate, 1);
                        { "  Floor V%: % Hz fading in".format(
                            i + 1, vFreq.round(0.1)).postln; }.defer;
                        nil;
                    });
                });
            });
        });

        // Floor reaction — lazy nudge to granular density after random delay (4–20s)
        if(ch.rootLocked, {
            SystemClock.sched(rrand(4.0, 20.0), {
                ch.granSyn.set(\density, ch.grainDensity + rrand(0.5, 1.5));
                SystemClock.sched(20, {
                    ch.granSyn.set(\density, ch.grainDensity);
                    nil;
                });
                nil;
            });
        });
    }, '/ch/swell');

    // ── Pitch monitor — shimmer key-gate (10 Hz) ──────────────────────────────
    OSCdef(\chPitch, { |msg|
        var freq    = msg[3];
        var hasFreq = msg[4];
        ch.inKeyBus.set(
            (ch.rootLocked && (hasFreq > 0.5) && (freq > 50) && (freq < 5000)
                && ch.isInKey.(freq)).binaryValue
        );
    }, '/ch/pitch');

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Chimera — running. Play guitar when ready.".postln;
    "Threshold: %. Bow/swell % notes to lock root.".format(
        ch.threshold, ch.swellsNeeded).postln;
    "Timeline from first sound:".postln;
    "  ~1–2 min : root locks, floor blooms (V1 → V4 over 3 min)".postln;
    "  % s      : mid-section shift (reverb expands, grains stretch)".format(
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
