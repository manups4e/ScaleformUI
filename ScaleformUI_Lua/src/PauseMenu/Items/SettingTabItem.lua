SettingsTabItem = setmetatable({}, SettingsTabItem)
SettingsTabItem.__index = SettingsTabItem
SettingsTabItem.__call = function()
    return "BasicTabItem", "SettingsTabItem"
end

function SettingsTabItem.NewBasic(label, rightLabel)
    data = {
        Base = BasicTabItem.New(label or ""),
        ItemType = SettingsItemType.Basic,
        Label = label or "", 
        _rightLabel = rightLabel or "",
        Parent = nil,
        OnActivated = function(item, index) 
        end
    }
    return setmetatable(data, SettingsTabItem)
end

function SettingsTabItem.NewList(label, items, index)
    data = {
        Base = BasicTabItem.New(label or ""),
        ItemType = SettingsItemType.ListItem,
        Label = label or "", 
        ListItems = items or {},
        _itemIndex = index or 0,
        Parent = nil,
        OnListChanged = function(item, value, listItem)
        end
    }
    return setmetatable(data, SettingsTabItem)
end

function SettingsTabItem.NewProgress(label, max, startIndex, masked, barColor)
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
        Parent = nil,
        OnBarChanged = function(item, value)
        end
    }
    return setmetatable(data, SettingsTabItem)
end

function SettingsTabItem.NewCheckbox(label, style, checked)
    data = {
        Base = BasicTabItem.New(label or ""),
        ItemType = SettingsItemType.CheckBox,
        Label = label or "", 
        CheckBoxStyle = style or 0,
        _isChecked = checked,
        Parent = nil,
        OnCheckboxChanged = function(item, _checked)
        end
    }
    return setmetatable(data, SettingsTabItem)
end

function SettingsTabItem.NewSlider(label, max, startIndex, barColor)
    data = {
        Base = BasicTabItem.New(label or ""),
        ItemType = SettingsItemType.SliderBar,
        Label = label or "", 
        MaxValue = max,
        _value = startIndex,
        _coloredBarColor = barColor or Colours.HUD_COLOUR_FREEMODE,
        Parent = nil,
        OnBarChanged = function(item, value)
        end
    }
    return setmetatable(data, SettingsTabItem)
end

function SettingsTabItem:RightLabel(label)
    if self.ItemType == SettingsItemType.Basic then
        if label ~= nil then
            self._rightLabel = label
            local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
            local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
            local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu:UpdateItemRightLabel(tab, leftItem, rightIndex, self._rightLabel)
        else
            return self._rightLabel
        end
    else
        local _type = ""
        for k, v in pairs(SettingsItemType) do
            if v == self.ItemType then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: RightLabel function can only be called by Basic items.. your item is of type: " .. _type)
    end
end

function SettingsTabItem:Value(value)
    if self.ItemType == SettingsItemType.SliderBar or self.ItemType == SettingsItemType.ProgressBar or self.ItemType == SettingsItemType.MaskedProgressBar then
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
    else
        local _type = ""
        for k, v in pairs(SettingsItemType) do
            if v == self.ItemType then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: Value function can only be called by colored bar items.. your item is of type: " .. _type)
    end
end

function SettingsTabItem:ItemIndex(index)
    if self.ItemType == SettingsItemType.ListItem then
        if index ~= nil then
            self._itemIndex = index
            local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
            local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
            local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu:SetRightSettingsItemIndex(tab, leftItem, rightIndex, index)
            self.OnListChanged(self, itemIndex, tostring(self.ListItems[index]))
        else
            return self._itemIndex
        end
    else
        local _type = ""
        for k, v in pairs(SettingsItemType) do
            if v == self.ItemType then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: ItemIndex function can only be called by ListItem items.. your item is of type: " .. _type)
    end
end


function SettingsTabItem:Checked(checked)
    if self.ItemType == SettingsItemType.CheckBox then
        if checked ~= nil then
            self._isChecked = checked
            local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
            local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
            local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu:SetRightSettingsItemBool(tab, leftItem, rightIndex, checked)
            self.OnCheckboxChanged(self, checked)
        else
            return self._isChecked
        end
    else
        local _type = ""
        for k, v in pairs(SettingsItemType) do
            if v == self.ItemType then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: Checked function can only be called by CheckBox items.. your item is of type: " .. _type)
    end
end

function SettingsTabItem:ColoredBarColor(color)
    if self.ItemType == SettingsItemType.SliderBar or self.ItemType == SettingsItemType.ProgressBar or self.ItemType == SettingsItemType.MaskedProgressBar then
        if color ~= nil then
            self._coloredBarColor = color
            local tab = IndexOf(self.Parent.Parent.Base.Parent.Tabs, self.Parent.Parent) - 1
            local leftItem = IndexOf(self.Parent.Parent.LeftItemList, self.Parent) - 1
            local rightIndex = IndexOf(self.Parent.ItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu:UpdateItemColoredBar(tab, leftItem, rightIndex, color)
        else
            return self._coloredBarColor
        end
    else
        local _type = ""
        for k, v in pairs(SettingsItemType) do
            if v == self.ItemType then _type = tostring(k) end
        end
        print("SCALEFORMUI - WARNING: ColoredBarColor function can only be called by colored bar items.. your item is of type: " .. _type)
    end
end
