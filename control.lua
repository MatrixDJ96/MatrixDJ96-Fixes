local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

require("scripts.mod-data")

script.on_init(global_data.init)
script.on_configuration_changed(global_data.init)

-- Loop through all events
for event_name, event_functions in pairs(EVENTS) do
	-- Add event handler for event name
	script.on_event(event_name, function(e)
		-- Get player index from event data
		local player_index = e.player_index --[[@as uint?]]

		-- Get player from game script data
		local player = player_index and global_data.get_player(player_index)

		-- Checks if player should exist
		if player_index and player == nil then
			-- Skip event
			return
		end

		-- Loop through all event functions
		for _, event_function in pairs(event_functions) do
			if type(event_function) == "function" then
				-- Execute event function
				event_function(player, e)
			end
		end
	end)
end

script.on_nth_tick(
	5,
	function()
		-- Loop through all players
		for _, player in pairs(global.players) do
			-- Loop through all tick functions
			for _, tick_function in pairs(player.tick_functions) do
				-- Execute tick function
				tick_function()
			end
		end
	end
)
