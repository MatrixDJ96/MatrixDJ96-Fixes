local global_data = {}

global_data.init = function()
    -- Initialize players table
    global.players = {}
end

--- @param player_index uint
--- @return TranslationTable[]
function global_data.get_all_translations(player_index)
    -- Return all player translations
    return global.players[player_index].translations
end

--- @param player_index uint
--- @param request_id uint
function global_data.get_translation_by_request_id(player_index, request_id)
    -- Loop through all player translations
    for _, translation in pairs(global.players[player_index].translations) do
        -- Check translation request ID
        if translation.request_id == request_id then
            -- Return translation
            return translation
        end
    end
end

return global_data
