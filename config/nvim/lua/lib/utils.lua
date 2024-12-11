return {
  make_is_enabled_predicate = function(value)
    ---@type fun(plugin:LazyPlugin, opts: table):boolean
    local is_enabled_predicate = function(plugin, opts)
      local is_enabled = plugin.name == value
      return is_enabled
    end

    return is_enabled_predicate
  end,
}
