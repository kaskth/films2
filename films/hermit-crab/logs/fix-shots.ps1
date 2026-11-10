$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)

# S03: fill the frame with the ridge instead of empty sand
$t = $t.Replace("case 'S03': return { k: lerp(1.45, 1.9, ease(u)), fx: lerp(0.40, 0.52, u), fy: 0.475 };",
                "case 'S03': return { k: lerp(1.75, 2.15, ease(u)), fx: lerp(0.40, 0.52, u), fy: 0.500 };")

# S06: bring the flipped crab inside the frame
$t = $t.Replace("case 'S06': return { k: 1.70, fx: 0.47, fy: 0.795 };",
                "case 'S06': return { k: 1.55, fx: 0.46, fy: 0.760 };")
$t = $t.Replace("      A(0.395, 0.955, 0.400, 'stand');`r`n      B(0.560, 0.955, 0.400, 'flip');",
                "      A(0.360, 0.955, 0.400, 'stand');`r`n      B(0.505, 0.930, 0.390, 'flip');")

# S05: a ragged wall of sand instead of four circles
$old = @'
function sandCloud(cx, cy, r) {
  [[-0.55, 0.10, 0.62], [0.00, -0.18, 0.80], [0.55, 0.06, 0.66], [0.10, 0.26, 0.72]].forEach(([ox, oy, rr], i) => {
    g.beginPath(); g.arc(cx + ox * r, cy + oy * r, r * rr, 0, 7);
    F(i % 2 ? LOOK.sandMid : LOOK.sandTop); g.fill();
    I(LW * 0.8); g.stroke();
  });
}
'@
$new = @'
function sandCloud(cx, cy, r) {
  const wall = (lift, fill, stroke) => {
    g.beginPath();
    for (let i = 0; i <= 22; i++) {
      const u = i / 22, x = cx - r * 1.35 + u * r * 2.70;
      const y = cy - r * lift * (0.42 + 0.58 * Math.abs(Math.sin(i * 2.13 + 0.8)));
      i ? g.lineTo(x, y) : g.moveTo(x, y);
    }
    g.lineTo(cx + r * 1.35, cy + r * 0.80); g.lineTo(cx - r * 1.35, cy + r * 0.80); g.closePath();
    F(fill); g.fill();
    if (stroke) { I(LW * 0.9); g.stroke(); }
  };
  wall(1.00, LOOK.sandMid, true);
  g.save(); g.beginPath();
  g.rect(cx - r * 1.4, cy - r * 1.2, r * 2.8, r * 1.1); g.clip();
  wall(0.86, LOOK.sandTop, false);
  g.restore();
}
'@
if ($t.Contains($old)) { $t = $t.Replace($old, $new); Write-Output 'cloud: ok' } else { Write-Output 'cloud: MISS' }

[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
