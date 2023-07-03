local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")

local mod = {}

local check_required_conditions = function()
    return game.active_mods["TaskList"]
end

--- @param player LuaPlayer
--- @param force? boolean
mod.add_top_button = function(player, force)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    local button_flow = mod_gui.get_button_flow(player)

    -- Destroy the task-list button if it exists
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
mod.toggle_window = function(player, element)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    -- Check if the task-list button was clicked and toggle the task-list window
    if element and element.name == "task_maximize_button" and player.gui.screen.tlst_tasks_window then
        player.gui.screen.tlst_tasks_window.visible = not player.gui.screen.tlst_tasks_window.visible
    end
end

return mod
