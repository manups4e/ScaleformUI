MinimapOverlay = setmetatable({}, MinimapOverlay)
MinimapOverlay.__index = MinimapOverlay
MinimapOverlay.__call = function()
    return "MinimapOverlay"
end

---@class MinimapOverlay
---@field public Handle number
---@field public Txd string
---@field public Txn string
---@field public Color SColor
---@field public Position vector2
---@field public Rotation number
---@field public Visible boolean
---@field public Size table
---@field public Alpha number
---@field public Centered boolean
---@field public SetOverlayColor fun(self:MinimapOverlay, color:SColor)
---@field public HideOverlay fun(self:MinimapOverlay, hide:boolean)
---@field public SetOverlayAlpha fun(self:MinimapOverlay, alpha:number)
---@field public SetOverlayRotation fun(self:MinimapOverlay, rotation:number)
---@field public SetOverlayPosition fun(self:MinimapOverlay, position:vector2|vector3)
---@field public SetOverlaySizeOrScale fun(self:MinimapOverlay, width:number, height:number)
---@field public RemoveOverlayFromMinimap fun(self:MinimapOverlay)

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
        Visible = true,
        isArea = false,
        OnMouseEvent = function(eventType)
        end
    }
    return setmetatable(_data, MinimapOverlay)
end

function MinimapOverlay:SetOverlayColor(color)
    ScaleformUI.Scaleforms.MinimapOverlays:SetOverlayColor(self.Handle,color)
end

function MinimapOverlay:HideOverlay(hide)
    ScaleformUI.Scaleforms.MinimapOverlays:HideOverlay(self.Handle,hide)
end

function MinimapOverlay:SetOverlayAlpha(alpha)
    ScaleformUI.Scaleforms.MinimapOverlays:SetOverlayAlpha(self.Handle,alpha)
end

function MinimapOverlay:SetOverlayPosition(position)
    ScaleformUI.Scaleforms.MinimapOverlays:SetOverlayPosition(self.Handle,position)
end

function MinimapOverlay:SetOverlaySizeOrScale(width, height)
    ScaleformUI.Scaleforms.MinimapOverlays:SetOverlaySizeOrScale(self.Handle,width, height)
end

function MinimapOverlay:RemoveOverlayFromMinimap()
    ScaleformUI.Scaleforms.MinimapOverlays:RemoveOverlayFromMinimap(self.Handle)
end

function MinimapOverlay:SetOverlayRotation(rotation)
    ScaleformUI.Scaleforms.MinimapOverlays:SetOverlayRotation(self.Handle, rotation)
end
