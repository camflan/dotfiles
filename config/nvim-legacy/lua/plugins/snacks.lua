return {
  -- https://github.com/folke/snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>ps",
        function()
          Snacks.profiler.scratch()
        end,
        desc = "Profiler Scratch Bufer",
      },
    },
    opts = function()
      -- Toggle the profiler
      Snacks.toggle.profiler():map("<leader>pp")
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map("<leader>ph")

      return {
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

        -- optional lualine component to show captured events
        -- when the profiler is running
        -- {
        --   "nvim-lualine/lualine.nvim",
        --   opts = function(_, opts)
        --     table.insert(opts.sections.lualine_x, Snacks.profiler.status())
        --   end,
        -- },
      }
    end,
  },
}
