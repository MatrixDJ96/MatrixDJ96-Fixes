local player_data = require("scripts.player-data")
local constants = require("constants")

local mod = {}

local gui_button = {
    ["character"] = "manual-inventory-sort-player",
    ["trash-slots"] = "manual-inventory-sort-player-trash",
    ["entity"] = "manual-inventory-sort-opened"
}

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return game.active_mods["manual-inventory-sort"] and player_data.get_settings(player, "manual-inventory-sort-buttons")
end

--- @param relative_gui_type defines.relative_gui_type
local function get_relative_gui_name(relative_gui_type)
    return "manual-inventory-sort-buttons-" .. relative_gui_type
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

--- @param frame LuaGuiElement?
--- @return table<string, LuaGuiElement>
local function get_gui_buttons(frame)
    -- Get sort buttons inside frame (if any)
    local character = frame ~= nil and frame[gui_button["character"]]
    local trash_slots = frame ~= nil and frame[gui_button["trash-slots"]]
    local entity = frame ~= nil and frame[gui_button["entity"]]

    return {
        ["character"] = character,
        ["trash-slots"] = trash_slots,
        ["entity"] = entity
    }
end

local function get_traslations(player, has_entity_opened)
    local translations = {
        -- Add character and trash-slots translations
        ["character"] = player_data.get_translation(player, "character"),
        ["trash-slots"] = player_data.get_translation(player, "trash-slots"),
        ["entity"] = nil
    }

    -- Check if an entity is opened and if it is valid
    if has_entity_opened and player.opened ~= nil and player.opened.valid then
        -- Check if translation exists for opened entity
        if not player_data.get_translation(player, player.opened.name) then
            -- Request the translation for the opened entity
            player_data.set_translation(player, player.opened.name, player.opened.localised_name)
        end

        translations["entity"] = player_data.get_translation(player, player.opened.name)
    end

    return translations
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

--- @param player LuaPlayer
function mod.remove_buttons(player)
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

--- @param player LuaPlayer
function mod.add_buttons(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get translations for button tooltips
    local translations = get_traslations(player, false)

    -- Create the new buttons for supported relative GUI types
    for _, relative_gui_type in pairs(constants.relative_gui_types) do
        -- Get or create sort frame for player GUI type
        local frame = get_gui_frame(player, relative_gui_type, true) --[[@as LuaGuiElement]]

        -- Get sort buttons from frame
        local buttons = get_gui_buttons(frame)

        if not buttons["character"] then
            -- Add player character sort button
            frame.add({
                type = "sprite-button",
                name = gui_button["character"],
                tooltip = get_tooltip(translations["character"]),
                style = "mod_gui_button",
                sprite = "entity/character",
                visible = true
            })
        end

        if not buttons["trash-slots"] then
            -- Add player trash-slots sort button
            frame.add({
                type = "sprite-button",
                name = gui_button["trash-slots"],
                tooltip = get_tooltip(translations["trash-slots"]),
                style = "mod_gui_button",
                sprite = "matrixdj96_trash_icon",
                visible = false
            })
        end

        if not buttons["entity"] then
            -- Add opened entity sort button
            frame.add({
                type = "sprite-button",
                name = gui_button["entity"],
                style = "mod_gui_button",
                visible = false
            })
        end
    end
end

--- @param player LuaPlayer
function mod.modify_buttons(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Define if an entity is opened
    local has_entity_opened = false

    -- Get the frame buttons created by manual-inventory-sort
    local sort_buttons = player.gui.left["manual-inventory-sort-buttons"]

    if sort_buttons ~= nil then
        -- Check if manual-inventory-sort has created "opened" button
        has_entity_opened = sort_buttons["manual-inventory-sort-opened"] ~= nil
        -- Destroy the buttons created by manual-inventory-sort
        sort_buttons.destroy()
    end

    -- Perform a better check on inventory
    if has_inventory_opened(player) then
        -- Get translations for button tooltips
        local translations = get_traslations(player, has_entity_opened)

        -- Update sort buttons for supported relative GUI types
        for _, relative_gui_type in pairs(constants.relative_gui_types) do
            -- Get sort frame for player GUI type
            local frame = get_gui_frame(player, relative_gui_type)

            -- Get sort buttons from frame
            local buttons = get_gui_buttons(frame)

            if buttons["character"] ~= nil then
                -- Update tooltip of character button
                buttons["character"].tooltip = get_tooltip(translations["character"])
            end

            if buttons["trash-slots"] ~= nil then
                -- Update vibility and tooltip of trash-slots button
                buttons["trash-slots"].visible = player.opened_self and player.force.character_logistic_requests
                buttons["trash-slots"].tooltip = get_tooltip(translations["trash-slots"])
            end

            if buttons["entity"] ~= nil then
                if has_entity_opened then
                    -- Update vibility, tooltip and sprite of opened button
                    buttons["entity"].visible = player.opened_gui_type == defines.gui_type.entity
                    buttons["entity"].tooltip = get_tooltip(translations["entity"])
                    buttons["entity"].sprite = "entity/" .. player.opened.name
                else
                    -- Hide opened button
                    buttons["entity"].visible = false
                end
            end
        end
    end
end

--- @param player LuaPlayer
--- @param translation TranslationTable
function mod.update_button_tooltip(player, translation)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

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

return mod
