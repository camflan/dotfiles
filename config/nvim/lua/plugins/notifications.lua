return {
  -- LSP status/notifications
  {
    "j-hui/fidget.nvim",
    lazy = true,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    enabled = false,
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
