local player_data = require("scripts.player-data")

local mod_sort = require("scripts.mods.manual-inventory-sort")

for _, player in pairs(game.players) do
    -- Initialize player data
    player_data.init(player)

    -- Remove invalid sort buttons
    mod_sort.remove_buttons(player)
end
