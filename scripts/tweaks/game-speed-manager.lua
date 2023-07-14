local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local utils = require("scripts.utils")
local constants = require("constants")

local mod = {}

--- @return boolean
local function check_required_conditions(player)
    return player_data.get_settings(player, "matrixdj96_enhanced_entity_build_setting")
end


--- Modify game speed
--- @param player LuaPlayer
--- @param e EventData
local function modify_game_speed(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get input name from event data
    local input_name = e.input_name --[[@as string]]

    -- Check if input event is a supported inputs
    if utils.contains(constants.speed_events, input_name) then
        local current_speed = game.speed

        if input_name == "matrixdj96_speed_up" then
            -- Increase game speed
            game.speed = game.speed + 0.1
        elseif input_name == "matrixdj96_speed_down" then
            -- Decrease game speed
            game.speed = game.speed - 0.1
        else
            -- Get speed from input name
            local speed = tonumber(input_name:sub(-1))

            -- Check if speed is valid
            if speed ~= nil then
                -- Set game speed
                game.speed = speed
            end
        end

        -- Check if game speed has changed
        if game.speed ~= current_speed then
            -- Add flying text to player
            player.create_local_flying_text({
                text = "Game speed: " .. game.speed,
                position = player.position,
                color = player.color
            })
        end
    end
end

-- Define events that will be handled
mod.events = {}

for _, value in pairs(constants.speed_events) do
    mod.events[value] = modify_game_speed
end
return mod
