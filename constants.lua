local constants = {}

constants.gui_events = {
	defines.events.on_gui_checked_state_changed,
	defines.events.on_gui_click,
	defines.events.on_gui_closed,
	defines.events.on_gui_confirmed,
	defines.events.on_gui_elem_changed,
	defines.events.on_gui_location_changed,
	defines.events.on_gui_opened,
	defines.events.on_gui_selected_tab_changed,
	defines.events.on_gui_selection_state_changed,
	defines.events.on_gui_switch_state_changed,
	defines.events.on_gui_text_changed,
	defines.events.on_gui_value_changed
}

constants.player_events = {
	defines.events.on_player_created,
	defines.events.on_player_joined_game
}

return constants
