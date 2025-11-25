vim.pack.add(
    {
        { src = "https://github.com/smoka7/hop.nvim" }
    },
    {
        load = true
    }
)

require("hop").setup({})

vim.keymap.set({ "n" }, "<leader>w", "<cmd>HopWord<cr>", { desc = "Hop to a word" })
vim.keymap.set({ "n" }, "<leader>hW", "<cmd>HopChar2MW<cr>", { desc = "Hop to bigram in any window" })
vim.keymap.set({ "n" }, "<leader>hl", "<cmd>HopLineStart<cr>", { desc = "Hop to a line" })
vim.keymap.set({ "n" }, "<leader>hw", "<cmd>HopWordMW<cr>", { desc = "Hop to a word in any window" })
