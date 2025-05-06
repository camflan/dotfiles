local table = {}

---@param a table | nil
---@param b table | nil
---@return table
table.assign = function(a, b)
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

return table
