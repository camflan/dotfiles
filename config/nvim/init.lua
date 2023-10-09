-- init.lua
-- camron flanders <me@camronflanders.com>
-- last update: January 2023:CBF
--
-- feel free to use all or part of my init.lua to learn, modify, use. If used
-- in an init.lua you intend to distribute, please credit appropriately.

-- NVIM provider paths
vim.g.node_host_prog = "$HOME/.volta/tools/image/packages/neovim/bin/neovim-node-host"
vim.g.python3_host_prog = "$HOME/.asdf-data/shims/python3"

-- let nvim set window title
vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:.:h")})%)%( %a%)'

-- spacebar as leader
vim.g.mapleader = " "

-- shorten key chord timeout len from 1000ms
vim.opt.timeoutlen = 200

-- auto-read changes to files
vim.opt.autoread = true

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- 3 line offset above/below current line
vim.opt.scrolloff = 3

-- enable mouse
vim.opt.mouse = "a"

-- show hidden chars
vim.opt.list = true
vim.opt.listchars = {
  extends = "»",
  nbsp = "␣",
  precedes = "«",
  -- space = "·",
  tab = "▸ ",
  trail = "•",
}

-- indent/tabs
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.breakindent = true
vim.opt.showbreak = "↪"

-- navigation
vim.keymap.set({ "n", "i", "v" }, "<C-h>", "<C-W>h")
vim.keymap.set({ "n", "i", "v" }, "<C-j>", "<C-W>j")
vim.keymap.set({ "n", "i", "v" }, "<C-k>", "<C-W>k")
vim.keymap.set({ "n", "i", "v" }, "<C-l>", "<C-W>l")

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<leader>/", ":silent nohlsearch<CR>", { remap = false })

-- jj to exit normal mode
vim.keymap.set("i", "jj", "<C-[>", { remap = false })

-- ; -> : for faster cmd
vim.keymap.set({ "n", "v" }, ";", ":", { remap = false })

-- Use oil for directory/file nav
vim.keymap.set({ "n" }, "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- FZF-lua
vim.keymap.set({ "n" }, "<leader>f", "<cmd>lua require('fzf-lua').files()<CR>", { remap = false, silent = true })
vim.keymap.set({ "n" }, "<leader>b", "<cmd>lua require('fzf-lua').buffers()<CR>", { remap = false, silent = true })
vim.keymap.set(
  { "n" },
  "<leader>r",
  "<cmd>lua require('fzf-lua').live_grep_native()<CR>",
  { remap = false, silent = true }
)
vim.keymap.set({ "n" }, "<leader>h", "<cmd>lua require('fzf-lua').help_tags()<CR>", { remap = false })
vim.keymap.set({ "n" }, "<leader>rr", "<cmd>lua require('fzf-lua').lsp_references()<CR>", { remap = false })
vim.keymap.set({ "n" }, "<leader>rs", "<cmd>lua require('fzf-lua').lsp_live_workspace_symbols()<CR>", { remap = false })
vim.keymap.set({ "n" }, "<leader>c", "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>", { remap = false })

-- ISwap
vim.keymap.set("", "<Leader>s", ":ISwap<CR>", { desc = "ISwap arguments" })

-- Hop
vim.keymap.set({ "n" }, "<leader>l", ":HopLineStart<CR>", { remap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>w", ":HopWord<CR>", { remap = true, silent = true })

-- Spectre
vim.keymap.set({ "n" }, "<leader>S", ":Spectre<CR>", { remap = false, silent = true })

-- Trouble
vim.keymap.set({ "n" }, "<leader>T", ":Trouble<CR>", { remap = false, silent = true })

-- tree view style for Explore/NetRw
vim.g.netrw_liststyle = 3

-- LAZY
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "catppuccin" },
  },
})
