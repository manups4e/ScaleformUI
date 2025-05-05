StatsTabItem = {}
StatsTabItem.__index = StatsTabItem
setmetatable(StatsTabItem, { __index = PauseMenuItem })
StatsTabItem.__call = function() return "StatsTabItem" end


---@class StatsTabItem
---@field public Base PauseMenuItem
---@field public Type StatItemType
---@field public Label string
---@field public Parent PauseMenuItem
---@field public OnBarChanged fun(item: StatsTabItem, value: number)
---@field public OnSliderSelected fun(item: StatsTabItem, value: number)

---Creates a new StatsTabItem.
---@param label string
---@param rightLabel string?
---@return table
function StatsTabItem.NewBasic(label, rightLabel)
    local base = PauseMenuItem.New(label, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)
    base.Type = StatItemType.Basic
    base._rightLabel = rightLabel or ""
    base.RightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY
    return setmetatable(base, StatsTabItem)
end

---Adds a new bar to the StatsTabItem.
---@param label string
---@param value number?
---@param color SColor?
---@return table
function StatsTabItem.NewBar(label, value, color)
    local base = PauseMenuItem.New(label, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)
    base.Type = StatItemType.ColoredBar
    base._value = value
    base._coloredBarColor = color or SColor.HUD_Freemode
    return setmetatable(base, StatsTabItem)
end

---Sets the right label of the item.
---@param label string
---@return string
function StatsTabItem:RightLabel(label)
    if self.Type == StatItemType.Basic then
        if label ~= nil then
            self._rightLabel = label
            if self.ParentColumn ~= nil and self.ParentColumn:visible() then
                self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
            end
        else
            return self._rightLabel
        end
    else
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
            if self.ParentColumn ~= nil and self.ParentColumn:visible() then
                self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
            end
            self.OnBarChanged(self, value)
        else
            return self._value
        end
    else
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
            if self.ParentColumn ~= nil and self.ParentColumn:visible() then
                self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
            end
        else
            return self._coloredBarColor
        end
    else
        print(
        "SCALEFORMUI - WARNING: ColoredBarColor function can only be called by colored bar items.. your item is of type: " ..
        _type)
    end
    return self._coloredBarColor
end
