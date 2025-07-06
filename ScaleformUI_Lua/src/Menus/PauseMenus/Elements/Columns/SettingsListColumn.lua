SettingsListColumn = {}
SettingsListColumn.__index = SettingsListColumn
setmetatable(SettingsListColumn, { __index = PM_Column })
SettingsListColumn.__call = function() return "SettingsListColumn" end


---@class SettingsListColumn
---@field private _label string
---@field private _color SColor
---@field private _isBuilding boolean
---@field private _currentSelection number
---@field private _unfilteredItems table
---@field private _rightLabel string
---@field public Parent function
---@field public ParentTab number
---@field public Items table<number, UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem>
---@field public OnIndexChanged fun(index: number)
---@field public AddSettings fun(self: SettingsListColumn, item: SettingsListItem)

function SettingsListColumn.New(label, _maxItems)
    local base = PM_Column.New(-1)
    base.Label = label
    base.type = PLT_COLUMNS.SETTINGS
    base.VisibleItems = _maxItems
    base._unfilteredItems = {} --[[@type table<number, UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem>]]
    base._unfilteredSelection = 1
    base.OnIndexChanged = function(index)
    end
    base.OnSettingItemActivated = function(index)
    end
    return setmetatable(base, SettingsListColumn)
end

function SettingsListColumn:SetVisibleItems(maxItems)
    self.VisibleItems = maxItems
    if self:visible() then
        self:Populate()
        self:ShowColumn()
    end
end

function SettingsListColumn:AddItem(item)
    self:AddSettings(item)
end

---Add a new item to the column.
---@param item UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem
function SettingsListColumn:AddSettings(item)
    if item:MainColor() == SColor.HUD_Panel_light then
        item:MainColor(SColor.HUD_Pause_bg)
    end
    item.ParentColumn = self
    table.insert(self.Items, item)
    if self:visible() and #self.Items < self.VisibleItems then
        local idx = #self.Items
        self:AddSlot(idx)
        self.Items[idx]:Selected(idx == self.index)
    end
end

function SettingsListColumn:ShowColumn()
    if not self:visible() then return end
    PM_Column.ShowColumn(self)
    self:InitColumnScroll(#self.Items >= self.VisibleItems, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT)
    self:SetColumnScroll(self.index, #self.Items, self.VisibleItems, "", #self.Items < self.VisibleItems)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_FOCUS", self.position, self.Focused, false, false)
    if #self.Items > 0 and self:CurrentItem().ItemId == 6 and self:CurrentItem().Jumpable then
        self:CurrentItem():Selected(false)
        self.index = self.index + 1
        if self.index > #self.Items then
            self.index = 1
        end
        self:CurrentItem():Selected(true)
    end
end

function SettingsListColumn:Populate()
    if not self:visible() then return end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT_EMPTY", self.position)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_MAX_ITEMS", self.position, self.VisibleItems)
    for i=1, #self.Items, 1 do
        self:SetDataSlot(i)
    end
end

function SettingsListColumn:CurrentSelection(value)
    if value == nil then
        return self.index
    else
        self:CurrentItem():Selected(false)
        self.index = value
        if self.index < 1 then
            self.index = #self.Items
        elseif self.index > #self.Items then
            self.index = 1
        end
        self:CurrentItem():Selected(true)
        if self:visible() and self.Focused then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position, self.index - 1, true, true)
        end
        self.OnIndexChanged(self.index)
    end
end


function SettingsListColumn:SetDataSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index)
    end
end
function SettingsListColumn:UpdateSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index, true)
    end
end
function SettingsListColumn:AddSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index, false, false, true)
    end
end

function SettingsListColumn:AddItemAt(item, index)
    table.insert(self.Items, index, item)
    if not self:visible() then return end
    self:AddSlot(index)
    item:Selected(idx == self.index)
end

function SettingsListColumn:SendItemToScaleform(i, update, newItem, isSlot)
    if i > #self.Items then return end
    local item = self.Items[i]
    local str = "SET_DATA_SLOT"
    if update then str = "UPDATE_SLOT" end
    if newItem then str = "SET_DATA_SLOT_SPLICE" end
    if isSlot then str = "ADD_SLOT" end

    BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, str)
    PushScaleformMovieFunctionParameterInt(self.position)
    PushScaleformMovieFunctionParameterInt(i - 1)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(item.ItemId)

    if item.ItemId == 1 then
        local rlabel = "SCUI_SETTCOL_RLBL"
        AddTextEntry(rlabel, item:CurrentListItem())
        BeginTextCommandScaleformString(rlabel)
        EndTextCommandScaleformString_2()
    elseif item.ItemId == 2 then
        PushScaleformMovieFunctionParameterBool(item:Checked())
    elseif item.ItemId == 3 or item.ItemId == 4 or item.ItemId == 5 then
        PushScaleformMovieFunctionParameterInt(item:Index())
    else
        PushScaleformMovieFunctionParameterInt(0)
    end
    PushScaleformMovieFunctionParameterBool(item:Enabled())
    local label = "SCUI_SETTCOL_LBL"
    AddTextEntry(label, item:Label())
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString_2()
    PushScaleformMovieFunctionParameterBool(item:BlinkDescription())
    if item.ItemId == 1 then -- dynamic list item are handled like list items in the scaleform.. so the type remains 1
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
        PushScaleformMovieMethodParameterString(item._rightLabelFont.FontName)
    elseif item.ItemId == 2 then
        PushScaleformMovieFunctionParameterInt(item.CheckBoxStyle)
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    elseif item.ItemId == 3 then
        PushScaleformMovieFunctionParameterInt(item._Max)
        PushScaleformMovieFunctionParameterInt(item._Multiplier)
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:SliderColor():ToArgb())
        PushScaleformMovieFunctionParameterBool(item._heritage)
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    elseif item.ItemId == 4 then
        PushScaleformMovieFunctionParameterInt(item._Max)
        PushScaleformMovieFunctionParameterInt(item._Multiplier)
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:SliderColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    elseif item.ItemId == 5 then
        PushScaleformMovieFunctionParameterInt(item._Type)
        PushScaleformMovieFunctionParameterInt(item:SliderColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    elseif item.ItemId == 6 then
        PushScaleformMovieFunctionParameterBool(item.Jumpable)
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
    else
        PushScaleformMovieFunctionParameterInt(item:MainColor():ToArgb())
        PushScaleformMovieFunctionParameterInt(item:HighlightColor():ToArgb())
        BeginTextCommandScaleformString("CELL_EMAIL_BCON")
        AddTextComponentScaleform(item:RightLabel())
        EndTextCommandScaleformString_2()
        PushScaleformMovieFunctionParameterInt(item._leftBadge)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customLeftIcon.TXN)
        PushScaleformMovieFunctionParameterInt(item._rightBadge)
        PushScaleformMovieMethodParameterString(item.customRightIcon.TXD)
        PushScaleformMovieMethodParameterString(item.customRightIcon.TXN)
        PushScaleformMovieMethodParameterString(item.LabelFont.FontName)
        PushScaleformMovieMethodParameterString(item._rightLabelFont.FontName)
    end
    PushScaleformMovieMethodParameterBool(item:KeepTextColorWhite())
    EndScaleformMovieMethod()
end

---Removes an item from the column.
---@param item UIMenuItem 
function SettingsListColumn:RemoveSetting(item)
    if item == nil then
        print("^1[ERROR] SettingsListColumn:RemoveSetting() - item is nil")
        return
    end
    for k,v in pairs(self.Items) do
        if v:Label () == item:Label() then
            self:RemoveSlot(k)
        end
    end
end

function SettingsListColumn:RemoveItemAt(index)
    if index >#self.Items or index < 1 then return end
    self:RemoveSlot(index)
end

function SettingsListColumn:RemoveSlot(idx)
    PM_Column.RemoveSlot(self, idx)
    AddTextEntry("PAUSEMENU_Current_Description", self:CurrentItem():Description());
end


---Refreshes the menu description
function SettingsListColumn:UpdateDescription()
    local pSubT = self.Parent()
    AddTextEntry("PAUSEMENU_Current_Description", self:CurrentItem():Description())
    self:SendItemToScaleform(self:Index(), true)
    -- legacy and definitely wrong to use it..
end

function SettingsListColumn:GoUp()
    self:CurrentItem().selected = false
    repeat
        Citizen.Wait(0)
        self.index = self.index - 1
        if self.index < 1 then
            self.index = #self.Items
        end
    until self:CurrentItem().ItemId ~= 6 or (self:CurrentItem().ItemId == 6 and not self:CurrentItem().Jumpable)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.position, 8)
    AddTextEntry("PAUSEMENU_Current_Description", self:CurrentItem():Description());
    self:CurrentItem().selected = true
    self.OnIndexChanged(self:CurrentSelection())
end

function SettingsListColumn:GoDown()
    self:CurrentItem().selected = false
    repeat
        Citizen.Wait(0)
        self.index = self.index + 1
        if self.index > #self.Items then
            self.index = 1
        end
    until self:CurrentItem().ItemId ~= 6 or (self:CurrentItem().ItemId == 6 and not self:CurrentItem().Jumpable)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.position, 9)
    AddTextEntry("PAUSEMENU_Current_Description", self:CurrentItem():Description());
    self:CurrentItem().selected = true
    self.OnIndexChanged(self:CurrentSelection())
end

function SettingsListColumn:GoLeft()
    if not self:visible() then return end
    if not self:CurrentItem():Enabled() then
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        return
    end

    if self:CurrentItem().ItemId == 1 then
        self:CurrentItem():Index(self:CurrentItem():Index() - 1)
        self:CurrentItem().OnListChanged(nil, self:CurrentItem(), self:CurrentItem():Index())
    elseif self:CurrentItem().ItemId == 3 then
        self:CurrentItem():Index(self:CurrentItem():Index() - 1)
    elseif self:CurrentItem().ItemId == 4 then
        self:CurrentItem():Index(self:CurrentItem():Index() - 1)
    elseif self:CurrentItem().ItemId == 5 then
        self:CurrentItem():Index(self:CurrentItem():Index() - 1)
    end
    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
end
function SettingsListColumn:GoRight()
    if not self:visible() then return end
    if not self:CurrentItem():Enabled() then
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        return
    end
    if self:CurrentItem().ItemId == 1 then
        self:CurrentItem():Index(self:CurrentItem():Index() + 1)
        self:CurrentItem().OnListChanged(nil, self:CurrentItem(), self:CurrentItem():Index())
    elseif self:CurrentItem().ItemId == 3 then
        self:CurrentItem():Index(self:CurrentItem():Index() + 1)
    elseif self:CurrentItem().ItemId == 4 then
        self:CurrentItem():Index(self:CurrentItem():Index() + 1)
    elseif self:CurrentItem().ItemId == 5 then
        self:CurrentItem():Index(self:CurrentItem():Index() + 1)
    end
    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
end

function SettingsListColumn:Select()
    if not self:visible() then return end
    if not self:CurrentItem():Enabled() then
        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        return
    end
    if self:CurrentItem().ItemId == 1 then
        self:CurrentItem().OnListSelected(nil, self:CurrentItem(), self:CurrentItem():Index())
        self.OnSettingItemActivated(self:Index())
    elseif self:CurrentItem().ItemId == 2 then
        self:CurrentItem():Checked(not self:CurrentItem():Checked())
        self:CurrentItem().OnCheckboxChanged(nil, self:CurrentItem(), self:CurrentItem():Checked())
    else
        self.OnSettingItemActivated(self:Index())
        if self:CurrentItem().Activated ~= nil then
            self:CurrentItem().Activated(nil, self:CurrentItem())
        end
    end
end

function SettingsListColumn:MouseScroll(dir)
    self:CurrentItem().selected = false
    repeat
        Citizen.Wait(0)
        self.index = self.index + dir
        if self.index < 1 then
            self.index = #self.Items
        elseif self.index > #self.Items then
            self.index = 1
        end
    until self:CurrentItem().ItemId ~= 6 or (self:CurrentItem().ItemId == 6 and not self:CurrentItem().Jumpable)
    AddTextEntry("PAUSEMENU_Current_Description", self:CurrentItem():Description());
    self:CurrentItem().selected = true
    self.OnIndexChanged(self:CurrentSelection())
end

function SettingsListColumn:UpdateItemLabels(index, leftLabel, rightLabel)
    if not self:visible() or index > #self.Items then return end
    local item = self.Items[index]
    item:Label(leftLabel)
    item:RightLabel(rightLabel)
end

function SettingsListColumn:UpdateItemBlinkDescription(index, blink)
    if not self:visible() or index > #self.Items then return end
    if blink == 1 then blink = true elseif blink == 0 then blink = false end
    local item = self.Items[index]
    item:BlinkDescription(blink)
end

function SettingsListColumn:UpdateItemLabel(index, label)
    if not self:visible() or index > #self.Items then return end
    local item = self.Items[index]
    item:Label(label)
end

function SettingsListColumn:UpdateItemRightLabel(index, label)
    if not self:visible() or index > #self.Items then return end
    local item = self.Items[index]
    item:RightLabel(label)
end

function SettingsListColumn:UpdateItemLeftBadge(index, badge)
    if not self:visible() or index > #self.Items then return end
    local item = self.Items[index]
    item:LeftBadge(badge)
end

function SettingsListColumn:UpdateItemRightBadge(index, badge)
    if not self:visible() or index > #self.Items then return end
    local item = self.Items[index]
    item:RightBadge(badge)
end

function SettingsListColumn:EnableItem(index, enable)
    if not self:visible() or index > #self.Items then return end
    local item = self.Items[index]
    item:Enabled(enable)
end

function SettingsListColumn:Clear()
    self:ClearColumn()
end

function SettingsListColumn:ClearColumn()
    PM_Column.ClearColumn(self)
    AddTextEntry("PAUSEMENU_Current_Description", "")
end

function SettingsListColumn:SortSettings(compare)
    if not self:visible() then return end
    self:CurrentItem():Selected(false)
    if self._unfilteredItems == nil or #self._unfilteredItems == 0 then
        for i, item in ipairs(self.Items) do
            table.insert(self._unfilteredItems, item)
        end
    end
    self._unfilteredSelection = self:Index()
    self:Clear()
    local list = self._unfilteredItems
    table.sort(list, compare)
    self.Items = list
    if self:visible() then
        self:Populate()
        self:ShowColumn()
    end
end

function SettingsListColumn:FilterSettings(predicate)
    self:CurrentItem():Selected(false)
    if self._unfilteredItems == nil or #self._unfilteredItems == 0 then
        for i, item in ipairs(self.Items) do
            table.insert(self._unfilteredItems, item)
        end
    end
    self._unfilteredSelection = self:Index()
    self:Clear()
    local filteredItems = {}
    for i, item in ipairs(self._unfilteredItems) do
        if predicate(item) then
            table.insert(filteredItems, item)
        end
    end
    self.Items = filteredItems
    if self:visible() then
        self:Populate()
        self:ShowColumn()
    end
end

function SettingsListColumn:ResetFilter()
    if self._unfilteredItems ~= nil and #self._unfilteredItems > 0 then
        self:CurrentItem():Selected(false)
        self:Clear()
        self.Items = self._unfilteredItems
        self:Index(self._unfilteredSelection)
        self._unfilteredItems = {}
        self._unfilteredSelection = 1
        if self:visible() then
            self:Populate()
            self:ShowColumn()
        end
    end
end