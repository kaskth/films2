$p = 'D:\coda\films2\films\hermit-crab\shots.json'
$j = Get-Content $p -Raw | ConvertFrom-Json

$plan = @{
  S01 = @{ s = 0;   e = 58;  vo = 'One shell. Two tenants.';                    f = 'VO1.wav';  at = 0.05 }
  S02 = @{ s = 58;  e = 118; vo = '';                                           f = '';         at = 0.00 }
  S03 = @{ s = 118; e = 158; vo = 'And a neighbourhood.';                       f = 'VO2.wav';  at = 0.05 }
  S04 = @{ s = 158; e = 209; vo = 'No blood. No retreat.';                      f = 'VO3a.wav'; at = 0.10 }
  S05 = @{ s = 209; e = 274; vo = 'The loser leaves empty.';                    f = 'VO3b.wav'; at = 0.10 }
  S06 = @{ s = 274; e = 305; vo = 'Eleven seconds.';                            f = 'VO4.wav';  at = 0.05 }
  S07 = @{ s = 305; e = 384; vo = 'The loser is already dead. Nobody told it.';  f = 'VO5.wav';  at = 0.10 }
  S08 = @{ s = 384; e = 480; vo = 'Nobody is watching. The winner gets the shell.'; f = 'VO6.wav'; at = 0.10 }
  S09 = @{ s = 480; e = 720; vo = 'The queue gets the winner.';                  f = 'VO7.wav';  at = 0.30 }
}

foreach ($sh in $j.shots) {
  $row = $plan[$sh.id]
  if ($row) {
    $sh.start = $row.s
    $sh.end = $row.e
    $sh.vo = $row.vo
    $sh | Add-Member -NotePropertyName vo_file -NotePropertyValue $row.f -Force
    $sh | Add-Member -NotePropertyName vo_at -NotePropertyValue $row.at -Force
  }
}
$j | Add-Member -NotePropertyName vo_dir -NotePropertyValue 'audio/vo-mine' -Force
$j.version = 2

$j | ConvertTo-Json -Depth 10 | Set-Content -Path $p -Encoding UTF8
Write-Output 'shots.json re-timed'
