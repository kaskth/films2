$dir = 'D:\coda\films2\films\hermit-crab\audio\vo-mine'
$out = 'D:\coda\films2\films\hermit-crab\audio\temp-vo.wav'
$files = @('VO1.wav','VO2.wav','VO3a.wav','VO3b.wav','VO4.wav','VO5.wav','VO6.wav','VO7.wav')
$ms    = @(50, 4967, 6683, 8808, 11467, 12808, 16100, 20300)

$inputs = ''
foreach ($f in $files) { $inputs += ' -i "' + (Join-Path $dir $f) + '"' }

$filter = ''
$mix = ''
for ($i = 0; $i -lt $files.Length; $i++) {
  $filter += "[${i}:a]adelay=${($ms[$i])}|${($ms[$i])}[a$i];"
  $mix += "[a$i]"
}
$filter += $mix + "amix=inputs=$($files.Length):normalize=0:dropout_transition=0,apad,atrim=0:30[m]"

$args = $inputs + ' -filter_complex "' + $filter + '" -map "[m]" -ar 48000 -ac 1 -c:a pcm_s16le -y "' + $out + '"'
Start-Process -FilePath 'ffmpeg' -ArgumentList ('-hide_banner -loglevel error' + $args) -Wait -NoNewWindow
$d = ffprobe -v error -show_entries format=duration -of csv=p=0 $out
"temp-vo.wav  $([double]$d) s"
