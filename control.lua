local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

script.on_init(
	function()
		for _, player in pairs(game.players) do
			player_data.fix_all(player, true)
		end
	end
)

script.on_configuration_changed(
	function()
		for _, player in pairs(game.players) do
			player_data.fix_all(player, true)
		end
	end
)

for i = 1, #constants.player_events do
	script.on_event(
		constants.player_events[i],
		function(e)
			player_data.fix_all(game.players[ e.player_index --[[@as uint]] ], true)
		end
	)
end

for i = 1, #constants.gui_events do
	script.on_event(
		constants.gui_events[i],
		function(e)
			local player = game.players[ e.player_index --[[@as uint]] ]

			-- Add the tick functions to perform manual-inventory-sort fixes
			global_data.tick_functions.manual_inventory_sort = function()
				-- Fix the manual-inventory-sort mod
				player_data.fix_manual_inventory_sort(player)
				-- Remove the tick function from the global_data
				global_data.tick_functions.manual_inventory_sort = nil
			end

			-- Add the tick functions to perform task-list fixes
			global_data.tick_functions.task_list = function()
				-- Fix the task-list mod
				player_data.fix_task_list(player)
				-- Remove the tick function from the global_data
				global_data.tick_functions.task_list = nil
			end

			-- Handle task-list button click event (if related element exists)
			player_data.toggle_task_list(player, e.element --[[@as LuaGuiElement?]])
		end
	)
end

script.on_event(
	defines.events.on_string_translated,
	function(e)
		-- Apply the tooltip translation to manual-inventory-sort buttons
		player_data.translate_manual_inventory_sort(game.players[e.player_index], e.id, e.result)
	end
)

script.on_nth_tick(
	1,
	function()
		for _, fnctn in pairs(global_data.tick_functions) do
			fnctn()
		end
	end
)
