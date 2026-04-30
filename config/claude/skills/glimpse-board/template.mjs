#!/usr/bin/env node
// glimpse-board template — renders a BoardSpec as a live interactive window
// Usage: node template.mjs <spec.json>
//
// stdout protocol:
//   CONTROL: <path>           emitted on startup, the path you write commands to
//   MSG: <json>               every webview event (button click, etc.)
//
// control-file protocol (one JSON object per line):
//   {"log": "...", "level": "info|ok|warn|err"}
//   {"status": {"id": "...", "state": null|"in_progress"|"done"|"parked"|"<custom>"}}
//   {"section": {"id": "...", "header": "...", "html": "..."}}
//   {"section": {"id": "...", "remove": true}}
//   {"eval": "<js to run in webview>"}

import { open } from "/Users/camron/.local/share/mise/installs/node/24.13.0/lib/node_modules/glimpseui/src/glimpse.mjs";
import { readFileSync, watchFile, writeFileSync, existsSync } from "node:fs";

const specPath = process.argv[2];
if (!specPath) {
  process.stderr.write("usage: template.mjs <spec.json>\n");
  process.exit(2);
}
if (!existsSync(specPath)) {
  process.stderr.write(`spec not found: ${specPath}\n`);
  process.exit(2);
}

const spec = JSON.parse(readFileSync(specPath, "utf8"));
const CONTROL = `/tmp/glimpse-board-${process.pid}-control.jsonl`;
writeFileSync(CONTROL, "");
process.stdout.write(`CONTROL: ${CONTROL}\n`);

// ---------- HTML rendering ----------

const escAttr = (s) => String(s).replace(/[&<>"']/g, (c) =>
  ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));

const renderChip = (chip) =>
  `<span class="chip ${chip.style || ""}">${chip.label}</span>`;

const renderAction = (a) => {
  const payload = a.payload ? JSON.stringify(a.payload) : "null";
  const setStatus = a.setStatus
    ? `setStatus(${JSON.stringify(a.payload?.id || "")}, ${JSON.stringify(a.setStatus)});`
    : "";
  return `<button class="btn ${a.style || ""}" onclick='${setStatus} emit(${JSON.stringify(a.action)}, ${payload})'>${a.label}</button>`;
};

const renderPaletteBtn = (a) => {
  const payload = a.payload ? JSON.stringify(a.payload) : "null";
  const kbd = a.shortcut ? `<span class="kbd">${a.shortcut}</span>` : "";
  return `<button class="btn ${a.style || ""}" onclick='emit(${JSON.stringify(a.action)}, ${payload})'>${a.label}${kbd}</button>`;
};

const renderItem = (item) => {
  const badgeClass = item.badgeStyle || `b${item.badge || 1}`;
  const statusClass = item.status ? ` ${item.status}` : "";
  const chips = (item.chips || []).map(renderChip).join("");
  const actions = (item.actions || []).map(renderAction).join("");
  const badgeLabel = item.badge === "⏸" || badgeClass === "parked" ? "⏸" : item.badge;
  return `
    <div class="item-card ${badgeClass}${statusClass}" data-id="${escAttr(item.id)}">
      <div class="item-head">
        <span class="item-badge">${badgeLabel ?? ""}</span>
        <span class="item-title">${item.title}</span>
      </div>
      ${chips ? `<div class="item-meta">${chips}</div>` : ""}
      ${item.body ? `<div class="item-body">${item.body}</div>` : ""}
      ${actions ? `<div class="actions">${actions}</div>` : ""}
    </div>
  `;
};

const palette = (spec.palette || []).map(renderPaletteBtn).join("");

// Sections — flexible content beyond just item lists.
// Backwards-compat: if spec.items is present, treat as a single "items" section.
const sections = spec.sections || (spec.items
  ? [{ type: "items", header: spec.itemsHeader || "Items", items: spec.items }]
  : []);

const sectionTypes = new Set(sections.map((s) => s.type));

const renderSection = (sec) => {
  const id = sec.id ? ` data-section="${escAttr(sec.id)}"` : "";
  const header = sec.header
    ? `<div class="section-label">${sec.header}</div>`
    : "";
  let body = "";
  switch (sec.type) {
    case "items":
      body = `<div class="grid">${(sec.items || []).map(renderItem).join("")}</div>`;
      break;
    case "html":
    case "svg":
      body = `<div class="card">${sec.content || ""}</div>`;
      break;
    case "code":
      body = `<pre class="code-block">${escAttr(sec.content || "")}</pre>`;
      break;
    case "kv": {
      const rows = (sec.rows || [])
        .map(([k, v]) => `<dt>${k}</dt><dd>${v}</dd>`)
        .join("");
      body = `<dl class="kv">${rows}</dl>`;
      break;
    }
    case "markdown":
      body = `<div class="card markdown" data-md>${escAttr(sec.content || "")}</div>`;
      break;
    case "mermaid":
      body = `<div class="card mermaid-host"><div class="mermaid">${escAttr(sec.content || "")}</div></div>`;
      break;
    default:
      body = `<div class="card">${sec.content || ""}</div>`;
  }
  return `<section class="board-section"${id}>${header}${body}</section>`;
};

const sectionsHTML = sections.map(renderSection).join("");

// Lazy CDN injection — only load libs we actually use
const cdnScripts = [];
if (sectionTypes.has("markdown")) {
  cdnScripts.push(`<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>`);
}
if (sectionTypes.has("mermaid")) {
  cdnScripts.push(`<script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>`);
}

const html = `<!DOCTYPE html>
<html><head><meta charset="utf-8" />
${cdnScripts.join("\n")}
<style>
  :root {
    --bg:#0a0e1a; --bg-card:#111827; --bg-soft:#0f172a; --bg-hover:#1a2235;
    --border:#1f2937; --border-hi:#374151;
    --text:#e5e7eb; --text-muted:#9ca3af; --text-dim:#6b7280;
    --accent:#60a5fa; --green:#34d399; --amber:#fbbf24; --red:#f87171;
    --purple:#a78bfa; --cyan:#22d3ee; --pink:#f472b6;
  }
  * { box-sizing: border-box; }
  html, body { margin: 0; padding: 0; }
  body {
    font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', system-ui, sans-serif;
    background: var(--bg); color: var(--text); font-size: 13px; line-height: 1.5;
    padding: 20px 28px 32px;
  }
  .header {
    display: flex; align-items: center; justify-content: space-between;
    margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid var(--border);
  }
  .header h1 { margin: 0; font-size: 20px; font-weight: 600; letter-spacing: -0.02em; }
  .header .sub { color: var(--text-muted); font-size: 11px; font-variant-numeric: tabular-nums; }
  .live-dot {
    display: inline-block; width: 8px; height: 8px; border-radius: 50%;
    background: var(--green); box-shadow: 0 0 8px rgba(52,211,153,0.6);
    animation: pulse 1.6s ease-in-out infinite; margin-right: 6px; vertical-align: middle;
  }
  @keyframes pulse { 0%,100% { opacity: 0.4; } 50% { opacity: 1; } }
  @keyframes flash {
    0%   { box-shadow: 0 0 0 0 rgba(96,165,250,0); border-color: var(--border); }
    25%  { box-shadow: 0 0 0 4px rgba(96,165,250,0.5); border-color: var(--accent); }
    100% { box-shadow: 0 0 0 0 rgba(96,165,250,0); border-color: var(--border); }
  }
  .item-card.flash { animation: flash 1.2s ease-out 1; }
  .section-label {
    font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em;
    color: var(--text-dim); margin: 18px 0 8px;
  }
  .palette {
    display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 8px; margin-bottom: 14px;
  }
  .palette .btn { padding: 10px 12px; text-align: left; font-size: 12px; }
  .palette .btn .kbd {
    color: var(--text-dim); font-family: 'SF Mono', monospace; font-size: 10px; float: right;
  }
  .grid { display: grid; gap: 10px; }
  .item-card {
    background: var(--bg-card); border: 1px solid var(--border);
    border-radius: 10px; padding: 12px 14px; position: relative;
    transition: border-color 0.15s, opacity 0.2s;
  }
  .item-card::before {
    content: ''; position: absolute; left: 0; top: 0; bottom: 0;
    width: 3px; background: var(--accent);
  }
  /* badge style classes — b1, b2, b3 are conventional, plus parked */
  .item-card.b1::before { background: var(--accent); }
  .item-card.b2::before { background: var(--purple); }
  .item-card.b3::before { background: var(--cyan); }
  .item-card.parked { opacity: 0.55; }
  .item-card.parked::before { background: var(--text-dim); }
  /* status state classes — built-ins, others stylable via eval */
  .item-card.done { opacity: 0.5; }
  .item-card.done::before { background: var(--green); }
  .item-card.done .item-title { text-decoration: line-through; color: var(--text-muted); }
  .item-card.in_progress::before { background: var(--amber); box-shadow: 0 0 12px rgba(251,191,36,0.4); }
  .item-head { display: flex; align-items: center; gap: 10px; margin-bottom: 4px; }
  .item-title { font-weight: 600; font-size: 13px; flex: 1; }
  .item-badge {
    background: var(--bg-hover); color: var(--text-muted);
    font-size: 10px; font-weight: 700; padding: 3px 7px;
    border-radius: 4px; min-width: 22px; text-align: center;
  }
  .item-card.b1 .item-badge { background: rgba(96,165,250,0.15); color: var(--accent); }
  .item-card.b2 .item-badge { background: rgba(167,139,250,0.15); color: var(--purple); }
  .item-card.b3 .item-badge { background: rgba(34,211,238,0.15); color: var(--cyan); }
  .item-card.in_progress .item-badge { background: rgba(251,191,36,0.15); color: var(--amber); }
  .item-meta {
    display: flex; align-items: center; gap: 6px;
    font-size: 10px; color: var(--text-muted); margin-top: 6px; flex-wrap: wrap;
  }
  .chip {
    display: inline-flex; padding: 2px 6px; border-radius: 4px;
    background: var(--bg-hover); font-size: 10px; font-weight: 500;
  }
  .chip.green { background: rgba(52,211,153,0.12); color: var(--green); }
  .chip.amber { background: rgba(251,191,36,0.12); color: var(--amber); }
  .chip.red   { background: rgba(248,113,113,0.12); color: var(--red); }
  .chip.blue  { background: rgba(96,165,250,0.12); color: var(--accent); }
  .chip.purple{ background: rgba(167,139,250,0.12); color: var(--purple); }
  .chip.cyan  { background: rgba(34,211,238,0.12); color: var(--cyan); }
  .chip.dim   { background: var(--bg-hover); color: var(--text-dim); }
  .item-body { color: var(--text-muted); font-size: 11px; margin-top: 4px; }
  .item-body code, .palette code, .header code, .markdown code {
    font-family: 'SF Mono', monospace; font-size: 10px; background: var(--bg-hover);
    padding: 1px 4px; border-radius: 3px; color: var(--text);
  }
  .actions { display: flex; gap: 6px; margin-top: 10px; flex-wrap: wrap; }
  .btn {
    background: var(--bg-soft); border: 1px solid var(--border-hi); color: var(--text);
    padding: 5px 11px; border-radius: 6px; font-size: 11px; font-weight: 500;
    cursor: pointer; font-family: inherit; transition: all 0.1s;
  }
  .btn:hover { background: var(--bg-hover); border-color: var(--accent); color: var(--accent); }
  .btn:active { transform: scale(0.96); }
  .btn.primary { background: rgba(96,165,250,0.15); border-color: var(--accent); color: var(--accent); }
  .btn.primary:hover { background: rgba(96,165,250,0.25); }
  .btn.success { background: rgba(52,211,153,0.12); border-color: var(--green); color: var(--green); }
  .btn.danger  { background: rgba(248,113,113,0.10); border-color: var(--red); color: var(--red); }
  .panel {
    background: var(--bg-card); border: 1px solid var(--border); border-radius: 10px;
    padding: 12px 14px; margin-top: 12px; max-height: 260px; overflow-y: auto;
    font-family: 'SF Mono', monospace; font-size: 11px;
  }
  .log-entry {
    padding: 4px 0; border-bottom: 1px dashed var(--border);
    display: grid; grid-template-columns: 64px 1fr; gap: 10px; color: var(--text-muted);
  }
  .log-entry:last-child { border-bottom: none; }
  .log-time { color: var(--text-dim); font-variant-numeric: tabular-nums; }
  .log-msg.ok { color: var(--green); }
  .log-msg.warn { color: var(--amber); }
  .log-msg.err { color: var(--red); }
  .log-msg.info { color: var(--accent); }
  .log-empty { color: var(--text-dim); font-style: italic; padding: 8px 0; text-align: center; }
  .card {
    background: var(--bg-card); border: 1px solid var(--border);
    border-radius: 10px; padding: 14px 16px; overflow-x: auto;
  }
  .card svg { display: block; max-width: 100%; height: auto; }
  .pre, .code-block {
    background: var(--bg-card); border: 1px solid var(--border);
    border-radius: 10px; padding: 12px 14px;
    font-family: 'SF Mono', monospace; font-size: 11px;
    color: var(--text); white-space: pre; overflow-x: auto;
  }
  dl.kv {
    background: var(--bg-card); border: 1px solid var(--border);
    border-radius: 10px; padding: 14px 16px;
    display: grid; grid-template-columns: auto 1fr; gap: 4px 16px;
    font-size: 12px; margin: 0;
  }
  dl.kv dt { color: var(--text-dim); }
  dl.kv dd { margin: 0; color: var(--text); }
  .board-section { margin-bottom: 12px; }
  /* markdown styling — subtle, matches palette */
  .markdown { font-size: 12px; color: var(--text); }
  .markdown h1, .markdown h2, .markdown h3 { margin: 10px 0 6px; font-weight: 600; letter-spacing: -0.01em; }
  .markdown h1 { font-size: 16px; }
  .markdown h2 { font-size: 14px; color: var(--text); }
  .markdown h3 { font-size: 13px; color: var(--text-muted); }
  .markdown p { margin: 6px 0; color: var(--text-muted); }
  .markdown ul, .markdown ol { margin: 6px 0; padding-left: 20px; color: var(--text-muted); }
  .markdown li { margin: 2px 0; }
  .markdown a { color: var(--accent); text-decoration: none; }
  .markdown a:hover { text-decoration: underline; }
  .markdown blockquote {
    border-left: 3px solid var(--border-hi); padding-left: 10px; margin: 8px 0;
    color: var(--text-dim); font-style: italic;
  }
  /* mermaid host — center the diagram */
  .mermaid-host { display: flex; justify-content: center; }
  .mermaid-host .mermaid { font-family: inherit; }
</style>
</head>
<body>

<div class="header">
  <div>
    <span class="live-dot"></span>
    <h1 style="display:inline-block;">${spec.title || "Glimpse Board"}</h1>
  </div>
  <div class="sub" id="status">${spec.subtitle || "live"}</div>
</div>

${palette ? `<div class="section-label">Quick Actions</div><div class="palette">${palette}</div>` : ""}

<div id="sections">${sectionsHTML}</div>

<div class="section-label">${spec.logHeader || "Activity Log — pushed from agent"}</div>
<div class="panel" id="log">
  <div class="log-empty">no activity yet · waiting for actions…</div>
</div>

<script>
  // ---- core helpers ----
  function emit(action, payload) {
    window.glimpse.send({ action, payload, t: Date.now() });
    const status = document.getElementById('status');
    const original = status.textContent;
    status.textContent = '↑ ' + action;
    status.style.color = '#60a5fa';
    setTimeout(() => { status.textContent = original; status.style.color = ''; }, 900);
  }

  // ---- status state management ----
  // built-ins have CSS; arbitrary custom states are also accepted
  const BUILTIN_STATES = ['in_progress', 'done', 'parked'];
  let _customStates = new Set();
  function setStatus(id, state) {
    const el = document.querySelector('[data-id="' + id + '"]');
    if (!el) return;
    BUILTIN_STATES.forEach(s => el.classList.remove(s));
    _customStates.forEach(s => el.classList.remove(s));
    if (state) {
      el.classList.add(state);
      if (!BUILTIN_STATES.includes(state)) _customStates.add(state);
    }
  }

  // ---- log panel ----
  window.appendLog = function(level, msg) {
    const log = document.getElementById('log');
    const empty = log.querySelector('.log-empty');
    if (empty) empty.remove();
    const entry = document.createElement('div');
    entry.className = 'log-entry';
    const t = new Date();
    const time = t.toTimeString().slice(0,8);
    entry.innerHTML = '<span class="log-time">' + time + '</span><span class="log-msg ' + (level||'info') + '">' + msg + '</span>';
    log.appendChild(entry);
    log.scrollTop = log.scrollHeight;
  };
  window.markStatus = setStatus;

  // ---- section live updates ----
  window.updateSection = function(sectionId, header, bodyHTML) {
    let sec = document.querySelector('[data-section="' + sectionId + '"]');
    if (!sec) {
      sec = document.createElement('section');
      sec.className = 'board-section';
      sec.setAttribute('data-section', sectionId);
      document.getElementById('sections').appendChild(sec);
    }
    sec.innerHTML = (header ? '<div class="section-label">' + header + '</div>' : '') + bodyHTML;
  };
  window.removeSection = function(sectionId) {
    const sec = document.querySelector('[data-section="' + sectionId + '"]');
    if (sec) sec.remove();
  };

  // ---- goto: scroll to + flash an item card ----
  window.goto = function(itemId) {
    const el = document.querySelector('[data-id="' + itemId + '"]');
    if (!el) return;
    el.scrollIntoView({ behavior: 'smooth', block: 'center' });
    el.classList.remove('flash');
    void el.offsetWidth; // reflow so animation restarts
    el.classList.add('flash');
    setTimeout(() => el.classList.remove('flash'), 1400);
  };

  // ---- markdown ----
  if (window.marked) {
    document.querySelectorAll('[data-md]').forEach(el => {
      el.innerHTML = window.marked.parse(el.textContent);
    });
  }
  window.renderMarkdown = function(sectionId) {
    if (!window.marked) return;
    const sec = document.querySelector('[data-section="' + sectionId + '"] [data-md]');
    if (sec) sec.innerHTML = window.marked.parse(sec.textContent);
  };

  // ---- mermaid ----
  if (window.mermaid) {
    window.mermaid.initialize({ startOnLoad: false, theme: 'dark', securityLevel: 'loose' });
    document.querySelectorAll('.mermaid-host .mermaid').forEach((el, i) => {
      try { window.mermaid.run({ nodes: [el] }); } catch (e) { console.warn('mermaid run failed', e); }
    });
  }
  window.renderMermaid = function(sectionId) {
    if (!window.mermaid) return;
    const el = document.querySelector('[data-section="' + sectionId + '"] .mermaid');
    if (!el) return;
    // re-run mermaid on the (possibly new) graph text
    el.removeAttribute('data-processed');
    try { window.mermaid.run({ nodes: [el] }); } catch (e) { console.warn('mermaid run failed', e); }
  };

  // ---- keyboard ----
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') window.glimpse.close();
  });
  ${(spec.palette || [])
    .filter((a) => a.shortcut && a.shortcut.startsWith("⌘"))
    .map((a) => {
      const key = a.shortcut.replace("⌘", "").toLowerCase();
      const payload = a.payload ? JSON.stringify(a.payload) : "null";
      return `document.addEventListener('keydown', e => { if (e.metaKey && e.key === '${key}') { emit(${JSON.stringify(a.action)}, ${payload}); e.preventDefault(); } });`;
    })
    .join("\n  ")}
</script>
</body></html>`;

// ---------- launch + bridge ----------

const win = open(html, {
  width: spec.width || 940,
  height: spec.height || 980,
  title: spec.title || "Glimpse Board",
});

win.on("ready", () => {
  process.stdout.write(`MSG: ${JSON.stringify({ action: "_ready" })}\n`);
});

win.on("message", (data) => {
  process.stdout.write(`MSG: ${JSON.stringify(data)}\n`);
});

let lastSize = 0;
function readControl() {
  try {
    const buf = readFileSync(CONTROL, "utf8");
    if (buf.length <= lastSize) return;
    const fresh = buf.slice(lastSize);
    lastSize = buf.length;
    for (const line of fresh.split("\n")) {
      if (!line.trim()) continue;
      try {
        const cmd = JSON.parse(line);
        if (cmd.log) {
          win.send(`window.appendLog(${JSON.stringify(cmd.level || "info")}, ${JSON.stringify(cmd.log)})`);
        }
        if (cmd.status) {
          win.send(`window.markStatus(${JSON.stringify(cmd.status.id)}, ${JSON.stringify(cmd.status.state)})`);
        }
        if (cmd.section) {
          if (cmd.section.remove) {
            win.send(`window.removeSection(${JSON.stringify(cmd.section.id)})`);
          } else {
            win.send(
              `window.updateSection(${JSON.stringify(cmd.section.id)}, ${JSON.stringify(cmd.section.header || "")}, ${JSON.stringify(cmd.section.html || "")})`
            );
          }
        }
        if (cmd.eval) {
          win.send(cmd.eval);
        }
      } catch (e) {
        process.stderr.write(`bad control line: ${e.message}\n`);
      }
    }
  } catch {}
}
watchFile(CONTROL, { interval: 250 }, readControl);
readControl();

win.on("closed", () => process.exit(0));
