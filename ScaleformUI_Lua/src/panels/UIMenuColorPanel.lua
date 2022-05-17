UIMenuColorPanel = setmetatable({}, UIMenuColorPanel)
UIMenuColorPanel.__index = UIMenuColorPanel
UIMenuColorPanel.__call = function() return "UIMenuPanel", "UIMenuColorPanel" end

---New
---@param title string
---@param colorType int
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
		OnColorPanelChanged = function(item, panel, newindex) end
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
			local van = IndexOf(self.ParentItem.Panels, self)
			ScaleformUI.Scaleforms._ui:CallFunction("SET_COLOR_PANEL_VALUE", false, it, van, new_value)
		end
	else
		return self.value
	end
end