UIMenuVehicleColourPickerPanel = setmetatable({}, UIMenuVehicleColourPickerPanel)
UIMenuVehicleColourPickerPanel.__index = UIMenuVehicleColourPickerPanel
UIMenuVehicleColourPickerPanel.__call = function() return "UIMenuPanel", "UIMenuVehicleColourPickerPanel" end

function UIMenuVehicleColourPickerPanel.New()
    local _data = {
        ParentItem = nil, -- required
        _value = 1,
        _color = SColor.HUD_None,
        PickerSelect = function(value, color)
        end,
        PickerHovered = function(value, color)
        end,
        PickerRollOut = function(value, color)
        end
    }
    return setmetatable(_data, UIMenuVehicleColourPickerPanel)
end

function UIMenuVehicleColourPickerPanel:Color()
    return self._color
end

function UIMenuVehicleColourPickerPanel:Value(val)
    if val == nil then
        return self._value
    else
        self._value = val
        if val == -1 then
            self:_setValue(self._value)
            return
        end
        if self._value < 0 then
            self._value = 0
        end
        if self._value > 159 then
            self._value = 159
        end
        self:_setValue(self._value)
        self._color = VehicleColors:GetColorById(self._value)
        self:_PickerSelect(self._color)
    end
end

function UIMenuVehicleColourPickerPanel:_setValue(val)
    if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
        local it = IndexOf(self.ParentItem:SetParentMenu().Items, self.ParentItem)
        self.ParentItem:SetParentMenu():SendPanelsToItemScaleform(it, true)
    end
end

function UIMenuVehicleColourPickerPanel:_PickerSelect(color)
    self.Color = color
    self.PickerSelect(self.ParentItem.ParentMenu, self.ParentItem, self.Value, self.Color)
end

function UIMenuVehicleColourPickerPanel:_PickerHovered(colorId, color)
    self.PickerHovered(self.ParentItem.ParentMenu, colorId, color)
end

function UIMenuVehicleColourPickerPanel:_PickerRollout()
    self.PickerRollOut(self.ParentItem.ParentMenu, self.ParentItem, self.Value, self.Color)
end