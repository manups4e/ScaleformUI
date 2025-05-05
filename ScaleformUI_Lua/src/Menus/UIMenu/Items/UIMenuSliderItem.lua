UIMenuSliderItem = {}
UIMenuSliderItem.__index = UIMenuSliderItem
setmetatable(UIMenuSliderItem, { __index = UIMenuItem })
UIMenuSliderItem.__call = function() return "UIMenuSliderItem" end


---@class UIMenuSliderItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param Max number
---@param Multiplier number|5
---@param Index number|0
---@param Heritage boolean|false
---@param Description string
---@param sliderColor SColor
---@param color SColor
---@param highlightColor SColor
function UIMenuSliderItem.New(Text, Max, Multiplier, Index, Heritage, Description, sliderColor, color, highlightColor)
    local base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White)
    base._Index = tonumber(Index) or 0
    base._Max = tonumber(Max) or 100
    base._Multiplier = Multiplier or 5
    base._heritage = Heritage or false
    base._sliderColor = sliderColor or SColor.HUD_Freemode
    base.ItemId = 3
    base.OnSliderChanged = function(menu, item, newindex)
    end
    base.OnSliderSelected = function(menu, item, newindex)
    end
    return setmetatable(base, UIMenuSliderItem)
end

function UIMenuSliderItem:RightLabelFont(itemFont)
    error("UIMenuSliderItem does not support a right label")
end

function UIMenuSliderItem:RightBadge()
    error("UIMenuSliderItem does not support right badges")
end

function UIMenuSliderItem:CustomRightBadge()
    error("UIMenuSliderItem does not support right badges")
end

function UIMenuSliderItem:RightLabel()
    error("UIMenuSliderItem does not support a right label")
end

function UIMenuSliderItem:SliderColor(color)
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

function UIMenuSliderItem:Index(Index)
    if Index ~= nil then
        if tonumber(Index) > self._Max then
            self._Index = self._Max
        elseif tonumber(Index) < 0 then
            self._Index = 0
        else
            self._Index = tonumber(Index)
        end
        self.OnSliderChanged(self.ParentMenu, self, self._Index)
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
