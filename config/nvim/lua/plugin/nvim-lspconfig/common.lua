-- Set which codelens text levels to show
local original_set_virtual_text = vim.lsp.diagnostic.set_virtual_text
local set_virtual_text_custom = function(diagnostics, bufnr, client_id, sign_ns, opts)
    opts = opts or {}
    opts.severity_limit = "Warning"
    original_set_virtual_text(diagnostics, bufnr, client_id, sign_ns, opts)
end

vim.lsp.diagnostic.set_virtual_text = set_virtual_text_custom

-- customize signs
-- vim.fn.sign_define("DiagnosticsSignError", { text= "🚨" })
-- vim.fn.sign_define("DiagnosticsSignWarning", { text= "⚠️" })
vim.fn.sign_define("DiagnosticSignHint", { text= "" })
-- vim.fn.sign_define("DiagnosticsSignInformation", { text= "📢" })



-- local Module to hold some common items
local M = {}

-- this is a list of servers to run setup for automatically without config
M.on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    local keymap_opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<leader>i', '<Cmd>lua vim.lsp.buf.hover()<CR>', keymap_opts)
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', keymap_opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', keymap_opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', keymap_opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', keymap_opts)
    buf_set_keymap('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', keymap_opts)
    buf_set_keymap('n', '<leader>o', '<cmd>lua vim.lsp.buf.signature_help()<CR>', keymap_opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts)
    buf_set_keymap('n', '<leader>u', "<cmd>lua vim.diagnostic.open_float(nil, { source = 'always' })<CR>", keymap_opts)
    buf_set_keymap('n', '<leader>k', '<cmd>lua vim.diagnostic.goto_prev()<CR>', keymap_opts)
    buf_set_keymap('n', '<leader>j', '<cmd>lua vim.diagnostic.goto_next()<CR>', keymap_opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', keymap_opts)

    -- buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', keymap_opts)
    -- buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', keymap_opts)
    -- buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', keymap_opts)
    buf_set_keymap("n", "<leader>p", "<cmd>lua vim.lsp.buf.formatting()<CR>", keymap_opts)


    if client.resolved_capabilities.document_formatting then
        vim.cmd [[autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync(nil, 3000)]]
    end
end

M.flags = {
    debounce_text_changes = 100
}

return M
