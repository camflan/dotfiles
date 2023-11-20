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
    event = "CmdlineEnter",
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
    event = "CmdlineEnter",
  },
  {
    -- git integration
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    event = "VeryLazy",
    lazy = true,
  },
  {
    -- github extension for fugitive
    "tpope/vim-rhubarb",
    lazy = true,
  },
  {
    -- repeat on steroids
    "tpope/vim-repeat",
    lazy = true,
    event = "InsertEnter",
  },
  {
    -- support readline keys on cmdline
    "tpope/vim-rsi",
    lazy = true,
    event = "CmdlineEnter",
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
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    -- handy mappings for qf, lines, etc
    "tpope/vim-unimpaired",
    event = { "BufReadPre", "BufNewFile" },
  },
  -- Database Interface
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
    },
    lazy = true,
    cmd = "DBUI",
  },
}
