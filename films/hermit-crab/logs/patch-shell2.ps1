$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$t = [IO.File]::ReadAllText($p)
$a = $t.IndexOf("  // ---- the shell")
$b = $t.IndexOf("  // ---- head")
if ($a -lt 0 -or $b -lt 0) { Write-Output "markers not found"; exit 1 }

$new = @'
  // ---- the shell: fat whorl, a short spire leaning back, a thin lip
  const c = u(-0.42, -0.52);
  const shellPath = () => {
    let p0 = u(0.03, -0.22); g.moveTo(p0[0], p0[1]);
    const Q = (cx1, cy1, x, y) => { const A = u(cx1, cy1), B = u(x, y); g.quadraticCurveTo(A[0], A[1], B[0], B[1]); };
    const L = (x, y) => { const B = u(x, y); g.lineTo(B[0], B[1]); };
    Q(-0.34, -0.04, -0.70, -0.30);
    Q(-0.92, -0.54, -0.83, -0.82);
    L(-0.88, -0.90);
    L(-0.77, -1.00);
    Q(-0.58, -0.84, -0.45, -0.78);
    Q(-0.10, -0.62, 0.03, -0.40);
    g.closePath();
  };
  shellPath(); F(colour); g.fill(); ink(LW * 1.05); g.stroke();
  g.save(); shellPath(); g.clip();
  F(LOOK.rim); g.globalAlpha = 0.16;
  g.beginPath(); g.ellipse(c[0] + s * 0.14, c[1] - s * 0.22, s * 0.34, s * 0.22, -0.55, 0, 7); g.fill();
  g.globalAlpha = 1;
  F(LOOK.ink); g.globalAlpha = 0.16;
  g.beginPath(); g.ellipse(c[0] - s * 0.16, c[1] + s * 0.20, s * 0.38, s * 0.17, -0.45, 0, 7); g.fill();
  g.globalAlpha = 1; g.restore();
  // sutures between whorls, concentric with the shell body
  ink(LW * 0.60);
  [0.74, 0.50, 0.28].forEach((k, i) => {
    g.beginPath(); g.arc(c[0], c[1], s * 0.46 * k, -2.35 + i * 0.22, 1.55 + i * 0.28); g.stroke(); });
  // the spire's own growth lines
  ink(LW * 0.42);
  [0.10, 0.055].forEach((o) => {
    g.beginPath(); g.arc(c[0], c[1], s * (0.52 + o), -2.05, -1.30); g.stroke(); });
  // barnacles: little cones on the whorl, inside the outline
  [[-0.34,-0.84,0.024],[-0.47,-0.74,0.019],[-0.58,-0.54,0.017],[-0.24,-0.30,0.015]].forEach(([bx, by, br]) => {
    const q = u(bx, by), r0 = s * br;
    g.beginPath(); g.moveTo(q[0] - r0, q[1] + r0 * 0.55); g.lineTo(q[0] - r0 * 0.35, q[1] - r0);
    g.lineTo(q[0] + r0 * 0.35, q[1] - r0); g.lineTo(q[0] + r0, q[1] + r0 * 0.55); g.closePath();
    F(colour); g.fill(); ink(LW * 0.42); g.stroke();
    ink(LW * 0.36); g.beginPath(); g.moveTo(q[0] - r0 * 0.14, q[1] - r0 * 0.50); g.lineTo(q[0], q[1] + r0 * 0.28); g.stroke();
  });
  // the aperture: a thin lip, a dark inside
  const ap = u(-0.005, -0.35);
  g.beginPath(); g.ellipse(ap[0], ap[1], s * 0.115, s * 0.155, facing * 0.30, 0, 7);
  F(colour); g.fill(); ink(LW * 0.95); g.stroke();
  g.beginPath(); g.ellipse(ap[0] - s * 0.010, ap[1] + s * 0.012, s * 0.082, s * 0.118, facing * 0.30, 0, 7);
  F(LOOK.rockDark); g.fill(); ink(LW * 0.55); g.stroke();

'@

$t = $t.Substring(0, $a) + $new + $t.Substring($b)
[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output "patched shell v4"
