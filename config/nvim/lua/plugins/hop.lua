return {
	{
		"phaazon/hop.nvim",
		lazy = true,
		keys = {
			{
				"<leader>l",
				":HopLineStart<CR>",
				mode = { "n" },
				desc = "Jump directly to start of line",
				remap = true,
				silent = true,
			},
			{
				"<leader>w",
				":HopWord<CR>",
				mode = { "n" },
				desc = "Jump directly to word",
				remap = true,
				silent = true,
			},
		},
		config = function()
			local hop = require("hop")
			hop.setup()
		end,
	},
}
