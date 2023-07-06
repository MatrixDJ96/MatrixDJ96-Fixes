local global_data = {}

--- @param force? boolean
function global_data.init(force)
    if force or not global.players then
        -- Initialize players table
        global.players = {}
    end
end

return global_data
