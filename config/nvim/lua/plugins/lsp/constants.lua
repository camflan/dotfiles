-- TODO: dedupe this with linters/formatters

local flags = {
  USE_CSS_MODULES_LS = false,
  USE_ESLINT_FIX_ON_SAVE = true,
  -- Try new inline diags plugin
  USE_TINY_INLINE_DIAGNOSTIC = false,
  -- try new tsserver plugin
  USE_TYPESCRIPT_TOOLS_INSTEAD_OF_TSSERVER = true,
  USE_TAILWIND_LS = true,
}

local lsps = {
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
  "vim-language-server",
  "yaml-language-server",
}

if not flags.USE_TYPESCRIPT_TOOLS_INSTEAD_OF_TSSERVER then
  -- renamed tsserver to ts_ls
  table.insert(lsps, "ts_ls")
end

return {
  debuggers = {},

  -- TOGGLES FOR LSP FUNCTIONALITY / PLUGIN STATUS
  flags = flags,

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

  lsps = lsps,

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
