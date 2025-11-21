vim.pack.add(
    {
        { src = "https://github.com/mizlan/iswap.nvim" },
    },
    {
        load = true
    })

require("iswap").setup()
vim.keymap.set({ "n" }, "<leader>s", "<cmd>ISwap<CR>", { desc = "Swap arguments" })
