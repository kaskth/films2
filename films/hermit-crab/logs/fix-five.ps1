$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)

# 1) the sand cloud: five lobes, lumpy top, one thin contour
$a = $t.IndexOf('function sandCloud')
$b = $t.IndexOf('// the queue: eye pairs')
$new = @'
function sandCloud(cx, cy, r) {
  const lobes = [[-0.98, 0.62, 0.06], [-0.52, 0.88, -0.04], [0.02, 1.02, -0.10], [0.56, 0.84, -0.02], [0.98, 0.60, 0.08]];
  lobes.forEach(([ox, rr, oy]) => {
    g.beginPath(); g.arc(cx + ox * r * 0.66, cy + oy * r, r * rr * 0.70, Math.PI, 2 * Math.PI); g.closePath();
    F(LOOK.sandMid); g.fill();
  });
  F(LOOK.sandMid); g.fillRect(cx - r * 1.05, cy - r * 0.05, r * 2.10, r * 0.85);
  I(LW * 0.55);
  lobes.forEach(([ox, rr, oy]) => {
    g.beginPath(); g.arc(cx + ox * r * 0.66, cy + oy * r, r * rr * 0.70, Math.PI, 2 * Math.PI); g.stroke();
  });
  I(LW * 0.35);
  [[-0.30, 0.34, 0.16], [0.34, 0.30, -0.12]].forEach(([ox, rr, oy]) => {
    g.beginPath(); g.arc(cx + ox * r, cy + oy * r, r * rr, Math.PI * 1.06, Math.PI * 1.94); g.stroke();
  });
}

'@
if ($a -ge 0 -and $b -gt $a) { $t = $t.Substring(0, $a) + $new + $t.Substring($b); Write-Output 'cloud: 5 lobes' }

# 2) S03 fills the frame with the ridge
$t = $t.Replace("case 'S03': return { k: lerp(1.75, 2.15, ease(u)), fx: lerp(0.40, 0.52, u), fy: 0.500 };",
                "case 'S03': return { k: lerp(1.95, 2.40, ease(u)), fx: lerp(0.38, 0.54, u), fy: 0.520 };")

# 3) S01 throws real grit
$t = $t.Replace("burst(X(0.30), Y(0.99), S * 0.30, 11, 2.2, 3);", "burst(X(0.30), Y(0.99), S * 0.44, 17, 2.5, 3);")

# 4) S04: anticipation before each tap (one frame up, then the hit)
$t = $t.Replace("      const tap = (t > 0.9 && t < 1.1) || (t > 1.9 && t < 2.1) ? 1 : 0;",
                "      const ant = (t > 0.78 && t < 0.88) || (t > 1.78 && t < 1.88);`r`n      const tap = (t > 0.88 && t < 1.08) || (t > 1.88 && t < 2.08) ? 1 : 0;")
$t = $t.Replace("      A(0.34, 0.965, 0.40, 'stand');",
                "      A(0.34, ant ? 0.942 : 0.965, 0.40, ant ? 'lunge' : 'stand');")

[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output 'patched'
