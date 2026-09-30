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
  SC detects onsets from the guitarist, cuts ~3s of audio (attack included) out
  of a rolling input buffer, and indexes it by the pitch it hears once the note
  has settled. Four partner voices draw from this library to create independent
  generative counterpoint. Two libraries: A (opening harmony) and B (mid-section
  harmonic shift).

TIMING
  Partners, click and voice cues all run on one private TempoClock, so the
  click follows the tempo ramps and every coordinated event lands on a bar line.
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
// BLOCK 1 — CONFIGURATION (Cmd+Return inside this block first)
// ─────────────────────────────────────────────────────────────────────────────
(
~ana = (
    bpm:      76,
    seedDur:  90,       // seconds of Library A seeding (harmonic bias follows you until then)
    totalDur: 480,      // 8 min from first note (final bar lands on the first bar line after)

    // Partner entry times from first note (seconds)
    // P1 at 45s, P2 at 70s, P3 at 95s, P4 at 120s — they join while you are still seeding
    partnerEntryTimes: [45, 70, 95, 120],

    // Coordination events from first note (seconds) — each lands on the next bar line
    // [0]=180 group attack (all active partners hit the downbeat together)
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

    // Default harmonic bias (D natural minor pitch classes) — used until you
    // have played at least 3 pitch classes
    harmonicBias: [2, 4, 5, 7, 9, 10, 0],

    // Partner definitions (4 entries, indexed 0–3)
    // rhythmWeights index ~durations: whole, half, quarter, 8th-triplet, 8th, 16th-triplet, 16th
    // P1: contemplative, low register, long notes, lots of rest
    // P2: melodic, mid-low, medium values
    // P3: restless, mid-high, triplet-leaning
    // P4: energetic, high, fast values, rarely rests
    partners: [
        (regLow:40, regHigh:60, rhythmWeights:[3,4,2,0,1,0,0], ringProb:0.85, playProb:0.40, ampBase:0.90, pan:-0.6),
        (regLow:52, regHigh:69, rhythmWeights:[1,3,4,1,2,1,0], ringProb:0.65, playProb:0.55, ampBase:0.85, pan:-0.25),
        (regLow:62, regHigh:79, rhythmWeights:[0,1,3,3,3,3,1], ringProb:0.50, playProb:0.60, ampBase:0.80, pan:0.25),
        (regLow:69, regHigh:90, rhythmWeights:[0,0,1,1,3,4,4], ringProb:0.20, playProb:0.95, ampBase:1.0,  pan:0.60),
    ],

    // Library
    bufPoolSize:      160,    // capture buffers; evicted takes are recycled
    captureDur:       3.0,
    maxTakesPerPitch: 3,
    onsetThreshold:   0.015,  // amplitude gate (and first-note trigger)
    onsetSens:        0.4,    // Onsets threshold — lower catches softer legato attacks
    onsetRefractory:  0.25,   // min seconds between captures
    pitchDelay:       0.08,   // seconds after the attack before the pitch is read
    preRoll:          0.01,   // seconds kept before the detected attack

    // Mix levels
    partnerAmp:   1.5,
    dryAmp:       0.55,
    reverbMix:    0.16,
    reverbRoom:   40,
    reverbDecay:  3.8,
    reverbDamp:   0.45,

    // Cue output
    cueOutChan: 2,              // SC output channel for click + voice (0-indexed)
    cueVoice:   "Samantha",     // macOS TTS voice

    clickOn: true,
    latency: 0.05,              // server scheduling latency (keeps click and partners tight)
);

// Derived values
~ana.barDur      = 60 / ~ana.bpm * 4;
~ana.beatDur     = 60 / ~ana.bpm;
~ana.durations   = [4, 2, 1, 2/3, 0.5, 1/3, 0.25];   // beats: whole→16th
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
    var sr        = s.sampleRate;
    var capFrames = (sr * ana.captureDur).ceil.asInteger;

    // ── Clocks ────────────────────────────────────────────────────────────────
    // mclock: musical time (beats) — partners, click, cues, tempo ramps
    // tclock: seconds from first note — the structural timeline
    // Stopping both cancels everything this piece has scheduled.
    ana.mclock = TempoClock(ana.bpm / 60);
    ana.tclock = TempoClock(1);

    // ── Allocations ───────────────────────────────────────────────────────────

    // Rolling input buffer — every capture is cut out of it after the fact
    ana.ringBuf = Buffer.alloc(s, (sr * (ana.captureDur + 5)).ceil.asInteger, 1);

    // Capture buffers. A buffer is either free, or owned by exactly one library take.
    ana.bufPool  = Array.fill(ana.bufPoolSize, { Buffer.alloc(s, capFrames, 1) });
    ana.freeBufs = List.newFrom(ana.bufPool);

    // Note libraries: Dictionary midiNote -> Array of Buffers
    ana.libA = Dictionary.new;
    ana.libB = Dictionary.new;
    ana.activeLib = ana.libA;
    ana.recordLib = ana.libA;
    ana.pcCountsA = Dictionary.new;   // pitch-class → number of captures (bias detection)
    ana.pcCountsB = Dictionary.new;

    ana.mixBus = Bus.audio(s, 2);
    ana.posBus = Bus.control(s, 1);

    // Voice cue buffers
    ana.cueBufs = Dictionary.new;

    s.sync;

    // ── Voice cue pre-rendering ───────────────────────────────────────────────
    // Generate AIFF files via macOS say (blocking), then load as SC buffers
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
        ("say -v " ++ ana.cueVoice ++ " -o " ++ path.shellQuote ++ " " ++ text.shellQuote).systemCmd;
    };
    [\slowDown, \speedUp, \newHarmony, \harmonyNow, \returning, \endSoon].do { |key|
        ana.cueBufs[key] = Buffer.read(s, "/tmp/ana_cue_" ++ key ++ ".aiff");
    };

    s.sync;

    // ── Helper functions ──────────────────────────────────────────────────────

    // Run fn on the music clock, `beats` after the next bar line
    ana.atBar = { |beats, fn|
        ana.mclock.schedAbs(ana.mclock.nextBar + beats, { fn.value; nil });
    };

    // Schedule a server event `latency` ahead so it lands exactly on the beat
    ana.bundle = { |fn| s.makeBundle(ana.latency, fn) };

    // Add a capture to a library; an evicted take goes back to the free list once
    // any partner note still reading it has finished
    ana.addToLib = { |buf, midiNote, lib|
        var arr = lib[midiNote] ?? { [] };
        if(arr.size >= ana.maxTakesPerPitch) {
            var old = arr[0];
            arr = arr.drop(1);
            ana.tclock.sched(ana.captureDur + 2, { ana.freeBufs.add(old); nil });
        };
        lib[midiNote] = arr.add(buf);
    };

    // Copy captureDur of audio from the ring buffer (wrap-aware) into buf
    ana.copyFromRing = { |buf, startFrame|
        var ringFrames = ana.ringBuf.numFrames;
        var start = startFrame.round.asInteger % ringFrames;
        var first = min(capFrames, ringFrames - start);
        ana.ringBuf.copyData(buf, 0, start, first);
        if(first < capFrames) { ana.ringBuf.copyData(buf, first, 0, capFrames - first) };
    };

    // Most frequent pitch classes (up to 7); nil if fewer than 3
    ana.biasFrom = { |counts|
        var sorted = counts.keys.asArray.sort { |a, b| counts[a] > counts[b] };
        if(sorted.size >= 3) { sorted.copyFromStart(min(7, sorted.size) - 1) } { nil };
    };

    // Play a voice cue to headphone output
    ana.playCue = { |key|
        if(ana.cueBufs[key].notNil and: { (ana.cueBufs[key].numFrames ? 0) > 0 }, {
            ana[\bundle].({
                Synth(\anaVoice, [out: ana.cueOutChan, bufnum: ana.cueBufs[key].bufnum], ana.grpMaster);
            });
        });
    };

    // Smooth tempo ramp over N bars, one step per beat (the click follows automatically)
    ana.tempoRamp = { |targetBpm, overBars|
        var startTempo = ana.mclock.tempo;
        var endTempo   = targetBpm / 60;
        var totalBeats = overBars * 4;
        ana.rampRoutine = Routine({
            totalBeats.do { |i|
                var t = (i + 1) / totalBeats;
                ana.mclock.tempo_(startTempo + ((endTempo - startTempo) * t));
                1.wait;
            };
            { "  Tempo: % BPM".format((ana.mclock.tempo * 60).round(0.1)).postln; }.defer;
        }).play(ana.mclock, quant: 1);
    };

    // Update harmonic bias with staggered lag per partner
    ana.updateBias = { |newBias|
        ana.partners.do { |p, i|
            ana.mclock.sched(ana.harmonicLag[i], { p[\currentBias] = newBias; nil });
        };
        { "  Bias updated: %".format(newBias).postln; }.defer;
    };

    // Pick a note for one partner from the active library (nil if nothing fits)
    ana.pickNote = { |partner|
        var lib     = ana.activeLib;
        var libKeys = lib.keys.asArray;
        var candidates, biased, lastMidi, intervalWeights, weights, chosenMidi;

        if(libKeys.isEmpty) { nil } {
            // Candidates in register range
            candidates = libKeys.select { |m|
                (m >= partner[\regLow]) && (m <= partner[\regHigh])
            };
            if(candidates.isEmpty) { candidates = libKeys };

            // Filter by harmonic bias if enough matches
            biased = candidates.select { |m| partner[\currentBias].includes(m % 12) };
            if(biased.size >= 2) { candidates = biased };

            // Avoid immediate repetition
            lastMidi = partner[\lastMidi];
            if(lastMidi.notNil && (candidates.size > 1), {
                candidates = candidates.reject { |m| m == lastMidi };
            });

            // Interval weighting
            intervalWeights = [0.0, 1.8, 1.6, 1.4, 0.9, 0.7, 0.5,
                               0.5, 0.6, 0.4, 0.3, 0.3, 0.8, 0.3, 0.2, 0.2, 0.1];
            weights = if(lastMidi.notNil, {
                candidates.collect { |m|
                    intervalWeights.at((m - lastMidi).abs.min(16))
                }
            }, {
                Array.fill(candidates.size, 1.0)
            });
            if(weights.sum <= 0) { weights = Array.fill(candidates.size, 1.0) };

            chosenMidi = candidates[weights.normalizeSum.windex];
            partner[\lastMidi] = chosenMidi;
            lib[chosenMidi].choose
        };
    };

    // Note decision algorithm — returns an Event with play/rest decision
    ana.decide = { |partnerIdx|
        var partner = ana.partners[partnerIdx];
        var doPlay  = ana.rhythmLock || (1.0.rand < partner[\playProb]);
        var result, buf, durBeats, ring, dec, amp;

        if(doPlay.not, {
            result = (play: false, restBeats: ana.restDurs[ana.restWeights.normalizeSum.windex]);
        }, {
            buf = ana[\pickNote].(partner);
            if(buf.isNil, {
                result = (play: false, restBeats: 1.0);
            }, {
                durBeats = if(ana.rhythmLock, { 1.0 }, {
                    ana.durations[partner[\rhythmWeights].normalizeSum.windex]
                });
                ring = 1.0.rand < partner[\ringProb];
                dec  = if(ring, { durBeats * ana.mclock.beatDur * 0.90 }, { 0.15 });
                amp  = ana.groupAmp * partner[\ampBase] * ana.partnerAmp * rrand(0.75, 1.0);
                result = (play: true, buf: buf, durBeats: durBeats, dec: dec, amp: amp);
            });
        });
        result
    };

    ana.hit = { |buf, amp, pan, dec|
        ana[\bundle].({
            Synth(\anaHit, [
                out: ana.mixBus.index, bufnum: buf.bufnum,
                amp: amp, pan: pan, atk: 0.04, dec: dec,
            ], ana.grpVoice);
        });
    };

    // Every active partner (or all, when `all` is true) strikes together, now
    ana.groupHit = { |dec, all=false|
        ana.partners.do { |partner|
            var buf;
            if(all || partner[\active]) {
                buf = ana[\pickNote].(partner);
                if(buf.notNil) {
                    ana[\hit].(buf, ana.groupAmp * partner[\ampBase] * ana.partnerAmp,
                        partner[\pan], dec);
                };
            };
        };
    };

    // Spawn a Routine on the music clock for one partner (starts on a beat)
    ana.startPartner = { |partnerIdx|
        var pan = ana.partners[partnerIdx][\pan];

        ana.partners[partnerIdx][\active] = true;
        ana.routines[partnerIdx] !? _.stop;

        ana.routines[partnerIdx] = Routine({
            loop {
                var d, frac;
                // During the rhythmic lock, snap back onto the beat grid
                if(ana.rhythmLock) {
                    frac = ana.mclock.beats.frac;
                    if((frac > 0.001) && (frac < 0.999)) { (1 - frac).wait };
                };
                d = ana[\decide].(partnerIdx);
                if(d[\play], {
                    ana[\hit].(d[\buf], d[\amp], pan, d[\dec]);
                    d[\durBeats].wait;
                }, {
                    d[\restBeats].wait;
                });
            };
        }).play(ana.mclock, quant: 1);

        { "  P% active".format(partnerIdx + 1).postln; }.defer;
    };

    // Stop one partner's Routine
    ana.stopPartner = { |partnerIdx|
        ana.routines[partnerIdx] !? _.stop;
        ana.routines[partnerIdx] = nil;
        ana.partners[partnerIdx][\active] = false;
    };

    // Free everything this piece owns (Block 3 and the automatic hard cutoff)
    ana.cleanup = {
        if(ana.cleanedUp.not) {
            ana.cleanedUp = true;
            OSCdef(\anaOnset).free;
            ana.mclock.stop;
            ana.tclock.stop;
            ana.grpRoot.free;
            ana.bufPool.do(_.free);
            ana.cueBufs.do(_.free);
            ana.ringBuf.free;
            ana.mixBus.free;
            ana.posBus.free;
        };
    };

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Ring writer — records the input continuously and publishes its write
    // position on a control bus (kept separate from Pitch: sharing a SynthDef
    // with BufWr stops Pitch from tracking)
    SynthDef(\anaRing, { |ringBuf=0, posBus=0|
        var phase = Phasor.ar(0, 1, 0, BufFrames.kr(ringBuf));
        BufWr.ar(SoundIn.ar(0), ringBuf, phase);
        Out.kr(posBus, A2K.kr(phase));
    }).add;

    // Listener — detects attacks (spectral onsets for legato, amplitude rise for
    // notes from silence), then reports [amp, freq, hasFreq, ringPosAtAttack]
    // once the pitch has settled
    SynthDef(\anaListen, { |posBus=0, thresh=0.015, sens=0.4, pitchDelay=0.08|
        var sig     = SoundIn.ar(0);
        var amp     = A2K.kr(Amplitude.ar(sig, attackTime: 0.005, releaseTime: 0.1));
        var above   = Schmidt.kr(amp, thresh * 0.5, thresh);   // hysteresis: no re-trigger on decay
        var rise    = above * (1 - Delay1.kr(above));
        var onset   = Onsets.kr(FFT(LocalBuf(512), sig), sens, \rcomplex) * above;
        var hold    = Trig1.kr((rise + onset) > 0, 0.1);
        var trig    = hold * (1 - Delay1.kr(hold));
        var pos     = Latch.kr(In.kr(posBus), trig);
        var pitch   = Pitch.kr(sig, ampThreshold: 0.01, median: 7);
        SendReply.kr(TDelay.kr(trig, pitchDelay), '/ana/onset',
            [amp, pitch[0], pitch[1], pos]);
    }).add;

    // Per-note playback — two-segment envelope
    SynthDef(\anaHit, {
        |out=0, bufnum=0, amp=0.24, pan=0.0, atk=0.005, dec=1.0|
        var env = EnvGen.kr(Env([0, 1, 0], [atk, dec], curve: [0, -3]), doneAction: 2);
        var sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 0);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    // Dry guitar passthrough to mix bus
    SynthDef(\anaDry, { |out=0, amp=0.55|
        Out.ar(out, (SoundIn.ar(0) * Lag.kr(amp, 0.05)).dup);
    }).add;

    // Plays a voice cue buffer to headphone output (mono → stereo)
    SynthDef(\anaVoice, { |out=2, bufnum=0, amp=0.88|
        var sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 0, doneAction: 2);
        Out.ar(out, sig.dup * amp);
    }).add;

    // Mix bus → GVerb → limiter → hardware out
    SynthDef(\anaMaster, {
        |busIn=0, out=0, reverbMix=0.16, reverbRoom=40, reverbDecay=3.8, reverbDamp=0.45|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry.sum * 0.5, roomsize: reverbRoom,
            revtime: reverbDecay, damping: reverbDamp, drylevel: 0);
        var sig  = (dry * (1 - reverbMix)) + (verb * reverbMix);
        Out.ar(out, Limiter.ar(sig, 0.95, 0.003));
    }).add;

    // One click — kick on the downbeat, rim shot on beats 2–4
    SynthDef(\anaClick, { |out=2, down=0|
        var kick = SinOsc.ar(80) * EnvGen.kr(Env.perc(0.001, 0.12)) * 0.5;
        var rim  = HPF.ar(WhiteNoise.ar, 900) * EnvGen.kr(Env.perc(0.001, 0.04)) * 0.3;
        Line.kr(0, 0, 0.2, doneAction: 2);
        Out.ar(out, Select.ar(down, [rim, kick]).dup);
    }).add;

    s.sync;

    // ── Initialize per-partner state ──────────────────────────────────────────
    ana.partners.do { |p|
        p[\active]      = false;
        p[\lastMidi]    = nil;
        p[\currentBias] = ana.harmonicBias;
    };

    ana.routines      = [nil, nil, nil, nil];
    ana.firstFired    = false;
    ana.cleanedUp     = false;
    ana.seeding       = true;
    ana.lastOnsetTime = 0;
    ana.groupAmp      = 0.7;
    ana.rhythmLock    = false;
    ana.biasA         = ana.harmonicBias;

    // ── Groups (all inside one root group — cleanup frees only this piece) ────
    ana.grpRoot   = Group.new(s);
    ana.grpRec    = Group.head(ana.grpRoot);
    ana.grpVoice  = Group.after(ana.grpRec);
    ana.grpDry    = Group.after(ana.grpVoice);
    ana.grpMaster = Group.after(ana.grpDry);

    // ── Start persistent synths ───────────────────────────────────────────────
    ana.ringSyn   = Synth(\anaRing, [ringBuf: ana.ringBuf, posBus: ana.posBus], ana.grpRec);
    ana.listenSyn = Synth(\anaListen, [
        posBus:     ana.posBus,
        thresh:     ana.onsetThreshold,
        sens:       ana.onsetSens,
        pitchDelay: ana.pitchDelay,
    ], ana.grpRec, \addToTail);

    ana.drySyn = Synth(\anaDry, [out: ana.mixBus.index, amp: ana.dryAmp], ana.grpDry);

    ana.masterSyn = Synth(\anaMaster, [
        busIn:       ana.mixBus.index,
        out:         0,
        reverbMix:   ana.reverbMix,
        reverbRoom:  ana.reverbRoom,
        reverbDecay: ana.reverbDecay,
        reverbDamp:  ana.reverbDamp,
    ], ana.grpMaster);

    if(ana.clickOn, {
        Routine({
            loop {
                var down = (ana.mclock.beatInBar.round(1) % 4) == 0;
                ana[\bundle].({
                    Synth(\anaClick, [out: ana.cueOutChan, down: down.binaryValue], ana.grpMaster);
                });
                1.wait;
            };
        }).play(ana.mclock, quant: 1);
        "Click active on output channel %".format(ana.cueOutChan).postln;
    });

    // ── Timeline — started by the first note ──────────────────────────────────
    ana.startTimeline = {
        var t = ana.tclock;

        // Partner entries
        ana.partnerEntryTimes.do { |time, i|
            t.sched(time, { ana[\startPartner].(i); nil });
        };

        // End of Library A seeding — freeze its bias
        t.sched(ana.seedDur, {
            ana.seeding = false;
            ana.biasA = ana[\biasFrom].(ana.pcCountsA) ? ana.harmonicBias;
            ana.partners.do { |p| p[\currentBias] = ana.biasA };
            { "Library A sealed. Bias: %".format(ana.biasA).postln; }.defer;
            nil
        });

        // Coord 0: group attack — every active partner on the same downbeat
        t.sched(ana.coordTimes[0], {
            ana[\atBar].(0, {
                { "Coord — group attack.".postln; }.defer;
                ana[\groupHit].(ana.mclock.beatDur * 0.9);
            });
            nil
        });

        // Coord 1: forte swell
        t.sched(ana.coordTimes[1], {
            { "Coord — forte.".postln; }.defer;
            ana.groupAmp = 1.0;
            nil
        });

        // Coord 2: decelerando — cue on a bar line, ramp starts four bars later
        t.sched(ana.coordTimes[2], {
            ana[\atBar].(0,  { ana[\playCue].(\slowDown) });
            ana[\atBar].(16, {
                { "Decelerando.".postln; }.defer;
                ana[\tempoRamp].(ana.decelTargetBpm, ana.decelOverBars);
            });
            nil
        });

        // Harmonic shift: cue, four bars later mute + seed Library B, then switch
        t.sched(ana.shiftCueTime, {
            ana[\atBar].(0, { ana[\playCue].(\newHarmony) });
            ana[\atBar].(16, {
                { "Dry muted. Seeding Library B...".postln; }.defer;
                ana.drySyn.set(\amp, 0);
                ana.recordLib = ana.libB;
                ana.mclock.sched(4 * ana.shiftSeedBars, {
                    var newBias = ana[\biasFrom].(ana.pcCountsB) ? ana.biasA;
                    if(ana.libB.isEmpty) {
                        { "Library B is empty — staying on Library A.".postln; }.defer;
                    } {
                        ana.activeLib = ana.libB;
                    };
                    ana.drySyn.set(\amp, ana.dryAmp);
                    ana[\playCue].(\harmonyNow);
                    ana[\updateBias].(newBias);
                    { "Library B active (% pitches). Bias: %".format(ana.libB.size, newBias).postln; }.defer;
                    nil
                });
            });
            nil
        });

        // Coord 3: rhythmic lock — 4 bars of quarter-note pulse, bar-aligned
        t.sched(ana.coordTimes[3], {
            ana[\atBar].(0, {
                { "Coord — rhythmic lock.".postln; }.defer;
                ana.rhythmLock = true;
            });
            ana[\atBar].(16, { ana.rhythmLock = false });
            nil
        });

        // Accelerando
        t.sched(ana.accelCueTime, {
            ana[\atBar].(0,  { ana[\playCue].(\speedUp) });
            ana[\atBar].(16, {
                { "Accelerando.".postln; }.defer;
                ana[\tempoRamp].(ana.accelTargetBpm, ana.accelOverBars);
            });
            nil
        });

        // Return to Library A
        t.sched(ana.returnCueTime, {
            ana[\atBar].(0, { ana[\playCue].(\returning) });
            ana[\atBar].(16, {
                ana.activeLib = ana.libA;
                ana.recordLib = ana.libA;
                ana[\updateBias].(ana.biasA);
                { "Library A active.".postln; }.defer;
            });
            nil
        });

        // Coord 4: piano drop
        t.sched(ana.coordTimes[4], {
            { "Coord — piano.".postln; }.defer;
            ana.groupAmp = 0.45;
            nil
        });

        // Ending: cue on a bar line four bars before totalDur, final bar four bars
        // later (all partners strike beat 1 together), hard cutoff one bar after
        t.sched(ana.totalDur - (ana.mclock.beatDur * 16), {
            ana[\atBar].(0, { ana[\playCue].(\endSoon) });
            ana[\atBar].(16, {
                { "Final bar.".postln; }.defer;
                4.do { |i| ana[\stopPartner].(i) };
                ana[\groupHit].(ana.mclock.beatDur * 4 - 0.1, true);
            });
            ana[\atBar].(20, {
                { "Anaerobes — hard cutoff.".postln; }.defer;
                AppClock.sched(ana.latency + 0.05, { ana[\cleanup].value; nil });
            });
            nil
        });
    };

    // ── OSC onset handler — first-note detection AND ongoing capture ──────────
    OSCdef(\anaOnset, { |msg|
        var freq    = msg[4];
        var hasFreq = msg[5];
        var pos     = msg[6];
        var now     = Main.elapsedTime;
        var midiF, buf, lib, counts;

        // ── First note: start the timeline ───────────────────────────────────
        if(ana.firstFired.not, {
            ana.firstFired = true;
            { "Anaerobes — first note. Seeding Library A...".postln; }.defer;
            ana[\startTimeline].value;
        });

        // ── Capture ──────────────────────────────────────────────────────────
        if((now - ana.lastOnsetTime) > ana.onsetRefractory, {
            ana.lastOnsetTime = now;
            midiF = if((hasFreq > 0.5) && (freq > 40) && (freq < 3000), {
                freq.cpsmidi.round.asInteger
            }, { nil });

            if(midiF.notNil, {
                buf = ana.freeBufs.pop;
                if(buf.isNil, {
                    { "  (capture pool full — note skipped)".postln; }.defer;
                }, {
                    lib    = ana.recordLib;
                    counts = if(lib === ana.libB, { ana.pcCountsB }, { ana.pcCountsA });
                    // Wait until the whole capture window is in the ring, then cut it
                    ana.tclock.sched(ana.captureDur - ana.pitchDelay + 0.15, {
                        ana[\copyFromRing].(buf, pos - (ana.preRoll * sr));
                        ana[\addToLib].(buf, midiF, lib);
                        counts[midiF % 12] = (counts[midiF % 12] ? 0) + 1;
                        // While seeding, the Library A bias follows what you play
                        if(ana.seeding && (lib === ana.libA)) {
                            ana[\biasFrom].(counts) !? { |b|
                                ana.partners.do { |p| p[\currentBias] = b };
                            };
                        };
                        { var na = ana.libA.size; var nb = ana.libB.size;
                          if((na + nb) % 5 == 0, {
                              "  Library A:% B:% pitches".format(na, nb).postln
                          });
                        }.defer;
                        nil
                    });
                });
            });
        });

    }, '/ana/onset');

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Anaerobes — running. Play guitar when ready.".postln;
    "Threshold: %. Click on output channel %.".format(ana.onsetThreshold, ana.cueOutChan).postln;
    "".postln;
    "Timeline from first note (events land on the next bar line):".postln;
    "  0:00–1:30  Library A seeding — play a wide range of notes".postln;
    "  0:45       P1 enters (low, long, contemplative)".postln;
    "  1:10       P2 enters (mid-low, melodic)".postln;
    "  1:35       P3 enters (mid-high, restless)".postln;
    "  1:30       Library A sealed — bias frozen".postln;
    "  2:00       P4 enters (high, energetic)".postln;
    "  3:00       Coord 1 — group attack on a downbeat".postln;
    "  3:30       Coord 2 — forte swell, groupAmp → 1.0".postln;
    "  3:45       Voice: slow down in four bars → decelerando (66 BPM over 16 bars)".postln;
    "  4:20       Voice: record new harmony in four bars".postln;
    "  ~4:32      Dry muted, Library B seeding begins (8 bars)".postln;
    "  ~5:05      Library B ready — partners switch, dry returns".postln;
    "  5:15       Coord 3 — rhythmic lock (quarter pulse, 4 bars)".postln;
    "  6:10       Voice: speed up in four bars → accelerando (84 BPM over 12 bars)".postln;
    "  6:47       Voice: returning in four bars → Library A returns".postln;
    "  7:20       Coord 4 — piano, groupAmp → 0.45".postln;
    "  ~7:48      Voice: end of piece in four bars".postln;
    "  ~8:00      Final bar — all partners strike beat 1, 1-bar fade, hard cutoff".postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP (Cmd+Return to end cleanly)
// ─────────────────────────────────────────────────────────────────────────────
(
~ana[\cleanup].value;
"Anaerobes — stopped.".postln;
)
