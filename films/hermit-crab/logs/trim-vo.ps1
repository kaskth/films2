$dir = 'D:\coda\films2\films\hermit-crab\audio\vo-mine'
Get-ChildItem $dir -Filter 'VO*.wav' | ForEach-Object {
  $tmp = Join-Path $dir ('t_' + $_.Name)
  ffmpeg -y -hide_banner -loglevel error -i $_.FullName -af "silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.02,areverse,silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.02,areverse" -ac 1 -ar 48000 -c:a pcm_s16le $tmp
  Move-Item $tmp $_.FullName -Force
}
$total = 0
Get-ChildItem $dir -Filter 'VO*.wav' | Sort-Object Name | ForEach-Object {
  $d = [double](ffprobe -v error -show_entries format=duration -of csv=p=0 $_.FullName)
  $script:total += $d
  '{0,-6} {1,6:N2}s' -f $_.BaseName, $d
}
'{0,-6} {1,6:N2}s' -f 'TOTAL', $total
