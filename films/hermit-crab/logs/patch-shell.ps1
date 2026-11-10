$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)
$a = $t.IndexOf("  // ---- the shell")
$b = $t.IndexOf("  // ---- head")
if ($a -lt 0 -or $b -lt 0) { Write-Output "markers not found"; exit 1 }

$new = @'
  // ---- the shell: a turbinate whorl with a spire and a real lip
  const c = u(-0.30, -0.54);
  const shellPath = () => {
    let p0 = u(0.03, -0.24); g.moveTo(p0[0], p0[1]);
    const Q = (cx1, cy1, x, y) => { const A = u(cx1, cy1), B = u(x, y); g.quadraticCurveTo(A[0], A[1], B[0], B[1]); };
    const L = (x, y) => { const B = u(x, y); g.lineTo(B[0], B[1]); };
    Q(-0.28, -0.08, -0.62, -0.32);
    Q(-0.86, -0.50, -0.76, -0.78);
    L(-0.68, -0.92);
    L(-0.60, -1.08);
    Q(-0.46, -0.86, -0.36, -0.80);
    Q(-0.08, -0.64, 0.03, -0.44);
    g.closePath();
  };
  shellPath(); F(colour); g.fill(); ink(LW * 1.05); g.stroke();
  g.save(); shellPath(); g.clip();
  F(LOOK.rim); g.globalAlpha = 0.17;
  g.beginPath(); g.ellipse(c[0] + s * 0.16, c[1] - s * 0.20, s * 0.34, s * 0.24, -0.5, 0, 7); g.fill();
  g.globalAlpha = 1;
  F(LOOK.ink); g.globalAlpha = 0.15;
  g.beginPath(); g.ellipse(c[0] - s * 0.14, c[1] + s * 0.22, s * 0.36, s * 0.16, -0.4, 0, 7); g.fill();
  g.globalAlpha = 1; g.restore();
  // sutures between whorls, not circles
  ink(LW * 0.62);
  [0.72, 0.46].forEach((k, i) => {
    g.beginPath(); g.arc(c[0], c[1], s * 0.30 * k, -2.2 + i * 0.3, 1.5 + i * 0.3); g.stroke(); });
  // growth lines at the lip
  ink(LW * 0.40);
  for (let i = 0; i < 5; i++) {
    g.beginPath(); g.arc(c[0], c[1], s * (0.30 - i * 0.018), -0.42 + i * 0.02, 0.16 + i * 0.02); g.stroke(); }
  // barnacles: little cones, never eyes
  [[-0.12,-0.86,0.026],[-0.045,-0.90,0.019],[-0.50,-0.60,0.022],[-0.60,-0.44,0.016]].forEach(([bx, by, br]) => {
    const q = u(bx, by), r0 = s * br;
    g.beginPath(); g.moveTo(q[0] - r0, q[1] + r0 * 0.55); g.lineTo(q[0] - r0 * 0.35, q[1] - r0);
    g.lineTo(q[0] + r0 * 0.35, q[1] - r0); g.lineTo(q[0] + r0, q[1] + r0 * 0.55); g.closePath();
    F(colour); g.fill(); ink(LW * 0.45); g.stroke();
    ink(LW * 0.40); g.beginPath(); g.moveTo(q[0] - r0 * 0.18, q[1] - r0 * 0.55); g.lineTo(q[0], q[1] + r0 * 0.30); g.stroke();
  });
  // the aperture: a lip, a bright inner edge, a dark inside
  const ap = u(-0.005, -0.37);
  g.beginPath(); g.ellipse(ap[0], ap[1], s * 0.135, s * 0.175, facing * 0.30, 0, 7);
  F(LOOK.sandTop); g.fill(); ink(LW * 0.95); g.stroke();
  g.beginPath(); g.ellipse(ap[0] - s * 0.012, ap[1] + s * 0.012, s * 0.095, s * 0.135, facing * 0.30, 0, 7);
  F(LOOK.rockDark); g.fill(); ink(LW * 0.60); g.stroke();

'@

$t = $t.Substring(0, $a) + $new + $t.Substring($b)
[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output "patched shell"
