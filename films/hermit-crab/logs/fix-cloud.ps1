$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)
$a = $t.IndexOf('function sandCloud')
$b = $t.IndexOf('// the queue: eye pairs')
if ($a -lt 0 -or $b -lt 0) { Write-Output 'markers missing'; exit 1 }
$new = @'
function sandCloud(cx, cy, r) {
  const dome = (sc, fill, stroke) => {
    g.beginPath();
    g.moveTo(cx - r * 1.30 * sc, cy + r * 0.80);
    g.quadraticCurveTo(cx - r * 1.05 * sc, cy - r * 0.95 * sc, cx - r * 0.30 * sc, cy - r * 0.60 * sc);
    g.quadraticCurveTo(cx + r * 0.30 * sc, cy - r * 1.15 * sc, cx + r * 0.95 * sc, cy - r * 0.55 * sc);
    g.quadraticCurveTo(cx + r * 1.30 * sc, cy - r * 0.15 * sc, cx + r * 1.30 * sc, cy + r * 0.80);
    g.closePath(); F(fill); g.fill();
    if (stroke) { I(LW * 0.9); g.stroke(); }
  };
  dome(1.00, LOOK.sandMid, true);
  dome(0.78, LOOK.sandTop, false);
}

'@
$t = $t.Substring(0, $a) + $new + $t.Substring($b)
[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output 'cloud replaced'
