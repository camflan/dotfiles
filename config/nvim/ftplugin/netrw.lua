vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set({ "n" }, ".", "gh", { buffer = true, desc = "Toggle hidden files", remap = true })
    vim.keymap.set({ "n" }, "P", "<C-w>z", { buffer = true, desc = "Close preview", remap = true })

    vim.keymap.set({ "n" }, "<tab>", "mf", { buffer = true, desc = "Toggle mark", remap = true })
    vim.keymap.set({ "n" }, "<leader><tab>", "mf", { buffer = true, desc = "Clear all marks", remap = true })


    vim.keymap.set({ "n" }, "fc", "%:w<CR>:buffer #<CR>", { buffer = true, desc = "Create and write new file", remap = true })
  end
})

