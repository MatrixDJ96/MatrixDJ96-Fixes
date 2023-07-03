local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

local mod_sort = require("scripts.mods.manual-inventory-sort")
local mod_task = require("scripts.mods.task-list")
local mod_todo = require("scripts.mods.todo-list")
local mod_train = require("scripts.mods.train-log")
local mod_yarm = require("scripts.mods.yarm")

--- @param player LuaPlayer
local function initialize_player(player)
	-- Initialize player data
	player_data.init(player)

	-- Add manual-inventory-sort buttons
	mod_sort.add_buttons(player)

	-- Add task-list top button
	mod_task.add_top_button(player)

	-- Update todo-list top button
	mod_todo.add_top_button(player)

	-- Update train-log top button
	mod_train.update_top_button(player)

	-- Force YARM filter to init UI
	mod_yarm.force_sites_filter(player)

	-- Remove YARM background toggle
	mod_yarm.remove_background_button(player)
end

local function initialize_global()
	-- Initialize global data
	global_data.init()

	for _, player in pairs(game.players) do
		-- Initialize player data
		initialize_player(player)
	end
end

script.on_init(initialize_global)
script.on_configuration_changed(initialize_global)

for i = 1, #constants.player_events do
	script.on_event(
		constants.player_events[i],
		function(e)
			-- Initialize player data
			initialize_player(game.players[ e.player_index --[[@as uint]] ])
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
			mod_task.toggle_window(player, e)

			-- Toggle todo-list window on button click
			mod_todo.toggle_window(player, e)

			-- Toggle YARM background on button click
			mod_yarm.toggle_background(player, e)
		end
	)
end

script.on_event(
	defines.events.on_gui_closed,
	function(e)
		-- Update visibility of todo-list buttons
		mod_todo.update_top_buttons(game.players[e.player_index])
	end
)

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
