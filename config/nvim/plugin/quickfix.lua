-- Quickfix and Location List Navigation
-- Quickfix is a global list (diagnostics, grep results, etc.)
-- Location list is buffer-local

-- Quickfix navigation
vim.keymap.set("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>zz", { desc = "Previous quickfix item" })
vim.keymap.set("n", "]Q", "<cmd>clast<cr>zz", { desc = "Last quickfix item" })
vim.keymap.set("n", "[Q", "<cmd>cfirst<cr>zz", { desc = "First quickfix item" })

-- Location list navigation (buffer-local)
vim.keymap.set("n", "<leader>lo", "<cmd>lopen<cr>", { desc = "Open location list" })
vim.keymap.set("n", "<leader>lc", "<cmd>lclose<cr>", { desc = "Close location list" })
vim.keymap.set("n", "]l", "<cmd>lnext<cr>zz", { desc = "Next location item" })
vim.keymap.set("n", "[l", "<cmd>lprev<cr>zz", { desc = "Previous location item" })
vim.keymap.set("n", "]L", "<cmd>llast<cr>zz", { desc = "Last location item" })
vim.keymap.set("n", "[L", "<cmd>lfirst<cr>zz", { desc = "First location item" })

-- Send diagnostics to quickfix/loclist
vim.keymap.set("n", "<leader>dq", function()
    vim.diagnostic.setqflist()
    vim.cmd("copen")
end, { desc = "Diagnostics to quickfix" })

vim.keymap.set("n", "<leader>dl", function()
    vim.diagnostic.setloclist()
    vim.cmd("lopen")
end, { desc = "Diagnostics to loclist" })

-- Useful quickfix commands to remember:
-- :grep pattern **/*.ext     - Grep and populate quickfix
-- :vimgrep /pattern/ **      - Built-in grep to quickfix
-- :cdo s/old/new/gc          - Edit each item interactively
-- :cfdo %s/old/new/g         - Edit per-file
-- :cdo update                - Save all changes

-- Create a command to list all TODOs in project
vim.api.nvim_create_user_command("TodoList", function()
    vim.cmd("vimgrep /\\<TODO\\|FIXME\\|HACK\\|XXX\\|NOTE\\>/ **/*.lua **/*.ex **/*.exs **/*.js **/*.ts **/*.tsx")
    vim.cmd("copen")
end, { desc = "Find all TODOs in project" })

-- Create a command to list all project files in quickfix
vim.api.nvim_create_user_command("ProjectFiles", function()
    local files = vim.fn.systemlist("git ls-files 2>/dev/null || find . -type f")
    local qf_list = {}
    for _, file in ipairs(files) do
        table.insert(qf_list, { filename = file, lnum = 1, col = 1, text = file })
    end
    vim.fn.setqflist(qf_list)
    vim.cmd("copen")
end, { desc = "Load all project files into quickfix" })
