local utils = require("lib.utils")

local COMPLETION_ENGINE = "saghen/blink.cmp"
local is_cmp_enabled = utils.make_is_enabled_predicate(COMPLETION_ENGINE)

return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = "default" },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
        },
      },

      signature = { enabled = true },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = {
                    "lazydev",
                    "lsp", "path", "snippets", "buffer" },

        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },

        min_keyword_length = function(ctx)
          -- only applies when typing a command, doesn't apply to arguments
          if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
            return 2 -- autocomplete after 2 characters
          end

          return 0
        end,
      },
    },
    opts_extend = { "sources.default" },
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "BufRead", "BufNewFile", "InsertEnter" },
    cond = is_cmp_enabled,
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      -- "milanglacier/minuet-ai.nvim",
      "neovim/nvim-lspconfig",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      vim.opt.completeopt = "preview,menu,menuone,noselect"

      local cmp = require("cmp")

      local kind_icons = {
        Text = "  ",
        Method = "  ",
        Function = "  ",
        Constructor = "  ",
        Field = "  ",
        Variable = "  ",
        Class = "  ",
        Interface = "  ",
        Module = "  ",
        Property = "  ",
        Unit = "  ",
        Value = "  ",
        Enum = "  ",
        Keyword = "  ",
        Snippet = "  ",
        Color = "  ",
        File = "  ",
        Reference = "  ",
        Folder = "  ",
        EnumMember = "  ",
        Constant = "  ",
        Struct = "  ",
        Event = "  ",
        Operator = "  ",
        TypeParameter = "  ",
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          expandable_indicator = true,
          fields = { "kind", "abbr", "menu" },
          format = function(_, vim_item)
            vim_item.menu = " " .. vim_item.kind
            vim_item.kind = (kind_icons[vim_item.kind] or " ")
            return vim_item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- Configuration for minuet-ai (located in ai-llm.lua)
          -- ["<C-Y>"] = require("minuet").make_cmp_map(),
        }),
        sources = cmp.config.sources({
          { name = "luasnip" }, -- For luasnip users.
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "calc" },
          -- { name = "lab.quick_data", keyword_length = 4 },
        }, {
          { name = "buffer" },
        }),
      })

      -- add CMP to searches
      -- cmp.setup.cmdline({ "/", "?" }, {
      --   sources = cmp.config.sources({
      --     { name = "nvim_lsp_document_symbol" },
      --   }, {
      --     { name = "buffer" },
      --   }),
      -- })
    end,
  },
}
