---
name: glimpse-board
description: Render any structured working list as a live, interactive native window. Sections support item cards, raw HTML/SVG, code blocks, key/value summaries, Markdown, and Mermaid diagrams. Buttons in the window send events back to the agent; the agent pushes log lines, status updates, and section replacements back into the window in real time. Use for plans of attack, PR queues, deploy watches, ticket triage, or any board the user wants to drive interactively.
---

# Glimpse Board

A composable interactive surface. Pass a structured `BoardSpec` JSON, the skill renders it; click events flow to the agent and updates flow back, all while the window stays open across multiple agent turns.

## When to use

Any time the agent has a working list and the user wants to drive it from a window. Examples:
- Plan of attack with start/done buttons per item
- PR queue with "review", "merge", "rebase" actions per PR
- Deploy watch with "rollback", "promote", "investigate" buttons
- Ticket triage with "assign", "close", "defer" actions
- Mermaid-rendered architecture diagrams with click-through to related items
- Markdown notes, key/value summaries, ASCII-art logs

Don't use it for one-shot dialogs (use `glimpse-browser` directly) or non-interactive status reports (markdown reply is fine).

## Composition

This skill renders. Other skills (or the agent itself) produce. The flow:

1. Build a `BoardSpec` (JSON).
2. Run `node $SKILL_DIR/template.mjs <spec.json>` in the background.
3. `Monitor` the background task's output, filter for `^MSG: ` lines.
4. Append JSONL commands to the control file to push updates back into the window.

## BoardSpec schema

```jsonc
{
  "title": "string",                          // window title + h1
  "subtitle": "string",                       // small text in the header
  "width": 940, "height": 980,                // optional pixel dims

  "palette": [                                // top action bar (optional)
    { "action": "refresh", "label": "↻ Refresh",
      "style": "primary",                     // primary | success | danger | (default)
      "shortcut": "⌘r",                       // ⌘<letter>; auto-bound globally
      "payload": { "any": "json" } }          // attached to MSG event
  ],

  "sections": [                               // body content, in render order
    { "id": "today", "type": "items", "header": "Today",
      "items": [ /* see Item schema */ ] },

    { "id": "dag", "type": "mermaid", "header": "Dependencies",
      "content": "graph LR\n  A --> B" },

    { "id": "notes", "type": "markdown", "header": "Notes",
      "content": "## Why\n- explanation\n- see [PR](https://...)" },

    { "id": "summary", "type": "kv", "header": "Stats",
      "rows": [ ["Open PRs", "2"], ["Behind main", "94"] ] },

    { "id": "graph", "type": "svg", "header": "Custom DAG",
      "content": "<svg viewBox='0 0 800 240'>…</svg>" },

    { "id": "log-tail", "type": "code", "header": "Last build",
      "content": "PASS  src/foo.test.ts\n  ✓ does the thing" },

    { "id": "free", "type": "html",
      "content": "<div class='card'>arbitrary HTML</div>" }
  ],

  "logHeader": "Activity Log"                 // header for the log panel (optional)
}
```

### Item schema (for `type: "items"` sections)

```jsonc
{
  "id": "pr-123",                             // required, used for status updates + goto()
  "badge": 1,                                 // small label — number, emoji, letter, "⏸"
  "badgeStyle": "b1",                         // b1 | b2 | b3 | parked  (built-in styles)
  "title": "Card title",
  "chips": [ { "label": "tag", "style": "purple" } ],
  "body": "<small body html or markdown-like text>",
  "status": null,                             // initial state; see Status states below
  "actions": [
    { "action": "start", "label": "▶ Start",
      "style": "primary",
      "payload": { "id": "pr-123" },
      "setStatus": "in_progress" }            // applies before the event fires
  ]
}
```

**Badge** is a small label slot — the skill is opinionated about layout, not meaning. Use whatever convention fits: priority numbers (1/2/3), severity emoji, repo initials, ticket prefix, etc. Built-in `badgeStyle` values (`b1`, `b2`, `b3`, `parked`) just paint the left border + badge background different colors. Pass any other string and it becomes a class — style it via an `eval` if you care.

**Chip styles:** `green | amber | red | blue | purple | cyan | dim`.

**Action styles:** `primary | success | danger | (default)`.

### Status states

Built-in states (have CSS):
- `in_progress` — amber border with glow
- `done` — green border, dimmed, strikethrough title
- `parked` — dimmed, gray border

Custom states are accepted too — just any string. The skill toggles class names; agents supply CSS via an `eval` if they want a custom look.

```jsonc
{"status": {"id": "ci-job", "state": "passing"}}      // adds class "passing"
{"status": {"id": "pr-123", "state": "done"}}         // built-in style applies
{"status": {"id": "pr-123", "state": null}}           // clears all states
```

## Launch

```bash
# Write the spec
cat > /tmp/board-spec.json <<'EOF'
{ ... BoardSpec ... }
EOF

# Run via Bash with run_in_background: true
node /Users/camron/.claude/skills/glimpse-board/template.mjs /tmp/board-spec.json
```

On startup the template prints two lines to stdout:
```
CONTROL: /tmp/glimpse-board-<pid>-control.jsonl
MSG: {"action":"_ready"}
```

## Wiring the bridge

After launch, capture the background task ID and attach a `Monitor`:

```bash
tail -F <task-output-file> 2>/dev/null | grep --line-buffered -E "^MSG: "
```

Each event arrives like `MSG: {"action":"start","payload":{"id":"pr-123"},"t":1714400000000}`.

## Pushing updates from the agent

Append JSONL to the control file. Commands:

```jsonc
// Log into the activity panel
{"log": "started scaffolding", "level": "ok"}            // info | ok | warn | err

// Update an item's visual state
{"status": {"id": "pr-123", "state": "in_progress"}}

// Replace, add, or remove a section by id (live; no relaunch)
{"section": {"id": "dag", "header": "Updated DAG",
  "html": "<div class='card mermaid-host'><div class='mermaid'>graph LR\n  X-->Y</div></div>"}}
{"section": {"id": "old", "remove": true}}

// Run arbitrary JS in the webview (escape hatch)
{"eval": "window.renderMermaid('dag')"}                  // re-render mermaid after a section swap
{"eval": "window.renderMarkdown('notes')"}               // re-render markdown
{"eval": "window.goto('pr-123')"}                        // scroll-to + flash an item
```

If the section id doesn't exist, `section` appends it.

## Linking custom views to items — `goto()`

Inside any `html` or `svg` section, wire `onclick` to the global helpers:

```html
<svg ...>
  <g onclick='goto("pr-123")' style='cursor:pointer'>
    <rect ... />
    <text>PR #123</text>
  </g>
  <g onclick='goto("pr-456"); emit("focus", {id:"pr-456"})'>
    <rect ... />
  </g>
</svg>
```

`goto(id)` scrolls the matching item card into view and flashes it. `emit(action, payload)` fires an event up to the agent. Both are global in the webview.

## Markdown sections

```jsonc
{ "type": "markdown", "header": "Notes",
  "content": "## Why\n- bullet one\n- [link](https://example.com)\n\n```js\ncode\n```" }
```

Rendered via marked.js (CDN, lazy-loaded only when at least one markdown section is present in the spec). Style follows the dark palette automatically.

To live-update markdown:
```bash
echo '{"section":{"id":"notes","header":"Notes","html":"<div class=\"card markdown\" data-md># New content</div>"}}' >> "$CTRL"
echo '{"eval":"window.renderMarkdown(\"notes\")"}' >> "$CTRL"
```

## Mermaid sections

```jsonc
{ "type": "mermaid", "header": "Dependency Graph",
  "content": "graph LR\n  A[PYR-76] --> B[PYR-172]\n  B --> C[PYR-173]" }
```

Rendered via mermaid.js (CDN, lazy-loaded). Theme set to dark to match. To make nodes click-linkable to item cards, use Mermaid's `click` directive:

```
graph LR
  A[PR #123] --> B[PR #124]
  click A call goto("pr-123") "Jump to card"
```

To live-update mermaid:
```bash
# Write the new graph as html (Mermaid won't auto-init it after replacement)
echo '{"section":{"id":"dag","header":"Updated","html":"<div class=\"card mermaid-host\"><div class=\"mermaid\">graph LR\n  X-->Y</div></div>"}}' >> "$CTRL"
# Then trigger mermaid to render the new node
echo '{"eval":"window.renderMermaid(\"dag\")"}' >> "$CTRL"
```

## Three example specs

### 1. PR triage

```jsonc
{
  "title": "PR Queue", "subtitle": "review my queue",
  "palette": [{ "action": "refresh", "label": "↻ Refresh", "shortcut": "⌘r" }],
  "sections": [{ "id": "queue", "type": "items", "header": "Open PRs",
    "items": [
      { "id": "pr-123", "badge": "🔥", "badgeStyle": "b1",
        "title": "Hotfix: rate limiter regression",
        "chips": [{ "label": "release-patch", "style": "red" }],
        "body": "Author: @teammate · 4 files · CI green",
        "actions": [
          { "action": "approve", "label": "✓ Approve", "style": "success",
            "payload": { "pr": 123 }, "setStatus": "done" },
          { "action": "comment", "label": "💬 Comment", "payload": { "pr": 123 } },
          { "action": "later", "label": "⏭ Later", "payload": { "pr": 123 }, "setStatus": "parked" }
        ] }
    ] }]
}
```

### 2. Deploy watch

```jsonc
{
  "title": "Deploy Watch", "subtitle": "production · live",
  "sections": [
    { "id": "envs", "type": "kv", "header": "Status",
      "rows": [ ["staging", "✅ green"], ["prod", "🟡 deploying"], ["jobs", "8 in queue"] ] },
    { "id": "actions", "type": "items", "header": "Quick Actions",
      "items": [
        { "id": "rollback", "badge": "↩", "badgeStyle": "b1", "title": "Roll back prod to v2.4.3",
          "actions": [{ "action": "rollback", "label": "Confirm rollback", "style": "danger",
            "payload": { "to": "v2.4.3" } }] }
      ] }
  ]
}
```

### 3. Plan of attack

See `reference.md` — the canonical example, with mermaid DAG section linking to item cards.

## Tradeoffs and limits

- **Turn-based.** Webview events queue; the agent only processes them on its next turn (via `Monitor` notification or a user message). Not real-time chat.
- **Single window per spec.** Multiple boards open via separate `node template.mjs` invocations — each gets its own PID-suffixed control file.
- **No persistence.** State (which items are done) lives only in the open window. Mirror to memory if it matters past the window's lifetime.
- **Raw HTML.** `html`/`svg` section bodies are inserted as-is. Sanitize untrusted input. In agent contexts this is almost always safe.
