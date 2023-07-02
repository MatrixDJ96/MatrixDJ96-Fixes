local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

script.on_init(
	function()
		for _, player in pairs(game.players) do
			player_data.remove_yarm_background_toggle(player)
			player_data.add_task_list_button(player, true)
		end
	end
)

script.on_configuration_changed(
	function()
		for _, player in pairs(game.players) do
			player_data.remove_yarm_background_toggle(player)
			player_data.add_task_list_button(player, true)
		end
	end
)

for i = 1, #constants.player_events do
	script.on_event(
		constants.player_events[i],
		function(e)
			local player = game.players[ e.player_index --[[@as uint]] ]

			player_data.remove_yarm_background_toggle(player)
			player_data.add_task_list_button(player, true)
		end
	)
end

for i = 1, #constants.gui_events do
	script.on_event(
		constants.gui_events[i],
		function(e)
			local player = game.players[ e.player_index --[[@as uint]] ]

			-- Remove YARM background toggle visibility
			player_data.remove_yarm_background_toggle(player)

			-- Fix the manual-inventory-sort mod
			player_data.fix_manual_inventory_sort(player)

			-- Handle task-list button click event (if related element exists)
			player_data.toggle_task_list(player, e.element --[[@as LuaGuiElement?]])
		end
	)
end

script.on_event(
	defines.events.on_string_translated,
	function(e)
		-- Apply the tooltip translation to manual-inventory-sort buttons
		player_data.translate_manual_inventory_sort_tooltip(game.players[e.player_index], e.id, e.result)
	end
)
