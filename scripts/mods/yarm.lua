local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

local mod = {}

--- @param table table
--- @param value any
--- @return boolean
local function contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end

    return false
end

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return global_data.is_mod_active("YARM") and global_data.is_mod_active("GUI_Unifyer")
end

--- @param player LuaPlayer
--- @param filter? string
function mod.force_sites_filter(player, filter)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    remote.call("YARM", "set_filter", player.index, filter or constants.WARNINGS)
end

--- Remove YARM background toggle
--- @param player LuaPlayer
function mod.remove_background_button(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    --- @type LuaGuiElement
    local frame_flow = mod_gui.get_frame_flow(player)

    local yarm_root = frame_flow.YARM_root

    -- Check if YARM root exists and it is valid
    if yarm_root and yarm_root.valid then
        local buttons = yarm_root.buttons

        -- Check if buttons exists and it is valid
        if buttons and buttons.valid then
            local toggle_bg = buttons.YARM_toggle_bg

            -- Check if toggle_bg exists and it is valid
            if toggle_bg and toggle_bg.valid then
                -- Remove toggle button visibility
                toggle_bg.visible = false
            end

            -- Remove buttons visibility
            buttons.visible = false
        end
    end
end

--- Toggle YARM background
--- @param player LuaPlayer
--- @param e EventData
function mod.toggle_background(player, e)
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

    -- Check if one of YARM buttons was clicked
    if element and element.valid and contains(constants.yarm_buttons, element.name) then
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
            for _, value in pairs(constants.yarm_buttons) do
                button_flow[value].visible = element.name == value
            end

            -- Set YARM filter using remote call
            if element.name == constants.yarm_buttons.warnings then
                mod.force_sites_filter(player, constants.NONE)
            elseif element.name == constants.yarm_buttons.all then
                mod.force_sites_filter(player, constants.WARNINGS)
            elseif element.name == constants.yarm_buttons.none then
                mod.force_sites_filter(player, constants.ALL)
            end
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

-- Define events that will be handled
mod.events = {
    [defines.events.on_gui_click] = mod.toggle_background,
    [defines.events.on_gui_opened] = mod.toggle_background,
    [defines.events.on_player_created] = mod.force_sites_filter,
    [defines.events.on_player_joined_game] = mod.remove_background_button,
}

return mod
