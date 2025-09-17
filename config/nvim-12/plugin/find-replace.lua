local utils = require("utils.pack")

utils.ensure_installed({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" }
})

vim.pack.add({
    { src = "https://github.com/MagicDuck/grug-far.nvim" }
}, { load = true })

require('grug-far').setup({})
