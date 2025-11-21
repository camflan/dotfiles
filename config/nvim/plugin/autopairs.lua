vim.pack.add({
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/windwp/nvim-ts-autotag" }
})

require("nvim-autopairs").setup({
    check_ts = true,
})

require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
    }
})
