local mod_gui = require("__core__.lualib.mod-gui")
local constants = require("constants")

local player_data = {}

local has_inventory_opened = function(player)
	if player.opened_self then
		return true
	end
	if player.opened and player.opened.valid and (player.opened.object_name == "LuaEntity") then
		return player.opened.get_output_inventory() or player.opened.get_module_inventory() or player.opened.get_fuel_inventory()
	end
end

function player_data.fix_manual_inventory_sort(player)
	if not has_inventory_opened(player) then
		if player.gui.left["manual-inventory-sort-buttons"] then
			player.gui.left["manual-inventory-sort-buttons"].destroy()
			-- player.print(serpent.block("fix_manual_inventory_sort"))
		end
	end
end

function player_data.fix_todo_list(player)
	local button_flow = mod_gui.get_button_flow(player)

	if button_flow.todo_maximize_button then
		if button_flow.todo_maximize_button.type == "button" then
			button_flow.todo_maximize_button.destroy()
			button_flow.add(
				{
					type = "sprite-button",
					style = "mod_gui_button",
					sprite = "matrixdj96_todo_list_icon",
					name = "todo_maximize_button",
					tooltip = "Todo List"
				}
			)
		else
			button_flow.todo_maximize_button.caption = ""
		end
		-- player.print(serpent.block("fix_todo_list"))
	end
end

function player_data.fix_train_log(player)
	local button_flow = mod_gui.get_button_flow(player)

	if button_flow.train_log then
		button_flow.train_log.sprite = "matrixdj96_train_log_icon"
		button_flow.train_log.style = "mod_gui_button"
		-- player.print(serpent.block("fix_train_log"))
	end
end

function player_data.fix_all(player)
	player_data.fix_manual_inventory_sort(player)
	player_data.fix_todo_list(player)
	player_data.fix_train_log(player)
end

function player_data.copy_player(from_player, to_player)
	for _, index in ipairs(constants.character_inventories) do
		local to_inventory = to_player.get_inventory(index)
		local from_inventory = from_player.get_inventory(index)

		to_inventory.clear()

		for i = 1, #from_inventory do
			to_inventory.insert(from_inventory[i])
			if from_inventory.supports_filters() then
				local filter = from_inventory.get_filter(i)
				if filter then
					to_inventory.set_filter(i, filter)
				end
			end
		end
	end

	for i = 1, 1000 do
		to_player.set_personal_logistic_slot(i, from_player.get_personal_logistic_slot(i))
	end

	for i = 1, 100 do
		to_player.set_quick_bar_slot(i, from_player.get_quick_bar_slot(i))
	end
end

return player_data
