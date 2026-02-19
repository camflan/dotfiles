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

                end
                )(o.spec)
            end
        end
    }
)
