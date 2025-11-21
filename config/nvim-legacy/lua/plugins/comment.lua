return {
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    cond = vim.fn.has("nvim-0.10.0") == 1,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    cond = vim.fn.has("nvim-0.10.0") ~= 1,
    name = "context-commentstring",
    lazy = true,
  },

  { "LudoPinelli/comment-box.nvim", event = { "VeryLazy" }, opts = {} },

  -- Quickly insert debug print/console.log/etc statements
  {
    "PatschD/zippy.nvim",
    event = { "LspAttach" },
    keys = {
      { "<leader>dl", ':lua require("zippy").insert_print()<CR>', desc = "Insert debug log" },
    },
    opts = {},
  },
}
