local mod_gui = require("__core__.lualib.mod-gui")

local mod = {}

local function check_required_conditions()
    return game.active_mods["TaskList"]
end

--- @param player LuaPlayer
--- @param force? boolean
function mod.add_top_button(player, force)
    -- Check if required conditions are met
    if not check_required_conditions() then
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

--- @param player LuaPlayer
--- @param e EventData
function mod.toggle_window(player, e)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    -- Get the clicked element from the event data
    local element = e.element --[[@as LuaGuiElement]]

    -- Check if the task-list button is valid and if it has been clicked
    if element and element.valid and element.name == "task_maximize_button" then
        if player.gui.screen.tlst_tasks_window then
            -- Toggle the task-list window visibility
            player.gui.screen.tlst_tasks_window.visible = not player.gui.screen.tlst_tasks_window.visible
        end
    end
end

return mod
