local borders = require("utils.borders")

vim.pack.add(
    {
        { src = "https://github.com/Chaitanyabsprip/fastaction.nvim" },
        { src = "https://github.com/MunifTanjim/nui.nvim", },
        { src = "https://github.com/b0o/schemastore.nvim" },
        { src = "https://github.com/dmmulroy/tsc.nvim" },
        { src = "https://github.com/j-hui/fidget.nvim" },
        { src = "https://github.com/marilari88/twoslash-queries.nvim" },
        { src = "https://github.com/neovim/nvim-lspconfig" },
        { src = "https://github.com/nvim-lua/plenary.nvim", },
        { src = "https://github.com/piersolenski/wtf.nvim" },
    },
    { load = true }
)

require("fastaction").setup({})
require("fidget").setup({})
require("tsc").setup({
    use_diagnostics = true,
    use_trouble_qflist = true,
})

require("wtf").setup({
    -- Directory for storing chat files
    -- chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/wtf/chats",
    -- Default AI popup type
    -- popup_type = "popup" | "horizontal" | "vertical",
    -- The default provider
    provider = "ollama", -- "anthropic" | "copilot" | "deepseek" | "gemini" | "grok" | "ollama" | "openai",
    -- Configure providers
    providers = {
        ollama = {
            api_key = "TERM",
            model_id = "qwen2.5-coder:7b"
        }
        -- anthropic = {
        --   -- An alternative way to set your API key
        --   api_key = "32lkj23sdjke223ksdlfk" | function() os.getenv("API_KEY") end,
        --   -- Your preferred model
        --   model_id = "claude-3-5-sonnet-20241022",
        -- },
    },
    -- Set your preferred language for the response
    -- language = "english",
    -- Any additional instructions
    -- additional_instructions = "Start the reply with 'OH HAI THERE'",
    -- Default search engine, can be overridden by passing an option to WtfSeatch
    -- search_engine = "google" | "duck_duck_go" | "stack_overflow" | "github" | "phind" | "perplexity",
    -- Callbacks
    -- hooks = {
    --   request_started = nil,
    --   request_finished = nil,
    -- },
    -- Add custom colours
    -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    callback = function()
        vim.keymap.set({ "n" }, "<leader>dT", "<cmd>TSC<cr>", {
            desc = "Open TSC issues"
        })
    end,
})

vim.diagnostic.config({
    float = {
        border = borders.rounded,
        severity_sort = true,
        source = "if_many",
    },
    severity_sort = true,
    virtual_text = false,
})

-- Diagnostic keybindings (work without LSP)
vim.keymap.set("n", "<leader>j", "<cmd>lua vim.diagnostic.jump({ count = 1 })<CR>", { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.jump({ count = -1 })<CR>", { desc = "Prev diagnostic" })
vim.keymap.set("n", "<leader>u", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Diagnostic float" })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local bufnr = ev.buf

        -- overwrites omnifunc/tagfunc set by some Python plugins to the
        -- default values for LSP
        vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
        vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })

        vim.keymap.set(
            { "n", "x" },
            "<leader>da",
            '<cmd>lua require("fastaction").code_action()<CR>',
            { desc = "Code actions (fastaction)", buffer = bufnr }
        )
        vim.keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>",
            { desc = "Go to type definition", buffer = bufnr })
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ border = borders.rounded })
        end, { desc = "Hover", buffer = bufnr })
    end,
})

vim.lsp.enable({
    "astro",
    -- "elixirls",
    "eslint",
    "expert", -- next gen elixir lang server
    "gopls",
    "graphql",
    "intelephense",
    "jsonls",
    "laravel_ls",
    "lua_ls",
    "tailwindcss",
    "taplo",
    "terraformls",
    "vtsls",
    "yamlls",
})

-- Python LSPs: checked per buffer so project-local venv tools are found.
-- Enables first available type checker only.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    group = vim.api.nvim_create_augroup("python_lsp", { clear = true }),
    callback = function(ev)
        local clients = vim.lsp.get_clients({ bufnr = ev.buf })
        local has_type_checker = false
        local has_ruff = false
        for _, client in ipairs(clients) do
            if vim.tbl_contains({ "ty", "pyre", "pyright" }, client.name) then
                has_type_checker = true
            elseif client.name == "ruff" then
                has_ruff = true
            end
        end

        if not has_type_checker then
            for _, checker in ipairs({
                { server = "ty", cmd = "ty" },
                { server = "pyre", cmd = "pyre" },
                { server = "pyright", cmd = "pyright-langserver" },
            }) do
                if vim.fn.executable(checker.cmd) == 1 then
                    vim.lsp.enable(checker.server)
                    break
                end
            end
        end

        if not has_ruff and vim.fn.executable("ruff") == 1 then
            vim.lsp.enable("ruff")
        end
    end,
})
