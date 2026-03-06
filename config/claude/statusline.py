#!/usr/bin/env python3
import json, sys

# json.load reads and parses stdin in one step
data = json.load(sys.stdin)
model = data['model']['display_name']
# "or 0" handles null values
pct = int(data.get('context_window', {}).get('used_percentage', 0) or 0)

# String multiplication builds the bar
filled = pct * 10 // 100
bar = '▓' * filled + '░' * (10 - filled)

print(f"[{model}] {bar} {pct}%")
