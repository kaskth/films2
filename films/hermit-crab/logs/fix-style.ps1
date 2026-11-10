$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)

$oldBarn = "    g.beginPath(); g.arc(q[0], q[1], s * br * 1.9, 0, 7); F(LOOK.foam); g.fill(); ink(LW * 0.55); g.stroke();`r`n    F(LOOK.ink); g.beginPath(); g.arc(q[0], q[1], s * br * 0.5, 0, 7); g.fill(); });"
$newBarn = "    g.beginPath(); g.arc(q[0], q[1], s * br * 1.7, 0, 7); F(colour); g.fill(); ink(LW * 0.5); g.stroke();`r`n    F(LOOK.ink); g.beginPath(); g.arc(q[0], q[1], s * br * 0.28, 0, 7); g.fill(); });"
if ($t.Contains($oldBarn)) { $t = $t.Replace($oldBarn, $newBarn); Write-Output 'barnacles: ok' } else { Write-Output 'barnacles: NOT FOUND' }

$t = $t.Replace('const joint = (x, y, r) => { const p = u(x, y);', 'const joint = (x, y, r) => { const p = u(x, y); r = r * 0.62;')

$t = $t.Replace('  for (let i = 0; i < teeth; i++) {', '  for (let i = 0; i < 2; i++) {')
$t = $t.Replace('g.lineTo(r * (t0 + 0.14), -r * 0.56); g.stroke();', 'g.lineTo(r * (t0 + 0.10), -r * 0.50); g.stroke();')
$t = $t.Replace('g.lineTo(r * (t0 + 0.14), r * 0.50); g.stroke(); }', 'g.lineTo(r * (t0 + 0.10), r * 0.46); g.stroke(); }')

$oldMouth = "  // the mouth`r`n  g.beginPath(); g.ellipse(s * 0.30, s * 0.10, s * 0.17, s * 0.28, 0.3, 0, 7);`r`n  F(LOOK.rockDark); g.fill(); I(LW * 0.9); g.stroke();`r`n  g.beginPath(); g.ellipse(s * 0.30, s * 0.10, s * 0.17, s * 0.28, 0.3, -0.9, 0.9);`r`n  F(LOOK.prize); g.globalAlpha = 0.35; g.fill(); g.globalAlpha = 1;"
$newMouth = "  // the mouth: a crescent at the lip`r`n  g.beginPath(); g.ellipse(s * 0.40, s * 0.06, s * 0.10, s * 0.26, 0.22, 0, 7);`r`n  F(LOOK.rockDark); g.fill(); I(LW * 0.85); g.stroke();"
if ($t.Contains($oldMouth)) { $t = $t.Replace($oldMouth, $newMouth); Write-Output 'mouth: ok' } else { Write-Output 'mouth: NOT FOUND' }

[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output 'written'
