vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}, {
	load = true,
})

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	group = vim.api.nvim_create_augroup("TreesitterUpdated", { clear = true }),
	callback = function(args)
		local spec = args.data.spec
		if spec and spec.name == "nvim-treesitter" and args.data.kind == "update" then
			vim.notify("nvim-treesitter was updated, running :TSUpdate", vim.log.levels.INFO)
			vim.schedule(function()
				vim.cmd("TSUpdate")
			end)
		end
	end,
})

local ts_configs = require("nvim-treesitter.configs")
ts_configs.setup({
	auto_install = true,
	sync_install = true,
	ignore_install = {},
	ensure_installed = {
		"astro",
		"c",
		"cmake",
		"cpp",
		"css",
		"diff",
		"dockerfile",
		"elm",
		"git_config",
		"git_rebase",
		"gitcommit",
		"gitignore",
		"go",
		"graphql",
		"hack",
		"haskell",
		"html",
		"htmldjango",
		"hurl",
		"java",
		"javascript",
		"jsdoc",
		"json",
		"json5",
		"jsonc",
		"kotlin",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"mermaid",
		"nix",
		"objc",
		"ocaml",
		"perl",
		-- "pkl",
		"php",
		"phpdoc",
		"prisma",
		"proto",
		"pymanifest",
		"python",
		"requirements",
		"rst",
		"ruby",
		"rust",
		"scala",
		"scss",
		"sql",
		"svelte",
		"swift",
		"terraform",
		"toml",
		"typescript",
		"vim",
		"vimdoc",
		"vue",
		"xml",
		"yaml",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})

-- from https://github.com/pwntester/octo.nvim#-installation
vim.treesitter.language.register("markdown", "octo")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 10
vim.opt.foldminlines = 3

require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
	local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
	local filename = vim.fn.fnamemodify(filepath, ":t")

    if string.match(filepath, "mise/config.toml$") ~= nil then
        return true
    end

    if string.match(filename, "mise.toml$") ~= nil then
        return true
    end

	return string.match(filename, ".*mise.*%.toml$") ~= nil
end, { force = true, all = false })
