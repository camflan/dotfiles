#!/bin/sh
# Warn about new TODO/FIXME comments before pushing.
command -v todos >/dev/null 2>&1 || { echo "Warning: 'todos' not found" >&2; exit 0; }
exec todos -i
