local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

local mod = {}

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return global_data.is_mod_active("TaskList")
end

--- Add task-list top button
--- @param player LuaPlayer
--- @param force? boolean
local function add_top_button(player, force)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    --- @type LuaGuiElement
    local button_flow = mod_gui.get_button_flow(player)

    local task_maximize_button = button_flow.task_maximize_button

    -- Destroy the task-list button if it exists
    if force and task_maximize_button then
        task_maximize_button.destroy()
        task_maximize_button = nil
    end

    -- Check if task-list button already exists
    if not task_maximize_button then
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

--- Toggle task-list window
--- @param player LuaPlayer
--- @param e EventData
local function toggle_window(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get the clicked element from the event data
    local element = e.element --[[@as LuaGuiElement]]

    -- Check if the clicked element is the task-list button
    if element ~= nil and element.valid and element.name == "task_maximize_button" then
        if player.gui.screen.tlst_tasks_window then
            -- Toggle the task-list window visibility
            player.gui.screen.tlst_tasks_window.visible = not player.gui.screen.tlst_tasks_window.visible
        end
    end
end

--- Initialize task-list mod
--- @param player LuaPlayer
--- @param force? boolean
function mod.init(player, force)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Add task-list top button
    add_top_button(player, force)
end

-- Define events that will be handled
mod.events = {
    [defines.events.on_gui_click] = toggle_window
}

return mod
