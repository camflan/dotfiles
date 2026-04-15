---@return nil
return function()
    local conform = require("conform")

    conform.setup({
        formatters_by_ft = {
            javascript = { "biome", "prettier", stop_after_first = true },
            javascriptreact = { "biome", "prettier", stop_after_first = true },
            typescript = { "biome", "prettier", stop_after_first = true },
            typescriptreact = { "biome", "prettier", stop_after_first = true },
            json = { "biome", "prettier", stop_after_first = true },

            python = function(bufnr)
                if conform.get_formatter_info("ruff_format", bufnr).available then
                    return { "ruff_format", "ruff_fix" }
                else
                    return { "isort", "black", "ssort" }
                end
            end,

            lua = { "stylua" },
            go = { "gofmt" },
            rust = { "rustfmt" },
            terraform = { "terraform_fmt" },
            yaml = { "yamlfmt" },
            markdown = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            graphql = { "prettier" },

            ["_"] = { "trim_whitespace" },
        },

        format_on_save = function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end

            return {
                timeout_ms = 500,
                lsp_format = "fallback",
            }
        end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>F", function()
        conform.format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format buffer/selection" })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
            vim.b.disable_autoformat = true
        else
            vim.g.disable_autoformat = true
        end
    end, {
        desc = "Disable format-on-save (use ! for buffer only)",
        bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
    end, {
        desc = "Enable format-on-save",
    })

    vim.api.nvim_create_user_command("FormatInfo", function()
        require("conform").formatters_by_ft()
    end, {
        desc = "Show available formatters for current filetype",
    })
end
