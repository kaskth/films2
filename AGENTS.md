# films2 — working notes

A films workspace: one short film under production, the reference material it was
reverse-engineered from, and the two skills that produce it.

## Layout

| Path | What it holds |
| :--- | :--- |
| `films\sea-turtle\` | The film project. `STATE.md` is its source of truth, `film.html` is the film (picture + sound, one file), `tools\make.py` renders it. |
| `refs\` | Source footage: `king_cobra.mp4` (the reference video) and `stills\` frames pulled from it. |
| `research\ref-video\` | Form breakdown of the reference — `REFERENCE.md`, `beats.json`, `results.json`. |
| `research\rea-output\` | rea-video analysis of the reference — `report.md`, `breakdown.json`, `storyboard.jpg`, `stems\`. Large; read only what you need. |
| `.agents\skills\` | The real skills (see below). Everything else is a mirror. |

`.agents` is 224 MB and `research` is ~483 MB, mostly audio and renders. Do not
copy or rewrite them wholesale; open the one file you need.

## Skills

| ID | Lives at | Use for |
| :--- | :--- | :--- |
| `cinecode` | `.agents\skills\cinecode\SKILL.md` | Making a short film, animation, ad or music video with code, together with the user (quick mode and film mode). |
| `rea-video` | `.agents\skills\rea-video\skills\rea-video\SKILL.md` | Reverse-engineering a reference video: per-shot method, real vs. generated footage, overlays, audio, edit rhythm, and a replication plan. |

Load a skill by its exact ID — `cinecode`, `rea-video` — with the skill tool; do not
read `SKILL.md` by hand. Paths inside a skill are relative to its own directory.

## The skills are mirrored, not duplicated

`.agents\skills` holds the real files. `.claude\skills`, `.cursor\skills`,
`.opencode\skills` and `.agent\skills` are directory junctions to them, so each
harness finds the skills where it expects them. Edit under `.agents\skills`; the
mirrors follow. Never create a second physical copy — the copies will drift.

## The film

`films\sea-turtle` — "Why It Sucks to Be Born a Sea Turtle", quick mode, cinematic,
30 s, Egyptian Arabic narration.

To work on it: read `films\sea-turtle\STATE.md` first, then follow the cinecode
quick-mode reference it points at. `STATE.md` records the phase, the director's
card, the beat list and the next action — start there, not from `film.html`.
