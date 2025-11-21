return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      color_icons = true,
    },
  },
  -- https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {},
  },

  -- https://github.com/folke/noice.nvim
  {
    "folke/noice.nvim",
    cond = false,
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
      },
      routes = {
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
