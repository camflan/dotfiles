local LSP = require("lspconfig")
local common = require("plugin.nvim-lspconfig.common")

LSP.eslint.setup{
    on_attach = common.on_attach,
    flags = common.flags
}
