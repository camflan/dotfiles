-- Set which codelens text levels to show
local original_set_virtual_text = vim.lsp.diagnostic.set_virtual_text
local set_virtual_text_custom = function(diagnostics, bufnr, client_id, sign_ns, opts)
  opts = opts or {}
  opts.severity_limit = "Warning"
  original_set_virtual_text(diagnostics, bufnr, client_id, sign_ns, opts)
end

vim.lsp.diagnostic.set_virtual_text = set_virtual_text_custom

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- local Module to hold some common items
local common = {
  flags = {},
  on_attach = function(client, bufnr)
    local keymap_opts = { buffer = bufnr, noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set("n", "<leader>i", "<Cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
    vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", keymap_opts)
    vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", keymap_opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", keymap_opts)
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>o", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>u", "<cmd>lua vim.diagnostic.open_float()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", keymap_opts)

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end

    -- configure LSP Diagnostic
    vim.diagnostic.config({
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "shadow",
        format = function(diagnostic)
          if diagnostic.source == "eslint" then
            return string.format(
              "%s (%s: %s)",
              diagnostic.message,
              diagnostic.source,
              -- shows the name of the rule
              diagnostic.user_data.lsp.code
            )
          end

          return string.format("%s (%s)", diagnostic.message, diagnostic.source)
        end,
        severity_sort = true,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        max_width = 80,
      },
    })
  end,
}

return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        on_attach = common.on_attach,
        sources = {
          -- need to filter out spelling in code
          -- null_ls.builtins.code_actions.cspell,
          -- null_ls.builtins.completion.spell,
          -- null_ls.builtins.diagnostics.cspell,
          null_ls.builtins.diagnostics.pyproject_flake8,
          null_ls.builtins.diagnostics.selene.with({
            cwd = function()
              return vim.fs.dirname(
                vim.fs.find({ "selene.toml" }, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
              ) or vim.fn.expand("~/.config/selene/") -- fallback value
            end,
          }),
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.markdownlint,
          null_ls.builtins.formatting.prettier.with({
            prefer_local = "node_modules/.bin",
          }),
          null_ls.builtins.formatting.stylua,
        },
      })
    end,
  },
  {
    "dmmulroy/tsc.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local LSP = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      LSP.tsserver.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- we want prettier to format files, not tsserver
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          common.on_attach(client, bufnr)
        end,
        flags = common.flags,
        init_options = {
          npmLocation = "$HOME/.volta/bin/npm",
        },
      })

      LSP.lua_ls.setup({
        capabilities = capabilities,
        on_attach = common.on_attach,
        flags = common.flags,
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                "vim",
              },
            },
          },
        },
      })

      LSP.cssmodules_ls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- avoid accepting `definitionProvider` responses from this LSP
          client.server_capabilities.definitionProvider = false
          common.on_attach(client, bufnr)
        end,
        flags = common.flags,
      })

      LSP.eslint.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Fix on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })

          common.on_attach(client, bufnr)
        end,
        flags = common.flags,
      })

      LSP.graphql.setup({
        capabilities = capabilities,
        on_attach = common.on_attach,
        flags = common.flags,
        filetypes = {
          "graphql",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
      })

      LSP.pyright.setup({
        capabilities = capabilities,
        flags = common.flags,
        on_attach = common.on_attach,
      })

      LSP.rome.setup({
        capabilities = capabilities,
        flags = common.flags,
        on_attach = common.on_attach,
      })

      LSP.ruff_lsp.setup({
        capabilities = capabilities,
        flags = common.flags,
        on_attach = function(client, bufnr)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false

          common.on_attach(client, bufnr)
        end,
      })

      LSP.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = common.on_attach,
        flags = common.flags,
      })
    end,
  },
}
