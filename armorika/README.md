# Armorika

Generative FM bed for live guitar. Duration ~5 min.

## Concept

Seven instrument streams (organ, bass, string, flute, chime, brass, granular guitar) run continuously in natural minor. Each note played on guitar shifts the key center of all streams simultaneously — they pick up the new root at their own pace, so harmonic changes cascade through the ensemble rather than snapping at once. The piece moves through three harmonic passages (natural minor → Dorian → natural minor → major → fade). The guitarist is heard through ring modulation, a resonator bank, and an FM shadow on each detected pluck.

## Architecture

```
Guitar → pitch detection
              ↓
         root pitch update → 7 instrument streams (always running)
              ↓
         FM shadow (fires on each pluck)
              ↓
         resonator bank (7 Resonz filters tuned to current mode)
              ↓
         mix bus → reverb → out
```

## Bed instruments

| Stream | Character | Register | Pace |
|---|---|---|---|
| bedOrgan | additive sines | wide, 3-octave | slow |
| bedBass | warm FM, saturation | anchored low | medium |
| bedString | detuned sine pair, natural beating | mid | medium |
| bedFlute | clean FM | mid-high | fast |
| bedChime | bright FM bell | mid-high accent | fast, sparse |
| bedBrass | punchy FM | mid | medium |
| bedGranGuitar | TGrains from live buffer, pitched to root | wide | slow |

Default mode: **natural minor** `[0, 2, 3, 5, 7, 8, 10]`.

## Guitar resonator

Seven narrow-bandwidth `Resonz` filters tuned to the 7 mode degrees one octave above the current root, driven by live guitar energy — responds to playing intensity, not pitch. Each resonator drifts independently. Sounds like bowed metal tines. Frequencies update whenever the root or mode changes.

## Structure

| Time from first note | Event |
|---|---|
| 0:00 | First note → streams enter one by one, 8s apart. Full ensemble at ~48s. |
| 2:00 | Dorian mode — minor with raised 6th; brass and chime pulled back; organ, string, flute boosted. |
| 3:00 | Natural minor returns, full texture restored. |
| 4:00 | Major mode — bright lift; same instrument balance as harmonious passages. |
| 5:00 | Streams stop; master fades to silence over 20s. |

## Guitar gesture vocabulary

- **Hold a single pitch** — bed converges on one key, full ensemble builds depth
- **Slow stepwise motion** — gradual key drift, streams lag behind at different rates
- **Large leaps** — sudden harmonic displacement; use as punctuation
- **Silence** — bed continues in last key; absence is expressive

## Guitar signal path

Three layers heard on top of the bed:
- **Ring mod** (`armorikaRingMod`): guitar multiplied by a sine carrier tuned to the current root. Playing the root gives octave doubling; other notes produce harmonically related combination tones.
- **Resonator bank** (`armorikaResonator`): 7 narrow filters tuned to the mode, excited by guitar energy. Responds to playing intensity.
- **FM shadow** (`armorikaVoiceA`): short FM burst on each detected pluck.

## Key levels

| Parameter | Value |
|---|---|
| `bedAmp` | 0.42 |
| `resAmp` | 0.28 |
| `ringAmp` | 0.20 |
| `shadowAmp` | 0.08 |
| `revMix` | 0.32 |

## How to run

1. Open `armorika.scd`
2. Evaluate **Block 1** (config)
3. Evaluate **Block 2** (start) — streams start on server boot; detection arms immediately
4. Play — first detected note starts the structure clock and brings in the first stream
5. Evaluate **Block 3** to stop early

## Tweaking (all in Block 1)

- `bedAmp` / `resAmp` / `ringAmp` / `shadowAmp` — mix balance between layers
- `revMix` / `revRoom` — master reverb wetness and size
- `mode` — harmonic world; change the pitch-class array for different colours
- `thresh` — onset detection sensitivity
- `refractory` — minimum gap between pitch detections (default 90ms)
- Per-stream `restProb` in `streamDefs` — density of each instrument (higher = sparser)
- Per-stream `stepMin` / `stepMax` — pace range of each instrument
