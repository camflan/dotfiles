local borders = require("utils.borders")

vim.pack.add({
    { src = "https://github.com/Chaitanyabsprip/fastaction.nvim" },
    { src = "https://github.com/b0o/schemastore.nvim" },
    { src = "https://github.com/dmmulroy/tsc.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = "https://github.com/marilari88/twoslash-queries.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
})

require("fastaction").setup({})
require("fidget").setup({})
require("tsc").setup({
    use_diagnostics = true,
    use_trouble_qflist = true,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    callback = function()
        vim.keymap.set({ "n" }, "<leader>dT", "<cmd>TSC<cr>", {
            desc = "Open TSC issues"
        })
    end,
})

vim.diagnostic.config({
    float = {
        border = borders.rounded,
        severity_sort = true,
        source = "if_many",
    },
    severity_sort = true,
    virtual_text = false,
})

vim.lsp.config("*", {
    on_attach = function(_, bufnr)
        -- overwrites omnifunc/tagfunc set by some Python plugins to the
        -- default values for LSP
        vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
        vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })

        local keymap_opts = { buffer = bufnr, noremap = true, silent = true }

        vim.keymap.set(
            { "n", "x" },
            "<leader>da",
            '<cmd>lua require("fastaction").code_action()<CR>',
            { desc = "Display code actions", buffer = bufnr }
        )
        -- vim.keymap.set({ "n", "v" }, "<leader>da", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
        vim.keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
        vim.keymap.set("n", "<leader>i", '<cmd>lua vim.lsp.buf.hover({ border = "rounded" })<CR>', keymap_opts)
        vim.keymap.set("n", "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<CR>", keymap_opts)
        vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<CR>", keymap_opts)
        vim.keymap.set("n", "<leader>u", "<cmd>lua vim.diagnostic.open_float()<CR>", keymap_opts)

        -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        --     vim.lsp.diagnostic.on_publish_diagnostics, {
        --         signs = true,
        --         underline = true,
        --         virtual_text = true
        --     }
        -- )
    end,
})

vim.lsp.enable({
    "elixirls",
    "eslint",
    "graphql",
    "jsonls",
    "tailwindcss",
    "taplo",
    "terraformls",
    "vtsls",
    "yamlls",
})
