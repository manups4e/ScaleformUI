UIMenuPercentagePanel = setmetatable({}, UIMenuPercentagePanel)
UIMenuPercentagePanel.__index = UIMenuPercentagePanel
UIMenuPercentagePanel.__call = function() return "UIMenuPanel", "UIMenuPercentagePanel" end

---@class UIMenuPercentagePanel
---@field public Min string
---@field public Max string
---@field public Title string
---@field public Percentage number
---@field public ParentItem table
---@field public SetParentItem fun(self:UIMenuStatisticsPanel, item:UIMenuItem):UIMenuItem -- required
---@field public OnPercentagePanelChange function

---New
---@param title string
---@param minText string
---@param maxText string
---@param initialValue number
function UIMenuPercentagePanel.New(title, minText, maxText, initialValue)
    local _UIMenuPercentagePanel = {
        Min = minText or "0%",
        Max = maxText or "100%",
        Title = title or "Opacity",
        _percentage = initialValue or 0.0,
        ParentItem = nil, -- required
        OnPercentagePanelChange = function(item, panel, value)
        end
    }
    return setmetatable(_UIMenuPercentagePanel, UIMenuPercentagePanel)
end

function UIMenuPercentagePanel:Percentage(value)
    if value ~= nil then
        self._percentage = value
        if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
            local it = IndexOf(self.ParentItem:SetParentMenu().Items, self.ParentItem)
            self.ParentItem:SetParentMenu():SendPanelsToItemScaleform(it, true)
            self.OnPercentagePanelChanged(self.ParentItem, self, self._percentage)
            self.ParentItem:SetParentMenu().OnPercentagePanelChange(self.ParentItem, self, self._percentage)
        end
    else
        return self._percentage
    end
end

---SetParentItem
---@param Item table
function UIMenuPercentagePanel:SetParentItem(Item) -- required
    if Item ~= nil then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end
