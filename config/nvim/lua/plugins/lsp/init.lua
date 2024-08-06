local constants = require("plugins.lsp.constants")

return {
  {
    "sontungexpt/better-diagnostic-virtual-text",
    enabled = false,
    event = { "LspAttach" },
    config = function()
      require("better-diagnostic-virtual-text").setup({
        inline = true,
        ui = {
          above = true,
        },
      })

      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    enabled = constants.flags.USE_TINY_INLINE_DIAGNOSTIC,
    event = "VeryLazy",
    config = function()
      local tiny_inline = require("tiny-inline-diagnostic")
      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = false,
      })

      tiny_inline.setup({})
    end,
  },

  {
    "lsp_lines",
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    enabled = true,
    event = { "LspAttach" },
    config = function()
      local lsp_lines = require("lsp_lines")
      lsp_lines.setup()

      -- Swap lsp_lines and built-in virtual_text usage for LSP
      local function toggle_lsp_lines()
        local new_value = lsp_lines.toggle()

        local virtual_lines_opts = nil

        if new_value then
          virtual_lines_opts = {
            only_current_line = true,
          }
        else
          virtual_lines_opts = false
        end

        if not constants.flags.USE_TINY_INLINE_DIAGNOSTIC then
          -- comment this setting out when using tiny-inline-diagnostic above
          vim.diagnostic.config({
            virtual_text = not new_value,
            virtual_lines = virtual_lines_opts,
          })
        end
      end

      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = not constants.flags.USE_TINY_INLINE_DIAGNOSTIC,
      })

      vim.keymap.set("", "<leader>tl", toggle_lsp_lines, { desc = "Toggle lsp_lines" })
    end,
  },
  -- eslint rule lookup
  {
    "chrisgrieser/nvim-rulebook",
    config = true,
    keys = {
      {
        "<leader>dri",
        function()
          require("rulebook").ignoreRule()
        end,
        desc = "Ignore rule",
      },
      {
        "<leader>drl",
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
      local lsp_utils = require("plugins.lsp.utils")
      local ensure_installed = lsp_utils.tools_to_auto_install(
        constants.lsps,
        constants.linters_by_ft,
        constants.formatters_by_ft,
        constants.debuggers,
        constants.do_not_install
      )

      require("mason-tool-installer").setup({
        automatic_installation = true,
        ensure_installed = ensure_installed,
        auto_update = false,
        run_on_start = true,
        start_delay = 3000, -- 3 seconds
        debounce_hours = 24,
      })
    end,
  },
  -- formatters
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile", "BufWritePre", "VeryLazy" },
    cmd = { "ConformInfo", "ConformEnable", "ConformDisable" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>P",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "n",
        desc = "Format buffer",
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function()
      local conform = require("conform")

      -- Track slow formatting filetypes so we can run async
      local slow_format_filetypes = {}

      conform.setup({
        default_format_opts = {
          lsp_format = "fallback",
        },
        formatters_by_ft = constants.formatters_by_ft,
        formatters = {
          codespell = {
            condition = function(_, ctx)
              -- NOTE: Do NOT let codespell run on lock files!
              if vim.fs.basename(ctx.filename) == "package-lock.json" then
                return false
              -- NOTE: Do not run on Prisma files because it can change some Index types (BRING => BRING)
              elseif vim.fs.basename(ctx.filename) == "schema.prisma" then
                return false
              else
                return true
              end
            end,
          },
          yamlfix = {
            env = {
              YAMLFIX_SECTION_WHITELINES = "1",
              YAMLFIX_WHITELINES = "1",
            },
          },
        },
        -- Set up format-on-save
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          local function on_format(err)
            if err and err:match("timeout$") then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return { timeout_ms = 200, lsp_format = "fallback" }, on_format
        end,

        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_format = "fallback" }
        end,
      })

      vim.api.nvim_create_user_command("ConformDisable", function(args)
        if args.bang then
          -- ConformDisable! will disable formatting just for this buffer
          ---@diagnostic disable-next-line: inject-field
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("ConformEnable", function()
        ---@diagnostic disable-next-line: inject-field
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })

      --   -- TODO: dynamically select formatters
      --   -- python = function(bufnr)
      --   --     if require("conform").get_formatter_info("ruff_format", bufnr).available then
      --   --         return { "ruff_fix", "ruff_format" }
      --   --     else
      --   --         return { "isort", "black" }
      --   --     end
      --   -- end,
    end,
  },
  -- linters
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = constants.linters_by_ft
    end,
  },
  -- Workspace-wide TSC
  {
    "dmmulroy/tsc.nvim",
    keys = {
      {
        "<leader>dT",
        "<cmd>TSC<CR>",
        desc = "Run TSC on entire workspace",
      },
    },
    opts = {
      auto_start_watch_mode = true,
    },
    cmd = { "TSC" },
  },
  -- lua dev environment config for neovim plugins
  {
    "folke/neodev.nvim",
    lazy = true,
    ft = { "lua" },
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
    "marilari88/twoslash-queries.nvim",
    keys = {
      {
        "<leader>dq",
        "<cmd>TwoslashQueriesInspect<CR>",
        desc = "Add magic twoslash comment for type introspection",
      },
    },
    config = function()
      local tsq = require("twoslash-queries")

      tsq.setup({
        multi_line = true,
        highlight = "Comment",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/schemastore.nvim",
      "dmmulroy/ts-error-translator.nvim",
      "folke/neodev.nvim",
      "hrsh7th/nvim-cmp",
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      "j-hui/fidget.nvim",
      "marilari88/twoslash-queries.nvim",
      -- "artemave/workspace-diagnostics.nvim",
    },
    config = function()
      local common = require("plugins.lsp.common")
      local lsp_config = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- local workspace_diagnostics = require("workspace-diagnostics")
      local twoslash = require("twoslash-queries")

      -- Set which cmdelens text levels to show
      -- local original_set_virtual_text = vim.lsp.diagnostic.set_virtual_text
      -- local set_virtual_text_custom = function(diagnostics, bufnr, client_id, sign_ns, opts)
      --   opts = opts or {}
      --   opts.severity_limit = "Warning"
      --   original_set_virtual_text(diagnostics, bufnr, client_id, sign_ns, opts)
      -- end
      --
      -- vim.lsp.diagnostic.set_virtual_text = set_virtual_text_custom

      -- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
      vim.lsp.handlers["textDocument/hover"] = common.handlers["textDocument/hover"]

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- 🪄 TYPESCRIPT LANGUAGE SERVER STUFF
      if constants.flags.USE_TYPESCRIPT_TOOLS_INSTEAD_OF_TSSERVER then
        -- noop
      else
        lsp_config.tsserver.setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            -- we want prettier to format files, not tsserver
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            -- workspace_diagnostics.populate_workspace_diagnostics(client, bufnr)
            twoslash.attach(client, bufnr)
            common.on_attach(client, bufnr)
          end,
          flags = common.flags,
          init_options = {
            npmLocation = "$HOME/.asdf-data/shims/npm",
            preferences = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
              importModuleSpecifierPreference = "non-relative",
            },
          },
        })
      end

      lsp_config.gopls.setup({
        capabilities = capabilities,
        on_attach = common.on_attach,
        flags = common.flags,
      })

      lsp_config.prismals.setup({
        capabilities = capabilities,
        on_attach = common.on_attach,
        flags = common.flags,
      })

      lsp_config.lua_ls.setup({
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

      -- lsp_config.biome.setup({
      --   capabilities = capabilities,
      --   flags = common.flags,
      --   on_attach = common.on_attach,
      -- })

      lsp_config.cssmodules_ls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- avoid accepting `definitionProvider` responses from this LSP
          client.server_capabilities.definitionProvider = false
          common.on_attach(client, bufnr)
        end,
        flags = common.flags,
      })

      lsp_config.eslint.setup({
        capabilities = capabilities,
        filetypes = {
          "astro",
          "graphql",
          "javascript",
          "javascript.jsx",
          "javascriptreact",
          "svelte",
          "typescript",
          "typescript.tsx",
          "typescriptreact",
          "vue",
        },
        flags = common.flags,
        on_attach = function(client, bufnr)
          -- Fix on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })

          -- workspace_diagnostics.populate_workspace_diagnostics(client, bufnr)
          common.on_attach(client, bufnr)
        end,
      })

      lsp_config.graphql.setup({
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

      local schemastore = require("schemastore")

      lsp_config.jsonls.setup({
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      })

      lsp_config.jsonnet_ls.setup({
        capabilities = capabilities,
        on_attach = common.on_attach,
        flags = common.flags,
        cmd = { "jsonnet-language-server", "--lint" }, -- Linting can be noisy

        settings = {
          formatting = {
            UseImplicitPlus = true, -- Recommended but might conflict with project-level jsonnetfmt settings
          },
        },
      })

      -- TODO: pull override from env?
      local KUBERNETES_SCHEMA_VERSION = "v1.26.9"
      local KUBERNETES_SCHEMA_VARIANT = "standalone-strict"

      lsp_config.yamlls.setup({
        capabilities = capabilities,
        on_attach = common.on_attach,
        flags = common.flags,
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            completion = true,
            hover = true,
            schemas = schemastore.yaml.schemas({
              extra = {
                {
                  description = "",
                  fileMatch = { "*.k8s.yaml" },
                  name = "Kubernetes " .. KUBERNETES_SCHEMA_VERSION,
                  url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/"
                    .. KUBERNETES_SCHEMA_VERSION
                    .. "-"
                    .. KUBERNETES_SCHEMA_VARIANT
                    .. "/all.json",
                },
              },
            }),
            schemaStore = {
              -- disable built-in schemastore so we can
              -- use b00/schemastore
              enable = false,
              url = "",
            },
            validate = true,
          },
        },
      })

      lsp_config.pyright.setup({
        capabilities = capabilities,
        flags = common.flags,
        on_attach = common.on_attach,
      })

      lsp_config.ruff_lsp.setup({
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

      lsp_config.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = common.on_attach,
        flags = common.flags,
      })

      lsp_config.tailwindcss.setup({
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

  -- nicer TS error messages
  {
    "dmmulroy/ts-error-translator.nvim",
    lazy = true,
    opts = {
      auto_override_publish_diagnostics = true,
      settings = {
        code_lens = "all",
        tsserver_file_preferences = {
          includeInlayFunctionParameterTypeHints = "all",
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = "all",
        },
      },
    },
  },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    enabled = constants.flags.USE_TYPESCRIPT_TOOLS_INSTEAD_OF_TSSERVER,
    event = { "VeryLazy" },
    config = function()
      local common = require("plugins.lsp.common")
      local tt = require("typescript-tools")

      tt.setup({
        handlers = common.handlers,
        on_attach = function(_, bufnr)
          common.on_attach(_, bufnr)
        end,
      })
    end,
  },
}
