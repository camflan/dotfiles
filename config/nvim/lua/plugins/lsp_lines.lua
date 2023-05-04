return {
	{
		"lsp_lines",
		url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			local lsp_lines = require("lsp_lines")
			lsp_lines.setup()

			-- Swap lsp_lines and built-in virtual_text usage for LSP
			function toggle_lsp_lines()
				local new_value = lsp_lines.toggle()

				vim.diagnostic.config({
					virtual_text = not new_value,
				})
			end

			vim.diagnostic.config({
				virtual_lines = false,
				virtual_text = true,
			})

			vim.keymap.set("", "<Leader>L", toggle_lsp_lines, { desc = "Toggle lsp_lines" })
		end,
	},
}
