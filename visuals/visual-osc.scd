/*
Visual Bridge
Standalone OSC sender — run this AFTER your piece has booted (Block 2 evaluated).
Streams live guitar amplitude to Python on port 57200 at 30 fps.
Works alongside any piece in this repo; does not interfere with their audio graph.

Usage:
  1. Boot your piece (run its Block 2)
  2. Evaluate Block A below to start sending
  3. Launch grain-still.py in a terminal
  4. Evaluate Block B to stop
*/


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK A — START
// ─────────────────────────────────────────────────────────────────────────────
(
~vis = ();
~vis.addr = NetAddr("127.0.0.1", 57200);

s.waitForBoot({
    SynthDef(\visBridge, {
        var sig, amp;
        sig = SoundIn.ar(0);
        amp = Amplitude.kr(sig, attackTime: 0.005, releaseTime: 0.3);
        SendReply.kr(Impulse.kr(30), '/vis/amp', [amp]);
    }).add;

    s.sync;

    ~vis.syn = Synth(\visBridge);

    OSCdef(\visAmp, { |msg|
        ~vis.addr.sendMsg('/amplitude', msg[3]);
    }, '/vis/amp');

    "Visual bridge active — sending amplitude to Python on port 57200 at 30 fps".postln;
});
)


// ─────────────────────────────────────────────────────────────────────────────
// BLOCK B — STOP
// ─────────────────────────────────────────────────────────────────────────────
(
OSCdef(\visAmp).free;
~vis.syn.free;
"Visual bridge stopped".postln;
)
