/*
Fan Fiction
Steve Reich-style phasing guitar piece
SuperCollider 3.14.1

SETUP
  Input:  guitar → Scarlett input 0 (mono)
  Output: stereo output 0+1 (speakers)
  Optional: metronome → output 2+3 (headphones, requires Scarlett 4i4+)

  Server setup — put this in your SC startup file (File > Open startup file):
    s.options.inDevice  = "Scarlett 2i2 USB";   // adjust to your model name
    s.options.outDevice = "Scarlett 2i2 USB";
    s.options.numOutputBusChannels = 4;          // for metronome headphone routing

STRUCTURE
  First note detected → timer starts
  +8 bars             → 4 voices fade in slowly over 8 bars (sine curve)
  +16 bars            → full mix begins archive recording
  +16+64 bars (~2:55) → archive loops to end of piece, live input no longer needed

VOICES
  G1: rate locked 1.0,           pan -1.0 (full left)
  G2: ±0.8% over 12min cycle,    pan -0.5 (half left)
  G3: ±1.0% over 9min cycle,     pan  0.5 (half right)
  G4: ±0.6% over 15min cycle,    pan  1.0 (full right)

REQUIRES sc3-plugins for JPverb (brew install sc3-plugins)
  Fallback: GVerb is used if JPverb not available (see master section)
*/

// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — CONFIGURATION (Cmd+Return inside this block first)
// ─────────────────────────────────────────────────────────────────────────────
(
~ff = (
    bpm:           110,
    loopBars:      2,      // loop buffer = 2 bars (~4.4s)
    entryBars:     8,      // bars after first note → voices start fading in
    fadeBars:      8,      // bars for fade-in (sine curve, feels gradual)
    recBars:       16,     // bars after first note → archive recording starts
    archBars:      64,     // bars to record (~2:20 of material, total ~2:55 to loop)
    threshold:     0.015,  // first-note amplitude threshold (0..1)
    dryAmp:        0.65,   // dry guitar in mix
    voiceAmp:      0.52,   // per-voice level — 4 voices equal presence with dry

    voices: [
        // lfoDepth=0 → locked rate, no phase drift
        (lfoDepth: 0.000, lfoHz: 1/720,   pan: -1.0),  // G1 full left
        (lfoDepth: 0.008, lfoHz: 1/720,   pan: -0.5),  // G2 half left,  12min cycle
        (lfoDepth: 0.010, lfoHz: 1/540,   pan:  0.5),  // G3 half right,  9min cycle
        (lfoDepth: 0.006, lfoHz: 1/900,   pan:  1.0),  // G4 full right, 15min cycle
    ],

    // Reverb
    reverbMix:     0.07,   // 0=dry 1=wet — very subtle, just space not wash
    reverbSize:    1.2,    // room size
    reverbDecay:   4.5,    // decay in seconds
    reverbDamp:    0.4,    // high-freq damping

    // Metronome (optional — requires Scarlett 4i4+ with outputs 3+4 as headphones)
    metronomeOn:   false,  // set true to enable click to headphones
    clickOutChan:  2,      // SC output channel for click L (0-indexed, so ch 3 on device)
);

// Derived timing
~ff.barDur    = 60 / ~ff.bpm * 4;
~ff.loopDur   = ~ff.barDur * ~ff.loopBars;
~ff.entryDur  = ~ff.barDur * ~ff.entryBars;
~ff.fadeDur   = ~ff.barDur * ~ff.fadeBars;
~ff.recDur    = ~ff.barDur * ~ff.recBars;
~ff.archDur   = ~ff.barDur * ~ff.archBars;
~ff.totalDur  = ~ff.recDur + ~ff.archDur;

"Fan Fiction — config loaded".postln;
"  bar=% s | loop=% s | entry=% s | fade=% s".format(
    ~ff.barDur.round(0.01), ~ff.loopDur.round(0.01),
    ~ff.entryDur.round(0.01), ~ff.fadeDur.round(0.01)).postln;
"  archive starts at % s, ends at % s (~% min)".format(
    ~ff.recDur.round(1), ~ff.totalDur.round(1),
    (~ff.totalDur / 60).round(0.1)).postln;
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — START (Cmd+Return inside this block)
// ─────────────────────────────────────────────────────────────────────────────
(
s.waitForBoot({
    var ff = ~ff;

    // ── Buffers & buses ───────────────────────────────────────────────────────
    ff.loopBuf = Buffer.alloc(s,
        (s.sampleRate * ff.loopDur).ceil.asInteger, 1);
    ff.archBuf = Buffer.alloc(s,
        (s.sampleRate * ff.archDur).ceil.asInteger, 2);
    ff.mixBus  = Bus.audio(s, 2);

    s.sync;

    // ── SynthDefs ─────────────────────────────────────────────────────────────

    // Records guitar into loop buffer continuously (always looping)
    SynthDef(\ffRec, { |bufnum|
        RecordBuf.ar(SoundIn.ar(0), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 1);
    }).add;

    // One loop voice — gate 1 triggers fade-in via Env.asr (sine curve)
    SynthDef(\ffVoice, {
        |out=0, bufnum, gate=0, fadeSecs=17.0,
         lfoDepth=0.0, lfoHz=0.001, pan=0.0, voiceAmp=0.5|
        var env  = EnvGen.kr(
            Env.asr(fadeSecs, 1.0, 2.0, curve: \sine), gate);
        var rate = 1.0 + (SinOsc.kr(lfoHz) * lfoDepth);
        var sig  = PlayBuf.ar(1, bufnum,
                       rate * BufRateScale.kr(bufnum), loop: 1);
        Out.ar(out, Pan2.ar(sig * env * voiceAmp, pan));
    }).add;

    // Dry guitar passthrough
    SynthDef(\ffDry, { |out=0, amp=0.65|
        Out.ar(out, (SoundIn.ar(0) * amp).dup);
    }).add;

    // Amplitude detector — fires OSC on first rising edge
    SynthDef(\ffDetect, { |thresh=0.015|
        var amp   = Amplitude.kr(SoundIn.ar(0),
                        attackTime: 0.005, releaseTime: 0.1);
        var above = amp > thresh;
        var trig  = above * (1 - Delay1.kr(above));
        SendReply.kr(trig, '/ff/firstNote', amp);
    }).add;

    // Records stereo mix bus to archive buffer (one-shot, no loop)
    SynthDef(\ffArchRec, { |bufnum, busIn=0|
        RecordBuf.ar(In.ar(busIn, 2), bufnum,
            recLevel: 1.0, preLevel: 0.0, loop: 0);
    }).add;

    // Plays archive buffer, looping forever
    SynthDef(\ffArchPlay, { |out=0, bufnum|
        var sig = PlayBuf.ar(2, bufnum,
                      BufRateScale.kr(bufnum), loop: 1);
        Out.ar(out, sig.clip2(1.0));
    }).add;

    // Master: mix bus → GVerb reverb → clip → hardware out
    SynthDef(\ffMaster, { |busIn=0, out=0, reverbMix=0.22, reverbDecay=4.5, reverbDamp=0.4|
        var dry  = In.ar(busIn, 2);
        var verb = GVerb.ar(dry[0], roomsize: 30,
            revtime: reverbDecay, damping: reverbDamp, drylevel: 0);
        var wet  = [verb[0], verb[1]];
        Out.ar(out, ((dry * (1-reverbMix)) + (wet * reverbMix)).clip2(1.0));
    }).add;

    // Optional metronome click to headphone output (requires Scarlett 4i4+)
    SynthDef(\ffClick, { |out=2, bpm=110|
        var trig = Impulse.kr(bpm / 60);
        var beat = Impulse.kr(bpm / 60 * 4);   // downbeat
        var sig  = SinOsc.ar(
            Select.kr(trig > beat, [880, 1200]), 0,
            EnvGen.kr(Env.perc(0.001, 0.05), trig)
        );
        Out.ar(out, sig.dup);
    }).add;

    s.sync;

    // ── Groups ────────────────────────────────────────────────────────────────
    ff.grpRec    = Group.new(s);
    ff.grpVoice  = Group.after(ff.grpRec);
    ff.grpDry    = Group.after(ff.grpVoice);
    ff.grpMaster = Group.after(ff.grpDry);

    // ── Start synths ──────────────────────────────────────────────────────────
    ff.recSyn  = Synth(\ffRec, [bufnum: ff.loopBuf], ff.grpRec);
    ff.detectSyn = Synth(\ffDetect, [thresh: ff.threshold], ff.grpRec);

    ff.voiceSyns = ff.voices.collect({ |v|
        Synth(\ffVoice, [
            out:       ff.mixBus.index,
            bufnum:    ff.loopBuf,
            gate:      0,
            fadeSecs:  ff.fadeDur,
            lfoDepth:  v[\lfoDepth],
            lfoHz:     v[\lfoHz],
            pan:       v[\pan],
            voiceAmp:  ff.voiceAmp,
        ], ff.grpVoice);
    });

    ff.drySyn    = Synth(\ffDry,
        [out: ff.mixBus.index, amp: ff.dryAmp], ff.grpDry);
    ff.masterSyn = Synth(\ffMaster, [
        busIn:       ff.mixBus.index,
        out:         0,
        reverbMix:   ff.reverbMix,
        reverbSize:  ff.reverbSize,
        reverbDecay: ff.reverbDecay,
        reverbDamp:  ff.reverbDamp,
    ], ff.grpMaster);

    if(ff.metronomeOn, {
        ff.clickSyn = Synth(\ffClick,
            [out: ff.clickOutChan, bpm: ff.bpm], ff.grpMaster);
        "Metronome active on output channel %".format(ff.clickOutChan).postln;
    });

    // ── First note handler ────────────────────────────────────────────────────
    ff.firstFired = false;

    OSCdef(\ffFirstNote, { |msg|
        if(ff.firstFired.not, {
            ff.firstFired = true;
            ff.detectSyn.free;

            { "First note! Voices enter in % bars (% sec)."
                .format(ff.entryBars, ff.entryDur.round(0.1)).postln; }.defer;

            // +8 bars: gate all 4 voices open (fade-in via Env.asr over fadeDur)
            SystemClock.sched(ff.entryDur, {
                { "Voices fading in over % bars...".format(ff.fadeBars).postln; }.defer;
                ff.voiceSyns.do({ |syn| syn.set(\gate, 1) });
                nil;
            });

            // +16 bars: start archive recording
            SystemClock.sched(ff.recDur, {
                { "Archive recording (% bars = % sec)..."
                    .format(ff.archBars, ff.archDur.round(1)).postln; }.defer;

                ff.archRecSyn = Synth(\ffArchRec, [
                    bufnum: ff.archBuf,
                    busIn:  ff.mixBus.index,
                ], ff.grpMaster);

                // +16+64 bars: stop live, switch to archive loop
                SystemClock.sched(ff.archDur, {
                    { "Archive complete — looping. Guitar no longer needed.".postln; }.defer;

                    ff.archRecSyn.free;
                    ff.recSyn.free;
                    ff.voiceSyns.do(_.free);
                    ff.drySyn.free;
                    if(ff.clickSyn.notNil, { ff.clickSyn.free });

                    // Route archive through mix bus so master reverb stays active
                    ff.archPlaySyn = Synth(\ffArchPlay, [
                        out:    ff.mixBus.index,
                        bufnum: ff.archBuf,
                    ], ff.grpVoice);
                    nil;
                });
                nil;
            });
        });
    }, '/ff/firstNote');

    "".postln;
    "Fan Fiction — running. Play guitar when ready.".postln;
    "Amplitude threshold: %. Cmd+. or Block 3 to stop.".format(ff.threshold).postln;
    "Timeline from first note:".postln;
    "  +% bars (% s): voices fade in over % bars".format(
        ff.entryBars, ff.entryDur.round(1), ff.fadeBars).postln;
    "  +% bars (% s): archive recording starts".format(
        ff.recBars, ff.recDur.round(1)).postln;
    "  +% bars (% s): live → loop (guitar done)".format(
        ff.recBars + ff.archBars, ff.totalDur.round(1)).postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 3 — STOP (Cmd+Return to end cleanly)
// ─────────────────────────────────────────────────────────────────────────────
(
OSCdef(\ffFirstNote).free;
~ff.loopBuf.free;
~ff.archBuf.free;
~ff.mixBus.free;
s.freeAll;
"Fan Fiction — stopped.".postln;
)
