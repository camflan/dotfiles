return {
  -- {
  -- 	-- NOTE: Currently disabled in favor of oil.nvim
  -- 	-- file navigation, enhanced
  -- 	"tpope/vim-vinegar",
  -- },
  {
    -- replacements with case manipulation
    "tpope/vim-abolish",
    lazy = true,
    cmd = {
      "S",
    },
  },
  {
    -- more char data on ga,
    "tpope/vim-characterize",
    lazy = true,
    keys = {
      { "ga" },
    },
  },
  {
    -- unix helpers that work on the buffer and file together. delete/move/copy/etc
    "tpope/vim-eunuch",
    lazy = true,
    cmd = {
      "Chmod",
      "Delete",
      "Mkdir",
      "Move",
    },
  },
  {
    -- git integration
    "tpope/vim-fugitive",
    lazy = true,
    cmd = {
      "G",
    },
  },
  {
    -- github extension for fugitive
    "tpope/vim-rhubarb",
    lazy = true,
    cmd = {
      "G",
    },
  },
  {
    -- repeat on steroids
    "tpope/vim-repeat",
    lazy = false,
  },
  {
    -- support readline keys on cmdline
    "tpope/vim-rsi",
    lazy = false,
  },
  {
    -- C-A/X to inc/dec dates, numbers, more
    "tpope/vim-speeddating",
    lazy = true,
    keys = {
      { "<C-A>" },
      { "<C-X>" },
    },
  },
  { --
    -- better surround support
    "tpope/vim-surround",
    lazy = false,
  },
  {
    -- handy mappings for qf, lines, etc
    "tpope/vim-unimpaired",
    lazy = false,
  },
  -- Database Interface
  { "tpope/vim-dadbod", lazy = true, cmd = "DB" },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
    },
    lazy = true,
    cmd = "DBUI",
  },
}
