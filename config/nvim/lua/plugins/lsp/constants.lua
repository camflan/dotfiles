-- TODO: dedupe this with linters/formatters

local flags = {
  USE_BIOME = false,
  USE_CSS_MODULES_LS = false,
  USE_ESLINT_FIX_ON_SAVE = true,
  USE_HARPER = true,
  USE_PYLYZER = true,
  USE_PYRIGHT = true,
  USE_RUFF = false,
  -- Try new inline diags plugin
  USE_TINY_INLINE_DIAGNOSTIC = false,
  -- try new tsserver plugin
  USE_TYPESCRIPT_TOOLS_INSTEAD_OF_TSSERVER = true,
  USE_TAILWIND_LS = true,
}

local lsps = {
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
  "rust_analyzer",
  "ruff",
  "selene",
  "stylua",
  "svelte",
  "tailwindcss",
  "vim-language-server",
  "yaml-language-server",
}

if flags.USE_BIOME then
  table.insert(lsps, "biome")
end

if flags.USE_HARPER then
  -- grammar lsp https://github.com/elijah-potter/harper
  table.insert(lsps, "harper-ls")
end

if flags.USE_PYLYZER then
  table.insert(lsps, "pylyzer")
end

if flags.USE_PYRIGHT then
  table.insert(lsps, "pyright")
end

if flags.USE_RUFF then
  table.insert(lsps, "ruff")
end

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
    ["*"] = {
      -- Using Harper-ls for now
      --     "codespell"
      "trim_whitespace",
    },
    -- files without any formatters available
    ["_"] = { "trim_whitespace" },
  },

  linters_by_ft = {},

  lsps = lsps,

  do_not_install = {
    -- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
    "gofmt",
    "pg_format",
    "rustfmt",
    "stylelint",
    "terraform_fmt",

    -- not real formatters, but pseudo-formatters from conform.nvim
    "trim_whitespace",
    "trim_newlines",
    "squeeze_blanks",
    "injected",
  },
}
