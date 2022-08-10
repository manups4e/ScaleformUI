UIMenuStatisticsPanel = setmetatable({}, UIMenuStatisticsPanel)
UIMenuStatisticsPanel.__index = UIMenuStatisticsPanel
UIMenuStatisticsPanel.__call = function() return "UIMenuPanel", "UIMenuStatisticsPanel" end

---New
---@param title string
---@param colorType int
---@param startIndex number
function UIMenuStatisticsPanel.New(items)
	local _UIMenuStatisticsPanel = {
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
		self.Items[#self.Items + 1] = {['name'] = name, ['value'] = value}
		if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
			local it = IndexOf(self.ParentItem:SetParentMenu().Items, self.ParentItem)
			local van = IndexOf(self.ParentItem.Panels, self)
			ScaleformUI.Scaleforms._ui:CallFunction("ADD_STATISTIC_TO_PANEL", false, it, van, name, value)
		end
    end
end

function UIMenuStatisticsPanel:GetPercentage(id)
	if id ~= nil then
		return self.Items[id].value
	end
end

function UIMenuStatisticsPanel:UpdateStatistic(id, value)
    if value ~= nil then
        if value > 100 then
            value = 100
        elseif value < 0 then
            value = 0
        end
		self.Items[id].value = value
		if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
			local it = IndexOf(self.ParentItem:SetParentMenu().Items, self.ParentItem)
			local van = IndexOf(self.ParentItem.Panels, self)
			ScaleformUI.Scaleforms._ui:CallFunction("SET_PANEL_STATS_ITEM_VALUE", false, it, van, id-1, value)
		end
    end
end