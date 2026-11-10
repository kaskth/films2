# Roadmap: The Duel

30 s · 16:9 · 1920×1080 · 24 fps · 2D flat vector · English narration · no music · Profile: Quality
Kit: `D:\coda\films2\.opencode\skills\cinecode` · Purpose: cinematic · Mode: Film

## 1. Concept

- **Logline:** Two hermit crabs want the same shell, so they fight for it under the pool's rules; the winner takes the prize and then finds out that the ring of eyes watching was a queue.
- **The turn:** Before: the fight decides who gets the shell. / After: the fight decides who is next in line to be beaten — the shell is a debt, not a prize.
- **Ending:** The crowd's eyes fill the frame and the winner's eye, small, sits inside the shell. Line: "The queue gets the winner." It re-reads the opening: the film starts on a claw hitting sand as if it is the first blow, and ends showing that the first blow was just the last one's echo.
- **How code shows it:** Canvas 2D, flat fills, one ink weight. A crab is six shapes and a shell is three bands, so the whole cast fits on one plane — no textures, no lighting rig, no 3D. The subject is on screen at every key beat because the film never leaves the pool floor: the rule, the charge, the flip, the walk-off and the queue are all crab-sized actions.
- **Specificity / world test:** the facts are the pool's own: one shell, two tenants, a ring of eyes on the ridge, the loser leaving without a shell (a real hermit crab without one is soft and dies), the winner sleeping with one eye open. No generic beach imagery, no gulls, no litter, no eco-moral.

## 2. Shots

9 shots · 30.0 s · average 3.33 s (energetic; the reference runs 2.58 s, so every shot is cut on an action, never a hold)

| # | Time | Len | Beat (what changes) | Camera | Read | Sound |
|---|---|---|---|---|---|---|
| 1 | 0.0–2.6 | 2.6 | A claw slams into the sand; the burst fills frame; the camera pulls back to the arena | ECU → wide, pull-back, already moving on frame 0 | the blow | grit impact, hard, then water slap |
| 2 | 2.6–5.2 | 2.6 | Two crabs, opposite ends, the shell between them | low wide, locked, slight drift | the standoff | shell clatter, one distant gull |
| 3 | 5.2–8.2 | 3.0 | The ridge: a row of eyes blinks in sequence | medium, slow push | the crowd | pool ambience, one bubble tick |
| 4 | 8.2–11.8 | 3.6 | Crab A taps the sand twice — the rules | close, locked | the ritual | two dry taps, exactly on the beat |
| 5 | 11.8–14.8 | 3.0 | The charge; claws lock; sand cloud | whip pan in, then hold | the collision | hard scrape, sand burst, no voice |
| 6 | 14.8–17.8 | 3.0 | B is flipped; a leg pedals in the air; A stands over it | high angle, locked | the result | shell knock, thin leg tick |
| 7 | 17.8–21.4 | 3.6 | The loser walks off naked and small into the dark | wide, static, long lens | the cost | footsteps in grit, fading |
| 8 | 21.4–25.4 | 4.0 | The winner climbs in — and the eyes have stepped closer | medium, push in | the mistake | shell settle, then a hundred small clicks |
| 9 | 25.4–30.0 | 4.6 | The eyes fill the frame; inside the shell, one small eye | wide → ECU, push to black | the debt | clicks rise, one shell knock, cut to near silence |

## 3. Look

- **Base preset:** custom — "Low Sun", built and approved on `review/directions.jpg` row B (`engine/proof.html`)
- **Changes for this film:** two-tone cels only (a lit tone and a shadow tone, no third); one ink weight everywhere (0.028 × frame height); no gradients anywhere, not even in water; hard cast shadows on the sand, long, from frame right; rim light `#ffd39a` on every top edge that faces the sun; no paper texture, no grain (this is not a print)
- **Palette:** sky `#ef9a55` / `#e5874a` · water `#1e4f70` / `#123c58` · sand `#d98f4d` / `#b06b34` / `#8b4d22` · rock `#2a3141` / `#465266` / `#191f2b` · crab A `#d9473a` · crab B `#3a5d8b` · the shell `#f2e4c6` (the only pale thing in the film, so the eye goes there) · ink `#120d12`
- **References used:** `research/board-v1/sheet.jpg` — three hermit crab photographs (shell carried high and tilted, one big claw on the near side, short eye stalks close together, thick jointed legs with pointed tips) and three tide-pool photographs (dark volcanic rock, a bright water window, the ridge line where a crowd would stand). They teach anatomy and how the light sits on wet rock. Nothing is fetched into the film.

## 4. Sound identity

- **Chosen concept:** the pool is the sound — everything comes from one place, and comedy comes from timing, not from cartoon noises
- **Palette:** synthesised and recorded-from-model: water slapping rock, shell knocking on shell, dry grit under a claw, a bubble tick, one distant gull, low wind across the water. Nothing from a generic SFX library that is not water, shell or grit.
- **Signature sound:** the shell knock — hollow, short, slightly wrong pitch. It hits on the rule (shot 4), on the flip (shot 6) and last, slowed, at 29.4 s.
- **Silence:** shot 5 has no voice at all (3 s), and the last 1.2 s is near-silent except one click.
- **Voice — music:** dry administrative male narrator, close, no reverb, no warmth — a man reading a report he did not write. Music: none.
- **Ambience per space — shared reverb:** one bed for the whole film (the pool, tight and wet) — the film never leaves it, so there is exactly one room and every sound sits in it.
- **Arrangement:** none (no music).

## 5. Hook (first 2 s)

Frame 0 already shows a claw mid-swing into sand; the impact lands at 0.4 s and the burst fills the frame; the camera is already pulling back before it lands. No title, no fade, no establishing shot.

## 6. Risks (top 3)

1. **A crab drawn badly reads as a snail with arms.** Mitigation: build the crab from the reference photographs (shell high and tilted, one big claw near side, eye stalks short), and judge it at 160 px wide before anything moves.
2. **A fight between two flat sprites looks like two shapes bumping.** Mitigation: pose-to-pose on twos, an impact frame that holds for two frames, sand bursts and a whip pan — the collision happens off-centre and the cut lands on the hit.
3. **The crowd is a one-note joke.** Mitigation: the eyes appear in exactly three shots (3, 8, 9), each time closer and larger, and never speak; the joke is the arithmetic, not the eyes.

## 7. Director card

- **Structure:** a contest in three movements — rules, bout, price — with the crowd as a clock that ticks three times.
- **Look:** B · Low Sun, picked on the board because a fight needs a light direction: the shadows swing with the crabs and the sun does the staging. **Camera:** locked-off wides with three push-ins and one whip pan; the signature move is the pull-back in shot 1 that reveals the arena from a single claw. **Motion:** *snap* — pose to pose on twos, holds of two frames on every impact.
- **Tempo:** energetic, 9 shots / 30 s (3.33 s average, the reference's energy with one breathing shot at the end). **Transitions:** hard cuts only; two impact cuts (mid-action, on the hit); one whip pan into the crowd at 11.8 s. **Sound:** the pool is the sound; voice dry and close, no room.
- **Light:** one sun, low, from frame right, for the whole film; it never changes, because the fight takes 30 seconds of one afternoon. **Signature:** the pale shell — the only bright object, and the only thing the light never leaves.
- **How each thing is seen:** crabs in three-quarter profile, lit side toward the camera, shadow side as one flat tone; the shell as a silhouette with three ink bands, always the brightest value on screen; the crowd as eyes only, never bodies, never in focus; rock as flat masses with one lit facet; water as a hard band with a wobbling edge and a white lip.
- **Atmosphere:** one place, one afternoon — hot sky, dark wet rock, a bright water window, the sand in the near foreground darker than the arena. Colour laid flat: each surface one tone plus its shadow tone, and the rim light is the only line drawn in the palette rather than in ink.
- **Motion design:** none. The film has no graphics, no numbers, no labels — a rule on screen would kill the joke.
- **Type:** none on screen (step 4b is skipped, with the reason: the film carries no words on the picture, like the reference). **Texture:** none. **Finishing:** at the style frame, the user's choice.

## 8. Next gates

1. **This roadmap** → your OK
2. Script and text (`SCRIPT.md`, 48 words of narration, shot list in `shots.json`)
3. Style frame (one still at final size, the bar for every later frame)
4. Animatic (timed, temp sound)
5. Draft cut → final

---

## Word budget

48 words of narration in 30 s (the reference's proportion: voice on 65% of the runtime, 35% effect-only).
