local COLORSCHEME = "nord"

return {
  {
    "f-person/auto-dark-mode.nvim",
    enabled = false,
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
    enabled = COLORSCHEME == "solarized",
    lazy = true,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme solarized")
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    enabled = COLORSCHEME == "nightfox",
    priority = 1000, -- load as soon as possible
    config = function()
      vim.cmd("colorscheme nightfox")
    end,
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    enabled = COLORSCHEME == "tokyonight",
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
    enabled = COLORSCHEME == "oxocarbon",
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
    enabled = COLORSCHEME == "nord",
    priority = 1000, -- load as soon as possible
    config = function()
      vim.cmd("colorscheme nord")
    end,
  },

  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    enabled = COLORSCHEME == "nordic",
    priority = 1000,
    config = function()
      require("nordic").load()
      vim.cmd("colorscheme nordic")
    end,
  },

  {
    "0xstepit/flow.nvim",
    lazy = false,
    enabled = COLORSCHEME == "flow",
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
    enabled = COLORSCHEME == "github-nvim",
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
    enabled = COLORSCHEME == "material",
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
    enabled = COLORSCHEME == "catppuccin",
    name = "catppuccin",
    priority = 1000, -- load as soon as possible
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local catppuccin = require("catppuccin")
      vim.g.catppuccin_flavour = "macchiato"

      catppuccin.setup({
        flavour = "macchiato",
        integrations = {
          hop = true,
          native_lsp = {
            enabled = true,
          },
          treesitter = true,
          lsp_trouble = true,
        },
      })

      vim.cmd([[colorscheme catppuccin]])
    end,
  },

  {
    "sainnhe/sonokai",
    enabled = COLORSCHEME == "sonokai",
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
  { "dracula/vim", name = "dracula", lazy = true },
  { "pineapplegiant/spaceduck", lazy = true },
}
