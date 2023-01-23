local LSP = require("lspconfig")
local common = require("plugin.nvim-lspconfig.common")

LSP.tsserver.setup {
    on_attach = function (client, bufnr)
      -- we want prettier to format files, not tsserver
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      common.on_attach(client, bufnr)
    end,
    flags = common.flags,
    init_options = {
        npmLocation = "$HOME/.volta/bin/npm"
    }
}
