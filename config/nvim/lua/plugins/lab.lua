return {
	{
		"0x100101/lab.nvim",
		lazy = true,
		cmd = { "Lab" },
		build = 'cd js && npm ci',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			code_runner = {
				enabled = true,
			},
			quick_data = {
				enabled = false,
			}
		}
	}
}
