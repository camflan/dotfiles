return {
  -- Sort structured text using treesitter nodes
  {
    "mtrajano/tssorter.nvim",
    version = "*", -- latest stable version, use `main` to keep up with the latest changes
    event = { "VeryLazy" },
    cond = false,
    ---@module "tssorter"
    ---@type TssorterOpts
    opts = {
      -- leave empty for the default config or define your own sortables in here. They will add, rather than
      -- replace, the defaults for the given filetype
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
    config = function()
      local ts_configs = require("nvim-treesitter.configs")
      ts_configs.setup({
        auto_install = true,
        sync_install = true,
        ignore_install = {},
        ensure_installed = {
          "astro",
          "c",
          "cmake",
          "cpp",
          "css",
          "diff",
          "dockerfile",
          "elm",
          "git_config",
          "git_rebase",
          "gitcommit",
          "gitignore",
          "go",
          "graphql",
          "hack",
          "haskell",
          "html",
          "htmldjango",
          "hurl",
          "java",
          "javascript",
          "jsdoc",
          "json",
          "json5",
          "jsonc",
          "kotlin",
          "latex",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "mermaid",
          "nix",
          "objc",
          "ocaml",
          "perl",
          -- "pkl",
          "php",
          "phpdoc",
          "prisma",
          "proto",
          "pymanifest",
          "python",
          "requirements",
          "rst",
          "ruby",
          "rust",
          "scala",
          "scss",
          "sql",
          "svelte",
          "swift",
          "terraform",
          "toml",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "xml",
          "yaml",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })

      -- from https://github.com/pwntester/octo.nvim#-installation
      vim.treesitter.language.register("markdown", "octo")

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevel = 10
      vim.opt.foldminlines = 3
    end,
  },
}
