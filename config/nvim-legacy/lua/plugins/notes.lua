return {
  {
    "letieu/jot.lua",
    keys = {
      {
        "<leader>oJ",
        "<cmd>lua require('jot').open()<CR>",
        mode = { "n" },
        remap = false,
        silent = true,
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
