UIMenuPercentagePanel = setmetatable({}, UIMenuPercentagePanel)
UIMenuPercentagePanel.__index = UIMenuPercentagePanel
UIMenuPercentagePanel.__call = function() return "UIMenuPanel", "UIMenuPercentagePanel" end

---New
---@param title string
---@param colorType int
---@param startIndex number
function UIMenuPercentagePanel.New(title, minText, maxText, initialValue)
	_UIMenuPercentagePanel = {
		Min = minText or "0%",
		Max = maxText or "100%",
		Title = title or "Opacity",
		Percentage = initialValue or 0.0,
		ParentItem = nil, -- required
		PanelChanged = function(menu, item, newindex) end
	}
	return setmetatable(_UIMenuPercentagePanel, UIMenuPercentagePanel)
end

---SetParentItem
---@param Item table
function UIMenuPercentagePanel:SetParentItem(Item) -- required
	if not Item() == nil then
		self.ParentItem = Item
	else
		return self.ParentItem
	end
end