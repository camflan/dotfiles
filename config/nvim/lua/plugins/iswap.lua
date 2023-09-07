return {
  {
    "mizlan/iswap.nvim",

    cmd = { "ISwap", "ISwapWith" },
    lazy = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },

    config = function ()
      local iswap = require('iswap')
      iswap.setup()
    end
  },
}
