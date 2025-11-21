vim.pack.add({
    { src = "https://github.com/ibhagwan/fzf-lua" }
})

local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")

fzf.setup({
    fzf_colors = true,
    fzf_opts = {
        -- saves to ~/.local/share/nvim/fzf-lua-history
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
    },
    actions = {
        buffers = {
            -- providers that inherit these actions:
            --   buffers, tabs, lines, blines
            ["default"] = actions.buf_switch_or_edit,
            ["ctrl-o"] = actions.buf_edit,
            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
        },
        files = {
            -- providers that inherit these actions:
            --   files, git_files, git_status, grep, lsp oldfiles, quickfix, loclist, tags, btags args
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-l"] = actions.file_sel_to_ll,
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-t"] = actions.file_tabedit,
            ["ctrl-v"] = actions.file_vsplit,
        },
    },
    files = {
        fd_opts = [[--type f --hidden --follow --exclude .git --exclude node_modules]],
        color_icons = false,
        file_icons = false,
        git_icons = false,
    },
    grep = {
        debug = false,
        color_icons = false,
        file_icons = false,
        git_icons = false,
        fzf_opts = { ["--nth"] = "2.." },
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        -- allow modifying file glob by passing `--file/glob/**/*` to a query
        rg_glob = true,
        actions = {
            ["ctrl-r"] = { actions.toggle_ignore },
        },
    },
    keymap = {
        builtin = {
            ["<F1>"] = "toggle-help",
        },
        fzf = {
            ["alt-a"] = "toggle-all",
            ["ctrl-q"] = "select-all+accept",
            ["ctrl-y"] = "toggle-preview",
            ["ctrl-z"] = "abort",
        },
    },
    previewers = {
        bat = {
            cmd = "bat",
        },
    },
    winopts = {
        preview = {
            default = "bat",
            wrap = "nowrap",
        },
    },
})

vim.keymap.set({ "n" }, "<leader>fF", fzf.builtin)
vim.keymap.set({ "n" }, "<leader>fb", fzf.buffers)
vim.keymap.set({ "n" }, "<leader>ff", fzf.files)
vim.keymap.set({ "n" }, "<leader>fh", fzf.help_tags)
vim.keymap.set({ "n" }, "<leader>fr", fzf.live_grep)
