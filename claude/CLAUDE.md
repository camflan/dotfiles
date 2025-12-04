Be as concise as possible, even at the expense of grammar.

# Code comments

- Do not comment self-describing code
- Only comment complex sections of code that might be hard to revisit. Prefer to explain the purpose of the code rather than what the code is doing

# Code standards

- Prefer DRY code
- Prefer file-level constants to magic numbers/strings, lift to project-level contants that load from env if needed in several places or if it's an important setting that can vary between environments
- Use "…" instead of "..." in strings that the user will be shown

# Git

- Name new branches starting with `camron/`. If working a ticket/issue, add the issue number after the `/`
- Use `gh` for all github actions
- Prefer rebasing to merges

# TypeScript

- Prefer declarative functions and immutable data structures as much as possible
- Prefer Array/iterable methods instead of declaring an array and pushing onto it
- Prefer flatMap instead of filter + map to save iterations
- Prefer types to interfaces where possible
- Always export types for exported functions
- Prefer named exports to default
- Avoid barrel files
- Derive types from other types, schemas, etc as much as possible
- Prefer named types to anonymous types
- Avoid Enums and use string unions unless absolutely necessary
- File level function declarations should use the function keyword and utility functions should be placed at the end of the file
- Avoid JSDocs when there are typescript types. Add comments to TS types instead
- Avoid return type annotations where possible

# Workflow

- After each group of steps, commit changes with descriptive, but concise, commit message
- At the end of each plan, raise any unanswered questions that we might need to consider. Be as concise as possible
- Delete unused or obsolete files when your changes make them irrelevant (refactors, feature removals, etc.), and revert files only when the change is yours or explicitly requested. If a git operation leaves you unsure about other agents' in-flight work, stop and coordinate instead of deleting.
- Before attempting to delete a file to resolve a local type/lint failure, stop and ask the user. Other agents are often editing adjacent files; deleting their work to silence an error is never acceptable without explicit approval.
- Moving/renaming and restoring files is allowed.
- ABSOLUTELY NEVER run destructive git operations (e.g., git reset --hard, rm, git checkout/git restore to an older commit) unless the user gives an explicit, written instruction in this conversation. Treat these commands as catastrophic; if you are even slightly unsure, stop and ask before touching them.
- Never use git restore (or similar commands) to revert files you didn't author—coordinate with other agents instead so their in-progress work stays intact.
- Keep commits atomic: commit only the files you touched and list each path explicitly. For tracked files run git commit -m "<scoped message>" -- path/to/file1 path/to/file2. For brand-new files, use the one-liner git restore --staged :/ && git add "path/to/file1" "path/to/file2" && git commit -m "<scoped message>" -- path/to/file1 path/to/file2.
- Quote any git paths containing brackets or parentheses (e.g., src/app/[candidate]/\*\*) when staging or committing so the shell does not treat them as globs or subshells.
- Never amend commits unless you have explicit written approval in the task thread.
