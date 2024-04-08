return {
  {
    "letieu/jot.lua",
    keys = {
      {
        "<leader>J",
        "<cmd>lua require('jot').open()<CR>",
        mode = { "n" },
        remap = false,
        silent = true,
      },
    },
    event = { "VeryLazy" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
