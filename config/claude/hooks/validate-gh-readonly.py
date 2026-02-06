#!/usr/bin/env python3

import json
import sys
import re

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError:
    sys.exit(0)

tool_input = input_data.get("tool_input", {})
command = tool_input.get("command", "")

# Only process gh commands
if not command.strip().startswith("gh "):
    sys.exit(0)

# Block write operations
write_operations_ask = [
    r"gh\s+api\s+(POST|PUT|PATCH|DELETE)",
    r"gh\s+(issue|pr)\s+(create|edit|close|reopen|merge)",
    r"gh\s+release\s+(create|upload|edit|delete)",
    r"gh\s+repo\s+create",
    r"gh\s+auth\s+(login|logout)",
    r"gh\s+(secret|variable)\s+(set|delete)",
]

for pattern in write_operations_ask:
    if re.search(pattern, command):
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PermissionRequest",
                "decision": {
                    "behavior": "ask_permission",
                    "message": "Write operations require permission. Do you want to proceed?",
                    "interrupt": True
                }
            }
        }
        print(json.dumps(output))
        sys.exit(0)

# Auto-allow read-only operations
output = {
    "hookSpecificOutput": {
        "hookEventName": "PermissionRequest",
        "decision": {
            "behavior": "allow"
        }
    }
}
print(json.dumps(output))
