return {
  {
    "akinsho/git-conflict.nvim",
    config = function()
      local git_conflict = require("git-conflict")

      git_conflict.setup({
        disable_diagnostics = true,
        highlights = {
          incoming = "DiffText",
          current = "DiffAdd",
        },
      })
    end,
  },
}
