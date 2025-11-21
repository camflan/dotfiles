-- vim.pack.add({
--     {
--         name = "monet",
--         src = "https://github.com/fynnfluegge/monet.nvim",
--     },
-- })
--
-- require("monet").setup({
--     styles = {
--         strings = {}
--     },
--     transparent_background = false,
-- })
--
-- vim.cmd([[colorscheme monet]])


vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" }
})
require("tokyonight").setup({})
vim.cmd([[colorscheme tokyonight]])


