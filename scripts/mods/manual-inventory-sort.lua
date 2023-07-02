local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")

local mod = {}

local function check_required_conditions()
    return game.active_mods["manual-inventory-sort"] and settings.player["manual-inventory-sort-buttons"]
end

--- @param player LuaPlayer
local function has_inventory_opened(player)
    -- Check if the player has opened itself, the blueprint library or another player
    if player.opened_self or (player.opened_gui_type == defines.gui_type.blueprint_library) or player.opened_gui_type == (defines.gui_type.other_player) then
        return true
    end

    -- Check if the player has opened an entity
    if player.opened_gui_type == defines.gui_type.entity then
        for _, index in pairs(defines.inventory) do
            -- Check if the entity has an inventory and if it is valid
            local inventory = player.opened.get_inventory(index)
            if inventory and inventory.valid then
                return true
            end
        end
    end
end

--- @param translation TranslationTable
--- @param force? boolean
local function get_tooltip(translation, force)
    -- Return translated string or request ID if not translated yet
    if force or translation.translated_string then
        return "Sort " .. string.lower(translation.translated_string or "")
    end

    return translation.request_id
end

--- @param player LuaPlayer
function mod.add_buttons(player, force)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    -- Create shortcut for all player translations
    local translations = global_data.get_all_translations(player.index)

    -- Create the new buttons for all types of relative GUIs
    for _, relative_gui_type in pairs(defines.relative_gui_type) do
        -- Define name button based on the relative GUI type
        local name = "manual-inventory-sort-buttons-" .. relative_gui_type

        -- Destroy the old frame buttons
        if force and player.gui.relative[name] then
            player.gui.relative[name].destroy()
        end

        --- @type LuaGuiElement
        -- Create the new frame buttons
        local frame = player.gui.relative.add({
            name = name,
            type = "frame",
            style = "quick_bar_window_frame",
            direction = "vertical",
            anchor = { gui = relative_gui_type, position = defines.relative_gui_position.left }
        })

        -- Add player inventory sort button
        frame.add({
            type = "sprite-button",
            name = "manual-inventory-sort-player",
            style = "mod_gui_button",
            sprite = "entity/character",
            visible = true
        })

        -- Add player trash sort button
        frame.add({
            type = "sprite-button",
            name = "manual-inventory-sort-player-trash",
            tooltip = get_tooltip(translations["trash-slots"]),
            style = "mod_gui_button",
            sprite = "matrixdj96_trash_icon",
            visible = false
        })

        -- Add opened entity sort button
        frame.add({
            type = "sprite-button",
            name = "manual-inventory-sort-opened",
            style = "mod_gui_button",
            visible = false
        })
    end
end

--- @param player LuaPlayer
function mod.modify_buttons(player)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    -- Get the frame buttons created by manual-inventory-sort
    local sort_buttons = player.gui.left["manual-inventory-sort-buttons"]

    -- Check if buttons has been created for the player
    if sort_buttons and sort_buttons.valid then
        -- Perform a better check on inventory
        if has_inventory_opened(player) then
            -- Check if manual-inventory-sort has created "opened" button
            local has_entity_opened = sort_buttons["manual-inventory-sort-opened"]

            -- Create shortcut for all player translations
            local translations = global_data.get_all_translations(player.index)

            if has_entity_opened then
                if not translations[player.opened.name] then
                    -- Request the translation for the opened entity localized string
                    translations[player.opened.name] = player_data.create_translation(player, player.opened.localised_name)
                end
            end

            -- Create the new buttons for all types of relative GUIs
            for _, relative_gui_type in pairs(defines.relative_gui_type) do
                -- Define name button based on the relative GUI type
                local name = "manual-inventory-sort-buttons-" .. relative_gui_type

                -- Get frame buttons created previously
                local frame = player.gui.relative[name]

                -- Check if frame buttons has been created and it is valid
                if frame and frame.valid then
                    -- Get buttons inside frame created previously
                    local character = frame["manual-inventory-sort-player"]
                    local trash_slots = frame["manual-inventory-sort-player-trash"]
                    local entity = frame["manual-inventory-sort-opened"]

                    if character and character.valid then
                        -- Update tooltip of character button
                        character.tooltip = get_tooltip(translations["character"])
                    end

                    if trash_slots and trash_slots.valid then
                        -- Update vibility and tooltip of trash-slots button
                        trash_slots.visible = player.opened_self and player.force.character_logistic_requests
                        trash_slots.tooltip = get_tooltip(translations["trash-slots"])
                    end

                    if entity and entity.valid then
                        if has_entity_opened then
                            -- Update vibility, tooltip and sprite of opened button
                            entity.visible = player.opened_gui_type == defines.gui_type.entity
                            entity.tooltip = get_tooltip(translations[player.opened.name])
                            entity.sprite = "entity/" .. player.opened.name
                        else
                            -- Hide opened button
                            entity.visible = false
                        end
                    end
                end
            end
        end

        -- Destroy the buttons created by manual-inventory-sort
        sort_buttons.destroy()
    end
end

--- @param player LuaPlayer
--- @param translation TranslationTable
function mod.update_button_tooltip(player, translation)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    -- Update buttons tooltip for all types of relative GUIs
    for _, relative_gui_type in pairs(defines.relative_gui_type) do
        local name = "manual-inventory-sort-buttons-" .. relative_gui_type

        -- Check if buttons has been created and it is valid
        if player.gui.relative[name] and player.gui.relative.valid then
            for _, item in pairs(player.gui.relative[name].children) do
                -- Find the button with the matching tooltip id
                if item.tooltip == tostring(translation.request_id) then
                    -- Update the tooltip with the new translation
                    item.tooltip = get_tooltip(translation, true)
                end
            end
        end
    end
end

return mod
