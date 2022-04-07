TabView = setmetatable({}, TabView)
TabView.__index = TabView
TabView.__call = function()
    return "PauseMenu"
end

function TabView.New(title, subtitle, sideTop, sideMid, sideBot)
    _data = {
        Title = title or "",
        Subtitle = subtitle or "",
        SideTop = sideTop or "",
        SideMid = sideMid or "",
        SideBot = sideBot or "",
        _headerPicture = {},
        _crewPicture = {},
        Tabs = {},
        Index = 0,
        _visible = false,
        focusLevel = 0,
        rightItemIndex = 0,
        leftItemIndex = 0,
        TemporarilyHidden = false,
        controller = false,
        _loaded = false,
        _timer = 0,
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
        OnPauseMenuFocusChanged = function(menu, tabIndex, focusLevel, leftItem)
        end,
        OnLeftItemChange = function(menu, tabIndex, focusLevel, leftItem)
        end,
        OnRightItemChange = function(menu, tabIndex, focusLevel, leftItem, rightItem)
        end
    }
    return setmetatable(_data, TabView)
end

function TabView:LeftItemIndex(index)
    if index ~= nil then
        self.leftItemIndex = index
        self.OnLeftItemChange(self, self.Index, self:FocusLevel(), index)
    else
        return self.leftItemIndex
    end
end

function TabView:RightItemIndex(index)
    if index ~= nil then
        self.rightItemIndex = index
        self.OnRightItemChange(self, self.Index, self:FocusLevel(), self:LeftItemIndex(), index)
    else
        return self.rightItemIndex
    end
end

function TabView:FocusLevel(index)
    if index ~= nil then
        self.focusLevel = index
        self.OnPauseMenuFocusChanged(self, self.Tabs[self.Index], index)
    else
        return self.focusLevel
    end
end

function TabView:Visible(visible)
    if(visible ~= nil) then
        if(visible == true)then
            self:BuildPauseMenu()
            self.OnPauseMenuOpen(self)
            AnimpostfxPlay("FocusOut", 800, false)
            TriggerScreenblurFadeIn(700)
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
            --SetPlayerControl(PlayerId(), false, 0)
        else
            ScaleformUI.Scaleforms._pauseMenu:Dispose()
            AnimpostfxPlay("FocusOut", 500, false)
            TriggerScreenblurFadeOut(400)
            self.OnPauseMenuClose(self)
            --SetPlayerControl(PlayerId(), true, 0)
        end
        ScaleformUI.Scaleforms.InstructionalButtons:Enabled(visible)
        self._visible = visible
        ScaleformUI.Scaleforms._pauseMenu:Visible(visible)
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
        if subtype == "TabTextItem" then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(tab.Base.Title, 0)
            if not tostring(tab.TextTitle):IsNullOrEmpty() then
                ScaleformUI.Scaleforms._pauseMenu:AddRightTitle(tabIndex, 0, tab.TextTitle)
            end
            for j,item in pairs(tab.LabelsList) do
                ScaleformUI.Scaleforms._pauseMenu:AddRightListLabel(tabIndex, 0, item.Label)
            end
        elseif subtype == "TabSubMenuItem" then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(tab.Base.Title, 1)
            for j,item in pairs(tab.LeftItemList) do
                local itemIndex = j-1
                ScaleformUI.Scaleforms._pauseMenu:AddLeftItem(tabIndex, item.ItemType, item.Label, item.MainColor, item.HighlightColor)

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
                    elseif __subtype == "SettingsTabItem" then
                        if ii.ItemType == SettingsItemType.Basic then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsBaseItem(tabIndex , itemIndex, ii.Label, ii._rightLabel)
                        elseif ii.ItemType == SettingsItemType.ListItem then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsListItem(tabIndex , itemIndex, ii.Label, ii.ListItems, ii._itemIndex)
                        elseif ii.ItemType == SettingsItemType.ProgressBar then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsProgressItem(tabIndex , itemIndex, ii.Label, ii.MaxValue, ii._coloredBarColor, ii._value)
                        elseif ii.ItemType == SettingsItemType.MaskedProgressBar then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsProgressItemAlt(tabIndex , itemIndex, ii.Label, ii.MaxValue, ii._coloredBarColor, ii._value)
                        elseif ii.ItemType == SettingsItemType.CheckBox then
                            while (not HasStreamedTextureDictLoaded("commonmenu")) do
                                Citizen.Wait(0)
                                RequestStreamedTextureDict("commonmenu", true)
                            end
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsCheckboxItem(tabIndex , itemIndex, ii.Label, ii.CheckBoxStyle, ii._isChecked)
                        elseif ii.ItemType == SettingsItemType.SliderBar then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsSliderItem(tabIndex , itemIndex, ii.Label, ii.MaxValue, ii._coloredBarColor, ii._value)
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
                if subtype == "TabSubMenuItem" then
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
                if subtype == "TabSubMenuItem" then
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

function TabView:ProcessControl()
    if not self:Visible() or self.TemporarilyHidden then
        return 
    end
    local result = ""
    if (IsControlJustPressed(2, 172)) then
        if (self:FocusLevel() == 0) then return end
        result = ScaleformUI.Scaleforms._pauseMenu:SendInputEvent(8)

    end
    if (IsControlJustPressed(2, 173)) then
        if (self:FocusLevel() == 0) then return end
        result = ScaleformUI.Scaleforms._pauseMenu:SendInputEvent(9)

    end
    if (IsControlJustPressed(2, 174)) then
        if (self:FocusLevel() == 1) then return end
        if (self:FocusLevel() == 0) then
            ScaleformUI.Scaleforms._pauseMenu:HeaderGoLeft()
        end
        result = ScaleformUI.Scaleforms._pauseMenu:SendInputEvent(10)

    end
    if (IsControlJustPressed(2, 175)) then
        if (self:FocusLevel() == 1) then return end
        if (self:FocusLevel() == 0) then
            ScaleformUI.Scaleforms._pauseMenu:HeaderGoRight()
        end
        result = ScaleformUI.Scaleforms._pauseMenu:SendInputEvent(11)

    end
    if (IsControlJustPressed(2, 205)) then
        if (self:FocusLevel() == 0) then
            ScaleformUI.Scaleforms._pauseMenu:HeaderGoLeft()
        end
        result = ScaleformUI.Scaleforms._pauseMenu:SendInputEvent(10)

    end
    if (IsControlJustPressed(2, 206)) then
        if (self:FocusLevel() == 0) then
                ScaleformUI.Scaleforms._pauseMenu:HeaderGoRight()
        end
        result = ScaleformUI.Scaleforms._pauseMenu:SendInputEvent(11)

    end
    if (IsControlJustPressed(2, 201)) then
        result = ScaleformUI.Scaleforms._pauseMenu:SendInputEvent(16)
        if self:FocusLevel() == 1 then
            if (self.Tabs[self.Index].LeftItemList[self:LeftItemIndex()].ItemType == LeftItemType.Info or self.Tabs[self.Index].LeftItemList[self:LeftItemIndex()].ItemType == LeftItemType.Empty) then
                self.Tabs[self.Index].LeftItemList[self:LeftItemIndex()].OnActivated(self.Tabs[self.Index].LeftItemList[self:LeftItemIndex()], self:LeftItemIndex())
            end
        elseif self:FocusLevel() == 2 then
            local aa, subt = self.Tabs[self.Index].LeftItemList[self:LeftItemIndex()].ItemList[self:RightItemIndex()]()
            if subt == "SettingsTabItem" then
                if(self.Tabs[self.Index].LeftItemList[self:LeftItemIndex()].ItemList[self:RightItemIndex()].ItemType == SettingsItemType.Basic) then
                    self.Tabs[self.Index].LeftItemList[self:LeftItemIndex()].ItemList[self:RightItemIndex()].OnActivated(self.Tabs[self.Index].LeftItemList[self:LeftItemIndex()].ItemList[self:RightItemIndex()], self:RightItemIndex())
                end
            end
        end
    end
    if (IsControlJustPressed(2, 177)) then
        if self:FocusLevel() > 0 then
            result = ScaleformUI.Scaleforms._pauseMenu:SendInputEvent(17)
        else
            self:Visible(false)
        end
    end

    if (IsControlJustPressed(1, 241)) then
        result = ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(-1)
    end
    if (IsControlJustPressed(1, 242)) then
        result = ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(1)
    end


    if (IsControlPressed(2, 3)) then
        if (GetGameTimer() - self._timer > 250) then
                result = ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(-1)
            self._timer = GetGameTimer()
        end

    end
    if (IsControlPressed(2, 4)) then
        if (GetGameTimer() - self._timer > 250) then
                result = ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(1)
            self._timer = GetGameTimer()
        end
    end

    if (IsControlJustPressed(0, 24) and IsInputDisabled(2)) then
        if (GetGameTimer() - self._timer > 250) then
                result = ScaleformUI.Scaleforms._pauseMenu:SendClickEvent()
            self._timer = GetGameTimer()
        end
    end

    if not result:IsNullOrEmpty() and result:find(",") then
        local split = split(result, ',')
        local curTab = tonumber(split[1])+1
        local focusLevel = tonumber(split[2])
        local leftItemIndex = -1
        local rightPanelIndex = -1
        local retVal = -1
        local retBool = false
        if (#split > 2)then
            if #split == 3 then
                if(split[3] ~= "undefined") then
                    leftItemIndex = tonumber(split[3]) + 1
                else
                    leftItemIndex = -1
                end
            elseif #split == 5 then
                leftItemIndex = tonumber(split[3]) + 1
                rightPanelIndex = tonumber(split[4]) + 1
                if (split[5] == "true" or split[5] == "false") then
                    retBool = tobool(split[5])
                else
                    retVal = tonumber(split[5])
                end
            end
        end

        self.Index = curTab
        self:FocusLevel(focusLevel)

        if (focusLevel == 0) then
            for k,v in pairs(self.Tabs) do
                v.Focused = k == self.Index
            end
            self.OnPauseMenuTabChanged(self, self.Tabs[self.Index], self.Index)
        end

        if (focusLevel == 1) then
            local tab = self.Tabs[self.Index]
            local it, subit = tab()
            if (subit ~= "TabTextItem") then
                tab.Index = leftItemIndex
                self:LeftItemIndex(leftItemIndex)
                for l, m in pairs(tab.LeftItemList) do
                    m.Highlighted = l == leftItemIndex
                end
            end
        end            

        if (focusLevel == 2) then
            local leftItem = self.Tabs[self.Index].LeftItemList[leftItemIndex]
            if leftItem ~= nil then
                if leftItem.ItemType == LeftItemType.Settings then
                    leftItem.ItemIndex = rightPanelIndex
                    self:RightItemIndex(leftItem.ItemIndex)
                    for h, it in pairs(leftItem.ItemList) do
                        it.Highlighted = h == rightPanelIndex
                        if it.Highlighted then
                            if it.ItemType == SettingsItemType.ListItem then
                                it:ItemIndex(retVal)
                            elseif it.ItemType == SettingsItemType.SliderBar or it.ItemType == SettingsItemType.ProgressBar or it.ItemType == SettingsItemType.MaskedProgressBar then
                                it:Value(retVal)
                            elseif it.ItemType == SettingsItemType.CheckBox then
                                it:Checked(retBool)
                            end
                        end
                    end
                end
            end
        end
        -- DEBUG
        --print("Scaleform [tabIndex, focusLevel, currentTabLeftItemIndex, currentRightPanelItemIndex, retVal] = " .. result)
        --print("LUA [tabIndex, focusLevel, currentTabLeftItemIndex, currentRightPanelItemIndex, retVal] = " ..self.Index..", " ..self:FocusLevel()..", " ..self:LeftItemIndex()..", " ..self:RightItemIndex())
    end
end