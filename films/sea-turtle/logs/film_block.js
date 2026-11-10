// Cues are shared by picture and sound, so a hit on screen and its sound land on the same frame.
const CUES = { hatch: 0.5, nest: 3.2, wide: 5.6, flap: 8.8, tired: 11.2, crab: 13.8, shadow: 16.2, gull: 17.3,
  chase: 18.8, sea: 21.2, fish: 23.0, jaws: 23.45, odds: 25.0, stare: 28.4, end: DURATION };

// Narration: one row per line, dur measured from its WAV (ffprobe audio/vo/VO1.wav).
const VO = [
  { id: 'VO1', at: 0.35, dur: 2.65 }, { id: 'VO2', at: 3.4, dur: 1.70 }, { id: 'VO3', at: 5.8, dur: 2.72 },
  { id: 'VO4', at: 9.0, dur: 4.50 }, { id: 'VO5', at: 14.15, dur: 1.68 }, { id: 'VO6', at: 16.55, dur: 1.47 },
  { id: 'VO7', at: 21.45, dur: 3.00 }, { id: 'VO8', at: 25.3, dur: 2.58 }, { id: 'VO9', at: 28.6, dur: 1.02 },
];
const CAPTIONS = null;
const CAPTION_STYLE = { role: 'display', accentRole: 'display', size: 0.062, caps: false, ink: PALETTE.ink, hi: PALETTE.ink, accent: PALETTE.accent, punch: 0.07 };

const AMB_BEACH = { kind: 'water', gain: 0.035 }, AMB_SEA = { kind: 'water', gain: 0.07 };
const SCENES = [
  { from: 0, to: CUES.nest, draw: s1Hatch, action: 'the sand bursts and the turtle pops out and blinks', amb: AMB_BEACH },
  { from: CUES.nest, to: CUES.wide, draw: s2Nest, action: 'the turtle looks at the empty nest; the tracks lead away', amb: AMB_BEACH },
  { from: CUES.wide, to: CUES.flap, draw: s3Wide, action: 'a tiny turtle on a huge beach, the sea far away', amb: AMB_BEACH },
  { from: CUES.flap, to: CUES.tired, draw: s4Flap, action: 'the turtle flaps hard and barely moves', amb: AMB_BEACH },
  { from: CUES.tired, to: CUES.crab, draw: s5Tired, action: 'close up: the turtle pants, sweating', amb: AMB_BEACH },
  { from: CUES.crab, to: CUES.shadow, draw: s6Crab, action: 'a crab rises from its hole and tucks in a napkin', amb: AMB_BEACH },
  { from: CUES.shadow, to: CUES.gull, draw: s7Shadow, action: 'a gull shadow sweeps over the turtle', amb: AMB_BEACH },
  { from: CUES.gull, to: CUES.chase, draw: s8Gull, action: 'the gull raises its knife and fork', amb: AMB_BEACH },
  { from: CUES.chase, to: CUES.sea, draw: s9Chase, action: 'the turtle runs, crab and gull behind', in: { type: 'whip', dur: 0.3, dir: 1 }, amb: AMB_BEACH },
  { from: CUES.sea, to: CUES.fish, draw: s10Sea, action: 'the turtle splashes into the sea, relieved', amb: AMB_SEA },
  { from: CUES.fish, to: CUES.odds, draw: s11Fish, action: 'a huge fish opens its jaws behind the turtle', amb: AMB_SEA },
  { from: CUES.odds, to: CUES.stare, draw: s12Odds, action: 'a thousand turtles vanish until one is left', amb: { kind: 'air', gain: 0.02 } },
  { from: CUES.stare, to: CUES.end, draw: s13Stare, action: 'the turtle stares at the camera, worried', amb: AMB_BEACH },
];

// Picture-locked sound effects (cartoon pops are in score(): pop()).
const flaps = (a, b, every, gain) => { const o = []; for (let t = a; t < b; t += every) o.push({ at: +t.toFixed(3), voice: 'foley', kind: 'step', gain, wet: 0.1 }); return o; };
const SFX = [
  { at: CUES.hatch, voice: 'foley', kind: 'cloth', gain: 0.35, wet: 0.1 },        // sand bursts
  { at: 1.6, voice: 'tick', gain: 0.12 },                                          // blink
  ...flaps(CUES.flap + 0.1, CUES.tired - 0.1, 0.25, 0.14),                         // fins slap the sand
  { at: CUES.crab + 0.05, voice: 'foley', kind: 'cloth', gain: 0.3, wet: 0.1 },   // crab digs out
  { at: CUES.shadow + 0.1, voice: 'air', dur: 1.0, gain: 0.22, wet: 0.2 },        // the gull swoops over
  { at: CUES.gull + 0.25, voice: 'foley', kind: 'tap', gain: 0.4, wet: 0.2 },     // knife on fork
  { at: CUES.gull + 0.45, voice: 'foley', kind: 'tap', gain: 0.35, wet: 0.2 },
  { at: CUES.chase - 0.3, voice: 'whoosh', dur: 0.6, gain: 0.35, wet: 0.2 },      // whip pan into the chase
  ...flaps(CUES.chase + 0.2, CUES.sea - 0.1, 0.16, 0.12),
  { at: CUES.sea, voice: 'air', dur: 0.7, gain: 0.3, wet: 0.3 },                   // splash
  { at: CUES.sea + 0.02, voice: 'foley', kind: 'cloth', gain: 0.4, wet: 0.3 },
  { at: CUES.jaws, voice: 'hit', gain: 0.85, wet: 0.35 },                          // the jaws open
];

const ROOM = { secs: 1.6, decay: 3.6, tone: 4200 };
const ARRANGEMENT = [ { section: 'none', from: 0, to: CUES.end, parts: [] } ];   // no music (user)

// ---------- drawing kit for this film: flat 2D, thick ink line, a 1920x1080 virtual frame ----------
const C = { sky: '#f8f8f6', sand: '#d8b56c', sandD: '#b8934e', sandL: '#e3c584', sea: '#3f8fb0', seaD: '#2f6f8c', foam: '#e9f4f6',
  skin: '#93b862', skinD: '#6f9a4f', shell: '#7a5a2e', shellL: '#94703a', belly: '#e6d28f', crab: '#e0703a', crabD: '#b8542a',
  gull: '#ffffff', gullG: '#b9c2c9', beak: '#f2b632', leg: '#e89a3c', ink: '#1a1410', fish: '#56788a', fishD: '#3c5868',
  mouth: '#3a1e24', sweat: '#9fd6ea', white: '#ffffff', pit: '#a9864a' };
const LW = 7;
function V(g, S, z = 1, cx = 960, cy = 540) {          // virtual 1920x1080; zoom z about the point (cx, cy)
  const s = S.W / 1920; g.setTransform(s * z, 0, 0, s * z, s * cx * (1 - z), s * cy * (1 - z));
  g.lineJoin = 'round'; g.lineCap = 'round';
}
function fs(g, fill, lw = LW) {
  if (fill) { g.fillStyle = fill; g.fill(); }
  if (lw) { g.lineWidth = lw; g.strokeStyle = C.ink; g.stroke(); }
}
function ell(g, x, y, rx, ry, rot = 0) { g.beginPath(); g.ellipse(x, y, Math.max(0.1, rx), Math.max(0.1, ry), rot, 0, TAU); }
function ln(g, pts, lw = LW, col = C.ink) { g.beginPath(); pts.forEach(([x, y], i) => (i ? g.lineTo(x, y) : g.moveTo(x, y))); g.lineWidth = lw; g.strokeStyle = col; g.stroke(); }
const edgeY = (x, y0, amp, wl, ph) => y0 + amp * Math.sin((x + ph) / wl * TAU) + amp * 0.45 * Math.sin((x * 1.7 + ph * 0.6) / wl * TAU);
function band(g, y0, fill, amp = 10, wl = 300, ph = 0, x0 = -600, x1 = 2600, bottom = 1500) {
  g.beginPath(); g.moveTo(x0, bottom);
  for (let x = x0; x <= x1; x += 16) g.lineTo(x, edgeY(x, y0, amp, wl, ph));
  g.lineTo(x1, bottom); g.closePath(); g.fillStyle = fill; g.fill();
  g.beginPath(); for (let x = x0; x <= x1; x += 16) (x === x0 ? g.moveTo(x, edgeY(x, y0, amp, wl, ph)) : g.lineTo(x, edgeY(x, y0, amp, wl, ph)));
  g.lineWidth = LW; g.strokeStyle = C.ink; g.stroke();
}
function marks(g, n, x0, x1, y0, y1, salt, len = 26, scroll = 0) {   // little ink dashes on the sand, seeded
  const r = rng(salt), span = x1 - x0;
  g.lineWidth = 4; g.strokeStyle = C.ink;
  for (let i = 0; i < n; i++) {
    const x = x0 + (((r() * span - scroll) % span) + span) % span, y = y0 + r() * (y1 - y0), l = len * (0.6 + 0.6 * r()) * (0.5 + 0.5 * (y - y0) / Math.max(1, y1 - y0));
    g.beginPath(); g.moveTo(x - l / 2, y); g.quadraticCurveTo(x, y - l * 0.35, x + l / 2, y); g.stroke();
  }
}
function sky(g) { g.fillStyle = C.sky; g.fillRect(-600, -600, 3200, 2400); }
function sea(g, y0, t, x0 = -600, x1 = 2600) {         // the sea as a band with moving foam lines
  band(g, y0, C.sea, 6, 220, t * 40, x0, x1);
  g.save(); g.globalAlpha = 0.9;
  for (let i = 0; i < 3; i++) {
    const y = y0 + 22 + i * 26, ph = t * (30 + i * 12) + i * 90;
    g.beginPath(); for (let x = x0; x <= x1; x += 16) (x === x0 ? g.moveTo(x, edgeY(x, y, 3, 140, ph)) : g.lineTo(x, edgeY(x, y, 3, 140, ph)));
    g.lineWidth = 3; g.strokeStyle = C.foam; g.setLineDash([60, 90]); g.lineDashOffset = -ph; g.stroke(); g.setLineDash([]);
  }
  g.restore();
}
const blinkAt = (t, at) => at.some((a) => t >= a && t < a + 0.13);
function sweat(g, x, y, s, phase) {                     // a drop that slides down and fades
  const k = ((phase % 1) + 1) % 1, yy = y + 40 * k * s;
  g.save(); g.globalAlpha = 1 - k * 0.7;
  g.beginPath(); g.moveTo(x, yy - 18 * s); g.quadraticCurveTo(x + 11 * s, yy, x, yy + 10 * s); g.quadraticCurveTo(x - 11 * s, yy, x, yy - 18 * s);
  fs(g, C.sweat, LW * 0.6); g.restore();
}
// The turtle, side view, facing right (dir -1 = left). flap: fin phase (rad) · mood: flat | angry | worried | happy · look: head tilt
function turtleSide(g, x, y, s, o = {}) {
  const d = o.dir ?? 1, f = o.flap ?? 0, sw = Math.sin(f), cw = Math.cos(f), lw = LW / s;
  g.save(); g.translate(x, y); g.scale(d * s, s);
  g.save(); g.translate(60, 4); g.rotate(-0.4 - 0.6 * sw); ell(g, 40, 0, 52, 14); fs(g, C.skinD, lw); g.restore();    // far fins
  g.save(); g.translate(-78, 10); g.rotate(0.4 + 0.4 * cw); ell(g, -24, 0, 32, 12); fs(g, C.skinD, lw); g.restore();
  g.beginPath(); g.moveTo(-104, 6); g.lineTo(-138, 18); g.lineTo(-104, 20); g.closePath(); fs(g, C.skin, lw);           // tail
  g.save(); g.translate(88, -6); g.rotate(o.look ?? 0);                                                                     // neck + head
  g.beginPath(); g.moveTo(-24, -18); g.quadraticCurveTo(20, -30, 44, -22); g.lineTo(44, 14); g.quadraticCurveTo(18, 20, -24, 16); g.closePath(); fs(g, C.skin, lw);
  ell(g, 70, -16, 46, 34); fs(g, C.skin, lw);
  const m = o.mood ?? 'flat';
  if (m === 'happy') { g.beginPath(); g.arc(82, -20, 9, Math.PI * 1.1, Math.PI * 1.9); g.lineWidth = lw; g.strokeStyle = C.ink; g.stroke(); }
  else if (o.blink) ln(g, [[74, -24], [90, -24]], lw);
  else { ell(g, 82, -24, 6.5, 7.5); fs(g, C.ink, 0); }
  const br = { flat: [[64, -44], [98, -44]], angry: [[62, -50], [98, -38]], worried: [[62, -40], [98, -52]], happy: [[64, -46], [98, -46]] }[m];
  ln(g, br, lw * 1.1);
  if (m === 'happy') { g.beginPath(); g.moveTo(92, -2); g.quadraticCurveTo(104, 8, 116, -4); g.lineWidth = lw; g.stroke(); }
  else if (m === 'worried') ln(g, [[92, 0], [99, -4], [106, 0], [113, -4]], lw * 0.8);
  else ln(g, [[92, -2], [116, -6]], lw * 0.9);
  g.restore();
  g.beginPath(); g.moveTo(-112, 12); g.bezierCurveTo(-110, -68, -42, -100, 2, -100); g.bezierCurveTo(60, -100, 104, -60, 100, 12); g.closePath(); fs(g, C.shell, lw);
  g.beginPath(); g.moveTo(-62, 10); g.quadraticCurveTo(-70, -40, -36, -78); g.moveTo(46, 10); g.quadraticCurveTo(54, -40, 30, -80);
  g.moveTo(-86, -36); g.lineTo(82, -36); g.lineWidth = lw * 0.7; g.strokeStyle = C.ink; g.stroke();
  ell(g, -6, 14, 108, 13); fs(g, C.belly, lw);
  g.save(); g.translate(56, 18); g.rotate(0.35 + 0.7 * sw); ell(g, 46, 8, 60, 16, 0.3); fs(g, C.skin, lw); g.restore();  // near fins
  g.save(); g.translate(-82, 22); g.rotate(-0.3 - 0.5 * cw); ell(g, -20, 6, 34, 13); fs(g, C.skin, lw); g.restore();
  g.restore();
}
// The turtle from the front: head, shell behind, two fins. mood: flat | angry | worried | tired | shock
function turtleFront(g, x, y, s, o = {}) {
  const lw = LW / s, f = o.flap ?? 0;
  g.save(); g.translate(x, y); g.scale(s, s);
  ell(g, 0, 150, 220, 120); fs(g, C.shell, lw);
  g.beginPath(); g.moveTo(-150, 90); g.quadraticCurveTo(0, 60, 150, 90); g.moveTo(-90, 40); g.lineTo(-110, 250); g.moveTo(90, 40); g.lineTo(110, 250);
  g.lineWidth = lw * 0.7; g.strokeStyle = C.ink; g.stroke();
  for (const sd of [-1, 1]) { g.save(); g.translate(sd * 150, 175); g.rotate(sd * (0.7 + 0.35 * Math.sin(f))); ell(g, sd * 55, 0, 75, 22); fs(g, C.skin, lw); g.restore(); }
  g.beginPath(); g.moveTo(-52, 30); g.lineTo(-58, 130); g.lineTo(58, 130); g.lineTo(52, 30); g.closePath(); fs(g, C.skin, lw);
  ell(g, 0, 0, 98, 86); fs(g, C.skin, lw);
  const m = o.mood ?? 'flat', ex = 36, ey = -10;
  for (const sd of [-1, 1]) {
    if (m === 'shock') { ell(g, sd * ex, ey, 22, 24); fs(g, C.white, lw * 0.8); ell(g, sd * ex + (o.lookX ?? 0), ey + 3, 8, 9); fs(g, C.ink, 0); }
    else if (o.blink) ln(g, [[sd * ex - 11, ey], [sd * ex + 11, ey]], lw);
    else { ell(g, sd * ex + (o.lookX ?? 0), ey, 9.5, 11); fs(g, C.ink, 0); }
    const inner = sd * 16, outer = sd * 62;
    const yi = { flat: -42, angry: -32, worried: -54, tired: -40, shock: -58 }[m], yo = { flat: -42, angry: -48, worried: -38, tired: -34, shock: -50 }[m];
    ln(g, [[outer, yo], [inner, yi]], lw * 1.15);
  }
  if (m === 'tired') {                                   // open mouth, tongue out
    ell(g, 0, 44, 24, 18 + 4 * Math.sin((o.t ?? 0) * 18)); fs(g, C.mouth, lw);
    ell(g, 4, 58, 11, 9); fs(g, '#e06a72', lw * 0.6);
  } else if (m === 'worried' || m === 'shock') ln(g, [[-24, 44], [-12, 38], [0, 44], [12, 38], [24, 44]], lw * 0.9);
  else ln(g, [[-22, 42], [22, 42]], lw);
  g.restore();
}
function crab(g, x, y, s, o = {}) {
  const lw = LW / s, rub = o.rub ?? 0, t = o.t ?? 0;
  g.save(); g.translate(x, y); g.scale(s, s);
  for (const sd of [-1, 1]) for (let i = 0; i < 3; i++) {
    const p = [[sd * 70, 12 + i * 12], [sd * (125 + i * 10), 40 + i * 6], [sd * (138 + i * 14), 86 + i * 4]];
    ln(g, p, 20 / s); ln(g, p, 9 / s, C.crab);
  }
  for (const sd of [-1, 1]) {                           // arms and claws; rub brings both claws together under the mouth
    const cx = lerp(sd * 150, sd * 46, rub), cy = lerp(-78, 30, rub) + (rub > 0.5 ? 6 * Math.sin(t * 30 + sd) : 0);
    const arm = [[sd * 82, -6], [lerp(sd * 130, sd * 80, rub), lerp(-40, 30, rub)], [cx, cy]];
    ln(g, arm, 22 / s); ln(g, arm, 11 / s, C.crab);
    ell(g, cx, cy, 40, 30, sd * 0.4); fs(g, C.crab, lw);
    ln(g, [[cx + sd * 4, cy - 4], [cx + sd * 40, cy - 14]], lw);
  }
  ell(g, 0, 0, 116, 62); fs(g, C.crab, lw);
  for (const sd of [-1, 1]) {
    ln(g, [[sd * 30, -48], [sd * 38, -112]], 18 / s); ln(g, [[sd * 30, -50], [sd * 38, -110]], 8 / s, C.crab);
    ell(g, sd * 38, -122, 20, 21); fs(g, C.white, lw);
    ell(g, sd * 38 + (o.lookX ?? 0), -120, 8, 9); fs(g, C.ink, 0);
    ln(g, [[sd * 64, -154], [sd * 20, -142]], lw * 1.2);
  }
  g.beginPath(); g.moveTo(-46, 10); g.quadraticCurveTo(0, 46, 46, 10); g.closePath(); fs(g, C.white, lw);     // grin
  ln(g, [[-38, 16], [38, 16]], lw * 0.6);
  const nk = o.napkin ?? 0;
  if (nk > 0) { g.beginPath(); g.moveTo(-50 * nk, 24); g.lineTo(50 * nk, 24); g.lineTo(0, 24 + 100 * nk); g.closePath(); fs(g, C.white, lw);
    ln(g, [[-30 * nk, 40], [30 * nk, 40]], lw * 0.5, '#d9534f'); }
  g.restore();
}
function gull(g, x, y, s, o = {}) {
  const lw = LW / s, raise = o.raise ?? 0, beak = o.beak ?? 0;
  g.save(); g.translate(x, y); g.scale(s, s);
  for (const sd of [-1, 1]) { ln(g, [[sd * 24, 55], [sd * 28, 140], [sd * 28 + 30, 146]], 16 / s); ln(g, [[sd * 24, 55], [sd * 28, 140], [sd * 28 + 30, 146]], 7 / s, C.leg); }
  g.beginPath(); g.moveTo(-110, -10); g.lineTo(-182, -36); g.lineTo(-176, 22); g.closePath(); fs(g, C.gullG, lw);
  ell(g, 0, 0, 128, 74); fs(g, C.gull, lw);
  g.beginPath(); g.moveTo(-100, -30); g.quadraticCurveTo(-10, -60, 70, -26); g.quadraticCurveTo(0, 30, -120, 26); g.closePath(); fs(g, C.gullG, lw);
  ell(g, 98, -88, 58, 54); fs(g, C.gull, lw);
  g.beginPath(); g.moveTo(144, -96); g.lineTo(214, -84 - 10 * beak); g.lineTo(146, -76); g.closePath(); fs(g, C.beak, lw);
  g.beginPath(); g.moveTo(146, -76); g.lineTo(204, -70 + 18 * beak); g.lineTo(140, -62); g.closePath(); fs(g, C.beak, lw);
  ell(g, 116, -100, 8, 9); fs(g, C.ink, 0);
  ln(g, [[92, -128], [140, -114]], lw * 1.2);
  if (o.cutlery) {                                       // knife and fork, raised by the wing tips
    const up = -40 * raise, clink = Math.sin((o.t ?? 0) * 26) * 6 * raise;
    g.save(); g.translate(-10 + clink, -40 + up);
    g.beginPath(); g.rect(-6, -10, 12, 120); fs(g, '#cfd6db', lw * 0.8);
    g.beginPath(); g.moveTo(-6, -10); g.lineTo(-6, -120); g.quadraticCurveTo(22, -90, 6, -10); g.closePath(); fs(g, '#e8edf0', lw * 0.8);
    g.restore();
    g.save(); g.translate(60 - clink, -40 + up);
    g.beginPath(); g.rect(-6, -10, 12, 120); fs(g, '#cfd6db', lw * 0.8);
    g.beginPath(); g.rect(-20, -60, 40, 50); fs(g, '#e8edf0', lw * 0.8);
    for (const tx of [-14, 0, 14]) ln(g, [[tx, -60], [tx, -112]], lw * 0.9);
    g.restore();
    for (const wx of [-10 + clink, 60 - clink]) { ell(g, wx, 40 + up, 22, 16); fs(g, C.gullG, lw); }
  }
  g.restore();
}
function gullShadow(g, x, y, s) {
  g.save(); g.translate(x, y); g.scale(s, s); g.fillStyle = 'rgba(26,20,16,0.32)';
  g.beginPath(); g.ellipse(0, 0, 120, 40, 0, 0, TAU); g.fill();
  g.beginPath(); g.moveTo(-60, -10); g.quadraticCurveTo(-20, -120, 40, -160); g.quadraticCurveTo(30, -60, 50, -10); g.fill();
  g.beginPath(); g.moveTo(-60, 10); g.quadraticCurveTo(-20, 120, 40, 160); g.quadraticCurveTo(30, 60, 50, 10); g.fill();
  g.restore();
}
function fish(g, x, y, s, open, look = -10) {           // a huge fish facing left; open 0..1
  const lw = LW / s, h = 190 * open;
  g.save(); g.translate(x, y); g.scale(s, s);
  g.beginPath(); g.moveTo(520, 0); g.lineTo(700, -150); g.lineTo(690, 150); g.closePath(); fs(g, C.fishD, lw);
  g.beginPath(); g.moveTo(140, -170); g.lineTo(300, -300); g.lineTo(380, -150); g.closePath(); fs(g, C.fishD, lw);
  ell(g, 260, 0, 320, 200); fs(g, C.fish, lw);
  if (open > 0.02) {
    g.beginPath(); g.moveTo(-70, -h); g.lineTo(110, 0); g.lineTo(-70, h); g.closePath(); fs(g, C.mouth, lw);
    g.fillStyle = C.white;
    for (let i = 0; i < 5; i++) { const u = i / 5, ax = lerp(-60, 90, u), ay = -h * (1 - u);
      g.beginPath(); g.moveTo(ax, ay); g.lineTo(ax + 18, ay + h * 0.12 + 6); g.lineTo(ax + 30, lerp(-h, 0, u + 0.2)); g.closePath(); fs(g, C.white, lw * 0.6);
      g.beginPath(); g.moveTo(ax, -ay); g.lineTo(ax + 18, -ay - h * 0.12 - 6); g.lineTo(ax + 30, -lerp(-h, 0, u + 0.2)); g.closePath(); fs(g, C.white, lw * 0.6); }
  }
  ell(g, 150, -100, 38, 38); fs(g, C.white, lw); ell(g, 150 + look, -98, 15, 15); fs(g, C.ink, 0);
  ln(g, [[100, -158], [196, -134]], lw * 1.3);
  g.beginPath(); g.moveTo(300, 40); g.quadraticCurveTo(360, 120, 300, 150); g.lineWidth = lw * 0.8; g.strokeStyle = C.ink; g.stroke();
  g.restore();
}
function tinyTurtle(g, x, y, r) {
  g.fillStyle = C.skin; for (const [dx, dy] of [[-0.9, -0.8], [0.9, -0.8], [-0.8, 0.9], [0.8, 0.9]]) { g.beginPath(); g.arc(x + dx * r, y + dy * r, r * 0.42, 0, TAU); g.fill(); }
  g.beginPath(); g.arc(x, y - r * 1.25, r * 0.45, 0, TAU); g.fill();
  g.beginPath(); g.ellipse(x, y, r, r * 1.1, 0, 0, TAU); g.fillStyle = C.shell; g.fill(); g.lineWidth = 2.5; g.strokeStyle = C.ink; g.stroke();
}
function numberText(g, str, x, y, size, alpha = 1) {
  g.save(); g.globalAlpha = alpha; g.font = `900 ${size}px "Arial Black", Impact, system-ui, sans-serif`; g.textAlign = 'center'; g.textBaseline = 'middle';
  g.lineWidth = size * 0.11; g.strokeStyle = C.ink; g.lineJoin = 'round'; g.strokeText(str, x, y); g.fillStyle = C.white; g.fillText(str, x, y); g.restore();
}

// ---------- the scenes (g, k = 0..1 through the scene, t = film time, S) ----------
function beach(g, horizon, t, seaFrom = -600) {          // sky, the sea strip on the horizon, the sand
  sky(g); sea(g, horizon, t, seaFrom); band(g, horizon + 70, C.sand, 9, 340, 120);
}
function s1Hatch(g, k, t, S) {
  // push in, 3.2 s, slow ease-out, on the mound (the sand shakes from frame 0)
  V(g, S, lerp(1, 1.1, EASE.out(k)), 960, 640);
  beach(g, 300, t); marks(g, 40, -200, 2100, 460, 1080, 3);
  const pop = MOTION.at(t, CUES.hatch, 0.6), shake = t < CUES.hatch ? 8 * Math.sin(t * 70) * (t / CUES.hatch) : 0;
  const rise = MOTION.spring(t - CUES.hatch, 0.45, 2.2);
  turtleFront(g, 960 + shake * 0.3, lerp(900, 560, clamp(rise, 0, 1.2)), 1.05,
    { mood: t < 2.2 ? 'flat' : 'angry', blink: blinkAt(t, [1.6]) });
  g.save(); ell(g, 960 + shake, 820, lerp(150, 330, pop), lerp(60, 90, pop)); fs(g, C.sandD); g.restore();   // the mound / the hole
  band(g, 860, C.sand, 6, 260, 40, -600, 2600);
  if (t >= CUES.hatch) {                                 // sand grains thrown out on arcs
    const r = rng(41), u = clamp((t - CUES.hatch) / 1.1);
    for (let i = 0; i < 26; i++) {
      const a = -Math.PI * (0.15 + 0.7 * r()), v = 500 + 500 * r(), px = 960 + Math.cos(a) * v * u, py = 800 + Math.sin(a) * v * u + 900 * u * u;
      if (u < 1) { ell(g, px, py, 9 + 8 * r(), 7 + 6 * r()); fs(g, i % 3 ? C.sandD : C.sand, 4); }
    }
  }
  if (t < CUES.hatch) { const r = rng(9); for (let i = 0; i < 8; i++) { ell(g, 960 + (r() - 0.5) * 220 + shake, 800 - r() * 30 - 18 * Math.abs(Math.sin(t * 20 + i)), 8, 6); fs(g, C.sandD, 4); } }
}
function s2Nest(g, k, t, S) {
  // truck right, 2.4 s, ease-in-out, along the mother's tracks to the sea
  V(g, S); g.translate(-lerp(0, 760, EASE.inOut(k)), 0);
  sky(g); sea(g, 330, t, 1300, 3400); band(g, 400, C.sand, 9, 340, 120, -600, 3400); marks(g, 50, -200, 3200, 520, 1080, 5);
  ell(g, 520, 830, 260, 90); fs(g, C.pit);
  const r = rng(13);                                     // broken shells in the nest
  for (let i = 0; i < 7; i++) { const x = 360 + i * 50 + r() * 20, y = 820 + (r() - 0.5) * 60;
    g.beginPath(); g.moveTo(x - 22, y); g.lineTo(x - 14, y - 16); g.lineTo(x - 4, y - 6); g.lineTo(x + 6, y - 18); g.lineTo(x + 16, y - 4); g.lineTo(x + 22, y);
    g.quadraticCurveTo(x, y + 20, x - 22, y); fs(g, C.white, 5); }
  for (let i = 0; i < 18; i++) {                         // the mother's flipper tracks, shrinking toward the sea
    const u = i / 17, x = lerp(800, 2700, u), y = lerp(860, 440, u), sc = lerp(1, 0.3, u);
    for (const sd of [-1, 1]) { g.beginPath(); g.moveTo(x - 30 * sc, y + sd * 55 * sc); g.quadraticCurveTo(x, y + sd * 40 * sc, x + 24 * sc, y + sd * 62 * sc); g.lineWidth = 6 * sc + 2; g.strokeStyle = C.sandD; g.stroke(); }
  }
  turtleSide(g, 760, 760, 0.85, { look: lerp(0.05, -0.12, EASE.inOut(k)), mood: 'flat', blink: blinkAt(t, [4.6]) });
}
function s3Wide(g, k, t, S) {
  // zoom out, 3.2 s, slow ease-out, on the whole beach (the turtle tiny in the corner)
  V(g, S, lerp(1.25, 1, EASE.out(k)), 240, 900);
  sky(g); sea(g, 250, t, 1500); band(g, 320, C.sand, 7, 420, 60); marks(g, 70, -400, 2400, 420, 1080, 7, 20);
  g.beginPath(); for (let x = 1500; x <= 2600; x += 16) (x === 1500 ? g.moveTo(x, edgeY(x, 250, 6, 220, t * 40)) : g.lineTo(x, edgeY(x, 250, 6, 220, t * 40)));
  turtleSide(g, 240, 905, 0.22, { flap: t * 9, mood: 'worried', blink: blinkAt(t, [7.4]) });
}
function s4Flap(g, k, t, S) {
  // truck right, 2.4 s, linear, at the turtle's pace (the sand barely slides)
  V(g, S); sky(g); sea(g, 260, t, 1400); band(g, 330, C.sand, 9, 340, 120);
  marks(g, 60, -200, 2200, 430, 1080, 11, 30, (t - CUES.flap) * 35);
  const bob = Math.abs(Math.sin(t * 14)) * 10;
  turtleSide(g, 880, 760 - bob, 1.55, { flap: t * 14, mood: 'angry', look: -0.05 });
  for (let i = 0; i < 3; i++) sweat(g, 1110 + i * 26, 600 + i * 10, 1.4, t * 1.6 + i * 0.33);
  const r = rng(17);                                     // sand kicked back by each stroke
  for (let i = 0; i < 10; i++) { const ph = (t * 4 + r()) % 1; ell(g, 660 - ph * 260, 820 - Math.sin(ph * Math.PI) * 90 - r() * 30, 7, 5); fs(g, C.sandD, 3); }
}
function s5Tired(g, k, t, S) {
  // push in, 2.6 s, slow ease-in-out, on the panting face
  V(g, S, lerp(1, 1.12, EASE.inOut(k)), 960, 520);
  sky(g); sea(g, 200, t); band(g, 270, C.sand, 9, 340, 30); marks(g, 40, -200, 2200, 380, 1080, 19);
  turtleFront(g, 960, 520 + 6 * Math.sin(t * 9), 1.75, { mood: 'tired', t, flap: t * 3 });
  for (let i = 0; i < 4; i++) sweat(g, i < 2 ? 760 - i * 40 : 1160 + (i - 2) * 40, 380 + (i % 2) * 40, 1.6, t * 1.3 + i * 0.27);
}
function s6Crab(g, k, t, S) {
  // push in, 2.4 s, ease-out, toward the crab
  V(g, S, lerp(1, 1.1, EASE.out(k)), 1250, 640);
  sky(g); sea(g, 240, t); band(g, 310, C.sand, 9, 340, 200); marks(g, 50, -200, 2200, 420, 1080, 23);
  const tt = t - CUES.crab, up = MOTION.spring(tt - 0.05, 0.5, 2.4);
  g.save(); g.beginPath(); g.rect(-600, -600, 3200, 1400); g.clip();                        // the crab rises out of its hole
  crab(g, 1300, lerp(1000, 740, clamp(up, 0, 1.15)), 1.35, { lookX: -8, napkin: EASE.out(MOTION.at(tt, 0.95, 0.35)), rub: EASE.inOut(MOTION.at(tt, 1.35, 0.3)), t });
  g.restore();
  ell(g, 1300, 870, 200, 40); fs(g, C.pit, LW);
  band(g, 880, C.sand, 5, 300, 10);
  turtleSide(g, 260, 900, 0.75, { mood: 'flat', flap: t * 10, blink: blinkAt(t, [15.4]) });
}
function s7Shadow(g, k, t, S) {
  // locked, 1.1 s: the gull's shadow crosses right to left over the turtle
  V(g, S); sky(g); sea(g, 240, t); band(g, 310, C.sand, 9, 340, 260); marks(g, 50, -200, 2200, 420, 1080, 29);
  const u = EASE.inOut(k), up = MOTION.at(k, 0.25, 0.3);
  turtleSide(g, 960, 760, 1.3, { mood: 'worried', look: lerp(0, -0.45, EASE.out(up)) });
  gullShadow(g, lerp(2300, -400, u), 800, 2.4);
}
function s8Gull(g, k, t, S) {
  // locked, 1.5 s, low angle: the gull fills the frame and raises its cutlery
  V(g, S, 1.02 + 0.02 * k, 960, 700);
  sky(g); band(g, 900, C.sand, 6, 380, 80); marks(g, 20, -200, 2200, 960, 1080, 31);
  const tt = t - CUES.gull, bob = Math.sin(tt * 10) * 6;
  gull(g, 900, 640 + bob, 2.6, { cutlery: true, raise: EASE.out(MOTION.at(tt, 0.05, 0.3)), beak: 0.5 + 0.5 * Math.sin(tt * 8), t });
}
function s9Chase(g, k, t, S) {
  // truck right, 2.4 s, fast and steady, with the chase (the sand streams past)
  V(g, S); sky(g); sea(g, 250, t, -600); band(g, 320, C.sand, 9, 340, -(t - CUES.chase) * 900);
  marks(g, 70, -200, 2200, 420, 1080, 37, 30, (t - CUES.chase) * 1400);
  g.lineWidth = 5; g.strokeStyle = C.ink;                // speed lines
  const r = rng(43); for (let i = 0; i < 9; i++) { const y = 420 + r() * 600, x = 2100 - (((t * 2600 + r() * 2000) % 2600)); g.beginPath(); g.moveTo(x, y); g.lineTo(x + 160, y); g.stroke(); }
  const run = Math.abs(Math.sin(t * 22)) * 14;
  crab(g, 380, 830 - Math.abs(Math.sin(t * 18)) * 18, 0.7, { lookX: 8, napkin: 1, rub: 0, t });
  gull(g, 560, 360 + Math.sin(t * 6) * 20, 0.75, { cutlery: true, raise: 1, beak: 0.6, t });
  turtleSide(g, 1300, 820 - run, 0.95, { flap: t * 22, mood: 'worried' });
  for (let i = 0; i < 2; i++) sweat(g, 1450 + i * 24, 700, 1, t * 2.2 + i * 0.5);
}
function s10Sea(g, k, t, S) {
  // locked, 1.8 s, at the waterline: splash, then relief
  V(g, S); sky(g);
  const tt = t - CUES.sea;
  band(g, 360, C.sea, 10, 260, t * 50);
  turtleSide(g, 960, 470 + 8 * Math.sin(t * 4), 1.25, { mood: tt > 0.5 ? 'happy' : 'worried', flap: t * 4 });
  g.save(); g.globalAlpha = 0.82; band(g, 495, C.sea, 9, 230, -t * 40); g.restore();
  for (let i = 0; i < 3; i++) { g.beginPath(); for (let x = -100; x <= 2100; x += 16) (x === -100 ? g.moveTo(x, edgeY(x, 560 + i * 120, 4, 180, t * 60 + i * 50)) : g.lineTo(x, edgeY(x, 560 + i * 120, 4, 180, t * 60 + i * 50)));
    g.lineWidth = 4; g.strokeStyle = C.foam; g.setLineDash([80, 120]); g.stroke(); g.setLineDash([]); }
  if (tt < 0.7) { const r = rng(51), u = tt / 0.7;                   // splash drops
    for (let i = 0; i < 18; i++) { const a = -Math.PI * (0.1 + 0.8 * r()), v = 260 + 300 * r();
      ell(g, 960 + Math.cos(a) * v * u, 480 + Math.sin(a) * v * u + 700 * u * u, 12, 16); fs(g, C.foam, 4); } }
}
function s11Fish(g, k, t, S) {
  // push in, 2 s, fast ease-out on the jaws opening
  const tt = t - CUES.fish, jaws = EASE.out(MOTION.at(t, CUES.jaws, 0.35));
  V(g, S, lerp(1, 1.08, jaws), 960, 520); sky(g);
  band(g, 360, C.sea, 10, 260, t * 50);
  g.save(); g.globalAlpha = lerp(0.55, 1, jaws); fish(g, 1080, lerp(760, 560, EASE.out(clamp(tt / 0.5))), 1.25, jaws, -16); g.restore();
  turtleSide(g, 760, 470 + 8 * Math.sin(t * 4), 1.25, { mood: jaws > 0.3 ? 'worried' : 'happy', flap: t * 4, look: jaws > 0.3 ? 0.08 : 0 });
  g.save(); g.globalAlpha = 0.7; band(g, 495, C.sea, 9, 230, -t * 40); g.restore();
  if (jaws > 0.3) for (let i = 0; i < 2; i++) sweat(g, 900 + i * 26, 360, 1.3, t * 2 + i * 0.5);
}
function s13Stare(g, k, t, S) {
  // push in, 1.6 s, slow ease-in, on the eyes
  V(g, S, lerp(1.05, 1.22, EASE.in(k)), 960, 470);
  sky(g); sea(g, 160, t); band(g, 230, C.sand, 9, 340, 60); marks(g, 40, -200, 2200, 330, 1080, 61);
  turtleFront(g, 960, 520, 2.1, { mood: 'worried', blink: blinkAt(t, [29.2]) });
  sweat(g, 1180, 330, 1.8, t * 0.9);
}
const ODDS = lazy(() => {                                 // 1000 turtles: 40 x 25, each with its seeded vanish time; one stays
  const r = rng(71), keep = 27 * 40 + 23, list = [];
  for (let i = 0; i < 1000; i++) list.push({ x: 240 + (i % 40) * 37, y: 200 + Math.floor(i / 40) * 31, at: i === keep ? 99 : 0.35 + 2.0 * r() ** 0.8 });
  return { list, keep: list[keep] };
});
function s12Odds(g, k, t, S) {
  // locked, 3.4 s: the grid empties while the counter falls from 1000 to 1
  V(g, S); g.fillStyle = C.sandL; g.fillRect(-600, -600, 3200, 2400);
  const tt = t - CUES.odds, O = ODDS(); let alive = 0;
  for (const p of O.list) { const v = 1 - clamp((tt - p.at) / 0.12); if (v > 0) { alive++; tinyTurtle(g, p.x, p.y, 10 * (p === O.keep ? 1 : v)); } }
  O.list.forEach((p) => { if (p.y > 1000) p.y = 0; });
  if (alive < 3) { const u = EASE.out(MOTION.at(tt, 2.5, 0.4)); g.beginPath(); g.arc(O.keep.x, O.keep.y, lerp(80, 34, u), 0, TAU); g.lineWidth = 6; g.strokeStyle = C.crabD; g.globalAlpha = u; g.stroke(); g.globalAlpha = 1; }
  g.fillStyle = 'rgba(248,248,246,0.0)';
  numberText(g, String(Math.max(1, alive)), 960, 110, 120);
}

// Cartoon pops (a sine that drops in pitch): written here, on the same CUES as the picture. No music in this film.
function pop(ctx, out, t, f, gain) {
  const o = ctx.createOscillator(), v = ctx.createGain(); o.type = 'sine';
  o.frequency.setValueAtTime(f, t); o.frequency.exponentialRampToValueAtTime(f * 0.35, t + 0.09);
  env(v.gain, t, 0.003, gain, 0.1); o.connect(v).connect(out); o.start(t); o.stop(t + 0.15);
}
function score(ctx, out) {
  pop(ctx, out, CUES.hatch + 0.02, 520, 0.5);              // the head pops out
  pop(ctx, out, CUES.crab + 0.35, 380, 0.4);               // crab out of the hole
  pop(ctx, out, CUES.crab + 0.95, 700, 0.35);              // napkin on
  pop(ctx, out, CUES.gull + 0.05, 600, 0.3);               // cutlery up
  const O = ODDS();                                        // a soft tick as the grid empties, thinning out
  for (let i = 0; i < 24; i++) pop(ctx, out, CUES.odds + 0.35 + 2.0 * (i / 24) ** 0.8, 900 + 25 * (i % 5), 0.08);
  pop(ctx, out, CUES.odds + 2.55, 440, 0.35);              // the one that is left
}

