# Dodge the Creeps: paid test task

This is the starting point for the carocloud paid Godot test task. It is Godot's official
[Dodge the Creeps](https://github.com/godotengine/godot-demo-projects/tree/master/2d/dodge_the_creeps) demo
(MIT licensed, see `dodge_the_creeps/LICENSE`) with one small addition, the run check described below.

You get the full brief by email after the interview. In short:

1. Fork this repository under the GitHub account you applied with, and create a branch.
2. Put the run code from your brief in `dodge_the_creeps/run_code.txt` (replace the placeholder line).
3. Open `dodge_the_creeps/project.godot` in Godot 4.7 and press Play (F5) to check it runs.
4. Build the features in the brief, commit as you go, and push your branch.
5. Reply with the link to your branch.

## Run check

`dodge_the_creeps/run_check.gd` is an autoload that runs each time the game starts. It sends one
request to `https://hire.aifoundjob.com/api/public/runs` with:

- your run code from `run_code.txt`
- your fork's GitHub address and current branch, read from `.git` (any credentials in the address are removed)
- the Godot version, your operating system, and whether it ran from the editor

As with any web request, our server also sees your IP address and approximate country, and stores them with the
run. We use this only to confirm that the project was actually opened and run during the test, and to spot
duplicate applications. It sends nothing else, never blocks or slows the game, and is skipped in headless and
web runs. The script is about 60 lines; please read it.

Please leave `run_check.gd` and the `[autoload]` entry in place while you work on the test. If you'd rather
not send this, tell us in your reply and we'll review your work without it.
