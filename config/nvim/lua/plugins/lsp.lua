vim.lsp.config('*', {
    on_attach = function(client, bufnr)
        -- overwrites omnifunc/tagfunc set by some Python plugins to the
        -- default values for LSP
        vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {buf = bufnr})
        vim.api.nvim_set_option_value('tagfunc', 'v:lua.vim.lsp.tagfunc', {buf = bufnr})

    local keymap_opts = { buffer = bufnr, noremap = true, silent = true }

      vim.keymap.set({ "n", "v" }, "<leader>da", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>i", "<Cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<CR>", keymap_opts)

        vim.diagnostic.config({ virtual_text = true })

        -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        --     vim.lsp.diagnostic.on_publish_diagnostics, {
        --         signs = true,
        --         underline = true,
        --         virtual_text = true
        --     }
        -- )
    end
})


vim.lsp.enable({
    "vtsls"
})

return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    config = true,
    cmd = { "Mason", "MasonInstall", "MasonToolsInstall" },
  },
}
