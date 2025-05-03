SettingsListItem = {}
SettingsListItem.__index = SettingsListItem
setmetatable(SettingsListItem, { __index = SettingsItem })
SettingsListItem.__call = function() return "SettingsListItem" end


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
    local base = SettingsItem.New(label, "")
    base.ItemType = SettingsItemType.ListItem
    base.ListItems = items or {}
    base._itemIndex = index or 1
    base.OnListChanged = function(item, value, listItem)
    end
    base.OnListSelected = function(item, value, listItem)
    end
    return setmetatable(base, SettingsListItem)
end

---Set the index of the selected item.
---@param index number
---@return number
function SettingsListItem:ItemIndex(index)
    if index ~= nil then
        self._itemIndex = index
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
        self.OnListChanged(self, self._itemIndex, tostring(self.ListItems[index]))
    end
    return self._itemIndex
end

function SettingsListItem:CurrentItem()
    return tostring(self.ListItems[self._itemIndex])
end