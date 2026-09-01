/*
External
Bare server boot for an external audio source (synth, DAW, etc. via BlackHole)
— no audio processing beyond a straight monitor passthrough. Use this instead
of one of the guitar pieces when you want to drive the visuals from something
other than the guitar rig, e.g. practicing with a synth over headphones with
no guitar plugged in.

SETUP
  Input/Output: "SCD EXTERNAL" — an Aggregate Device (built in Audio MIDI
    Setup) combining BlackHole 2ch (clock source, input) with External
    Headphones (output). CoreAudio needs input and output on one shared-clock
    aggregate; two independent devices for in vs. out fail to boot
    (kAudioDevicePropertyStreamFormat error). See external/README.md for how
    to rebuild this aggregate if it doesn't exist on this machine.

  SC runs a straight passthrough monitor only (no processing). Jerrican/your
  synth's output should go to BlackHole 2ch alone; SC echoes that signal back
  out to your headphones so you can still hear it, while also reading its
  amplitude for visuals/visual-osc.scd to pick up.

USAGE
  1. In your synth/DAW, set output to BlackHole 2ch.
  2. Evaluate Block 1 (boot).
  3. Run visuals/visual-osc.scd Block A to start streaming amplitude to Python.
  4. Play — you should hear the monitor passthrough in your headphones.
  5. Evaluate Block 2 (stop). Evaluate visual-osc.scd Block B too.
*/


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 1 — BOOT
// ─────────────────────────────────────────────────────────────────────────────
(
s.options.inDevice  = "SCD EXTERNAL";
s.options.outDevice = "SCD EXTERNAL";
s.reboot;
s.waitForBoot({
    SynthDef(\extMonitor, {
        Out.ar(0, SoundIn.ar(0) ! 2);
    }).add;

    s.sync;

    ~extMonitor = Synth(\extMonitor);

    "External — server booted on SCD EXTERNAL (BlackHole in, headphones out).".postln;
    "Next: run visuals/visual-osc.scd Block A, then play.".postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK 2 — STOP
// ─────────────────────────────────────────────────────────────────────────────
(
s.quit;
"External — stopped.".postln;
)
