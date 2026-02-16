Be as concise as possible, even at the expense of grammar.

# Code comments

- Do not comment self-describing code
- Only comment complex sections of code that might be hard to revisit. Prefer to explain the purpose of the code rather than what the code is doing
- Use ASCII art/diagrams when it helps document/describe code

# Tooling

- Always follow existing project tooling. Below are greenfield defaults
- Use mise for installing tools/runtimes not managed by the project's package manager
- TypeScript: npm, biome
- Python: uv, ruff, ty

# Code standards

- Extract shared logic at 2+ repetitions. Hoist to the necessary scope: start at file/module level, then work up through parent scopes until it's shared appropriately
- Prefer file-level constants to magic numbers/strings, lift to project-level constants that load from env if needed in several places or if it's an important setting that can vary between environments
- Use real ellipses `…` instead of `...` in ALL non-code contexts

# Git

- Name new branches starting with `camron/`. If working a ticket/issue, add the issue number after the `/`
- Use `gh` for all github actions
- Prefer rebasing to merges

# Git safety

- ABSOLUTELY NEVER run destructive git operations (e.g., git reset --hard, rm, git checkout/git restore to an older commit) unless the user gives an explicit, written instruction in this conversation. Treat these commands as catastrophic; if you are even slightly unsure, stop and ask before touching them.
- Never use git restore (or similar commands) to revert files you didn't author — coordinate with other agents instead so their in-progress work stays intact.
- Keep commits atomic: stage files explicitly by path, only include files you touched.
- Quote any git paths containing brackets or parentheses (e.g., src/app/[candidate]/\*\*) when staging or committing so the shell does not treat them as globs or subshells.
- Never amend commits unless you have explicit written approval in the task thread.
- Before attempting to delete a file to resolve a local type/lint failure, stop and ask the user. Other agents are often editing adjacent files; deleting their work to silence an error is never acceptable without explicit approval.
- Delete unused or obsolete files when your changes make them irrelevant (refactors, feature removals, etc.), and revert files only when the change is yours or explicitly requested. If a git operation leaves you unsure about other agents' in-flight work, stop and coordinate instead of deleting.
- Moving/renaming and restoring files is allowed.

# Workflow

- After each group of steps, commit changes with descriptive, but concise, commit message
- At the end of each plan, raise any unanswered questions that we might need to consider. Be as concise as possible
