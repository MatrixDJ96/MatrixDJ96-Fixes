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
			player_data.fix_all(game.players[e.player_index], true)
		end
	)
end

for i = 1, #constants.gui_events do
	script.on_event(
		constants.gui_events[i],
		function(e)
			local player = game.players[e.player_index]

			global_data.tick_functions.manual_inventory_sort = function()
				player_data.fix_manual_inventory_sort(player)
				global_data.tick_functions.manual_inventory_sort = nil
			end

			global_data.tick_functions.task_list = function()
				player_data.fix_task_list(player)
				global_data.tick_functions.task_list = nil
			end

			player_data.toggle_task_list(player, e.element)
		end
	)
end

script.on_event(
	defines.events.on_string_translated,
	function(e)
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
