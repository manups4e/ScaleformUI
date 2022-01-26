UIMenuGridPanel = setmetatable({}, UIMenuGridPanel)
UIMenuGridPanel.__index = UIMenuGridPanel
UIMenuGridPanel.__call = function() return "UIMenuPanel", "UIMenuGridPanel" end

---New
---@param title string
---@param colorType int
---@param startIndex number
function UIMenuGridPanel.New(topText, leftText, rightText, bottomText, circlePosition, gridType)
	_UIMenuGridPanel = {
		TopLabel = topText or "UP",
		RightLabel = leftText or "RIGHT",
		LeftLabel = rightText or "LEFT",
		BottomLabel = bottomText or "DOWN",
		CirclePosition = circlePosition or vector2(0.5, 0.5),
		GridType = gridType or 0,
		ParentItem = nil, -- required
	}
	return setmetatable(_UIMenuGridPanel, UIMenuGridPanel)
end

---SetParentItem
---@param Item table
function UIMenuGridPanel:SetParentItem(Item) -- required
	if not Item() == nil then
		self.ParentItem = Item
	else
		return self.ParentItem
	end
end