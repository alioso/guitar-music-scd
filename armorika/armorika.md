# Armorika

Inspired by Frank Zappa's *Amnerica* (Civilization Phaze III, 1994).

A generative Synclavier-style bed triggered and conducted by live guitar. The guitar does not play *with* the bed — it *commands* it.

---

## Architecture

```
Guitar → pitch detection
              ↓
         root pitch update → 6 FM bed streams (always running)
              ↓
         soft FM shadow (echoes each pluck)
              ↓
         processed guitar blend (tanh saturation)
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

Mode: **Lydian dominant** `[0, 2, 4, 6, 7, 9, 10]` — Zappa's characteristic scale.

---

## Performance

### Starting the piece
- Boot, then play your first note. The bed starts on the first detected pitch.
- Give it 10–15 seconds to build before moving.

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
The input is soft-saturated (not dry) — it blends into the texture rather than sitting on top. Each pluck also spawns a light FM shadow voice. The guitar is the high register of the orchestra, not a soloist above it.

---

## Tuning knobs (config block)

| Parameter | Effect |
|---|---|
| `bedAmp` | overall bed volume |
| `blendAmp` | how present the processed guitar is |
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
