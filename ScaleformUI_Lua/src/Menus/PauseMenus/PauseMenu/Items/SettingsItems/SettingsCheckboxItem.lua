SettingsCheckboxItem = setmetatable({}, SettingsCheckboxItem)
SettingsCheckboxItem.__index = SettingsCheckboxItem
SettingsCheckboxItem.__call = function()
    return "SettingsItem", "SettingsItem"
end

---@class SettingsCheckboxItem
---@field public Base SettingsItem
---@field public ItemType SettingsItemType
---@field public Label string
---@field public CheckBoxStyle number
---@field public Parent SettingsItem
---@field public OnCheckboxChanged fun(item:SettingsCheckboxItem, checked:boolean)

---Create a new SettingsCheckboxItem.
---@param label string
---@param style number
---@param checked boolean
---@return table
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

---Toggle the enabled state of the item.
---@param enabled boolean
---@return boolean
function SettingsCheckboxItem:Enabled(enabled)
    if enabled ~= nil then
        self._enabled = enabled
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent.Base.Parent ~= nil and self.Parent.Parent.Base.Parent:Visible() then
            if self.Parent:Selected() then
                local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
                local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_RIGHT_ITEM", leftItem,
                    rightIndex, self._enabled)
            end
        end
    end
    return self._enabled
end

---Toggle the hovered state of the item.
---@param hover boolean
---@return boolean
function SettingsCheckboxItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    end
    return self._hovered
end

---Toggle the selected state of the item.
---@param selected boolean
---@return boolean
function SettingsCheckboxItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    end
    return self._selected
end

---Toggle the checked state of the item.
---@param checked boolean
---@return boolean
function SettingsCheckboxItem:Checked(checked)
    if checked ~= nil then
        self._isChecked = checked
        local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
        local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu:SetRightSettingsItemBool(tab, leftItem, rightIndex, checked)
        self.OnCheckboxChanged(self, checked)
    end
    return self._isChecked
end
