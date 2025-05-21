UIVehicleColorPickerPanel = setmetatable({}, UIVehicleColorPickerPanel)
UIVehicleColorPickerPanel.__index = UIVehicleColorPickerPanel
UIVehicleColorPickerPanel.__call = function() return "UIVehicleColorPickerPanel", "UIVehicleColorPickerPanel" end

function UIVehicleColorPickerPanel.New(side, title, color)
    local _titleColor
    if color ~= SColor.HUD_None then
        _titleColor = color
    else
        _titleColor = SColor.HUD_None
    end

    _UIVehicleColorPickerPanel = {
        PanelSide = side,
        Title = title,
        TitleColor = _titleColor,
        TitleType = 0,
        Value = 1,
        ParentItem = nil,
        Color = SColor.HUD_None,
        PickerSelect = function(menu, item, newindex, color)
        end,
        PickerHovered = function(menu, item, index, color)
        end
    }
    return setmetatable(_UIVehicleColorPickerPanel, UIVehicleColorPickerPanel)
end

function UIVehicleColorPickerPanel:SetParentItem(Item) -- required
    if Item ~= nil then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

function UIVehicleColorPickerPanel:UpdatePanelTitle(title)
    self.Title = title
    if self.ParentItem ~= nil and self.ParentItem.ParentMenu ~= nil and self.ParentItem.ParentMenu:Visible() then
        local it = IndexOf(self.ParentItem.ParentMenu.Items, self)
        self.ParentItem.ParentMenu:SendSidePanelToScaleform(it, true)
    end
end

function UIVehicleColorPickerPanel:_PickerSelect(color)
    self.Color = color
    self.PickerSelect(self.ParentItem.ParentMenu, self.ParentItem, self.Value, self.Color)
end

function UIVehicleColorPickerPanel:_PickerHovered(colorId, color)

    self.PickerHovered(self.ParentItem.ParentMenu, colorId, color)
end

function UIVehicleColorPickerPanel:_PickerRollout()
    self.PickerHovered(self.ParentItem.ParentMenu, self.ParentItem, self.Value, self.Color)
end
