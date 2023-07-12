local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

local mod = {}

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return global_data.is_mod_active("train-log") and not global_data.is_mod_active("GUI_Unifyer")
end

--- Update train-log top button
--- @param player LuaPlayer
function mod.update_top_button(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    --- @type LuaGuiElement
    local button_flow = mod_gui.get_button_flow(player)

    local train_log = button_flow.train_log

    -- Check if the button exists and it is valid
    if train_log and train_log.valid then
        train_log.style = "mod_gui_button"
        train_log.sprite = "matrixdj96_train_log_icon"
    end
end

-- Define events that will be handled
mod.events = {
    [defines.events.on_player_joined_game] = mod.update_top_button,
}

return mod
