---@return nil
return function()
    require("tokyonight").setup({})
    vim.cmd([[colorscheme tokyonight]])
end
