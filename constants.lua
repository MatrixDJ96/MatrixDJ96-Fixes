local constants = {}

constants.NONE = "none"
constants.WARNINGS = "warnings"
constants.ALL = "all"

constants.yarm_buttons = {
	[constants.NONE] = "YARM_filter_none",
	[constants.WARNINGS] = "YARM_filter_warnings",
	[constants.ALL] = "YARM_filter_all"
}

constants.sort_buttons = {
	["character"] = "manual-inventory-sort-player",
	["trash-slots"] = "manual-inventory-sort-player-trash",
	["entity"] = "manual-inventory-sort-opened"
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
