return {
  {
    "3rd/time-tracker.nvim",
    dependencies = {
      "3rd/sqlite.nvim",
    },
    event = { "VeryLazy" },
    opts = {
      data_file = vim.fn.stdpath("data") .. "/time-tracker.db",
    },
  },

  -- https://github.com/ptdewey/pendulum-nvim
  {
    "ptdewey/pendulum-nvim",
    event = { "VeryLazy" },
    opts = {
      log_file = vim.fn.stdpath("data") .. "/pendulum-time-tracker.csv",
      report_excludes = {
        directory = {
          "dotfiles",
        },
        filetype = {
          "oil",
        },
      },
    },
    config = function(_, opts)
      require("pendulum").setup(opts)
    end,
  },
}
