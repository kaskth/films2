# films2

A films workspace: two short films made with code, the reference material one of them was
reverse-engineered from, and the two agent skills that make them.

## Layout

| Path | What it holds |
| :--- | :--- |
| `films\hermit-crab\` | **The Duel** — 30 s, 2D flat vector, English narration. Built in this workspace. |
| `films\sea-turtle\` | **Why It Sucks to Be a Born a Sea Turtle** — 30 s, quick mode, stopped at the card gate. |
| `research\ref-video\` | Form breakdown of the reference film (timings, palette, beat grid). |
| `research\rea-output\` | Full reverse-engineering of the reference: report, breakdown, per-shot analysis, packaging timeline. |
| `refs\` | Source material. The reference video itself is **not** in this repo (see below). |
| `.agents\skills\` | The two skills, vendored: `cinecode` (make a film with code) and `rea-video` (reverse-engineer one). |
| `opencode.json`, `AGENTS.md` | OpenCode project config and workspace notes. |

## The two skills

Both are vendored copies of public repositories, kept here so the workspace is self-contained:

- **cinecode** — https://github.com/sarpstar/cinecode (MIT). Makes a short film, animation, ad or
  music video entirely with code, together with the user.
- **rea-video** — https://github.com/JuneYaooo/rea-video. Reverse-engineers how a video was made:
  per-shot production method, overlays, real material, sound, and a replication plan.

Their own git histories are not part of this repo. To update either one, re-clone it over the folder.

## Restoring the skill links

`.agents\skills\` holds the real files. Each agent harness looks for skills in its own directory, so
they are linked in with Windows junctions rather than copied. On a fresh clone, run:

```powershell
powershell -ExecutionPolicy Bypass -File setup-links.ps1
```

That creates:

```
.agent                         -> .agents
.claude\skills\cinecode        -> .agents\skills\cinecode
.claude\skills\rea-video       -> .agents\skills\rea-video
.cursor\skills\cinecode        -> .agents\skills\cinecode
.cursor\skills\rea-video       -> .agents\skills\rea-video
.opencode\skills\cinecode      -> .agents\skills\cinecode
.opencode\skills\rea-video     -> .agents\skills\rea-video
```

OpenCode reads `.opencode\skills` natively, and also reads `.claude\skills` and `.agents\skills`
as compatibility sources, so the film skills appear whichever harness you open the folder with.

## What is not in this repo, and why

| Missing | Why |
| :--- | :--- |
| `refs\king_cobra.mp4` | The reference film belongs to its creator. It was studied for form only and is not redistributed here. |
| `refs\stills\` | Frames of that same film. |
| `research\rea-output\stems\` | Three 131 MB WAVs, over GitHub's 100 MB file limit, and derived: `rea-video stems refs/king_cobra.mp4` rebuilds them. |
| `films\*\renders\picture-*.mp4` | Intermediate picture-only renders; the draft cuts are kept. |

## The films

Each film folder has its own `STATE.md`, which is the source of truth: phase, decisions, next
action. Read that first, not the code.

```powershell
cd films\hermit-crab
node tools\capture.mjs --url engine\arena.html --out review\frames --start 0 --end 720 `
     --params "w=960&h=540" --video renders\picture.mp4
```

Rendering needs Node 22+, Python 3, ffmpeg and Chrome. Nothing else; no paid services, no API keys.

## Credits

- `cinecode` — MIT, © LemoLab / sarpstar. Licence text in `.agents\skills\cinecode\LICENSE`.
- `rea-video` — see `.agents\skills\rea-video\LICENSE` and `NOTICE`.
- The reference film is quoted as form and measurements only. No frame of it is redistributed.
