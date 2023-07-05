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

---@param name string
---@param game_control string
local function create_linked_input(name, game_control)
	return {
		type = "custom-input",
		name = "matrixdj96_" .. name,
		linked_game_control = game_control,
		key_sequence = ""
	}
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

-- Generate custom inputs
local move_up_input = create_linked_input("move_up", "move-up")
local move_down_input = create_linked_input("move_down", "move-down")
local move_left_input = create_linked_input("move_left", "move-left")
local move_right_input = create_linked_input("move_right", "move-right")

-- Add custom inputs to data
data:extend({ move_up_input, move_down_input, move_left_input, move_right_input })
