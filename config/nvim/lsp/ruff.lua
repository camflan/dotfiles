return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", "setup.py", ".git" },
  on_attach = function(client)
    -- Disable hover in favor of type checker (ty/pyright/pyre)
    client.server_capabilities.hoverProvider = false
  end,
}
