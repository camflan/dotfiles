vim.pack.add({
    { src = "https://github.com/mbbill/undotree" }
}, {
    load = true
})

vim.keymap.set(
    { "n" },
    "<leader>oU",
    "<cmd>UndotreeToggle<CR>",
    {desc = "Show UndoTree",}
)
