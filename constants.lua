local constants = {}

constants.gui_events = {
	defines.events.on_gui_click,
	defines.events.on_gui_opened
}

constants.player_events = {
	defines.events.on_player_created,
	defines.events.on_player_joined_game
}

constants.gui_types = {
	defines.gui_type.other_player,
	defines.gui_type.blueprint_library,
	defines.gui_type.entity
}

constants.relative_gui_types = {
	defines.relative_gui_type.accumulator_gui,
	defines.relative_gui_type.achievement_gui,
	defines.relative_gui_type.additional_entity_info_gui,
	defines.relative_gui_type.admin_gui,
	defines.relative_gui_type.arithmetic_combinator_gui,
	defines.relative_gui_type.armor_gui,
	defines.relative_gui_type.assembling_machine_gui,
	defines.relative_gui_type.assembling_machine_select_recipe_gui,
	defines.relative_gui_type.beacon_gui,
	defines.relative_gui_type.blueprint_book_gui,
	defines.relative_gui_type.blueprint_library_gui,
	-- defines.relative_gui_type.blueprint_setup_gui,
	defines.relative_gui_type.bonus_gui,
	defines.relative_gui_type.burner_equipment_gui,
	defines.relative_gui_type.car_gui,
	defines.relative_gui_type.constant_combinator_gui,
	defines.relative_gui_type.container_gui,
	defines.relative_gui_type.controller_gui,
	defines.relative_gui_type.decider_combinator_gui,
	defines.relative_gui_type.deconstruction_item_gui,
	defines.relative_gui_type.electric_energy_interface_gui,
	defines.relative_gui_type.electric_network_gui,
	defines.relative_gui_type.entity_variations_gui,
	defines.relative_gui_type.entity_with_energy_source_gui,
	defines.relative_gui_type.equipment_grid_gui,
	defines.relative_gui_type.furnace_gui,
	defines.relative_gui_type.generic_on_off_entity_gui,
	defines.relative_gui_type.heat_interface_gui,
	defines.relative_gui_type.infinity_pipe_gui,
	defines.relative_gui_type.inserter_gui,
	defines.relative_gui_type.item_with_inventory_gui,
	defines.relative_gui_type.lab_gui,
	defines.relative_gui_type.lamp_gui,
	defines.relative_gui_type.linked_container_gui,
	defines.relative_gui_type.loader_gui,
	defines.relative_gui_type.logistic_gui,
	defines.relative_gui_type.market_gui,
	defines.relative_gui_type.mining_drill_gui,
	defines.relative_gui_type.other_player_gui,
	defines.relative_gui_type.permissions_gui,
	defines.relative_gui_type.pipe_gui,
	defines.relative_gui_type.power_switch_gui,
	defines.relative_gui_type.production_gui,
	defines.relative_gui_type.programmable_speaker_gui,
	defines.relative_gui_type.rail_chain_signal_gui,
	defines.relative_gui_type.rail_signal_gui,
	defines.relative_gui_type.reactor_gui,
	defines.relative_gui_type.rename_stop_gui,
	defines.relative_gui_type.resource_entity_gui,
	defines.relative_gui_type.roboport_gui,
	defines.relative_gui_type.rocket_silo_gui,
	defines.relative_gui_type.script_inventory_gui,
	defines.relative_gui_type.server_config_gui,
	defines.relative_gui_type.spider_vehicle_gui,
	defines.relative_gui_type.splitter_gui,
	defines.relative_gui_type.standalone_character_gui,
	defines.relative_gui_type.storage_tank_gui,
	defines.relative_gui_type.tile_variations_gui,
	defines.relative_gui_type.train_gui,
	defines.relative_gui_type.train_stop_gui,
	defines.relative_gui_type.trains_gui,
	defines.relative_gui_type.transport_belt_gui,
	defines.relative_gui_type.upgrade_item_gui,
	defines.relative_gui_type.wall_gui
}

return constants
