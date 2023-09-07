-- https://github.com/j-hui/fidget.nvim
-- Used to show LSP Progress in lower right
return {
  "j-hui/fidget.nvim",
  tag = "legacy", -- used temporarily while fidget is rewritten
  event = "LspAttach",
  config = function()
    local f = require("fidget")
    f.setup({
      text = {
        spinner = "dots",
      },
    })
  end,
}
