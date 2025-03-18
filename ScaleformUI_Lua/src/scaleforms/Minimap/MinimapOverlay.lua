MinimapOverlay = setmetatable({}, MinimapOverlay)
MinimapOverlay.__index = MinimapOverlay
MinimapOverlay.__call = function()
    return "MinimapOverlay"
end

---@class SColor
---@field private Handle number
---@field private Txd string
---@field private Txn string
---@field private Color SColor
---@field private Position vector2
---@field private Rotation number
---@field private Size table
---@field private Alpha number
---@field private Centered boolean

function MinimapOverlay.New(handle, textureDict, textureName, x, y, rotation, width, height, alpha, centered)
    local _data = {
        Handle = handle or 0,
        Txd = textureDict or "",
        Txn = textureName or "",
        Color = SColor.HUD_None,
        Position = vector2(x or 0, y or 0),
        Rotation = rotation or 0,
        Size = { width or 0, height or 0 },
        Alpha = alpha or 0,
        Centered = centered or false,
        visible = true,
        OnMouseEvent = function(eventType)
        end
    }
    return setmetatable(_data, MinimapOverlay)
end
