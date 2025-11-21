return {
  {
    "folke/trouble.nvim",
    event = { "VeryLazy" },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble toggle diagnostics<CR>",
        desc = "Diagnostics (Trouble)",
        mode = { "n" },
        remap = false,
        silent = true,
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
        mode = { "n" },
        remap = false,
        silent = true,
      },
      {
        "<leader>ds",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
        mode = { "n" },
        remap = false,
        silent = true,
      },
      {
        "<leader>dd",
        "<cmd>Trouble lsp toggle focus=false win.size.width=50 win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
        mode = { "n" },
        remap = false,
        silent = true,
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
        mode = { "n" },
        remap = false,
        silent = true,
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
        mode = { "n" },
        remap = false,
        silent = true,
      },
      {
        "<leader>xt",
        "<cmd>Trouble todo<cr>",
        desc = "Project TODOs (Trouble)",
        mode = { "n" },
        remap = false,
        silent = true,
      },
    },
    opts = {
      position = "bottom",
      -- icons = false,
      fold_open = "v", -- icon used for open folds
      fold_closed = ">", -- icon used for closed folds
      indent_lines = false, -- add an indent guide below the fold icons
      signs = {
        -- icons / text used for a diagnostic
        error = "error",
        warning = "warn",
        hint = "hint",
        information = "info",
      },
      use_diagnostic_signs = false,
    },
  },
}
