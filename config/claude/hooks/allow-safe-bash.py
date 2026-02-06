#!/usr/bin/env python3

import json
import sys
import re

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

tool_input = input_data.get("tool_input", {})
command = tool_input.get("command", "").strip()

# Skip subshells - too complex to parse safely
if re.search(r"\$\(|`", command):
    sys.exit(0)

SAFE_PATTERNS = [
    # Read-only filesystem
    r"^ls(\s|$)",
    r"^pwd$",
    r"^cat\s",
    r"^head\s",
    r"^tail\s",
    r"^tree(\s|$)",
    r"^file\s",
    r"^wc\s",

    # Git read-only
    r"^git\s+(status|log|diff|branch|show|remote)(\s|$)",

    # Search tools
    r"^find\s",
    r"^grep\s",
    r"^rg\s",
    r"^fd\s",

    # System info
    r"^which\s",
    r"^type\s",
    r"^env$",
    r"^printenv(\s|$)",
    r"^uname(\s|$)",
]


def is_safe(cmd):
    cmd = cmd.strip()
    if not cmd:
        return True
    return any(re.search(p, cmd) for p in SAFE_PATTERNS)


def split_commands(cmd):
    """Split on ;, &&, ||, | while respecting quotes."""
    parts = []
    current = []
    in_single = False
    in_double = False
    i = 0

    while i < len(cmd):
        c = cmd[i]

        if c == "'" and not in_double:
            in_single = not in_single
            current.append(c)
        elif c == '"' and not in_single:
            in_double = not in_double
            current.append(c)
        elif not in_single and not in_double:
            if c == ";":
                parts.append("".join(current))
                current = []
            elif c in "&|" and i + 1 < len(cmd) and cmd[i + 1] == c:
                parts.append("".join(current))
                current = []
                i += 1
            elif c == "|":
                parts.append("".join(current))
                current = []
            else:
                current.append(c)
        else:
            current.append(c)
        i += 1

    parts.append("".join(current))
    return parts


commands = split_commands(command)

if all(is_safe(cmd) for cmd in commands):
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PermissionRequest",
            "decision": {"behavior": "allow"}
        }
    }
    print(json.dumps(output))

sys.exit(0)
