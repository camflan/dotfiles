-- init.lua
-- camron flanders <me@camronflanders.com>
-- last update: November 2023:CBF
--
-- feel free to use all or part of my init.lua to learn, modify, use. If used
-- in an init.lua you intend to distribute, please credit appropriately.

-- NVIM provider paths
vim.g.node_host_prog = "$HOME/.asdf-data/shims/neovim-node-host"
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
vim.keymap.set("n", "<leader>/", ":silent nohlsearch<CR>", { desc = "Toggle search highlights", remap = false })

-- jj to exit normal mode
vim.keymap.set("i", "jj", "<C-[>", { desc = "ergo exit intead of esc", remap = false })

-- ; -> : for faster cmd
vim.keymap.set({ "n", "v" }, ";", ":", { desc = "Fast access to :", remap = false })

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
    colorscheme = { "tokyonight", "catpuccin", "solarized", "koehler" },
  },
})
