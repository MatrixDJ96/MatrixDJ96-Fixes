local constants = {}

constants.none = "none"
constants.warnings = "warnings"
constants.all = "all"

constants.character = "character"
constants.trash_slots = "trash-slots"
constants.entity = "entity"

constants.maximize = "maximize"
constants.minimize = "minimize"

constants.yarm_buttons = {
	[constants.none] = "YARM_filter_none",
	[constants.warnings] = "YARM_filter_warnings",
	[constants.all] = "YARM_filter_all"
}

constants.sort_frame = "manual-inventory-sort-buttons"

constants.sort_buttons = {
	[constants.character] = "manual-inventory-sort-player",
	[constants.trash_slots] = "manual-inventory-sort-player-trash",
	[constants.entity] = "manual-inventory-sort-opened"
}

constants.todo_buttons = {
	[constants.maximize] = "todo_maximize_button",
	[constants.minimize] = "todo_minimize_button"
}

constants.dummy_todo_buttons = {
	[constants.maximize] = "dummy_" .. constants.todo_buttons[constants.maximize],
	[constants.minimize] = "dummy_" .. constants.todo_buttons[constants.minimize]
}

constants.input_events = {
	"matrixdj96_move_up",
	"matrixdj96_move_down",
	"matrixdj96_move_left",
	"matrixdj96_move_right"
}

constants.gui_types = {
	defines.gui_type.blueprint_library,
	defines.gui_type.entity,
	defines.gui_type.other_player
}

constants.relative_gui_types = {
	defines.relative_gui_type.armor_gui,
	defines.relative_gui_type.assembling_machine_gui,
	defines.relative_gui_type.beacon_gui,
	defines.relative_gui_type.blueprint_book_gui,
	defines.relative_gui_type.blueprint_library_gui,
	defines.relative_gui_type.bonus_gui,
	defines.relative_gui_type.burner_equipment_gui,
	defines.relative_gui_type.car_gui,
	defines.relative_gui_type.container_gui,
	defines.relative_gui_type.controller_gui,
	defines.relative_gui_type.deconstruction_item_gui,
	defines.relative_gui_type.equipment_grid_gui,
	defines.relative_gui_type.furnace_gui,
	defines.relative_gui_type.inserter_gui,
	defines.relative_gui_type.item_with_inventory_gui,
	defines.relative_gui_type.lab_gui,
	defines.relative_gui_type.linked_container_gui,
	defines.relative_gui_type.logistic_gui,
	defines.relative_gui_type.market_gui,
	defines.relative_gui_type.mining_drill_gui,
	defines.relative_gui_type.other_player_gui,
	defines.relative_gui_type.reactor_gui,
	defines.relative_gui_type.resource_entity_gui,
	defines.relative_gui_type.roboport_gui,
	defines.relative_gui_type.rocket_silo_gui,
	defines.relative_gui_type.script_inventory_gui,
	defines.relative_gui_type.spider_vehicle_gui,
	defines.relative_gui_type.standalone_character_gui,
	defines.relative_gui_type.storage_tank_gui,
	defines.relative_gui_type.tile_variations_gui,
	defines.relative_gui_type.train_gui,
	defines.relative_gui_type.upgrade_item_gui
}

return constants
