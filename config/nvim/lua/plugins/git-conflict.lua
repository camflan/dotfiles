return {
  {
    "akinsho/git-conflict.nvim",
    config = function()
      local git_conflict = require("git-conflict")

      git_conflict.setup({
          default_mappings = {
            ours = 'o',
            theirs = 't',
            none = '0',
            both = 'b',
            next = 'n',
            prev = 'p',
          },
        disable_diagnostics = true,
        highlights = {
          incoming = "DiffText",
          current = "DiffAdd",
        },
      })
    end,
  },
}
