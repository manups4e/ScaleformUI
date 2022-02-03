UIMenuColorPanel = setmetatable({}, UIMenuColorPanel)
UIMenuColorPanel.__index = UIMenuColorPanel
UIMenuColorPanel.__call = function() return "UIMenuPanel", "UIMenuColorPanel" end

---New
---@param title string
---@param colorType int
---@param startIndex number
function UIMenuColorPanel.New(title, colorType, startIndex)
	_UIMenuColorPanel = {
		Title = title or "Color Panel",
		ColorPanelColorType = colorType,
		value = startIndex or 0,
		ParentItem = nil, -- required
		PanelChanged = function(menu, item, newindex) end
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
	else
		return self.value
	end
end