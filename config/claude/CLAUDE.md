Be as concise as possible, even at the expense of grammar.

# Communication

- No preamble. Start with the answer or action.
- No summaries unless asked
- Don't repeat back what I said

# Code comments

- Do not comment self-describing code
- Only comment complex sections of code that might be hard to revisit. Prefer to explain the purpose of the code rather than what the code is doing
- Use ASCII art/diagrams when it helps document/describe code
- Preserve existing comments from other developers. Update them only when functionality changes. If a comment seems outdated and removal-worthy, flag it for review rather than deleting

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

- NEVER run destructive git ops (reset --hard, checkout to older commit, etc.) without explicit written instruction. If unsure, ask.
- Keep commits atomic: stage files by path, only include files you touched
- Quote paths with brackets/parens for shell safety
- Never amend commits without explicit approval
- Before deleting ANY file, verify it's not another agent's in-progress work — ask if unsure
- Moving/renaming and restoring files is allowed

# Testing

- Match existing test patterns in the project
- Prefer integration tests over mocks unless isolation is required
- Never delete or skip failing tests to make CI green

# Workflow

- After each group of steps, commit changes with descriptive, but concise, commit message
- At the end of each plan, raise any unanswered questions that we might need to consider. Be as concise as possible
