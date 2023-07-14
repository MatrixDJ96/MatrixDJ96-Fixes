MODS = {
    require("scripts.mods.manual-inventory-sort"),
    require("scripts.mods.task-list"),
    require("scripts.mods.todo-list"),
    require("scripts.mods.train-log"),
    require("scripts.mods.yarm"),
    require("scripts.tweaks.enhanced-entity-build"),
    require("scripts.tweaks.game-speed-manager"),
    require("scripts.tweaks.trains-auto-manual-mode"),
    require("scripts.tweaks.trains-manual-mode-temp-stop"),
    require("scripts.tweaks.vehicle-auto-fueling")
}

EVENTS = {}

-- Loop through all mods
for _, mod in pairs(MODS) do
    -- Add missing mod properties
    mod.events = mod.events or {}
    mod.init = mod.init or function(_) end
    mod.clean = mod.clean or function(_) end

    -- Add on_player_created event to mod (if missing)
    if not mod.events[defines.events.on_player_created] then
        mod.events[defines.events.on_player_created] = function(player)
            -- Call mod init function
            mod.init(player)
        end
    end

    -- Loop through all defined events in mod
    for event_name, event_function in pairs(mod.events) do
        EVENTS[event_name] = EVENTS[event_name] or {}

        -- Check if event_function is a function
        if type(event_function) ~= "function" then
            event_function = function(...)
                -- Check if index exists in mod.events
                if mod.events[event_function] then
                    game.print("event_function " .. game.tick)

                    -- Call linked event function
                    mod.events[event_function](...)
                end
            end
        end

        -- Add event function to events table
        table.insert(EVENTS[event_name], event_function)
    end
end
