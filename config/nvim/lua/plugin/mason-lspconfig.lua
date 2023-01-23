local mason_lsp = require('mason-lspconfig')

mason_lsp.setup({
        ensure_installed = {
            "cssmodules_ls",
            "efm",
            "eslint",
            "graphql",
            "intelephense",
            "pyright",
            "svelte",
            "tailwindcss",
            "tsserver"
        }
})
