return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = true,
		config = function()
			-- setup for comment.nvim + nvim-ts-context-commentstring
			-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
			local ts_configs = require("nvim-treesitter.configs")
			ts_configs.setup({
				context_commentstring = {
					enable = true,
					-- Put custom comment definitions here for other filetypes or filetypes that don't work well.
					-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
				},
			})
		end,
	},
}
