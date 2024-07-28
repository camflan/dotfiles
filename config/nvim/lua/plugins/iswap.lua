return {
  {
    "mizlan/iswap.nvim",
    keys = {
      { "<Leader>s", ":ISwap<CR>", desc = "ISwap arguments" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local iswap = require("iswap")
      iswap.setup()
    end,
  },
}
