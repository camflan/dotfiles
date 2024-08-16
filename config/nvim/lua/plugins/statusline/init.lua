return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VeryLazy" },
    opts = {
      extensions = {
        "fugitive",
        "fzf",
        "lazy",
        "mason",
        "oil",
        "trouble",
      },
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        lualine_b = { "branch", "diff" },
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 4,
            symbols = {
              newfile = "[N]",
            },
          },
        },
        lualine_x = { "diagnostics" },
        lualine_y = {},
        lualine_z = {
          { "location", separator = "", padding = { left = 1, right = 0 } },
          { "progress", separator = "", padding = { left = 0, right = 1 } },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
    },
  },
}
