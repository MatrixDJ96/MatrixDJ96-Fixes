local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")

local mod = {}

local check_required_conditions = function()
    return game.active_mods["YARM"] and game.active_mods["GUI_Unifyer"]
end

--- @param player LuaPlayer
mod.remove_bg_toggle = function(player)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    local frame_flow = mod_gui.get_frame_flow(player)

    -- Check if the YARM toggle background exists
    if frame_flow.YARM_root.buttons.YARM_toggle_bg then
        -- Set visibility of the YARM toggle background
        frame_flow.YARM_root.buttons.YARM_toggle_bg.visible = false
    end
end

return mod
