$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)

# a clock every drawing function can read
$t = $t.Replace("const X = (u) => u * W;", "let NOW = 0;`r`nconst X = (u) => u * W;")

# the crabs breathe and their bodies sway, so no shot is a still
$t = $t.Replace("function crab(g, cx, cy, s, colour, facing, pose) {`r`n  pose = pose || 'stand';",
                "function crab(g, cx, cy, s, colour, facing, pose) {`r`n  pose = pose || 'stand';`r`n  cy = cy + Math.sin(NOW * 2.2 + cx * 0.011) * s * 0.013;")

# the water line and the shore drift
$t = $t.Replace("shape(wave(0.243, 0.0045, 0).concat", "shape(wave(0.243, 0.0045, NOW * 0.9).concat")
$t = $t.Replace("shape(wave(0.416, 0.004, 2).concat", "shape(wave(0.416, 0.004, 2 + NOW * 0.7).concat")

# the crowd blinks, one pair at a time
$t = $t.Replace("  crowd.forEach(([x, y, k]) => {`r`n    const r = S * 0.0140 * k, gap = r * 1.5, hx = X(x), hy = Y(y);",
                "  crowd.forEach(([x, y, k], ci) => {`r`n    const r = S * 0.0140 * k, gap = r * 1.5, hx = X(x), hy = Y(y);`r`n    const blink = Math.max(0.18, Math.abs(Math.cos(NOW * 1.6 - ci * 0.55))) ;")

$t = $t.Replace("      F(LOOK.foam); g.beginPath(); g.arc(hx + ox - r * 0.10, hy, r, 0, 7); g.fill();`r`n      I(LW * 0.55); g.beginPath(); g.arc(hx + ox - r * 0.10, hy, r, 0, 7); g.stroke();`r`n      F(LOOK.ink); g.beginPath(); g.arc(hx + ox + r * 0.22, hy + r * 0.04, r * 0.42, 0, 7); g.fill();",
                "      F(LOOK.foam); g.beginPath(); g.ellipse(hx + ox - r * 0.10, hy, r, r * blink, 0, 0, 7); g.fill();`r`n      I(LW * 0.55); g.beginPath(); g.ellipse(hx + ox - r * 0.10, hy, r, r * blink, 0, 0, 7); g.stroke();`r`n      F(LOOK.ink); g.beginPath(); g.ellipse(hx + ox + r * 0.22, hy + r * 0.04, r * 0.42, r * 0.42 * blink, 0, 0, 7); g.fill();")

# the clock is set per frame
$t = $t.Replace("window.renderFrame = (i) => {`r`n  g.setTransform(1, 0, 0, 1, 0, 0);",
                "window.renderFrame = (i) => {`r`n  NOW = i / FPS2;`r`n  g.setTransform(1, 0, 0, 1, 0, 0);")

[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output 'motion added'
