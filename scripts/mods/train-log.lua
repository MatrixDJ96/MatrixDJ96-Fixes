local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")

local mod = {}

local function check_required_conditions()
    return game.active_mods["train-log"] and not game.active_mods["GUI_Unifyer"]
end

--- @param player LuaPlayer
--- @param force? boolean
function mod.update_top_button(player, force)
    -- Check if required conditions are met
    if not check_required_conditions() then
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

return mod
