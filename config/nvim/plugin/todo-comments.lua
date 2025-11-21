vim.pack.add({
    { src = "https://github.com/folke/todo-comments.nvim" }
},
    { load = true })

require("todo-comments").setup()
