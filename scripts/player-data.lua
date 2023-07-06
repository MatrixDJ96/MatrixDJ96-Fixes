local player_data = {}

--- @param player LuaPlayer
--- @param localised_string LocalisedString
--- @return TranslationTable
local function request_translation(player, localised_string)
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
local function initialize_translations(player)
    -- Initialize player translations
    global.players[player.index].translations = {
        -- Add character and trash-slots translations
        ["character"] = request_translation(player, { "gui.character" }),
        ["trash-slots"] = request_translation(player, { "gui-logistic.trash-slots" })
    }
end

--- @param player LuaPlayer
local function initialize_tick_functions(player)
    -- Initialize player tick functions
    global.players[player.index].tick_functions = {}
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
--- @param name string
--- @param localised_string LocalisedString
function player_data.set_translation(player, name, localised_string)
    -- Check if translation exists
    if global.players[player.index].translations[name] ~= nil then
        -- Request new translation for player
        global.players[player.index].translations[name] = request_translation(player, localised_string)
    end
end

--- @param player LuaPlayer
--- @param name_id string|uint
--- @return TranslationTable?
function player_data.get_translation(player, name_id)
    if type(name_id) == "string" then
        -- Return translation by name
        return global.players[player.index].translations[name_id]
    elseif type(name_id) == "number" then
        -- Loop through all player translations
        for _, translation in pairs(global.players[player.index].translations) do
            -- Check translation request ID
            if translation.request_id == name_id then
                -- Return translation by request ID
                return translation
            end
        end
    end
end

--- @param player LuaPlayer
--- @return TranslationTable[]
function player_data.get_translations(player)
    -- Return all player translations
    return global.players[player.index].translations
end

--- @param player LuaPlayer
function player_data.set_tick_function(player, function_name, tick_function)
    global.players[player.index].tick_functions[function_name] = function()
        -- Execute tick function using pcall
        local status, retval = pcall(tick_function)
        -- Remove tick function from global table after execution
        global.players[player.index].tick_functions[function_name] = nil
    end
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
