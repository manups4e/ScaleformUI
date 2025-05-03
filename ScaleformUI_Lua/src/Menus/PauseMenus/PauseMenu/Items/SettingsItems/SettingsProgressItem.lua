SettingsProgressItem = {}
SettingsProgressItem.__index = SettingsProgressItem
setmetatable(SettingsProgressItem, { __index = SettingsItem })
SettingsProgressItem.__call = function() return "SettingsProgressItem" end

---@class SettingsProgressItem
---@field public Base PauseMenuItem
---@field public ItemType SettingsItemType
---@field public Label string
---@field public MaxValue number
---@field public Parent PauseMenuItem
---@field public OnBarChanged fun(item: SettingsProgressItem, value: number)
---@field public OnProgressSelected fun(item: SettingsProgressItem, value: number)

---Creates a new SettingsProgressItem.
---@param label string
---@param max number
---@param startIndex number
---@param masked boolean
---@param barColor SColor
---@return table
function SettingsProgressItem.New(label, max, startIndex, masked, barColor)
    local _type = SettingsItemType.ProgressBar
    if (masked) then
        _type = SettingsItemType.MaskedProgressBar
    end
    local base = SettingsItem.New(label,  "")
    base.ItemType = _type
    base.MaxValue = max
    base._value = startIndex
    base._coloredBarColor = barColor or SColor.HUD_Freemode
    base.OnBarChanged = function(item, value)
    end
    base.OnProgressSelected = function(item, value)
    end
    return setmetatable(base, SettingsProgressItem)
end

---Set the value of the item.
---@param value number
---@return number
function SettingsProgressItem:Value(value)
    if value ~= nil then
        self._value = value
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
        self.OnBarChanged(self, value)
    end
    return self._value
end

---Set the color of the colored bar.
---@param color SColor
---@return SColor
function SettingsProgressItem:ColoredBarColor(color)
    if color ~= nil then
        self._coloredBarColor = color
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self._coloredBarColor
end