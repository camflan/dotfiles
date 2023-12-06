return {
  -- LSP status/notifications
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        override_vim_notify = false,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
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
