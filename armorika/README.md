# Armorika

Generative FM bed for live guitar. Duration ~5 min.

## Concept

Seven instrument streams (organ, bass, string, flute, chime, brass, granular guitar) run continuously. The **structure** owns the mode — natural minor → Dorian → natural minor → major → fade. The **guitar** owns the root: each note you play moves the key center of all streams to that note, and they pick it up at their own pace (each on its next note), so harmonic changes cascade through the ensemble rather than snapping at once. When your recent notes clearly sit in the current mode on one root, the key center locks to that root instead of following every note. The guitarist is heard through ring modulation, a resonator bank, and an FM shadow on each detected pluck.

## Architecture

```
Guitar → attack + pitch detection
              ↓
         key center update → 7 instrument streams (mode set by the structure)
              ↓
         FM shadow (fires on each pluck)
              ↓
         resonator bank (7 Resonz filters tuned to current root + mode)
              ↓
         mix bus → reverb → limiter → out
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
| bedGranGuitar | TGrains from the last second of live input, transposed from the note you last played to the stream's scale degree | wide | slow |

## Key center

- Each detected note sets the key center to that note.
- SC keeps your last 10 pitch classes. Once they include 5+ distinct ones and all fit the current mode on one root — agreed across your last 4 notes — the key center locks to that root (`Key center locked: N` in the post window). It stays there until your playing leaves it.
- The mode never comes from the guitar: the passages below always hold.

## Guitar resonator

Seven narrow-bandwidth `Resonz` filters tuned to the 7 mode degrees one octave above the current root, driven by live guitar energy — responds to playing intensity, not pitch. Each resonator drifts independently. Sounds like bowed metal tines. Frequencies update whenever the root or mode changes.

## Structure

| Time from first note | Event |
|---|---|
| 0:00 | First note → streams enter one by one, 8s apart. Full ensemble at ~48s. Natural minor. |
| 2:00 | Dorian — minor with raised 6th; brass and chime pulled back; organ, string, flute boosted; ring mod and shadow pulled back. |
| 3:00 | Natural minor returns, full texture restored. |
| 4:00 | Major — bright lift; same instrument balance as the Dorian passage. |
| 5:00 | Streams stop; master fades to silence over 20s. |

## Guitar gesture vocabulary

- **Hold a single pitch** — bed converges on one key, full ensemble builds depth
- **Slow stepwise motion** — gradual key drift, streams lag behind at different rates
- **Large leaps** — sudden harmonic displacement; use as punctuation
- **Play in the mode** — a few bars of scale-wise playing lock the key center
- **Silence** — bed continues in last key; absence is expressive

## Guitar signal path

Three layers heard on top of the bed:
- **Ring mod** (`armorikaRingMod`): guitar multiplied by a sine carrier tuned to the current root. Playing the root gives octave doubling; other notes produce harmonically related combination tones.
- **Resonator bank** (`armorikaResonator`): 7 narrow filters tuned to the mode, excited by guitar energy. Responds to playing intensity.
- **FM shadow** (`armorikaVoiceA`): short FM burst on each detected pluck.

Notes are detected from spectral onsets (so legato notes count) or a rise from silence; the pitch is read 80 ms after the attack, once it has settled, and notes the tracker isn't confident about are ignored.

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
3. Evaluate **Block 2** (start) — guitar layers are live immediately; detection arms
4. Play — first detected note starts the structure clock and brings in the first stream
5. The piece fades by itself at 5:00; evaluate **Block 3** to clean up (or to stop early)

## Tweaking (all in Block 1)

- `bedAmp` / `resAmp` / `ringAmp` / `shadowAmp` — mix balance between layers
- `revMix` / `revRoom` — master reverb wetness and size
- `minor` / `dorian` / `major` — the pitch sets used by the structure
- `passageTimes` / `fadeSecs` / `streamGap` — structure timing
- `thresh` / `onsetSens` — note detection sensitivity
- `refractory` — minimum gap between notes (default 90ms)
- Per-stream `restProb` in `streamDefs` — density of each instrument (higher = sparser)
- Per-stream `stepMin` / `stepMax` — pace range of each instrument
