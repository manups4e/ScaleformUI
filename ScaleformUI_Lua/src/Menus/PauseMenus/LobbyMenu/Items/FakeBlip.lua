FakeBlip = setmetatable({}, FakeBlip)
FakeBlip.__index = FakeBlip
FakeBlip.__call = function()
    return "LobbyItem", "FakeBlip"
end

---@class FakeBlip
---@field private New fun(sprite:number, position:vector3, color:HudColours, scale:number)
---@field public Sprite number
---@field public Position vector3

function FakeBlip.New(sprite, position, color, scale)
    local _data = {
        Sprite = sprite,
        Position = position,
        Scale = scale or 0.0,
        Color = color or HudColours.HUD_COLOUR_WHITE
    }
    return setmetatable(_data, FakeBlip)
end
