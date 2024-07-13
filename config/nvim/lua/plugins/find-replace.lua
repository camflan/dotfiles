return {
  {
    "backdround/improved-search.nvim",
    event = { "VeryLazy" },
    opts = {},
    config = function()
      local search = require("improved-search")

      -- Search next / previous.
      vim.keymap.set({ "n", "x", "o" }, "n", search.stable_next)
      vim.keymap.set({ "n", "x", "o" }, "N", search.stable_previous)

      -- Search current word without moving.
      vim.keymap.set("n", "!", search.current_word)

      -- Search selected text in visual mode
      vim.keymap.set("x", "!", search.in_place) -- search selection without moving
      vim.keymap.set("x", "*", search.forward) -- search selection forward
      vim.keymap.set("x", "#", search.backward) -- search selection backward

      -- Search by motion in place
      vim.keymap.set("n", "|", search.in_place)
    end,
  },
  {
    "ray-x/sad.nvim",
    cmd = { "Sad" },
    dependencies = {
      { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
    },
    opts = {
      debug = false, -- print debug info
      diff = "delta", -- you can use `less`, `diff-so-fancy`
      ls_file = "fd", -- also git ls-files
      exact = false, -- exact match
      vsplit = false, -- split sad window the screen vertically, when set to number
      -- it is a threadhold when window is larger than the threshold sad will split vertically,
      height_ratio = 0.6, -- height ratio of sad window when split horizontally
      width_ratio = 0.6, -- height ratio of sad window when split vertically
    },
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>oS", ":Spectre<CR>", desc = "Spectre find/replace", mode = { "n" }, remap = false, silent = true },
    },
    opts = {},
  },
}
