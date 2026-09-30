# Coronal

Feedback resonance network for live guitar. Duration ~7 min.

## Concept

Seven CombL delay lines (97–443 ms, prime-derived) form a feedback network. Each line is slow-chorus-drifted by an independent LFO — the modes beat against each other at rates that never align. Guitar amplitude modulates the feedback gain in real time: soft touch keeps the system in stable resonance; loud playing pushes it toward the edge of instability, where the lines ring for tens of seconds. No pitch detection. Touch is the compositional gesture.

The piece has three acts: excitation (prime the resonators), sustain (network self-runs), dissolution (feedback stops; the network rings out in its own physics). There is no fade button.

## Structure

| Time from first note | Event |
|---|---|
| 0:00 | First note → EXCITATION. Play freely. |
| 0:00–2:30 | Feedback gain ramps 0.15 → 0.84. CombL decay ramps 3.0 → 8.0 s. |
| 2:30 | SUSTAINING. Network self-runs. Barely play. |
| 2:30–5:00 | Peak feedback gain (0.84 base + up to 0.08 touch boost). |
| 5:00 | DISSOLVING. Do not play. |
| 5:00–7:00 | Feedback gain ramps 0.84 → 0. Delay lines ring out on their own 8 s decay. |
| 7:00 | Natural silence — evaluate Block 3 to stop. |

## Delay network

| Line | Delay (ms) | LFO rate (mHz) | Pan |
|---|---|---|---|
| 1 | 97 | 11 | −0.88 |
| 2 | 137 | 17 | −0.55 |
| 3 | 181 | 13 | −0.22 |
| 4 | 239 | 19 | 0.0 |
| 5 | 307 | 23 | +0.22 |
| 6 | 389 | 9 | +0.55 |
| 7 | 443 | 27 | +0.88 |

Delay times are prime-derived — the modes never fall into rhythmic alignment. LFO rates are incommensurable — no two lines drift in sync. Each line is `tanh`-clipped before re-entering the feedback path.

## Feedback gain

The feedback gain sets the **loop gain of every line**: how much of a sound survives one trip around it. Each comb already feeds back according to its decay time; the external path adds only what is needed on top to reach the feedback gain (nothing, when the comb's own decay is already longer — so a line never rings shorter than the CombL decay). 1.0 would sustain forever; below it, everything dies away.

| Source | Range |
|---|---|
| `baseGain` (arc) | 0.15 at start → 0.84 at peak |
| Touch boost (amplitude) | 0 → 0.08 (guitar amp 0–0.10) |
| Hard ceiling | 0.94 (server-side `clip`) |

What that means for the ring (time to fall 60 dB) of the shortest and longest lines at peak (CombL decay 8 s):

| Feedback gain | 97 ms line | 443 ms line |
|---|---|---|
| 0.84 (peak, soft touch) | ~8 s (comb decay) | ~18 s |
| 0.92 (peak + full touch) | ~8 s | ~37 s |
| 0.94 (ceiling) | ~11 s | ~49 s |

Touch matters most on the long lines — that is where loud playing is heard as a longer, heavier bloom.

The edge zone is 0.88–0.94. During Act 1 the system stays below it. During Act 2 a sustained loud attack pushes into it — that near-instability is the piece. If it rings too long, release all strings immediately.

## Key levels

| Parameter | Value |
|---|---|
| `dryAmp` | 0.70 (guitar entering the network — no dry bypass) |
| `outGain` | 3.0 (master output from network) — set it at sound check |
| `reverbMix` | 0.40 |
| `reverbDecay` | 5.0 s |
| `threshold` | 0.012 |

The network is never allowed to run away, so its loudness depends on how hard you drive it: set `outGain` at sound check with your real guitar level. A limiter (0.95) on the master catches peaks.

## How to run

1. Open `coronal.scd`
2. Evaluate **Block 1** (config)
3. Evaluate **Block 2** (start)
4. Play guitar — first note above threshold fires the arc
5. Act 1 (0–2:30): play freely, any timbre or register, to prime the network
6. Act 2 (2:30–5:00): barely play — slow bows, isolated taps, long swells
7. Act 3 (5:00–7:00): do not play; let the network die
8. Evaluate **Block 3** when silence is complete

## Emergency controls (evaluate in REPL during performance)

Force delay lines to drain quickly if Act 3 is too slow:
```supercollider
~cor.netSyn.set(\decayTime, 1.0)
```

Cut feedback immediately (the lines then decay on their own comb decay):
```supercollider
~cor.netSyn.set(\baseGain, 0.0)
```

## Tweaking (all in Block 1)

- `gainStart` / `gainPeak` — feedback gain range across Act 1
- `touchMax` — maximum amplitude-driven gain boost (default 0.08)
- `gainCeiling` — hard limit on feedback gain (default 0.94; keep it below 1.0)
- `decayStart` / `decayPeak` — CombL decay arc (seconds)
- `act1Dur` / `act2Dur` / `act3Dur` / `totalDur` — timing of each act and the end cue
- `outGain` — overall network level
- `reverbMix` / `reverbDecay` — GVerb on the mix bus
- `rampStep` — how often (seconds) the arc routine updates gain/decay
