local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")
local utils = require("scripts.utils")

local mod = {}

-- Create shortcuts for constants
local character = constants.character
local trash_slots = constants.trash_slots
local entity = constants.entity
local sort_frame = constants.sort_frame
local sort_buttons = constants.sort_buttons

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return global_data.is_mod_active("manual-inventory-sort") and
        player_data.get_settings(player, "manual-inventory-sort-buttons")
end

--- @param player LuaPlayer
local function has_inventory_opened(player)
    -- Check if the player has opened itself
    if player.opened_self then
        return true
    end

    -- Check if the player has opened a supported GUI type
    for _, gui_type in pairs(constants.gui_types) do
        if player.opened_gui_type == gui_type then
            return true
        end
    end
end

--- @param translation TranslationTable
local function get_tooltip(translation)
    -- Check if translation is valid
    if not translation.translated_string then
        -- Return translation id
        return translation.id
    end

    -- Return translated string
    return "Sort " .. string.lower(translation.translated_string)
end

local function get_traslations(player, has_entity_opened)
    local translations = {
        -- Add character and trash-slots translations
        [character] = player_data.get_translation(player, character),
        [trash_slots] = player_data.get_translation(player, trash_slots),
        [entity] = nil
    }

    -- Check if an entity is opened and if it exists
    if has_entity_opened and player.opened ~= nil then
        -- Check if translation exists for opened entity
        if not player_data.get_translation(player, player.opened.name) then
            -- Request the translation for the opened entity
            player_data.set_translation(player, player.opened.name, player.opened.localised_name)
        end

        translations[entity] = player_data.get_translation(player, player.opened.name)
    end

    return translations
end

--- @param relative_gui_type defines.relative_gui_type
local function get_relative_gui_name(relative_gui_type)
    return sort_frame .. "-" .. relative_gui_type
end

--- @param player LuaPlayer
--- @param relative_gui_type defines.relative_gui_type
--- @param create_if_missing? boolean
--- @return LuaGuiElement?
local function get_gui_frame(player, relative_gui_type, create_if_missing)
    local name = get_relative_gui_name(relative_gui_type)

    --- @type LuaGuiElement?
    local window = player.gui.relative[name .. "_window"]

    if window == nil and create_if_missing then
        -- Create sort window
        --- @type LuaGuiElement
        window = player.gui.relative.add({
            name = name .. "_window",
            type = "frame",
            style = "quick_bar_window_frame",
            direction = "vertical",
            anchor = { gui = relative_gui_type, position = defines.relative_gui_position.left }
        })
    end

    if window ~= nil then
        --- @type LuaGuiElement?
        local frame = window[name .. "_frame"]

        if frame == nil and create_if_missing then
            -- Create sort frame
            --- @type LuaGuiElement
            frame = window.add({
                name = name .. "_frame",
                type = "frame",
                direction = "vertical",
                style = "mod_gui_inside_deep_frame"
            })
        end

        -- Return the frame
        return frame
    end

    -- Return nil
    return nil
end

--- @param player LuaPlayer
--- @param relative_gui_type defines.relative_gui_type
--- @param create_if_missing? boolean
--- @return table<string, LuaGuiElement>
local function get_gui_buttons(player, relative_gui_type, create_if_missing)
    -- Define gui buttons
    local gui_buttons = {
        [character] = nil,
        [trash_slots] = nil,
        [entity] = nil
    }

    -- Get or create sort frame for player GUI type
    local gui_frame = get_gui_frame(player, relative_gui_type, create_if_missing)

    -- Check if sort frame exists
    if gui_frame ~= nil then
        -- Get sort buttons inside frame (if any)
        gui_buttons[character] = gui_frame[sort_buttons[character]]
        gui_buttons[trash_slots] = gui_frame[sort_buttons[trash_slots]]
        gui_buttons[entity] = gui_frame[sort_buttons[entity]]

        if gui_buttons[character] == nil then
            -- Add player character sort button
            gui_buttons[character] = gui_frame.add({
                type = "sprite-button",
                name = sort_buttons[character],
                style = "mod_gui_button",
                sprite = "entity/character",
                visible = true
            })
        end

        if gui_buttons[trash_slots] == nil then
            -- Add player trash-slots sort button
            gui_buttons[trash_slots] = gui_frame.add({
                type = "sprite-button",
                name = sort_buttons[trash_slots],
                style = "mod_gui_button",
                sprite = "matrixdj96_trash_icon",
                visible = false
            })
        end

        if gui_buttons[entity] == nil then
            -- Add opened entity sort button
            gui_buttons[entity] = gui_frame.add({
                type = "sprite-button",
                name = sort_buttons[entity],
                style = "mod_gui_button",
                visible = false
            })
        end
    end

    return gui_buttons
end

--- Remove manual-inventory-sort buttons
--- @param player LuaPlayer
local function remove_buttons(player)
    -- Create the new buttons for all relative GUI types
    for _, relative_gui_type in pairs(defines.relative_gui_type) do
        -- Define name button based on the relative GUI type
        local name = get_relative_gui_name(relative_gui_type)

        -- Destroy the old frame buttons
        if player.gui.relative[name] then
            player.gui.relative[name].destroy()
        end

        -- Destroy the old frame buttons 2.0
        if player.gui.relative[name .. "_window"] then
            player.gui.relative[name .. "_window"].destroy()
        end
    end
end

--- Add manual-inventory-sort buttons
--- @param player LuaPlayer
local function add_buttons(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get translations for button tooltips
    local translations = get_traslations(player, false)

    -- Create the new buttons for supported relative GUI types
    for _, relative_gui_type in pairs(constants.relative_gui_types) do
        local buttons = get_gui_buttons(player, relative_gui_type, true)

        if buttons[character] ~= nil then
            -- Set player character sort button tooltip
            buttons[character].tooltip = get_tooltip(translations[character])
        end

        if buttons[trash_slots] ~= nil then
            -- Set player trash-slots sort button tooltip
            buttons[trash_slots].tooltip = get_tooltip(translations[trash_slots])
        end
    end
end

--- Sort inventory
--- @param player LuaPlayer
--- @param e EventData
local function sort_inventory(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get the clicked element from the event data
    local element = e.element --[[@as LuaGuiElement]]

    -- Check if player is using a supported controller type (character or god)
    local supported_controller = player.controller_type == defines.controllers.god or
        player.controller_type == defines.controllers.character

    -- Check if one of manual-invertory-sort buttons has been clicked
    if element ~= nil and element.valid and utils.contains(sort_buttons, element.name) then
        --  Check is controller is not supported
        if not supported_controller then
            -- Define inventory to sort and merge
            local inventory = nil --[[@as LuaInventory?]]

            if element.name == sort_buttons[character] then
                -- Get player character inventory
                inventory = player.get_main_inventory()
            elseif element.name == sort_buttons[entity] then
                -- Get opened entity inventory
                inventory = player.opened.get_inventory(defines.inventory.chest) or
                    player.opened.get_inventory(defines.inventory.cargo_wagon) or
                    player.opened.get_inventory(defines.inventory.car_trunk)
            end

            if inventory ~= nil then
                -- Sort and merge inventory
                inventory.sort_and_merge()
            end
        end
    end
end

--- Modify manual-inventory-sort buttons
--- @param player LuaPlayer
--- @param e EventData
local function modify_buttons(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Define buttons visibility
    local buttons_visibility = {}

    -- Check if frame buttons created by manual-inventory-sort exist
    if player.gui.left[sort_frame] ~= nil then
        -- Get buttons visibility
        for key, value in pairs(sort_buttons) do
            buttons_visibility[key] = player.gui.left[sort_frame][value] ~= nil
        end

        -- Remove buttons visibility
        player.gui.left[sort_frame].visible = false
    end

    -- Perform a better check on inventory
    if has_inventory_opened(player) then
        -- Get translations for button tooltips
        local translations = get_traslations(player, buttons_visibility[entity])

        -- Update sort buttons for supported relative GUI types
        for _, relative_gui_type in pairs(constants.relative_gui_types) do
            -- Get sort buttons for player GUI type
            local buttons = get_gui_buttons(player, relative_gui_type)

            if buttons[character] ~= nil then
                -- Update vibility and tooltip of character button
                buttons[character].visible = true -- buttons_visibility[character]
                buttons[character].tooltip = get_tooltip(translations[character])
            end

            if buttons[trash_slots] ~= nil then
                -- Update vibility and tooltip of trash-slots button
                buttons[trash_slots].visible = buttons_visibility[trash_slots] and
                    player.opened_self and player.force.character_logistic_requests
                buttons[trash_slots].tooltip = get_tooltip(translations[trash_slots])
            end

            if buttons[entity] ~= nil then
                -- Update vibility of opened button
                buttons[entity].visible = buttons_visibility[entity]

                if buttons[entity].visible then
                    -- Update tooltip and sprite of opened button
                    buttons[entity].tooltip = get_tooltip(translations[entity])
                    buttons[entity].sprite = "entity/" .. player.opened.name
                end
            end
        end
    end
end

--- Update tooltips of manual-inventory-sort
--- @param player LuaPlayer
--- @param e EventData
local function update_tooltips(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get translation id from event data
    local translation_id = e.id --[[@as uint]]
    -- Get translation result from event data
    local translation_result = e.result --[[@as string]]

    -- Get player translation from translation id
    local translation = player_data.get_translation(player, translation_id)

    -- Check if translation exists
    if translation ~= nil then
        -- Update translation with translation result
        translation.translated_string = translation_result

        -- Update buttons tooltip for supported relative GUI types
        for _, relative_gui_type in pairs(constants.relative_gui_types) do
            -- Get sort frame for player GUI type
            local frame = get_gui_frame(player, relative_gui_type)

            -- Check if sort frame exists
            if frame ~= nil then
                for _, item in pairs(frame.children) do
                    -- Find the button with the matching tooltip id
                    if item.tooltip == tostring(translation.id) then
                        -- Update the tooltip with the new translation
                        item.tooltip = get_tooltip(translation)
                    end
                end
            end
        end
    end
end

--- Initialize manual-inventory-sort mod
--- @param player LuaPlayer
--- @param force? boolean
function mod.init(player, force)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Add sort buttons
    add_buttons(player)
end

--- Clean manual-inventory-sort mod
--- @param player LuaPlayer
function mod.clean(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Remove sort buttons
    remove_buttons(player)
end

-- Define events that will be handled
mod.events = {
    [defines.events.on_gui_click] = sort_inventory,
    [defines.events.on_gui_opened] = modify_buttons,
    [defines.events.on_string_translated] = update_tooltips
}

return mod
