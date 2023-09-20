StatsTabItem = setmetatable({}, StatsTabItem)
StatsTabItem.__index = StatsTabItem
StatsTabItem.__call = function()
    return "BasicTabItem", "StatsTabItem"
end

---@class StatsTabItem
---@field public Base BasicTabItem
---@field public Type StatItemType
---@field public Label string
---@field public Parent BasicTabItem
---@field public OnBarChanged fun(item: StatsTabItem, value: number)
---@field public OnSliderSelected fun(item: StatsTabItem, value: number)

---Creates a new StatsTabItem.
---@param label string
---@param rightLabel string?
---@return table
function StatsTabItem.NewBasic(label, rightLabel)
    local data = {
        Base = BasicTabItem.New(label or ""),
        Type = StatItemType.Basic,
        Label = label or "",
        _rightLabel = rightLabel or "",
        LabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        RightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY
    }
    return setmetatable(data, StatsTabItem)
end

---Adds a new bar to the StatsTabItem.
---@param label string
---@param value number?
---@param color SColor?
---@return table
function StatsTabItem.NewBar(label, value, color)
    local data = {
        Base = BasicTabItem.New(label or ""),
        Type = StatItemType.ColoredBar,
        Label = label or "",
        _value = value,
        _coloredBarColor = color or SColor.HUD_Freemode,
        LabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY
    }
    return setmetatable(data, StatsTabItem)
end

---Sets the right label of the item.
---@param label string
---@return string
function StatsTabItem:RightLabel(label)
    if self.Type == StatItemType.Basic then
        if label ~= nil then
            self._rightLabel = label
            local tab = IndexOf(self.Base.Parent.Parent.Parent.Tabs, self.Base.Parent.Parent) - 1
            local leftItem = IndexOf(self.Base.Parent.Parent.LeftItemList, self.Base.Parent) - 1
            local rightIndex = IndexOf(self.Base.Parent.ItemList, self) - 1
            self.Base.Parent.Parent.Parent._pause:UpdateStatsItemBasic(tab, leftItem, rightIndex, self.Label,
                self._rightLabel)
        else
            return self._rightLabel
        end
    else
        local _type = ""
        for k, v in pairs(StatItemType) do
            if v == self.Type then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: RightLabel function can only be called by Basic items.. your item is of type: " ..
            _type)
    end
    return self._rightLabel
end

---Sets the value of the item.
---@param value any
---@return any
function StatsTabItem:Value(value)
    if self.Type == StatItemType.ColoredBar then
        if value ~= nil then
            self._value = value
            local tab = IndexOf(self.Base.Parent.Parent.Parent.Tabs, self.Base.Parent.Parent) - 1
            local leftItem = IndexOf(self.Base.Parent.Parent.LeftItemList, self.Base.Parent) - 1
            local rightIndex = IndexOf(self.Base.Parent.ItemList, self) - 1
            self.Base.Parent.Parent.Parent._pause:UpdateStatsItemBar(tab, leftItem, rightIndex, self._value)
            self.OnBarChanged(self, value)
        else
            return self._value
        end
    else
        local _type = ""
        for k, v in pairs(StatItemType) do
            if v == self.Type then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: Value function can only be called by colored bar items.. your item is of type: " ..
            _type)
    end
    return self._value
end

---Sets the color of the item.
---@param color SColor
---@return SColor
function StatsTabItem:ColoredBarColor(color)
    if self.Type == StatItemType.ColoredBar then
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
        print(
            "SCALEFORMUI - WARNING: ColoredBarColor function can only be called by colored bar items.. your item is of type: " ..
            _type)
    end
    return self._coloredBarColor
end
