local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

local mods = {
	require("scripts.mods.manual-inventory-sort"),
	require("scripts.mods.task-list"),
	require("scripts.mods.todo-list"),
	require("scripts.mods.train-log"),
	require("scripts.mods.yarm"),
	require("scripts.tweaks.enhanced-entity-build"),
	require("scripts.tweaks.trains-auto-manual-mode"),
	require("scripts.tweaks.trains-manual-mode-temp-stop"),
	require("scripts.tweaks.vehicle-auto-fueling")
}

local events = {}

script.on_init(global_data.init)
script.on_configuration_changed(global_data.init)

-- Loop through all mods
for _, mod in pairs(mods) do
	mod.events = mod.events or {}

	-- Loop through all defined events in mod
	for event_name, event_function in pairs(mod.events) do
		events[event_name] = events[event_name] or {}

		-- Add event function to events table
		table.insert(events[event_name], event_function)
	end
end

-- Loop through all events
for event_name, event_functions in pairs(events) do
	-- Add event handler for event name
	script.on_event(event_name, function(e)
		-- Get player index from event data
		local player_index = e.player_index --[[@as uint?]]

		-- Get player from game script data
		local player = player_index and global_data.get_player(player_index)

		-- Check if player_index exists and player is valid
		if player_index and not (player ~= nil and player.valid) then
			-- Skip event
			return
		end

		-- Loop through all event functions
		for _, event_function in pairs(event_functions) do
			-- Execute event function
			event_function(player, e)
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
