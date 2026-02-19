vim.lsp.config("pyre", {
  cmd = { "pyre", "persistent" },
  filetypes = { "python" },
  root_markers = { ".pyre_configuration" },
  workspace_required = true,
})

return {}
