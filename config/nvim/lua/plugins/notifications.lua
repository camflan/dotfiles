return {
  -- LSP status/notifications
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
      notification = {
        override_vim_notify = false,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    enabled = true,
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
