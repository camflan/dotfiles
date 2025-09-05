vim.pack.add({
    { src = "https://github.com/mrjones2014/smart-splits.nvim" }
}, {
    load = true
})

local smart_splits = require("smart-splits")

smart_splits.setup({
    at_edge = "wrap",
    ignored_filetypes = { "NvimTree" },
})

vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left)
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down)
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up)
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right)
vim.keymap.set("n", "<C-\\>",smart_splits.move_cursor_previous)

-- swapping buffers between windows
vim.keymap.set({ "n" }, "<leader><leader>h", smart_splits.swap_buf_left)
vim.keymap.set({ "n" }, "<leader><leader>j", smart_splits.swap_buf_down)
vim.keymap.set({ "n" }, "<leader><leader>k", smart_splits.swap_buf_up)
vim.keymap.set({ "n" }, "<leader><leader>l", smart_splits.swap_buf_right)


