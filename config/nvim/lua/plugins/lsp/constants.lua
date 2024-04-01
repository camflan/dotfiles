-- TODO: dedupe this with linters/formatters
return {
  debuggers = {},

  formatters_by_ft = {
    go = { "gofmt" },
    graphql = { "prettier" },
    javascript = { "prettier", "injected" },
    javascriptreact = { "prettier", "injected" },
    json = { "prettier" },
    jsonnet = { "jsonnetfmt" },
    lua = { "stylua" },
    html = { "prettier" },
    markdown = { "markdownlint", "injected" },
    python = { "isort", "black", "injected" },
    rust = { "rustfmt" },
    sql = { "pg_format" },
    terraform = { "terraform_fmt" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    yaml = { "yamlfix", "injected" },
    -- all files
    ["*"] = { "codespell" },
    -- files without any formatters available
    ["_"] = { "trim_whitespace" },
  },

  linters_by_ft = {},

  lsps = {
    -- "biome",
    "cssmodules_ls",
    "eslint",
    "flake8",
    "gopls",
    "graphql",
    "intelephense",
    "jsonls",
    "jsonnet_ls",
    "lua_ls",
    "prismals",
    "pyproject-flake8",
    "pyright",
    "rust_analyzer",
    "ruff",
    "ruff_lsp",
    "selene",
    "stylua",
    "svelte",
    "tailwindcss",
    "tsserver",
    "vim-language-server",
    "yaml-language-server",
  },

  do_not_install = {
    -- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
    "gofmt",
    "pg_format",
    "stylelint",
    "terraform_fmt",

    -- not real formatters, but pseudo-formatters from conform.nvim
    "trim_whitespace",
    "trim_newlines",
    "squeeze_blanks",
    "injected",
  },
}
