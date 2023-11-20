return {
  {
    "folke/trouble.nvim",
    lazy = true,
    keys = {
      {
        "<leader>T",
        ":TroubleToggle<CR>",
        mode = { "n" },
        remap = false,
        silent = true,
      },
    },
    opts = {
      position = "bottom",
      icons = false,
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
