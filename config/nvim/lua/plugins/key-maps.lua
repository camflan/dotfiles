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
    config = {
      -- an empty table will work for default config
      --- if you use functions, or whichkey, or lazy to map keys
      --- then please see the API below for options
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    -- already have timeout set in init.lua
    -- init = function()
    --   vim.o.timeout = true
    --   vim.o.timeoutlen = 300
    -- end,
    opts = {
      operators = { gc = "Comments" },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.register({
        -- <leader>o prefixes keymaps that *o*pen panels/modals/tools/etc
        o = {
          F = {
            "<cmd>FzfLua<CR>",
            "Open FzfLua",
          },
          L = {
            "<cmd>LazyGit<CR>",
            "Open Lazygit",
          },
          d = {
            "<cmd>DiffviewOpen<CR>",
            "Open DiffView",
          },
          l = {
            "<cmd>Lazy<CR>",
            "Open Lazy.nvim",
          },
          m = {
            "<cmd>Mason<CR>",
            "Open Mason",
          },
        },
        -- <leader>t prefixes keymaps that *t*oggle functionality
        t = {
          L = {
            "<cmd>set list!<CR>",
            "Toggle hidden chars (:set list!)",
          },
          S = {
            "<cmd>setlocal spell! spelllang=en_us<CR>",
            "Toggle spelling",
          },
          n = {
            "<cmd>set number!<CR>",
            "Toggle line numbers",
          },
          r = {
            "<cmd>set relativenumber!<CR>",
            "Toggle relative line numbers",
          },
          w = {
            "<cmd>set nowrap!<CR>",
            "Toggle line wrapping",
          },
        },
      }, {
        prefix = "<leader>",
      })
    end,
  },
}
