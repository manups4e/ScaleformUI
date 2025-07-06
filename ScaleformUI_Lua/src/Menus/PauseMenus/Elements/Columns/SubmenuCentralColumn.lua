SubmenuCentralColumn = {}
SubmenuCentralColumn.__index = SubmenuCentralColumn
setmetatable(SubmenuCentralColumn, { __index = PM_Column })
SubmenuCentralColumn.__call = function() return "SubmenuCentralColumn" end

function SubmenuCentralColumn.New(pos)
    local col = PM_Column.New(pos)
    col._type = 0
    return setmetatable(col, SubmenuCentralColumn)
end

function SubmenuCentralColumn:currentColumnType(t)
    if t == nil then
        return self._type
    else
        self._type = t
    end
end

function SubmenuCentralColumn:SetDataSlot(index)
    local curItem = self.Parent.LeftColumn.Items[self.Parent.LeftColumn:Index()]
    local _item = self.Items[index]
    if curItem.ItemType == LeftItemType.Info then
        local label = "SUBMN_CCOL_LBL"
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(self.position)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterBool(true)
        AddTextEntry(label, _item.label)
        BeginTextCommandScaleformString(label)
        EndTextCommandScaleformString_2()
        EndScaleformMovieMethod()
    elseif curItem.ItemType == LeftItemType.Statistics then
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(self.position)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(_item.Type)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterBool(true)
        PushScaleformMovieFunctionParameterString(_item.label)
        if _item.Type == StatItemType.Basic then
            PushScaleformMovieFunctionParameterString(_item._rightLabel)
        elseif _item.Type == StatItemType.ColoredBar then
            PushScaleformMovieMethodParameterInt(_item._value)
            PushScaleformMovieMethodParameterInt(_item._coloredBarColor:ToArgb())
        end
        EndScaleformMovieMethod()
    elseif curItem.ItemType == LeftItemType.Settings then
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(self.position)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(_item.ItemType)
        if _item.ItemType == SettingsItemType.ListItem then
            PushScaleformMovieFunctionParameterInt(_item._itemIndex)
        elseif _item.ItemType == SettingsItemType.SliderBar or _item.ItemType == SettingsItemType.MaskedProgressBar or _item.ItemType == SettingsItemType.ProgressBar then
            PushScaleformMovieFunctionParameterInt(_item._value)
        else
            PushScaleformMovieFunctionParameterInt(0)
        end
        PushScaleformMovieFunctionParameterBool(true)
        if (_item.ItemType == SettingsItemType.BlipType) then
            BeginTextCommandScaleformString("STRING")
            AddTextComponentScaleform(_item.label)
            EndTextCommandScaleformString_2()
        else
            PushScaleformMovieFunctionParameterString(_item.label)
        end
        if _item.ItemType == SettingsItemType.Basic then
            PushScaleformMovieFunctionParameterString(_item._rightLabel)
        elseif _item.ItemType == SettingsItemType.ListItem then
            PushScaleformMovieFunctionParameterString(Join(",", _item.ListItems))
        elseif _item.ItemType == SettingsItemType.CheckBox then
            PushScaleformMovieFunctionParameterInt(_item.CheckBoxStyle)
            PushScaleformMovieFunctionParameterBool(_item._isChecked)
        elseif _item.ItemType == SettingsItemType.MaskedProgressBar or _item.ItemType == SettingsItemType.ProgressBar or _item.ItemType == SettingsItemType.SliderBar then
            PushScaleformMovieMethodParameterInt(_item.MaxValue)
            PushScaleformMovieMethodParameterInt(_item._coloredBarColor:ToArgb())
        elseif _item.ItemType == SettingsItemType.BlipType then
            PushScaleformMovieFunctionParameterString(_item._rightLabel)
        end
        EndScaleformMovieMethod()
        self:SetColumnScroll(self.index, #self.Items, self.VisibleItems, "", #self.Items < self.VisibleItems)
    elseif curItem.ItemType == LeftItemType.Keymap then
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(self.position)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterBool(true)
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(_item.label)
        EndTextCommandScaleformString_2()
        BeginTextCommandScaleformString("STRING")
        if IsUsingKeyboard(2) then
            AddTextComponentScaleform(_item.PrimaryKeyboard)
        else
            AddTextComponentScaleform(_item.PrimaryGamepad)
        end
        EndTextCommandScaleformString_2()
        BeginTextCommandScaleformString("STRING")
        if IsUsingKeyboard(2) then
            AddTextComponentScaleform(_item.SecondaryKeyboard)
        else
            AddTextComponentScaleform(_item.SecondaryGamepad)
        end
        EndTextCommandScaleformString_2()
        EndScaleformMovieMethod()
    end
end

function SubmenuCentralColumn:UpdateSlot(index)
    local _item = self.Items[index]
    if self:currentColumnType() == LeftItemType.Info then
        local label = "SUBMN_CCOL_LBL"
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "UPDATE_SLOT")
        PushScaleformMovieFunctionParameterInt(self.position)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterBool(true)
        AddTextEntry(label, _item.label)
        BeginTextCommandScaleformString(label)
        EndTextCommandScaleformString_2()
        EndScaleformMovieMethod()
    elseif self:currentColumnType() == LeftItemType.Statistics then
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "UPDATE_SLOT")
        PushScaleformMovieFunctionParameterInt(self.position)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(_item.Type)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterBool(true)
        PushScaleformMovieFunctionParameterString(_item.label)
        if _item.Type == StatItemType.Basic then
            PushScaleformMovieFunctionParameterString(_item._rightLabel)
        elseif _item.Type == StatItemType.ColoredBar then
            PushScaleformMovieMethodParameterInt(_item._value)
            PushScaleformMovieMethodParameterInt(_item._coloredBarColor:ToArgb())
        end
        EndScaleformMovieMethod()
    elseif self:currentColumnType() == LeftItemType.Settings then
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "UPDATE_SLOT")
        PushScaleformMovieFunctionParameterInt(self.position)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(_item.ItemType)
        if _item.ItemType == SettingsItemType.ListItem then
            PushScaleformMovieFunctionParameterInt(_item.ItemIndex)
        elseif _item.ItemType == SettingsItemType.SliderBar or _item.ItemType == SettingsItemType.MaskedProgressBar or _item.ItemType == SettingsItemType.ProgressBar then
            PushScaleformMovieFunctionParameterInt(_item.Value)
        else
            PushScaleformMovieFunctionParameterInt(0)
        end
        PushScaleformMovieFunctionParameterBool(true)
        if (_item.ItemType == SettingsItemType.BlipType) then
            BeginTextCommandScaleformString("STRING")
            AddTextComponentScaleform(_item.label)
            EndTextCommandScaleformString_2()
        else
            PushScaleformMovieFunctionParameterString(_item.label)
        end
        if _item.ItemType == SettingsItemType.Basic then
            PushScaleformMovieFunctionParameterString(_item.RightLabel)
        elseif _item.ItemType == SettingsItemType.ListItem then
            PushScaleformMovieFunctionParameterString(Join(",", _item.ListItems))
        elseif _item.ItemType == SettingsItemType.CheckBox then
            PushScaleformMovieFunctionParameterInt(_item.CheckBoxStyle)
            PushScaleformMovieFunctionParameterBool(_item.IsChecked)
        elseif _item.ItemType == SettingsItemType.MaskedProgressBar or _item.ItemType == SettingsItemType.ProgressBar or  _item.ItemType == SettingsItemType.SliderBar then
            PushScaleformMovieMethodParameterInt(_item.MaxValue)
            PushScaleformMovieMethodParameterInt(_item.ColoredBarColor:ToArgb())
        elseif _item.ItemType == SettingsItemType.BlipType then
            PushScaleformMovieFunctionParameterString(_item.RightLabel)
        end
        EndScaleformMovieMethod()
        self:SetColumnScroll(self.index, #self.Items, self.VisibleItems, "", #self.Items < self.VisibleItems)
    elseif self:currentColumnType() == LeftItemType.Keymap then
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "UPDATE_SLOT")
        PushScaleformMovieFunctionParameterInt(self.position)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(index - 1)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterBool(true)
        BeginTextCommandScaleformString("STRING")
        AddTextComponentScaleform(_item.label)
        EndTextCommandScaleformString_2()
        BeginTextCommandScaleformString("STRING")
        if IsUsingKeyboard(2) then
            AddTextComponentScaleform(_item.PrimaryKeyboard)
        else
            AddTextComponentScaleform(_item.PrimaryGamepad)
        end
        EndTextCommandScaleformString_2()
        BeginTextCommandScaleformString("STRING")
        if IsUsingKeyboard(2) then
            AddTextComponentScaleform(_item.SecondaryKeyboard)
        else
            AddTextComponentScaleform(_item.SecondaryGamepad)
        end
        EndTextCommandScaleformString_2()
        EndScaleformMovieMethod()
    end
end

function SubmenuCentralColumn:GoUp()
    if self:currentColumnType() == LeftItemType.Settings then
        Citizen.CreateThread(function()
            self.Items[self.index]:Selected(false)
            repeat
                self.index = self.index - 1
                if self.index < 1 then
                    self.index = #self.Items
                end
                Wait(0)
            until self.Items[self.index].ItemType ~= SettingsItemType.Separator and self.Items[self.index].ItemType ~= SettingsItemType.Empty
            self.Items[self.index]:Selected(true)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position, self.index - 1,
                true, true)
            self:SetColumnScroll(self.index, #self.Items, self.VisibleItems, "", #self.Items < self.VisibleItems)
        end)
    end
end

function SubmenuCentralColumn:GoDown()
    if self:currentColumnType() == LeftItemType.Settings then
        Citizen.CreateThread(function()
            self.Items[self.index]:Selected(false)
            repeat
                self.index = self.index + 1
                if self.index > #self.Items then
                    self.index = 1
                end
                Wait(0)
            until self.Items[self.index].ItemType ~= SettingsItemType.Separator and self.Items[self.index].ItemType ~= SettingsItemType.Empty
            self.Items[self.index]:Selected(true)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position, self.index - 1,
                true, true)
            self:SetColumnScroll(self.index, #self.Items, self.VisibleItems, "", #self.Items < self.VisibleItems)
        end)
    end
end

function SubmenuCentralColumn:GoLeft()
    if self:currentColumnType() == LeftItemType.Settings then
        local item = self.Items[self.index]
        if item.ItemType == SettingsItemType.ListItem then
            item._itemIndex = item._itemIndex - 1
            item.OnListChanged(item, item:ItemIndex(), tostring(item.ListItems[item:ItemIndex()]))
        elseif item.ItemType == SettingsItemType.SliderBar or item.ItemType == SettingsItemType.ProgressBar or item.ItemType == SettingsItemType.MaskedProgressBar then
            item._value = item._value - 1
            item.OnBarChanged(item, item._value)
        end
    end
end

function SubmenuCentralColumn:GoRight()
    if self:currentColumnType() == LeftItemType.Settings then
        local item = self.Items[self.index]
        if item.ItemType == SettingsItemType.ListItem then
            item._itemIndex = item._itemIndex + 1
            item.OnListChanged(item, item:ItemIndex(), tostring(item.ListItems[item:ItemIndex()]))
        elseif item.ItemType == SettingsItemType.SliderBar or item.ItemType == SettingsItemType.ProgressBar or item.ItemType == SettingsItemType.MaskedProgressBar then
            item._value = item._value + 1
            item.OnBarChanged(item, item._value)
        end
    end
end

function SubmenuCentralColumn:Select()
    if self:currentColumnType() == LeftItemType.Settings then
        local item = self.Items[self.index]
        if not item:Enabled() then
            PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
            return
        end
        if item.ItemType == SettingsItemType.ListItem then
            item.OnListSelected(item, item:ItemIndex(), tostring(item.ListItems[item:ItemIndex()]))
        elseif item.ItemType == SettingsItemType.CheckBox then
            item:Checked(not item:Checked())
        elseif item.ItemType == SettingsItemType.SliderBar then
            item.OnSliderSelected(item, item._value)
        elseif item.ItemType == SettingsItemType.ProgressBar or item.ItemType == SettingsItemType.MaskedProgressBar then
            item.OnProgressSelected(item, item._value)
        end
        if item.ItemType ~= SettingsItemType.CheckBox then
            item.OnActivated()
        end
    end
end
