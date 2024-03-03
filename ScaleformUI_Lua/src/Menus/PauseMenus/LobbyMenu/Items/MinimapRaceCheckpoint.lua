MinimapRaceCheckpoint = setmetatable({}, MinimapRaceCheckpoint)
MinimapRaceCheckpoint.__index = MinimapRaceCheckpoint
MinimapRaceCheckpoint.__call = function()
    return "LobbyItem", "MinimapRaceCheckpoint"
end

---@class MinimapRaceCheckpoint
---@field private New fun(sprite:number, position:vector3)
---@field public Sprite number
---@field public Position vector3

function MinimapRaceCheckpoint.New(sprite, position)
    local _data = {
        Sprite = sprite,
        Position = position
    }
    return setmetatable(_data, MinimapRaceCheckpoint)
end