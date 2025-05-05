UIMenuStatsItem = {}
UIMenuStatsItem.__index = UIMenuStatsItem
setmetatable(UIMenuStatsItem, { __index = UIMenuItem })
UIMenuStatsItem.__call = function() return "UIMenuStatsItem" end

---@class UIMenuStatsItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param Description string
---@param Index number|0
---@param barColor SColor
---@param type number|0
---@param mainColor SColor
---@param highlightColor SColor
function UIMenuStatsItem.New(Text, Description, Index, barColor, type, mainColor, highlightColor)
    local base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White)
    base._Index = Index or 0
    base._Color = barColor or SColor.HUD_Freemode
    base._Type = type or 0
    base.ItemId = 5
    base.OnStatsChanged = function(menu, item, newindex)
    end
    base.OnStatsSelected = function(menu, item, newindex)
    end
    return setmetatable(base, UIMenuStatsItem)
end

function UIMenuStatsItem:RightLabelFont(itemFont)
    error("UIMenuStatsItem does not support a right label")
end

---LeftBadge
function UIMenuStatsItem:LeftBadge()
    error("This item does not support badges")
end

---RightBadge
function UIMenuStatsItem:RightBadge()
    error("This item does not support badges")
end

function UIMenuStatsItem:CustomLeftBadge()
    error("This item does not support badges")
end

function UIMenuStatsItem:CustomRightBadge()
    error("This item does not support badges")
end

---RightLabel
function UIMenuStatsItem:RightLabel()
    error("This item does not support a right label")
end

function UIMenuStatsItem:SliderColor(color)
    if color then
        assert(color() == "SColor", "Color must be SColor type")
        self._Color = color
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._Color
    end
end

---Index
---@param Index table
function UIMenuStatsItem:Index(Index)
    if tonumber(Index) then
        if Index > 100 then
            self._Index = 100
        elseif Index < 0 then
            self._Index = 0
        else
            self._Index = Index
        end
        self.OnStatsChanged(self._Index)
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