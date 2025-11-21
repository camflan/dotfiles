vim.pack.add(
    { { src = "https://github.com/stevearc/conform.nvim" } },
    { load = true }
)

local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        -- JavaScript/TypeScript - prefer biome, fallback to prettier
        javascript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "biome", "prettier", stop_after_first = true },

        -- Elixir - mix format is the standard
        elixir = { "mix" },

        -- Other languages
        lua = { "stylua" },
        python = { "ruff_format", "ruff_fix" },
        go = { "gofmt" },
        rust = { "rustfmt" },
        terraform = { "terraform_fmt" },
        yaml = { "yamlfmt" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        graphql = { "prettier" },

        -- Fallback for all files
        ["_"] = { "trim_whitespace" },
    },

    formatters = {
        mix = {
            command = "mix",
            args = { "format", "-" },
            stdin = true,
        },
    },

    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end

        return {
            timeout_ms = 500,
            lsp_fallback = true,
        }
    end,
})

-- Manual format keymap
vim.keymap.set({ "n", "v" }, "<leader>F", function()
    conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer/selection" })

-- Toggle format-on-save commands
vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! disables for current buffer only
        vim.b.disable_autoformat = true
    else
        -- FormatDisable disables globally
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
