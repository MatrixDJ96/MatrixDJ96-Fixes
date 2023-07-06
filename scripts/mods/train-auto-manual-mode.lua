local player_data = require("scripts.player-data")

local mod = {}

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return not game.active_mods["auto_manual_mode"] and player_data.get_settings(player, "matrixdj96_auto_manual_mode_setting")
end

--- @param player LuaPlayer
--- @param driving_changed_state boolean
function mod.update_manual_mode(player, driving_changed_state)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Check if player is in game render mode (not in map view)
    if player.render_mode == defines.render_mode.game then
        -- Get vehicle from player data
        local vehicle = player.vehicle --[[@as LuaEntity]]

        if not driving_changed_state then
            -- Check if player is in vehicle
            if vehicle ~= nil and vehicle.valid then
                local train = vehicle.train --[[@as LuaTrain]]
                -- Check if vehicle is a train
                if train ~= nil and train.valid then
                    -- Check if train is in manual mode
                    if not train.manual_mode then
                        -- Add train to player data
                        player_data.set_train(player, train)
                        -- Set train to manual mode
                        train.manual_mode = true

                        -- Create flying text over player position
                        player.create_local_flying_text({
                            text = { "tooltip.matrixdj96_set_train_manual_mode" },
                            position = player.position,
                            color = player.color,
                        })
                    end
                end
            end
        else
            -- Check if restore automatic mode setting is enabled
            if player_data.get_settings(player, "matrixdj96_restore_automatic_mode_setting") then
                -- Get train with manual mode from player data
                local train = player_data.get_train(player)

                -- Check if train with manual mode exists
                if train ~= nil and train.valid then
                    -- Restore train manual mode
                    train.manual_mode = false
                    -- Remove train from player data
                    player_data.set_train(player, nil)

                    -- Create flying text over player position
                    player.create_local_flying_text({
                        text = { "tooltip.matrixdj96_restore_train_auto_mode" },
                        position = player.position,
                        color = player.color,
                    })
                end
            end
        end
    end
end

return mod
