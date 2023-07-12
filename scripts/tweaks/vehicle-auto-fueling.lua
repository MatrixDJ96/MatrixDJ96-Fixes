local mod_gui = require("__core__.lualib.mod-gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")
local constants = require("constants")

local mod = {}

--- @param table table
--- @param value any
--- @return boolean
local function contains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end

    return false
end

--- @param player LuaPlayer
--- @return boolean
local function check_required_conditions(player)
    return player_data.get_settings(player, "matrixdj96_vehicle_auto_fueling_setting") and
        not (global_data.is_mod_active("Fill4Me") and global_data.is_mod_active("Fill4Me-fixed"))
end

-- Perform vehicle auto fueling
--- @param player LuaPlayer
--- @param e EventData
function mod.perform_auto_fueling(player, e)
    -- Check if required conditions are met
    if not check_required_conditions(player) then
        return
    end

    -- Get input name from event data
    local input_name = e.input_name --[[@as string]]

    -- Check if input event is a supported inputs
    if not contains(constants.input_events, input_name) then
        return
    end

    -- Check if player is in game render mode (not in map view)
    if player.render_mode ~= defines.render_mode.game then
        return
    end

    -- Get vehicle from player data
    local vehicle = player.vehicle

    -- Check if player is in a vehicle
    if vehicle and vehicle.valid then
        -- Get current vehicle fuel inventory
        local fuel_inventory = vehicle.get_fuel_inventory()

        -- Check if fuel inventory exists and it is empty
        if fuel_inventory and fuel_inventory.is_empty() then
            --- Define fuel items
            --- @type LuaItemStack[]
            local fuel_items = {}

            -- Get current player main inventory
            local player_inventory = player.get_main_inventory()

            -- Check if player main inventory exists, it is valid and it is not empty
            if player_inventory and player_inventory.valid and not player_inventory.is_empty() then
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
                -- Check if fuel item can be inserted into vehicle fuel inventory
                if fuel_inventory.can_insert(fuel_item) then
                    -- Get fuel item name
                    local name = fuel_item.name

                    -- Get fuel prototype localised_name
                    local localised_name = fuel_item.prototype.localised_name

                    -- Check if player inventory exists
                    if player_inventory and player_inventory.valid then
                        -- Insert fuel item into vehicle fuel inventory
                        local count = fuel_inventory.insert(fuel_item)

                        -- Check if fuel item has been inserted
                        if count > 0 then
                            -- Remove inserted fuel items from player inventory
                            player_inventory.remove({ name = name, count = count })

                            -- Get remaining fuel item count in player inventory
                            local total_count = player_inventory.get_item_count(name)

                            -- Generate flying text
                            local flying_text = {
                                "",
                                "-" .. count .. " ",
                                localised_name,
                                " (" .. total_count .. ")"
                            }

                            -- Create flying text over player position
                            player.create_local_flying_text({
                                text = flying_text,
                                time_to_live = 160,
                                color = player.color,
                                position = player.position
                            })
                        end
                    end

                    -- Break loop
                    break
                end
            end
        end
    end
end

-- Define events that will be handled
mod.events = {}

for _, value in pairs(constants.input_events) do
    mod.events[value] = mod.perform_auto_fueling
end

return mod
