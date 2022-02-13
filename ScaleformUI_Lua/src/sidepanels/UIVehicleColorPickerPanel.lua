UIVehicleColorPickerPanel = setmetatable({}, UIVehicleColorPickerPanel)
UIVehicleColorPickerPanel.__index = UIVehicleColorPickerPanel
UIVehicleColorPickerPanel.__call = function() return "UIVehicleColorPickerPanel", "UIVehicleColorPickerPanel" end

function UIVehicleColorPickerPanel.New(side, title, color, inside)
	if inside == -1 then
        _titleType = 1
    elseif inside then
        _titleType = 2
    else
        _titleType = 0
    end

    if color ~= -1 then
        _titleColor = color
    else
        _titleColor = Colours.NONE
    end

    _UIVehicleColorPickerPanel = {
        PanelSide = side,
        Title = title,
        TitleColor = _titleColor,
        TitleType = _titleType,
        Value = 1,
        ParentItem = nil,
        PickerSelect = function(menu, item, newindex) end
	}
	return setmetatable(_UIVehicleColorPickerPanel, UIVehicleColorPickerPanel)
end

function UIVehicleColorPickerPanel:SetParentItem(Item) -- required
	if not Item() == nil then
		self.ParentItem = Item
	else
		return self.ParentItem
	end
end

function UIVehicleColorPickerPanel:UpdatePanelTitle(title)
    self.Title = title

    if self.ParentItem ~= nil then
        local item = IndexOf(self.ParentItem.Base.ParentMenu.Items, self.ParentItem) - 1
        ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_SIDE_PANEL_TITLE", false, item, title)
    end
end