local lsps = {
  "biome",
  "elixirls",
  "eslint",
  "graphql",
  "jsonls",
  "lua_ls",
  "tailwindcss",
  "terraformls",
  "vtsls",
  "yamlls",
}

vim.lsp.config("*", {
  on_attach = function(_, bufnr)
    -- overwrites omnifunc/tagfunc set by some Python plugins to the
    -- default values for LSP
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
    vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })

    local keymap_opts = { buffer = bufnr, noremap = true, silent = true }

    vim.keymap.set(
      { "n", "x" },
      "<leader>da",
      '<cmd>lua require("fastaction").code_action()<CR>',
      { desc = "Display code actions", buffer = bufnr }
    )
    -- vim.keymap.set({ "n", "v" }, "<leader>da", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>i", "<Cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>j", "<cmd>lua vim.diagnostic.goto_next()<CR>", keymap_opts)
    vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.goto_prev()<CR>", keymap_opts)

    vim.diagnostic.config({ virtual_text = true })

    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    --     vim.lsp.diagnostic.on_publish_diagnostics, {
    --         signs = true,
    --         underline = true,
    --         virtual_text = true
    --     }
    -- )
  end,
})

return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "b0o/schemastore.nvim",
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    opts = {
      automatic_enable = true,
      ensure_installed = lsps,
    },
  },

  {
    "Chaitanyabsprip/fastaction.nvim",
    lazy = true,
    ---@type FastActionConfig
    opts = {},
  },

  {
    "folke/lazydev.nvim",
    dependencies = {
      "justinsgithub/wezterm-types",
    },
    ft = "lua",
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },

        -- Plugins
        { "nvim-dap-ui" },
        -- Load the wezterm types when the `wezterm` module is required
        -- Needs `justinsgithub/wezterm-types` to be installed
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },

  -- eslint rule lookup
  {
    "chrisgrieser/nvim-rulebook",
    config = true,
    keys = {
      {
        "<leader>dri",
        function()
          require("rulebook").ignoreRule()
        end,
        desc = "Ignore rule",
      },
      {
        "<leader>drl",
        function()
          require("rulebook").lookupRule()
        end,
        desc = "Lookup rule",
      },
    },
  },

  {
    "marilari88/twoslash-queries.nvim",
    lazy = true,
  },

  {
    "williamboman/mason.nvim",
    lazy = true,
    config = true,
    cmd = { "Mason", "MasonInstall", "MasonToolsInstall" },
  },

  {
    "neovim/nvim-lspconfig",
    lazy = true,
  },
}
