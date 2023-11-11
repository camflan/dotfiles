return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
    config = function()
      -- setup for comment.nvim + nvim-ts-context-commentstring
      -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
      local ts_configs = require("nvim-treesitter.configs")
      ts_configs.setup({
        auto_install = true,
        ensure_installed = {
          "c",
          "graphql",
          "git_config",
          "git_rebase",
          "gitcommit",
          "gitignore",
          "go",
          "hack",
          "haskell",
          "hurl",
          "diff",
          "dockerfile",
          "cmake",
          "cpp",
          "css",
          "elm",
          "python",
          "html",
          "htmldjango",
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
          "php",
          "phpdoc",
          "prisma",
          "proto",
          "pymanifest",
          "requirements",
          "rst",
          "ruby",
          "rust",
          "scala",
          "scss",
          "sql",
          "swift",
          "svelte",
          "terraform",
          "toml",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "xml",
          "yaml",
        },
        context_commentstring = {
          enable = true,
          -- Put custom comment definitions here for other filetypes or filetypes that don't work well.
          -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
        },
        highlight = {
          enable = true,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
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
