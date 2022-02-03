UIMenuStatisticsPanel = setmetatable({}, UIMenuStatisticsPanel)
UIMenuStatisticsPanel.__index = UIMenuStatisticsPanel
UIMenuStatisticsPanel.__call = function() return "UIMenuPanel", "UIMenuStatisticsPanel" end

---New
---@param title string
---@param colorType int
---@param startIndex number
function UIMenuStatisticsPanel.New(items)
	_UIMenuStatisticsPanel = {
		Items = items or {},
		ParentItem = nil, -- required
	}
	return setmetatable(_UIMenuStatisticsPanel, UIMenuStatisticsPanel)
end

---SetParentItem
---@param Item table
function UIMenuStatisticsPanel:SetParentItem(Item) -- required
	if not Item() == nil then
		self.ParentItem = Item
	else
		return self.ParentItem
	end
end

---AddStatistic
---@param Item table
function UIMenuStatisticsPanel:AddStatistic(name, value) -- required
    if name ~= nil and name ~= "" and value ~= nil then
        if value > 100 then
            value = 100
        elseif value < 0 then
            value = 0
        end
        table.insert(self.Items, {['name'] = name, ['value'] = value}) 
    end
end