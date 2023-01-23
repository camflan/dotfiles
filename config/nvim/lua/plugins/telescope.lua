return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-lua/plenary.nvim",
			{
				"folke/trouble.nvim",
				config = function()
					local trouble = require("trouble")

					trouble.setup({
						position = "bottom",
						icons = false,
						fold_open = "v", -- icon used for open folds
						fold_closed = ">", -- icon used for closed folds
						indent_lines = false, -- add an indent guide below the fold icons
						signs = {
							-- icons / text used for a diagnostic
							error = "error",
							warning = "warn",
							hint = "hint",
							information = "info",
						},
						use_diagnostic_signs = false,
					})
				end,
			},
		},
		lazy = true,
		config = function()
			local telescope = require("telescope")
			local telescope_actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					-- Default configuration for telescope goes here:
					-- config_key = value,
					mappings = {
						i = {
							["<esc>"] = telescope_actions.close,
							-- map actions.which_key to <C-h> (default: <C-/>)
							-- actions.which_key shows the mappings for your picker,
							-- e.g. git_{create, delete, ...}_branch for the git_branches picker
						},
					},
				},
				pickers = {
					find_files = {
						theme = "dropdown",
					},
					-- Default configuration for builtin pickers goes here:
					-- picker_name = {
					--   picker_config_key = value,
					--   ...
					-- }
					-- Now the picker_config_key will be applied every time you call this
					-- builtin picker
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			telescope.load_extension("fzf")
		end,
	},
}