local M = {

	-- tokyonight
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = { style = "moon" },
	},

	-- catppuccin
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000, -- load as soon as possible
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local catppuccin = require("catppuccin")

			vim.g.catppuccin_flavour = "macchiato"

			catppuccin.setup({
				flavour = "macchiato",
				integrations = {
					hop = true,
					native_lsp = {
						enabled = true,
					},
					treesitter = true,
					lsp_trouble = true,
				},
			})

			vim.cmd([[colorscheme catppuccin]])
		end,
	},
	{
		"altercation/vim-colors-solarized",
		lazy = true,
	},
	{
		"srcery-colors/srcery-vim",
		lazy = true,
	},
	{ "tjammer/blayu.vim", lazy = true },
	{ "tomasr/molokai", lazy = true },
	{ "mhartington/oceanic-next", lazy = true },
	{ "marciomazza/vim-brogrammer-theme", lazy = true },
	{ "haishanh/night-owl.vim", lazy = true },
	{ "sts10/vim-pink-moon", lazy = true },
	{ "fenetikm/falcon", lazy = true },
	{ "phanviet/vim-monokai-pro", lazy = true },
	{ "andreypopp/vim-colors-plain", lazy = true },
	{ "cocopon/iceberg.vim", lazy = true },
	{ "dracula/vim", name = "dracula", lazy = true },
	{ "pineapplegiant/spaceduck", lazy = true },
}

return M
