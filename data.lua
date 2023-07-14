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
local function create_input(name, game_control, key_sequence, alternative_key_sequence)
	return {
		type = "custom-input",
		name = "matrixdj96_" .. name,
		linked_game_control = game_control,
		key_sequence = key_sequence or "",
		alternative_key_sequence = alternative_key_sequence or ""
	}
end

local custom_sprites = {}
local custom_inputs = {}

if mods["manual-inventory-sort"] then
	-- Generate custom sprite for manual-inventory-sort
	table.insert(custom_sprites, create_sprite("trash_icon", "icons/trash"))
end

if mods["train-log"] then
	-- Generate custom sprite for train-log
	table.insert(custom_sprites, create_sprite("train_log_icon", "icons/locomotive", "__base__"))

	if mods["GUI_Unifyer"] then
		-- Update existing sprite definition with new one
		data:extend({ clone_sprite(custom_sprites[#custom_sprites], "trainlog_button") })
	end
end

if mods["TaskList"] then
	-- Generate custom sprite for TaskList
	table.insert(custom_sprites, create_sprite("task_list_icon", "icons/task_list"))
end

if mods["Todo-List"] then
	-- Generate custom sprite form Todo-List
	table.insert(custom_sprites, create_sprite("todo_list_icon", "icons/todo_list"))

	if mods["GUI_Unifyer"] then
		-- Update existing sprite definition with new one
		data:extend({ clone_sprite(custom_sprites[#custom_sprites], "todolist_button") })
	end
end

if mods["YARM"] and not mods["GUI_Unifyer"] then
	-- Generate custom sprite for YARM
	local yarm_icon = create_sprite(
		"yarm_icon",
		"resource-monitor",
		"__YARM__"
	)

	yarm_icon.width = 32
	yarm_icon.height = 32

	table.insert(custom_sprites, yarm_icon)
end

-- Generate custom inputs
table.insert(custom_inputs, create_input("move_up", "move-up"))
table.insert(custom_inputs, create_input("move_down", "move-down"))
table.insert(custom_inputs, create_input("move_left", "move-left"))
table.insert(custom_inputs, create_input("move_right", "move-right"))

table.insert(custom_inputs, create_input("speed_up", "", "ALT + PLUS", "ALT + KP_PLUS"))
table.insert(custom_inputs, create_input("speed_down", "", "ALT + MINUS", "ALT + KP_MINUS"))

for i = 1, 9 do
	table.insert(custom_inputs, create_input("speed_" .. i, "", "ALT + " .. i, "ALT + KP_" .. i))
end

-- Add custom sprites to data
data:extend(custom_sprites)

-- Add custom inputs to data
data:extend(custom_inputs)
