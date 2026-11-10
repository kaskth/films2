$p = 'D:\coda\films2\films\hermit-crab\STATE.md'
$t = [IO.File]::ReadAllText($p)

$t = $t.Replace('| 1 | interview answered / defaults accepted | | | |',
                '| 1 | interview answered / defaults accepted | PASSED | 2026-11-10 | Film, cinematic, 30 s 16:9, 2D flat vector, no music, English, Quality |')
$t = $t.Replace('| 2 | roadmap approved | | | |',
                '| 2 | roadmap approved | PASSED | 2026-11-10 | 9 shots, 3.33 s average |')
$t = $t.Replace('| 3 | script and text approved | | | |',
                '| 3 | script and text approved | PASSED | 2026-11-10 | 38 words, no on-screen text, pace steps |')

$t = $t.Replace('- **Pace:** <steps / through> (Film mode: asked with the script gate)',
                '- **Pace:** steps (the user wants a gate at each stage)')

$t = $t.Replace(@'
| 2026-11-10 | Decision | Why | Who |
'@, @'
'@)
$t = $t.Replace('|---|---|---|---|
', '|---|---|---|---|
| 2026-11-10 | Interpretation: The Duel | the only survivor of three overlap-check rounds that is physical rather than tender | user |
| 2026-11-10 | Look: B · Low Sun | a fight needs a light direction; the shadows swing with the crabs | user |
| 2026-11-10 | Tone: cold administrative | the reference voice; matches no music | user |
| 2026-11-10 | Sound identity: the pool is the sound | no music was chosen, so one place carries the film | user |
| 2026-11-10 | Profile: Quality | the user asked for the highest effort | user |
| 2026-11-10 | Shell: conical, not round | anatomically right once the spire leans back | user |
', 1)

[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output 'state updated'
