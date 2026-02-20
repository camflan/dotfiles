# Ralph — Cheerfully Persistent Claude Harness

> "I'm helping!" — Ralph Wiggum

## Overview

`ralph` is a CLI tool that drops into any project to run Claude Code in iterative loops. It's intentionally simple: give Claude a prompt, a task list, and let it chip away one task at a time until done.

## Commands

- `ralph init [template]` — scaffolds `.ralph/` in the current project (default template: `default`)
- `ralph once` — launches interactive Claude session with context injected
- `ralph loop [N]` — runs up to N non-interactive iterations (default: 5), exits early when no tasks remain
- `ralph templates` — lists available templates

## Project Directory: `.ralph/`

Created by `ralph init`, contains only content — no orchestration logic:

```
.ralph/
├── prompt.md       # user-written instructions for Claude
├── tasks.md        # user-written checklist (Claude checks off items)
├── progress.md     # agent-written, append-only log of completed work
└── learnings.md    # agent-written knowledge base for future iterations
```

## Prompt Assembly

Each invocation assembles a prompt from the `.ralph/` files:

```
You are working on a project. Here are your instructions:

<instructions>
{.ralph/prompt.md}
</instructions>

<tasks>
{.ralph/tasks.md}
</tasks>

<progress>
{.ralph/progress.md}
</progress>

<learnings>
{.ralph/learnings.md}
</learnings>

Pick ONE incomplete task from the tasks list — any one, your choice.
Complete it fully.

After completing the task:
1. Check off the task in .ralph/tasks.md
2. Append a brief entry to .ralph/progress.md describing what you did
3. If you discovered patterns, learnings, or helpful context, add them to .ralph/learnings.md

Rules:
- Do NOT suggest or prescribe next steps for future iterations
- Do NOT reorder or reprioritize remaining tasks
- Do NOT edit or remove existing entries in progress.md (append-only)
- If there are no incomplete tasks remaining, output exactly: <promise>NO MORE TASKS</promise>
```

## Loop Behavior

`ralph loop [N]`:
1. Assemble prompt from `.ralph/` files
2. Run `claude --dangerously-skip-permissions -p "{assembled_prompt}"`
3. Check output for `<promise>NO MORE TASKS</promise>` — if found, exit
4. Check tasks.md for remaining incomplete tasks — if none, exit
5. Repeat up to N times

## Once Behavior

`ralph once`:
1. Print assembled context summary
2. Launch `claude` in interactive mode (no `-p` flag)
3. The prompt/tasks/progress/learnings are provided via `--system-prompt` or similar mechanism

## Templates

Templates live at `~/dotfiles/tools/ralph/templates/<name>/`. Each template is a directory containing seed files that get copied into `.ralph/` on init.

A template directory should contain:
- `prompt.md` — project instructions for Claude
- `tasks.md` — initial task checklist

Files like `progress.md` and `learnings.md` are always created empty by `ralph init` regardless of template — they're agent-written, not user-authored.

To create a new template, add a directory under `templates/` with the files above:

```
templates/
├── default/
│   ├── prompt.md
│   └── tasks.md
└── my-template/
    ├── prompt.md
    └── tasks.md
```

Then use it: `ralph init my-template`

Init is idempotent — running it again fills in any missing files without overwriting existing ones. `ralph once` and `ralph loop` auto-init with the `default` template if `.ralph/` doesn't exist.

## Installation

Lives at `~/dotfiles/tools/ralph/ralph`, symlinked into `~/dotfiles/bin/ralph`.
