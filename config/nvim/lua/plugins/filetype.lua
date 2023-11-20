return {
  -- hurl: api request files
  {
    "ethancarlsson/nvim-hurl.nvim",
    enabled = false,
    ft = "hurl",
    lazy = true,
  },
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "prisma/vim-prisma",
    ft = "prisma",
    lazy = true,
    opts = {},
  },
}
