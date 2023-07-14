local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")
local utils = require("scripts.utils")

local mod = {}

--- @return boolean
local function check_required_conditions(player)
    return player_data.get_settings(player, "matrixdj96_enhanced_entity_build_setting")
end

--- Improve placement of an entity over another
--- @param player LuaPlayer
--- @param e EventData
local function improve_placement(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get entity from event data
    local created_entity = e.created_entity --[[@as LuaEntity]]

    -- Check if entity exists and it is a enity-ghost
    if created_entity ~= nil and created_entity.type == "entity-ghost" then
        -- Get data from entity
        local name = created_entity.ghost_name
        local position = created_entity.position
        local surface = created_entity.surface

        -- Find entities at the same position of the ghost
        local other_entities = surface.find_entities_filtered({ position = position })

        -- Loop through all entities
        for _, other_entity in pairs(other_entities) do
            -- Check if other_entity is not the created_entity and it is not a ghost
            if other_entity ~= created_entity and other_entity.type ~= "entity-ghost" then
                -- Check if other_entity has the same name and it is marked for deconstruction
                if other_entity.name == name and other_entity.to_be_deconstructed() then
                    -- Check if other_entity has the same position as created_entity
                    if utils.position(other_entity.position, position) then
                        -- Destroy created_entity ghost and cancel deconstruction of other_entity
                        created_entity.order_deconstruction(player.force, player)
                        other_entity.cancel_deconstruction(player.force, player)
                    end
                end
            end
        end
    end
end

-- Define events that will be handled
mod.events = {
    [defines.events.on_built_entity] = improve_placement
}

return mod
