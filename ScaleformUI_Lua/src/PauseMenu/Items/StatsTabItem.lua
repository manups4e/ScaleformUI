StatsTabItem = setmetatable({}, StatsTabItem)
StatsTabItem.__index = StatsTabItem
StatsTabItem.__call = function()
    return "BasicTabItem", "StatsTabItem"
end

function StatsTabItem.NewBasic(label, rightLabel)
    data = {
        Base = BasicTabItem.New(label or ""),
        Type = StatItemType.Basic,
        Label = label or "", 
        _rightLabel = rightLabel or ""
    }
    return setmetatable(data, StatsTabItem)
end

function StatsTabItem.NewBar(label, value, color)
    data = {
        Base = BasicTabItem.New(label or ""),
        Type = StatItemType.ColoredBar,
        Label = label or "", 
        _value = value,
        _coloredBarColor = color or Colours.HUD_COLOUR_FREEMODE
    }
    return setmetatable(data, StatsTabItem)
end

function StatsTabItem:RightLabel(label)
    if self.Type == StatItemType.Basic then
        if label ~= nil then
            self._rightLabel = label
            local tab = IndexOf(self.Base.Parent.Parent.Parent.Tabs, self.Base.Parent.Parent) - 1
            local leftItem = IndexOf(self.Base.Parent.Parent.LeftItemList, self.Base.Parent) - 1
            local rightIndex = IndexOf(self.Base.Parent.ItemList, self) - 1
            self.Base.Parent.Parent.Parent._pause:UpdateStatsItemBasic(tab, leftItem, rightIndex, self.Label, self._rightLabel)
        else
            return self._rightLabel
        end
    else
        local _type = ""
        for k, v in pairs(StatItemType) do
            if v == self.Type then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: RightLabel function can only be called by Basic items.. your item is of type: " .. _type)
    end
end

function StatsTabItem:Value(value)
    if self.Type == SettingsItemType.ColoredBar then
        if value ~= nil then
            self._value = value
            local tab = IndexOf(self.Base.Parent.Parent.Parent.Tabs, self.Base.Parent.Parent) - 1
            local leftItem = IndexOf(self.Base.Parent.Parent.LeftItemList, self.Base.Parent) - 1
            local rightIndex = IndexOf(self.Base.Parent.ItemList, self) - 1
            self.Base.Parent.Parent.Parent._pause:UpdateStatsItemBar(tab, leftItem, rightIndex, _value)
            self.OnBarChanged(self, value)
        else
            return self._value
        end
    else
        local _type = ""
        for k, v in pairs(StatItemType) do
            if v == self.Type then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: Value function can only be called by colored bar items.. your item is of type: " .. _type)
    end
end

function StatsTabItem:ColoredBarColor(color)
    if self.Type == SettingsItemType.ColoredBar then
        if color ~= nil then
            self._coloredBarColor = color
            local tab = IndexOf(self.Base.Parent.Parent.Parent.Tabs, self.Base.Parent.Parent) - 1
            local leftItem = IndexOf(self.Base.Parent.Parent.LeftItemList, self.Base.Parent) - 1
            local rightIndex = IndexOf(self.Base.Parent.ItemList, self) - 1
            self.Base.Parent.Parent.Parent._pause:UpdateStatsItemBar(tab, leftItem, rightIndex, color)
        else
            return self._coloredBarColor
        end
    else
        local _type = ""
        for k, v in pairs(StatItemType) do
            if v == self.Type then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: ColoredBarColor function can only be called by colored bar items.. your item is of type: " .. _type)
    end
end
