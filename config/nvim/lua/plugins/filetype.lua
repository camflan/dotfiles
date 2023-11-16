return {
  {
    "nathom/filetype.nvim",
    config = function()
      local filetype = require("filetype")

      filetype.setup({
        overrides = {
          extensions = {
            hurl = "hurl",
            prisma = "prisma",
            -- Set the filetype of *.pn files to potion
            pn = "potion",
          },
          literal = {
            -- Set the filetype of files named "MyBackupFile" to lua
            MyBackupFile = "lua",
          },
          complex = {
            -- Set the filetype of any full filename matching the regex to gitconfig
            [".*git/config"] = "gitconfig", -- Included in the plugin
          },

          -- The same as the ones above except the keys map to functions
          function_extensions = {
            ["cpp"] = function()
              vim.bo.filetype = "cpp"
              -- Remove annoying indent jumping
              vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
            end,
          },
          function_literal = {
            Brewfile = function()
              vim.cmd("syntax off")
            end,
          },

          shebang = {
            -- Set the filetype of files with a dash shebang to sh
            dash = "sh",
          },
        },
      })
    end,
  },
}
