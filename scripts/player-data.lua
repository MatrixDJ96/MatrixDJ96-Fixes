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

    if not has_inventory_opened(player) then
        if player.gui.left["manual-inventory-sort-buttons"] then
            player.gui.left["manual-inventory-sort-buttons"].destroy()
        end
    else
        if not player.gui.left["manual-inventory-sort-buttons"] then
            local frame = player.gui.left.add({
                type = "frame",
                name = "manual-inventory-sort-buttons",
                direction = "vertical",
				caption = {"manual-inventory-gui-sort-title"}
			})
			frame.add({type = "button", name = "manual-inventory-sort-player", caption = {"manual-inventory-gui-sort_player"}})
			if player.controller_type == defines.controllers.character then
				frame.add({type = "button", name = "manual-inventory-sort-player-trash", caption = {"manual-inventory-gui-sort_player_trash"}})
            end
        end
    end

    if not player.gui.left["manual-inventory-sort-buttons"] then
        if player.gui.relative["manual-inventory-sort-buttons"] then
            player.gui.relative["manual-inventory-sort-buttons"].destroy()
        end
    end

    -- player.print(serpent.block("fix_manual_inventory_sort"))
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
