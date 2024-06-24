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
        "<leader>q",
        "<cmd>lua require('fzf-lua').resume()<CR>",
        mode = { "n" },
        desc = "Resume last Fzf session",
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
        "<cmd>lua require('fzf-lua').live_grep()<CR>",
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
        fzf_colors = true,
        fzf_opts = {
          -- saves to ~/.local/share/nvim/fzf-lua-history
          ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
        },
        actions = {
          buffers = {
            -- providers that inherit these actions:
            --   buffers, tabs, lines, blines
            ["default"] = actions.buf_switch_or_edit,
            ["ctrl-o"] = actions.buf_edit,
            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
          files = {
            -- providers that inherit these actions:
            --   files, git_files, git_status, grep, lsp oldfiles, quickfix, loclist, tags, btags args
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-l"] = actions.file_sel_to_ll,
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-t"] = actions.file_tabedit,
            ["ctrl-v"] = actions.file_vsplit,
          },
        },
        files = {
          fd_opts = [[--type f --hidden --follow --exclude .git --exclude node_modules]],
          color_icons = false,
          file_icons = false,
          git_icons = false,
        },
        grep = {
          debug = false,
          color_icons = false,
          file_icons = false,
          git_icons = false,
          fzf_opts = { ["--nth"] = "2.." },
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
          -- allow modifying file glob by passing `--file/glob/**/*` to a query
          rg_glob = true,
          actions = {
            ["ctrl-r"] = { actions.toggle_ignore },
          },
        },
        keymap = {
          builtin = {
            ["<F1>"] = "toggle-help",
          },
          fzf = {
            ["alt-a"] = "toggle-all",
            ["ctrl-q"] = "select-all+accept",
            ["ctrl-y"] = "toggle-preview",
            ["ctrl-z"] = "abort",
          },
        },
        previewers = {
          bat = {
            cmd = "bat",
          },
        },
        winopts = {
          preview = {
            default = "bat",
            wrap = "nowrap",
          },
        },
      })
    end,
  },
}
