-- Set which codelens text levels to show
local original_set_virtual_text = vim.lsp.diagnostic.set_virtual_text
local set_virtual_text_custom = function(diagnostics, bufnr, client_id, sign_ns, opts)
  opts = opts or {}
  opts.severity_limit = "Warning"
  original_set_virtual_text(diagnostics, bufnr, client_id, sign_ns, opts)
end

vim.lsp.diagnostic.set_virtual_text = set_virtual_text_custom

-- local Module to hold some common items
local common = {
  flags = {},
  on_attach = function(_, bufnr)
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

-- TODO: dedupe this with linters/formatters
local lsps = {
  "biome",
  "cssmodules_ls",
  "eslint",
  "flake8",
  "graphql",
  "intelephense",
  "jsonls",
  "lua_ls",
  "pyproject-flake8",
  "pyright",
  "ruff",
  "ruff_lsp",
  "selene",
  "stylua",
  "svelte",
  "tailwindcss",
  "tsserver",
  "vim-language-server",
}

local linters_by_ft = {}

local formatters_by_ft = {
  go = { "gofmt" },
  javascript = { "prettier" },
  typescript = { "prettier" },
  javascriptreact = { "prettier" },
  typescriptreact = { "prettier" },
  lua = { "stylua" },
  markdown = { "markdownlint", "injected" },
  sql = { "pg_format" },
  -- these are dynamically selected in conform
  python = {
    -- "ruff_fix", "ruff_format",
    "isort",
    "black",
  },
  -- terraform = {
  --   "terraform_fmt",
  -- },
  yaml = {
    "yamlfix",
    "yamlfmt",
  },
  -- all files
  ["*"] = { "codespell" },
  -- files without any formatters available
  ["_"] = { "trim_whitespace" },
}

local debuggers = {}

local do_not_install = {
  -- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
  "gofmt",
  "pg_format",
  "stylelint",
  -- not real formatters, but pseudo-formatters from conform.nvim
  "trim_whitespace",
  "trim_newlines",
  "squeeze_blanks",
  "injected",
}

---given the linter- and formatter-list of nvim-lint and conform.nvim, extract a
---list of all tools that need to be auto-installed
---@param my_lsps object[]
---@param my_linters object[]
---@param my_formatters object[]
---@param my_debuggers string[]
---@param tools_to_ignore string[]
---@return string[] tools
---@nodiscard
local function tools_to_auto_install(my_lsps, my_linters, my_formatters, my_debuggers, tools_to_ignore)
  -- get all linters, formatters, & debuggers and merge them into one list
  local lsp_list = vim.tbl_flatten(vim.tbl_values(my_lsps))
  local linter_list = vim.tbl_flatten(vim.tbl_values(my_linters))
  local tools = vim.list_extend(lsp_list, linter_list)

  local formatter_list = vim.tbl_flatten(vim.tbl_values(my_formatters))
  vim.list_extend(tools, formatter_list)
  vim.list_extend(tools, my_debuggers)

  -- only unique tools
  table.sort(tools)
  tools = vim.fn.uniq(tools)

  -- remove exceptions not to install
  tools = vim.tbl_filter(function(tool)
    return not vim.tbl_contains(tools_to_ignore, tool)
  end, tools)

  return tools
end

return {
  -- LSP status/notifications
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      notification = {
        override_vim_notify = true,
      },
    },
  },
  {
    "lsp_lines",
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    lazy = true,
    config = function()
      local lsp_lines = require("lsp_lines")
      lsp_lines.setup()

      -- Swap lsp_lines and built-in virtual_text usage for LSP
      local function toggle_lsp_lines()
        local new_value = lsp_lines.toggle()

        vim.diagnostic.config({
          virtual_text = not new_value,
        })
      end

      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = true,
      })

      vim.keymap.set("", "<Leader>L", toggle_lsp_lines, { desc = "Toggle lsp_lines" })
    end,
  },
  -- eslint rule lookup
  {
    "chrisgrieser/nvim-rulebook",
    config = true,
    keys = {
      {
        "<leader>ri",
        function()
          require("rulebook").ignoreRule()
        end,
        desc = "Ignore rule",
      },
      {
        "<leader>rl",
        function()
          require("rulebook").lookupRule()
        end,
        desc = "Lookup rule",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    config = true,
  },
  -- Ensures tools/linters/etc are installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    lazy = true,
    event = "VeryLazy",
    cmd = { "Mason", "MasonInstall", "MasonToolsInstall" },
    config = function()
      local ensure_installed = tools_to_auto_install(lsps, linters_by_ft, formatters_by_ft, debuggers, do_not_install)

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
        auto_update = false,
        run_on_start = false,
        start_delay = 3000, -- 3 seconds
        debounce_hours = 24,
      })
    end,
  },
  -- formatters
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>P",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    -- Everything in opts will be passed to setup()
    opts = {
      formatters_by_ft = formatters_by_ft,
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
    -- config = function(_, opts)
    --   require("conform").setup(opts)

    --   -- TODO: dynamically select formatters
    --   -- python = function(bufnr)
    --   --     if require("conform").get_formatter_info("ruff_format", bufnr).available then
    --   --         return { "ruff_fix", "ruff_format" }
    --   --     else
    --   --         return { "isort", "black" }
    --   --     end
    --   -- end,
    -- end,
  },
  -- linters
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = linters_by_ft
    end,
  },
  -- Workspace-wide TSC
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
  },
  -- lua dev environment config for neovim plugins
  {
    "folke/neodev.nvim",
    lazy = true,
    opts = {
      -- library = {
      --   plugins = {
      --     "nvim-dap-ui",
      --   },
      --   types = true,
      -- },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/schemastore.nvim",
      "folke/neodev.nvim",
      "hrsh7th/nvim-cmp",
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    },
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
          npmLocation = "$HOME/.asdf-data/shims/npm",
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

      LSP.biome.setup({
        capabilities = capabilities,
        flags = common.flags,
        on_attach = common.on_attach,
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

      LSP.jsonls.setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      LSP.pyright.setup({
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
        settings = {
          python = {
            analysis = {
              project = "pyproject.toml",
            },
          },
        },
      })

      LSP.tailwindcss.setup({
        capabilities = capabilities,
        on_attach = common.on_attach,
        flags = common.flags,
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "cva\\(((?:[^()]|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "classnames\\(([^)]*)\\)", "'([^']*)'" },
                { "cx\\(([^)]*)\\)", "'([^']*)'" },
                { "clsx\\(([^)]*)\\)", "'([^']*)'" },
                -- { "cva\\(([^)]*)\\)", "'([^']*)'" },
              },
            },
          },
        },
      })
    end,
  },
}
