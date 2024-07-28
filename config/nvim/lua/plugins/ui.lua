return {
  -- https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    enabled = true,
    lazy = true,
    opts = {},
  },

  -- https://github.com/folke/noice.nvim
  {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
