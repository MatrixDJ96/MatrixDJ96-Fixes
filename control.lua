local events = require("__flib__.event")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

events.on_init(
	function()
		for _, player in pairs(game.players) do
			player_data.fix_all(player)
		end
	end
)

events.on_configuration_changed(
	function()
		for _, player in pairs(game.players) do
			player_data.fix_all(player)
		end
	end
)

events.register(
	constants.player_events,
	function(e)
		player_data.fix_all(game.players[e.player_index])
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

		global_data.tick_functions.todo_list = function()
			player_data.fix_todo_list(player)
			if not player.gui.screen["todo_main_frame"] and not player.gui.screen["todo_edit_dialog"] then
				global_data.tick_functions.todo_list = nil
			-- player.print(serpent.block("todo_list"))
			end
		end
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

commands.add_command(
	"set_last_user",
	nil,
	function(c)
		if c.player_index then
			local player = game.players[c.player_index]
			local surface = player.surface

			local entity_types = {}

			for _, entity in pairs(surface.find_entities()) do
				if not entity_types[entity.type] then
					entity_types[entity.type] = true
				end
			end

			player.print(serpent.line(entity_types))
		end
	end
)
