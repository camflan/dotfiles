return {
  {
    "windwp/windline.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      "lewis6991/gitsigns.nvim",
    },
    config = function()
      local windline = require("windline")
      local helper = require("windline.helpers")
      local b_components = require("windline.components.basic")
      local state = _G.WindLine.state

      local lsp_comps = require("windline.components.lsp")
      local lsp_progress_comps = require("windline.components.lsp_progress")
      local git_comps = require("windline.components.git")

      local hl_list = {
        Black = { "white", "black" },
        White = { "black", "white" },
        Inactive = { "InactiveFg", "InactiveBg" },
        Active = { "ActiveFg", "ActiveBg" },
      }
      local basic = {}

      local breakpoint_width = 90
      basic.divider = { b_components.divider, "" }
      basic.bg = { " ", "StatusLine" }

      local colors_mode = {
        Normal = { "red", "black" },
        Insert = { "green", "black" },
        Visual = { "yellow", "black" },
        Replace = { "blue_light", "black" },
        Command = { "magenta", "black" },
      }

      local inverted_colors_mode = {}

      for k in pairs(colors_mode) do
        local config = colors_mode[k]
        inverted_colors_mode[k] = { config[2], config[1] }
      end

      basic.vi_mode = {
        name = "vi_mode",
        hl_colors = inverted_colors_mode,
        text = function()
          return {
            { " " .. state.mode[1] .. " " .. helper.separators.slant_left, state.mode[2] },
            { " ", "ActiveBg" },
          }
        end,
      }

      basic.nav_and_mode = {
        hl_colors = inverted_colors_mode,
        text = function()
          return {
            { helper.separators.slant_right, state.mode[2] },
            { b_components.line_col_lua, state.mode[2] },
            { b_components.progress_lua, state.mode[2] },
            { " ", state.mode[2] },
          }
        end,
      }

      basic.square_mode = {
        hl_colors = colors_mode,
        text = function()
          return {
            { helper.separators.slant_left .. "▊", state.mode[2] },
          }
        end,
      }

      basic.lsp_diagnos = {
        name = "diagnostic",
        hl_colors = {
          red = { "red", "black" },
          yellow = { "yellow", "black" },
          blue = { "blue", "black" },
        },
        width = breakpoint_width,
        text = function(bufnr)
          if lsp_comps.check_lsp(bufnr) then
            return {
              { lsp_comps.lsp_error({ format = "  %s", show_zero = false }), "red" },
              { lsp_comps.lsp_warning({ format = "  %s", show_zero = false }), "yellow" },
              -- { lsp_comps.lsp_hint({ format = "  %s", show_zero = true }), "blue" },
            }
          end
          return ""
        end,
      }

      basic.lsp_progress = {
        name = "lsp_progress",
        hl_colors = {
          red = { "red", "black" },
          yellow = { "yellow", "black" },
          blue = { "blue", "black" },
        },
        width = breakpoint_width,
        text = function(bufnr)
          if lsp_comps.check_lsp(bufnr) then
            return {
              { lsp_progress_comps.lsp_progress(), "red" },
            }
          end
          return ""
        end,
      }

      basic.file = {
        name = "file",
        hl_colors = {
          default = hl_list.Black,
          white = { "white", "black" },
          magenta = { "magenta", "black" },
        },
        text = function()
          return {
            { b_components.cache_file_name("[No Name]", "unique"), "magenta" },
            { b_components.file_modified("+ "), "magenta" },
          }
        end,
      }
      basic.file_right = {
        hl_colors = {
          default = hl_list.Black,
          white = { "white", "black" },
          magenta = { "magenta", "black" },
        },
        text = function()
          return {
            { b_components.line_col_lua, "white" },
            { b_components.progress_lua, "" },
          }
        end,
      }
      basic.git = {
        name = "git",
        hl_colors = {
          green = { "green", "black" },
          red = { "red", "black" },
          blue = { "blue", "black" },
        },
        width = breakpoint_width,
        text = function(bufnr)
          if git_comps.is_git(bufnr) then
            return {
              { git_comps.diff_added({ format = "  %s", show_zero = true }), "green" },
              { git_comps.diff_removed({ format = "  %s", show_zero = true }), "red" },
              { git_comps.diff_changed({ format = "  %s", show_zero = true }), "blue" },
            }
          end
          return ""
        end,
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
        filetypes = { "fern", "NvimTree", "lir", "oil" },
        active = {
          { "  ", { "black", "red" } },
          { helper.separators.slant_right, { "red", "NormalBg" } },
          { b_components.divider, "" },
          { b_components.file_name(""), { "white", "NormalBg" } },
        },
        always_active = true,
        show_last_status = true,
      }

      local default = {
        filetypes = { "default" },
        active = {
          basic.vi_mode,
          basic.file,
          basic.lsp_progress,
          basic.lsp_diagnos,
          basic.divider,
          -- basic.git,
          { git_comps.git_branch(), { "magenta", "black" }, breakpoint_width },
          { " ", hl_list.Black },
          -- basic.file_right,
          basic.nav_and_mode,
        },
        inactive = {
          { b_components.full_file_name, hl_list.Inactive },
          basic.file_name_inactive,
          basic.divider,
          basic.divider,
          { b_components.line_col, hl_list.Inactive },
          { b_components.progress, hl_list.Inactive },
        },
      }

      windline.setup({
        colors_name = function(colors)
          -- print(vim.inspect(colors))
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
