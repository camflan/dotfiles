vim.pack.add({
    { src = "https://github.com/mizlan/iswap.nvim", }
})

require("iswap").setup()
vim.keymap.set({ "n" }, "<leader>s", "<cmd>ISwap<CR>", { desc = "Swap arguments" })
