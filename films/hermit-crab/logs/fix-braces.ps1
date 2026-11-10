$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$lines = [IO.File]::ReadAllLines($p)

# 1) close the shell wrap and add the naked abdomen, just before "  // ---- head"
$i = [Array]::IndexOf($lines, '  // ---- head')
$ins = @(
  '  } else {',
  '    const ab = u(-0.10, -0.40);',
  '    g.beginPath(); g.ellipse(ab[0], ab[1], s * 0.20, s * 0.13, facing * 0.20, 0, 7);',
  '    F(colour); g.fill(); ink(LW * 1.0); g.stroke();',
  '  }'
)
if ($i -gt 0) { $lines = $lines[0..($i-1)] + $ins + $lines[$i..($lines.Length-1)] } else { Write-Output 'head marker missing' }

# 2) pose setup right after "function crab(...)"
$j = -1
for ($k = 0; $k -lt $lines.Length; $k++) { if ($lines[$k] -like 'function crab(g, cx, cy*') { $j = $k; break } }
$pre = @(
  "  pose = pose || 'stand';",
  '  g.save();',
  "  if (pose === 'flip') { g.translate(cx, cy); g.scale(1, -1); g.translate(-cx, -cy); }",
  "  else if (pose === 'lunge') { g.translate(cx, cy); g.rotate(-0.10 * facing); g.translate(-cx, -cy); }",
  "  else if (pose === 'brace') { g.translate(cx, cy); g.rotate(0.09 * facing); g.translate(-cx, -cy); }"
)
if ($j -gt 0) { $lines = $lines[0..$j] + $pre + $lines[($j+1)..($lines.Length-1)] } else { Write-Output 'crab marker missing' }

# 3) close the save at the end of crab(): last line before the pincer() function comment
$m = -1
for ($k = 0; $k -lt $lines.Length; $k++) { if ($lines[$k] -like '*a claw: one palm*') { $m = $k; break } }
if ($m -gt 2) { $lines = $lines[0..($m-2)] + @('  g.restore();') + $lines[($m-1)..($lines.Length-1)] } else { Write-Output 'pincer marker missing' }

[IO.File]::WriteAllLines($p, $lines, (New-Object System.Text.UTF8Encoding($false)))
Write-Output ('lines now: ' + $lines.Length)
