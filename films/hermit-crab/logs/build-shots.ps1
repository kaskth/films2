$p = 'D:\coda\films2\films\hermit-crab\engine\arena.html'
$lines = [IO.File]::ReadAllLines($p)

# --- cut the prize + the two crabs out of world(): they belong to a shot, not the backdrop
$a = -1; $b = -1
for ($i = 0; $i -lt $lines.Length; $i++) {
  if ($lines[$i] -like '*// the prize*') { $a = $i }
  if ($a -ge 0 -and $lines[$i] -like '*LOOK.shellB, -1);*') { $b = $i; break }
}
if ($a -ge 0 -and $b -gt $a) {
  $lines = $lines[0..($a-1)] + $lines[($b+1)..($lines.Length-1)]
  Write-Output "cut prize+crabs: lines $a..$b"
} else { Write-Output "cut markers missing a=$a b=$b" }

# --- replace the contract with the shot system
$c = -1
for ($i = 0; $i -lt $lines.Length; $i++) { if ($lines[$i] -like '*---- contract*') { $c = $i; break } }
if ($c -lt 0) { Write-Output 'contract marker missing'; exit 1 }
$lines = $lines[0..($c-1)]

$tail = @'
// ---------------------------------------------------------------- shots
const SHOTS = [
  { id:'S01', a:0,   b:58  }, { id:'S02', a:58,  b:118 }, { id:'S03', a:118, b:158 },
  { id:'S04', a:158, b:209 }, { id:'S05', a:209, b:274 }, { id:'S06', a:274, b:305 },
  { id:'S07', a:305, b:384 }, { id:'S08', a:384, b:480 }, { id:'S09', a:480, b:720 }
];
const FPS2 = 24;
const ease = (u) => u * u * (3 - 2 * u);
const lerp = (x, y, u) => x + (y - x) * u;

function camera(id, u) {
  switch (id) {
    case 'S01': return { k: lerp(3.2, 1.0, ease(u)), fx: lerp(0.30, 0.50, ease(u)), fy: lerp(0.88, 0.60, ease(u)) };
    case 'S02': return { k: 1.0, fx: 0.5 + 0.014 * u, fy: 0.585 };
    case 'S03': return { k: lerp(1.45, 1.9, ease(u)), fx: lerp(0.40, 0.52, u), fy: 0.475 };
    case 'S04': return { k: 2.05, fx: 0.34, fy: 0.755 };
    case 'S05': return { k: lerp(1.30, 1.52, ease(u)), fx: 0.47, fy: 0.735 };
    case 'S06': return { k: 1.70, fx: 0.47, fy: 0.795 };
    case 'S07': return { k: 1.03, fx: 0.50, fy: 0.615 };
    case 'S08': return { k: lerp(1.85, 2.30, ease(u)), fx: 0.53, fy: 0.705 };
    case 'S09': return { k: lerp(2.5, 4.4, u * u), fx: 0.52, fy: 0.615 };
    default:    return { k: 1.0, fx: 0.5, fy: 0.6 };
  }
}

// flat sand burst: a fan of grit, no blur
function burst(cx, cy, r, n, spread, seed) {
  for (let i = 0; i < n; i++) {
    const a = -Math.PI / 2 + (i / (n - 1) - 0.5) * spread + Math.sin(i * 12.9 + seed) * 0.09;
    const d = r * (0.45 + 0.55 * Math.abs(Math.sin(i * 7.3 + seed)));
    const x = cx + Math.cos(a) * d, y = cy + Math.sin(a) * d * 0.62;
    const s2 = r * (0.020 + 0.020 * Math.abs(Math.cos(i * 3.1)));
    g.beginPath(); g.moveTo(cx, cy);
    g.lineTo(x - s2, y); g.lineTo(x + s2, y); g.closePath();
    F(i % 3 ? LOOK.sandTop : LOOK.sandMid); g.fill();
  }
}

// a cloud of sand: four flat blobs over the fight
function sandCloud(cx, cy, r) {
  [[-0.55, 0.10, 0.62], [0.00, -0.18, 0.80], [0.55, 0.06, 0.66], [0.10, 0.26, 0.72]].forEach(([ox, oy, rr], i) => {
    g.beginPath(); g.arc(cx + ox * r, cy + oy * r, r * rr, 0, 7);
    F(i % 2 ? LOOK.sandMid : LOOK.sandTop); g.fill();
    I(LW * 0.8); g.stroke();
  });
}

// the queue: eye pairs that have stepped off the ridge
function queue(rows, scale, alpha) {
  rows.forEach(([x, y, k], i) => {
    const r = S * 0.020 * k * scale, gap = r * 1.5, hx = X(x), hy = Y(y);
    F(LOOK.rockDark); g.beginPath(); g.arc(hx, hy + r * 2.1, r * 3.0, Math.PI, 2 * Math.PI); g.closePath(); g.fill();
    [-gap, gap].forEach((ox) => {
      F(LOOK.foam); g.beginPath(); g.arc(hx + ox - r * 0.10, hy, r, 0, 7); g.fill();
      I(LW * 0.5); g.beginPath(); g.arc(hx + ox - r * 0.10, hy, r, 0, 7); g.stroke();
      F(LOOK.ink); g.beginPath(); g.arc(hx + ox + r * 0.22, hy + r * 0.04, r * 0.42, 0, 7); g.fill();
    });
  });
}

function actors(id, t, L) {
  const A = (x, y, s, pose) => crab(g, X(x), Y(y), S * s, LOOK.shellA, 1, pose);
  const B = (x, y, s, pose) => crab(g, X(x), Y(y), S * s, LOOK.shellB, -1, pose);
  const prize = (x, y, s) => {
    shell(g, X(x), Y(y), S * s, -0.16, LOOK.prize, true);
    F(LOOK.sandLo); g.globalAlpha = 0.72;
    P([[x - 0.082, y + 0.040], [x + 0.082, y + 0.034], [x + 0.066, y + 0.064], [x - 0.096, y + 0.070]]);
    g.fill(); g.globalAlpha = 1;
    shell(g, X(x), Y(y), S * s, -0.16, LOOK.prize, false);
  };

  switch (id) {
    case 'S01': {                       // the first blow, then the arena opens
      burst(X(0.30), Y(0.99), S * 0.30, 11, 2.2, 3);
      A(0.30, 1.02, 0.42, 'lunge');
      break;
    }
    case 'S02': {                       // the standoff
      prize(0.500, 0.836, 0.170);
      A(0.238, 0.952, 0.360, 'stand');
      B(0.762, 0.952, 0.360, 'stand');
      break;
    }
    case 'S03': break;                  // the ridge only
    case 'S04': {                       // the rules, tapped on the sand
      const tap = (t > 0.9 && t < 1.1) || (t > 1.9 && t < 2.1) ? 1 : 0;
      if (tap) burst(X(0.30), Y(0.985), S * 0.09, 5, 1.4, t);
      A(0.34, 0.965, 0.40, 'stand');
      break;
    }
    case 'S05': {                       // the charge and the cloud
      const u = Math.min(1, t / 0.9);
      A(lerp(0.30, 0.42, u), 0.965, 0.40, 'lunge');
      B(lerp(0.74, 0.60, u), 0.965, 0.40, 'brace');
      if (t > 0.75) sandCloud(X(0.51), Y(0.86), S * (0.16 + 0.10 * Math.min(1, (t - 0.75) / 1.2)));
      break;
    }
    case 'S06': {                       // one down, one standing over it
      A(0.395, 0.955, 0.400, 'stand');
      B(0.560, 0.955, 0.400, 'flip');
      break;
    }
    case 'S07': {                       // the loser walks off with nothing on its back
      A(0.300, 0.955, 0.395, 'stand');
      B(lerp(0.700, 0.880, Math.min(1, t / 2.6)), 0.955, 0.330, 'naked');
      break;
    }
    case 'S08': {                       // the prize taken, and the queue has arrived
      A(0.420, 0.955, 0.400, 'stand');
      queue([[0.60, 0.700, 1.00], [0.72, 0.688, 0.92], [0.84, 0.702, 0.86], [0.95, 0.690, 0.80]],
            0.85 + 0.25 * Math.min(1, t / L), 1);
      break;
    }
    case 'S09': {                       // the line fills the frame
      const push = Math.min(1, t / L);
      queue([[0.30, 0.560, 1.30], [0.50, 0.545, 1.40], [0.70, 0.560, 1.25], [0.88, 0.548, 1.15]],
            1.0 + 0.9 * push, 1);
      const ex = X(0.505), ey = Y(0.620), r = S * (0.052 - 0.020 * push);
      F(LOOK.foam); g.beginPath(); g.arc(ex, ey, r, 0, 7); g.fill();
      I(LW * 1.0); g.beginPath(); g.arc(ex, ey, r, 0, 7); g.stroke();
      F(LOOK.ink); g.beginPath(); g.arc(ex + r * 0.24, ey + r * 0.05, r * 0.44, 0, 7); g.fill();
      break;
    }
  }
}

function shotAt(f) {
  for (const s of SHOTS) if (f >= s.a && f < s.b) return s;
  return SHOTS[SHOTS.length - 1];
}

window.renderFrame = (i) => {
  g.setTransform(1, 0, 0, 1, 0, 0);
  const sh = shotAt(i);
  const t = (i - sh.a) / FPS2, L = (sh.b - sh.a) / FPS2;
  const cam = camera(sh.id, Math.max(0, Math.min(1, t / L)));
  g.save();
  g.translate(W / 2, H / 2); g.scale(cam.k, cam.k); g.translate(-cam.fx * W, -cam.fy * H);
  world(0);
  actors(sh.id, t, L);
  g.restore();
  if (sh.id === 'S09') {                                  // the cut to black
    const p = Math.max(0, (t - (L - 1.2)) / 1.2);
    if (p > 0) { F(LOOK.ink); g.globalAlpha = p * 0.92; g.fillRect(0, 0, W, H); g.globalAlpha = 1; }
  }
};
window.captureFrame = (i, type = 'image/png', quality = 0.95) => { window.renderFrame(i); return canvas.toDataURL(type, quality); };
window.READY = Promise.resolve({ frames: 720, fps: FPS2, width: W, height: H, renderer: 'canvas2d' });
window.renderFrame(0);
</script>
</body>
</html>
'@

[IO.File]::WriteAllLines($p, ($lines + $tail), (New-Object System.Text.UTF8Encoding($false)))
Write-Output ('built: ' + ($lines.Length + $tail.Count) + ' lines')
