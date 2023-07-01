local mod_gui = require("__core__.lualib.mod-gui")

local player_data = {}

local has_inventory_opened = function(player)
    if player.opened_self or (player.opened_gui_type == defines.gui_type.blueprint_library) or player.opened_gui_type == (defines.gui_type.other_player) then
        return true
    end

    if player.opened_gui_type == defines.gui_type.entity then
        for _, index in pairs(defines.inventory) do
            local inventory = player.opened.get_inventory(index)
            if inventory and inventory.valid then
                return true
            end
        end
    end
end

player_data.fix_manual_inventory_sort = function(player, force)
    if not game.active_mods["manual-inventory-sort"] or not settings.player["manual-inventory-sort-buttons"] then
        return
    end

    if player.gui.left["manual-inventory-sort-buttons"] then
        if has_inventory_opened(player) then
            local localised_strings = {
                { "gui.character" },
                { "gui-logistic.trash-slots" }
            }

            for _, item in ipairs(player.gui.left["manual-inventory-sort-buttons"].children_names) do
                if item == "manual-inventory-sort-opened" then
                    localised_strings[3] = player.opened.localised_name
                end
            end

            local request_ids = player.request_translations(localised_strings)

            for _, relative_gui_type in pairs(defines.relative_gui_type) do
                local name = "manual-inventory-sort-buttons-" .. relative_gui_type
                local anchor = { gui = relative_gui_type, position = defines.relative_gui_position.left }

                if player.gui.relative[name] then
                    player.gui.relative[name].destroy()
                end

                local frame = player.gui.relative.add({
                    name = name,
                    type = "frame",
                    style = "quick_bar_window_frame",
                    direction = "vertical",
                    anchor = anchor
                })

                frame.add({
                    type = "sprite-button",
                    name = "manual-inventory-sort-player",
                    tooltip = request_ids[1],
                    style = "mod_gui_button",
                    sprite = "entity/character"
                })

                if player.opened_self and player.force.character_logistic_requests then
                    frame.add({
                        type = "sprite-button",
                        name = "manual-inventory-sort-player-trash",
                        tooltip = request_ids[2],
                        style = "mod_gui_button",
                        sprite = "matrixdj96_trash_icon"
                    })
                end

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

        player.gui.left["manual-inventory-sort-buttons"].destroy()
    end

    -- player.print(serpent.block("fix_manual_inventory_sort"))
end

player_data.translate_manual_inventory_sort = function(player, id, result)
    for _, relative_gui_type in pairs(defines.relative_gui_type) do
        local name = "manual-inventory-sort-buttons-" .. relative_gui_type

        if player.gui.relative[name] then
            for _, item in ipairs(player.gui.relative[name].children) do
                if item.tooltip == tostring(id) then
                    item.tooltip = "Sort " .. string.lower(result)
                end
            end
        end

        -- player.print(serpent.block("translate_manual_inventory_sort"))
    end
end

player_data.fix_task_list = function(player, force)
    if not game.active_mods["TaskList"] then
        return
    end

    local button_flow = mod_gui.get_button_flow(player)

    if force and button_flow.task_maximize_button then
        button_flow.task_maximize_button.destroy()
    end

    if not button_flow.task_maximize_button then
        button_flow.add({
            name = "task_maximize_button",
            tooltip = "Task List",
            type = "sprite-button",
            style = "mod_gui_button",
            sprite = "matrixdj96_task_list_icon"
        })
    end

    -- player.print(serpent.block("fix_task_list"))
end

player_data.toggle_task_list = function(player, element)
    if element and element.name == "task_maximize_button" and player.gui.screen.tlst_tasks_window then
        player.gui.screen.tlst_tasks_window.visible = not player.gui.screen.tlst_tasks_window.visible
    end
end

player_data.fix_all = function(player, force)
    player_data.fix_manual_inventory_sort(player, force)
    player_data.fix_task_list(player, force)
end

return player_data
