local player_data = require("scripts.player-data")
local utils = require("scripts.utils")

local global_data = {}

--- @param e? ConfigurationChangedData
function global_data.init(e)
    if not global.players then
        -- Initialize players table
        global.players = {}
    end

    -- Check if event exists and there are mod changes
    if e ~= nil and utils.size(e.mod_changes) > 0 then
        for index, _ in pairs(global.players) do
            local player = game.get_player(index)

            if player ~= nil then
                for _, mod in pairs(MODS) do
                    -- Call mod init function
                    mod.init(player, true)
                end
            end
        end
    end
end

--- @param player_index uint
--- @return LuaPlayer?
function global_data.get_player(player_index)
    -- Get player from game data
    local player = game.get_player(player_index)

    if player ~= nil then
        -- Initialize player data
        player_data.init(player)

        -- Return player
        return player
    end
end

--- @param mod_name string
--- @return boolean
function global_data.is_mod_active(mod_name)
    local mod = game.active_mods[mod_name]

    return mod ~= nil
end

--- @param name string
--- @return any
function global_data.get_settings(name)
    -- Return setting value or nil
    return settings.global[name].value or nil
end

return global_data
