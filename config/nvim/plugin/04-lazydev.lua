local utils = require("utils.pack")

utils.ensure_installed({
    { src = "https://github.com/justinsgithub/wezterm-types" },
})

vim.pack.add({
    { src = "https://github.com/folke/lazydev.nvim" }
}, {
        load = function (o)
            if o.spec.name == "lazydev.nvim" then
                utils.load_on_filetype("lua", function ()
                    local lazydev = require("lazydev")

                    lazydev.setup({
                        library = {
                            { path = "${3rd}/luv/library", words = { "vim%.uv" } },

                            -- Plugins
                            -- { "nvim-dap-ui" },
                            { path = "wezterm-types", mods = { "wezterm" } },
                        },
                    })

                    vim.lsp.enable('lua_ls')
                    vim.lsp.config('lua_ls', { root_dir = function(bufnr, on_dir) on_dir(lazydev.find_workspace(bufnr)) end })
                end
                )(o.spec)
            end
        end
    }
)
