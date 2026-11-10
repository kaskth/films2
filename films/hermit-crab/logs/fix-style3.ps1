$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)
$pairs = @(
  @('[0.62, 0.38, 0.17].forEach((k) => { g.beginPath(); g.arc(0, 0, s * k, -0.7, 4.2); g.stroke(); });',
    '[0.66, 0.40, 0.18].forEach((k) => { g.beginPath(); g.arc(0, 0, s * 0.47 * k, -0.7, 4.2); g.stroke(); });'),
  @('F(LOOK.ink); g.beginPath(); g.arc(q[0], q[1], s * br * 0.28, 0, 7); g.fill();',
    'g.beginPath(); g.arc(q[0], q[1], s * br * 0.55, 1.2, 2.6); I(LW * 0.45); g.stroke();')
)
foreach ($pair in $pairs) {
  if ($t.Contains($pair[0])) { $t = $t.Replace($pair[0], $pair[1]); Write-Output ('ok: ' + $pair[0].Substring(0, [Math]::Min(40, $pair[0].Length))) }
  else { Write-Output ('MISS: ' + $pair[0].Substring(0, [Math]::Min(40, $pair[0].Length))) }
}
[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
