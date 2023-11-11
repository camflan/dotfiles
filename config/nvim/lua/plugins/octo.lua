return {
	{
		"pwntester/octo.nvim",
		dependencies = {
			"ibhagwan/fzf-lua",
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = true,
		cmd = { "Octo" },
		-- NOTE: also registering markdown parser in nvim-treesitter.lua
		opts = {
			picker = "fzf-lua",
			enable_builtin = true,
			default_remote = { "upstream", "origin", "github", "gh" },
		},
	},
}
