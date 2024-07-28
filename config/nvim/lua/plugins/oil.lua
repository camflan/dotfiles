return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
    keys = {
      {
        "-",
        "<CMD>Oil<CR>",
        mode = { "n" },
        desc = "Open parent directory",
      },
      {
        "<leader>-",
        "<CMD>Oil --float<CR>",
        mode = { "n" },
        desc = "Open parent directory in float",
      },
    },
    opts = {
      columns = {
        "icon",
        "permissions",
        "mtime",
      },
      -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          -- never show .DS_Store files
          if name == ".DS_Store" then
            return true
          end

          return false
        end,
      },
    },
  },
}
