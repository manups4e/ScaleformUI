UIMenuColorPanel = setmetatable({}, UIMenuColorPanel)
UIMenuColorPanel.__index = UIMenuColorPanel
UIMenuColorPanel.__call = function() return "UIMenuPanel", "UIMenuColorPanel" end

---@class UIMenuColorPanel
---@field public Title string
---@field public ColorPanelColorType number
---@field public value number
---@field public CustomColors table<SColor>
---@field public ParentItem table
---@field public SetParentItem fun(self:UIMenuStatisticsPanel, item:UIMenuItem):UIMenuItem -- required
---@field public OnColorPanelChanged function

---New
---@param title string
---@param colorType number
---@param startIndex number
function UIMenuColorPanel.New(title, colorType, startIndex, colors)
    if colors ~= nil then
        colorType = 2
    end

    local _UIMenuColorPanel = {
        Title = title or "Color Panel",
        ColorPanelColorType = colorType,
        value = startIndex or 0,
        CustomColors = colors or nil,
        ParentItem = nil, -- required
        OnColorPanelChanged = function(item, panel, newindex)
        end
    }
    return setmetatable(_UIMenuColorPanel, UIMenuColorPanel)
end

---SetParentItem
---@param Item table
function UIMenuColorPanel:SetParentItem(Item) -- required
    if not Item() == nil then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

function UIMenuColorPanel:CurrentSelection(new_value)
    if new_value ~= nil then
        self.value = new_value
        if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
            local it = IndexOf(self.ParentItem:SetParentMenu().Items, self.ParentItem)
            self.ParentItem:SetParentMenu():SendPanelsToItemScaleform(it, true)
            self.OnColorPanelChanged(self.ParentItem, self, self.value)
            self.ParentItem:SetParentMenu().OnColorPanelChanged(self.ParentItem, self, self.value)
        end
    else
        return self.value
    end
end
