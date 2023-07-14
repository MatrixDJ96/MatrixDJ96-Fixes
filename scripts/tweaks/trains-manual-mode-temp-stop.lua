local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

local mod = {}

--- @return boolean
local function check_required_conditions(player)
    return not global_data.is_mod_active("manual-trains-at-temp-stops") and
        global_data.get_settings("matrixdj96_train_manual_mode_temp_stop_setting")
end

--- Update train manual mode
--- @param player LuaPlayer
--- @param e EventData
local function update_manual_mode(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get train from event data
    local train = e.train --[[@as LuaTrain]]

    -- Check if train exists
    if train ~= nil then
        -- Get schedule from train
        local schedule = train.schedule

        -- Check if train is waiting at station and it has scheduled stops
        if train.state == defines.train_state.wait_station and schedule ~= nil then
            -- Get current stop from train schedule list
            local current_stop = schedule.records[schedule.current]

            -- Check if current schedule is a temporary stop
            if current_stop ~= nil and current_stop.temporary then
                -- Remove current stop from train schedule
                table.remove(schedule.records, schedule.current)

                -- Get size of train schedule list
                local total_records = #schedule.records

                if total_records > 0 then
                    -- Update schedule stop index after removal
                    if total_records < schedule.current then
                        schedule.current = #schedule.records --[[@as uint]]
                    end

                    -- Update train schedule
                    train.schedule = schedule
                else
                    -- Remove train schedule
                    train.schedule = nil
                end

                -- Set train to manual mode
                train.manual_mode = true
            end
        end
    end
end

-- Define events that will be handled
mod.events = {
    [defines.events.on_train_changed_state] = update_manual_mode
}

return mod
