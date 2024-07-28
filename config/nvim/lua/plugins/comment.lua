return {
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    enabled = vim.fn.has("nvim-0.10.0") ~= 1,
    name = "context-commentstring",
    lazy = true,
  },

  -- Quickly insert debug print/console.log/etc statements
  {
    "PatschD/zippy.nvim",
    lazy = true,
    event = { "LspAttach" },
    keys = {
      { "<leader>dl", ':lua require("zippy").insert_print()<CR>', desc = "Insert debug log" },
    },
    opts = {},
  },
}
