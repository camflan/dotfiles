local utils = require("utils.pack")

vim.pack.add({
    { src = "https://github.com/justinsgithub/wezterm-types" },
    { src = "https://github.com/folke/lazydev.nvim" }
}, {
        load = function (o)
            if o.spec.name == "lazydev.nvim" then
                utils.load_on_filetype("lua", function ()
                    local lazydev = require("lazydev")

                    lazydev.setup({
                        library = {
                            -- See the configuration section for more details
                            -- Load luvit types when the `vim.uv` word is found
                            { path = "${3rd}/luv/library", words = { "vim%.uv" } },

                            -- Plugins
                            -- { "nvim-dap-ui" },
                            -- Load the wezterm types when the `wezterm` module is required
                            -- Needs `justinsgithub/wezterm-types` to be installed
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
