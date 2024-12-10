vim.filetype.add({
  filename = {
    extension = {
      tf = "terraform",
      tfvars = "terraform",
    },
    ["package.json"] = function()
      return "json", function()
        vim.cmd("PackageInfoShow")
      end
    end,
  },
})

return {
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
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
    "camflan/markdown-preview.nvim",
    enabled = false,
    name = "Markdown preview",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "md", "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  {
    -- "iamcco/markdown-preview.nvim",
    dir = "/Users/camron/src/github.com/camflan/markdown-preview.nvim",
    enabled = false,
    name = "Markdown Preview",
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
    config = function() end,
  },

  {
    "Duologic/nvim-jsonnet",
    ft = { "jsonnet" },
  },
}
