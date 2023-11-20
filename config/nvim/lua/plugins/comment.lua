return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    name = "context-commentstring",
    lazy = true,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "context-commentstring",
    },
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = "gc",
        ---Block-comment toggle keymap
        block = "gb",
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = "gc",
        ---Block-comment keymap
        block = "gb",
      },
      ---LHS of extra mappings
      extra = {
        ---Add comment on the line above
        above = "gcO",
        ---Add comment on the line below
        below = "gco",
        ---Add comment at the end of line
        eol = "gcA",
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
      pre_hook = function()
        -- defined by context-commentstring above
        return vim.bo.commentstring
      end,
    },
  },
}
