vim.pack.add(
    {
        { src = "https://github.com/chrisgrieser/nvim-chainsaw" },
    },
    {
        load = true
    }
)

require("chainsaw").setup({
    marker = "🪵"
})

vim.keymap.set({ "n" }, "gli", "<cmd>Chainsaw typeLog<cr>")
vim.keymap.set({ "n" }, "glm", "<cmd>Chainsaw messageLog<cr>")
vim.keymap.set({ "n" }, "glo", "<cmd>Chainsaw objectLog<cr>")
vim.keymap.set({ "n" }, "glt", "<cmd>Chainsaw timeLog<cr>")
