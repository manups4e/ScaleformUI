SettingsCheckboxItem = setmetatable({}, SettingsCheckboxItem)
SettingsCheckboxItem.__index = SettingsCheckboxItem
SettingsCheckboxItem.__call = function()
    return "SettingsItem", "SettingsItem"
end

function SettingsCheckboxItem.New(label, style, checked)
    local data = {
        Base = SettingsItem.New(label),
        ItemType = SettingsItemType.CheckBox,
        Label = label or "",
        CheckBoxStyle = style or 0,
        _isChecked = checked,
        _enabled = true,
        _hovered = false,
        _selected = false,
        Parent = nil,
        OnCheckboxChanged = function(item, _checked)
        end
    }
    return setmetatable(data, SettingsCheckboxItem)
end

function SettingsCheckboxItem:Enabled(enabled)
    if enabled ~= nil then
        self._enabled = enabled
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent.Base.Parent ~= nil and self.Parent.Parent.Base.Parent:Visible() then
            if self.Parent:Selected() then
                local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
                local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
                local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_RIGHT_ITEM", false, tab, leftItem,
                rightIndex, self._enabled)
            end
        end
    else
        return self._enabled
    end
end

function SettingsCheckboxItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    else
        return self._hovered
    end
end

function SettingsCheckboxItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    else
        return self._selected
    end
end

function SettingsCheckboxItem:Checked(checked)
    if checked ~= nil then
        self._isChecked = checked
        local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
        local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
        local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu:SetRightSettingsItemBool(tab, leftItem, rightIndex, checked)
        self.OnCheckboxChanged(self, checked)
    else
        return self._isChecked
    end
end
