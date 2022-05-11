SettingsProgressItem = setmetatable({}, SettingsProgressItem)
SettingsProgressItem.__index = SettingsProgressItem
SettingsProgressItem.__call = function()
    return "SettingsItem", "SettingsItem"
end

function SettingsProgressItem.New(label, max, startIndex, masked, barColor)
    local _type = SettingsItemType.ProgressBar
    if(masked) then
        _type = SettingsItemType.MaskedProgressBar
    end
    data = {
        Base = BasicTabItem.New(label or ""),
        ItemType = _type,
        Label = label or "", 
        MaxValue = max,
        _value = startIndex,
        _coloredBarColor = barColor or Colours.HUD_COLOUR_FREEMODE,
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

function SettingsProgressItem:Enabled(enabled)
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

function SettingsProgressItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    else
        return self._hovered
    end
end

function SettingsProgressItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    else
        return self._selected
    end
end

function SettingsProgressItem:Value(value)
    if value ~= nil then
        self._value = value
        local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
        local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
        local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu:SetRightSettingsItemValue(tab, leftItem, rightIndex, value)
        self.OnBarChanged(self, value)
    else
        return self._value
    end
end

function SettingsProgressItem:ColoredBarColor(color)
    if color ~= nil then
        self._coloredBarColor = color
        local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
        local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
        local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu:UpdateItemColoredBar(tab, leftItem, rightIndex, color)
    else
        return self._coloredBarColor
    end
end
