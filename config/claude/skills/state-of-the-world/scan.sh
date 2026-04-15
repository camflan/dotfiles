#!/usr/bin/env bash
#
# Scan git repos under a directory for in-flight work.
# Outputs JSON array — one object per repo with activity.
# Clean repos on main/master are omitted.
#
# Usage: scan.sh [directory]  (default: $PWD)

set -euo pipefail

BASE_DIR="${1:-$PWD}"

# Noise directories to skip in change listings
EXCLUDE_PATTERN='(node_modules|vendor|\.next|\.cache|\.claude|postgres-data|storage)/|\.DS_Store'

scan_repo() {
  local dir="$1"
  local name
  name="$(basename "$dir")"

  local branch
  branch="$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null || echo "unknown")"

  local is_main=false
  [[ "$branch" == "main" || "$branch" == "master" ]] && is_main=true

  # Uncommitted changes (excluding noise)
  local dirty
  dirty="$(git -C "$dir" status --porcelain 2>/dev/null | grep -Ev "$EXCLUDE_PATTERN" || true)"

  # Unpushed commits
  local unpushed=""
  if git -C "$dir" rev-parse --verify '@{u}' &>/dev/null; then
    unpushed="$(git -C "$dir" log --oneline '@{u}..HEAD' 2>/dev/null || true)"
  fi

  # Behind main
  local behind=0
  local main_branch=""
  for candidate in main master; do
    if git -C "$dir" rev-parse --verify "origin/$candidate" &>/dev/null; then
      main_branch="$candidate"
      break
    fi
  done
  if [[ -n "$main_branch" && "$branch" != "$main_branch" ]]; then
    behind="$(git -C "$dir" rev-list --count "HEAD..origin/$main_branch" 2>/dev/null || echo 0)"
  fi

  # Stashes (skip autostash)
  local stashes
  stashes="$(git -C "$dir" stash list 2>/dev/null | grep -v 'autostash' || true)"

  # Worktrees (beyond the main one)
  local worktrees
  worktrees="$(git -C "$dir" worktree list --porcelain 2>/dev/null | grep -c '^worktree ' || echo 1)"
  worktrees=$((worktrees - 1))

  # Skip clean repos on main
  if $is_main && [[ -z "$dirty" && -z "$unpushed" && -z "$stashes" && "$worktrees" -eq 0 ]]; then
    return
  fi

  # Build JSON via jq
  jq -n \
    --arg name "$name" \
    --arg path "$dir" \
    --arg branch "$branch" \
    --arg dirty "$dirty" \
    --arg unpushed "$unpushed" \
    --argjson behind "$behind" \
    --arg stashes "$stashes" \
    --argjson worktrees "$worktrees" \
    '{name: $name, path: $path, branch: $branch, dirty: $dirty, unpushed: $unpushed, behind_main: $behind, stashes: $stashes, extra_worktrees: $worktrees}'
}

# Find git repos (max depth 2 to catch worktrees)
repos=()
while IFS= read -r gitdir; do
  repos+=("$(dirname "$gitdir")")
done < <(find "$BASE_DIR" -maxdepth 2 -name ".git" -not -path "*/\.*/*" 2>/dev/null)

# Scan in parallel, collect results
results=()
for repo in "${repos[@]}"; do
  result="$(scan_repo "$repo" 2>/dev/null || true)"
  [[ -n "$result" ]] && results+=("$result")
done

# Output as JSON array
if [[ ${#results[@]} -eq 0 ]]; then
  echo "[]"
else
  printf '%s\n' "${results[@]}" | jq -s '.'
fi
