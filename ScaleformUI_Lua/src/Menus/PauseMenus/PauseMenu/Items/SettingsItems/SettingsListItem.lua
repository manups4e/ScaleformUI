SettingsListItem = setmetatable({}, SettingsListItem)
SettingsListItem.__index = SettingsListItem
SettingsListItem.__call = function()
    return "SettingsItem", "SettingsItem"
end

---@class SettingsListItem
---@field public Base SettingsItem
---@field public ItemType SettingsItemType
---@field public Label string
---@field public ListItems table
---@field public Parent SettingsItem
---@field public OnListChanged fun(item: SettingsListItem, value: number, listItem: string)
---@field public OnListSelected fun(item: SettingsListItem, value: number, listItem: string)

---Create a new SettingsListItem.
---@param label string
---@param items table
---@param index number
---@return table
function SettingsListItem.New(label, items, index)
    local data = {
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

---Toggle the enabled state of the item.
---@param enabled boolean
---@return boolean
function SettingsListItem:Enabled(enabled)
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
function SettingsListItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    end
    return self._hovered
end

---Toggle the selected state of the item.
---@param selected boolean
---@return boolean
function SettingsListItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    end
    return self._selected
end

---Set the index of the selected item.
---@param index number
---@return number
function SettingsListItem:ItemIndex(index)
    if index ~= nil then
        self._itemIndex = index
        local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
        local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
        local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu:SetRightSettingsItemIndex(leftItem, rightIndex, index)
        self.OnListChanged(self, self._itemIndex, tostring(self.ListItems[index]))
    end
    return self._itemIndex
end
