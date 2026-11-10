<!-- cinecode brief: overlap -->
# Task (the overlap check: each candidate idea against the expected films and this user's own films, judged by someone who did not write them)

Judge each candidate in research/candidates.md against the predictions and this user's own films. The user's first message, quoted, so an overlap it asks for (a sequel, the same subject on purpose) is known and counts as CLEAR: A 30-second 16:9 2D flat-vector cartoon, English narration, no music, made in code. A hermit crab looks for a shell in a tide pool. Same form as the reference film (a small creature's harsh life told by a deadpan narrator, comic gags on every beat, a dark-funny ending).

# Files

PROJECT: D:\coda\films2\films\hermit-crab (the film's folder; every path below is inside it)
WRITES: research/overlap.md,research/past-films.md
READS: research/candidates.md,research/predict.md
DO NOT TOUCH: STATE.md, shots.json, audio/mix.json, LICENSES.csv (the main chat owns them) and every file not under WRITES
DONE WHEN: research/overlap.md marks every candidate that repeats a prediction or one of this user's own films

# The kit's rules for this task (quoted; they are not optional)

**The overlap check (independent).** The maker cannot judge its own repeats either. Before the ideas reach the user, write the best five angles as candidates in `research/candidates.md` (numbered, each with its logline, key images, worlds or places, form, and the seed it grew from), then `python3 tools/brief.py overlap --task "<the user's first message, quoted>"`: it writes this user's own films into `research/past-films.md` (the memory `make.py` keeps, and the films on the same shelf) and prints the brief for a fresh helper, which reads the candidates beside `research/predict.md` and those films and writes `research/overlap.md`: one line per candidate, CLEAR; SHARES, when one element repeats while the idea is new (an ending, a form, a key image or a world; which one, and with what: a prediction by its number, a film by its title); or OVERLAP, when the idea itself repeats (its premise and key images, whatever the details; with what). What the message itself names (a brand, a product, a person, a place) is the user's and never an overlap on its own: a film about the same brand repeats only in its idea, images, worlds or form. About half a minute. The three strongest that are not OVERLAP are offered, a SHARES one with its shared element changed; an OVERLAP is dropped, never argued with, unless the user's own message asks for that film again (a sequel, the same subject on purpose); with fewer than three left, new candidates go through the check once more. The guard holds the ideas question until the check has read the latest candidates.

# Report

At most 25 tool calls. Details go in the file under WRITES; reply in 10 lines or fewer: what was done, the files written, what was measured (the command and its result, not a claim), what is still open, and anything you saw that is outside your task.
