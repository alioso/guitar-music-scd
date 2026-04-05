/*
Tryphon
Euclidean polyrhythm guitar quintet
SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)
  Click:  metronome → output 2+3 (headphones, requires Scarlett 4i4+)

  Server setup — put this in your SC startup file (File > Open startup file):
    s.options.inDevice  = "Scarlett 2i2 USB";   // adjust to your model
    s.options.outDevice = "Scarlett 2i2 USB";
    s.options.numOutputBusChannels = 4;          // for click to headphones

STRUCTURE (~7 min from first note)
  t=0s       First note → clock starts, 4-bar loop recorded (12s)
  t=12s      P1 enters — E(3,16)
  t=24s      P2 enters — E(4,11)
  t=36s      P3 enters — E(5,9)
  t=48s      P4 enters — E(6,13)    ← Cycle 1 full
  t=3m       P2–P4 drop. P1 holds old pattern. New loop re-recorded (12s).
  t=3m+12s   P1 switches to Cycle 2. P2–P4 re-enter staggered (every 12s).
  t=5m       P2–P4 drop. P1 holds. New loop re-recorded (12s).
  t=5m+12s   P1 switches to Cycle 3. P2–P4 re-enter staggered.
  t=6m+36s   P2–P4 drop → duo phase (input + P1 only)
  t=7m       Hard stop

EUCLIDEAN PATTERNS — 16th-note steps, prime N values
  LCM of 9,11,13 ≈ 28 min → patterns never realign within the piece.
  P1 uses N=16 (bar-aligned anchor, stays at every transition).
  Cycle 1: P1 E(3,16)  P2 E(4,11)  P3 E(5,9)   P4 E(6,13)
  Cycle 2: P1 E(4,16)  P2 E(5,11)  P3 E(6,9)   P4 E(7,13)
  Cycle 3: P1 E(5,16)  P2 E(7,11)  P3 E(7,9)   P4 E(9,13)

  Each euclidean hit plays 1 bar (~3s) of the recorded guitar loop, reading
  from the current loop phase at the moment of the hit. Overlapping washes
  from all partners create a guitar quintet texture — harmonic coherence
  is guaranteed because all partners read from the same source recording.

REQUIRES sc3-plugins for JPverb (brew install sc3-plugins)
  Fallback: GVerb (see master SynthDef comment)
*/


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION (Cmd+Return inside this block first)
// ─────────────────────────────────────────────────────────────────────────────
(
~trp = (
    bpm:     80,
    recBars: 4,     // loop buffer length in bars (4 bars = 12s at 80 BPM)

    // Euclidean patterns per partner per cycle — [k, n] (k hits in n 16th-note steps)
    // P1: bar-aligned (N=16), stays at every transition (simplest anchor)
    // P2–P4: prime N values → cycle lengths never realign within 7 min
    patterns: [
        [[3,16], [4,16], [5,16]],    // P1
        [[4,11], [5,11], [7,11]],    // P2
        [[5, 9], [6, 9], [7, 9]],    // P3
        [[6,13], [7,13], [9,13]],    // P4
    ],

    // Stereo positions (left to right)
    pans: [-0.7, -0.3, 0.3, 0.7],

    // Mix levels
    partnerAmp: 0.22,   // per hit — overlapping washes accumulate
    dryAmp:     0.58,   // live guitar passthrough level

    // Master reverb (JPverb — subtle, not too wet)
    reverbMix:   0.15,
    reverbDecay: 3.5,
    reverbSize:  1.1,
    reverbDamp:  0.5,

    // First-note detection
    threshold: 0.015,

    // Timing
    totalDur:      420,   // 7 min from first note
    endDropBefore:  24,   // seconds of duo (P1 + input) before hard stop

    // Click track (requires Scarlett 4i4+ — outputs 3+4 as headphones)
    clickOn:      true,
    clickOutChan: 2,      // SC output channel index (0-based → device channel 3)
);

// Derived timing
~trp.barDur    = 60 / ~trp.bpm * 4;               // 3.0s per bar
~trp.stepDur   = ~trp.barDur / 16;                // 0.1875s per 16th note
~trp.loopDur   = ~trp.barDur * ~trp.recBars;      // 12.0s loop buffer
~trp.buildStep = ~trp.barDur * 4;                 // 12.0s between partner entries

// Cycle transition times from first note (seconds)
~trp.cycleTimes = [180, 300];   // Cycle 1→2 at 3 min, Cycle 2→3 at 5 min

"Tryphon — config loaded".postln;
"  bpm=% | bar=% s | step=% s | loop=% s".format(
    ~trp.bpm,
    ~trp.barDur.round(0.001),
    ~trp.stepDur.round(0.001),
    ~trp.loopDur.round(0.01)).postln;
"  transitions at % s (% min) and % s (% min)".format(
    ~trp.cycleTimes[0], (~trp.cycleTimes[0] / 60).round(0.1),
    ~trp.cycleTimes[1], (~trp.cycleTimes[1] / 60).round(0.1)).postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START (Cmd+Return inside this block)
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var trp       = ~trp;
    var bufFrames = (s.sampleRate * trp.loopDur).ceil.asInteger;

    // ── Buffers & buses ───────────────────────────────────────────────────────
    // Three loop buffers — one per cycle, pre-allocated.
    // A new buffer is always recorded while P1 still reads the previous one,
    // so no buffer is ever overwritten while in active use.
    trp.bufs      = 3.collect { Buffer.alloc(s, bufFrames, 1) };
    trp.bufStart  = [0.0, 0.0, 0.0];   // Main.elapsedTime when each recording started
    trp.recSyns   = [nil, nil, nil];
    trp.routines  = [nil, nil, nil, nil];
    trp.mixBus    = Bus.audio(s, 2);

    s.sync;

    // ── Euclidean pattern generator (Bjorklund accumulator) ───────────────────
    // Distributes k hits as evenly as possible across n 16th-note steps.
    trp.euclidean = { |k, n|
        var pattern = [], bucket = 0;
        n.do {
            bucket = bucket + k;
            if(bucket >= n) { bucket = bucket - n; pattern = pattern.add(1) }
            { pattern = pattern.add(0) };
        };
        pattern
    };

    // ── Partner management ────────────────────────────────────────────────────
    // Starts (or restarts) one partner: spawns a Routine stepping through its
    // euclidean pattern at 16th-note rate, triggering \trpHit on each '1'.
    //
    // Buffer read position is anchored to the current loop phase at hit time,
    // so all partners on the same cycle buffer stay temporally coherent —
    // a partner that enters late reads the "right" moment in the loop.
    trp.startPartner = { |partnerIdx, cycleIdx|
        var spec     = trp.patterns[partnerIdx][cycleIdx];
        var k        = spec[0];
        var n        = spec[1];
        var pattern  = trp[\euclidean].(k, n);
        var bufnum   = trp.bufs[cycleIdx].bufnum;
        var amp      = trp.partnerAmp;
        var pan      = trp.pans[partnerIdx];
        var hitDur   = trp.barDur;
        var stepDur  = trp.stepDur;
        var loopDur  = trp.loopDur;
        var busIdx   = trp.mixBus.index;
        var grp      = trp.grpVoice;

        if(trp.routines[partnerIdx].notNil, {
            trp.routines[partnerIdx].stop;
        });

        trp.routines[partnerIdx] = Routine({
            var step = 0;
            loop {
                if(trp.alive && (pattern[step % n] == 1), {
                    // Read from the current position in the 4-bar loop
                    var elapsed  = Main.elapsedTime - trp.bufStart[cycleIdx];
                    var startPos = (elapsed % loopDur * s.sampleRate)
                                       .asInteger.clip(0, bufFrames - 1);
                    Synth(\trpHit, [
                        out:      busIdx,
                        bufnum:   bufnum,
                        startPos: startPos,
                        amp:      amp,
                        pan:      pan,
                        hitDur:   hitDur,
                    ], grp);
                });
                stepDur.wait;
                step = step + 1;
            };
        }).play(TempoClock.default);

        { "  P% → E(%,%) cycle %".format(partnerIdx + 1, k, n, cycleIdx + 1).postln; }.defer;
    };

    trp.stopPartner = { |partnerIdx|
        if(trp.routines[partnerIdx].notNil, {
            trp.routines[partnerIdx].stop;
            trp.routines[partnerIdx] = nil;
        });
    };

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Records guitar into buffer, stops when full (loop:0, doneAction:2).
    // Buffer sized for exactly loopDur seconds → self-terminates after 4 bars.
    SynthDef(\trpRec, { |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 0, doneAction: 2);
    }).add;

    // Amplitude detector — rising-edge only, fires /trp/firstNote once.
    SynthDef(\trpDetect, { |thresh=0.015|
        var amp   = Amplitude.kr(SoundIn.ar(0), attackTime: 0.005, releaseTime: 0.1);
        var above = amp > thresh;
        var trig  = above * (1 - Delay1.kr(above));
        SendReply.kr(trig, '/trp/firstNote', amp);
    }).add;

    // Per-euclidean-hit playback. Reads from startPos in the loop buffer,
    // loop:1 so playback wraps cleanly if startPos is near the buffer end.
    // 1-bar amplitude envelope (sine curve), self-frees after hitDur seconds.
    SynthDef(\trpHit, {
        |out=0, bufnum=0, startPos=0, amp=0.22, pan=0.0, hitDur=3.0|
        var env = EnvGen.kr(
            Env([0, 1, 1, 0], [0.005, hitDur * 0.83, hitDur * 0.17], curve: \sine),
            doneAction: 2);
        var sig = PlayBuf.ar(1, bufnum,
            BufRateScale.kr(bufnum), startPos: startPos, loop: 1);
        Out.ar(out, Pan2.ar(sig * env * amp, pan));
    }).add;

    // Dry guitar passthrough → mix bus
    SynthDef(\trpDry, { |out=0, amp=0.58|
        Out.ar(out, (SoundIn.ar(0) * amp).dup);
    }).add;

    // Master: mix bus → GVerb → clip → hardware out
    SynthDef(\trpMaster, {
        |busIn=0, out=0, reverbMix=0.15, reverbDecay=3.5, reverbDamp=0.5|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry[0], roomsize: 30,
            revtime: reverbDecay, damping: reverbDamp, drylevel: 0);
        var wet  = [verb[0], verb[1]];
        Out.ar(out, ((dry * (1 - reverbMix)) + (wet * reverbMix)).clip2(1.0));
    }).add;

    // Quarter-note click with bar-1 accent — PulseCount keeps beat/bar in sync
    SynthDef(\trpClick, { |out=2, bpm=80|
        var trig   = Impulse.kr(bpm / 60);
        var count  = PulseCount.kr(trig) % 4;
        var isDown = count < 1;
        var freq   = Select.kr(isDown, [880, 1200]);
        var sig    = SinOsc.ar(freq, 0, EnvGen.kr(Env.perc(0.001, 0.06), trig));
        Out.ar(out, sig.dup);
    }).add;

    s.sync;

    // ── Groups ────────────────────────────────────────────────────────────────
    trp.grpRec    = Group.new(s);
    trp.grpVoice  = Group.after(trp.grpRec);
    trp.grpDry    = Group.after(trp.grpVoice);
    trp.grpMaster = Group.after(trp.grpDry);

    // ── Start persistent synths ───────────────────────────────────────────────
    trp.detectSyn = Synth(\trpDetect, [thresh: trp.threshold], trp.grpRec);

    trp.drySyn    = Synth(\trpDry,
        [out: trp.mixBus.index, amp: trp.dryAmp], trp.grpDry);

    trp.masterSyn = Synth(\trpMaster, [
        busIn:       trp.mixBus.index,
        out:         0,
        reverbMix:   trp.reverbMix,
        reverbDecay: trp.reverbDecay,
        reverbSize:  trp.reverbSize,
        reverbDamp:  trp.reverbDamp,
    ], trp.grpMaster);

    if(trp.clickOn, {
        trp.clickSyn = Synth(\trpClick,
            [out: trp.clickOutChan, bpm: trp.bpm], trp.grpMaster);
        "Click active on output channel %".format(trp.clickOutChan).postln;
    });

    // ── State ─────────────────────────────────────────────────────────────────
    trp.firstFired = false;
    trp.alive      = true;

    // ── First-note handler ────────────────────────────────────────────────────
    OSCdef(\trpFirstNote, { |msg|
        if(trp.firstFired.not, {
            trp.firstFired = true;
            trp.detectSyn.free;

            { "Tryphon — first note. Recording loop (% bars / % s)..."
                .format(trp.recBars, trp.loopDur).postln; }.defer;

            // ── Intro: record buf[0], then build 4 partners one per 4 bars ──

            trp.bufStart[0] = Main.elapsedTime;
            trp.recSyns[0]  = Synth(\trpRec, [bufnum: trp.bufs[0]], trp.grpRec);

            SystemClock.sched(trp.loopDur, {
                if(trp.alive, {
                    { "Loop recorded. Intro build starting...".postln; }.defer;
                    trp[\startPartner].(0, 0);   // P1 — E(3,16)

                    SystemClock.sched(trp.buildStep, {
                        if(trp.alive, { trp[\startPartner].(1, 0) });   // P2 — E(4,11)
                        nil
                    });
                    SystemClock.sched(trp.buildStep * 2, {
                        if(trp.alive, { trp[\startPartner].(2, 0) });   // P3 — E(5,9)
                        nil
                    });
                    SystemClock.sched(trp.buildStep * 3, {
                        if(trp.alive, {
                            trp[\startPartner].(3, 0);   // P4 — E(6,13)
                            { "Cycle 1 — full texture.".postln; }.defer;
                        });
                        nil
                    });
                });
                nil
            });

            // ── Cycle 1 → 2 transition (T=180s) ─────────────────────────────

            SystemClock.sched(trp.cycleTimes[0], {
                if(trp.alive, {
                    { "\n─── Cycle 1→2 — P2–P4 dropped. P1 holds. Re-recording...".postln; }.defer;
                    [1, 2, 3].do { |i| trp[\stopPartner].(i) };

                    trp.bufStart[1] = Main.elapsedTime;
                    trp.recSyns[1]  = Synth(\trpRec, [bufnum: trp.bufs[1]], trp.grpRec);

                    SystemClock.sched(trp.loopDur, {
                        if(trp.alive, {
                            { "Cycle 2 — P1 switching, partners re-entering...".postln; }.defer;
                            trp[\startPartner].(0, 1);   // P1 → E(4,16)

                            SystemClock.sched(trp.buildStep, {
                                if(trp.alive, { trp[\startPartner].(1, 1) });   // P2
                                nil
                            });
                            SystemClock.sched(trp.buildStep * 2, {
                                if(trp.alive, { trp[\startPartner].(2, 1) });   // P3
                                nil
                            });
                            SystemClock.sched(trp.buildStep * 3, {
                                if(trp.alive, {
                                    trp[\startPartner].(3, 1);   // P4
                                    { "Cycle 2 — full texture.".postln; }.defer;
                                });
                                nil
                            });
                        });
                        nil
                    });
                });
                nil
            });

            // ── Cycle 2 → 3 transition (T=300s) ─────────────────────────────

            SystemClock.sched(trp.cycleTimes[1], {
                if(trp.alive, {
                    { "\n─── Cycle 2→3 — P2–P4 dropped. P1 holds. Re-recording...".postln; }.defer;
                    [1, 2, 3].do { |i| trp[\stopPartner].(i) };

                    trp.bufStart[2] = Main.elapsedTime;
                    trp.recSyns[2]  = Synth(\trpRec, [bufnum: trp.bufs[2]], trp.grpRec);

                    SystemClock.sched(trp.loopDur, {
                        if(trp.alive, {
                            { "Cycle 3 — P1 switching, partners re-entering...".postln; }.defer;
                            trp[\startPartner].(0, 2);   // P1 → E(5,16)

                            SystemClock.sched(trp.buildStep, {
                                if(trp.alive, { trp[\startPartner].(1, 2) });   // P2
                                nil
                            });
                            SystemClock.sched(trp.buildStep * 2, {
                                if(trp.alive, { trp[\startPartner].(2, 2) });   // P3
                                nil
                            });
                            SystemClock.sched(trp.buildStep * 3, {
                                if(trp.alive, {
                                    trp[\startPartner].(3, 2);   // P4
                                    { "Cycle 3 — full texture.".postln; }.defer;
                                });
                                nil
                            });
                        });
                        nil
                    });
                });
                nil
            });

            // ── Duo phase ────────────────────────────────────────────────────

            SystemClock.sched(trp.totalDur - trp.endDropBefore, {
                if(trp.alive, {
                    { "\n─── Duo — P2–P4 dropped. Input + P1 only.".postln; }.defer;
                    [1, 2, 3].do { |i| trp[\stopPartner].(i) };
                });
                nil
            });

            // ── Hard stop ────────────────────────────────────────────────────

            SystemClock.sched(trp.totalDur, {
                if(trp.alive, {
                    { "Tryphon — hard stop.".postln; }.defer;
                    trp.alive = false;
                    OSCdef(\trpFirstNote).free;
                    trp.routines.do { |r| if(r.notNil, { r.stop }) };
                    s.freeAll;
                    // Buffers and bus are freed server-side by s.freeAll.
                    // Block 3 handles SC language cleanup.
                });
                nil
            });

        });
    }, '/trp/firstNote');

    // ── Ready ─────────────────────────────────────────────────────────────────
    "".postln;
    "Tryphon — running. Play guitar when ready (threshold: %).".format(trp.threshold).postln;
    "Timeline from first note:".postln;
    "  +% s  : loop recorded, P1 enters E(3,16)".format(trp.loopDur.round(1)).postln;
    "  +% s  : P2 enters E(4,11)".format((trp.loopDur + trp.buildStep).round(1)).postln;
    "  +% s  : P3 enters E(5,9)".format((trp.loopDur + (trp.buildStep * 2)).round(1)).postln;
    "  +% s  : P4 enters E(6,13)  — Cycle 1 full".format((trp.loopDur + (trp.buildStep * 3)).round(1)).postln;
    "  +% s  : Cycle 1→2 transition".format(trp.cycleTimes[0]).postln;
    "  +% s  : Cycle 2→3 transition".format(trp.cycleTimes[1]).postln;
    "  +% s  : duo phase (P1 + input)".format(trp.totalDur - trp.endDropBefore).postln;
    "  +% s  : hard stop".format(trp.totalDur).postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP (Cmd+Return to end cleanly)
// ─────────────────────────────────────────────────────────────────────────────
(
~trp.alive = false;
OSCdef(\trpFirstNote).free;
~trp.routines.do { |r| if(r.notNil, { r.stop }) };
if(~trp.bufs.notNil, { ~trp.bufs.do { |b| if(b.notNil, { b.free }) } });
if(~trp.mixBus.notNil, { ~trp.mixBus.free });
s.freeAll;
"Tryphon — stopped.".postln;
)
