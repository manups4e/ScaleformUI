SettingsItem = setmetatable({}, SettingsItem)
SettingsItem.__index = SettingsItem
SettingsItem.__call = function()
    return "SettingsItem", "SettingsItem"
end

function SettingsItem.New(label, rightLabel)
    data = {
        ItemType = SettingsItemType.Basic,
        Label = label or "", 
        _rightLabel = rightLabel or "",
        Parent = nil,
        _enabled = true,
        _hovered = false,
        _selected = false,
        OnActivated = function(item, index) 
        end
    }
    return setmetatable(data, SettingsItem)
end

function SettingsItem:Enabled(enabled)
    if enabled ~= nil then
        self._enabled = enabled
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent.Base.Parent ~= nil and self.Parent.Parent.Base.Parent:Visible() then
            if self.Parent:Selected() then
                local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
                local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
                local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_RIGHT_ITEM", false, tab, leftItem, rightIndex, self._enabled)
            end
        end
    else
        return self._enabled
    end
end

function SettingsItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    else
        return self._hovered
    end
end

function SettingsItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    else
        return self._selected
    end
end

function SettingsItem:RightLabel(label)
    if label ~= nil then
        self._rightLabel = label
        if self.Parent ~= nil and self.Parent.Parent ~= nil and self.Parent.Parent.Base.Parent ~= nil and self.Parent.Parent.Base.Parent:Visible() then
            if self.Parent:Selected() then
                local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
                local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
                local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
                ScaleformUI.Scaleforms._pauseMenu.UpdateItemRightLabel(tab, leftItem, rightIndex, self._rightLabel)
            end
        end
    else
        return self._rightLabel
    end
end