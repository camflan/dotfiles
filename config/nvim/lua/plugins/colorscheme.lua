local utils = require("lib.utils")

local COLORSCHEME = "catppuccin"
local COLORSCHEME_FLAVOR = {
  catppuccin = "latte",
  zenbones = "nordbones", -- "zenbones",
}

local is_colorscheme_active = utils.make_is_enabled_predicate(COLORSCHEME)

return {
  {
    "f-person/auto-dark-mode.nvim",
    cond = false,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
        vim.cmd("colorscheme tokyonight")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
        vim.cmd("colorscheme solarized-flat")
      end,
    },
  },

  {
    "ishan9299/nvim-solarized-lua",
    name = "solarized",
    cond = is_colorscheme_active,
    lazy = true,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme solarized")
    end,
  },

  -- https://github.com/comfysage/evergarden
  {
    "comfysage/evergarden",
    cond = is_colorscheme_active,
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    opts = {
      transparent_background = true,
      contrast_dark = "medium", -- 'hard'|'medium'|'soft'
      override_terminal = true,
      style = {
        -- tabline = { reverse = true, color = "green" },
        -- search = { reverse = false, inc_reverse = true },
        types = { italic = true },
        keyword = { italic = true },
        comment = { italic = false },
        -- sign = { highlight = false },
      },
      overrides = {}, -- add custom overrides
    },
  },

  {
    "vague2k/vague.nvim",
    cond = is_colorscheme_active,
    lazy = false,
    name = "vague",
    priority = 1000,
    -- opts = {},
    config = function(_, opts)
      require("vague").setup(opts)
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    cond = is_colorscheme_active,
    priority = 1000, -- load as soon as possible
    config = function()
      vim.cmd("colorscheme nightfox")
    end,
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    cond = is_colorscheme_active,
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
      light_style = "day",
      transparent = false,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    "nyoom-engineering/oxocarbon.nvim",
    cond = is_colorscheme_active,
    priority = 1000, -- load as soon as possible
    -- Add in any other configuration;
    --   event = foo,
    --   config = bar
    --   end,
    config = function()
      vim.cmd("colorscheme oxocarbon")
    end,
  },

  {
    "shaunsingh/nord.nvim",
    cond = is_colorscheme_active,
    priority = 1000, -- load as soon as possible
    config = function()
      vim.cmd("colorscheme nord")
    end,
  },

  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    cond = is_colorscheme_active,
    priority = 1000,
    config = function()
      require("nordic").load()
      vim.cmd("colorscheme nordic")
    end,
  },

  {
    "0xstepit/flow.nvim",
    lazy = false,
    cond = is_colorscheme_active,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("flow").setup(opts)
      vim.cmd("colorscheme flow")
    end,
  },

  -- github
  {
    "projekt0n/github-nvim-theme",
    cond = is_colorscheme_active,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {},
    config = function(_, opts)
      require("github-theme").setup(opts)
      vim.cmd("colorscheme github_dark")
    end,
  },

  {
    "marko-cerovac/material.nvim",
    cond = is_colorscheme_active,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("material").setup(opts)
      vim.cmd("colorscheme material")
    end,
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    cond = is_colorscheme_active,
    name = "catppuccin",
    priority = 1000, -- load as soon as possible
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local catppuccin = require("catppuccin")
      vim.g.catppuccin_flavour = COLORSCHEME_FLAVOR.catppuccin

      catppuccin.setup({
        flavour = COLORSCHEME_FLAVOR.catppuccin,
        integrations = {
          cmp = true,
          dadbod_ui = true,
          diffview = true,
          fidget = true,
          flash = true,
          fzf = true,
          gitsigns = true,
          hop = true,
          indent_blankline = {
            enabled = true,
          },
          lsp_trouble = true,
          mason = true,
          native_lsp = {
            enabled = true,
          },
          notify = true,
          treesitter = true,
          which_key = true,
        },
      })

      vim.cmd([[colorscheme catppuccin]])
    end,
  },

  {
    "Mofiqul/dracula.nvim",
    cond = is_colorscheme_active,
    opts = {
      italic_comment = true,
    },
    config = function(_, opts)
      local dracula = require("dracula")
      dracula.setup(opts)

      vim.cmd([[colorscheme dracula]])
    end,
  },

  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = { "rktjmp/lush.nvim" },
    cond = is_colorscheme_active,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme(COLORSCHEME_FLAVOR.zenbones)
    end,
  },

  {
    "olivercederborg/poimandres.nvim",
    cond = is_colorscheme_active,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("poimandres").setup(opts)
    end,
    init = function()
      vim.cmd("colorscheme poimandres")
    end,
  },

  {
    "sainnhe/sonokai",
    cond = is_colorscheme_active,
  },

  {
    "altercation/vim-colors-solarized",
    lazy = true,
  },

  {
    "srcery-colors/srcery-vim",
    lazy = true,
  },
  { "tjammer/blayu.vim", lazy = true },
  { "tomasr/molokai", lazy = true },
  { "mhartington/oceanic-next", lazy = true },
  { "marciomazza/vim-brogrammer-theme", lazy = true },
  { "haishanh/night-owl.vim", lazy = true },
  { "sts10/vim-pink-moon", lazy = true },
  { "fenetikm/falcon", lazy = true },
  { "phanviet/vim-monokai-pro", lazy = true },
  { "andreypopp/vim-colors-plain", lazy = true },
  { "cocopon/iceberg.vim", lazy = true },
  { "pineapplegiant/spaceduck", lazy = true },
}
