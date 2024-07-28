return {
  {
    "smoka7/hop.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>l",
        ":HopLineStart<CR>",
        mode = { "n" },
        desc = "Jump directly to start of line",
        remap = true,
        silent = true,
      },
      {
        "<leader>w",
        ":HopWord<CR>",
        mode = { "n" },
        desc = "Jump directly to word",
        remap = true,
        silent = true,
      },
      {
        "<leader>W",
        ":HopWordMW<CR>",
        mode = { "n" },
        desc = "Jump directly to word across all buffers",
        remap = true,
        silent = true,
      },
    },
    opts = {},
  },
}
