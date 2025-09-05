local M = {}

M.flatten_unique = function(input, output)
  output = output or {}
  for _, value in pairs(input) do
    if type(value) == "table" then
      M.flatten_unique(value, output)
    else
      local found = false
      for _, v in pairs(output) do
        if v == value then
          found = true
          break
        end
      end
      if not found then
        table.insert(output, value)
      end
    end
  end
  return output
end

---@param a table | nil
---@param b table | nil
---@return table
M.assign = function(a, b)
  local result = {}

  if a then
    for k, v in pairs(a) do
      result[k] = v
    end
  end

  if b then
    for k, v in pairs(b) do
      result[k] = v
    end
  end

  return result
end

---@param t table | nil
M.keys = function(t)
  if t == nil then
    return {}
  end

  local k = {}

  for key, _ in ipairs(t) do
    table.insert(k, key)
  end

  return k
end

---@param t table | nil
M.values = function(t)
  if t == nil then
    return {}
  end

  local v = {}

  for _, value in ipairs(t) do
    table.insert(v, value)
  end

  return v
end

---@param a table | nil
---@param b table | nil
---@param ensure_unique boolean | nil
M.concat = function(a, b, ensure_unique)
  local make_unique = ensure_unique or false
  local v = {}

  for _, value in ipairs(a or {}) do
    table.insert(v, value)
  end

  for _, value in ipairs(b or {}) do
    if make_unique then
      if M.includes(v, value) then
        goto continue
      end
    end

    table.insert(v, value)

    ::continue::
  end

  return v
end

---@param t table
---@param needle string | number
M.includes = function(t, needle)
  for _, value in ipairs(t) do
    if value == needle then
      return true
    end
  end

  return false
end

---@generic T, K, V {[K]: V}
---@param t T
---@param condition fun(key: K, value: V): boolean
M.filter = function(t, condition)
  local new_tbl = {}

  for k, v in ipairs(t) do
    if condition(k, v) then
      new_tbl[k] = v
    end
  end

  return new_tbl
end

---@param t table
---@param values table
M.without_values = function(t, values)
  local values_set = {}

  for _, v in ipairs(values) do
    values_set[v] = true
  end

  return M.filter(t, function(_, value)
    if values_set[value] then
      return false
    else
      return true
    end
  end)
end

M.print = function(tbl, indent)
  indent = indent or 0
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      M.print(v, indent + 1)
    else
      print(formatting .. tostring(v))
    end
  end
end

return M
