SettingsSliderItem = {}
SettingsSliderItem.__index = SettingsSliderItem
setmetatable(SettingsSliderItem, { __index = SettingsItem })
SettingsSliderItem.__call = function() return "SettingsSliderItem" end

---@class SettingsSliderItem
---@field public Base PauseMenuItem
---@field public ItemType SettingsItemType
---@field public Label string
---@field public MaxValue number
---@field public Parent PauseMenuItem
---@field public OnBarChanged fun(item: SettingsSliderItem, value: number)
---@field public OnSliderSelected fun(item: SettingsSliderItem, value: number)

---Creates a new SettingsSliderItem.
---@param label string
---@param max number
---@param startIndex number
---@param barColor SColor
---@return table
function SettingsSliderItem.New(label, max, startIndex, barColor)
    local base = SettingsItem.New(label, "")
    base.ItemType = SettingsItemType.SliderBar
    base.MaxValue = max
    base._value = startIndex
    base._coloredBarColor = barColor or SColor.HUD_Freemode
    base.OnBarChanged = function(item, value)
    end
    base.OnSliderSelected = function(item, value)
    end
    return setmetatable(base, SettingsSliderItem)
end

---Set the value of the item.
---@param value number
---@return number
function SettingsSliderItem:Value(value)
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
function SettingsSliderItem:ColoredBarColor(color)
    if color ~= nil then
        self._coloredBarColor = color
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self._coloredBarColor
end
