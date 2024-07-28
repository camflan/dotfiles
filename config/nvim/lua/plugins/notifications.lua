return {
  -- LSP status/notifications
  {
    "j-hui/fidget.nvim",
    enabled = true,
    event = { "VeryLazy" },
  },

  {
    "rcarriga/nvim-notify",
    enabled = true,
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
