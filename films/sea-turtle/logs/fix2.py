import pathlib
p = pathlib.Path("film.html"); s = p.read_text(encoding="utf-8-sig")
rep = [
("list.push({ x: 240 + (i % 40) * 37, y: 200 + Math.floor(i / 40) * 31,", "list.push({ x: 141 + (i % 40) * 42, y: 205 + Math.floor(i / 40) * 34,"),
("tinyTurtle(g, p.x, p.y, 10 * (p === O.keep ? 1 : v));", "tinyTurtle(g, p.x, p.y, p === O.keep ? lerp(13, 46, EASE.out(MOTION.at(tt, 2.5, 0.5))) : 13 * v);"),
("g.arc(O.keep.x, O.keep.y, lerp(80, 34, u), 0, TAU)", "g.arc(O.keep.x, O.keep.y, lerp(140, 80, u), 0, TAU)"),
("crab(g, 380, 830 - Math.abs(Math.sin(t * 18)) * 18, 0.7,", "crab(g, 420, 850 - Math.abs(Math.sin(t * 18)) * 18, 0.95,"),
("gull(g, 560, 360 + Math.sin(t * 6) * 20, 0.75,", "gull(g, 700, 420 + Math.sin(t * 6) * 20, 1.1,"),
]
for a, b in rep:
    assert a in s, a[:60]; s = s.replace(a, b)
p.write_text(s, encoding="utf-8"); print("ok")
