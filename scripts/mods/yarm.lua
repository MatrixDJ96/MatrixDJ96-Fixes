local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")

local mod = {}

local NONE = "none"
local WARNINGS = "warnings"
local ALL = "all"

local gui_button = {
    [NONE] = "YARM_filter_none",
    [WARNINGS] = "YARM_filter_warnings",
    [ALL] = "YARM_filter_all"
}

--- @param t table
--- @param value any
--- @return boolean
function table.has(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end

    return false
end

local function check_required_conditions()
    return game.active_mods["YARM"] and game.active_mods["GUI_Unifyer"]
end

--- @param player LuaPlayer
function mod.remove_background_button(player)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    --- @type LuaGuiElement
    local frame_flow = mod_gui.get_frame_flow(player)

    local yarm_root = frame_flow.YARM_root

    -- Check if element exists and it is valid
    if yarm_root and yarm_root.valid then
        local buttons = yarm_root.buttons

        -- Check if element exists and it is valid
        if buttons and buttons.valid then
            local toggle_bg = buttons.YARM_toggle_bg

            -- Check if element exists and it is valid
            if toggle_bg and toggle_bg.valid then
                -- Remove toggle button visibility
                toggle_bg.visible = false
            end

            -- Remove buttons visibility
            buttons.visible = false
        end
    end
end

--- @param player LuaPlayer
--- @param e EventData
function mod.toggle_background(player, e)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    -- Get the clicked element from the event data
    local element = e.element --[[@as LuaGuiElement]]

    -- Get the modifier keys from the event data
    local alt = e.alt --[[@as boolean]]
    local control = e.control --[[@as boolean]]
    local shift = e.shift --[[@as boolean]]

    -- Check if one of YARM buttons was clicked
    if element and element.valid and table.has(gui_button, element.name) then
        -- Check if any modifier key is pressed
        if alt or control or shift then
            --- @type LuaGuiElement
            local button_flow = mod_gui.get_button_flow(player)
            --- @type LuaGuiElement
            local frame_flow = mod_gui.get_frame_flow(player)

            -- Get YARM root element
            local yarm_root = frame_flow.YARM_root

            -- Check if YARM root exists and it is valid
            if yarm_root and yarm_root.valid then
                -- Toggle YARM root background
                if yarm_root.style.name == "YARM_outer_frame_no_border" then
                    yarm_root.style = "YARM_outer_frame_no_border_bg"
                else
                    yarm_root.style = "YARM_outer_frame_no_border"
                end
            end

            -- Set YARM buttons visibility
            for _, value in pairs(gui_button) do
                button_flow[value].visible = element.name == value
            end

            -- local old_filter = remote.call("YARM", "get_current_filter", player.index)

            -- Set YARM filter using remote call
            if element.name == gui_button.warnings then
                remote.call("YARM", "set_filter", player.index, NONE)
            elseif element.name == gui_button.all then
                remote.call("YARM", "set_filter", player.index, WARNINGS)
            elseif element.name == gui_button.none then
                remote.call("YARM", "set_filter", player.index, ALL)
            end

            -- local new_filter = remote.call("YARM", "get_current_filter", player.index)

            -- player.print("[" .. element.name .. "] " .. old_filter .. ' -> ' .. new_filter)
        else
            if not global.players[player.index].yarm_toggle_background then
                -- Show message about keys modifier usage
                player.print({ "console.yarm_toggle_background" }, { r = 1, g = 1, b = 0 })
                -- Set flag to show this message only once
                global.players[player.index].yarm_toggle_background = true
            end
        end
    end
end

return mod
