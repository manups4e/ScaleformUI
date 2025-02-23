UIMenuStatisticsPanel = setmetatable({}, UIMenuStatisticsPanel)
UIMenuStatisticsPanel.__index = UIMenuStatisticsPanel
UIMenuStatisticsPanel.__call = function() return "UIMenuPanel", "UIMenuStatisticsPanel" end

---@class UIMenuStatisticsPanel
---@field public Items table
---@field public ParentItem UIMenuItem -- required
---@field public SetParentItem fun(self:UIMenuStatisticsPanel, item:UIMenuItem):UIMenuItem -- required

function UIMenuStatisticsPanel.New(items)
    local _UIMenuStatisticsPanel = {
        Items = items or {},
        ParentItem = nil, -- required
    }
    return setmetatable(_UIMenuStatisticsPanel, UIMenuStatisticsPanel)
end

---Set the parent item of the panel
---@param item UIMenuItem
---@return UIMenuItem
function UIMenuStatisticsPanel:SetParentItem(item) -- required
    if not item() ~= nil then
        self.ParentItem = item
    end
    return self.ParentItem
end

---Add a statistic to the panel
---@param name string -- The name of the statistic
---@param value number -- Must be between 0 and 100
function UIMenuStatisticsPanel:AddStatistic(name, value) -- required
    if name ~= nil and name ~= "" and value ~= nil then
        if value > 100 then
            value = 100
        elseif value < 0 then
            value = 0
        end
        table.insert(self.Items, { ['name'] = name, ['value'] = value })
        if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
            local it = IndexOf(self.ParentItem:SetParentMenu().Items, self.ParentItem)
            self.ParentItem:SetParentMenu():SendPanelsToItemScaleform(it, true)
        end
    end
end

---Get the percentage of a statistic
---@param index number -- The index of the statistic 1-4
---@return number
function UIMenuStatisticsPanel:GetPercentage(index)
    if index ~= nil then
        if index > #self.Items then
            index = #self.Items
        elseif index < 1 then
            index = 1
        end
        return self.Items[index].value
    end
    return 0
end

---Update a statistic
---@param index number -- The index of the statistic starting from 1
---@param value number -- Must be a between 0 and 100
function UIMenuStatisticsPanel:UpdateStatistic(index, value)
    if value ~= nil then
        if value > 100 then
            value = 100
        elseif value < 0 then
            value = 0
        end
        self.Items[index].value = value
        if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
            local it = IndexOf(self.ParentItem:SetParentMenu().Items, self.ParentItem)
            self.ParentItem:SetParentMenu():SendPanelsToItemScaleform(it, true)
        end
    end
end
