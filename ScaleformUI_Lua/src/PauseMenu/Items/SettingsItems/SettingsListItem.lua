SettingsListItem = setmetatable({}, SettingsListItem)
SettingsListItem.__index = SettingsListItem
SettingsListItem.__call = function()
    return "SettingsItem", "SettingsItem"
end

function SettingsListItem.New(label, items, index)
    data = {
        Base = SettingsItem.New(label, ""),
        ItemType = SettingsItemType.ListItem,
        Label = label or "",
        ListItems = items or {},
        _itemIndex = index or 0,
        _enabled = true,
        _hovered = false,
        _selected = false,
        Parent = nil,
        OnListChanged = function(item, value, listItem)
        end,
        OnListSelected = function(item, value, listItem)
        end
    }
    return setmetatable(data, SettingsListItem)
end

function SettingsListItem:Enabled(enabled)
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

function SettingsListItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    else
        return self._hovered
    end
end

function SettingsListItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    else
        return self._selected
    end
end

function SettingsListItem:ItemIndex(index)
    if index ~= nil then
        self._itemIndex = index
        local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
        local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
        local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu:SetRightSettingsItemIndex(tab, leftItem, rightIndex, index)
        self.OnListChanged(self, self._itemIndex, tostring(self.ListItems[index]))
    else
        return self._itemIndex
    end
end
