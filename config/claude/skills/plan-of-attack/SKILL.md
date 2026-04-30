---
name: plan-of-attack
description: Prioritized action plan based on current state of all repos, PRs, and in-flight work. Use when starting a work session or re-orienting after context switch.
---

# Plan of Attack

**Announce at start:** "Building plan of attack…"

## Prerequisites

**REQUIRED:** Run the `state-of-the-world` skill first to gather current data. The plan is built from that output. State-of-the-world handles context discovery (memory, CLAUDE.md, org detection, repo filtering) — don't duplicate that work here.

## Priority Framework

Order work by impact and urgency:

1. **🔥 Production issues** — hotfixes, rollbacks, broken deploys
2. **Unblock others** — PRs with approvals waiting on CI fixes, review requests from teammates
3. **Finish in-flight** — work that's close to done (unpushed commits, uncommitted changes needing commit + push + PR)
4. **Quick wins** — PRs with green CI just needing review requests, trivial CI fixes
5. **Cleanup** — dead branches, stale stashes, merged-but-not-deleted branches
6. **Triage stale** — old PRs/branches that need a decision: rebase, close, or revive

## Analysis

For each item in the plan:
- State what to do and why it's at this priority
- Note blockers or dependencies (e.g., "rebase after X merges")
- Flag risks (e.g., "main is unstable — wait before rebasing")
- For multi-repo features, specify the order across repos

## Output Format

Numbered list, grouped by priority tier. Each item is 1-2 lines. Example:

```
### 1. 🔥 Fix CI on rollback PR #2176
phpstan failing — production is on broken L12. Fix and merge first.

### 2. Ship extension-fe PYR-90 (no blockers)
Push + open PR. Up to date with main, 2 clean commits.

### 3. Commit + push customer-fe PYR-90
Review 4 modified files, commit, rebase (2 behind), push + open PR.

### 4. Core-be PYR-90 — WAIT
12 behind main, but main is unstable (rollback pending). Rebase after main stabilizes.
```

## Principles

- Be specific: name the repo, PR number (with URL), branch, exact action
- Don't plan work that's blocked — note the blocker and defer
- Surface decisions the user needs to make (e.g., "still needed?", "PYR-90 or not?")
- Keep it short — this is a checklist, not a design doc
- Update the plan when asked to "refresh" — re-run state-of-the-world and rebuild

## Optional: interactive board

If the user asks for an interactive view (or says "show me in glimpse", "make it clickable", "live board"), compose with the `glimpse-board` skill. Build a `BoardSpec` from the priority list — one item per priority entry, with per-item actions like `start`, `mark_done`, plus a palette for `refresh_state` and other global actions — then launch via `glimpse-board`'s template and attach a Monitor to receive click events. See `glimpse-board/reference.md` for the recipe.
