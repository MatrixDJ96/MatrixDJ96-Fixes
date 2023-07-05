local player_data = require("scripts.player-data")

local mod = {}

--- @param player LuaPlayer
local function check_required_conditions(player)
    return player_data.get_settings(player, "matrixdj96_auto_fueling_setting")
end

function mod.perform_auto_fueling(player)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Check if player is in game render mode (not in map view)
    if player.render_mode == defines.render_mode.game then
        local vehicle = player.vehicle

        -- Check if player is in a vehicle
        if vehicle and vehicle.valid then
            -- Get current vehicle fuel inventory
            local fuel_inventory = vehicle.get_fuel_inventory()

            -- Check if fuel inventory exists and it is empty
            if fuel_inventory and fuel_inventory.is_empty() then
                -- Define fuel items
                local fuel_items = {}

                -- Get current player main inventory
                local player_inventory = player.get_main_inventory()

                -- Check if player main inventory exists and it is not empty
                if player_inventory and not player_inventory.is_empty() then
                    -- Loop through all items in player inventory to find fuel
                    for x = 1, #player_inventory do
                        -- Get item from player inventory
                        local item = player_inventory[x] --[[@as LuaItemStack]]

                        if item and item.valid and item.valid_for_read then
                            if item.prototype.fuel_value > 0 then
                                -- Add item to fuel items
                                table.insert(fuel_items, item)
                            end
                        end
                    end
                end

                -- Sort fuel items by fuel value (ascending)
                table.sort(fuel_items, function(current, next)
                    return current.prototype.fuel_value < next.prototype.fuel_value
                end)

                for _, fuel_item in pairs(fuel_items) do
                    if fuel_inventory.can_insert(fuel_item) then
                        -- Insert fuel item into vehicle
                        local count = fuel_inventory.insert(fuel_item)

                        -- Remove inserted items from item stack
                        fuel_item.count = fuel_item.count - count

                        -- Break loop
                        break
                    end
                end
            end
        end
    end
end

return mod
