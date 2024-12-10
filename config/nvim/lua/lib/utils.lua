return {
  make_is_enabled_predicate = function(value)
    ---@type fun(plugin:LazyPlugin):boolean
    local is_enabled_predicate = function(plugin)
      return plugin.name == value
    end

    return is_enabled_predicate
  end,
}
