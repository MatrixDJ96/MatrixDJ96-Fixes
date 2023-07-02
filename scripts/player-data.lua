local mod_gui = require("__core__.lualib.mod-gui")

local player_data = {}

--- @param player LuaPlayer
local has_inventory_opened = function(player)
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

--- @param player LuaPlayer
player_data.fix_manual_inventory_sort = function(player)
    -- Check if the mod is enabled and the player has the setting enabled
    if not game.active_mods["manual-inventory-sort"] or not settings.player["manual-inventory-sort-buttons"] then
        return
    end

    local sort_buttons = player.gui.left["manual-inventory-sort-buttons"]

    -- Check if buttons has been created for the player
    if sort_buttons and sort_buttons.valid then
        -- Perform a better check on inventory
        if has_inventory_opened(player) then
            local localised_strings = {
                { "gui.character" },
                { "gui-logistic.trash-slots" }
            }

            -- Check if the player has opened a supported entity by manual-inventory-sort
            if sort_buttons["manual-inventory-sort-opened"] then
                localised_strings[3] = player.opened.localised_name
            end

            -- Try to request the localised strings from the player translations
            local request_ids = player.request_translations(localised_strings) or localised_strings

            -- Create the new buttons for all types of relative GUIs
            for _, relative_gui_type in pairs(defines.relative_gui_type) do
                local name = "manual-inventory-sort-buttons-" .. relative_gui_type
                local anchor = { gui = relative_gui_type, position = defines.relative_gui_position.left }

                -- Destroy the old frame buttons
                if player.gui.relative[name] then
                    player.gui.relative[name].destroy()
                end

                --- @type LuaGuiElement
                -- Create the new frame buttons
                local frame = player.gui.relative.add({
                    name = name,
                    type = "frame",
                    style = "quick_bar_window_frame",
                    direction = "vertical",
                    anchor = anchor
                })

                -- Add player inventory sort button
                frame.add({
                    type = "sprite-button",
                    name = "manual-inventory-sort-player",
                    tooltip = request_ids[1],
                    style = "mod_gui_button",
                    sprite = "entity/character"
                })

                if player.opened_self and player.force.character_logistic_requests then
                    -- Add player trash sort button
                    frame.add({
                        type = "sprite-button",
                        name = "manual-inventory-sort-player-trash",
                        tooltip = request_ids[2],
                        style = "mod_gui_button",
                        sprite = "matrixdj96_trash_icon"
                    })
                end

                -- Add opened entity sort button
                if localised_strings[3] then
                    frame.add({
                        type = "sprite-button",
                        name = "manual-inventory-sort-opened",
                        tooltip = request_ids[3],
                        style = "mod_gui_button",
                        sprite = "entity/" .. player.opened.name
                    })
                end
            end
        end

        -- Destroy the buttons created by manual-inventory-sort
        sort_buttons.destroy()
    end
end

--- @param player LuaPlayer
--- @param id uint
--- @param result string
player_data.translate_manual_inventory_sort_tooltip = function(player, id, result)
    -- Update buttons tooltip for all types of relative GUIs
    for _, relative_gui_type in pairs(defines.relative_gui_type) do
        local name = "manual-inventory-sort-buttons-" .. relative_gui_type

        -- Check if the buttons has been created
        if player.gui.relative[name] then
            for _, item in ipairs(player.gui.relative[name].children) do
                -- Find the button with the matching tooltip id
                if item.tooltip == tostring(id) then
                    -- Update the tooltip with the new translation
                    item.tooltip = "Sort " .. string.lower(result)
                end
            end
        end
    end
end

--- @param player LuaPlayer
--- @param force? boolean
player_data.add_task_list_button = function(player, force)
    if not game.active_mods["TaskList"] then
        return
    end

    local button_flow = mod_gui.get_button_flow(player)

    -- Destroy the task-list button if it exists and force is true
    if force and button_flow.task_maximize_button then
        button_flow.task_maximize_button.destroy()
    end

    -- Check if task-list button already exists
    if not button_flow.task_maximize_button then
        -- Create the task-list button
        button_flow.add({
            name = "task_maximize_button",
            tooltip = "Task List",
            type = "sprite-button",
            style = "mod_gui_button",
            sprite = "matrixdj96_task_list_icon"
        })
    end
end

--- @param player LuaPlayer
--- @param element? LuaGuiElement
player_data.toggle_task_list = function(player, element)
    -- Check if the task-list button was clicked and toggle the task-list window
    if element and element.name == "task_maximize_button" and player.gui.screen.tlst_tasks_window then
        player.gui.screen.tlst_tasks_window.visible = not player.gui.screen.tlst_tasks_window.visible
    end
end

return player_data
