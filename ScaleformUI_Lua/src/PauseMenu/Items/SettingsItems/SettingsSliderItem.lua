SettingsSliderItem = setmetatable({}, SettingsSliderItem)
SettingsSliderItem.__index = SettingsSliderItem
SettingsSliderItem.__call = function()
    return "SettingsItem", "SettingsItem"
end

---@class SettingsSliderItem
---@field public Base BasicTabItem
---@field public ItemType SettingsItemType
---@field public Label string
---@field public MaxValue number
---@field public Parent BasicTabItem
---@field public OnBarChanged fun(item: SettingsSliderItem, value: number)
---@field public OnSliderSelected fun(item: SettingsSliderItem, value: number)

---Creates a new SettingsSliderItem.
---@param label string
---@param max number
---@param startIndex number
---@param barColor number
---@return table
function SettingsSliderItem.New(label, max, startIndex, barColor)
    local data = {
        Base = BasicTabItem.New(label or ""),
        ItemType = SettingsItemType.SliderBar,
        Label = label or "",
        MaxValue = max,
        _value = startIndex,
        _coloredBarColor = barColor or Colours.HUD_COLOUR_FREEMODE,
        Parent = nil,
        _enabled = true,
        _hovered = false,
        _selected = false,
        OnBarChanged = function(item, value)
        end,
        OnSliderSelected = function(item, value)
        end
    }
    return setmetatable(data, SettingsSliderItem)
end

---Toggle the enabled state of the item.
---@param enabled boolean
---@return boolean
function SettingsSliderItem:Enabled(enabled)
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
    end
    return self._enabled
end

---Toggle the hovered state of the item.
---@param hover boolean
---@return boolean
function SettingsSliderItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    end
    return self._hovered
end

---Toggle the selected state of the item.
---@param selected boolean
---@return boolean
function SettingsSliderItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    end
    return self._selected
end

---Set the value of the item.
---@param value number
---@return number
function SettingsSliderItem:Value(value)
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
---@param color number
---@return number
function SettingsSliderItem:ColoredBarColor(color)
    if color ~= nil then
        self._coloredBarColor = color
        local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
        local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
        local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu:UpdateItemColoredBar(tab, leftItem, rightIndex, color)
    end
    return self._coloredBarColor
end
