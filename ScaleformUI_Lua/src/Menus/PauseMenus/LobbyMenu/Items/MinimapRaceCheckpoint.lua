MinimapRaceCheckpoint = setmetatable({}, MinimapRaceCheckpoint)
MinimapRaceCheckpoint.__index = MinimapRaceCheckpoint
MinimapRaceCheckpoint.__call = function()
    return "LobbyItem", "MinimapRaceCheckpoint"
end

---@class MinimapRaceCheckpoint
---@field private New fun(sprite:number, position:vector3, color:HudColours, scale:number)
---@field public Sprite number
---@field public Position vector3

function MinimapRaceCheckpoint.New(sprite, position, color, scale)
    local _data = {
        Sprite = sprite,
        Position = position,
        Scale = scale or 0.0,
        Color = color or HudColours.HUD_COLOUR_WHITE
    }
    return setmetatable(_data, MinimapRaceCheckpoint)
end
