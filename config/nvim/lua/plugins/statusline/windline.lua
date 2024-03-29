-- Symbols available on windline
-- {
--     vertical_bar = '┃',
--     vertical_bar_thin = '│',
--     left = '',
--     right = '',
--     block = '█',
--     block_thin = "▌",
--     left_filled = '',
--     right_filled = '',
--     slant_left = '',
--     slant_left_thin = '',
--     slant_right = '',
--     slant_right_thin = '',
--     slant_left_2 = '',
--     slant_left_2_thin = '',
--     slant_right_2 = '',
--     slant_right_2_thin = '',
--     left_rounded = '',
--     left_rounded_thin = '',
--     right_rounded = '',
--     right_rounded_thin = '',
--     circle = '●'
-- }

return {
  {
    "windwp/windline.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local windline = require("windline")
      local helper = require("windline.helpers")
      local b_components = require("windline.components.basic")
      local vim_components = require("windline.components.vim")
      local ts_statusline = require("nvim-treesitter.statusline")

      local sep = helper.separators
      local state = _G.WindLine.state

      local lsp_comps = require("windline.components.lsp")

      local hl_list = {
        Black = { "white", "black" },
        White = { "black", "white" },
        Inactive = { "InactiveFg", "InactiveBg" },
        Active = { "ActiveFg", "ActiveBg" },
      }
      local basic = {}

      basic.divider = { b_components.divider, "" }
      basic.space = { " ", "" }
      basic.bg = { " ", "StatusLine" }
      basic.file_name_inactive = { b_components.full_file_name, hl_list.Inactive }
      basic.line_col_inactive = { b_components.line_col, hl_list.Inactive }
      basic.progress_inactive = { b_components.progress, hl_list.Inactive }

      basic.vi_mode = {
        hl_colors = {
          Normal = { "black", "red", "bold" },
          Insert = { "black", "green", "bold" },
          Visual = { "black", "yellow", "bold" },
          Replace = { "black", "blue_light", "bold" },
          Command = { "black", "magenta", "bold" },
          NormalBefore = { "red", "black" },
          InsertBefore = { "green", "black" },
          VisualBefore = { "yellow", "black" },
          ReplaceBefore = { "blue_light", "black" },
          CommandBefore = { "magenta", "black" },
          NormalAfter = { "white", "red" },
          InsertAfter = { "white", "green" },
          VisualAfter = { "white", "yellow" },
          ReplaceAfter = { "white", "blue_light" },
          CommandAfter = { "white", "magenta" },
        },
        text = function()
          return {
            { sep.left_rounded, state.mode[2] .. "Before" },
            { state.mode[1] .. " ", state.mode[2] },
          }
        end,
      }

      basic.lsp_diagnos = {
        width = 90,
        hl_colors = {
          red = { "red", "black_light" },
          yellow = { "yellow", "black_light" },
          blue = { "blue", "black_light" },
        },
        text = function(bufnr)
          if lsp_comps.check_lsp(bufnr) then
            return {
              { lsp_comps.lsp_error({ format = "  %s" }), "red" },
              { lsp_comps.lsp_warning({ format = "  %s" }), "yellow" },
              { lsp_comps.lsp_hint({ format = "  %s" }), "blue" },
            }
          end
          return ""
        end,
      }

      local icon_comp = b_components.cache_file_icon({ default = "", hl_colors = { "white", "black_light" } })

      local ts_statusline_width = 40
      basic.file = {
        hl_colors = {
          default = { "white", "black_light" },
          light_text = { "white_light", "black_light" },
        },
        text = function(bufnr)
          local components = {
            { " ", "default" },
            icon_comp(bufnr),
            { " ", "default" },
            { b_components.cache_file_name("[No Name]", "unique"), "" },
            { b_components.file_modified("+ "), "default" },
          }

          local treesitter_path = ts_statusline.statusline({ bufnr = bufnr, indicator_size = ts_statusline_width })

          if treesitter_path == nil or treesitter_path == "" then
            return components
          end

          table.insert(components, { sep.slant_left_thin, "default" })
          table.insert(components, { treesitter_path, "light_text" })
          return components
        end,
      }
      basic.right = {
        hl_colors = {
          sep_before = { "black_light", "white_light" },
          sep_after = { "white_light", "black" },
          text = { "black", "white_light" },
        },
        text = function()
          return {
            { b_components.line_col_lua, "text" },
            { sep.slant_left_thin, "text" },
            { b_components.progress, "text" },
            { sep.right_rounded, "sep_after" },
          }
        end,
      }
      basic.logo = {
        hl_colors = {
          sep_before = { "blue", "black" },
          default = { "black", "blue" },
        },
        text = function()
          return {
            { sep.left_rounded, "sep_before" },
            { " ", "default" },
          }
        end,
      }

      local default = {
        filetypes = { "default" },
        active = {
          { " ", hl_list.Black },
          basic.logo,
          basic.lsp_diagnos,
          basic.file,
          { vim_components.search_count(), { "red", "black_light" } },
          { sep.right_rounded, { "black_light", "black" } },
          basic.divider,
          { " ", hl_list.Black },
          basic.vi_mode,
          basic.right,
          { " ", hl_list.Black },
        },
        inactive = {
          basic.file,
          basic.divider,
          basic.progress_inactive,
        },
      }

      local quickfix = {
        filetypes = { "qf", "Trouble" },
        active = {
          { "🚦 Quickfix ", { "white", "black" } },
          { helper.separators.slant_right, { "black", "black_light" } },
          {
            function()
              return vim.fn.getqflist({ title = 0 }).title
            end,
            { "cyan", "black_light" },
          },
          { " Total : %L ", { "cyan", "black_light" } },
          { helper.separators.slant_right, { "black_light", "InactiveBg" } },
          { " ", { "InactiveFg", "InactiveBg" } },
          basic.divider,
          { helper.separators.slant_right, { "InactiveBg", "black" } },
          { "🧛 ", { "white", "black" } },
        },
        always_active = true,
        show_last_status = true,
      }

      local explorer = {
        filetypes = { "netrw", "fern", "NvimTree", "lir" },
        active = {
          { "  ", { "white", "black" } },
          { helper.separators.slant_right, { "black", "black_light" } },
          { b_components.divider, "" },
          { b_components.file_name(""), { "white", "black_light" } },
        },
        always_active = true,
        show_last_status = true,
      }

      -- local winbar = {
      --   filetypes = { "winbar" },
      --   active = {
      --     { " " },
      --     { "%=" },
      --     {
      --       "@@",
      --       { "red", "white" },
      --     },
      --   },
      --   inactive = {
      --     { " ", { "white", "InactiveBg" } },
      --     { "%=" },
      --     {
      --       function(bufnr)
      --         local bufname = vim.api.nvim_buf_get_name(bufnr)
      --         local path = vim.fn.fnamemodify(bufname, ":~:.")
      --         return path
      --       end,
      --       { "white", "InactiveBg" },
      --     },
      --   },
      -- }

      windline.setup({
        colors_name = function(colors)
          -- ADD MORE COLOR HERE ----
          return colors
        end,
        statuslines = {
          default,
          quickfix,
          explorer,
        },
      })
    end,
  },
}
