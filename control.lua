local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

local mod_sort = require("scripts.mods.manual-inventory-sort")
local mod_task = require("scripts.mods.task-list")
local mod_yarm = require("scripts.mods.yarm")

local initialize = function()
	-- Initialize global data
	global_data.init()

	for _, player in pairs(game.players) do
		-- Initialize player data
		player_data.init(player)

		-- Add task-list top button
		mod_task.add_top_button(player, true)

		-- Remove YARM background toggle
		mod_yarm.remove_bg_toggle(player)
	end
end

script.on_init(initialize)
script.on_configuration_changed(initialize)

for i = 1, #constants.player_events do
	script.on_event(
		constants.player_events[i],
		function(e)
			-- Get player from event data
			local player = game.players[ e.player_index --[[@as uint]] ]

			-- Add task-list top button
			mod_task.add_top_button(player)

			-- Remove YARM background toggle
			mod_yarm.remove_bg_toggle(player)
		end
	)
end

for i = 1, #constants.gui_events do
	script.on_event(
		constants.gui_events[i],
		function(e)
			-- Get player from event data
			local player = game.players[ e.player_index --[[@as uint]] ]

			-- Modify manual-inventory-sort buttons
			mod_sort.modify_buttons(player)

			-- Toggle task-list window on button click
			mod_task.toggle_window(player, e.element --[[@as LuaGuiElement?]])
		end
	)
end

script.on_event(
	defines.events.on_string_translated,
	function(e)
		-- Get player from event data
		local player = game.players[ e.player_index --[[@as uint]] ]

		-- Create shortcut for all player translations
		local translation = global_data.get_translation_by_request_id(player.index, e.id)

		-- Check if translation has been found
		if translation then
			-- Update translation
			translation.translated_string = e.result

			-- Update tooltip of manual-inventory-sort button
			mod_sort.update_button_tooltip(player, translation)
		end
	end
)
