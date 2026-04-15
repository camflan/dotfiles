---@return nil
return function()
    ---@type string[]
    local default_blink_sources = {
        "lsp",
        "path",
        "snippets",
        "buffer",
    }

    ---@type table<string, string[]>
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

        keymap = { preset = "default" },

        appearance = {
            use_nvim_cmp_as_default = true,
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

        sources = {
            default = function()
                ---@type string[]|nil
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
                    score_offset = 100,
                },
            },

            min_keyword_length = function(ctx)
                if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                    return 2
                end

                return 0
            end,
        },
    })
end
