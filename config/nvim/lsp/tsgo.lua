return {
  cmd = {
    "npx",
    "tsgo",
    "--lsp",
    "-stdio",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json" },
}
