$p = 'D:\coda\films2\films\hermit-crab\shots.json'
$j = [IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8) | ConvertFrom-Json
$fps = $j.fps

foreach ($sh in $j.shots) {
  $L = ($sh.end - $sh.start) / $fps
  $max = [math]::Round($L - 0.03, 2)
  if ($sh.reads.Count -ge 2) {
    $mid = [math]::Round($max * 0.46, 2)
    $sh.reads[0].t = @(0.0, $mid)
    $sh.reads[1].t = @($mid, $max)
  } elseif ($sh.reads.Count -eq 1) {
    $sh.reads[0].t = @(0.0, $max)
  }
  $s = [math]::Round($L / 2, 1)
  $sh.camera.move.line = $sh.camera.move.line -replace '\d+(\.\d+)? s,', "$s s,"
}

# S03 lost time: a 1.7 s push
foreach ($sh in $j.shots) {
  if ($sh.id -eq 'S03') {
    $sh.camera.move.line = 'push-in, 1.7 s, slow ease-in-out, toward the middle eye'
    $sh.camera.move.speed = 'medium'
  }
}

$out = $j | ConvertTo-Json -Depth 10
[IO.File]::WriteAllText($p, $out, (New-Object System.Text.UTF8Encoding($false)))
Write-Output 'reads re-scaled'
