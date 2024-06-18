return {
  {
    "f-person/auto-dark-mode.nvim",
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
    lazy = true,
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
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

  -- github
  {
    "projekt0n/github-nvim-theme",
    enabled = false,
    lazy = true, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {},
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
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
    lazy = true,
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
