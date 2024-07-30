SegmentItem = setmetatable({}, SegmentItem)
SegmentItem.__index = SegmentItem
SegmentItem.__call = function()
    return "SegmentItem"
end

---@class SegmentItem
---@field public label string
---@field public description string
---@field public textureDict string
---@field public textureName string
---@field public textureWidth number
---@field public textureHeight number
---@field public color SColor
---@field public qtty number
---@field public max number
---@field public Parent SegmentItem

---New
---@param _label string
---@param _desc? string
---@param _txd? string
---@param _txn? string
---@param _txwidth? number
---@param _txheight? number
---@param _color? SColor
---@return SegmentItem
function SegmentItem.New(_label, _desc, _txd, _txn, _txwidth, _txheight, _color)
    local _it = {
        label = _label or "",
        description = _desc or "",
        textureDict = _txd or "",
        textureName = _txn or "",
        textureWidth = _txwidth or 0,
        textureHeight = _txheight or 0,
        color = _color or SColor.HUD_Freemode,
        qtty = 0,
        max = 0,
        Parent = nil
    }
    return setmetatable(_it, SegmentItem)
end

function SegmentItem:Label(lbl)
    if lbl ~= nil then
        self.label = lbl
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent:Visible() then
            ScaleformUI.Scaleforms._radialMenu:CallFunction("UPDATE_SUBITEM", self.Parent.index - 1, IndexOf(self.Parent.Items, self) - 1, self.label, self.description, self.textureName, self.textureDict, self.textureHeight, self.textureWidth, self.color, self.qtty, self.max);
        end
    else
        return self.label
    end
end

function SegmentItem:Description(desc)
    if desc ~= nil then
        self.description = desc
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent:Visible() then
            ScaleformUI.Scaleforms._radialMenu:CallFunction("UPDATE_SUBITEM", self.Parent.index - 1, IndexOf(self.Parent.Items, self) - 1, self.label, self.description, self.textureName, self.textureDict, self.textureHeight, self.textureWidth, self.color, self.qtty, self.max);
        end
    else
        return self.description
    end
end

function SegmentItem:TextureDict(txd)
    if txd ~= nil then
        self.textureDict = txd
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent:Visible() then
            ScaleformUI.Scaleforms._radialMenu:CallFunction("UPDATE_SUBITEM", self.Parent.index - 1, IndexOf(self.Parent.Items, self) - 1, self.label, self.description, self.textureName, self.textureDict, self.textureHeight, self.textureWidth, self.color, self.qtty, self.max);
        end
    else
        return self.textureDict
    end
end

function SegmentItem:TextureName(txn)
    if txn ~= nil then
        self.textureName = txn
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent:Visible() then
            ScaleformUI.Scaleforms._radialMenu:CallFunction("UPDATE_SUBITEM", self.Parent.index - 1, IndexOf(self.Parent.Items, self) - 1, self.label, self.description, self.textureName, self.textureDict, self.textureHeight, self.textureWidth, self.color, self.qtty, self.max);
        end
    else
        return self.textureName
    end
end

function SegmentItem:TextureWidth(width)
    if width ~= nil then
        self.textureWidth = width
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent:Visible() then
            ScaleformUI.Scaleforms._radialMenu:CallFunction("UPDATE_SUBITEM", self.Parent.index - 1, IndexOf(self.Parent.Items, self) - 1, self.label, self.description, self.textureName, self.textureDict, self.textureHeight, self.textureWidth, self.color, self.qtty, self.max);
        end
    else
        return self.textureWidth
    end
end

function SegmentItem:TextureHeight(height)
    if height ~= nil then
        self.textureHeight = height
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent:Visible() then
            ScaleformUI.Scaleforms._radialMenu:CallFunction("UPDATE_SUBITEM", self.Parent.index - 1, IndexOf(self.Parent.Items, self) - 1, self.label, self.description, self.textureName, self.textureDict, self.textureHeight, self.textureWidth, self.color, self.qtty, self.max);
        end
    else
        return self.textureHeight
    end
end

function SegmentItem:Color(color)
    if color ~= nil then
        self.color = color
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent:Visible() then
            ScaleformUI.Scaleforms._radialMenu:CallFunction("UPDATE_SUBITEM", self.Parent.index - 1, IndexOf(self.Parent.Items, self) - 1, self.label, self.description, self.textureName, self.textureDict, self.textureHeight, self.textureWidth, self.color, self.qtty, self.max);
        end
    else
        return self.color
    end
end

function SegmentItem:SetQuantity(qtty, max)
    self.qtty = qtty
    self.max = max or 0
    if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent:Visible() then
        ScaleformUI.Scaleforms._radialMenu:CallFunction("UPDATE_SUBITEM", self.Parent.index - 1, IndexOf(self.Parent.Items, self) - 1, self.label, self.description, self.textureName, self.textureDict, self.textureHeight, self.textureWidth, self.color, self.qtty, self.max);
    end
end
