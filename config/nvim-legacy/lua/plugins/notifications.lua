return {
  -- LSP status/notifications
  {
    "j-hui/fidget.nvim",
    cond = true,
    event = { "VeryLazy" },
    config = true,
    opts = {},
  },

  {
    "rcarriga/nvim-notify",
    cond = false,
    event = { "VeryLazy" },
    config = function()
      local notify = require("notify")

      notify.setup({
        render = "wrapped-compact",
        stages = "slide",
      })

      vim.notify = function(message, level, opts)
        return notify(message, level, opts)
      end
    end,
  },
}
