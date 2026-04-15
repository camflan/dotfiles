---@type PackSpec[]
return {
    -- Colorscheme (load first)
    { src = "https://github.com/folke/tokyonight.nvim", setup = require("plugins.colorscheme") },

    -- Statusline
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-lualine/lualine.nvim", deps = { "nvim-web-devicons" }, event = "ColorScheme", setup = require("plugins.statusline") },

    -- Treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", setup = require("plugins.treesitter") },

    -- LSP
    { src = "https://github.com/Chaitanyabsprip/fastaction.nvim" },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/b0o/schemastore.nvim" },
    { src = "https://github.com/dmmulroy/tsc.nvim" },
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = "https://github.com/marilari88/twoslash-queries.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/piersolenski/wtf.nvim" },
    {
        src = "https://github.com/neovim/nvim-lspconfig",
        deps = { "fastaction.nvim", "nui.nvim", "schemastore.nvim", "tsc.nvim", "fidget.nvim", "twoslash-queries.nvim", "plenary.nvim", "wtf.nvim" },
        setup = require("plugins.lspconfig"),
    },

    -- Lazydev (lua filetype only)
    { src = "https://github.com/justinsgithub/wezterm-types" },
    {
        src = "https://github.com/folke/lazydev.nvim",
        deps = { "wezterm-types" },
        ft = "lua",
        setup = function()
            require("lazydev").setup({
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    { path = "wezterm-types", mods = { "wezterm" } },
                },
            })
        end,
    },

    -- Conform (formatting)
    { src = "https://github.com/stevearc/conform.nvim", setup = require("plugins.conform") },

    -- Completion
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/milanglacier/minuet-ai.nvim" },
    {
        src = "https://github.com/saghen/blink.cmp",
        version = "v1",
        build = "cargo build --release",
        build_output = "target/release/libblink_cmp_fuzzy.dylib",
        deps = { "plenary.nvim", "friendly-snippets", "minuet-ai.nvim" },
        event = { "InsertEnter", "CmdlineEnter" },
        setup = require("plugins.blink"),
    },

    -- Fuzzy finder
    { src = "https://github.com/ibhagwan/fzf-lua", event = "UIEnter", setup = require("plugins.fzf") },

    -- Git
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/tpope/vim-rhubarb" },
    { src = "https://github.com/lewis6991/gitsigns.nvim", setup = function() require("gitsigns").setup() end },

    -- Navigation
    { src = "https://github.com/mrjones2014/smart-splits.nvim", setup = require("plugins.smart-splits") },
    {
        src = "https://github.com/smoka7/hop.nvim",
        setup = function()
            require("hop").setup({})
            vim.keymap.set({ "n" }, "<leader>w", "<cmd>HopWord<cr>", { desc = "Hop to a word" })
            vim.keymap.set({ "n" }, "<leader>hW", "<cmd>HopChar2MW<cr>", { desc = "Hop to bigram in any window" })
            vim.keymap.set({ "n" }, "<leader>hl", "<cmd>HopLineStart<cr>", { desc = "Hop to a line" })
            vim.keymap.set({ "n" }, "<leader>hw", "<cmd>HopWordMW<cr>", { desc = "Hop to a word in any window" })
        end,
    },

    -- Editing
    { src = "https://github.com/windwp/nvim-autopairs", setup = function() require("nvim-autopairs").setup({ check_ts = true }) end },
    {
        src = "https://github.com/windwp/nvim-ts-autotag",
        setup = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = true,
                },
            })
        end,
    },
    { src = "https://github.com/kylechui/nvim-surround", setup = function() require("nvim-surround").setup({}) end },
    {
        src = "https://github.com/mizlan/iswap.nvim",
        setup = function()
            require("iswap").setup()
            vim.keymap.set({ "n" }, "<leader>s", "<cmd>ISwap<CR>", { desc = "Swap arguments" })
        end,
    },
    {
        src = "https://github.com/axelvc/template-string.nvim",
        setup = function()
            require("template-string").setup({
                jsx_brackets = true,
                remove_template_string = true,
                restore_quotes = {
                    normal = [[']],
                    jsx = [["]],
                },
            })
        end,
    },
    {
        src = "https://github.com/AndrewRadev/switch.vim",
        pre = function()
            vim.g.switch_custom_definitions = {
                { "attach", "detach" },
                { "enabled", "disabled" },
            }
        end,
    },

    -- Debug logging
    {
        src = "https://github.com/chrisgrieser/nvim-chainsaw",
        setup = function()
            require("chainsaw").setup({ marker = "🪵" })
            vim.keymap.set({ "n" }, "gli", "<cmd>Chainsaw typeLog<cr>")
            vim.keymap.set({ "n" }, "glm", "<cmd>Chainsaw messageLog<cr>")
            vim.keymap.set({ "n" }, "glo", "<cmd>Chainsaw objectLog<cr>")
            vim.keymap.set({ "n" }, "glt", "<cmd>Chainsaw timeLog<cr>")
        end,
    },

    -- UI
    { src = "https://github.com/folke/todo-comments.nvim", setup = function() require("todo-comments").setup() end },
    {
        src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
        setup = function() require("render-markdown").setup({ heading = { width = "full" } }) end,
    },
    {
        src = "https://github.com/mbbill/undotree",
        setup = function()
            vim.keymap.set({ "n" }, "<leader>oU", "<cmd>UndotreeToggle<CR>", { desc = "Show UndoTree" })
        end,
    },
    { src = "https://github.com/vieitesss/command.nvim", setup = function() require("command").setup() end },

    -- Find and replace
    {
        src = "https://github.com/MagicDuck/grug-far.nvim",
        deps = { "nvim-web-devicons" },
        setup = function() require("grug-far").setup({}) end,
    },

    -- Tpope essentials
    { src = "https://github.com/tpope/vim-abolish" },
    { src = "https://github.com/tpope/vim-characterize" },
    { src = "https://github.com/tpope/vim-repeat" },
    { src = "https://github.com/tpope/vim-rsi" },
    { src = "https://github.com/tpope/vim-speeddating" },
    { src = "https://github.com/tpope/vim-unimpaired" },
}
