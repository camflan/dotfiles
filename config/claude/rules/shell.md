---
paths:
  - "**/*.sh"
  - "**/*.bash"
---

# Shell Scripts

- Always use bash (`#!/usr/bin/env bash`), not POSIX sh
- Always `set -Eeuo pipefail`
- Use `main()` + `main "$@"` entry pattern
- Trap cleanup on SIGINT/SIGTERM/ERR/EXIT
- Use `die()` / `msg()` helpers for stderr output
- Use `parse_params()` with while/case for CLI arg handling
- Support NO_COLOR-aware color output when using colors
- Use `fn_name() {` style (no `function` keyword)
- Quote all variables unless word splitting is intentional
