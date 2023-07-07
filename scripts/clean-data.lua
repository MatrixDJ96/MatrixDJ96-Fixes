local mod_manual_sort = require("scripts.mods.manual-inventory-sort")

for _, player in pairs(game.players) do
    -- Remove invalid sort buttons
    mod_manual_sort.remove_buttons(player)
end
