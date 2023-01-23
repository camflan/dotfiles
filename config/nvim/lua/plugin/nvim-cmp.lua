local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.confirm({ select = true })
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'path' },
        {
            name = 'buffer',
            option = {
                keyword_length = 3,
                indexing_interval = 1000,
                -- limit scanned files by filesize
                get_bufnrs = function()
                    local buf = vim.api.nvim_get_current_buf()
                    local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))

                    if byte_size > 1024 * 512 then -- 512kb max
                        return {}
                    end

                    return { buf }
                end
            }
        },
    })
})
