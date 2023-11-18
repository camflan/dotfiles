-- https://github.com/j-hui/fidget.nvim
-- Used to show LSP Progress in lower right
return {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  config = true,
  opts = {
      notification = {
          override_vim_notify = true
      }
  }
}
