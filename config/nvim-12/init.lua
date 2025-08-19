-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

local opt = vim.opt

-- let nvim set window title
opt.title = true
opt.titlestring = "%t%( %M%)%( (%{getcwd()})%)%( %a%)"

-- spacebar as leader
vim.g.mapleader = " "
-- \ as localleader
vim.g.maplocalleader = "\\"

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

-- make Esc work in :terminal
vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>", { remap = false })

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- jj to exit normal mode
vim.keymap.set("i", "jj", "<C-[>", { desc = "ergo exit instead of esc", remap = false })

-- ; -> : for faster cmd
vim.keymap.set({ "n", "v" }, ";", ":", { desc = "Fast access to :", remap = false })

-- tree view style for Explore/NetRw
vim.g.netrw_liststyle = 3
vim.keymap.set({ "n" }, "-", "<cmd>Explore<cr>")

vim.keymap.set({ "n" }, "<leader>/", "<cmd>set hlsearch!<cr>", { desc = "Toggle search highlights" })
