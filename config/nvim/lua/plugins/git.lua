return {
  -- Nicer 3-way merge handling
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
    keys = {
      {
        "<leader>od",
        "<cmd>DiffviewOpen<CR>",
        desc = "Open DiffView",
      },
    },
    ---@module "diffview"
    ---@type DiffviewConfig
    opts = {
      enhanced_diff_hl = true,
    },
  },

  -- Nice diff/conflict highlights
  -- also disables LSP in those buffers
  {
    "akinsho/git-conflict.nvim",
    event = { "VeryLazy" },
    opts = {
      disable_diagnostics = true,
      highlights = {
        incoming = "DiffText",
        current = "DiffAdd",
      },
    },
  },

  {
    -- git integration
    "tpope/vim-fugitive",
    dependencies = {
      -- github extension for fugitive
      "tpope/vim-rhubarb",
    },
    cmd = { "G" },
  },

  {
    "lewis6991/gitsigns.nvim",
    cmd = { "Gitsigns" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
  },

  -- NEOGIT
  {
    "NeogitOrg/neogit",
    keys = {
      {
        "<leader>oG",
        "<cmd>Neogit<CR>",
        desc = "Open Neogit",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
  },

  {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      picker = "fzf-lua",
    },
    config = function(_, opts)
      require("octo").setup(opts)
    end,
  },
}
