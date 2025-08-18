vim.lsp.config("biome", {
  cmd = { "npx", "biome", "lsp-proxy" },
  workspace_required = true,
})

return {}
