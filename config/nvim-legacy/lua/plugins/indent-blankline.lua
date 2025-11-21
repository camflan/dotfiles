return {
  {
    "lukas-reineke/indent-blankline.nvim",

    cond = false,

    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },

    main = "ibl",

    opts = {
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    },
  },
}
