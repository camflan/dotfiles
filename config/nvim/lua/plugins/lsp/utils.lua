return {
  ---given the linter- and formatter-list of nvim-lint and conform.nvim, extract a
  ---list of all tools that need to be auto-installed
  ---@param my_lsps object[]
  ---@param my_linters object[]
  ---@param my_formatters object[]
  ---@param my_debuggers string[]
  ---@param tools_to_ignore string[]
  ---@return string[] tools
  ---@nodiscard
  tools_to_auto_install = function(my_lsps, my_linters, my_formatters, my_debuggers, tools_to_ignore)
    -- get all linters, formatters, & debuggers and merge them into one list
    local lsp_list = vim.tbl_flatten(vim.tbl_values(my_lsps))
    local linter_list = vim.tbl_flatten(vim.tbl_values(my_linters))
    local tools = vim.list_extend(lsp_list, linter_list)

    local formatter_list = vim.tbl_flatten(vim.tbl_values(my_formatters))
    vim.list_extend(tools, formatter_list)
    vim.list_extend(tools, my_debuggers)

    -- only unique tools
    table.sort(tools)
    tools = vim.fn.uniq(tools)

    -- remove exceptions not to install
    tools = vim.tbl_filter(function(tool)
      return not vim.tbl_contains(tools_to_ignore, tool)
    end, tools)

    return tools
  end,
}
