import pathlib
p = pathlib.Path("film.html"); s = p.read_text(encoding="utf-8")
rep = [
("const LW = 7;\n", "const LW = 7;\nObject.assign(PALETTE, { sand: C.sand, sea: C.sea, skin: C.skin, shell: C.shell });   // the film's own colours\n"),
# S1: grains fly sideways (away from the face) and the head is bigger
("const a = -Math.PI * (0.15 + 0.7 * r()), v = 500 + 500 * r()", "const a = -Math.PI * (r() < 0.5 ? 0.05 + 0.22 * r() : 0.73 + 0.22 * r()), v = 600 + 500 * r()"),
("turtleFront(g, 960 + shake * 0.3, lerp(900, 560, clamp(rise, 0, 1.2)), 1.05,", "turtleFront(g, 960 + shake * 0.3, lerp(980, 560, clamp(rise, 0, 1.2)), 1.35,"),
# S6: crab higher so the napkin shows; turtle inside the frame
("crab(g, 1300, lerp(1000, 740, clamp(up, 0, 1.15)), 1.35,", "crab(g, 1300, lerp(1000, 660, clamp(up, 0, 1.15)), 1.35,"),
("turtleSide(g, 260, 900, 0.75, { mood: 'flat', flap: t * 10, blink: blinkAt(t, [15.4]) });", "turtleSide(g, 360, 930, 0.9, { mood: 'flat', flap: t * 10, blink: blinkAt(t, [15.4]) });"),
]
for a, b in rep:
    assert a in s, a[:60]; s = s.replace(a, b)
p.write_text(s, encoding="utf-8"); print("ok")
