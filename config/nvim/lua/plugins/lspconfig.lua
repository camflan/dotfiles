local borders = require("utils.borders")

---@return nil
return function()
    -- Diagnostics (work without LSP, run immediately)
    vim.diagnostic.config({
        float = {
            border = borders.rounded,
            severity_sort = true,
            source = "if_many",
        },
        severity_sort = true,
        virtual_text = false,
    })

    vim.keymap.set("n", "<leader>j", "<cmd>lua vim.diagnostic.jump({ count = 1 })<CR>", { desc = "Next diagnostic" })
    vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.jump({ count = -1 })<CR>", { desc = "Prev diagnostic" })
    vim.keymap.set("n", "<leader>u", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Diagnostic float" })

    -- Enable LSP servers (configs come from lsp/*.lua, schemastore must be loaded)
    vim.lsp.enable({
        "astro",
        "eslint",
        "expert",
        "gopls",
        "graphql",
        "intelephense",
        "jsonls",
        "laravel_ls",
        "lua_ls",
        "openscad_lsp",
        "tailwindcss",
        "taplo",
        "terraformls",
        "vtsls",
        "yamlls",
    })

    -- Python LSPs: checked per buffer so project-local venv tools are found.
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        group = vim.api.nvim_create_augroup("python_lsp", { clear = true }),
        callback = function(ev)
            ---@type table[]
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
                    { server = "ty",      cmd = "ty" },
                    { server = "pyre",    cmd = "pyre" },
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

    -- Defer heavy plugin setups to first LspAttach
    ---@type boolean
    local plugins_loaded = false
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
            local bufnr = ev.buf

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

            if not plugins_loaded then
                plugins_loaded = true
                require("fastaction").setup({})
                require("fidget").setup({})
                require("tsc").setup({
                    use_diagnostics = true,
                    use_trouble_qflist = true,
                })
                require("wtf").setup({
                    provider = "ollama",
                    providers = {
                        ollama = {
                            api_key = "TERM",
                            model_id = "qwen2.5-coder:7b"
                        }
                    },
                })
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                    callback = function()
                        vim.keymap.set({ "n" }, "<leader>dT", "<cmd>TSC<cr>", { desc = "Open TSC issues" })
                    end,
                })
            end
        end,
    })
end
