---@param name string
---@param path string
---@return table
local function create_sprite(name, path, prefix)
	-- Check if prefix is nil
	if prefix == nil then
		-- Set default prefix to mod name
		prefix = "__MatrixDJ96-Fixes__"
	end

	-- Create sprite definition
	return {
		type = "sprite",
		name = "matrixdj96_" .. name,
		filename = prefix .. "/graphics/" .. path .. ".png",
		flags = { "linear-minification", "linear-magnification" },
		width = 64,
		height = 64
	}
end

-- Generate custom sprites
local task_list_icon = create_sprite("task_list_icon", "icons/task_list")
local trash_icon = create_sprite("trash_icon", "icons/trash")

-- Add custom sprites to data
data:extend({ task_list_icon, trash_icon })

