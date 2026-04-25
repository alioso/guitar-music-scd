# Armorika

Inspired by Frank Zappa's *Amnerica* (Civilization Phaze III, 1994).

A generative Synclavier-style bed triggered and conducted by live guitar. The guitar does not play *with* the bed — it *commands* it.

---

## Architecture

```
Guitar → pitch detection
              ↓
         root pitch update → 7 FM bed streams (always running)
              ↓
         soft FM shadow (echoes each pluck)
              ↓
         resonator bank (7 Resonz filters tuned to current mode,
              excited by live guitar energy)
              ↓
         mix bus → reverb → limiter → out
```

### Bed instruments
| Stream | Character | Register | Pace |
|---|---|---|---|
| bedOrgan | additive sines, organ/pipe | wide, 3-octave range | slow |
| bedBass | warm FM, sub-octave | anchored low | medium |
| bedString | detuned sines, slow attack | mid | medium |
| bedFlute | clean low-modIndex FM | mid-high | fast |
| bedChime | bright FM bell | mid-high accent | fast, sparse |
| bedBrass | high modIndex FM, punchy | mid | medium |
| bedGranGuitar | TGrains from live buffer, pitched to root | wide | slow |

Default mode: **natural minor** `[0, 2, 3, 5, 7, 8, 10]`.

### Guitar resonator
Seven narrow-bandwidth `Resonz` filters tuned to the 7 mode degrees one octave above the current root. Driven by live guitar energy — responds to playing intensity, not pitch. Each resonator has a slow independent drift (LFNoise1) and a fixed stereo position. Sounds like bowed metal tines or singing bowls. Frequencies update whenever the root or mode changes.

---

## Performance

### Structure (all times from first detected note)

| Time | Event |
|---|---|
| 0:00 | First note → bed instruments enter one by one, 8s apart (organ → bass → string → flute → chime → brass → gran guitar). Full ensemble ~48s in. |
| 2:00 | **Harmonious passage 1** — Dorian mode (minor with sweet 6th); brass+chime near-silent; organ/string/flute boosted; ring mod pulled back. |
| 3:00 | Natural minor returns, full texture restored. |
| 4:00 | **Harmonious passage 2** — major mode (bright lift); same instrument balance as passage 1. |
| 5:00 | Streams stop, master fades to silence over 20s. |

### Starting the piece
- Boot, then play your first note. The bed starts and the structure clock begins.
- The first ~50 seconds are sparse — let it build.

### What the guitar does
- **Each note shifts the key center** of all 6 streams simultaneously. Streams pick up the new root on their next step — key changes feel gradual because each stream has its own pace.
- **Slow, deliberate playing** = the bed shifts in large harmonic steps. Dramatic.
- **Fast melodic playing** = root updates rapidly, bed becomes harmonically unstable, dense. Use sparingly.
- **Staying on one note or one chord area** = the bed locks into that key and builds depth. This is the most powerful gesture.

### Gesture vocabulary
- **Hold a single pitch** → bed converges on one key, full orchestral density builds
- **Slow stepwise motion** → gradual key drift, streams lag behind at different rates
- **Large leaps** → sudden harmonic displacement, disorienting, use as punctuation
- **Silence** → bed continues in last key, guitar absence becomes expressive

### What the guitar sounds like
Three layers on top of the bed:
- **Ring mod** (`\armorikaRingMod`): dry guitar multiplied by a sine carrier tuned to the current root. Creates sum and difference tones — when you play the root you get octave doubling, other notes produce harmonically "wrong" but related overtones. Goes through the master reverb.
- **Resonator bank** (`\armorikaResonator`): 7 narrow filters tuned to the mode, excited by guitar energy. Responds to intensity, not pitch.
- **FM shadow** (`\armorikaVoiceA`): short FM burst on each detected pluck.

---

## Tuning knobs (config block)

| Parameter | Effect |
|---|---|
| `bedAmp` | overall bed volume |
| `resAmp` | resonator bank level (metal tines) |
| `ringAmp` | ring-modulated guitar level |
| `shadowAmp` | brightness of the FM echo on each pluck |
| `revMix` | how much the space envelops everything |
| `mode` | harmonic world — change for different color |
| `restProb` per stream | density of each instrument (higher = sparser) |
| `stepMin/Max` per stream | pace of each instrument |

---

## To do / ideas
- [ ] Vary `octVar` on more streams for wider melodic range
- [ ] Try different modes (Phrygian dominant for darker color)
- [ ] Add a slow LFO on `bedAmp` for breathing dynamics
- [ ] Consider a second guitar input for pitch detection on string 6 only (low register trigger)
- [ ] Arc/shape: start sparse (low restProb streams muted), build to full density, end on silence
