vim.pack.add({
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/milanglacier/minuet-ai.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") }
})

local default_blink_sources = {
    -- "lazydev",
    "lsp",
    -- "minuet",
    "path",
    "snippets",
    "buffer",
}

local blink_sources = {
    default = default_blink_sources,
    terraform = {
        "lsp",
        "path",
        "buffer",
    },
}

require("blink.cmp").setup({
    fuzzy = { 
        implementation = 'prefer_rust',
        prebuilt_binaries = {
            download = true,
            force_version = "1.6.0"
        },
    },

    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = { preset = "default" },

    appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
    },

    completion = {
        accept = {
            auto_brackets = {
                enabled = false,
            },
        },

        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
            window = {
                border = "rounded",
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
            },
        },

        menu = {
            border = "rounded",
            draw = {
                columns = {
                    { "kind_icon" },
                    { "label", "label_description", gap = 1 },
                },
                gap = 2,
                treesitter = { "lsp" },
            },
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None",
        },
    },

    signature = { enabled = true },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
        default = function()
            local filetype_sources = blink_sources[vim.bo.filetype]

            if filetype_sources then
                return filetype_sources
            end

            return blink_sources.default
        end,

        providers = {
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
            },
            minuet = {
                name = "minuet",
                module = "minuet.blink",
                async = true,
                -- Should match minuet.config.request_timeout * 1000,
                -- since minuet.config.request_timeout is in seconds
                timeout_ms = 3000,
                score_offset = 20, -- Gives minuet higher priority among suggestions
            },
        },

        min_keyword_length = function(ctx)
            -- only applies when typing a command, doesn't apply to arguments
            if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 2 -- autocomplete after 2 characters
            end

            return 0
        end,
    },
})
