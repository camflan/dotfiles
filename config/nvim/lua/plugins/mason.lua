return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    lazy = false,
    config = function()
      require("mason").setup()

      local mason_lsp = require("mason-lspconfig")
      mason_lsp.setup({
        ensure_installed = {
          "cssmodules_ls",
          "eslint",
          "graphql",
          "intelephense",
          "lua_ls",
          "pyright",
          "rome",
          "ruff_lsp",
          "svelte",
          "tailwindcss",
          "tsserver",
        },
        automatic_installation = false,
      })

      require("mason-tool-installer").setup({
        -- a list of all tools you want to ensure are installed upon
        -- start; they should be the names Mason uses for each tool
        ensure_installed = {
          "cspell",
          "editorconfig-checker",
          "flake8",
          "pyproject-flake8",
          "rome",
          "ruff",
          "ruff-lsp",
          "selene",
          "stylua",
          "vim-language-server",
        },
        -- automatically install / update on startup. If set to false nothing
        -- will happen on startup. You can use :MasonToolsInstall or
        -- :MasonToolsUpdate to install tools and check for updates.
        -- Default: true
        run_on_start = true,
        -- set a delay (in ms) before the installation starts. This is only
        -- effective if run_on_start is set to true.
        -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
        -- Default: 0
        start_delay = 3000, -- 3 second delay
      })
    end,
  },
}
