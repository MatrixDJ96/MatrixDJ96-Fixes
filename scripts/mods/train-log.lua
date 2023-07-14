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
local function update_top_button(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    --- @type LuaGuiElement
    local button_flow = mod_gui.get_button_flow(player)

    local train_log = button_flow.train_log

    -- Create the train-log button
    if train_log == nil then
        button_flow.add({
            name = "train_log",
            tooltip = "Train Log",
            type = "sprite-button",
            style = "mod_gui_button",
            sprite = "matrixdj96_train_log_icon"
        })

        player.print("train-log: update_top_button(add)")
    end

    -- Update the train-log button
    if train_log ~= nil then
        -- Set the button style and sprite
        train_log.style = "mod_gui_button"
        train_log.sprite = "matrixdj96_train_log_icon"

        player.print("train-log: update_top_button(modify)")
    end
end

--- Initialize train-log mod
--- @param player LuaPlayer
--- @param force? boolean
function mod.init(player, force)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    player.print("train-log: init(" .. (force and "true" or "false") .. ") - start")

    -- Add the train-log top button
    update_top_button(player)

    player.print("train-log: init(" .. (force and "true" or "false") .. ") - end")
end

-- Define events that will be handled
mod.events = {
    [defines.events.on_player_joined_game] = defines.events.on_player_created
}

return mod
