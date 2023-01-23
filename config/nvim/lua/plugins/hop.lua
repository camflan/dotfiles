return {
	{
		"phaazon/hop.nvim",
		lazy = true,
		cmd = { "HopWord", "HopLineStart" },
		config = function()
			local hop = require("hop")
			hop.setup()
		end,
	},
}
