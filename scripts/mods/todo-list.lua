local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")
local utils = require("scripts.utils")

local mod = {}

-- Create shortcuts for constants
local maximize = constants.maximize
local minimize = constants.minimize
local todo_buttons = constants.todo_buttons
local dummy_todo_buttons = constants.dummy_todo_buttons
local all_todo_buttons = utils.insert(todo_buttons, dummy_todo_buttons)

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return global_data.is_mod_active("Todo-List") and not global_data.is_mod_active("GUI_Unifyer")
end

--- @param player LuaPlayer
--- @param string string
--- @return LocalisedString
local function todo_translate(player, string)
    -- Get the translation mode setting
    local translation_mode = player_data.get_settings(player, "todolist-translation-mode")

    -- Simulate todo-list translations
    if (translation_mode.value == "quest") then
        string = "todo.quest_" .. string
    else
        string = "todo." .. string
    end

    return { string }
end

--- @param player LuaPlayer
--- @return table<string, LuaGuiElement>
local function get_todo_elements(player)
    --- @type LuaGuiElement
    local button_flow = mod_gui.get_button_flow(player)

    -- Get the todo-list related elements
    local todo_main_frame = player.gui.screen.todo_main_frame
    local todo_maximize_button = button_flow.todo_maximize_button
    local dummy_todo_maximize_button = button_flow.dummy_todo_maximize_button

    return {
        todo_main_frame = todo_main_frame,
        todo_maximize_button = todo_maximize_button,
        dummy_todo_maximize_button = dummy_todo_maximize_button
    }
end

--- Add todo-list top button
--- @param player LuaPlayer
local function add_top_button(player, force)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    --- @type LuaGuiElement
    local button_flow = mod_gui.get_button_flow(player)

    local todo_maximize_button = button_flow.todo_maximize_button
    local dummy_todo_maximize_button = button_flow.dummy_todo_maximize_button

    -- Restore the old todo-list button if it exists
    if force and todo_maximize_button ~= nil then
        -- Destroy the old todo-list button
        todo_maximize_button.destroy()

        -- Create the old todo-list button
        todo_maximize_button = button_flow.add({
            type = "button",
            style = "todo_button_default",
            name = todo_buttons[maximize],
            caption = todo_translate(player, "todo_list"),
        })
    end

    -- Destroy the new todo-list button if it exists
    if force and dummy_todo_maximize_button ~= nil then
        dummy_todo_maximize_button.destroy()
        dummy_todo_maximize_button = nil
    end

    -- Check if todo-list button exists
    if todo_maximize_button ~= nil then
        -- Check if todo-list button is a button
        if todo_maximize_button.type == "button" then
            -- Destroy the todo-list button
            todo_maximize_button.destroy()

            -- Create the todo-list sprite-button
            button_flow.add({
                name = todo_buttons[maximize],
                tooltip = "Todo List",
                type = "sprite-button",
                style = "mod_gui_button",
                sprite = "matrixdj96_todo_list_icon",
            })
        end

        -- Check if new todo-list button exists
        if dummy_todo_maximize_button == nil then
            -- Create the  new todo-list button
            button_flow.add({
                name = dummy_todo_buttons[maximize],
                tooltip = "Todo List",
                type = "sprite-button",
                style = "mod_gui_button",
                sprite = "matrixdj96_todo_list_icon",
                visible = false
            })
        end
    end

    player.print("todo-list: add_top_button(" .. (force and "true" or "false") .. ")")
end

--- Update todo-list buttons
--- @param player LuaPlayer
local function update_top_buttons(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get the todo-list related elements
    local elements = get_todo_elements(player)

    -- Toggle the todo-list buttons visibility
    elements[todo_buttons[maximize]].visible = not (elements.todo_main_frame and elements.todo_main_frame.valid)
    elements[dummy_todo_buttons[maximize]].visible = elements.todo_main_frame and elements.todo_main_frame.valid

    -- Remove the todo-list button caption
    elements.todo_maximize_button.caption = ""

    player.print("todo-list: update_top_button")
end

--- Toggle todo-list window
--- @param player LuaPlayer
--- @param e EventData
local function toggle_window(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get the clicked element from the event data
    local element = e.element --[[@as LuaGuiElement]]

    -- Check if the clicked element is the todo-list button
    if element ~= nil and element.valid and utils.contains(all_todo_buttons, element.name) then
        -- Get the todo-list related elements
        local elements = get_todo_elements(player)

        -- Check if the todo-list frame exists
        if elements.todo_main_frame ~= nil then
            for _, item in pairs(elements.todo_main_frame.children) do
                -- Get the todo-list minimize button
                local todo_minimize_button = item[todo_buttons[minimize]]

                if todo_minimize_button ~= nil then
                    -- Define dummy todo-list minimize button
                    local dummy_todo_minimize_button = {
                        type = todo_minimize_button["type"],
                        style = todo_minimize_button["style"].name,
                        sprite = todo_minimize_button["sprite"],
                        name = dummy_todo_buttons[minimize]
                    }

                    -- Destroy the todo-list minimize button
                    todo_minimize_button.destroy()

                    -- Add the dummy todo-list minimize button
                    item.add(dummy_todo_minimize_button)
                end
            end

            player.print("todo-list: toggle_window(" .. element.name .. ")")

            if utils.contains(dummy_todo_buttons, element.name) then
                -- Destroy the todo-list frame
                elements.todo_main_frame.destroy()
            end
        end

        -- Update todo-list buttons
        update_top_buttons(player)
    end
end

--- Initialize todo-list mod
--- @param player LuaPlayer
--- @param force? boolean
function mod.init(player, force)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    player.print("todo-list: init(" .. (force and "true" or "false") .. ") - start")

    -- Add todo-list top button
    add_top_button(player, force)

    player.print("todo-list: init(" .. (force and "true" or "false") .. ") - end")
end

-- Define events that will be handled
mod.events = {
    [defines.events.on_gui_click] = toggle_window,
    [defines.events.on_gui_opened] = toggle_window,
    [defines.events.on_gui_closed] = update_top_buttons,
    [defines.events.on_player_joined_game] = defines.events.on_player_created,
}

return mod
