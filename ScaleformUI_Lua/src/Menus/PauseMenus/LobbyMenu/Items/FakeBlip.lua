FakeBlip = setmetatable({}, FakeBlip)
FakeBlip.__index = FakeBlip
FakeBlip.__call = function()
    return "LobbyItem", "FakeBlip"
end

---@class FakeBlip
---@field private New fun(sprite:number, position:vector3)
---@field public Sprite number
---@field public Position vector3

function FakeBlip.New(sprite, position)
    local _data = {
        Sprite = sprite,
        Position = position
    }
    return setmetatable(_data, FakeBlip)
end