TabView = setmetatable({}, TabView)
TabView.__index = TabView
TabView.__call = function()
    return "PauseMenu"
end

function TabView.New(title, subtitle, sideTop, sideMid, sideBot)
    local _data = {
        Title = title or "",
        Subtitle = subtitle or "",
        SideTop = sideTop or "",
        SideMid = sideMid or "",
        SideBot = sideBot or "",
        _headerPicture = {},
        _crewPicture = {},
        Tabs = {},
        Index = 1,
        _visible = false,
        _internalpool = nil,
        focusLevel = 0,
        rightItemIndex = 1,
        leftItemIndex = 1,
        TemporarilyHidden = false,
        controller = false,
        _loaded = false,
        _timer = 0,
        _canHe = true,
        InstructionalButtons = {
            InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 176, 176, -1),
            InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 177, 177, -1),
            InstructionalButton.New(GetLabelText("HUD_INPUT1C"), -1, -1, -1, "INPUTGROUP_FRONTEND_BUMPERS")
        },
        OnPauseMenuOpen = function(menu)
        end,
        OnPauseMenuClose = function(menu)
        end,
        OnPauseMenuTabChanged = function(menu, tab, tabIndex)
        end,
        OnPauseMenuFocusChanged = function(menu, tab, focusLevel)
        end,
        OnLeftItemChange = function(menu, leftItem, index)
        end,
        OnRightItemChange = function(menu, rightItem, index)
        end,
        OnLeftItemSelect = function(menu, leftItem, index)
        end,
        OnRightItemSelect = function(menu, rightItem, index)
        end
    }
    return setmetatable(_data, TabView)
end

function TabView:LeftItemIndex(index)
    if index ~= nil then
        self.leftItemIndex = index
        self.OnLeftItemChange(self, self.Tabs[self.Index].LeftItemList[self.leftItemIndex], self.leftItemIndex)
    else
        return self.leftItemIndex
    end
end

function TabView:RightItemIndex(index)
    if index ~= nil then
        self.rightItemIndex = index
        self.OnRightItemChange(self, self.Tabs[self.Index].LeftItemList[self.leftItemIndex].ItemList[self.rightItemIndex], self.rightItemIndex)
    else
        return self.rightItemIndex
    end
end

function TabView:FocusLevel(index)
    if index ~= nil then
        self.focusLevel = index
        ScaleformUI.Scaleforms._pauseMenu:SetFocus(index)
        self.OnPauseMenuFocusChanged(self, self.Tabs[self.Index], index)
    else
        return self.focusLevel
    end
end

function TabView:Visible(visible)
    if visible ~= nil then
        ScaleformUI.Scaleforms.InstructionalButtons:Enabled(visible)
        self._visible = visible
        ScaleformUI.Scaleforms._pauseMenu:Visible(visible)
        if visible == true then
            self:BuildPauseMenu()
            self._internalpool:ProcessMenus(true)
            self.OnPauseMenuOpen(self)
            DontRenderInGameUi(true)
            AnimpostfxPlay("PauseMenuIn", 800, true)
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
            SetPlayerControl(PlayerId(), false, 0)
        else
            ScaleformUI.Scaleforms._pauseMenu:Dispose()
            DontRenderInGameUi(false)
            AnimpostfxStop("PauseMenuIn")
            AnimpostfxPlay("PauseMenuOut", 800, false)
            self.OnPauseMenuClose(self)
            SetPlayerControl(PlayerId(), true, 0)
            self._internalpool:ProcessMenus(false)
            self._internalpool:FlushPauseMenus()
        end
    else
        return self._visible
    end
end

function TabView:AddTab(item)
    item.Base.Parent = self
    table.insert(self.Tabs, item)
end

function TabView:HeaderPicture(Txd, Txn)
    if(Txd ~= nil and Txn ~= nil) then
        self._headerPicture = {txd = Txd, txn = Txn}
    else
        return self._headerPicture
    end
end
function TabView:CrewPicture(Txd, Txn)
    if(Txd ~= nil and Txn ~= nil) then
        self._crewPicture = {txd = Txd, txn = Txn}
    else
        return self._crewPicture
    end
end

function TabView:CanPlayerCloseMenu(canHe)
    if canHe == nil then
        return self._canHe
    else
        self._canHe = canHe
    end
end

function TabView:ShowHeader()
    if self.Subtitle:IsNullOrEmpty() then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderTitle(self.Title)
    else
        ScaleformUI.Scaleforms._pauseMenu:ShiftCoronaDescription(true, false)
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderTitle(self.Title, self.Subtitle)
    end
    if (self:HeaderPicture() ~= nil) then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderCharImg(self:HeaderPicture().txd, self:HeaderPicture().txn, true)
    end
    if (self:CrewPicture() ~= nil) then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderSecondaryImg(self:CrewPicture().txd, self:CrewPicture().txn, true)
    end
    ScaleformUI.Scaleforms._pauseMenu:SetHeaderDetails(self.SideTop, self.SideMid, self.SideBot)
    self._loaded = true
end

function TabView:BuildPauseMenu()
    self:ShowHeader()
    for k, tab in pairs(self.Tabs) do
        local tabIndex = k-1
        local type, subtype = tab()
        if subtype == "TextTab" then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(tab.Base.Title, tab.Base.Type, 0)
            if not tostring(tab.TextTitle):IsNullOrEmpty() then
                ScaleformUI.Scaleforms._pauseMenu:AddRightTitle(tabIndex, 0, tab.TextTitle)
            end
            for j,item in pairs(tab.LabelsList) do
                ScaleformUI.Scaleforms._pauseMenu:AddRightListLabel(tabIndex, 0, item.Label)
            end
        elseif subtype == "SubmenuTab" then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(tab.Base.Title, tab.Base.Type, 1)
            for j,item in pairs(tab.LeftItemList) do
                local itemIndex = j-1
                ScaleformUI.Scaleforms._pauseMenu:AddLeftItem(tabIndex, item.ItemType, item.Label, item.MainColor, item.HighlightColor, item:Enabled())

                if item.TextTitle ~= nil and not item.TextTitle:IsNullOrEmpty() then
                    if (item.ItemType == LeftItemType.Keymap) then
                        ScaleformUI.Scaleforms._pauseMenu:AddKeymapTitle(tabIndex , itemIndex, item.TextTitle, item.KeymapRightLabel_1, item.KeymapRightLabel_2)
                    else
                        ScaleformUI.Scaleforms._pauseMenu:AddRightTitle(tabIndex , itemIndex, item.TextTitle)
                    end
                end

                for l, ii in pairs(item.ItemList) do
                    local __type, __subtype = ii()
                    if __subtype == "StatsTabItem" then
                        if (ii.Type == StatItemType.Basic) then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightStatItemLabel(tabIndex , itemIndex, ii.Label, ii._rightLabel)
                        elseif (ii.Type == StatItemType.ColoredBar) then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightStatItemColorBar(tabIndex , itemIndex, ii.Label, ii._value, ii._coloredBarColor)
                        end
                    elseif __subtype == "SettingsItem" then
                        if ii.ItemType == SettingsItemType.Basic then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsBaseItem(tabIndex , itemIndex, ii.Label, ii._rightLabel, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.ListItem then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsListItem(tabIndex , itemIndex, ii.Label, ii.ListItems, ii._itemIndex, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.ProgressBar then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsProgressItem(tabIndex , itemIndex, ii.Label, ii.MaxValue, ii._coloredBarColor, ii._value, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.MaskedProgressBar then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsProgressItemAlt(tabIndex , itemIndex, ii.Label, ii.MaxValue, ii._coloredBarColor, ii._value, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.CheckBox then
                            while (not HasStreamedTextureDictLoaded("commonmenu")) do
                                Citizen.Wait(0)
                                RequestStreamedTextureDict("commonmenu", true)
                            end
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsCheckboxItem(tabIndex , itemIndex, ii.Label, ii.CheckBoxStyle, ii._isChecked, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.SliderBar then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsSliderItem(tabIndex , itemIndex, ii.Label, ii.MaxValue, ii._coloredBarColor, ii._value, ii:Enabled())
                        end
                    elseif __subtype == "KeymapItem" then
                        if IsInputDisabled(2) then
                            ScaleformUI.Scaleforms._pauseMenu:AddKeymapItem(tabIndex , itemIndex, ii.Label, ii.PrimaryKeyboard, ii.SecondaryKeyboard)
                        else
                            ScaleformUI.Scaleforms._pauseMenu:AddKeymapItem(tabIndex , itemIndex, ii.Label, ii.PrimaryGamepad, ii.SecondaryGamepad)
                        end
                        self:UpdateKeymapItems()
                    else
                        ScaleformUI.Scaleforms._pauseMenu:AddRightListLabel(tabIndex , itemIndex, ii.Label)
                    end
                end
            end
        end
    end
end

function TabView:UpdateKeymapItems()
    if not IsInputDisabled(2) then
        if not self.controller then
            self.controller = true
            for j, tab in pairs(self.Tabs) do
                local type, subtype = tab()
                if subtype == "SubmenuTab" then
                    for k, lItem in pairs(tab.LeftItemList) do
                        local idx = k-1
                        if lItem.ItemType == LeftItemType.Keymap then
                            for i = 1, #lItem.ItemList, 1 do
                                local item = lItem.ItemList[i]
                                ScaleformUI.Scaleforms._pauseMenu:UpdateKeymap(j-1, idx, i-1, item.PrimaryGamepad, item.SecondaryGamepad)
                            end
                        end
                    end
                end
            end
        end
    else
        if self.controller then
            self.controller = false
            for j, tab in pairs(self.Tabs) do
                local type, subtype = tab()
                if subtype == "SubmenuTab" then
                    for k, lItem in pairs(tab.LeftItemList) do
                        local idx = k-1
                        if lItem.ItemType == LeftItemType.Keymap then
                            for i = 1, #lItem.ItemList, 1 do
                                local item = lItem.ItemList[i]
                                ScaleformUI.Scaleforms._pauseMenu:UpdateKeymap(j-1, idx, i-1, item.PrimaryKeyboard, item.SecondaryKeyboard)
                            end
                        end
                    end
                end
            end
        end
    end
end

function TabView:Draw()
    if not self:Visible() or self.TemporarilyHidden then
        return 
    end
    ScaleformUI.Scaleforms._pauseMenu:Draw()
    self:UpdateKeymapItems()
end

function TabView:Select()
    if self:FocusLevel() == 0 then
        self:FocusLevel(self:FocusLevel() + 1)
        --[[ check if all disabled ]]
        local allDisabled = true
        for _,v in ipairs(self.Tabs[self.Index].LeftItemList) do
            if v:Enabled() then
                allDisabled = false
                break
            end
        end
        if allDisabled then return end
        --[[ end check all disabled ]]--
        while(not self.Tabs[self.Index].LeftItemList[self.leftItemIndex]:Enabled()) do
            Citizen.Wait(0)
            self.leftItemIndex = self.leftItemIndex + 1
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_LEFT_ITEM_INDEX", false, self.leftItemIndex-1)
        end
    elseif self:FocusLevel() == 1 then
        local tab = self.Tabs[self.Index]
        local cur_tab, cur_sub_tab = tab()
        if cur_sub_tab == "SubmenuTab" then
            local leftItem = tab.LeftItemList[self.leftItemIndex]
            if not leftItem:Enabled() then
                PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                return
            end
            if leftItem.ItemType == LeftItemType.Settings then
                self:FocusLevel(2)
                --[[ check if all disabled ]]
                local allDisabled = true
                for _,v in ipairs(self.Tabs[self.Index].LeftItemList) do
                    if v:Enabled() then
                        allDisabled = false
                        break
                    end
                end
                if allDisabled then return end
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                --[[ end check all disabled ]]--
                while(not self.Tabs[self.Index].LeftItemList[self.leftItemIndex]:Enabled()) do
                    Citizen.Wait(0)
                    self.rightItemIndex = self.rightItemIndex+1
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_RIGHT_ITEM_INDEX", false, self.rightItemIndex-1)
                end
            end
        end
    elseif self:FocusLevel() == 2 then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", false, 16)
        local leftItem = self.Tabs[self.Index].LeftItemList[self.leftItemIndex]
        if leftItem.ItemType == LeftItemType.Settings then
            local rightItem = leftItem.ItemList[self.rightItemIndex]
            if not rightItem:Enabled() then
                PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                return
            end
            --[[ to add real functions ]] -- 
            if rightItem.ItemType == SettingsItemType.ListItem then
                rightItem.OnListSelected(rightItem, rightItem:ItemIndex(), tostring(rightItem.ListItems[rightItem:ItemIndex()]))
            elseif rightItem.ItemType == SettingsItemType.CheckBox then
                rightItem:Checked(not rightItem:Checked())
            elseif rightItem.ItemType == SettingsItemType.MaskedProgressBar or rightItem.ItemType == SettingsItemType.ProgressBar then
                rightItem.OnProgressSelected(rightItem, rightItem:Value())
            elseif rightItem.ItemType == SettingsItemType.SliderBar then
                rightItem.OnSliderSelected(rightItem, rightItem:Value())
            else
                rightItem.OnActivated(rightItem, IndexOf(leftItem.ItemList, rightItem))
            end
            self.OnRightItemSelect(self, rightItem, self.rightItemIndex)
        end
    end
end

function TabView:GoBack()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    if self:FocusLevel() > 0 then
        self:FocusLevel(self:FocusLevel() - 1)
    else
        if self:CanPlayerCloseMenu() then
            self:Visible(false)
        end
    end
end

function TabView:GoUp()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", true, 8)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueInt(return_value)
    if retVal ~= -1 then
        if self:FocusLevel() == 1 then
            self:LeftItemIndex(retVal+1)
        elseif self:FocusLevel() == 2 then
            self:RightItemIndex(retVal+1)
        end
    end
end

function TabView:GoDown()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", true, 9)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueInt(return_value)
    if retVal ~= -1 then
        if self:FocusLevel() == 1 then
            self:LeftItemIndex(retVal+1)
        elseif self:FocusLevel() == 2 then
            self:RightItemIndex(retVal+1)
        end
    end
end

function TabView:GoLeft()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", true, 10)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueInt(return_value)

    if retVal ~= -1 then
        if self:FocusLevel() == 0 then
            ScaleformUI.Scaleforms._pauseMenu:HeaderGoLeft()
            self.Index = retVal+1
        elseif self:FocusLevel() == 2 then
            local rightItem = self.Tabs[self.Index].LeftItemList[self.leftItemIndex].ItemList[self.rightItemIndex]
            local sub_item, sub_item_type = rightItem()

            if sub_item_type == "SettingsItem" then
                if rightItem.ItemType == SettingsItemType.ListItem then
                    rightItem:ItemIndex(retVal)
                    rightItem.OnListChanged(rightItem, rightItem:ItemIndex(), tostring(rightItem.ListItems[rightItem:ItemIndex()]))
                elseif rightItem.ItemType == SettingsItemType.SliderBar then
                    rightItem:Value(retVal)
                    rightItem.OnBarChanged(rightItem, rightItem:Value())
                elseif rightItem.ItemType == SettingsItemType.ProgressBar or rightItem.ItemType == SettingsItemType.MaskedProgressBar then
                    rightItem:Value(retVal)
                    rightItem.OnBarChanged(rightItem, rightItem:Value())
                end
            end
        end
    end
end

function TabView:GoRight()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", true, 11)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueInt(return_value)

    if retVal ~= -1 then
        if self:FocusLevel() == 0 then
            ScaleformUI.Scaleforms._pauseMenu:HeaderGoLeft()
            self.Index = retVal+1
        elseif self:FocusLevel() == 2 then
            local rightItem = self.Tabs[self.Index].LeftItemList[self.leftItemIndex].ItemList[self.rightItemIndex]
            local sub_item, sub_item_type = rightItem()
            if sub_item_type == "SettingsItem" then
                if rightItem.ItemType == SettingsItemType.ListItem then
                    rightItem:ItemIndex(retVal)
                    rightItem.OnListChanged(rightItem, rightItem:ItemIndex(), tostring(rightItem.ListItems[rightItem:ItemIndex()]))
                elseif rightItem.ItemType == SettingsItemType.SliderBar then
                    rightItem:Value(retVal)
                    rightItem.OnBarChanged(rightItem, rightItem:Value())
                elseif rightItem.ItemType == SettingsItemType.ProgressBar or rightItem.ItemType == SettingsItemType.MaskedProgressBar then
                    rightItem:Value(retVal)
                    rightItem.OnBarChanged(rightItem, rightItem:Value())
                end
            end
        end
    end
end

local successHeader, event_type_h, context_h, item_id_h
local successPause, event_type, context, item_id

function TabView:ProcessMouse()
    if not IsUsingKeyboard(2) then
        return
    end
    SetMouseCursorActiveThisFrame()
    SetInputExclusive(2, 239)
    SetInputExclusive(2, 240)
    SetInputExclusive(2, 237)
    SetInputExclusive(2, 238)

    successHeader, event_type_h, context_h, item_id_h = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms._pauseMenu._header.handle)
    if successHeader then
        if event_type_h == 5 then
            if context_h == -1 then
                ScaleformUI.Scaleforms._pauseMenu:SelectTab(item_id_h)
                self:FocusLevel(1)
                self.Index = item_id_h + 1
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
        end
    end

    successPause, event_type, context, item_id = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms._pauseMenu._pause.handle)
    if successPause then
        if event_type == 5 then
            if context == 0 then
                self:FocusLevel(1)
                if #self.Tabs[self.Index].LeftItemList == 0 then return end
                if not self.Tabs[self.Index].LeftItemList[self.leftItemList] then return end
                while not self.Tabs[self.Index].LeftItemList[self.leftItemList]:Enabled() do
                    Citizen.Wait(0)
                    self.leftItemIndex = self.leftItemIndex+1
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_LEFT_ITEM_INDEX", false, self.leftItemIndex)
                end
            elseif context == 1 then
                if self:FocusLevel() ~= 1 then
                    if not self.Tabs[self.Index].LeftItemList[item_id+1]:Enabled() then
                        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                        return    
                    end
                    self.Tabs[self.Index].LeftItemList[self.leftItemIndex]:Selected(false)
                    self:LeftItemIndex(item_id+1)
                    self.Tabs[self.Index].LeftItemList[self.leftItemIndex]:Selected(true)
                    self:FocusLevel(1)
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                elseif self:FocusLevel() == 1 then
                    if not self.Tabs[self.Index].LeftItemList[item_id+1]:Enabled() then
                        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                        return    
                    end
                    if self.Tabs[self.Index].LeftItemList[self.leftItemIndex].ItemType == LeftItemType.Settings then
                        self:FocusLevel(2)
                        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_RIGHT_ITEM_INDEX", false, 0)
                        self:RightItemIndex(1)
                    end
                    self.Tabs[self.Index].LeftItemList[self.leftItemIndex]:Selected(false)
                    self:LeftItemIndex(item_id+1)
                    self.Tabs[self.Index].LeftItemList[self.leftItemIndex]:Selected(true)
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                end
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_LEFT_ITEM_INDEX", false, item_id)
                self.Tabs[self.Index].LeftItemList[self.leftItemIndex].OnActivated(self.Tabs[self.Index].LeftItemList[self.leftItemIndex], self.leftItemIndex)
                self.OnLeftItemSelect(self, self.Tabs[self.Index].LeftItemList[self.leftItemIndex], self.leftItemIndex)
            elseif context == 2 then
                local rightItem = self.Tabs[self.Index].LeftItemList[self.leftItemIndex].ItemList[item_id+1]
                if not rightItem:Enabled() then
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    return    
                end
                if self:FocusLevel() ~= 2 then
                    self:FocusLevel(2)
                end
                if rightItem:Selected() then
                    if rightItem.ItemType == SettingsItemType.ListItem then
                        rightItem.OnListSelected(rightItem, rightItem:ItemIndex(), tostring(rightItem.ListItems[rightItem:ItemIndex()]))
                    elseif rightItem.ItemType == SettingsItemType.CheckBox then
                        rightItem:Checked(not rightItem:Checked())
                    elseif rightItem.ItemType == SettingsItemType.MaskedProgressBar or rightItem.ItemType == SettingsItemType.ProgressBar then
                        rightItem.OnProgressSelected(rightItem, rightItem:Value())
                    elseif rightItem.ItemType == SettingsItemType.SliderBar then
                        rightItem.OnSliderSelected(rightItem, rightItem:Value())
                    else
                        rightItem.OnActivated(rightItem, IndexOf(self.Tabs[self.Index].LeftItemList[self.leftItemIndex].ItemList, rightItem))
                    end
                    self.OnRightItemSelect(self, rightItem, self.rightItemIndex)
                    return
                end
                self.Tabs[self.Index].LeftItemList[self.leftItemIndex].ItemList[self.rightItemIndex]:Selected(false)
                self:RightItemIndex(item_id+1)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_RIGHT_ITEM_INDEX", false, item_id)
                self.Tabs[self.Index].LeftItemList[self.leftItemIndex].ItemList[self.rightItemIndex]:Selected(true)
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
        elseif event_type == 9 then
            if context == 1 then
                for i, item in ipairs(self.Tabs[self.Index].LeftItemList) do
                    item:Hovered(item:Enabled() and i == item_id+1)
                end
            elseif context == 2 then
                for i, item in ipairs(self.Tabs[self.Index].LeftItemList[self.leftItemIndex].ItemList) do
                    item:Hovered(item:Enabled() and i == item_id+1)
                end
            end
        end
    end
end

function TabView:ProcessControl()
    if not self:Visible() or self.TemporarilyHidden then
        return 
    end
    EnableControlAction(2, 177, true)
    if (IsControlJustPressed(2, 172)) then
        Citizen.CreateThread(function()
            self:GoUp()
        end)
    end
    if (IsControlJustPressed(2, 173)) then
        Citizen.CreateThread(function()
            self:GoDown()
        end)
    end
    if (IsControlJustPressed(2, 174)) then
        Citizen.CreateThread(function()
            self:GoLeft()
        end)
    end
    if (IsControlJustPressed(2, 175)) then
        Citizen.CreateThread(function()
            self:GoRight()
        end)
    end
    if (IsControlJustPressed(2, 205)) then
        Citizen.CreateThread(function()
            if (self:FocusLevel() == 0) then
                self:GoLeft();
            end
        end)
    end
    if (IsControlJustPressed(2, 206)) then
        Citizen.CreateThread(function()
            if (self:FocusLevel() == 0) then
                self:GoRight();
            end
        end)
    end
    if (IsControlJustPressed(2, 201)) then
        Citizen.CreateThread(function()
            self:Select()
        end)
    end
    if (IsControlJustPressed(2, 177)) then
        Citizen.CreateThread(function()
            self:GoBack()
        end)
    end

    if (IsControlJustPressed(1, 241)) then
        Citizen.CreateThread(function()
            ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(-1)
        end)
    end
    if (IsControlJustPressed(1, 242)) then
        Citizen.CreateThread(function()
            ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(1)
        end)
    end


    if (IsControlPressed(2, 3) and not IsUsingKeyboard(2)) then
        if (GetGameTimer() - self._timer > 175) then
            Citizen.CreateThread(function()
                ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(-1)
            end)
            self._timer = GetGameTimer()
        end
    end
    if (IsControlPressed(2, 4) and not IsUsingKeyboard(2)) then
        if (GetGameTimer() - self._timer > 175) then
            Citizen.CreateThread(function()
                ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(1)
            end)
            self._timer = GetGameTimer()
        end
    end
end
