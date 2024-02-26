return {
  {
    "rebelot/heirline.nvim",
    dependencies = {
      "Zeioth/heirline-components.nvim",
      "lewis6991/gitsigns.nvim",
    },
    event = { "UiEnter" },
    config = function()
      local heirline = require("heirline")
      local lib = require("heirline-components.all")

      -- Setup
      lib.init.subscribe_to_events()
      heirline.load_colors(lib.hl.get_colors())

      local statusline = {
        lib.component.mode({ mode_text = {}, pad_text = "center" }),
        lib.component.file_info({
          file_icon = {},
          file_modified = {},
          file_read_only = {},
          filename = {},
        }),
        lib.component.fill(),
        lib.component.treesitter({
          separator = "left",
          str = { str = " ", icon = { kind = "ActiveTS", padding = { left = 1 } } },
        }),
      }

      local example = {
        hl = { fg = "fg", bg = "bg" },
        lib.component.git_branch(),
        lib.component.file_info({
          file_icon = {},
          file_modified = {},
          file_read_only = {},
          filename = {},
          filetype = false,
        }),

        lib.component.fill(),

        lib.component.diagnostics(),
        lib.component.cmd_info(),
        lib.component.nav({
          percentage = {},
          scrollbar = false,
        }),
        lib.component.mode({ mode_text = {}, pad_text = "left" }),
      }

      heirline.setup({
        statusline = example,
        -- winbar = {...},
        -- tabline = {...},
        -- statuscolumn = {...},
      })
    end,
  },
}
