-- init.lua
-- camron flanders <me@camronflanders.com>
-- last update: November 2023:CBF
--
-- feel free to use all or part of my init.lua to learn, modify, use. If used
-- in an init.lua you intend to distribute, please credit appropriately.

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
--
-- NVIM provider paths
-- vim.g.node_host_prog = "$HOME/.asdf-data/shims/neovim-node-host"
-- vim.g.python3_host_prog = "$HOME/.asdf-data/shims/python3"

-- let nvim set window title
vim.opt.title = true
vim.opt.titlestring = "%t%( %M%)%( (%{getcwd()})%)%( %a%)"
-- vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:p")})%)%( %a%)'

-- spacebar as leader
vim.g.mapleader = " "

-- shorten key chord timeout len from 1000ms
vim.opt.timeoutlen = 300

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

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<leader>/", "<cmd>silent nohlsearch<CR>", { desc = "Toggle search highlights", remap = false })

-- jj to exit normal mode
vim.keymap.set("i", "jj", "<C-[>", { desc = "ergo exit instead of esc", remap = false })

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
    colorscheme = {
      "tokyonight",
      "dracula",
      "poimandres",
      "catpuccin",
      "nord",
      "oxocarbon",
      "nightfox",
      "sonokai",
      "solarized",
      "koehler",
    },
    diff = {
      cmd = "diffview.nvim",
    },
  },
})
