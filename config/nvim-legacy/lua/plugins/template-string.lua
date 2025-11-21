-- FTs where this plugin is enabled
local filetypes =
  { "html", "typescript", "javascript", "typescriptreact", "javascriptreact", "vue", "svelte", "python", "cs" }

return {
  {
    "axelvc/template-string.nvim",
    ft = filetypes,
    event = { "InsertEnter" },
    opts = {
      filetypes = filetypes,
      jsx_brackets = true, -- must add brackets to jsx attributes
      remove_template_string = true, -- remove backticks when there are no template string
      restore_quotes = {
        -- quotes used when "remove_template_string" option is enabled
        normal = [[']],
        jsx = [["]],
      },
    },
  },
}
