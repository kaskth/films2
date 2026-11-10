# Voice over: text to record

The film's narration, ready to read or to feed to whichever voice you use.
38 words in 30 seconds. Seven takes. English.

---

## The seven lines, with their windows

Record each line as its own file. The take must fit its window and start on its window's first frame.

| Take | Shot | Window | Length | The line | Delivery |
| :--- | :--- | :--- | :--- | :--- | :--- |
| VO1 | S01 | 0.00 to 2.60 | 2.58 s | **One shell. Two tenants.** | two flat announcements, a beat between them |
| VO2 | S03 | 5.20 to 8.20 | 3.00 s | **And a neighbourhood.** | lower and slower than VO1, almost bored |
| VO3 | S04 | 8.20 to 11.80 | 3.58 s | **No blood. No retreat. The loser leaves empty.** | a list read off a form, no emphasis on any item |
| VO4 | S06 | 14.80 to 17.80 | 3.00 s | **Eleven seconds.** | a fact stated once, then stop |
| VO5 | S07 | 17.80 to 21.40 | 3.58 s | **The loser is already dead. Nobody told it.** | the first half flat, the second half flatter |
| VO6 | S08 | 21.40 to 25.40 | 4.00 s | **Nobody is watching. The winner gets the shell.** | a correction being made to a record |
| VO7 | S09 | 25.40 to 30.00 | 4.58 s | **The queue gets the winner.** | the same tone as VO6, one step quieter |

Silent shots: **S02** (2.60 to 5.20) and **S05** (11.80 to 14.80). Do not record anything there.
The last 1.2 seconds (28.80 to 30.00) carry one slowed shell knock and nothing else.

---

## The whole thing in one block

For a single continuous take, or for a TTS box:

```
One shell. Two tenants.

And a neighbourhood.

No blood. No retreat. The loser leaves empty.

Eleven seconds.

The loser is already dead. Nobody told it.

Nobody is watching. The winner gets the shell.

The queue gets the winner.
```

The gaps above are the silences in the film. If you read it in one go, hold each gap for
about a second and I will cut on the punctuation.

---

## How it should sound

- **Flat.** This is a man reading a report he did not write. No warmth, no smile, no lift at
  the end of a sentence.
- **Hard starts.** Each sentence begins at full level on its first word. No fade in.
- **No emphasis inside a line.** The comedy is in the timing and in the picture, not in the read.
  If one word is stressed, the joke dies.
- **Periods are real stops.** "One shell." then a breath, then "Two tenants." The stop is part of
  the performance.
- **Pace.** around 135 words per minute. If a take is short and clipped, that is correct.

---

## Pronunciation

- **hermit** never appears in the narration; do not explain it.
- **tenants**: TEN-ants.
- **neighbourhood**: NAY-buh-hood, three syllables, no extra syllable.
- **queue**: "kew", one syllable.

---

## Technical

- One file per take: `VO1.wav` to `VO7.wav`, in `audio/vo-mine/`.
- 48 kHz, 24 bit, mono. WAV, not MP3.
- Leave roughly 0.4 s of clean room tone at the head and tail of each take so I can trim on the
  first consonant without cutting into it.
- Room tone: silence, no music, no fan, no reverb. If the room rings, a duvet behind you and a
  duvet in front is enough.
- Peaks under -6 dBFS. I master the film at -14 LUFS, so leave me headroom.
- If a take is long, send it anyway and say which one: I will time the shots to the take rather
  than cut the line.

---

## What happens after you send them

I trim each take, treat them as one voice in one room, lay them at their windows, and time the
animatic to the real lengths. Nothing else about the film changes: same lines, same order, same
silences. If a take comes in long or short, the shot gets the time, not the line.

---

## RECEIVED: the take you sent

`audio/vo-mine/` now holds the split. Source: `Generated Audio November 10, 2026 - 4_08PM.wav`
(19.12 s, 24 kHz mono, peak -1.1 dB), copied in as `take-raw-19s.wav` and cut at the silences,
trimmed, resampled to 48 kHz mono.

| File | Line | Tight length |
| :--- | :--- | :--- |
| VO1.wav | One shell. Two tenants. | 2.26 s |
| VO2.wav | And a neighbourhood. | 1.34 s |
| VO3a.wav | No blood. No retreat. | 1.78 s |
| VO3b.wav | The loser leaves empty. | 1.96 s |
| VO4.wav | Eleven seconds. | 0.87 s |
| VO5.wav | The loser is already dead. Nobody told it. | 2.86 s |
| VO6.wav | Nobody is watching. The winner gets the shell. | 2.71 s |
| VO7.wav | The queue gets the winner. | 1.80 s |

Total speech 15.57 s in a 30 s film (52 percent voice).
The read came in at about 119 words per minute, slower than the 135 asked for, so the shots were
stretched to the takes rather than the lines cut. The full 38 words were heard, nothing is missing.

VO3 was split in two: "No blood. No retreat." now sits on the taps (S04) and "The loser leaves
empty." lands on the collision (S05), which the shot was already silent for.

---

## CORRECTED from the SRT

The SRT (`audio/vo-mine/take-raw.srt`) gives the real word timings, and they exposed a fault in the
first cut: four of the eight cuts started **after** the first word began, so VO4, VO5, VO6 and VO7
were clipping their opening consonant. Re-cut from the cue boundaries with 0.12 s of lead.

Verified cues:

| File | Cue in the SRT | In | Out | Trimmed |
| :--- | :--- | :--- | :--- | :--- |
| VO1 | One shell, two tenants | 0.000 | 2.600 | 2.26 s |
| VO2 | and a neighborhood | 2.680 | 4.210 | 1.34 s |
| VO3a | No blood, no retreat | 4.420 | 6.360 | 1.78 s |
| VO3b | The loser leaves empty | 6.400 | 8.660 | 1.96 s |
| VO4 | 11 seconds | 8.920 | 10.080 | 0.79 s |
| VO5 | The loser is already dead / Nobody told it | 10.260 | 13.560 | 2.86 s |
| VO6 | Nobody is watching / The winner gets the shell | 13.560 | 16.680 | 2.71 s |
| VO7 | The cue gets the winner | 16.680 | 18.900 | 1.80 s |

The exporter wrote cue 1 as one line with commas, but the audio has real pauses at 1.17 s and
2.47 s, so "and a neighbourhood" is a separate breath and is cut as its own take (VO2). Every line
still fits its shot window, so the shot timing in `shots.json` v2 stands unchanged.
