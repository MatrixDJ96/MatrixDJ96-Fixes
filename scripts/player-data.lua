local player_data = {}

--- @param player LuaPlayer
local function initialize_tick_functions(player)
    -- Initialize player tick functions
    global.players[player.index].tick_functions = {}
end

--- @param player LuaPlayer
local function initialize_translations(player)
    -- Initialize player translations
    global.players[player.index].translations = {
        -- Add character and trash-slots translations
        ["character"] = player_data.create_translation(player, { "gui.character" }),
        ["trash-slots"] = player_data.create_translation(player, { "gui-logistic.trash-slots" })
    }
end

--- @param player LuaPlayer
--- @param force? boolean
function player_data.init(player, force)
    -- Check if player data exists in global
    if force or not global.players[player.index] then
        -- Initialize player data
        global.players[player.index] = {}
    end

    -- Check if all required keys exists
    if not global.players[player.index].translations then
        -- Initialize player translations
        initialize_translations(player)
    end

    if not global.players[player.index].tick_functions then
        -- Initialize player tick functions
        initialize_tick_functions(player)
    end
end

--- @param player LuaPlayer
--- @param localised_string LocalisedString
--- @return TranslationTable
function player_data.create_translation(player, localised_string)
    --- @class TranslationTable
    --- @field request_id uint
    --- @field translated_string string
    --- @field localised_string LocalisedString
    return {
        request_id = player.request_translation(localised_string),
        translated_string = nil,
        localised_string = localised_string
    }
end

--- @param player LuaPlayer
--- @param name string
--- @return any
function player_data.get_settings(player, name)
    -- Get settings for player
    local settings = settings.get_player_settings(player)

    -- Return setting value or nil
    return settings[name] and settings[name].value or nil
end

return player_data
