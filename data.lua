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

---@param sprite table
---@param name string
---@return table
local function clone_sprite(sprite, name)
	-- Deepcopy of sprite to allow changes
	local cloned_sprite = table.deepcopy(sprite)
	-- Change name to requested one
	cloned_sprite.name = name

	return cloned_sprite
end

-- Generate custom sprites
local task_list_icon = create_sprite("task_list_icon", "icons/task_list")
local todo_list_icon = create_sprite("todo_list_icon", "icons/todo_list")
local train_log_icon = create_sprite("train_log_icon", "icons/locomotive", "__base__")
local trash_icon = create_sprite("trash_icon", "icons/trash")

-- Add custom sprites to data
data:extend({ task_list_icon, todo_list_icon, train_log_icon, trash_icon })

-- Check if GUI_Unifyer is installed
if mods["GUI_Unifyer"] then
	-- Check if todolist_button exists
	if data.raw["sprite"]["todolist_button"] then
		-- Update existing sprite definition with new one
		data:extend({ clone_sprite(todo_list_icon, "todolist_button") })
	end

	-- Check if trainlog_button exists
	if data.raw["sprite"]["trainlog_button"] then
		-- Update existing sprite definition with new one
		data:extend({ clone_sprite(train_log_icon, "trainlog_button") })
	end
end
