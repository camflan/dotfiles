vim.pack.add(
    {
        { src = "https://github.com/nvim-lua/plenary.nvim" },
        { src = "https://github.com/rafamadriz/friendly-snippets" },
        { src = "https://github.com/milanglacier/minuet-ai.nvim" },
        { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") }
    },
    {
        load = true
    })


---@enum  LlmModelName
local models = {
    codestral = "codestral:22b",
  codegemma_code = "codegemma:7b-code",
  deepseekr1 = "deepseek-r1:14b",
  devstral = "devstral:24b",
  gemma3 = "gemma3:4b-it-q4_K_M",
  gemma3n = "gemma3n:e4b",
  gpt_oss_large = "gpt-oss:120b",
  gpt_oss_small = "gpt-oss:20b",
  llama32 = "llama3.2:latest",
  llama4scout = "llama4:scout",
  mistral = "mistral:7b",
  qwen25coder = "qwen2.5-coder:7b",
  qwen25coder_huge = "qwen2.5-coder:32b",
  qwen25coder_small = "qwen2.5-coder:1.5b",
  qwen3 = "qwen3:30b",
  qwen3coder = "qwen3-coder:latest",
  qwen3coder_30b_q3 = "hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q3_K_XL",
  qwen3coder_30b_q8 = "hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q8_K_XL",
  sqlcoder = "sqlcoder:latest",
}

local default_blink_sources = {
    -- "lazydev",
    "lsp",
    "minuet",
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


local minuet_request_timeout_seconds = 10

require("minuet").setup({
    provider = "openai_fim_compatible",
    n_completions = 3, -- recommend for local model for resource saving
    context_window = 16000,
    context_ratio = 0.7,
    request_timeout = minuet_request_timeout_seconds,
    provider_options = {
        openai_fim_compatible = {
            api_key = "TERM",
            name = "Ollama",
            end_point = "http://localhost:11434/v1/completions",
            model = models.qwen25coder_small,
        },
    },
})

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
                timeout_ms = minuet_request_timeout_seconds * 1000,
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
