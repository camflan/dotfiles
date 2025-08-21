vim.pack.add(
    {
        { src = "https://github.com/smoka7/hop.nvim" }
    },
    {
        load = true
    }
)

require("hop").setup({})

vim.keymap.set({ "n" }, "<leader>W", "<cmd>HopChar2<cr>", { desc = "Hop to bigram" })
vim.keymap.set({ "n" }, "<leader>l", "<cmd>HopLineStart<cr>", { desc = "Hop to a line" })
vim.keymap.set({ "n" }, "<leader>w", "<cmd>HopWord<cr>", { desc = "Hop to a word" })
