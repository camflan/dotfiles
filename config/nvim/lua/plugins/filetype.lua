return {
  -- hurl: api request files
  {
    "ethancarlsson/nvim-hurl.nvim",
    enabled = false,
    ft = { "hurl" },
  },
  {
    "iamcco/markdown-preview.nvim",
    enabled = true,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "md", "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "prisma/vim-prisma",
    ft = { "prisma" },
    opts = {},
  },
}
