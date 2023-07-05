local mod_sort = require("scripts.mods.manual-inventory-sort")

for _, player in pairs(game.players) do
    -- Remove invalid sort buttons
    mod_sort.remove_buttons(player)
end
