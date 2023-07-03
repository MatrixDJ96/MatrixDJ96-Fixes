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
local todo_list_icon = create_sprite("todo_list_icon", "icons/todo_list")
local trash_icon = create_sprite("trash_icon", "icons/trash")

-- Add custom sprites to data
data:extend({ task_list_icon, todo_list_icon, trash_icon })

-- Check if GUI_Unifyer is installed
if mods["GUI_Unifyer"] then
	-- Check if todolist_button exists
	if data.raw["sprite"]["todolist_button"] then
		-- Deepcopy of todo_list_icon to allow changes
		local guiu_todo_list_icon = table.deepcopy(todo_list_icon)
		-- Change name to match the GUI_Unifyer's one
		guiu_todo_list_icon.name = "todolist_button"
		-- Update existing sprite definition
		data:extend({ guiu_todo_list_icon })
	end
end
