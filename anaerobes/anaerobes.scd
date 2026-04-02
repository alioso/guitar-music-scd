/*
Anaerobes
Generative guitar quintet — live note library, four independent partner voices
SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)
  Cues:   click + voice → output 2+3 (headphones, requires Scarlett 4i4+)

  Server setup — put this in your SC startup file (File > Open startup file):
    s.options.inDevice  = "Scarlett 2i2 USB";   // adjust to your model
    s.options.outDevice = "Scarlett 2i2 USB";
    s.options.numOutputBusChannels = 4;          // for cues to headphones

CONCEPT
  SC detects onsets from the guitarist, captures ~3s audio into buffer slots,
  and indexes them by MIDI pitch. Four partner voices draw from this library to
  create independent generative counterpoint. Two libraries: A (opening harmony)
  and B (mid-section harmonic shift).

REQUIRES sc3-plugins for JPverb (brew install sc3-plugins)
  Fallback: GVerb (see comments in master SynthDef)
*/


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION (Cmd+Return inside this block first)
// ─────────────────────────────────────────────────────────────────────────────
(
~ana = (
    bpm:      76,
    seedDur:  90,       // seconds of Library A seeding, player alone
    totalDur: 480,      // 8 min from first note

    // Partner entry times from first note (seconds)
    // P1 at 90s, P2 at 120s, P3 at 150s, P4 at 180s
    partnerEntryTimes: [90, 120, 150, 180],

    // Coordination events from first note (seconds)
    // [0]=180 group attack (coincides with P4 entry)
    // [1]=210 forte swell
    // [2]=225 decelerando cue
    // [3]=315 rhythmic lock (4 bars of quarter-note pulse)
    // [4]=440 piano drop
    coordTimes: [180, 210, 225, 315, 440],

    // Harmonic shift (Library B)
    shiftCueTime:  260,     // voice cue "record new harmony in four bars"
    shiftSeedBars: 8,       // bars of Library B seeding (dry guitar muted)
    returnCueTime: 407,     // voice cue "returning in four bars"

    // Tempo changes
    decelTargetBpm: 66,   decelOverBars: 16,
    accelCueTime:   370,  accelTargetBpm: 84,  accelOverBars: 12,

    // Harmonic bias lag per partner (in beats, before new bias takes effect)
    harmonicLag: [0, 0, 16, 32],

    // Default harmonic bias (D natural minor pitch classes)
    harmonicBias: [2, 4, 5, 7, 9, 10, 0],

    // Partner definitions (4 entries, indexed 0–3)
    // P1: contemplative, low register, long notes, lots of rest
    // P2: melodic, mid-low, medium values
    // P3: restless, mid-high, triplet-leaning
    // P4: energetic, high, fast values, rarely rests
    partners: [
        (regLow:40, regHigh:60, rhythmWeights:[3,4,2,0,1,0,0], ringProb:0.85, playProb:0.40, ampBase:0.90, pan:-0.6),
        (regLow:52, regHigh:69, rhythmWeights:[1,3,4,1,2,1,0], ringProb:0.65, playProb:0.55, ampBase:0.85, pan:-0.25),
        (regLow:62, regHigh:79, rhythmWeights:[0,1,3,3,3,3,1], ringProb:0.50, playProb:0.60, ampBase:0.80, pan:0.25),
        (regLow:69, regHigh:90, rhythmWeights:[0,0,2,2,4,3,2], ringProb:0.35, playProb:0.75, ampBase:0.75, pan:0.60),
    ],

    // Library
    bufPoolSize:      96,
    captureDur:       3.0,
    maxTakesPerPitch: 3,
    onsetThreshold:   0.015,
    onsetRefractory:  0.25,   // min seconds between captures

    // Mix levels
    partnerAmp:   0.26,
    dryAmp:       0.55,
    reverbMix:    0.16,
    reverbDecay:  3.8,
    reverbSize:   1.2,
    reverbDamp:   0.45,

    // Cue output
    cueOutChan: 2,              // SC output channel for click + voice (0-indexed)
    cueVoice:   "Samantha",     // macOS TTS voice

    // Distortion
    distAmt: 0.65,

    clickOn: true,
);

// Derived values
~ana.barDur      = 60 / ~ana.bpm * 4;
~ana.beatDur     = 60 / ~ana.bpm;
~ana.durations   = [4, 2, 1, 0.667, 0.5, 0.333, 0.25];   // beats: whole→16th-triplet
~ana.restDurs    = [1, 2, 4, 8];
~ana.restWeights = [2, 3, 2, 1];

"Anaerobes — config loaded".postln;
"  bpm=% | bar=% s | beat=% s | totalDur=% s (% min)".format(
    ~ana.bpm,
    ~ana.barDur.round(0.001),
    ~ana.beatDur.round(0.001),
    ~ana.totalDur,
    (~ana.totalDur / 60).round(0.1)).postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START (Cmd+Return inside this block)
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var ana = ~ana;
    var capFrames = (s.sampleRate * ana.captureDur).ceil.asInteger;

    // ── Allocations ───────────────────────────────────────────────────────────

    // Pre-allocate capture buffer pool (round-robin reuse)
    ana.bufPool = Array.fill(ana.bufPoolSize, { Buffer.alloc(s, capFrames, 1) });
    ana.poolIdx = 0;

    // Note libraries: Dictionary midiNote -> Array of Buffers
    ana.libA = Dictionary.new;
    ana.libB = Dictionary.new;
    ana.activeLib = ana.libA;
    ana.recordLib = ana.libA;

    // Control bus for click BPM (so click follows tempo changes)
    ana.bpmBus = Bus.control(s, 1);
    ana.bpmBus.set(ana.bpm);

    ana.mixBus = Bus.audio(s, 2);

    // Voice cue buffers
    ana.cueBufs = Dictionary.new;

    s.sync;

    // ── Voice cue pre-rendering ───────────────────────────────────────────────
    // Generate AIFF files via macOS say, then load as SC buffers
    [
        [\slowDown,   "slow down in four bars"],
        [\speedUp,    "speed up in four bars"],
        [\newHarmony, "record new harmony in four bars"],
        [\harmonyNow, "new harmony"],
        [\returning,  "returning in four bars"],
        [\endSoon,    "end of piece in four bars"],
    ].do { |pair|
        var key  = pair[0];
        var text = pair[1];
        var path = "/tmp/ana_cue_" ++ key ++ ".aiff";
        ("say -v " ++ ana.cueVoice ++ " -o " ++ path.shellQuote ++ " " ++ text.shellQuote).unixCmd;
    };
    1.5.wait;
    [\slowDown, \speedUp, \newHarmony, \harmonyNow, \returning, \endSoon].do { |key|
        ana.cueBufs[key] = Buffer.read(s, "/tmp/ana_cue_" ++ key ++ ".aiff");
    };

    s.sync;

    // ── Helper functions ──────────────────────────────────────────────────────

    // Get next pre-allocated capture buffer (round-robin)
    ana.nextBuf = {
        var b = ana.bufPool[ana.poolIdx % ana.bufPoolSize];
        ana.poolIdx = ana.poolIdx + 1;
        b
    };

    // Add buffer to library indexed by MIDI note
    ana.addToLib = { |buf, midiNote, lib|
        var arr = lib[midiNote] ?? { [] };
        if(arr.size >= ana.maxTakesPerPitch) { arr = arr.drop(1) };
        lib[midiNote] = arr.add(buf);
    };

    // Play a voice cue to headphone output
    ana.playCue = { |key|
        if(ana.cueBufs[key].notNil, {
            Synth(\anaVoice, [out: ana.cueOutChan, bufnum: ana.cueBufs[key].bufnum], ana.grpMaster);
        });
    };

    // Smooth tempo ramp over N bars; also updates bpmBus for click
    ana.tempoRamp = { |targetBpm, overBars|
        var startTempo = TempoClock.default.tempo;
        var endTempo   = targetBpm / 60;
        var totalBeats = overBars * 4;
        Routine({
            totalBeats.do { |i|
                var t        = (i + 1) / totalBeats;
                var newTempo = startTempo + ((endTempo - startTempo) * t);
                TempoClock.default.tempo_(newTempo);
                ana.bpmBus.set(newTempo * 60);
                1.wait;
            };
            { "  Tempo: % BPM".format((TempoClock.default.tempo * 60).round(0.1)).postln; }.defer;
        }).play(TempoClock.default);
    };

    // Update harmonic bias with staggered lag per partner
    ana.updateBias = { |newBias|
        ana.harmonicBias = newBias;
        ana.partners[0][\currentBias] = newBias;
        ana.partners[1][\currentBias] = newBias;
        Routine({
            ana.harmonicLag[2].wait;
            ana.partners[2][\currentBias] = newBias;
        }).play(TempoClock.default);
        Routine({
            ana.harmonicLag[3].wait;
            ana.partners[3][\currentBias] = newBias;
        }).play(TempoClock.default);
        { "  Bias updated: %".format(newBias).postln; }.defer;
    };

    // Note decision algorithm — returns an Event with play/rest decision
    ana.decide = { |partnerIdx|
        var partner = ana.partners[partnerIdx];
        var lib     = ana.activeLib;
        var libKeys = lib.keys.asArray;
        var result;

        if(libKeys.isEmpty || (partner[\active].not), {
            result = (play: false, restBeats: 2.0);
        }, {
            var now    = TempoClock.default.seconds;
            var forced = now < ana.groupAttackUntil;
            var doPlay = forced || (1.0.rand < partner[\playProb]);

            if(doPlay.not, {
                result = (play: false, restBeats: (ana.restDurs[ana.restWeights.windex]) * 1.0);
            }, {
                // Candidates in register range
                var candidates = libKeys.select { |m|
                    (m >= partner[\regLow]) && (m <= partner[\regHigh])
                };
                if(candidates.isEmpty) { candidates = libKeys };

                // Filter by harmonic bias if enough matches
                var biased = candidates.select { |m| partner[\currentBias].includes(m % 12) };
                if(biased.size >= 2) { candidates = biased };

                // Avoid immediate repetition
                var lastMidi = partner[\lastMidi];
                if(lastMidi.notNil && (candidates.size > 1), {
                    candidates = candidates.reject { |m| m == lastMidi };
                });

                // Interval weighting
                var intervalWeights = [0.0, 1.8, 1.6, 1.4, 0.9, 0.7, 0.5,
                                       0.5, 0.6, 0.4, 0.3, 0.3, 0.8, 0.3, 0.2, 0.2, 0.1];
                var weights = if(lastMidi.notNil, {
                    candidates.collect { |m|
                        intervalWeights.at((m - lastMidi).abs.min(16))
                    }
                }, {
                    Array.fill(candidates.size, 1.0)
                });
                if(weights.sum <= 0) { weights = Array.fill(candidates.size, 1.0) };

                var chosenMidi = candidates[weights.windex];
                var bufs       = lib[chosenMidi];

                if(bufs.isNil || bufs.isEmpty, {
                    result = (play: false, restBeats: 1.0);
                }, {
                    // Duration
                    var durBeats = if(ana.rhythmLock, {
                        1.0
                    }, {
                        ana.durations[partner[\rhythmWeights].windex]
                    });
                    var beatDur = TempoClock.default.beatDur;

                    // Envelope decay
                    var ring = 1.0.rand < partner[\ringProb];
                    var dec  = if(ring, { durBeats * beatDur * 0.90 }, { 0.15 });

                    // Dynamic
                    var amp = ana.groupAmp * partner[\ampBase] * ana.partnerAmp * rrand(0.75, 1.0);

                    partner[\lastMidi] = chosenMidi;

                    result = (play: true, buf: bufs.choose, durBeats: durBeats,
                              dec: dec, amp: amp, dist: 0.0);
                });
            });
        });
        result
    };

    // Spawn a Routine on TempoClock for one partner
    ana.startPartner = { |partnerIdx|
        var busIdx = ana.mixBus.index;
        var grp    = ana.grpVoice;
        var pan    = ana.partners[partnerIdx][\pan];

        ana.partners[partnerIdx][\active] = true;
        if(ana.routines[partnerIdx].notNil, { ana.routines[partnerIdx].stop });

        ana.routines[partnerIdx] = Routine({
            loop {
                var d = ana.decide.(partnerIdx);
                if(d[\play], {
                    Synth(\anaHit, [
                        out:    busIdx,
                        bufnum: d[\buf].bufnum,
                        amp:    d[\amp],
                        pan:    pan,
                        atk:    0.005,
                        dec:    d[\dec],
                        dist:   d[\dist],
                    ], grp);
                    d[\durBeats].wait;
                }, {
                    d[\restBeats].wait;
                });
            };
        }).play(TempoClock.default);

        { "  P% active".format(partnerIdx + 1).postln; }.defer;
    };

    // Stop one partner's Routine
    ana.stopPartner = { |partnerIdx|
        if(ana.routines[partnerIdx].notNil, {
            ana.routines[partnerIdx].stop;
            ana.routines[partnerIdx] = nil;
        });
        ana.partners[partnerIdx][\active] = false;
    };

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Onset detector — fires /ana/onset [amp, freq, hasFreq]
    SynthDef(\anaDetect, { |thresh=0.015|
        var sig     = SoundIn.ar(0);
        var amp     = Amplitude.kr(sig, attackTime: 0.005, releaseTime: 0.1);
        var above   = amp > thresh;
        var trig    = above * (1 - Delay1.kr(above));
        var pitch   = Pitch.kr(sig, ampThreshold: 0.02, median: 7);
        SendReply.kr(trig, '/ana/onset', [amp, pitch[0], pitch[1]]);
    }).add;

    // Records 3s into a buffer, self-frees when full
    SynthDef(\anaCapture, { |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum, loop: 0, doneAction: 2);
    }).add;

    // Per-note playback — two-segment envelope, optional soft distortion
    SynthDef(\anaHit, {
        |out=0, bufnum=0, amp=0.24, pan=0.0, atk=0.005, dec=1.0, dist=0.0|
        var env    = EnvGen.kr(Env([0, 1, 0], [atk, dec], curve: [0, -3]), doneAction: 2);
        var sig    = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 1);
        var driven = (sig * 12).tanh * 0.3;
        sig = (sig * (1 - dist)) + (driven * dist);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    // Dry guitar passthrough to mix bus
    SynthDef(\anaDry, { |out=0, amp=0.55|
        Out.ar(out, (SoundIn.ar(0) * amp).dup);
    }).add;

    // Plays a voice cue buffer to headphone output (mono → stereo)
    SynthDef(\anaVoice, { |out=2, bufnum=0, amp=0.88|
        var sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 0, doneAction: 2);
        Out.ar(out, sig.dup * amp);
    }).add;

    // Mix bus → JPverb → clip → hardware out
    // GVerb fallback: replace JPverb block with:
    //   var verb = GVerb.ar(dry[0], roomsize: 40, revtime: reverbDecay,
    //                       damping: reverbDamp, drylevel: 0);
    //   var wet  = [verb[0], verb[1]];
    SynthDef(\anaMaster, {
        |busIn=0, out=0, reverbMix=0.16, reverbDecay=3.8, reverbSize=1.2, reverbDamp=0.45|
        var dry = In.ar(busIn, 2);
        var wet = JPverb.ar(dry,
            t60:       reverbDecay,
            damp:      reverbDamp,
            size:      reverbSize,
            earlyDiff: 0.72,
            modDepth:  0.03,
            modFreq:   0.10);
        Out.ar(out, ((dry * (1 - reverbMix)) + (wet * reverbMix)).clip2(1.0));
    }).add;

    // Quarter-note click reading from bpmBus — kick on beat 1, rim on 2-4
    SynthDef(\anaClick, { |out=2, bpmBus=0|
        var bpm    = In.kr(bpmBus);
        var trig   = Impulse.kr(bpm / 60);
        var count  = PulseCount.kr(trig) % 4;
        var isDown = count < 1;
        var kick   = SinOsc.ar(80) * EnvGen.kr(Env.perc(0.001, 0.12), isDown * trig) * 0.5;
        var rim    = HPF.ar(WhiteNoise.ar, 900) * EnvGen.kr(Env.perc(0.001, 0.04), (1 - isDown) * trig) * 0.3;
        Out.ar(out, (kick + rim).dup);
    }).add;

    s.sync;

    // ── Set TempoClock ────────────────────────────────────────────────────────
    TempoClock.default.tempo_(ana.bpm / 60);

    // ── Initialize per-partner state ──────────────────────────────────────────
    ana.partners.do { |p|
        p[\active]      = false;
        p[\lastMidi]    = nil;
        p[\currentBias] = ana.harmonicBias;
    };

    ana.routines         = [nil, nil, nil, nil];
    ana.firstFired       = false;
    ana.lastOnsetTime    = 0;
    ana.groupAmp         = 0.7;
    ana.groupAttackUntil = 0.0;
    ana.rhythmLock       = false;
    ana.dryMuted         = false;
    ana.libBPitches      = [];
    ana.libBBias         = ana.harmonicBias;

    // ── Groups ────────────────────────────────────────────────────────────────
    ana.grpRec    = Group.new(s);
    ana.grpVoice  = Group.after(ana.grpRec);
    ana.grpDry    = Group.after(ana.grpVoice);
    ana.grpMaster = Group.after(ana.grpDry);

    // ── Start persistent synths ───────────────────────────────────────────────
    ana.detectSyn = Synth(\anaDetect, [thresh: ana.onsetThreshold], ana.grpRec);

    ana.drySyn = Synth(\anaDry, [out: ana.mixBus.index, amp: ana.dryAmp], ana.grpDry);

    ana.masterSyn = Synth(\anaMaster, [
        busIn:       ana.mixBus.index,
        out:         0,
        reverbMix:   ana.reverbMix,
        reverbDecay: ana.reverbDecay,
        reverbSize:  ana.reverbSize,
        reverbDamp:  ana.reverbDamp,
    ], ana.grpMaster);

    if(ana.clickOn, {
        ana.clickSyn = Synth(\anaClick,
            [out: ana.cueOutChan, bpmBus: ana.bpmBus.index], ana.grpMaster);
        "Click active on output channel %".format(ana.cueOutChan).postln;
    });

    // ── OSC onset handler — first-note detection AND ongoing capture ──────────
    OSCdef(\anaOnset, { |msg|
        var amp     = msg[3];
        var freq    = msg[4];
        var hasFreq = msg[5];
        var now     = Main.elapsedTime;

        // ── First note: start the timeline ───────────────────────────────────
        if(ana.firstFired.not, {
            ana.firstFired = true;
            { "Anaerobes — first note. Seeding Library A...".postln; }.defer;

            // Compute Library A bias just before partners enter
            SystemClock.sched(ana.seedDur - 5, {
                var counts = Dictionary.new;
                var sorted, detected;
                ana.libA.keys.do { |m| var pc = m % 12; counts[pc] = (counts[pc] ? 0) + 1 };
                sorted   = counts.keys.asArray.sort { |a, b| counts[a] > counts[b] };
                detected = sorted.copyFromStart(min(7, sorted.size));
                if(detected.size >= 3) {
                    ana.harmonicBias = detected;
                    ana.partners.do { |p| p[\currentBias] = detected };
                    { "Library A bias: %".format(detected).postln; }.defer;
                };
                nil
            });

            // Partner entries
            ana.partnerEntryTimes.do { |t, i|
                SystemClock.sched(t, {
                    ana.startPartner.(i);
                    nil
                });
            };

            // Coord 0: group attack window (T=180s, coincides with P4 entry)
            SystemClock.sched(ana.coordTimes[0], {
                ana.groupAttackUntil = TempoClock.default.seconds + (TempoClock.default.beatDur * 4);
                nil
            });

            // Coord 1: forte swell (T=210s)
            SystemClock.sched(ana.coordTimes[1], {
                { "Coord — forte.".postln; }.defer;
                ana.groupAmp = 1.0;
                nil
            });

            // Coord 2: decelerando cue (T=225s)
            SystemClock.sched(ana.coordTimes[2], {
                ana.playCue.(\slowDown);
                SystemClock.sched(TempoClock.default.beatDur * 16, {
                    ana.tempoRamp.(ana.decelTargetBpm, ana.decelOverBars);
                    nil
                });
                nil
            });

            // Harmonic shift: voice cue then mute + seed Library B
            SystemClock.sched(ana.shiftCueTime, {
                ana.playCue.(\newHarmony);
                SystemClock.sched(TempoClock.default.beatDur * 16, {
                    { "Dry muted. Seeding Library B...".postln; }.defer;
                    ana.dryMuted   = true;
                    ana.drySyn.set(\amp, 0);
                    ana.recordLib  = ana.libB;
                    ana.libBPitches = [];

                    SystemClock.sched(TempoClock.default.beatDur * 4 * ana.shiftSeedBars, {
                        var counts = Dictionary.new;
                        var sorted, newBias;
                        ana.libBPitches.do { |pc| counts[pc] = (counts[pc] ? 0) + 1 };
                        sorted  = counts.keys.asArray.sort { |a, b| counts[a] > counts[b] };
                        newBias = sorted.copyFromStart(min(7, sorted.size));
                        if(newBias.isEmpty) { newBias = ana.harmonicBias };
                        ana.libBBias  = newBias;
                        ana.activeLib = ana.libB;
                        ana.dryMuted  = false;
                        ana.drySyn.set(\amp, ana.dryAmp);
                        ana.playCue.(\harmonyNow);
                        ana.updateBias.(newBias);
                        { "Library B active. Bias: %".format(newBias).postln; }.defer;
                        nil
                    });
                    nil
                });
                nil
            });

            // Coord 3: rhythmic lock (T=315s) — 4 bars of quarter-note pulse
            SystemClock.sched(ana.coordTimes[3], {
                { "Coord — rhythmic lock.".postln; }.defer;
                ana.rhythmLock = true;
                SystemClock.sched(TempoClock.default.beatDur * 16, {
                    ana.rhythmLock = false;
                    nil
                });
                nil
            });

            // Accelerando cue (T=370s)
            SystemClock.sched(ana.accelCueTime, {
                ana.playCue.(\speedUp);
                SystemClock.sched(TempoClock.default.beatDur * 16, {
                    ana.tempoRamp.(ana.accelTargetBpm, ana.accelOverBars);
                    nil
                });
                nil
            });

            // Return to Library A (T=407s)
            SystemClock.sched(ana.returnCueTime, {
                ana.playCue.(\returning);
                SystemClock.sched(TempoClock.default.beatDur * 16, {
                    ana.activeLib = ana.libA;
                    ana.recordLib = ana.libA;
                    ana.updateBias.(ana.harmonicBias);
                    { "Library A active.".postln; }.defer;
                    nil
                });
                nil
            });

            // Coord 4: piano drop (T=440s)
            SystemClock.sched(ana.coordTimes[4], {
                { "Coord — piano.".postln; }.defer;
                ana.groupAmp = 0.45;
                nil
            });

            // End cue (T = totalDur - 16 beats)
            SystemClock.sched(ana.totalDur - (TempoClock.default.beatDur * 16), {
                ana.playCue.(\endSoon);
                nil
            });

            // Final bar: stop routines, each partner plays one long note with 1-bar fade
            SystemClock.sched(ana.totalDur, {
                { "Final bar.".postln; }.defer;
                4.do { |i| ana.stopPartner.(i) };
                var barDurNow = TempoClock.default.beatDur * 4;
                4.do { |i|
                    var lib     = ana.activeLib;
                    var partner = ana.partners[i];
                    var keys    = lib.keys.asArray.select { |m|
                        (m >= partner[\regLow]) && (m <= partner[\regHigh])
                    };
                    if(keys.isEmpty) { keys = lib.keys.asArray };
                    if(keys.notEmpty, {
                        var midi = keys.choose;
                        var bufs = lib[midi];
                        if(bufs.notNil && bufs.notEmpty, {
                            Synth(\anaHit, [
                                out:    ana.mixBus.index,
                                bufnum: bufs.choose.bufnum,
                                amp:    ana.groupAmp * partner[\ampBase] * ana.partnerAmp,
                                pan:    partner[\pan],
                                atk:    0.005,
                                dec:    barDurNow - 0.1,
                                dist:   0.0,
                            ], ana.grpVoice);
                        });
                    });
                };
                nil
            });

            // Hard cutoff
            SystemClock.sched(ana.totalDur + (TempoClock.default.beatDur * 4), {
                { "Anaerobes — hard cutoff.".postln; }.defer;
                OSCdef(\anaOnset).free;
                ana.routines.do { |r| if(r.notNil, { r.stop }) };
                ana.bufPool.do(_.free);
                ana.cueBufs.do(_.free);
                ana.mixBus.free;
                ana.bpmBus.free;
                s.freeAll;
                nil
            });
        });

        // ── Ongoing note capture ──────────────────────────────────────────────
        if(ana.firstFired && ((now - ana.lastOnsetTime) > ana.onsetRefractory), {
            ana.lastOnsetTime = now;
            var buf   = ana.nextBuf.();
            var midiF = if((hasFreq > 0.5) && (freq > 40) && (freq < 3000), {
                ((freq / 440).log2 * 12 + 69).round.asInteger
            }, { nil });

            Synth(\anaCapture, [bufnum: buf.bufnum], ana.grpRec);

            if(midiF.notNil, {
                SystemClock.sched(ana.captureDur + 0.05, {
                    ana.addToLib.(buf, midiF, ana.recordLib);
                    if(ana.recordLib === ana.libB, {
                        ana.libBPitches = ana.libBPitches.add(midiF % 12);
                    });
                    { var na = ana.libA.size; var nb = ana.libB.size;
                      if((na + nb) % 5 == 0, {
                          "  Library A:% B:% pitches".format(na, nb).postln
                      });
                    }.defer;
                    nil
                });
            });
        });

    }, '/ana/onset');

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Anaerobes — running. Play guitar when ready.".postln;
    "Threshold: %. Click on output channel %.".format(ana.onsetThreshold, ana.cueOutChan).postln;
    "".postln;
    "Timeline from first note:".postln;
    "  0:00–1:30  Library A seeding — play wide range of notes".postln;
    "  1:30       P1 enters (low, long, contemplative)".postln;
    "  2:00       P2 enters (mid-low, melodic)".postln;
    "  2:30       P3 enters (mid-high, restless)".postln;
    "  3:00       Coord 1 — group attack, P4 enters (high, energetic)".postln;
    "  3:30       Coord 2 — forte swell, groupAmp → 1.0".postln;
    "  3:45       Voice: slow down in four bars → decelerando (66 BPM over 16 bars)".postln;
    "  4:20       Voice: record new harmony in four bars".postln;
    "  4:32       Dry muted, Library B seeding begins (8 bars)".postln;
    "  ~5:05      Library B ready — partners switch, dry returns".postln;
    "  5:15       Coord 3 — rhythmic lock (quarter pulse, 4 bars)".postln;
    "  6:10       Voice: speed up in four bars → accelerando (84 BPM over 12 bars)".postln;
    "  6:47       Voice: returning in four bars → Library A returns".postln;
    "  7:20       Coord 4 — piano, groupAmp → 0.45".postln;
    "  ~7:28      Voice: end of piece in four bars".postln;
    "  8:00       Final bar — all partners attack, 1-bar fade, hard cutoff".postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP (Cmd+Return to end cleanly)
// ─────────────────────────────────────────────────────────────────────────────
(
OSCdef(\anaOnset).free;
~ana.routines.do { |r| if(r.notNil, { r.stop }) };
~ana.bufPool.do(_.free);
~ana.cueBufs.do(_.free);
~ana.mixBus.free;
~ana.bpmBus.free;
s.freeAll;
"Anaerobes — stopped.".postln;
)
