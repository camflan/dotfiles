---
name: state-of-the-world
description: Scan all repos for open work, PRs, uncommitted changes, branches, stashes, and worktrees. Use when starting a session, picking up where you left off, or needing a full picture of in-flight work.
---

# State of the World

**Announce at start:** "Running state-of-the-world scan…"

## Context Discovery

Before scanning, gather project context from these sources (in order):

1. **Memory** — read MEMORY.md for repo layout, ticket prefixes, in-flight work, CI conventions, dependency chains
2. **CLAUDE.md** — check project-level CLAUDE.md for repo conventions, branch naming, PR requirements
3. **reference.md (optional)** — if `state-of-the-world/reference.md` exists in the skills directory, use it for overrides (e.g., specific repos to watch, org aliases, custom ticket patterns). Not required.

## Scope Detection

Determine scope based on the current working directory:

- **Inside a git repo** → scan only this repo. Skip org detection and multi-repo discovery entirely.
- **Not inside a git repo** → scan all `*/` directories under the working directory that are git repos (`.git/` dir or `.git` file for worktrees), detect org(s) from remotes, and query each.

### Org Detection (multi-repo only)

Derive the GitHub org from git remotes — don't hardcode:
```bash
git -C <first-repo-found> remote get-url origin
# extract org from github.com:<org>/<repo>.git
```

If repos span multiple orgs, query each org separately.

### Repo Filtering (multi-repo only)

**Skip noise** — only report repos that have at least one of:
- Non-main/master branch checked out
- Uncommitted changes (staged or unstaged)
- Unpushed commits
- Stashes tied to feature branches

This keeps output focused. Clean repos on main are not reported.

## Data Gathering

Run all of the following in parallel where possible. Use subagents for independent queries when the set is large.

### 1. Repo Scan

Run the scan script to discover repos with in-flight work:

```bash
~/.claude/skills/state-of-the-world/scan.sh
```

This outputs a JSON array of repos that have activity (non-main branch, dirty files, unpushed commits, stashes, or worktrees). Clean repos on main are omitted. Each object contains: `name`, `path`, `branch`, `dirty`, `unpushed`, `behind_main`, `stashes`, `extra_worktrees`.

### 2. Open PRs

```bash
gh search prs --author @me --state open --owner <org> \
  --json repository,title,number,url,updatedAt,isDraft --limit 50
```

For each open PR, gather:
- CI status (passing/failing check names)
- Review status (approvals, requested reviewers, pending)
- Release label presence (if project requires them — check memory/CLAUDE.md)

### 3. Recently Merged PRs

```bash
gh search prs --author @me --owner <org> --merged \
  --json repository,title,number,updatedAt --limit 20 \
  -- "merged:>=<7-days-ago>"
```

### 4. Memory Cross-Reference

Cross-reference discovered branches/PRs with memory:
- Match ticket numbers from branches/PRs to known in-flight work
- Flag dependency chains (e.g., "PYR-75 stacked on PYR-90")
- Note known blockers from previous sessions
- Identify work that memory says is done but branches still exist (cleanup candidates)

## Output Format

### Diagram

Produce an ASCII diagram grouping work by feature/ticket. For each group show:
- Ticket/PR numbers
- Status: shipped ✅, open PR, unpushed, uncommitted
- CI/review state on open PRs
- Dependency arrows between related items
- Flag production issues or blockers with 🔥
- Flag repos behind main with count

### Tables

After the diagram, include only the tables that have data:
- **Open PRs** — repo, PR# (with URL), title, CI status, review status, age
- **Unpushed work** — repo, branch, ticket, commits, uncommitted changes, behind main
- **Worktrees** — directory, source repo, branch, state
- **Stashes worth noting** — skip autostash/noise, list ones tied to feature branches
- **Cleanup candidates** — dead branches (merged or 0 ahead), stale stashes, stale PRs (>2 weeks)

### Principles

- Extract ticket numbers from branch names (e.g., `camron/PYR-90-...` → PYR-90) and PR titles
- Group related work across repos by ticket — a feature spanning 3 repos is one group, not three
- Flag anything stale (>2 weeks without update)
- Flag CI failures that block merging
- Always include the PR URL when referencing a PR — make it clickable
- Be concise — this output feeds into plan-of-attack
