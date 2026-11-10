import pathlib, json
p = pathlib.Path("film.html"); s = p.read_text(encoding="utf-8-sig")
rep = [
("const DURATION = 30;", "const DURATION = 31;"),
("{ id: 'VO9', at: 28.6, dur: 1.02 }", "{ id: 'VO9', at: 28.1, dur: 1.02 }"),
("stare: 28.4,", "stare: 27.95,"),
# sound: one designed whoosh, no air on the splash, softer bright foley, louder chase
("  { at: CUES.sea, voice: 'air', dur: 0.7, gain: 0.3, wet: 0.3 },                   // splash\n", ""),
("{ at: CUES.sea + 0.02, voice: 'foley', kind: 'cloth', gain: 0.4, wet: 0.3 },", "{ at: CUES.sea + 0.02, voice: 'foley', kind: 'step', gain: 0.7, wet: 0.3 },"),
("{ at: CUES.crab + 0.05, voice: 'foley', kind: 'cloth', gain: 0.3, wet: 0.1 },", "{ at: CUES.crab + 0.05, voice: 'foley', kind: 'step', gain: 0.45, wet: 0.1 },"),
("{ at: CUES.gull + 0.25, voice: 'foley', kind: 'tap', gain: 0.4, wet: 0.2 },", "{ at: CUES.gull + 0.25, voice: 'foley', kind: 'tap', gain: 0.2, wet: 0.2 },"),
("{ at: CUES.gull + 0.45, voice: 'foley', kind: 'tap', gain: 0.35, wet: 0.2 },", "{ at: CUES.gull + 0.45, voice: 'foley', kind: 'tap', gain: 0.18, wet: 0.2 },"),
("{ at: CUES.shadow + 0.1, voice: 'air', dur: 1.0, gain: 0.22, wet: 0.2 },", "{ at: CUES.shadow + 0.1, voice: 'air', dur: 1.0, gain: 0.16, wet: 0.2 },"),
("...flaps(CUES.chase + 0.2, CUES.sea - 0.1, 0.16, 0.12),", "...flaps(CUES.chase + 0.2, CUES.sea - 0.1, 0.16, 0.5),"),
# S1: the head keeps acting (looks left, right, bobs)
("    { mood: t < 2.2 ? 'flat' : 'angry', blink: blinkAt(t, [1.6]) });",
 "    { mood: t < 2.2 ? 'flat' : 'angry', blink: blinkAt(t, [1.6]), lookX: t > 1.0 && t < 2.2 ? 9 * Math.sin((t - 1) * 5) : 0 });"),
("turtleFront(g, 960 + shake * 0.3, lerp(980, 560, clamp(rise, 0, 1.2)), 1.35,",
 "turtleFront(g, 960 + shake * 0.3 + 20 * Math.sin(Math.max(0, t - 1.2) * 3), lerp(980, 560, clamp(rise, 0, 1.2)) - 10 * Math.abs(Math.sin(t * 4)), 1.35,"),
# S2: the turtle crawls a little toward the tracks
("turtleSide(g, 760, 760, 0.85, { look:", "turtleSide(g, 700 + 180 * EASE.inOut(k), 760 - 5 * Math.abs(Math.sin(t * 9)), 0.85, { flap: t * 9, look:"),
# S3: crawls across the empty sand
("turtleSide(g, 240, 905, 0.22, {", "turtleSide(g, 200 + 120 * k, 905 - 3 * Math.abs(Math.sin(t * 9)), 0.22, {"),
("V(g, S, lerp(1.25, 1, EASE.out(k)), 240, 900);", "V(g, S, lerp(1.6, 1, EASE.out(k)), 240, 900);"),
# S13: trembles
("turtleFront(g, 960, 520, 2.1, { mood: 'worried', blink: blinkAt(t, [29.2]) });",
 "turtleFront(g, 960 + 3 * Math.sin(t * 40), 520, 2.1, { mood: 'worried', blink: blinkAt(t, [29.6]), lookX: t > 29.9 ? 6 : 0, flap: t * 2 });"),
]
for a, b in rep:
    assert a in s, a[:70]; s = s.replace(a, b)
a = s.index("function score(ctx, out) {"); b = s.index("// ============================== HELPERS (picture)")
s = s[:a] + "function score(ctx, out) {\n  // No music (user). The cartoon pops are recorded layers on the sfx bus (audio/mix.json, audio/sfx/).\n}\n\n" + s[b:]
p.write_text(s, encoding="utf-8")
m = json.loads(pathlib.Path("audio/mix.json").read_text())
for L in m["layers"]:
    if L["file"] == "audio/vo-t/VO9.wav": L["at"] = 28.1
m["duration"] = 31.0
pops = [(0.52, "pop-mid", -4), (14.15, "pop-lo", -4), (14.75, "pop-hi", -8), (17.35, "pop-hi", -8), (23.45, "pop-lo", 0), (27.55, "pop-mid", -4)]
for i in range(24): pops.append((round(25.35 + 2.0 * (i / 24) ** 0.8, 3), "tick", -16))
for i in range(6): pops.append((round(19.0 + i * 0.35, 3), "pop-hi", -14))   # crab claws snapping in the chase
m["layers"] = [L for L in m["layers"] if L["bus"] != "sfx"] + [{"file": f"audio/sfx/{f}.wav", "at": t, "gain_db": gdb, "bus": "sfx"} for t, f, gdb in pops]
pathlib.Path("audio/mix.json").write_text(json.dumps(m, indent=1))
print("ok")
