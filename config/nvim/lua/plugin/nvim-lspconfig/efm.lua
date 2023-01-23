local LSP = require("lspconfig")
local common = require("plugin.nvim-lspconfig.common")

local black = { formatCommand = 'black --quiet -', formatStdin = true }

local flake8 = {
  lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
  lintStdin = true,
  lintFormats = { '%f:%l:%c: %m' }
}

local isort = { formatCommand = 'isort --quiet -', formatStdin = true }

local ssort = { formatCommand = 'ssort' }

-- normal prettier
--local prettier = {
 --formatCommand = "npx prettier --stdin-filepath ${INPUT}",
 --formatStdin = true,
--}

-- uses prettier_d
local prettier = {
  formatCommand = 'prettierd "${INPUT}"',
  formatStdin = true,
}

local luaformatter = {formatCommand = 'lua-format -i', formatStdin = true}

local filetype_config = {
  css = {prettier},
  html = {prettier},
  javascript = {prettier},
  javascriptreact = {prettier},
  json = {prettier},
  jsonc = {prettier},
  less = {prettier},
  lua = {luaformatter},
  markdown = {prettier},
  python = {black, flake8, isort, ssort},
  scss = {prettier},
  scss = {prettier},
  typescript = {prettier},
  typescriptreact = {prettier},
  yaml = {prettier},
}

LSP.efm.setup {
    filetypes = vim.tbl_keys(filetype_config),
    init_options = { documentFormatting = true, codeAction = true },
    on_attach = function (client, bufnr)
        client.server_capabilities.document_formatting = true

        common.on_attach(client, bufnr)
    end,
    root_dir = LSP.util.root_pattern({ '.git/', 'tsconfig.json', 'package.json', 'pyproject.toml' }),
    settings = { languages = filetype_config, },
}
