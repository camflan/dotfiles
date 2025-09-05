vim.pack.add(
    {
        { src = "https://github.com/tpope/vim-fugitive" },
        { src = "https://github.com/lewis6991/gitsigns.nvim" }
    },
    {
        load = true
    }
)

require("gitsigns").setup()
