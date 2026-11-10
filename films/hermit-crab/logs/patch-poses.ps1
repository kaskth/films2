$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)

# ---- fix 1: round the top-left of the whorl (it read as a leaf point)
$t = $t.Replace('Q(-0.92, -0.54, -0.83, -0.82);', 'Q(-0.99, -0.50, -0.84, -0.84);')

# ---- fix 2: a wider shell-colour lip on the aperture, dark only inside
$t = $t.Replace('g.ellipse(ap[0] - s * 0.010, ap[1] + s * 0.012, s * 0.082, s * 0.118, facing * 0.30, 0, 7);',
                'g.ellipse(ap[0] - s * 0.008, ap[1] + s * 0.020, s * 0.066, s * 0.100, facing * 0.30, 0, 7);')

# ---- fix 3: a flat lit facet on the near claw's palm
$t = $t.Replace('  // hinge`r`n  F(LOOK.ink);',
                '  // one lit facet on the palm`r`n  F(LOOK.rim); g.globalAlpha = 0.18;`r`n  g.beginPath(); g.ellipse(-r * 0.12, -r * 0.34, r * 0.62, r * 0.34, -0.25, 0, 7); g.fill();`r`n  g.globalAlpha = 1;`r`n  // hinge`r`n  F(LOOK.ink);')

# ---- poses: tilt for lunge/brace, mirror for a flipped crab, and a naked crab
$t = $t.Replace('function crab(g, cx, cy, s, colour, facing) {',
                'function crab(g, cx, cy, s, colour, facing, pose) {')
$t = $t.Replace("  const u = (x, y) => [cx + x * s * facing, cy + y * s];`r`n  const ink = (w = LW * 1.0) => I(w);",
                "  pose = pose || 'stand';`r`n  g.save();`r`n  if (pose === 'flip') { g.translate(cx, cy); g.scale(1, -1); g.translate(-cx, -cy); }`r`n  else if (pose === 'lunge') { g.translate(cx, cy); g.rotate(-0.10 * facing); g.translate(-cx, -cy); }`r`n  else if (pose === 'brace') { g.translate(cx, cy); g.rotate(0.09 * facing); g.translate(-cx, -cy); }`r`n  const u = (x, y) => [cx + x * s * facing, cy + y * s];`r`n  const ink = (w = LW * 1.0) => I(w);")

# close the save at the end of crab(): before the pincer of the big claw is the last call
$t = $t.Replace("  pincer(u(0.60, -0.66), s * 0.155, facing, -0.62, colour);`r`n}",
                "  pincer(u(0.60, -0.66), s * 0.155, facing, -0.62, colour);`r`n  g.restore();`r`n}")

# naked crabs have no shell: wrap the shell block
$t = $t.Replace("  // ---- the shell: fat whorl, a short spire leaning back, a thin lip",
                "  // ---- the shell: fat whorl, a short spire leaning back, a thin lip`r`n  if (pose !== 'naked') {")
$t = $t.Replace("  // ---- head`r`n  const h = u(0.15, -0.36);",
                "  } else {`r`n    const ab = u(-0.10, -0.40);`r`n    g.beginPath(); g.ellipse(ab[0], ab[1], s * 0.20, s * 0.13, facing * 0.20, 0, 7);`r`n    F(colour); g.fill(); ink(LW * 1.0); g.stroke();`r`n  }`r`n  // ---- head`r`n  const h = u(0.15, -0.36);")

[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output "fixes + poses applied"
