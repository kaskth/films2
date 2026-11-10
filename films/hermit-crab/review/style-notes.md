# Style frame: what still has to improve

The bar the user set: "stronger drawing, more detailed, and much stronger, clearer animation, very worked".

## Judgement of `review/style-v2.png`

Better than v1 (tapered jointed legs, a whorled shell with an aperture, barnacles, mandibles,
antennae, a palm-and-two-fingers pincer with teeth). Still **at the reference's level, not above it**.

## The character, in the order that matters

1. **Silhouette.** The shell is a plain ellipse. A real one is asymmetric: a fat body whorl and a
   pointed spire that lifts the back of the shell. Draw the outline as one hand-authored path, not
   an ellipse, and make the spire break the silhouette.
2. **The aperture.** Today it is a dark blob behind the head. It should be a visible lip:
   a bright inner edge, a dark inside, and the crab's first two legs emerging through it.
3. **Legs.** They taper now, but all five read as the same weight. Give each a carpus
   (a knee bulge) and a sharp pointed dactyl; the near three should overlap the shell mouth,
   the far two should be visibly darker and thinner.
4. **The big claw.** The palm is a rounded blob. Needs: a flat outer face with one lighter facet,
   a hinge dot, two fingers with 2 teeth that visibly mesh, and 4 short hairs on the upper finger.
5. **The head.** Add a brow shelf over the eyes, a jaw line, and a second pair of short antennules.
   The eyes need a paper-white sclera, a hard pupil, and one square highlight.
6. **Surface.** Barnacles read as eyes. Make them cones: a small triangle with a dark slot,
   never a circle with a dot.
7. **Colour.** One lit facet and one shadow facet per mass, hard edges, no gradients. The shell
   needs a third, deeper shadow only where it meets the sand.

## The environment

1. **Rock.** Flat masses are fine; add 3 shapes per rock: a lit top facet, a crack, a wet band at
   the waterline.
2. **Water.** Three tones plus a foam lip now; add a submerged shelf (a pale band under the surface)
   and two dark pebbles seen through the water.
3. **Sand.** Add 6 thin ripple arcs behind the crabs and 12 grit specks; leave the foreground clean
   so the crabs read.
4. **The crowd.** Five humps with eye pairs read as googly eyes. Give each hump a brow line and a
   different eye spacing, and put one of them lower, half hidden.

## Animation (the other half of the note)

- Pose to pose on twos, with anticipation one frame before every lunge and overshoot after.
- 2-frame impact holds; three-frame smear on the whip pan.
- Secondary motion: eye stalks lag the head by 2 frames; sand settles for 8 frames after a hit.
- The loser's legs keep pedalling for 4 frames after it stops moving.
- Every cut lands on an action, never on a hold.

## Where it stands

`engine/arena.html` draws S02 only. The rest of the shot list is not built yet.

## Round 3 (style-v3.png): the spire failed

Built the shell as a turbinate path with a spire. It reads as a **sail / leaf**, not a shell:

- the spire is too tall and swept (`-0.60,-1.08` above a whorl top at `-0.64`): it should top out
  about `0.15` above the whorl and lean back over the body, not up
- the shell body is a teardrop, not a fat whorl: widen the bottom-left and give it a full belly
- the four barnacle coordinates sit **outside** the new outline and float free
- the aperture lip (`F(LOOK.sandTop)` ellipse) is a pale collar as wide as the head
- the sutures disappeared: they are drawn at `s*0.30*k` inside a much larger path

Fork recorded in `review/shell-fork.jpg`: v2 round spiral (reads at once, barnacles read as eyes)
against v3 spire (anatomically right, currently a fin).

## Measured reference for the next pass

From `research/ref-crab` (three photographs): the shell is carried at about 20 degrees, its spire
points back and slightly up, and its length is about 1.4 times the body whorl height. The crab's
legs come out under the aperture, not around it.

## Round 4-5 (style-v5.png): the spire, corrected

What was actually wrong in v3 and v4, found by looking:

- the two long arcs floating above each crab were the **spire growth lines** drawn at `s*(0.52+o)`
  from a centre inside the whorl, so they landed outside the outline. Removed.
- the sutures were drawn unclipped and left the shell. Now wrapped in `shellPath(); clip();`.
- the spire was `L(-0.88,-0.90) L(-0.77,-1.00)`: a spike. Now `Q(-0.92,-0.92, -0.80,-1.00)`, a
  rounded tip, topping out about 0.20 above the whorl and leaning back.
- barnacles moved inside the outline and drawn as four-sided cones with a slot, not circles.

Still to fix, in order:

1. the top-left of the whorl comes to a point and reads as a **leaf**; round it by moving the
   control point `Q(-0.92,-0.54, -0.83,-0.82)` outward and down
2. the aperture is a dark ring; it needs the shell colour on the outer lip and only the inside dark
   (the pale collar from v3 was too wide, this one is too thin)
3. the near claw's palm has no lit facet; add one flat lighter shape at 18 percent

## Round 6 (style-v6.png): the three fixes are in

1. whorl top-left rounded (`Q(-0.99,-0.50, -0.84,-0.84)`) - the leaf point is gone
2. aperture now a shell-colour lip with a smaller dark inside (`0.066 x 0.100`)
3. near claw palm has a flat lit facet at 18 percent

Pose support added to `crab()`: `stand` | `lunge` | `brace` | `flip` | `naked`
(tilt / vertical mirror / no shell). Not yet used by any shot.

## Next: the shot system

`engine/arena.html` still draws S02 only. What is needed:

- a per-shot camera (focus point + scale) so push-in, pull-back and drift are one transform
- nine shot functions over the same backdrop and cast
- the sand burst, the flip, the naked walk, the queue stepping off the ridge
- pose-to-pose timing on twos, impact holds, secondary motion (eye stalks 2 frames late)

## The shot system (v1): nine shots, one backdrop, one cast

`engine/arena.html` now carries the whole film. One camera per shot (a focus point and a scale),
the same backdrop and the same two crabs. Render any frame with
`--frames <n> --params "w=1920&h=1080"`.

| Shot | Camera | What is on screen |
| :--- | :--- | :--- |
| S01 | k 3.2 to 1.0, focus 0.30/0.88 to 0.50/0.60 | a claw at full frame, grit thrown, the arena opening |
| S02 | k 1.0, slow drift | the standoff and the pale shell |
| S03 | k 1.75 to 2.15, focus on the ridge | the crowd, five eye pairs |
| S04 | k 2.05 locked | A close, tapping the sand |
| S05 | k 1.30 to 1.52 | the charge, then a dome of sand |
| S06 | k 1.55, high | A over a flipped B |
| S07 | k 1.03 locked, long lens | B naked, walking out of frame |
| S08 | k 1.85 to 2.30 | the shell taken, the queue in a row |
| S09 | k 2.5 to 4.4, then a fade to black | the eyes filling the frame |

Contact sheet: `review/sheet-v3.jpg`.

## Known weak, in order

1. **S05's sand** is a smooth dome, not a cloud. It needs a ragged top edge and 6 to 8 separate
   lumps of grit, not two clean arcs.
2. **S03** is still half empty sand; the crowd should sit lower in frame and the ridge line needs
   a foreground shape to hold it.
3. **S01's grit** is a thin yellow fan; it should be bigger, white-hot sand only at the impact.
4. No pose work yet on S04's two taps and S05's wind-up: the anticipation and the impact hold are
   not in the code, only the end positions.
5. Secondary motion (eye stalks 2 frames late, sand settling) is not written.
