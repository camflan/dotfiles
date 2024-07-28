-- Common LSP functions and config
--

-- Fn to toggle inlay_hints for LSPs
local toggle_inlay_hints = function(bufnr)
  local toggle_opts = {}

  if bufnr ~= nil then
    toggle_opts = {
      filter = {
        bufnr = bufnr,
      },
    }
  end

  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), toggle_opts)
end

-- Custom UI handlers
local common_handlers = {}
common_handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
common_handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

return {
  flags = {},
  handlers = common_handlers,
  on_attach = function(_, bufnr)
    local keymap_opts = { buffer = bufnr, noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>i", "<Cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<CR>", keymap_opts)
    -- vim.keymap.set("n", "<leader>o", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>u", "<cmd>lua vim.diagnostic.open_float()<CR>", keymap_opts)
    vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", keymap_opts)
    vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", keymap_opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", keymap_opts)
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>ti", toggle_inlay_hints, {
      desc = "Toggle inlay hints",
    })

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- configure LSP Diagnostic
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        format = function(diagnostic)
          if diagnostic.source == "eslint" then
            return string.format(
              "%s (%s: %s)",
              diagnostic.message,
              diagnostic.source,
              -- shows the name of the rule
              diagnostic.user_data.lsp.code
            )
          end

          return string.format("%s (%s)", diagnostic.message, diagnostic.source)
        end,
        severity_sort = true,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        max_width = 80,
      },
    })
  end,
}
