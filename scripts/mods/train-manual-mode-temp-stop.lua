local global_data = require("scripts.global-data")

local mod = {}

--- @return boolean
local function check_required_conditions()
    return not global_data.is_mod_active("manual-trains-at-temp-stops")
end


--- @param train LuaTrain
function mod.update_manual_mode(train)
    -- Check if required conditions are met
    if not check_required_conditions() then
        return
    end

    if train ~= nil and train.valid then
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

return mod
