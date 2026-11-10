$dir  = 'D:\coda\films2\films\hermit-crab\audio\vo-mine'
$src  = Join-Path $dir 'take-raw-19s.wav'
Copy-Item 'D:\coda\films2\films\sea-turtle\review\voices\Generated Audio November 10, 2026 - 4_08PM.srt' (Join-Path $dir 'take-raw.srt') -Force

# boundaries taken from the SRT cues, with 0.12 s of lead and tail so no first consonant is clipped
$cuts = @(
  @('VO1',  0.000, 2.600),
  @('VO2',  2.680, 4.210),
  @('VO3a', 4.420, 6.360),
  @('VO3b', 6.400, 8.660),
  @('VO4',  8.920, 10.080),
  @('VO5',  10.260, 13.560),
  @('VO6',  13.560, 16.680),
  @('VO7',  16.680, 18.900)
)
foreach ($c in $cuts) {
  $out = Join-Path $dir ($c[0] + '.wav')
  ffmpeg -y -hide_banner -loglevel error -i $src -ss $c[1] -to $c[2] -ac 1 -ar 48000 -c:a pcm_s16le $out
  $tmp = Join-Path $dir ('t_' + $c[0] + '.wav')
  ffmpeg -y -hide_banner -loglevel error -i $out -af "silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.02,areverse,silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.02,areverse" -ac 1 -ar 48000 -c:a pcm_s16le $tmp
  Move-Item $tmp $out -Force
}
$total = 0
Get-ChildItem $dir -Filter 'VO*.wav' | Sort-Object Name | ForEach-Object {
  $d = [double](ffprobe -v error -show_entries format=duration -of csv=p=0 $_.FullName)
  $script:total += $d
  '{0,-6} {1,6:N2}s' -f $_.BaseName, $d
}
'{0,-6} {1,6:N2}s' -f 'TOTAL', $total
