return {
	{
		"winston0410/range-highlight.nvim",
		dependencies = {
			"winston0410/cmd-parser.nvim"
		},
		lazy = false,
		config = function ()
			require'range-highlight'.setup{}
		end
	},
}
