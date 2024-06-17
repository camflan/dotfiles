return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
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
