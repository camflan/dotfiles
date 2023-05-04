return {
  "ibhagwan/fzf-lua",
  config = function()
    local fzf = require("fzf-lua")
    local actions = require("fzf-lua.actions")

    fzf.setup({
      actions = {
        files = {
          -- providers that inherit these actions:
          --   files, git_files, git_status, grep, lsp
          --   oldfiles, quickfix, loclist, tags, btags
          --   args
          -- default action opens a single selection
          -- or sends multiple selection to quickfix
          -- replace the default action with the below
          -- to open all files whether single or multiple
          -- ["default"]     = actions.file_edit,
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-s"] = actions.file_split,
          ["ctrl-v"] = actions.file_vsplit,
          ["ctrl-t"] = actions.file_tabedit,
          ["ctrl-q"] = actions.file_sel_to_qf,
          ["ctrl-l"] = actions.file_sel_to_ll,
        },
      },
    })
  end,
}
