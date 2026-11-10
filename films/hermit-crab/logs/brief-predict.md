<!-- cinecode brief: predict -->
# Task (the prediction test: the films the user's first message makes anyone expect, five lines, from that message alone)

A 30-second 16:9 2D flat-vector cartoon, English narration, no music, made in code. A hermit crab looks for a shell in a tide pool. Same form as the reference film (a small creature's harsh life told by a deadpan narrator, comic gags on every beat, a dark-funny ending).

# Files

PROJECT: D:\coda\films2\films\hermit-crab (the film's folder; every path below is inside it)
WRITES: research/predict.md
READS: none
DO NOT TOUCH: STATE.md, shots.json, audio/mix.json, LICENSES.csv (the main chat owns them) and every file not under WRITES
DONE WHEN: research/predict.md lists what any film-maker would predict this brief produces

# The kit's rules for this task (quoted; they are not optional)

**The prediction test (independent).** The maker cannot judge its own surprise. At the very start, where the tool has helpers, a fresh helper (`python3 tools/brief.py predict`) gets only the user's first message, quoted, and nothing else, and writes `research/predict.md`: the five films it would expect from that message, one line each (subject, key images, form). Write the 10 angles while it runs. A kept angle that shares its subject, key image or form with a predicted line is replaced by the next one on the list; each interpretation offered then says in a few words what it does that the predictions did not. One reply, about a minute, never waited on by the user.

# Report

At most 25 tool calls. Details go in the file under WRITES; reply in 10 lines or fewer: what was done, the files written, what was measured (the command and its result, not a claim), what is still open, and anything you saw that is outside your task.
