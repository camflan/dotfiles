local table_utils = require("lib.table")

local USE_TSGO = false

local global_lsps_to_install = {
  "elixirls",
  "eslint",
  "graphql",
  "jsonls",
  "lua_ls",
  "tailwindcss",
  "terraformls",
  "yamlls",
}

local project_local_lsps = {
  "biome",
  "gopls",
  "pyrefly",
  "ty",
}

if USE_TSGO then
  table.insert(project_local_lsps, "tsgo")
else
  table.insert(global_lsps_to_install, "vtsls")
end

local lsps = table_utils.concat(global_lsps_to_install, project_local_lsps, true)

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
    vim.keymap.set("n", "<leader>u", "<cmd>lua vim.diagnostic.open_float()<CR>", keymap_opts)

    vim.diagnostic.config({
      float = {
        severity_sort = true,
        source = "if_many",
      },
      severity_sort = true,
      virtual_text = false,
    })

    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    --     vim.lsp.diagnostic.on_publish_diagnostics, {
    --         signs = true,
    --         underline = true,
    --         virtual_text = true
    --     }
    -- )
  end,
})

vim.lsp.enable(lsps)

return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "b0o/schemastore.nvim",
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    opts = {
      automatic_enable = lsps,
      ensure_installed = global_lsps_to_install,
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" }, -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "powerline",

        options = {
          multilines = {
            enabled = true,
            always_show = true,
            trim_whitespaces = true,
          },
          show_source = {
            enabled = true,
            if_many = true,
          },
        },
      })
      vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end,
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

  -- Workspace-wide TSC
  {
    "dmmulroy/tsc.nvim",
    keys = {
      {
        "<leader>dT",
        "<cmd>TSC<CR>",
        desc = "Run TSC on entire workspace",
      },
    },
    opts = {
      auto_start_watch_mode = true,
    },
    cmd = { "TSC" },
  },
}
