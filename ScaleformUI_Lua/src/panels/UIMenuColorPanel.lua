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
		CurrentSelection = startIndex or 0,
		ParentItem = nil, -- required
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