return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    -- already have timeout set in init.lua
    -- init = function()
    --   vim.o.timeout = true
    --   vim.o.timeoutlen = 300
    -- end,
    opts = {
      operators = { gc = "Comments" },
    },
  },
}
