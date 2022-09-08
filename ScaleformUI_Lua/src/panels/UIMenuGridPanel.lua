UIMenuGridPanel = setmetatable({}, UIMenuGridPanel)
UIMenuGridPanel.__index = UIMenuGridPanel
UIMenuGridPanel.__call = function() return "UIMenuPanel", "UIMenuGridPanel" end

---New
---@param title string
---@param colorType int
---@param startIndex number
function UIMenuGridPanel.New(topText, leftText, rightText, bottomText, circlePosition, gridType)
	local _UIMenuGridPanel = {
		TopLabel = topText or "UP",
		RightLabel = leftText or "RIGHT",
		LeftLabel = rightText or "LEFT",
		BottomLabel = bottomText or "DOWN",
		CirclePosition = circlePosition or vector2(0.5, 0.5),
		GridType = gridType or 0,
		ParentItem = nil, -- required
		OnGridPanelChanged = function(item, panel, newindex) end
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

function UIMenuGridPanel:SetCirclePosition(position)
	if position ~= nil then
		self.CirclePosition = position
		if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
			local it = IndexOf(self.ParentItem:SetParentMenu().Items, self.ParentItem)
			local van = IndexOf(self.ParentItem.Panels, self)
			ScaleformUI.Scaleforms._ui:CallFunction("SET_GRID_PANEL_VALUE_RETURN_VALUE", false, it-1, van-1, position.x, position.y)
		end
	else
		return self.CirclePosition
	end
end