local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

local mod_fuel = require("scripts.mods.auto-fueling")
local mod_sort = require("scripts.mods.manual-inventory-sort")
local mod_task = require("scripts.mods.task-list")
local mod_todo = require("scripts.mods.todo-list")
local mod_train_log = require("scripts.mods.train-log")
local mod_train_mode = require("scripts.mods.train-mode")
local mod_yarm = require("scripts.mods.yarm")

script.on_init(global_data.init)
script.on_configuration_changed(global_data.init)

script.on_event({
		defines.events.on_player_created,
		defines.events.on_player_joined_game
	},
	function(e)
		-- Get player from event data
		local player = global_data.get_player(e.player_index)

		if not (player ~= nil and player.valid) then
			-- Skip event if player is invalid
			return
		end

		-- Add manual-inventory-sort buttons
		mod_sort.add_buttons(player)

		-- Add task-list top button
		mod_task.add_top_button(player)

		-- Update todo-list top button
		mod_todo.add_top_button(player)

		-- Update train-log top button
		mod_train_log.update_top_button(player)

		-- Force YARM filter to init UI
		mod_yarm.force_sites_filter(player)

		-- Remove YARM background toggle
		mod_yarm.remove_background_button(player)
	end
)

script.on_event({
		defines.events.on_gui_click,
		defines.events.on_gui_opened
	},
	function(e)
		-- Get player from event data
		local player = global_data.get_player(e.player_index)

		if not (player ~= nil and player.valid) then
			-- Skip event if player is invalid
			return
		end

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

script.on_event(
	defines.events.on_gui_closed,
	function(e)
		-- Get player from event data
		local player = global_data.get_player(e.player_index)

		if not (player ~= nil and player.valid) then
			-- Skip event if player is invalid
			return
		end

		-- Update visibility of todo-list buttons
		mod_todo.update_top_buttons(player)
	end
)

script.on_event(
	defines.events.on_string_translated,
	function(e)
		-- Get player from event data
		local player = global_data.get_player(e.player_index)

		if not (player ~= nil and player.valid) then
			-- Skip event if player is invalid
			return
		end

		-- Get player translation from event data
		local translation = player_data.get_translation(player, e.id)

		-- Check if translation has been found
		if translation ~= nil then
			-- Update translation from event data
			translation.translated_string = e.result

			-- Update tooltip of manual-inventory-sort button
			mod_sort.update_button_tooltip(player, translation)
		end
	end
)

script.on_event(
	constants.input_events,
	--- @param e EventData.CustomInputEvent
	function(e)
		-- Get player from event data
		local player = global_data.get_player(e.player_index)

		if not (player ~= nil and player.valid) then
			-- Skip event if player is invalid
			return
		end

		-- Perform auto-fueling on input event
		mod_fuel.perform_auto_fueling(player)

		-- Update train mode on input event
		mod_train_mode.update_manual_mode(player, e)
	end
)

script.on_event(
	defines.events.on_player_driving_changed_state,
	function(e)
		-- Get player from event data
		local player = global_data.get_player(e.player_index)

		if not (player ~= nil and player.valid) then
			-- Skip event if player is invalid
			return
		end

		-- Update train mode on driving change
		mod_train_mode.update_manual_mode(player, e)
	end
)

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
