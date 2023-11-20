return {
  {
    "smoka7/hop.nvim",
    lazy = true,
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
    config = function()
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection

      hop.setup()

      vim.keymap.set("", "f", function()
        hop.hint_char1({ desc = "Hop f replacement", direction = directions.AFTER_CURSOR, current_line_only = true })
      end, { remap = true })
      vim.keymap.set("", "F", function()
        hop.hint_char1({ desc = "Hop F replacement", direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, { remap = true })
      vim.keymap.set("", "t", function()
        hop.hint_char1({
          desc = "Hop t replacement",
          direction = directions.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end, { remap = true })
      vim.keymap.set("", "T", function()
        hop.hint_char1({
          desc = "Hop T replacement",
          direction = directions.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1,
        })
      end, { remap = true })
    end,
  },
}
