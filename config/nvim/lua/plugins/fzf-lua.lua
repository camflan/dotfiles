return {
  {
    "ibhagwan/fzf-lua",
    lazy = true,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>F",
        "<cmd>lua require('fzf-lua').builtin()<CR>",
        mode = { "n" },
        desc = "Open FzfLua",
        remap = false,
        silent = true,
      },
      {
        "<leader>f",
        "<cmd>lua require('fzf-lua').files()<CR>",
        mode = { "n" },
        desc = "Search files in cwd",
        remap = false,
        silent = true,
      },
      {
        "<leader>b",
        "<cmd>lua require('fzf-lua').buffers()<CR>",
        mode = { "n" },
        desc = "Search open buffers",
        remap = false,
        silent = true,
      },
      {
        "<leader>gh",
        "<cmd>lua require('fzf-lua').git_bcommits()<CR>",
        mode = { "n" },
        desc = "Git commit history for this file",
        remap = false,
        silent = true,
      },
      {
        "<leader>gc",
        "<cmd>lua require('fzf-lua').git_commits()<CR>",
        mode = { "n" },
        desc = "Git commit history",
        remap = false,
        silent = true,
      },
      {
        "<leader>gs",
        "<cmd>lua require('fzf-lua').git_status()<CR>",
        mode = { "n" },
        desc = "Git Status",
        remap = false,
        silent = true,
      },
      {
        "<leader>r",
        "<cmd>lua require('fzf-lua').live_grep_native()<CR>",
        mode = { "n" },
        desc = "Live Ripgrep search of cwd",
        remap = false,
        silent = true,
      },
      {
        "<leader>h",
        "<cmd>lua require('fzf-lua').help_tags()<CR>",
        mode = { "n" },
        remap = false,
        desc = "Search :help docs",
      },
      {
        "<leader>t",
        "<cmd>lua require('fzf-lua').lsp_finder()<CR>",
        mode = { "n" },
        remap = false,
        desc = "Find current symbol in workspace",
      },
      {
        "<leader>rs",
        "<cmd>lua require('fzf-lua').lsp_live_workspace_symbols()<CR>",
        mode = { "n" },
        remap = false,
        desc = "Live search LSP workspace symbols",
      },
      {
        "<leader>c",
        "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>",
        mode = { "n" },
        remap = false,
        desc = "Show LSP code actions for selection",
      },
    },
    config = function()
      local fzf = require("fzf-lua")
      local actions = require("fzf-lua.actions")

      fzf.setup({
        preview = {
          default = "bat",
        },
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
  },
}
