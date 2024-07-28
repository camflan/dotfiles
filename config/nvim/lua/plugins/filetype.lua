return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "md", "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  {
    "https://github.com/apple/pkl-neovim.git",
    ft = { "pkl" },
  },

  {
    "prisma/vim-prisma",
    ft = { "prisma" },
    lazy = true,
    config = function() end,
  },

  {
    "Duologic/nvim-jsonnet",
    ft = { "jsonnet" },
  },
}
