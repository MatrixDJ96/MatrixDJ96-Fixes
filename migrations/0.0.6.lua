local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")

local mod_sort = require("scripts.mods.manual-inventory-sort")

-- Initialize global data
global_data.init()

for _, player in pairs(game.players) do
    -- Initialize player data
    player_data.init(player)

    -- Remove invalid manual-inventory-sort buttons
    mod_sort.remove_buttons(player)

    -- Add new manual-inventory-sort buttons
    mod_sort.add_buttons(player)
end
