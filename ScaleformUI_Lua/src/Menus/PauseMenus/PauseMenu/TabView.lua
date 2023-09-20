TabView = setmetatable({}, TabView)
TabView.__index = TabView
TabView.__call = function()
    return "PauseMenu"
end
TabView.SoundId = GetSoundId()

---@class TabView

---comment
---@param title string
---@param subtitle string
---@param sideTop string
---@param sideMiddle string
---@param sideBottom string
function TabView.New(title, subtitle, sideTop, sideMiddle, sideBottom)
    local _data = {
        Title = title or "",
        Subtitle = subtitle or "",
        SideTop = sideTop or "",
        SideMid = sideMiddle or "",
        SideBot = sideBottom or "",
        _headerPicture = {},
        _crewPicture = {},
        Tabs = {},
        index = 1,
        ParentPool = nil,
        _visible = false,
        _isBuilding = false,
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
        self.Tabs[self.index].LeftItemList[self.leftItemIndex]:Selected(false)
        self.leftItemIndex = index
        self.Tabs[self.index].LeftItemList[self.leftItemIndex]:Selected(true)
        self.OnLeftItemChange(self, self.Tabs[self.index].LeftItemList[self.leftItemIndex], self.leftItemIndex)
    else
        return self.leftItemIndex
    end
end

function TabView:RightItemIndex(index)
    if index ~= nil then
        self.rightItemIndex = index
        self.OnRightItemChange(self, self.Tabs[self.index].LeftItemList[self.leftItemIndex].ItemList
            [self.rightItemIndex], self.rightItemIndex)
    else
        return self.rightItemIndex
    end
end

function TabView:FocusLevel(index)
    if index ~= nil then
        self.focusLevel = index
        ScaleformUI.Scaleforms._pauseMenu:SetFocus(index)
        self.OnPauseMenuFocusChanged(self, self.Tabs[self.index], index)
    else
        return self.focusLevel
    end
end

function TabView:Index(idx)
    if idx ~= nil then
        self.Tabs[self.index].Visible = false
        self.index = idx
        self.Tabs[self.index].Visible = true
        self.OnPauseMenuTabChanged(self, self.Tabs[self.index], self.index)
    else
        return self.index
    end
end

function TabView:Visible(visible)
    if visible ~= nil then
        self._visible = visible
        ScaleformUI.Scaleforms._pauseMenu:Visible(visible)
        if visible == true then
            if not IsPauseMenuActive() then
                PlaySoundFrontend(self.SoundId, "Hit_In", "PLAYER_SWITCH_CUSTOM_SOUNDSET", true)
                ActivateFrontendMenu(`FE_MENU_VERSION_EMPTY_NO_BACKGROUND`, true, -1)
                self:BuildPauseMenu()
                MenuHandler._currentPauseMenu = self
                MenuHandler.ableToDraw = true;
                self.OnPauseMenuOpen(self)
                AnimpostfxPlay("PauseMenuIn", 800, true)
                ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
                SetPlayerControl(PlayerId(), false, 0)
            end
        else
            MenuHandler.ableToDraw = false
            MenuHandler._currentPauseMenu = nil
            ScaleformUI.Scaleforms._pauseMenu:Dispose()
            ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList()
            AnimpostfxStop("PauseMenuIn")
            AnimpostfxPlay("PauseMenuOut", 800, false)
            self.OnPauseMenuClose(self)
            SetPlayerControl(PlayerId(), true, 0)
            if IsPauseMenuActive() then
                PlaySoundFrontend(self.SoundId, "Hit_Out", "PLAYER_SWITCH_CUSTOM_SOUNDSET", true)
                ActivateFrontendMenu(`FE_MENU_VERSION_EMPTY_NO_BACKGROUND`, true, -1)
            end
            SetFrontendActive(false)
        end
    else
        return self._visible
    end
end

function TabView:AddTab(item)
    item.Base.Parent = self
    self.Tabs[#self.Tabs + 1] = item
end

function TabView:HeaderPicture(Txd, Txn)
    if (Txd ~= nil and Txn ~= nil) then
        self._headerPicture = { txd = Txd, txn = Txn }
    else
        return self._headerPicture
    end
end

function TabView:CrewPicture(Txd, Txn)
    if (Txd ~= nil and Txn ~= nil) then
        self._crewPicture = { txd = Txd, txn = Txn }
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
    self._isBuilding = true
    self:ShowHeader()
    for k, tab in pairs(self.Tabs) do
        local tabIndex = k - 1
        local type, subtype = tab()
        if subtype == "TextTab" then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(tab.Base.Title, 1, tab.Base.Type, tab.Base._color)
            if not tostring(tab.TextTitle):IsNullOrEmpty() then
                ScaleformUI.Scaleforms._pauseMenu:AddRightTitle(tabIndex, 0, tab.TextTitle)
            end
            for j, item in pairs(tab.LabelsList) do
                ScaleformUI.Scaleforms._pauseMenu:AddRightListLabel(tabIndex, 0, item.Label, item.LabelFont.FontName, item.LabelFont.FontID)
            end
            if not (tab.TextureDict:IsNullOrEmpty() and tab.TextureName:IsNullOrEmpty()) then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_BASE_TAB_BACKGROUND", false, tabIndex, tab.TextureDict, tab.TextureName)
            end
        elseif subtype == "SubmenuTab" then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(tab.Base.Title, 1, tab.Base.Type, tab.Base._color)
            for j, item in pairs(tab.LeftItemList) do
                local itemIndex = j - 1
                ScaleformUI.Scaleforms._pauseMenu:AddLeftItem(tabIndex, item.ItemType, item._formatLeftLabel, item.MainColor,
                    item.HighlightColor, item:Enabled())
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_LEFT_ITEM_LABEL_FONT", false, tabIndex, itemIndex, item._labelFont.FontName, item._labelFont.FontID)

                if item.RightTitle ~= nil and not item.RightTitle:IsNullOrEmpty() then
                    if (item.ItemType == LeftItemType.Keymap) then
                        ScaleformUI.Scaleforms._pauseMenu:AddKeymapTitle(tabIndex, itemIndex, item.RightTitle,
                            item.KeymapRightLabel_1, item.KeymapRightLabel_2)
                    else
                        ScaleformUI.Scaleforms._pauseMenu:AddRightTitle(tabIndex, itemIndex, item.RightTitle)
                    end
                end

                for l, ii in pairs(item.ItemList) do
                    local __type, __subtype = ii()
                    if __subtype == "StatsTabItem" then
                        if (ii.Type == StatItemType.Basic) then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightStatItemLabel(tabIndex, itemIndex, ii.Label,
                                ii._rightLabel, ii.LabelFont, ii.RightLabelFont)
                        elseif (ii.Type == StatItemType.ColoredBar) then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightStatItemColorBar(tabIndex, itemIndex, ii.Label,
                                ii._value, ii._coloredBarColor, ii.LabelFont)
                        end
                    elseif __subtype == "SettingsItem" then
                        if ii.ItemType == SettingsItemType.Basic then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsBaseItem(tabIndex, itemIndex, ii.Label,
                                ii._rightLabel, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.ListItem then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsListItem(tabIndex, itemIndex, ii.Label,
                                ii.ListItems, ii._itemIndex, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.ProgressBar then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsProgressItem(tabIndex, itemIndex, ii.Label,
                                ii.MaxValue, ii._coloredBarColor, ii._value, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.MaskedProgressBar then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsProgressItemAlt(tabIndex, itemIndex,
                                ii.Label, ii.MaxValue, ii._coloredBarColor, ii._value, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.CheckBox then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsCheckboxItem(tabIndex, itemIndex, ii.Label,
                                ii.CheckBoxStyle, ii._isChecked, ii:Enabled())
                        elseif ii.ItemType == SettingsItemType.SliderBar then
                            ScaleformUI.Scaleforms._pauseMenu:AddRightSettingsSliderItem(tabIndex, itemIndex, ii.Label,
                                ii.MaxValue, ii._coloredBarColor, ii._value, ii:Enabled())
                        end
                    elseif __subtype == "KeymapItem" then
                        if IsUsingKeyboard(2) then
                            ScaleformUI.Scaleforms._pauseMenu:AddKeymapItem(tabIndex, itemIndex, ii.Label,
                                ii.PrimaryKeyboard, ii.SecondaryKeyboard)
                        else
                            ScaleformUI.Scaleforms._pauseMenu:AddKeymapItem(tabIndex, itemIndex, ii.Label,
                                ii.PrimaryGamepad, ii.SecondaryGamepad)
                        end
                        self:UpdateKeymapItems()
                    else
                        ScaleformUI.Scaleforms._pauseMenu:AddRightListLabel(tabIndex, itemIndex, ii.Label, ii.LabelFont.FontName, ii.LabelFont.FontID)
                    end
                end
                if item.ItemType == LeftItemType.Info or item.ItemType == LeftItemType.Statistics or item.ItemType == LeftItemType.Settings then
                    if not (item.TextureDict:IsNullOrEmpty() and item.TextureName:IsNullOrEmpty()) then
                        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_LEFT_ITEM_RIGHT_BACKGROUND", false, tabIndex, itemIndex, item.TextureDict, item.TextureName, item.LeftItemBGType);
                    end
                end
            end
        elseif subtype == "PlayerListTab" then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(tab.Base.Title, 1, tab.Base.Type, tab.Base._color)
            local count = #tab.listCol
            if count == 1 then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CREATE_PLAYERS_TAB_COLUMNS", false, tabIndex, tab.listCol[1].Type)
            elseif count == 2 then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CREATE_PLAYERS_TAB_COLUMNS", false, tabIndex, tab.listCol[1].Type, tab.listCol[2].Type)
            elseif count == 3 then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CREATE_PLAYERS_TAB_COLUMNS", false, tabIndex, tab.listCol[1].Type, tab.listCol[2].Type, tab.listCol[3].Type)
            end
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_NEWSTYLE", false, tabIndex, tab._newStyle)
            for i,col in pairs(tab.listCol) do
                col.Parent = self
                col.ParentTab = tabIndex
                if col.Type == "settings" then
                    self:buildSettings(tab, tabIndex)
                elseif col.Type == "players" then
                    self:buildPlayers(tab, tabIndex)
                elseif col.Type == "missions" then
                    self:buildMissions(tab, tabIndex)
                elseif col.Type == "panel" then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_MISSION_PANEL_PICTURE", false, tabIndex, tab.MissionPanel.TextureDict, tab.MissionPanel.TextureName)
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSION_PANEL_TITLE", false, tabIndex, tab.MissionPanel:Title())
                    if #tab.MissionPanel.Items > 0 then
                        for j,item in pairs(tab.MissionPanel.Items) do
                            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_MISSION_PANEL_ITEM", false, tabIndex, item.Type, item.TextLeft,
                            item.TextRight, item.Icon or 0, item.IconColor or 0, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID)
                        end
                    end
                end
            end
            while tab.SettingsColumn ~= nil and tab.SettingsColumn._isBuilding or tab.PlayerColumn ~= nil and tab.PlayerColumn._isBuilding or tab.MissionsColumn ~= nil and tab.MissionsColumn._isBuilding do
                Citizen.Wait(0)
            end
            tab:updateFocus(1)
        end
    end
    self._isBuilding = false
end

function TabView:buildSettings(tab, tabIndex)
    Citizen.CreateThread(function()
        tab.SettingsColumn._isBuilding = true
        local i = 1
        local max = tab.SettingsColumn.Pagination:ItemsPerPage()
        if #tab.SettingsColumn.Items < max then
            max = #tab.SettingsColumn.Items
        end
        tab.SettingsColumn.Pagination:MinItem(tab.SettingsColumn.Pagination:CurrentPageStartIndex())

        if tab.SettingsColumn.scrollingType == MenuScrollingType.CLASSIC and tab.SettingsColumn.Pagination:TotalPages() > 1 then
            local missingItems = tab.SettingsColumn.Pagination:GetMissingItems()
            if missingItems > 0 then
                tab.SettingsColumn.Pagination:ScaleformIndex(tab.SettingsColumn.Pagination:GetPageIndexFromMenuIndex(tab.SettingsColumn.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                tab.SettingsColumn.Pagination.minItem = tab.SettingsColumn.Pagination:CurrentPageStartIndex() - missingItems
            end
        end

        tab.SettingsColumn.Pagination:MaxItem(tab.SettingsColumn.Pagination:CurrentPageEndIndex())

        while i <= max do
            Citizen.Wait(0)
            if not self:Visible() then return end
            tab.SettingsColumn:_itemCreation(tab.SettingsColumn.Pagination:CurrentPage(), i, false, true)
            i = i + 1
        end

        tab.SettingsColumn:CurrentSelection(1)
        tab.SettingsColumn.Pagination:ScaleformIndex(tab.SettingsColumn.Pagination:GetScaleformIndex(tab.SettingsColumn:CurrentSelection()))
        tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]:Selected(false)

        ScaleformUI.Scaleforms._ui:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", false, tab.SettingsColumn.Pagination:GetScaleformIndex(tab.SettingsColumn.Pagination:CurrentMenuIndex()))
        ScaleformUI.Scaleforms._ui:CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", false, tab.SettingsColumn:CurrentSelection(), #tab.SettingsColumn.Items)

        local Item = tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]
        local _, subtype = Item()
        if subtype == "UIMenuSeparatorItem" then
            if (tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()].Jumpable) then
                tab.SettingsColumn:GoDown()
            end
        end

        tab.SettingsColumn._isBuilding = false
    end)
end

function TabView:buildPlayers(tab, tabIndex)
    Citizen.CreateThread(function()
        tab.PlayersColumn._isBuilding = true
        local i = 1
        local max = tab.PlayersColumn.Pagination:ItemsPerPage()
        if #tab.PlayersColumn.Items < max then
            max = #tab.PlayersColumn.Items
        end
        tab.PlayersColumn.Pagination:MinItem(tab.PlayersColumn.Pagination:CurrentPageStartIndex())

        if tab.PlayersColumn.scrollingType == MenuScrollingType.CLASSIC and tab.PlayersColumn.Pagination:TotalPages() > 1 then
            local missingItems = tab.PlayersColumn.Pagination:GetMissingItems()
            if missingItems > 0 then
                tab.PlayersColumn.Pagination:ScaleformIndex(tab.PlayersColumn.Pagination:GetPageIndexFromMenuIndex(tab.PlayersColumn.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                tab.PlayersColumn.Pagination.minItem = tab.PlayersColumn.Pagination:CurrentPageStartIndex() - missingItems
            end
        end

        tab.PlayersColumn.Pagination:MaxItem(tab.PlayersColumn.Pagination:CurrentPageEndIndex())

        while i <= max do
            Citizen.Wait(0)
            if not self:Visible() then return end
            tab.PlayersColumn:_itemCreation(tab.PlayersColumn.Pagination:CurrentPage(), i, false, true)
            i = i + 1
        end

        tab.PlayersColumn:CurrentSelection(1)
        tab.PlayersColumn.Pagination:ScaleformIndex(tab.PlayersColumn.Pagination:GetScaleformIndex(tab.PlayersColumn:CurrentSelection()))
        tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:Selected(false)

        ScaleformUI.Scaleforms._ui:CallFunction("SET_PLAYERS_TAB_PLAYERS_SELECTION", false, tab.PlayersColumn.Pagination:GetScaleformIndex(tab.PlayersColumn.Pagination:CurrentMenuIndex()))
        ScaleformUI.Scaleforms._ui:CallFunction("SET_PLAYERS_TAB_PLAYERS_QTTY", false, tab.PlayersColumn:CurrentSelection(), #tab.PlayersColumn.Items)

        tab.PlayersColumn._isBuilding = false
    end)
end

function TabView:buildMissions(tab, tabIndex)
    Citizen.CreateThread(function()
        tab.MissionsColumn._isBuilding = true
        local i = 1
        local max = tab.MissionsColumn.Pagination:ItemsPerPage()
        if #tab.MissionsColumn.Items < max then
            max = #tab.MissionsColumn.Items
        end
        tab.MissionsColumn.Pagination:MinItem(tab.MissionsColumn.Pagination:CurrentPageStartIndex())

        if tab.MissionsColumn.scrollingType == MenuScrollingType.CLASSIC and tab.MissionsColumn.Pagination:TotalPages() > 1 then
            local missingItems = tab.MissionsColumn.Pagination:GetMissingItems()
            if missingItems > 0 then
                tab.MissionsColumn.Pagination:ScaleformIndex(tab.MissionsColumn.Pagination:GetPageIndexFromMenuIndex(tab.MissionsColumn.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                tab.MissionsColumn.Pagination.minItem = tab.MissionsColumn.Pagination:CurrentPageStartIndex() - missingItems
            end
        end

        tab.MissionsColumn.Pagination:MaxItem(tab.MissionsColumn.Pagination:CurrentPageEndIndex())

        while i <= max do
            Citizen.Wait(0)
            if not self:Visible() then return end
            tab.MissionsColumn:_itemCreation(tab.MissionsColumn.Pagination:CurrentPage(), i, false, true)
            i = i + 1
        end

        tab.MissionsColumn:CurrentSelection(1)
        tab.MissionsColumn.Pagination:ScaleformIndex(tab.MissionsColumn.Pagination:GetScaleformIndex(tab.MissionsColumn:CurrentSelection()))
        tab.MissionsColumn.Items[tab.MissionsColumn:CurrentSelection()]:Selected(false)

        ScaleformUI.Scaleforms._ui:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", false, tab.MissionsColumn.Pagination:GetScaleformIndex(tab.MissionsColumn.Pagination:CurrentMenuIndex()))
        ScaleformUI.Scaleforms._ui:CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", false, tab.MissionsColumn:CurrentSelection(), #tab.MissionsColumn.Items)

        tab.MissionsColumn._isBuilding = false
    end)
end

function TabView:UpdateKeymapItems()
    if not IsUsingKeyboard(2) then
        if not self.controller then
            self.controller = true
            for j, tab in pairs(self.Tabs) do
                local type, subtype = tab()
                if subtype == "SubmenuTab" then
                    for k, lItem in pairs(tab.LeftItemList) do
                        local idx = k - 1
                        if lItem.ItemType == LeftItemType.Keymap then
                            for i = 1, #lItem.ItemList, 1 do
                                local item = lItem.ItemList[i]
                                ScaleformUI.Scaleforms._pauseMenu:UpdateKeymap(j - 1, idx, i - 1, item.PrimaryGamepad,
                                    item.SecondaryGamepad)
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
                        local idx = k - 1
                        if lItem.ItemType == LeftItemType.Keymap then
                            for i = 1, #lItem.ItemList, 1 do
                                local item = lItem.ItemList[i]
                                ScaleformUI.Scaleforms._pauseMenu:UpdateKeymap(j - 1, idx, i - 1, item.PrimaryKeyboard,
                                    item.SecondaryKeyboard)
                            end
                        end
                    end
                end
            end
        end
    end
end

function TabView:Draw()
    if not self:Visible() or self.TemporarilyHidden or self._isBuilding then
        return
    end
    DisableControlAction(0, 199, true)
    DisableControlAction(0, 200, true)
    DisableControlAction(1, 199, true)
    DisableControlAction(1, 200, true)
    DisableControlAction(2, 199, true)
    DisableControlAction(2, 200, true)
    ScaleformUI.Scaleforms._pauseMenu:Draw()
    self:UpdateKeymapItems()
end

function TabView:Select()
    if self:FocusLevel() == 0 then
        self:FocusLevel(self:FocusLevel() + 1)
        local tab = self.Tabs[self.index]
        local cur_tab, cur_sub_tab = tab()
        if cur_sub_tab == "PlayerListTab" then
            local selection = tab:Focus()
            if tab._newStyle then
                selection = 1
            end
            if tab.listCol[selection].Type == "settings" then
                tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]:Selected(true)
            elseif tab.listCol[selection].Type == "players" then
                local it = tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]
                it:Selected(true)
                if it:KeepPanelVisible() then
                    it:AddPedToPauseMenu()
                end
            elseif tab.listCol[selection].Type == "missions" then
                tab.MissionsColumn.Items[tab.MissionsColumn:CurrentSelection()]:Selected(true)
            end
            for k,v in pairs(tab.listCol) do
                if v.Type == "players" then
                    SetPauseMenuPedLighting(self:FocusLevel() ~= 0)
                end
            end
        elseif cut_sub_tab == "SubmenuTab" then
            self.Tabs[self.index].LeftItemList[self.leftItemIndex]:Selected(true)
        end
        --[[ check if all disabled ]]
        local allDisabled = true
        for _, v in ipairs(self.Tabs[self.index].LeftItemList) do
            if v:Enabled() then
                allDisabled = false
                break
            end
        end
        if allDisabled then return end
        --[[ end check all disabled ]]
        --
        while (not self.Tabs[self.index].LeftItemList[self.leftItemIndex]:Enabled()) do
            Citizen.Wait(0)
            self:LeftItemIndex(self.leftItemIndex + 1)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_LEFT_ITEM_INDEX", false, self.leftItemIndex - 1)
        end
    elseif self:FocusLevel() == 1 then
        local tab = self.Tabs[self.index]
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
                for _, v in ipairs(self.Tabs[self.index].LeftItemList) do
                    if v:Enabled() then
                        allDisabled = false
                        break
                    end
                end
                if allDisabled then return end
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                --[[ end check all disabled ]]
                --
                while (not self.Tabs[self.index].LeftItemList[self.leftItemIndex]:Enabled()) do
                    Citizen.Wait(0)
                    self.rightItemIndex = self.rightItemIndex + 1
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_RIGHT_ITEM_INDEX", false,
                        self.rightItemIndex - 1)
                end
            end
        elseif cur_sub_tab == "PlayerListTab" then
            if tab.listCol[tab:Focus()].Type == "settings" then
                local _item = tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]
                if not _item:Enabled() then
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    return
                end
                local _, subtype = _item()
                if subtype == "UIMenuCheckboxItem" then
                    _item:Checked(not _item:Checked())
                    _item.OnCheckboxChanged(self, _item, _item:Checked())
                elseif subtype == "UIMenuListItem" then
                    _item.OnListSelected(self, _item, _item._Index)
                elseif subtype == "UIMenuDynamicListItem" then
                    _item.OnListSelected(self, _item, _item._currentItem)
                elseif subtype == "UIMenuSliderItem" then
                    _item.OnSliderSelected(self, _item, _item._Index)
                elseif subtype == "UIMenuProgressItem" then
                    _item.OnProgressSelected(self, _item, _item._Index)
                elseif subtype == "UIMenuStatsItem" then
                    _item.OnStatsSelected(self, _item, _item._Index)
                else
                    _item:Activated(self, _item)
                end
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", false, 16)
            elseif tab.listCol[tab:Focus()].Type == "missions" then
                tab.MissionsColumn.Items[tab.MissionsColumn:CurrentSelection()].Activated(tab.MissionsColumn.Items[tab.MissionsColumn:CurrentSelection()])
            end
        end
    elseif self:FocusLevel() == 2 then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", false, 16)
        local leftItem = self.Tabs[self.index].LeftItemList[self.leftItemIndex]
        if leftItem.ItemType == LeftItemType.Settings then
            local rightItem = leftItem.ItemList[self.rightItemIndex]
            if not rightItem:Enabled() then
                PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                return
            end
            --[[ to add real functions ]]
            --
            if rightItem.ItemType == SettingsItemType.ListItem then
                rightItem.OnListSelected(rightItem, rightItem:ItemIndex(),
                    tostring(rightItem.ListItems[rightItem:ItemIndex()]))
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
    if self:FocusLevel() > 0 then
        local tab = self.Tabs[self.index]
        local _, subT = tab()
        if subT ~= "PlayerListTab" then
            self:FocusLevel(self:FocusLevel() - 1)
            tab.LeftItemList[self.leftItemIndex]:Selected(self:FocusLevel() == 1)
        elseif subT == "PlayerListTab" then
            if tab._newStyle then
                self:FocusLevel(self:FocusLevel() - 1)
                SetPauseMenuPedLighting(self:FocusLevel() ~= 0)
                tab.listCol[tab:Focus()].Items[tab.listCol[tab:Focus()]:CurrentSelection()]:Selected(false)
            else
                if self:FocusLevel() == 1 then
                    tab.listCol[tab:Focus()].Items[tab.listCol[tab:Focus()]:CurrentSelection()]:Selected(false)
                    if tab:Focus() == 1 then
                        self:FocusLevel(self:FocusLevel() - 1)
                        return
                    end
                    tab:updateFocus(tab:Focus() - 1)
                end
            end
        end
    else
        if self:CanPlayerCloseMenu() then
            self:Visible(false)
        end
    end
end

function TabView:GoUp()
    local tab = self.Tabs[self.index]
    local _, subT = tab()
    if subT == "PlayerListTab" then
        if tab.listCol[tab:Focus()].Type == "players" then
            tab.PlayersColumn:GoUp()
        elseif tab.listCol[tab:Focus()].Type == "settings" then
            tab.SettingsColumn:GoUp()
        elseif tab.listCol[tab:Focus()].Type == "missions" then
            tab.MissionsColumn:GoUp()
        end
        return
    end
    
    local return_value = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", true, 8) --[[@as number]]
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueInt(return_value)
    if retVal ~= -1 then
        if self:FocusLevel() == 1 then
            self:LeftItemIndex(retVal + 1)
        elseif self:FocusLevel() == 2 then
            self:RightItemIndex(retVal + 1)
        end
    end
end

function TabView:GoDown()
    local tab = self.Tabs[self.index]
    local _, subT = tab()
    if subT == "PlayerListTab" then
        if tab.listCol[tab:Focus()].Type == "players" then
            tab.PlayersColumn:GoDown()
        elseif tab.listCol[tab:Focus()].Type == "settings" then
            tab.SettingsColumn:GoDown()
        elseif tab.listCol[tab:Focus()].Type == "missions" then
            tab.MissionsColumn:GoDown()
        end
        return
    end
    local return_value = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", true, 9) --[[@as number]]
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueInt(return_value)
    if retVal ~= -1 then
        if self:FocusLevel() == 1 then
            self:LeftItemIndex(retVal + 1)
        elseif self:FocusLevel() == 2 then
            self:RightItemIndex(retVal + 1)
        end
    end
end

function TabView:GoLeft()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", true, 10) --[[@as number]]
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueInt(return_value)

    if self:FocusLevel() == 0 then
        ClearPedInPauseMenu()
        ScaleformUI.Scaleforms._pauseMenu:HeaderGoLeft()
        local tab = self.Tabs[self.index]
        local _, subT = tab()
        if subT == "SubmenuTab" then
            tab.LeftItemList[self.leftItemIndex]:Selected(self:FocusLevel() == 1)
        end
        self:Index(retVal + 1)
        tab = self.Tabs[self.index]
        _, subT = tab()
        if subT == "PlayerListTab" then
            for k,v in pairs(tab.listCol) do
                if v.Type == "settings" then
                    tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]:Selected(false)
                elseif v.Type == "missions" then
                    tab.MissionsColumn.Items[tab.MissionsColumn:CurrentSelection()]:Selected(false)
                elseif v.Type == "players" then
                    tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:Selected(false)
                    if k == 1 or tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:KeepPanelVisible() then
                        if tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
                            tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
                        else
                            ClearPedInPauseMenu()
                        end
                    else
                        ClearPedInPauseMenu()
                    end
                else
                    ClearPedInPauseMenu()
                end
            end
        end
        self.OnPauseMenuTabChanged(self, tab, self.index)
    elseif self:FocusLevel() == 1 then
        local tab = self.Tabs[self.index]
        local _, subT = tab()
        if subT == "PlayerListTab" then
            if tab.listCol[tab:Focus()].Type == "settings" then
                local Item = tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]
                if not Item:Enabled() then
                    if tab._newStyle then
                        Item:Selected(false)
                        tab:updateFocus(tab:Focus() - 1)
                    else
                        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    end
                    return
                end
                local type, subtype = Item()
                if subtype == "UIMenuListItem" then
                    Item:Index(retVal)
                    Item.OnListChanged(self, Item, Item._Index)
                elseif subtype == "UIMenuSliderItem" then
                    Item:Index(retVal)
                    Item.OnSliderChanged(self, Item, Item._Index)
                elseif subtype == "UIMenuProgressItem" then
                    Item:Index(retVal)
                    Item.OnProgressChanged(self, Item, Item:Index())
                elseif subtype == "UIMenuStatsItem" then
                    Item:Index(retVal)
                    Item.OnStatsChanged(self, Item, Item._Index)
                else
                    print(tab._newStyle)
                    if tab._newStyle then
                        tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]:Selected(false)
                        tab:updateFocus(tab:Focus() - 1)
                    end
                end
            elseif tab.listCol[tab:Focus()].Type == "missions" then
                if tab._newStyle then
                    tab.MissionsColumn.Items[tab.MissionsColumn:CurrentSelection()]:Selected(false)
                    tab:updateFocus(tab:Focus() - 1)
                end
            elseif tab.listCol[tab:Focus()].Type == "panel" then
                if tab._newStyle then
                    tab:updateFocus(tab:Focus() - 1)
                end
            elseif tab.listCol[tab:Focus()].Type == "players" then
                if tab._newStyle then
                    tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:Selected(false)
                    tab:updateFocus(tab:Focus() - 1)
                else
                    if tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
                        tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
                    end
                end
            end
        end
    elseif self:FocusLevel() == 2 then
        local rightItem = self.Tabs[self.index].LeftItemList[self.leftItemIndex].ItemList[self.rightItemIndex]
        local sub_item, sub_item_type = rightItem()

        if sub_item_type == "SettingsItem" then
            if rightItem.ItemType == SettingsItemType.ListItem then
                rightItem:ItemIndex(retVal)
                rightItem.OnListChanged(rightItem, rightItem:ItemIndex(),
                    tostring(rightItem.ListItems[rightItem:ItemIndex()]))
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

function TabView:GoRight()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", true, 11) --[[@as number]]
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueInt(return_value)

    if self:FocusLevel() == 0 then
        ClearPedInPauseMenu()
        ScaleformUI.Scaleforms._pauseMenu:HeaderGoRight()
        local tab = self.Tabs[self.index]
        local _, subT = tab()
        if subT == "SubmenuTab" then
            tab.LeftItemList[self.leftItemIndex]:Selected(self:FocusLevel() == 1)
        end
        self:Index(retVal + 1)
        tab = self.Tabs[self.index]
        _, subT = tab()
        if subT == "PlayerListTab" then
            for k,v in pairs(tab.listCol) do
                if v.Type == "settings" then
                    tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]:Selected(false)
                elseif v.Type == "missions" then
                    tab.MissionsColumn.Items[tab.MissionsColumn:CurrentSelection()]:Selected(false)
                elseif v.Type == "players" then
                    tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:Selected(false)
                    if k == 1 or tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:KeepPanelVisible() then
                        if tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
                            tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
                        else
                            ClearPedInPauseMenu()
                        end
                    else
                        ClearPedInPauseMenu()
                    end
                else
                    ClearPedInPauseMenu()
                end
            end
        end
        self.OnPauseMenuTabChanged(self, tab, self.index)
    elseif self:FocusLevel() == 1 then
        local tab = self.Tabs[self.index]
        local _, subT = tab()
        if subT == "PlayerListTab" then
            if tab.listCol[tab:Focus()].Type == "settings" then
                local Item = tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]
                if not Item:Enabled() then
                    if tab._newStyle then
                        Item:Selected(false)
                        tab:updateFocus(tab:Focus() + 1)
                    else
                        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    end
                    return
                end
                local type, subtype = Item()
                if subtype == "UIMenuListItem" then
                    Item:Index(retVal)
                    Item.OnListChanged(self, Item, Item._Index)
                elseif subtype == "UIMenuSliderItem" then
                    Item:Index(retVal)
                    Item.OnSliderChanged(self, Item, Item._Index)
                elseif subtype == "UIMenuProgressItem" then
                    Item:Index(retVal)
                    Item.OnProgressChanged(self, Item, Item:Index())
                elseif subtype == "UIMenuStatsItem" then
                    Item:Index(retVal)
                    Item.OnStatsChanged(self, Item, Item._Index)
                else
                    if tab._newStyle then
                        tab.SettingsColumn.Items[tab.SettingsColumn:CurrentSelection()]:Selected(false)
                        tab:updateFocus(tab:Focus() + 1)
                    end
                end
            elseif tab.listCol[tab:Focus()].Type == "missions" then
                if tab._newStyle then
                    tab.MissionsColumn.Items[tab.MissionsColumn:CurrentSelection()]:Selected(false)
                    tab:updateFocus(tab:Focus() + 1)
                end
            elseif tab.listCol[tab:Focus()].Type == "panel" then
                if tab._newStyle then
                    tab:updateFocus(tab:Focus() + 1)
                end
            elseif tab.listCol[tab:Focus()].Type == "players" then
                if tab._newStyle then
                    tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:Selected(false)
                    tab:updateFocus(tab:Focus() + 1)
                else
                    if tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
                        tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
                    end
                end
            end
        end
    elseif self:FocusLevel() == 2 then
        local rightItem = self.Tabs[self.index].LeftItemList[self.leftItemIndex].ItemList[self.rightItemIndex]
        local sub_item, sub_item_type = rightItem()
        if sub_item_type == "SettingsItem" then
            if rightItem.ItemType == SettingsItemType.ListItem then
                rightItem:ItemIndex(retVal)
                rightItem.OnListChanged(rightItem, rightItem:ItemIndex(),
                    tostring(rightItem.ListItems[rightItem:ItemIndex()]))
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

function TabView:ProcessMouse()
    if not IsUsingKeyboard(2) then
        return
    end
    SetMouseCursorActiveThisFrame()
    SetInputExclusive(2, 239)
    SetInputExclusive(2, 240)
    SetInputExclusive(2, 237)
    SetInputExclusive(2, 238)

    Citizen.CreateThread(function()
        local successHeader, event_type_h, context_h, item_id_h
        local successPause, event_type, context, item_id

        successHeader, event_type_h, context_h, item_id_h = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms._pauseMenu._header.handle)
        if successHeader then
            if event_type_h == 5 then
                if context_h == -1 then
                    ScaleformUI.Scaleforms._pauseMenu:SelectTab(item_id_h)
                    self:FocusLevel(1)
                    self:Index(item_id_h + 1)
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    local tab = self.Tabs[self.index]
                    local _, subT = tab()
                    if subT == "PlayerListTab" then
                        tab:updateFocus(tab._focus)
                        if tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()].ClonePed ~= nil and tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
                            tab.PlayersColumn.Items[tab.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
                        else
                            ClearPedInPauseMenu()
                        end
                    else
                        ClearPedInPauseMenu()
                    end
                    local allDisabled = true
                    for k,v in pairs(tab.LeftItemList) do
                        if v:Enabled() then allDisabled = false break end
                    end
                    if not allDisabled then
                        while not tab.LeftItemList[self.leftItemIndex]:Enabled() do
                            Citizen.Wait(0)
                            self:LeftItemIndex(self:LeftItemIndex() + 1)
                            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_LEFT_ITEM_INDEX", false, self.leftItemIndex-1)
                        end
                    end
                end
            end
        end

        successPause, event_type, context, item_id = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms._pauseMenu._pause.handle)
        if successPause then
            local tab = self.Tabs[self.index]
            local _, subT = tab()
            if event_type == 5 then
                if self:FocusLevel() == 1 and subT == "PlayerListTab" then
                    local foc = tab:Focus()
                    local curSel = 1
                    if tab._newStyle then
                        curSel = tab.listCol[foc]:CurrentSelection()
                    end
                    if context+1 ~= foc then
                        tab.listCol[foc].Items[tab.listCol[foc]:CurrentSelection()]:Selected(false)
                        tab:updateFocus(context+1, true)
                        tab.listCol[context+1]:CurrentSelection(tab.listCol[context+1].Pagination:GetMenuIndexFromScaleformIndex(item_id-1))
                        tab.listCol[context+1].OnIndexChanged(tab.listCol[context+1]:CurrentSelection())
                        if curSel ~= tab.listCol[context+1]:CurrentSelection() then
                            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                        end
                    else
                        tab.listCol[foc]:CurrentSelection(tab.listCol[context+1].Pagination:GetMenuIndexFromScaleformIndex(item_id-1))
                    end
                    if foc == tab:Focus() and curSel == tab.listCol[context+1]:CurrentSelection() then
                        self:Select()
                    end
                    return
                end
                if context == 0 then
                    self:FocusLevel(1)
                    if subT ~= "PlayerListTab" then
                        if #tab.LeftItemList == 0 then return end
                        if not tab.LeftItemList[self.leftItemList] then return end
                        local allDisabled = true
                        for k,v in pairs(tab.LeftItemList) do
                            if v:Enabled() then allDisabled = false break end
                        end
                        if not allDisabled then
                            while not tab.LeftItemList[self.leftItemList]:Enabled() do
                                Citizen.Wait(0)
                                self:LeftItemIndex(self.leftItemIndex + 1)
                                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_LEFT_ITEM_INDEX", false, self.leftItemIndex-1)
                            end
                        end
                    end
                elseif context == 1 then
                        if self:FocusLevel() ~= 1 then
                            if not tab.LeftItemList[item_id + 1]:Enabled() then
                                PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                                return
                            end
                            tab.LeftItemList[self.leftItemIndex]:Selected(false)
                            self:LeftItemIndex(item_id + 1)
                            tab.LeftItemList[self.leftItemIndex]:Selected(true)
                            self:FocusLevel(1)
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                        elseif self:FocusLevel() == 1 then
                            if not tab.LeftItemList[item_id + 1]:Enabled() then
                                PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                                return
                            end
                            if tab.LeftItemList[self.leftItemIndex].ItemType == LeftItemType.Settings then
                                self:FocusLevel(2)
                                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_RIGHT_ITEM_INDEX", false, 0)
                                self:RightItemIndex(1)
                            end
                            tab.LeftItemList[self.leftItemIndex]:Selected(false)
                            self:LeftItemIndex(item_id + 1)
                            tab.LeftItemList[self.leftItemIndex]:Selected(true)
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                        end
                        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_LEFT_ITEM_INDEX", false, item_id)
                        tab.LeftItemList[self.leftItemIndex].OnActivated(tab.LeftItemList[self.leftItemIndex],
                            self.leftItemIndex)
                        self.OnLeftItemSelect(self, tab.LeftItemList[self.leftItemIndex], self.leftItemIndex)
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                elseif context == 2 then
                    local rightItem = tab.LeftItemList[self.leftItemIndex].ItemList[item_id + 1]
                    if not rightItem:Enabled() then
                        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                        return
                    end
                    if self:FocusLevel() ~= 2 then
                        self:FocusLevel(2)
                    end
                    if rightItem:Selected() then
                        if rightItem.ItemType == SettingsItemType.ListItem then
                            rightItem.OnListSelected(rightItem, rightItem:ItemIndex(),
                                tostring(rightItem.ListItems[rightItem:ItemIndex()]))
                        elseif rightItem.ItemType == SettingsItemType.CheckBox then
                            rightItem:Checked(not rightItem:Checked())
                        elseif rightItem.ItemType == SettingsItemType.MaskedProgressBar or rightItem.ItemType == SettingsItemType.ProgressBar then
                            rightItem.OnProgressSelected(rightItem, rightItem:Value())
                        elseif rightItem.ItemType == SettingsItemType.SliderBar then
                            rightItem.OnSliderSelected(rightItem, rightItem:Value())
                        else
                            rightItem.OnActivated(rightItem,
                                IndexOf(tab.LeftItemList[self.leftItemIndex].ItemList, rightItem))
                        end
                        self.OnRightItemSelect(self, rightItem, self.rightItemIndex)
                        return
                    end
                    tab.LeftItemList[self.leftItemIndex].ItemList[self.rightItemIndex]:Selected(false)
                    self:RightItemIndex(item_id + 1)
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SELECT_RIGHT_ITEM_INDEX", false, item_id)
                    tab.LeftItemList[self.leftItemIndex].ItemList[self.rightItemIndex]:Selected(true)
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                end
            elseif event_type == 9 then
                if subT == "PlayerListTab" then
                    local idx = tab.listCol[context+1].Pagination:GetMenuIndexFromScaleformIndex(item_id-1)
                    tab.listCol[context+1].Items[idx]:Hovered(true)
                else
                    if context == 1 then
                        for i, item in ipairs(tab.LeftItemList) do
                            item:Hovered(item:Enabled() and i == item_id + 1)
                        end
                    elseif context == 2 then
                        for i, item in ipairs(tab.LeftItemList[self.leftItemIndex].ItemList) do
                            item:Hovered(item:Enabled() and i == item_id + 1)
                        end
                    end
                end
            elseif event_type == 8 or event_type == 0 then
                if subT == "PlayerListTab" then
                    local idx = tab.listCol[context+1].Pagination:GetMenuIndexFromScaleformIndex(item_id-1)
                    tab.listCol[context+1].Items[idx]:Hovered(false)
                end
            end
        end
    end)
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
    if (IsControlJustPressed(2, 205) or (IsUsingKeyboard(2) and IsControlJustPressed(2, 192) and IsControlPressed(2, 21))) then
        Citizen.CreateThread(function()
            if (self:FocusLevel() ~= 0) then
                self:FocusLevel(0)
            end
            self:GoLeft()
        end)
    end
    if (IsControlJustPressed(2, 206) or (IsUsingKeyboard(2) and IsControlJustPressed(2, 192))) then
        Citizen.CreateThread(function()
            if (self:FocusLevel() ~= 0) then
                self:FocusLevel(0)
            end
            self:GoRight()
        end)
    end
    if (IsControlJustPressed(2, 201)) then
        Citizen.CreateThread(function()
            self:Select()
        end)
    end
    if (IsControlJustReleased(2, 177)) then
        Citizen.CreateThread(function()
            self:GoBack()
        end)
    end

    if (IsControlJustPressed(2, 241) or IsDisabledControlJustPressed(2, 241)) then
        Citizen.CreateThread(function()
            ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(-1)
        end)
    end
    if (IsControlJustPressed(2, 242) or IsDisabledControlJustPressed(2, 242)) then
        Citizen.CreateThread(function()
            ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(1)
        end)
    end


    if (IsControlPressed(2, 3) and not IsUsingKeyboard(2)) then
        if (GlobalGameTimer - self._timer > 175) then
            Citizen.CreateThread(function()
                ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(-1)
            end)
            self._timer = GlobalGameTimer
        end
    end
    if (IsControlPressed(2, 4) and not IsUsingKeyboard(2)) then
        if (GlobalGameTimer - self._timer > 175) then
            Citizen.CreateThread(function()
                ScaleformUI.Scaleforms._pauseMenu:SendScrollEvent(1)
            end)
            self._timer = GlobalGameTimer
        end
    end
end
