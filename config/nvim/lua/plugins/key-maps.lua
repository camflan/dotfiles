return {
  {
    "mrjones2014/smart-splits.nvim",
    opts = {
      at_edge = "stop",
      ignored_filetypes = { "NvimTree" },
    },
    config = function(_, opts)
      local smart_splits = require("smart-splits")

      smart_splits.setup(opts)

      -- recommended mappings
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
      vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
      vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
      vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
      -- moving between splits
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
      vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
      -- swapping buffers between windows
      vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
      vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
      vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
      vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
    end,
  },

  {
    "fedepujol/move.nvim",
    opts = {
      block = {
        enable = true,
        indent = true,
      },
      char = {
        enable = false,
      },
      line = {
        enable = false,
        indent = false,
      },
      word = {
        enable = false,
      },
    },
    config = function(_, opts)
      local m = require("move")
      m.setup(opts)

      local keymap_opts = { noremap = true, silent = true }
      vim.keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>", keymap_opts)
      vim.keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>", keymap_opts)
      vim.keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>", keymap_opts)
      vim.keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>", keymap_opts)
    end,
  },

  {
    "tris203/hawtkeys.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    enabled = false,
    config = {
      -- an empty table will work for default config
      --- if you use functions, or whichkey, or lazy to map keys
      --- then please see the API below for options
    },
  },
  {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    opts = {
      preset = "modern",
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.add({
        -- NORMAL mode keymaps
        {
          mode = { "n" },
          { "<leader>d", group = "Dev utils" },
          { "<leader>f", group = "FZF" },
          { "<leader>g", group = "git" },

          -- <leader>o prefixes keymaps that *o*pen panels/modals/tools/etc
          { "<leader>o", group = "open panels/modules" },
          {
            "<leader>oF",
            "<cmd>FzfLua<CR>",
            desc = "Open FzfLua",
          },
          {
            "<leader>oG",
            "<cmd>LazyGit<CR>",
            desc = "Open Lazygit",
          },
          {
            "<leader>od",
            "<cmd>DiffviewOpen<CR>",
            desc = "Open DiffView",
          },
          {
            "<leader>oL",
            "<cmd>Lazy<CR>",
            desc = "Open Lazy.nvim",
          },
          {
            "<leader>oM",
            "<cmd>Mason<CR>",
            desc = "Open Mason",
          },
          -- <leader>t prefixes keymaps that *t*oggle functionality
          { "<leader>t", group = "toggles" },
          {
            "<leader>tL",
            "<cmd>set list!<CR>",
            desc = "Toggle hidden chars (:set list!)",
          },
          {
            "<leader>tS",
            "<cmd>setlocal spell! spelllang=en_us<CR>",
            desc = "Toggle spelling",
          },
          {
            "<leader>tn",
            "<cmd>set number!<CR>",
            desc = "Toggle line numbers",
          },
          {
            "<leader>tr",
            "<cmd>set relativenumber!<CR>",
            desc = "Toggle relative line numbers",
          },
          {
            "<leader>tw",
            "<cmd>set nowrap!<CR>",
            desc = "Toggle line wrapping",
          },
        },
      })

      -- Octo.nvim
      wk.add({
        {
          mode = { "n" },
          { "<leader>O", group = "GitHub Octo" },
          { "<leader>Op", "<cmd>Octo pr list<CR>", desc = "List PRs" },
          {
            "<leader>Or",
            group = "+Review",
          },
          {
            "<leader>Ors",
            "<cmd>Octo review start<CR>",
            desc = "Start review",
          },
          {
            "<leader>Orc",
            "<cmd>Octo review submit<CR>",
            desc = "Submit review",
          },
          {
            "<leader>Orr",
            "<cmd>Octo review resume<CR>",
            desc = "Resume review",
          },
        },
      })
    end,
  },
}
