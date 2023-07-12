local player_data = require("scripts.player-data")

local global_data = {}

--- @param force? boolean
function global_data.init(force)
    if force or not global.players then
        -- Initialize players table
        global.players = {}
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
