local LSP = require("lspconfig")
local common = require("plugin.nvim-lspconfig.common")

LSP.graphql.setup{
    on_attach = common.on_attach,
    flags = common.flags,
    filetypes = {
        "graphql",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact"
    }
}
