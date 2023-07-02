local player_data = {}

--- @param player LuaPlayer
function player_data.init(player)
    -- Initialize player translations
    global.players[player.index] = {
        translations = {
            -- Add character and trash-slots translations
            ["character"] = player_data.create_translation(player, { "gui.character" }),
            ["trash-slots"] = player_data.create_translation(player, { "gui-logistic.trash-slots" })
        }
    }
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

return player_data
