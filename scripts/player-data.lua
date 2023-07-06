local player_data = {}

--- @param player LuaPlayer
--- @param name string
--- @param localised_string LocalisedString
--- @return TranslationTable
local function request_translation(player, name, localised_string)
    --- @class TranslationTable
    --- @field id uint
    --- @field name string
    --- @field translated_string string?
    --- @field localised_string LocalisedString
    return {
        id = player.request_translation(localised_string),
        name = name,
        translated_string = nil,
        localised_string = localised_string
    }
end

--- @param player LuaPlayer
local function initialize_translations(player)
    -- Initialize player translations table
    global.players[player.index].translations = { ids = {}, names = {} }

    local translations = {
        -- Add character and trash-slots translations
        request_translation(player, "character", { "gui.character" }),
        request_translation(player, "trash-slots", { "gui-logistic.trash-slots" })
    }

    for _, translation in pairs(translations) do
        -- Add translation to player translations
        global.players[player.index].translations.ids[translation.id] = translation
        global.players[player.index].translations.names[translation.name] = translation
    end
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
    -- Check if translation exists for player
    if global.players[player.index].translations.names[name] == nil then
        -- Request new translation for player
        local translation = request_translation(player, name, localised_string)

        -- Add translation to player translations
        global.players[player.index].translations.ids[translation.id] = translation
        global.players[player.index].translations.names[translation.name] = translation
    end
end

--- @param player LuaPlayer
--- @param id_name string|uint
--- @return TranslationTable?
function player_data.get_translation(player, id_name)
    if type(id_name) == "number" then
        -- Return translation by id
        return global.players[player.index].translations.ids[id_name]
    elseif type(id_name) == "string" then
        -- Return translation by name
        return global.players[player.index].translations.names[id_name]
    end
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
