local utils = require("lib.utils")

local COLORSCHEME = "tokyonight"
local COLORSCHEME_FLAVOR = {
  catppuccin = "macchiato",
  github = "github_light",
  onedark = "dark", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  nightfox = "nightfox", -- "nightfox", "dayfox", "dawnfox", "duskfox", "nordfox", "terafox", "carbonfox"
  tokyonight = "moon", -- "moon", "storm", "night", and "day"
  zenbones = "nordbones", -- "zenbones",
}

local is_colorscheme_active = utils.make_is_enabled_predicate(COLORSCHEME)

return {
  {
    "ishan9299/nvim-solarized-lua",
    name = "solarized",
    cond = is_colorscheme_active,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme solarized")
    end,
  },

  -- https://github.com/sainnhe/everforest/blob/master/doc/everforest.txt
  {
    "sainnhe/everforest",
    cond = is_colorscheme_active,
    lazy = false,
    priority = 1000,
    config = function()
      -- directly inside the plugin declaration.
      vim.g.everforest_better_performance = true
      vim.g.everforest_enable_italic = true
      vim.cmd.colorscheme("everforest")
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
      vim.cmd("colorscheme " .. COLORSCHEME_FLAVOR["nightfox"])
    end,
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    cond = is_colorscheme_active,
    lazy = false,
    priority = 1000,
    ---@module "tokyonight"
    ---@type tokyonight.Config
    opts = {
      light_style = "day",
      style = COLORSCHEME_FLAVOR["tokyonight"],
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
    name = "github",
    cond = is_colorscheme_active,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {},
    config = function(_, opts)
      require("github-theme").setup(opts)
      vim.cmd("colorscheme " .. COLORSCHEME_FLAVOR.github)
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
    name = "dracula",
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

  -- Using Lazy
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    cond = is_colorscheme_active,
    config = function()
      require("onedark").setup({
        style = COLORSCHEME_FLAVOR["onedark"],
      })
      -- Enable theme
      require("onedark").load()
    end,
  },

  -- lua/plugins/rose-pine.lua
  {
    "rose-pine/neovim",
    name = "rose-pine",
    cond = is_colorscheme_active,
    lazy = false,
    priority = 1000,
    opts = {
      variant = "auto",
      dark_variant = "main",
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd("colorscheme rose-pine")
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    cond = is_colorscheme_active,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd("colorscheme kanagawa")
    end,
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
