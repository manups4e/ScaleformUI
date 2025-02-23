UIMenuGridPanel = setmetatable({}, UIMenuGridPanel)
UIMenuGridPanel.__index = UIMenuGridPanel
UIMenuGridPanel.__call = function() return "UIMenuPanel", "UIMenuGridPanel" end

---@class UIMenuGridPanel
---@field public TopLabel string
---@field public RightLabel string
---@field public LeftLabel string
---@field public BottomLabel string
---@field public GridType number
---@field public ParentItem table
---@field public SetParentItem fun(self:UIMenuStatisticsPanel, item:UIMenuItem):UIMenuItem -- required
---@field public OnGridPanelChanged function

---New
---@param topText string
---@param leftText string
---@param rightText string
---@param bottomText string
---@param circlePosition vector2
---@param gridType number
function UIMenuGridPanel.New(topText, leftText, rightText, bottomText, circlePosition, gridType)
    local _UIMenuGridPanel = {
        TopLabel = topText or "UP",
        RightLabel = rightText or "RIGHT",
        LeftLabel = leftText or "LEFT",
        BottomLabel = bottomText or "DOWN",
        _CirclePosition = circlePosition or vector2(0.5, 0.5),
        GridType = gridType or 0,
        ParentItem = nil, -- required
        OnGridPanelChanged = function(item, panel, newindex)
        end
    }
    return setmetatable(_UIMenuGridPanel, UIMenuGridPanel)
end

---SetParentItem
---@param Item table
function UIMenuGridPanel:SetParentItem(Item) -- required
    if Item() ~= nil then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

function UIMenuGridPanel:CirclePosition(position)
    if position ~= nil then
        self._CirclePosition = position
        if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
            local it = IndexOf(self.ParentItem:SetParentMenu().Items, self.ParentItem)
            self.ParentItem:SetParentMenu():SendPanelsToItemScaleform(it, true)
            self.OnGridPanelChanged(self.ParentItem, self, self._CirclePosition)
            self.ParentItem:SetParentMenu().OnGridPanelChanged(self.ParentItem, self, self._CirclePosition)
        end
    else
        return self._CirclePosition
    end
end
