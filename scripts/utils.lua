local utils = {}

--- @param first table
--- @param second table
--- @return table
function utils.insert(first, second)
	local result = {}

	-- Copy first table
	for _, v in pairs(first) do table.insert(result, v) end
	-- Copy second table
	for _, v in pairs(second) do table.insert(result, v) end

	return result
end

--- @param table table
--- @param value any
--- @return boolean
function utils.contains(table, value)
	-- Loop through table
	for _, v in pairs(table) do
		-- Check if value is in table
		if v == value then
			return true
		end
	end

	return false
end

--- @param table table
--- @return uint
function utils.size(table)
	-- Initialize count
	local count = 0

	-- Loop through table
	for _, _ in pairs(table) do
		-- Increment count
		count = count + 1
	end

	return count
end

return utils
