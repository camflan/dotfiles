vim.pack.add({
    { src = "https://github.com/axelvc/template-string.nvim" }
})

require("template-string").setup({
    jsx_brackets = true, -- must add brackets to jsx attributes
    remove_template_string = true, -- remove backticks when there are no template string
    restore_quotes = {
        -- quotes used when "remove_template_string" option is enabled
        normal = [[']],
        jsx = [["]],
    },
})
