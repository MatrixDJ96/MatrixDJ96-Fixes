require("scripts.mod-data")

for _, player in pairs(game.players) do
    for _, mod in pairs(MODS) do
        -- Execute cleaning
        mod.clean(player)
    end
end
