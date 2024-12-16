local utils = require("lib.utils")

local COMPLETION_ENGINE = "saghen/blink.cmp"
local is_cmp_enabled = utils.make_is_enabled_predicate(COMPLETION_ENGINE)

return {
  {
    "saghen/blink.cmp",
    -- cond = is_cmp_enabled,
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      "mikavilpas/blink-ripgrep.nvim",
    },

    -- use a release tag to download pre-built binaries
    version = "v0.*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = "default" },

      completion = {
        menu = {
          min_width = 25,
        },

        ghost_text = {
          enabled = false,
        },
      },

      signature = {
        enabled = true,
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        completion = {
          enabled_providers = {
            "lsp",
            "path",
            "snippets",
            "buffer",
            -- "ripgrep",
            -- "markdown"
          },
        },

        providers = {
          markdown = { name = "RenderMarkdown", module = "render-markdown.integ.blink" },

          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            -- the options below are optional, some default values are shown
            ---@module "blink-ripgrep"
            ---@type blink-ripgrep.Options
            opts = {
              -- For many options, see `rg --help` for an exact description of
              -- the values that ripgrep expects.

              -- the minimum length of the current word to start searching
              -- (if the word is shorter than this, the search will not start)
              prefix_min_len = 5,

              -- The number of lines to show around each match in the preview window
              context_size = 5,

              -- The maximum file size that ripgrep should include in its search.
              -- Useful when your project contains large files that might cause
              -- performance issues.
              -- Examples: "1024" (bytes by default), "200K", "1M", "1G"
              max_filesize = "1M",
            },
          },
        },
      },

      -- experimental auto-brackets support
      -- completion = { accept = { auto_brackets = { enabled = true } } }

      -- experimental signature help support
      -- signature = { enabled = true }
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.completion.enabled_providers" },
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
