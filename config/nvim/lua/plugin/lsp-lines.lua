lsp_lines = require("lsp_lines")
lsp_lines.setup()

-- Swap lsp_lines and built-in virtual_text usage for LSP
function toggle_lsp_lines()
    new_value = lsp_lines.toggle()

    vim.diagnostic.config({
        virtual_text = not new_value
    })
end

-- Set lsp_lines ON by default
vim.diagnostic.config({
    virtual_text = false
})

vim.keymap.set(
    "",
    "<Leader>L",
    toggle_lsp_lines,
    { desc = "Toggle lsp_lines" }
)
