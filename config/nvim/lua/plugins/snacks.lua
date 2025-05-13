return {
  -- https://github.com/folke/snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      indent = {
        enabled = true,

        animate = {
          enabled = false,
        },

        chunks = {
          enabled = true,
        },

        indent = {
          enabled = true,
          only_current = true,
        },

        scope = {
          enabled = true,
        },
      },
      input = {
        enabled = true,
        keys = {
          n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
          i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true },
          i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
          i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
          i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
          i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
          i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
          q = "cancel",
        },
      },
      notifier = {
        enabled = true,
      },
    },
  },
}
