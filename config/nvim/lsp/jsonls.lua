local schemastore = require("schemastore")

vim.lsp.config("jsonls", {
    settings = {
        json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
        },
    },
})
