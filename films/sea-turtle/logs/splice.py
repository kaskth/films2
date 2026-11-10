import re, pathlib
p = pathlib.Path("film.html"); s = p.read_text(encoding="utf-8")
blk = pathlib.Path("logs/film_block.js").read_text(encoding="utf-8")
blk = blk.replace("  O.list.forEach((p) => { if (p.y > 1000) p.y = 0; });\n", "").replace("  g.fillStyle = 'rgba(248,248,246,0.0)';\n", "")
blk = blk.replace("  g.beginPath(); for (let x = 1500; x <= 2600; x += 16) (x === 1500 ? g.moveTo(x, edgeY(x, 250, 6, 220, t * 40)) : g.lineTo(x, edgeY(x, 250, 6, 220, t * 40)));\n", "")
a = s.index("// Cues are shared by picture and sound"); b = s.index("// ============================== HELPERS (picture)")
s = s[:a] + blk + s[b:]
s = s.replace("const TITLE = 'Untitled';", "const TITLE = 'Why It Sucks to Be Born a Sea Turtle';")
s = s.replace("const LOOKS = {\n", "const LOOKS = {\n  'dinzo-flat': { grade: null, bloom: 0, texture: null, vignette: 0, grain: 0, grainHold: 1, hold: 12, line: 0.0065, steps: 0,\n    palette: { bg: '#f8f8f6', ink: '#1a1410', accent: '#e0703a', dim: '#3f8fb0' } },\n", 1)
s = s.replace("|| 'cinematic-realistic';", "|| 'dinzo-flat';", 1)
s = s.replace("const DURATION = 8; ", "const DURATION = 30;")
s = s.replace("lang: 'tr',", "lang: 'en',")
p.write_text(s, encoding="utf-8")
print("ok", "dinzo-flat" in s, "DURATION = 30" in s)
