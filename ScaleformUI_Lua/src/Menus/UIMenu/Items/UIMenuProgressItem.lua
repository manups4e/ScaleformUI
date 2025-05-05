UIMenuProgressItem = {}
UIMenuProgressItem.__index = UIMenuProgressItem
setmetatable(UIMenuProgressItem, { __index = UIMenuItem })
UIMenuProgressItem.__call = function() return "UIMenuProgressItem" end

---@class UIMenuProgressItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param Max number
---@param Index number
---@param Description string
---@param sliderColor SColor
---@param color SColor
---@param highlightColor SColor
---@param backgroundSliderColor SColor
function UIMenuProgressItem.New(Text, Max, Index, Description, sliderColor, color, highlightColor, backgroundSliderColor)
    local base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light,
        highlightColor or SColor.HUD_White)
    base._Max = Max or 100
    base._Multiplier = 5
    base._Index = Index or 0
    base._sliderColor = sliderColor or SColor.HUD_Freemode
    base.BackgroundSliderColor = backgroundSliderColor or SColor.HUD_Pause_bg
    base.ItemId = 4
    base.OnProgressChanged = function(menu, item, newindex)
    end
    base.OnProgressSelected = function(menu, item, newindex)
    end
    return setmetatable(base, UIMenuProgressItem)
end

-- not supported on Lobby and Pause menu yet
function UIMenuProgressItem:RightLabelFont(itemFont)
    error("UIMenuProgressItem does not support a right label")
end

---RightBadge
function UIMenuProgressItem:RightBadge()
    error("UIMenuProgressItem does not support right badges")
end

function UIMenuProgressItem:CustomRightBadge()
    error("UIMenuProgressItem does not support right badges")
end

---RightLabel
function UIMenuProgressItem:RightLabel()
    error("UIMenuProgressItem does not support a right label")
end

function UIMenuProgressItem:SliderColor(color)
    if color then
        assert(color() == "SColor", "Color must be SColor type")
        self._sliderColor = color
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._sliderColor
    end
end

---Index
---@param Index table
function UIMenuProgressItem:Index(Index)
    if tonumber(Index) then
        if Index > self._Max then
            self._Index = self._Max
        elseif Index < 0 then
            self._Index = 0
        else
            self._Index = Index
        end
        self.OnProgressChanged(self._Index)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._Index
    end
end

function UIMenuProgressItem:Value(index)
    return self:Index(value)
end
