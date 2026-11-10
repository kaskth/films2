$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)
$pairs = @(
  @('g.arc(q[0], q[1], s * br * 1.9, 0, 7); F(LOOK.foam);', 'g.arc(q[0], q[1], s * br * 1.7, 0, 7); F(colour);'),
  @('F(LOOK.ink); g.beginPath(); g.arc(q[0], q[1], s * br * 0.5, 0, 7); g.fill();', 'F(LOOK.ink); g.beginPath(); g.arc(q[0], q[1], s * br * 0.28, 0, 7); g.fill();'),
  @('g.ellipse(s * 0.30, s * 0.10, s * 0.17, s * 0.28, 0.3, 0, 7);', 'g.ellipse(s * 0.40, s * 0.06, s * 0.10, s * 0.26, 0.22, 0, 7);'),
  @('g.beginPath(); g.ellipse(s * 0.30, s * 0.10, s * 0.17, s * 0.28, 0.3, -0.9, 0.9);', 'g.beginPath();'),
  @('F(LOOK.rockDark); g.fill(); I(LW * 0.9); g.stroke();', 'F(LOOK.rockDark); g.fill(); I(LW * 0.85); g.stroke();')
)
foreach ($pair in $pairs) {
  if ($t.Contains($pair[0])) { $t = $t.Replace($pair[0], $pair[1]); Write-Output ('ok: ' + $pair[0].Substring(0, [Math]::Min(46, $pair[0].Length))) }
  else { Write-Output ('MISS: ' + $pair[0].Substring(0, [Math]::Min(46, $pair[0].Length))) }
}
[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
