$src = 'D:\coda\films2\films\sea-turtle\review\voices\Generated Audio November 10, 2026 - 4_08PM.wav'
$dir = 'D:\coda\films2\films\hermit-crab\audio\vo-mine'
New-Item -ItemType Directory -Force -Path $dir | Out-Null
Copy-Item $src (Join-Path $dir 'take-raw-19s.wav') -Force

$cuts = @(
  @('VO1', 0.00, 2.70),
  @('VO2', 2.70, 4.40),
  @('VO3a', 4.50, 6.45),
  @('VO3b', 6.55, 8.70),
  @('VO4', 9.20, 10.35),
  @('VO5', 10.50, 13.55),
  @('VO6', 13.85, 16.75),
  @('VO7', 16.95, 19.12)
)
foreach ($c in $cuts) {
  $out = Join-Path $dir ($c[0] + '.wav')
  ffmpeg -y -hide_banner -loglevel error -i $src -ss $c[1] -to $c[2] -ac 1 -ar 48000 -c:a pcm_s16le $out
}
Get-ChildItem $dir -Filter 'VO*.wav' | ForEach-Object {
  $d = ffprobe -v error -show_entries format=duration -of csv=p=0 $_.FullName
  '{0}  {1,6:N2}s  {2}' -f $_.BaseName, [double]$d, $_.Length
}
