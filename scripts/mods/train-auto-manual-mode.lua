local player_data = require("scripts.player-data")

local mod = {}

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return not game.active_mods["auto_manual_mode"] and player_data.get_settings(player, "matrixdj96_train_mode_setting")
end

--- @param vehicle LuaEntity
---@param manual_mode boolean
local function set_manual_mode(vehicle, manual_mode)
    local train = vehicle.train

    -- Check if vehicle is a train
    if train and train.valid then
        -- Update vehicle manual mode
        train.manual_mode = manual_mode
    end
end

--- @param player LuaPlayer
--- @param e EventData
function mod.update_manual_mode(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Check if player is in game render mode (not in map view)
    if player.render_mode == defines.render_mode.game then
        -- Get vehicle from event data and player
        local e_vehicle = e.entity --[[@as LuaEntity]]
        local p_vehicle = player.vehicle --[[@as LuaEntity]]

        -- Check if player exited from train
        if e_vehicle and e_vehicle.valid then
            set_manual_mode(e_vehicle, false)
        else
            -- Check if player is inside a train
            if p_vehicle and p_vehicle.valid then
                set_manual_mode(p_vehicle, true)
            end
        end
    end
end

return mod
