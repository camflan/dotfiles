#!/usr/bin/env python3

import json
import os
import sys

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

tool_input = input_data.get("tool_input", {})
command = tool_input.get("command", "").strip()

SKILLS_DIR = os.path.expanduser("~/.claude/skills")

# Reject compound commands — only allow a single skill script invocation
import re
if re.search(r"[;&|]|`|\$\(", command):
    sys.exit(0)

# Resolve the first token (the script path) to an absolute path
first_token = command.split()[0] if command else ""
resolved = os.path.expanduser(first_token.replace("$HOME", os.path.expanduser("~")))

try:
    resolved = os.path.realpath(resolved)
except (OSError, ValueError):
    sys.exit(0)

skills_real = os.path.realpath(SKILLS_DIR)

if resolved.startswith(skills_real + os.sep) and resolved.endswith(".sh"):
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PermissionRequest",
            "decision": {"behavior": "allow"},
        }
    }
    print(json.dumps(output))

sys.exit(0)
