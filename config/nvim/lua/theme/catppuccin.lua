catppuccin = require("catppuccin")
local macchiato = require("catppuccin.palettes").get_palette "latte"


catppuccin.setup({
    flavour = "macchiato",
    integrations = {
        hop = true,
        native_lsp = {
            enabled = true
        },
        treesitter = true,
        lsp_trouble = true
    }
})

vim.cmd.colorscheme "catppuccin"
