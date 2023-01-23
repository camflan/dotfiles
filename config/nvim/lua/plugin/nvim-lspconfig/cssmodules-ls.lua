local LSP = require('lspconfig')
local common = require("plugin.nvim-lspconfig.common")

LSP.cssmodules_ls.setup({
    on_attach = function (client, bufnr)
        -- avoid accepting `definitionProvider` responses from this LSP
        client.server_capabilities.definitionProvider = false
        common.on_attach(client, bufnr)
    end,
    flags = common.flags,
})
