local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")
local utils = require("scripts.utils")

local mod = {}

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return global_data.is_mod_active("YARM")
end

--- @param player LuaPlayer
--- @return string
local function get_current_filter(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return constants.none
    end

    return remote.call("YARM", "get_current_filter", player.index)
end

--- @param player LuaPlayer
--- @param filter? string
local function force_sites_filter(player, filter)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    remote.call("YARM", "set_filter", player.index, filter or constants.warnings)

    player.print("yarm: force_sites_filter(" .. (filter or constants.warnings) .. ")")
end

--- @param player LuaPlayer
--- @return table<string, LuaGuiElement>
local function get_gui_buttons(player)
    --- @type LuaGuiElement
    local button_flow = mod_gui.get_button_flow(player)

    -- Define gui buttons
    local gui_buttons = {}

    for name, value in pairs(constants.yarm_buttons) do
        gui_buttons[name] = button_flow[value]
    end

    return gui_buttons
end

--- Add todo-list top button
--- @param player LuaPlayer
--- @param force? boolean
local function add_top_button(player, force)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Check if GUI_Unifyer is active
    local gui_unifyer = global_data.is_mod_active("GUI_Unifyer")

    -- Get current YARM filter for the player
    local current_filter = get_current_filter(player)

    --- @type LuaGuiElement
    local button_flow = mod_gui.get_button_flow(player)

    for filter, name in pairs(constants.yarm_buttons) do
        if force and button_flow[name] ~= nil then
            button_flow[name].destroy()
        end

        if not gui_unifyer then
            if button_flow[name] == nil then
                button_flow.add({
                    name = name,
                    tooltip = { "gui.matrixdj96_yarm_" .. filter .. "_button" },
                    type = "sprite-button",
                    style = "mod_gui_button",
                    sprite = "matrixdj96_yarm_icon"
                })
            end

            -- Set button visibility based on current filter
            button_flow[name].visible = current_filter == filter
        end
    end

    player.print("yarm: add_top_button(" .. (force and "true" or "false") .. ")")
end

--- Hide YARM left buttons
--- @param player LuaPlayer
local function hide_left_buttons(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    --- @type LuaGuiElement
    local frame_flow = mod_gui.get_frame_flow(player)

    local yarm_root = frame_flow.YARM_root

    -- Check if YARM root exists
    if yarm_root ~= nil then
        local buttons = yarm_root.buttons

        -- Check if buttons exists
        if buttons ~= nil then
            -- Remove buttons visibility
            buttons.visible = false
        end
    end

    player.print("yarm: hide_left_buttons")
end

--- Toggle YARM background
--- @param player LuaPlayer
--- @param e EventData
local function toggle_background(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get the clicked element from the event data
    local element = e.element --[[@as LuaGuiElement]]

    -- Get the modifier keys from the event data
    local alt = e.alt --[[@as boolean]]
    local control = e.control --[[@as boolean]]
    local shift = e.shift --[[@as boolean]]

    -- Check if one of YARM buttons has been clicked
    if element ~= nil and element.valid and utils.contains(constants.yarm_buttons, element.name) then
        -- Get custom YARM buttons
        local gui_buttons = get_gui_buttons(player)

        -- Check if any modifier key is pressed
        if alt or control or shift then
            --- @type LuaGuiElement
            local frame_flow = mod_gui.get_frame_flow(player)

            -- Get YARM root element
            local yarm_root = frame_flow.YARM_root

            -- Check if YARM root exists
            if yarm_root ~= nil then
                -- Toggle YARM root background
                if yarm_root.style.name == "YARM_outer_frame_no_border" then
                    yarm_root.style = "YARM_outer_frame_no_border_bg"
                else
                    yarm_root.style = "YARM_outer_frame_no_border"
                end
            end

            if global_data.is_mod_active("GUI_Unifyer") then
                -- Set YARM buttons visibility
                for name, value in pairs(constants.yarm_buttons) do
                    gui_buttons[name].visible = element.name == value
                end

                -- Set YARM filter using remote call
                if element.name == constants.yarm_buttons.none then
                    force_sites_filter(player, constants.all)
                elseif element.name == constants.yarm_buttons.warnings then
                    force_sites_filter(player, constants.none)
                elseif element.name == constants.yarm_buttons.all then
                    force_sites_filter(player, constants.warnings)
                end
            end

            player.print("yarm: toggle_background(true)")
        else
            if not global_data.is_mod_active("GUI_Unifyer") then
                -- Get current YARM filter for the player
                local current_filter = get_current_filter(player)

                -- Update current YARM filter for the player
                if current_filter == constants.none then
                    current_filter = constants.warnings
                elseif current_filter == constants.warnings then
                    current_filter = constants.all
                elseif current_filter == constants.all then
                    current_filter = constants.none
                end

                -- Update YARM buttons visibility
                for name, button in pairs(gui_buttons) do
                    button.visible = name == current_filter
                end

                -- Set YARM filter using remote call
                force_sites_filter(player, current_filter)
            end

            if not global.players[player.index].yarm_toggle_background then
                -- Show message about keys modifier usage
                player.print({ "console.matrixdj96_yarm_toggle_background" }, { r = 1, g = 1, b = 0 })
                -- Set flag to show this message only once
                global.players[player.index].yarm_toggle_background = true
            end

            player.print("yarm: toggle_background(false)")
        end
    end
end

--- Initialize YARM mod
--- @param player LuaPlayer
--- @param force? boolean
function mod.init(player, force)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    player.print("yarm: init(" .. (force and "true" or "false") .. ") - start ")

    -- Force YARM filter to warnings
    force_sites_filter(player)

    -- Hide YARM left buttons
    hide_left_buttons(player)

    -- Add YARM top button
    add_top_button(player, force)

    player.print("yarm: init(" .. (force and "true" or "false") .. ") - end")
end

-- Define events that will be handled
mod.events = {
    [defines.events.on_gui_click] = toggle_background,
    [defines.events.on_player_joined_game] = defines.events.on_player_created
}

return mod
