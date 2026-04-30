# glimpse-board reference

## Composition recipes

### With plan-of-attack

```
1. Run plan-of-attack → prioritized list
2. Build a BoardSpec:
   - sections: [
       { type: "mermaid", id: "dag", content: "<dependency graph>" },
       { type: "items",   id: "today", items: [<one per priority entry>] },
       { type: "kv",      id: "summary", rows: [<headline stats>] }
     ]
   - palette: [refresh_state, open_focus_pr, …]
3. Launch + Monitor + tell user board is live
4. On click events, do the work and push log/status/section updates
```

### With state-of-the-world

```
1. Run state-of-the-world → repo scan
2. Build a BoardSpec:
   - sections: [
       { type: "items", id: "repos", items: [<one per dirty repo>] },
       { type: "items", id: "prs",   items: [<one per open PR>] },
       { type: "kv",    id: "stats", rows: [counts, totals] }
     ]
   - per-item actions: rebase, discard_strays, open_pr, investigate
3. Launch + monitor
```

### Standalone — PR review queue

```
1. gh pr list --state open --review-requested @me
2. One item per PR, actions: approve | comment | request_changes | later
3. setStatus on each action so visual state updates immediately on click
```

### Standalone — deploy watch

```
1. Build sections: [kv (env health), items (queued deploys), code (last build log)]
2. Palette: rollback, promote, restart_workers
3. Use {section} commands to live-update env health every minute via a poll
```

## Action handler patterns

Events arrive as `MSG: {action, payload, t}`. The agent decides what each action means.

**Begin work on an item.**
```
event: { action: "start", payload: { id: "pr-123" } }
agent:
  1. {"log": "starting pr-123…", "level": "info"}
  2. {"status": {"id": "pr-123", "state": "in_progress"}}
  3. do the work
  4. on completion: {"status": {"id": "pr-123", "state": "done"}}
                    {"log": "done", "level": "ok"}
```

**Refresh state.**
```
event: { action: "refresh_state" }
agent:
  1. {"log": "refreshing…", "level": "info"}
  2. invoke state-of-the-world skill
  3. emit a {"section": {…}} command per section that changed
  4. {"log": "refreshed", "level": "ok"}
```

**Open a PR.**
```
event: { action: "open_pr", payload: { repo: "owner/repo", num: 123 } }
agent:
  1. compute URL → https://github.com/owner/repo/pull/123
  2. either: print for user, or run `open <url>` to launch browser
```

**Live-link a node in a custom diagram.**
```
SVG: <g onclick='goto("pr-123")' …>
- click in window → goto() scrolls + flashes the matching item card
- no agent round-trip needed for navigation
```

## Mermaid example — DAG with click-through

```jsonc
{
  "id": "dag",
  "type": "mermaid",
  "header": "Dependency Graph",
  "content": "graph LR\n  A[PR-A] --> B[PR-B]\n  B --> C[PR-C]\n  click A call goto(\"pr-a\") \"Jump to PR-A\"\n  click B call goto(\"pr-b\") \"Jump to PR-B\"\n  click C call goto(\"pr-c\") \"Jump to PR-C\""
}
```

Pair with item cards whose `id` matches (`"pr-a"`, etc.). Clicking any node scrolls + flashes the corresponding card.

## Pushing updates

```bash
CTRL="/tmp/glimpse-board-<pid>-control.jsonl"  # printed at startup

# log
echo '{"log":"build passing","level":"ok"}' >> "$CTRL"
echo '{"log":"phpstan: 3 errors","level":"warn"}' >> "$CTRL"

# status (built-in)
echo '{"status":{"id":"pr-123","state":"in_progress"}}' >> "$CTRL"

# status (custom — you supply CSS via eval if you want a look)
echo '{"status":{"id":"job-7","state":"running"}}' >> "$CTRL"
echo '{"eval":"document.styleSheets[0].insertRule(\".item-card.running::before{background:#f472b6}\")"}' >> "$CTRL"

# section (replace, add, or remove)
echo '{"section":{"id":"summary","header":"Stats","html":"<dl class=\"kv\"><dt>Open</dt><dd>42</dd></dl>"}}' >> "$CTRL"
echo '{"section":{"id":"old-section","remove":true}}' >> "$CTRL"

# live mermaid update
echo '{"section":{"id":"dag","header":"Updated","html":"<div class=\"card mermaid-host\"><div class=\"mermaid\">graph LR\n  X-->Y</div></div>"}}' >> "$CTRL"
echo '{"eval":"window.renderMermaid(\"dag\")"}' >> "$CTRL"

# eval escape hatch
echo '{"eval":"document.title = \"DONE\""}' >> "$CTRL"
echo '{"eval":"goto(\"pr-123\")"}' >> "$CTRL"  # programmatic scroll-to
```

## Closing the window

- User: presses Escape
- Agent: `pkill -f "template.mjs <spec-path>"`, or `{"eval": "window.glimpse.close()"}` via control file

The Node process exits when the window closes; the `Monitor` task ends.

## Troubleshooting

**"no such file" on startup** — make sure spec file is fully written before launching.

**Events not arriving at agent** — Monitor must filter for `^MSG: ` (with the trailing space). Without it, you'll catch the `CONTROL: …` startup line too, which isn't an event.

**Updates not appearing in window** — the Node process polls the control file every 250ms. If your script writes faster, lines batch into one update — usually fine. JSON parse errors go to the task's stderr (visible in the task output file).

**Mermaid section not rendering after live update** — Mermaid only auto-runs on the initial DOM. After a section swap, run `{"eval": "window.renderMermaid('your-section-id')"}`.

**Custom status not styled** — that's by design; the skill toggles class names but doesn't ship CSS for unknown states. Push your own rule via `eval`:
```js
document.styleSheets[0].insertRule(".item-card.passing::before{background:#34d399}")
```

**Window opens behind other apps** — Glimpse on macOS sometimes opens behind the active app. Cmd-Tab to it. Set `floating: true` in a custom render if it matters often (would require forking the template).

## What this skill does NOT do

- Persist state across window closes — mirror to memory if it matters
- Sanitize untrusted HTML in section bodies — caller's responsibility
- Provide a chat input — use `glimpse-browser` directly with `prompt()` for free-text input
- Replace the agent's reasoning — events are intent signals; the agent decides the action

## Implementation surface

For reference / debugging:

- `template.mjs` — entrypoint. Reads spec, renders HTML, opens window, sets up bridge.
- Control file format: one JSON object per line. Fields recognized: `log`, `status`, `section`, `eval`. Unknown fields silently ignored.
- Webview globals (callable from any HTML/SVG `onclick`):
  - `emit(action, payload)` — send an event to the agent
  - `goto(itemId)` — scroll to + flash an item card
  - `setStatus(id, state)` — toggle a class on a card
  - `appendLog(level, msg)` — push a log line
  - `updateSection(id, header, html)` / `removeSection(id)` — section CRUD
  - `renderMarkdown(id)` / `renderMermaid(id)` — re-process content after live updates
