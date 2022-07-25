local LSP = require("lspconfig")
local common = require("plugin.nvim-lspconfig.common")

LSP.pyright.setup {
    on_attach = common.on_attach,
    flags = common.flags
}
