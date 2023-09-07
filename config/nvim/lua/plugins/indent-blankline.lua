return {
  {
    "lukas-reineke/indent-blankline.nvim",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },

    opts = {
      show_current_context = true,
      show_current_context_start = true,
      show_first_indent_level = true,
      -- use_treesitter = true,
      -- use_treesitter_scope  = true,
    }
  },
}
