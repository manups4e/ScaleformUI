SettingsProgressItem = setmetatable({}, SettingsProgressItem)
SettingsProgressItem.__index = SettingsProgressItem
SettingsProgressItem.__call = function()
    return "SettingsItem", "SettingsItem"
end

---@class SettingsProgressItem
---@field public Base BasicTabItem
---@field public ItemType SettingsItemType
---@field public Label string
---@field public MaxValue number
---@field public Parent BasicTabItem
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
    local data = {
        Base = BasicTabItem.New(label or ""),
        ItemType = _type,
        Label = label or "",
        MaxValue = max,
        _value = startIndex,
        _coloredBarColor = barColor or SColor.HUD_Freemode,
        _enabled = true,
        _hovered = false,
        _selected = false,
        Parent = nil,
        OnBarChanged = function(item, value)
        end,
        OnProgressSelected = function(item, value)
        end
    }
    return setmetatable(data, SettingsProgressItem)
end

---Toggle the enabled state of the item.
---@param enabled boolean
---@return boolean
function SettingsProgressItem:Enabled(enabled)
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
function SettingsProgressItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    end
    return self._hovered
end

---Toggle the selected state of the item.
---@param selected boolean
---@return boolean
function SettingsProgressItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    end
    return self._selected
end

---Set the value of the item.
---@param value number
---@return number
function SettingsProgressItem:Value(value)
    if value ~= nil then
        self._value = value
        local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
        local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
        local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu:SetRightSettingsItemValue(tab, leftItem, rightIndex, value)
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
        local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
        local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
        local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu:UpdateItemColoredBar(tab, leftItem, rightIndex, color)
    end
    return self._coloredBarColor
end
