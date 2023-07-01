local events = require("__flib__.event")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

events.on_init(
	function()
		for _, player in pairs(game.players) do
			player_data.fix_all(player, true)
		end
	end
)

events.on_configuration_changed(
	function()
		for _, player in pairs(game.players) do
			player_data.fix_all(player, true)
		end
	end
)

events.register(
	constants.player_events,
	function(e)
		player_data.fix_all(game.players[e.player_index], true)
	end
)

events.register(
	constants.gui_events,
	function(e)
		local player = game.players[e.player_index]

		global_data.tick_functions.manual_inventory_sort = function()
			player_data.fix_manual_inventory_sort(player)
			global_data.tick_functions.manual_inventory_sort = nil
			-- player.print(serpent.block("manual_inventory_sort"))
		end

		global_data.tick_functions.task_list = function()
			player_data.fix_task_list(player)
			global_data.tick_functions.task_list = nil
			-- player.print(serpent.block("task_list"))
		end

		player_data.toggle_task_list(player, e.element)
	end
)

events.on_nth_tick(
	1,
	function()
		for _, fnctn in pairs(global_data.tick_functions) do
			fnctn()
		end
	end
)
