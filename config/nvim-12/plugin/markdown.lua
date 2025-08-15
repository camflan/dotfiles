vim.pack.add({
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" }
})

local md = require("render-markdown")

md.setup({
    heading = {
        width = "full"
    }
})
