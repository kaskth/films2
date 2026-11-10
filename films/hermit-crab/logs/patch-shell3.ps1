$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)
$pairs = @(
  @("    L(-0.88, -0.90);`n    L(-0.77, -1.00);", "    Q(-0.92, -0.92, -0.80, -1.00);"),
  @("  // sutures between whorls, concentric with the shell body`n  ink(LW * 0.60);`n  [0.74, 0.50, 0.28].forEach((k, i) => {`n    g.beginPath(); g.arc(c[0], c[1], s * 0.46 * k, -2.35 + i * 0.22, 1.55 + i * 0.28); g.stroke(); });`n  // the spire's own growth lines`n  ink(LW * 0.42);`n  [0.10, 0.055].forEach((o) => {`n    g.beginPath(); g.arc(c[0], c[1], s * (0.52 + o), -2.05, -1.30); g.stroke(); });",
    "  // sutures between whorls, clipped to the shell`n  g.save(); shellPath(); g.clip();`n  ink(LW * 0.60);`n  [0.74, 0.50, 0.28].forEach((k, i) => {`n    g.beginPath(); g.arc(c[0], c[1], s * 0.46 * k, -2.35 + i * 0.22, 1.55 + i * 0.28); g.stroke(); });`n  g.restore();")
)
foreach ($pair in $pairs) {
  $a = $pair[0].Replace('`n', "`n")
  if ($t.Contains($a)) { $t = $t.Replace($a, $pair[1].Replace('`n', "`n")); Write-Output 'ok' } else { Write-Output 'MISS' }
}
[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
