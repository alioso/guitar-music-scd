# Chimera

Ambient guitar — granular floor, harmonic synthesis, shimmer reverb. Duration ~12 min.

## Concept

The guitarist establishes a harmonic center through bowing and swelling. SC detects the pitch, locks the root, and builds a four-voice synthesis floor tuned to root / 5th / octave / flat-7th. A granular layer made of the live guitar blurs beneath the surface. In-key melodic playing triggers a shimmer reverb that slowly dissolves notes into the ambient floor. The piece evolves across a 12-minute arc and fades autonomously.

## Structure

| Time from first sound | Event |
|---|---|
| 0:00 | Timer starts; granular seeding begins (barely perceptible) |
| ~1–2 min | Root locks after 3 confirmed swells — floor voices bloom one by one |
| ~4 min | All 4 floor voices fully present |
| 6 min | Mid-section: reverb expands 4.5→8s, octave-voice LFO doubles, grains stretch 1.2→2.5s |
| 10 min | Fade begins — voices drop out one by one |
| ~11:30 | Root voice alone |
| ~12:20 | Silence — evaluate Block 3 to stop cleanly |

## Floor voices

| Voice | Interval | LFO period | Pan |
|---|---|---|---|
| V1 | root | 47 s | −0.8 (near full left) |
| V2 | perfect 5th | 61 s | +0.8 (near full right) |
| V3 | octave | 83 s | −0.4 (half left) |
| V4 | flat 7th (minor 7th) | 103 s | +0.4 (half right) |

LFO periods are prime-ish — voices never align, so the texture is always in motion without ever repeating. Floor amplitude never drops to zero (minimum 15%), ensuring continuous immersion.

## Granular layer

TGrains reads random positions from a 30s rolling capture buffer. The floor is literally made of the guitarist's own bowing and swelling, smeared over 1–2.5s grains. Swells trigger lazy nudges (4–20s random delay) that briefly increase grain density, then return to base.

## Shimmer reverb

In-key notes (Aeolian scale on locked root) → PitchShift up one octave + octave+fifth → long JPverb (9s decay, high diffusion). Chromatic notes pass through dry only. The shimmer dissolves melodic material into the ambient floor.

## Key levels

| Parameter | Value |
|---|---|
| `floorAmp` | 0.28 per voice |
| `granAmp` | 0.11 base |
| `dryAmp` | 0.52 |
| `shimmerAmp` | 0.32 |
| `reverbMix` (master) | 0.18, ramps to 8s decay at mid-section |
| `guitarReverbMix` | 0.32, 2.5s decay (separate from floor) |

## Root detection

- 3 confirmed swells (slow amplitude envelope + pitch confidence) vote by majority
- Pitch normalized to 130–260 Hz (C3–C4 range) regardless of octave played
- Scale: Aeolian (natural minor) — used for shimmer gating only

## Reverb

Uses **JPverb** from sc3-plugins (`brew install sc3-plugins`). GVerb fallback commented in source.

## How to run

1. Open `chimera.scd`
2. Evaluate **Block 1** (config) — `Cmd+Return` inside the block
3. Evaluate **Block 2** (start)
4. Play guitar — bow or swell 3 sustained notes to lock root
5. Continue playing — melodic material feeds shimmer, swells feed floor
6. Piece fades autonomously from 10 min
7. Evaluate **Block 3** when silence is complete

## Tweaking (all in Block 1)

- `swellsNeeded` — number of swells to confirm root (default 3)
- `voiceEntryDelays` — stagger between floor voice entries after root lock
- `midShiftTime` — when space expansion occurs (default 360s)
- `grainDensity` — base granular density (grains/second)
- `shimmerDecay` — reverb tail on melodic path (default 9s)
- `fadeDur` / `totalDur` — timing of fade and full arc
