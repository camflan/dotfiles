---@param command string
---@return string
local get_venv_command = function(command)
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. "/bin/" .. command
  else
    return command
  end
end

return {
  get_venv_command = get_venv_command,

  ---@param value string
  make_is_enabled_predicate = function(value)
    ---@type fun(plugin:LazyPlugin, opts: table):boolean
    local is_enabled_predicate = function(plugin, _)
      local is_enabled = plugin.name == value
      return is_enabled
    end

    return is_enabled_predicate
  end,
}
