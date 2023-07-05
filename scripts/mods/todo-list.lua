local mod_gui = require("__core__.lualib.mod-gui")
local player_data = require("scripts.player-data")

local mod = {}

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return game.active_mods["Todo-List"] and not game.active_mods["GUI_Unifyer"]
end

--- @param player LuaPlayer
--- @param string string
--- @return LocalisedString
local function todo_translate(player, string)
    -- Get the translation mode setting
    local translation_mode = player_data.get_player_settings(player, "todolist-translation-mode")

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

--- @param player LuaPlayer
function mod.add_top_button(player, force)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    --- @type LuaGuiElement
    local button_flow = mod_gui.get_button_flow(player)

    local todo_maximize_button = button_flow.todo_maximize_button
    local dummy_todo_maximize_button = button_flow.dummy_todo_maximize_button

    -- Destroy the new todo-list button if it exists
    if force and dummy_todo_maximize_button then
        dummy_todo_maximize_button.destroy()
        dummy_todo_maximize_button = nil
    end

    -- Restore the old todo-list button if it exists
    if force and todo_maximize_button then
        -- Destroy the old todo-list button
        todo_maximize_button.destroy()

        -- Create the old todo-list button
        todo_maximize_button = button_flow.add({
            type = "button",
            style = "todo_button_default",
            name = "todo_maximize_button",
            caption = todo_translate(player, "todo_list"),
        })
    end

    if todo_maximize_button and todo_maximize_button.valid then
        if button_flow.todo_maximize_button.type == "button" then
            button_flow.todo_maximize_button.destroy()

            button_flow.add({
                name = "todo_maximize_button",
                tooltip = "Todo List",
                type = "sprite-button",
                style = "mod_gui_button",
                sprite = "matrixdj96_todo_list_icon",
            })
        end

        -- Check if new todo-list button exists
        if not dummy_todo_maximize_button then
            -- Create the  new todo-list button
            button_flow.add({
                name = "dummy_todo_maximize_button",
                tooltip = "Todo List",
                type = "sprite-button",
                style = "mod_gui_button",
                sprite = "matrixdj96_todo_list_icon",
                visible = false
            })
        end
    end
end

--- @param player LuaPlayer
--- @param elements? table<string, LuaGuiElement>
function mod.update_top_buttons(player, elements)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get the todo-list related elements
    if not elements then
        elements = get_todo_elements(player)
    end

    -- Toggle the todo-list buttons visibility
    elements.todo_maximize_button.visible = not (elements.todo_main_frame and elements.todo_main_frame.valid)
    elements.dummy_todo_maximize_button.visible = elements.todo_main_frame and elements.todo_main_frame.valid

    -- Remove the todo-list button caption
    elements.todo_maximize_button.caption = ""
end

--- @param player LuaPlayer
--- @param e EventData
function mod.toggle_window(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get the clicked element from the event data
    local element = e.element --[[@as LuaGuiElement]]

    -- Check if element exists and it is valid
    if element and element.valid then
        -- Check if the clicked element is the todo-list button
        if element.name == "todo_maximize_button" or element.name == "dummy_todo_maximize_button" or element.name == "dummy_todo_minimize_button" then
            -- Get the todo-list related elements
            local elements = get_todo_elements(player)

            -- Check if the todo-list frame exists and it is valid
            if elements.todo_main_frame and elements.todo_main_frame.valid then
                for _, item in pairs(elements.todo_main_frame.children) do
                    local todo_minimize_button = item["todo_minimize_button"]

                    if todo_minimize_button and todo_minimize_button.valid then
                        local dummy_todo_minimize_button = {
                            type = todo_minimize_button["type"],
                            style = todo_minimize_button["style"].name,
                            sprite = todo_minimize_button["sprite"],
                            name = "dummy_todo_minimize_button"
                        }

                        todo_minimize_button.destroy()
                        item.add(dummy_todo_minimize_button)
                    end
                end

                if element.name == "dummy_todo_maximize_button" or element.name == "dummy_todo_minimize_button" then
                    -- Destroy the todo-list frame
                    elements.todo_main_frame.destroy()
                end
            end

            -- Update visibility of todo-list buttons
            mod.update_top_buttons(player, elements)
        end
    end
end

return mod
