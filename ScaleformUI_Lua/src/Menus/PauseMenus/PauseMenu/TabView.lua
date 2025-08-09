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
        TabsColor = 117,
        _headerPicture = {txd = "", txn = ""},
        _crewPicture = {txd = "", txn = ""},
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
        setHeaderDynamicWidth = false,
        _firstDrawTick = false,
        timer = 100,
        changed = false,
        ShowBlur = true,
        IsCorona = false,
        _showStoreBackground = false,
        _storeBackgroundAnimationSpeed = 240, -- milliseconds
        coronaTab = nil,
        hoveredColumn = 0,
        tabArrowsHovered = false,
        sm_uDisableInputDuration = 250,   -- milliseconds.
        FRONTEND_ANALOGUE_THRESHOLD = 80, -- out of 128
        BUTTON_PRESSED_DOWN_INTERVAL = 250,
        BUTTON_PRESSED_REFIRE_ATTRITION = 45,
        BUTTON_PRESSED_REFIRE_MINIMUM = 100,
        s_iLastRefireTimeUp = 250,
        s_iLastRefireTimeDn = 250,
        s_pressedDownTimer = GetGameTimer(),
        s_lastGameFrame = 0,
        iPreviousXAxis = 0.0,
        iPreviousYAxis = 0.0,
        iPreviousXAxisR = 0.0,
        iPreviousYAxisR = 0.0,
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
        OnColumnItemChange = function(menu, tab, column, index)
        end,
        OnColumnItemSelect = function(menu, tab, column, index)
        end
    }
    return setmetatable(_data, TabView)
end

function TabView:SetHeaderDynamicWidth(value)
    if value ~= nil then
        self.setHeaderDynamicWidth = value
    else
        return self.setHeaderDynamicWidth
    end
end

function TabView:FocusLevel(index)
    if index ~= nil then
        local dir = 0
        if index < self.focusLevel then
            dir = -1
        elseif index > self.focusLevel then
            dir = 1
        else
            dir = 0
        end
        self.focusLevel = self.focusLevel + dir
        ScaleformUI.Scaleforms._pauseMenu:SetFocus(dir)
        if dir > 0 and #self.Tabs > 0 and self.focusLevel == 1 then
            self.Tabs[self.index]:Focus()
        elseif (dir < 0 and #self.Tabs > 0 and self.focusLevel == 0) then
            self.Tabs[self.index]:UnFocus()
        end
        self.OnPauseMenuFocusChanged(self, self.Tabs[self.index], index)
    else
        return self.focusLevel
    end
end

function TabView:Index(idx)
    if idx ~= nil then
        self.Tabs[self.index].Visible = false
        self.index = idx
        if self.index > #self.Tabs then
            self.index = 1
        end
        if self.index < 1 then
            self.index = #self.Tabs
        end
        self.Tabs[self.index].Visible = true
        if self:Visible() then
            self:BuildPauseMenu()
            ScaleformUI.Scaleforms._pauseMenu:SelectTab(self.index - 1)
        end
        self.OnPauseMenuTabChanged(self, self.Tabs[self.index], self.index)
    else
        return self.index
    end
end

function TabView:ShowStoreBackground(bool)
    if bool == nil then
        return self._showStoreBackground
    else
        self._showStoreBackground = bool
        ScaleformUI.Scaleforms._pauseMenu.BGEnabled = self._showStoreBackground
    end
end

function TabView:StoreBackgroundAnimationSpeed(speed)
    if speed == nil then
        return self._storeBackgroundAnimationSpeed
    else
        self._storeBackgroundAnimationSpeed = speed
        if self:Visible() then
            ScaleformUI.Scaleforms._pauseMenu._pauseBG:CallFunction("ANIMATE_BACKGROUND", speed)
        end
    end
end

function TabView:Visible(visible)
    if visible ~= nil then
        self._visible = visible
        ScaleformUI.Scaleforms._pauseMenu:Visible(visible)
        if visible == true then
            if not IsPauseMenuActive() then
                PlaySoundFrontend(self.SoundId, "Hit_In", "PLAYER_SWITCH_CUSTOM_SOUNDSET", true)
                ActivateFrontendMenu(`FE_MENU_VERSION_CORONA`, true, -1)
                if self.ShowBlur then
                    self:doScreenBlur()
                end
                self._firstDrawTick = true
                ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
                SetPlayerControl(PlayerId(), false, 0)
                MenuHandler._currentPauseMenu = self
                MenuHandler.ableToDraw = true
                self._isBuilding = true
                self.Tabs[self.index].Visible = true
                self:ShowHeader()
                self:BuildPauseMenu()
                self.OnPauseMenuOpen(self)
                if self.IsCorona then
                    ScaleformUI.Scaleforms._pauseMenu.BGEnabled = self._showStoreBackground
                    ScaleformUI.Scaleforms._pauseMenu._pauseBG:CallFunction("ANIMATE_BACKGROUND", self._storeBackgroundAnimationSpeed)
                    self:FocusLevel(1)
                end
            end
        else
            if self.Tabs[self.index].Minimap ~= nil then
                self.Tabs[self.index].Minimap:Dispose()
            end
            MenuHandler.ableToDraw = false
            MenuHandler._currentPauseMenu = nil
            ScaleformUI.Scaleforms._pauseMenu:Dispose()
            ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList()
            if self.ShowBlur or AnimpostfxIsRunning("PauseMenuIn") then
                AnimpostfxStop("PauseMenuIn")
                AnimpostfxPlay("PauseMenuOut", 0, false)
            end
            self.OnPauseMenuClose(self)
            SetPlayerControl(PlayerId(), true, 0)
            PlaySoundFrontend(self.SoundId, "Hit_Out", "PLAYER_SWITCH_CUSTOM_SOUNDSET", true)
            SetFrontendActive(false)
        end
    else
        return self._visible
    end
end

function TabView:doScreenBlur()
    while (AnimpostfxIsRunning("PauseMenuOut")) do
        Wait(0)
        AnimpostfxStop("PauseMenuOut")
    end
    AnimpostfxPlay("PauseMenuIn", 0, true)
end

function TabView:AddTab(tab)
    tab.Parent = self
    if tab.Minimap ~= nil then
        tab.Minimap.Parent = self
    end
    self.Tabs[#self.Tabs + 1] = tab
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
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderTitle(self.Title, self.Subtitle .. "\n\n\n\n\n\n\n\n\n\n\n")
    end
    if (self:HeaderPicture() ~= nil and not self:HeaderPicture().txd:IsNullOrEmpty()) then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderCharImg(self:HeaderPicture().txd, self:HeaderPicture().txn, true)
    end
    if (self:CrewPicture() ~= nil and not self:CrewPicture().txd:IsNullOrEmpty()) then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderSecondaryImg(self:CrewPicture().txd, self:CrewPicture().txn, true)
    end
    if not self.IsCorona then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_DYNAMIC_WIDTH", self:SetHeaderDynamicWidth())
        for k, tab in pairs(self.Tabs) do
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(tab.Title, 0, tab.TabColor)
        end
    else
        if self.coronaTab == nil then return end
        if self.coronaTab.LeftColumn ~= nil then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(self.coronaTab.LeftColumn.Label, 2, self.coronaTab.LeftColumn.Color)
        end
        if self.coronaTab.CenterColumn ~= nil then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(self.coronaTab.CenterColumn.Label, 2,
                self.coronaTab.CenterColumn.Color)
        end
        if self.coronaTab.RightColumn ~= nil then
            ScaleformUI.Scaleforms._pauseMenu:AddPauseMenuTab(self.coronaTab.RightColumn.Label, 2, self.coronaTab.RightColumn
                .Color)
        end
        ScaleformUI.Scaleforms._pauseMenu._header:CallFunction("SET_ALL_HIGHLIGHTS", true, self.TabsColor)
        ScaleformUI.Scaleforms._pauseMenu._header:CallFunction("ENABLE_DYNAMIC_WIDTH", false)
    end
    ScaleformUI.Scaleforms._pauseMenu:SetHeaderDetails(self.SideTop, self.SideMid, self.SideBot)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_DYNAMIC_WIDTH", self:SetHeaderDynamicWidth())
    self._loaded = true
end

function TabView:BuildPauseMenu()
    while (not ScaleformUI.Scaleforms._pauseMenu:IsLoaded()) do Wait(0) end
    if not HasStreamedTextureDictLoaded("commonmenu") then
        RequestStreamedTextureDict("commonmenu", true)
        while not HasStreamedTextureDictLoaded("commonmenu") do Wait(0) end
    end
    self._isBuilding = true
    ScaleformUI.Scaleforms._pauseMenu.BGEnabled = false
    local tab = self.Tabs[self.index]
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("LOAD_CHILD_PAGE", tab._identifier)
    tab:Populate()
    tab:ShowColumns()
    self._isBuilding = false
end

function TabView:UpdateKeymapItems()
    if not IsUsingKeyboard(2) then
        if not self.controller then
            self.controller = true
            self.changed = true
        end
    else
        if self.controller then
            self.controller = false
            self.changed = true
        end
    end

    if self.changed then
        local tab = self.Tabs[self.index]
        local t, st = tab()
        if st == "SubmenuTab" then
            if tab.currentItemType == 4 then
                for k, v in pairs(tab.CenterColumn.Items) do
                    tab.CenterColumn:UpdateItem(k)
                end
            end
        end
        self.changed = false
    end
end

function TabView:CurrentTab()
    return self.Tabs[self.index]
end

function TabView:Draw()
    if not self:Visible() or self.TemporarilyHidden then
        return
    end
    local tab = self.Tabs[self.index]
    if tab.Minimap ~= nil then
        tab.Minimap:MaintainMap()
    end
    DisableControlAction(0, 199, true)
    DisableControlAction(0, 200, true)
    DisableControlAction(1, 199, true)
    DisableControlAction(1, 200, true)
    DisableControlAction(2, 199, true)
    DisableControlAction(2, 200, true)
    ScaleformUI.Scaleforms._pauseMenu:Draw(false)
    ScaleformUI.Scaleforms._pauseMenu._header:CallFunction("SHOW_ARROWS")
    self:UpdateKeymapItems()
    Citizen.CreateThread(function()
        self:GetHoveredColumn()
    end)
end


function TabView:GetHoveredColumn()
    self.hoveredColumn = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunctionAsyncReturnInt("GET_HOVERED_COLUMN")
end

function TabView:GoBack()
    PlaySoundFrontend(-1, "BACK","HUD_FRONTEND_DEFAULT_SOUNDSET", false)
    if self.IsCorona then
        if self:CurrentTab().CurrentColumnIndex > 0 then
            self:CurrentTab():GoBack()
        else
            if self:CanPlayerCloseMenu() then
                if self:CurrentTab()._identifier == "Page_Multi" then
                    self:CurrentTab().Minimap:Enabled(false)
                end
                self:Visible(false)
            end
        end
    else
        if self:FocusLevel() > 0 then
            if self:FocusLevel() == 1 and self:CurrentTab().CurrentColumnIndex == 0 then
                self:CurrentTab():UnFocus()
                self:FocusLevel(0)
                if self:CurrentTab()._identifier == "Page_Multi" then
                    self:CurrentTab().Minimap:Enabled(false)
                end
            else
                self:CurrentTab():GoBack()
            end
        else
            if self:CanPlayerCloseMenu() then
                self:Visible(false)
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

        successHeader, event_type_h, context_h, item_id_h = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms
            ._pauseMenu._header.handle)
        if successHeader then
            if event_type_h == 5 then
                if context_h == -1 then
                    self:CurrentTab():UnFocus()
                    self:FocusLevel(0)
                    ScaleformUI.Scaleforms._pauseMenu:SelectTab(item_id_h)
                    self:Index(item_id_h + 1)
                    self:CurrentTab():Focus()
                    self:FocusLevel(1)
                    PlaySoundFrontend(-1, "SELECT","HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                end
            elseif event_type_h == 6 then
                if context_h == 1000 then
                    self:FocusLevel(0)
                    self:CurrentTab():UnFocus()
                    if item_id == -1 then
                        self:Index(self:Index() - 1)
                    elseif item_id == 1 then
                        self:Index(self:Index() + 1)
                    end
                    self:CurrentTab():Focus()
                    self:FocusLevel(1)
                end
            elseif event_type_h == 8 then
                self.tabArrowsHovered = false
            elseif event_type_h == 9 then
                self.tabArrowsHovered = true
            end
        end

        successPause, event_type, context, item_id = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms._pauseMenu
            ._pause.handle)
        if successPause and not self.tabArrowsHovered then
            if event_type == 5 and self:FocusLevel() == 0 and not self.tabArrowsHovered then
                self:FocusLevel(1)
                return
            end
            self:CurrentTab():MouseEvent(event_type, context, item_id + 1)
        end
        if not successPause and not successHeader and self:FocusLevel() == 0 and event_type == 5 then
            self:FocusLevel(1)
        end
    end)
end

function TabView:CheckInput(input, bPlaySound, OverrideFlags, bCheckForButtonJustPressed)
    local bOnlyCheckForDown = false
    local interval = 0

    if input == eFRONTEND_INPUT.FRONTEND_INPUT_UP then
        interval = self.s_iLastRefireTimeUp
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_DOWN then
        interval = self.s_iLastRefireTimeDn
    else
        interval = self.BUTTON_PRESSED_DOWN_INTERVAL
    end

    if self.s_lastGameFrame ~= GetFrameCount() and GetGameTimer() > (self.s_pressedDownTimer + interval) then
        bOnlyCheckForDown = true
    end

    local bInputTriggered = false
    local iXAxis = 0
    local iYAxis = 0
    local iYAxisR = 0
    local iXAxisR = 0

    local c_ignoreDpad = OverrideFlags & CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_IGNORE_D_PAD ~= 0

    if OverrideFlags & CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_IGNORE_ANALOGUE_STICKS == 0 then
        iXAxis = GetDisabledControlNormal(2, 195) * 128.0
        iYAxis = GetDisabledControlNormal(2, 196) * 128.0
        iYAxisR = GetDisabledControlNormal(2, 198) * 128.0
        iXAxisR = GetDisabledControlNormal(2, 197) * 128.0
    end

    -- Input-specific logic
    if input == eFRONTEND_INPUT.FRONTEND_INPUT_UP then
        if iXAxis > -self.FRONTEND_ANALOGUE_THRESHOLD and iXAxis < self.FRONTEND_ANALOGUE_THRESHOLD then
            if bOnlyCheckForDown then
                if iYAxis < -self.FRONTEND_ANALOGUE_THRESHOLD or (IsDisabledControlPressed(2, 188) and not c_ignoreDpad) then
                    bInputTriggered = true
                end
            else
                if (self.iPreviousYAxis > -self.FRONTEND_ANALOGUE_THRESHOLD and iYAxis < -self.FRONTEND_ANALOGUE_THRESHOLD)
                    or (IsDisabledControlJustPressed(2, 188) and not c_ignoreDpad) then
                    bInputTriggered = true
                end
            end
        end

        if self.s_lastGameFrame ~= GetFrameCount() then
            if iYAxis < -self.FRONTEND_ANALOGUE_THRESHOLD or (IsDisabledControlPressed(2, 188) and not c_ignoreDpad) then
                if bInputTriggered then
                    self.s_iLastRefireTimeUp = math.max(self.s_iLastRefireTimeUp - self.BUTTON_PRESSED_REFIRE_ATTRITION,
                        self.BUTTON_PRESSED_REFIRE_MINIMUM)
                end
            else
                self.s_iLastRefireTimeUp = self.BUTTON_PRESSED_DOWN_INTERVAL
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_DOWN then
        if (iXAxis > -self.FRONTEND_ANALOGUE_THRESHOLD and iXAxis < self.FRONTEND_ANALOGUE_THRESHOLD) then
            if (bOnlyCheckForDown) then
                if (iYAxis > self.FRONTEND_ANALOGUE_THRESHOLD or (IsDisabledControlPressed(2, 187) and not c_ignoreDpad)) then
                    bInputTriggered = true
                end
            else
                if ((self.iPreviousYAxis < self.FRONTEND_ANALOGUE_THRESHOLD and iYAxis > self.FRONTEND_ANALOGUE_THRESHOLD) or (IsDisabledControlJustPressed(2, 187) and not c_ignoreDpad)) then
                    bInputTriggered = true
                end
            end
            if self.s_lastGameFrame ~= GetFrameCount() then
                -- can't just do bInputTriggered because we may be waiting for an up
                if (iYAxis > self.FRONTEND_ANALOGUE_THRESHOLD or (IsDisabledControlPressed(2, 187) and not c_ignoreDpad)) then
                    if (bInputTriggered) then
                        self.s_iLastRefireTimeDn = math.max(
                            self.s_iLastRefireTimeDn - self.BUTTON_PRESSED_REFIRE_ATTRITION,
                            self.BUTTON_PRESSED_REFIRE_MINIMUM)
                    end
                else
                    self.s_iLastRefireTimeDn = self.BUTTON_PRESSED_DOWN_INTERVAL
                end
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_LEFT then
        if iYAxis > -self.FRONTEND_ANALOGUE_THRESHOLD and iYAxis < self.FRONTEND_ANALOGUE_THRESHOLD then
            if bOnlyCheckForDown then
                if iXAxis < -self.FRONTEND_ANALOGUE_THRESHOLD or (IsDisabledControlPressed(2, 189) and not c_ignoreDpad) then
                    bInputTriggered = true
                end
            else
                if (self.iPreviousXAxis > -self.FRONTEND_ANALOGUE_THRESHOLD and iXAxis < -self.FRONTEND_ANALOGUE_THRESHOLD)
                    or (IsDisabledControlJustPressed(2, 189) and not c_ignoreDpad) then
                    bInputTriggered = true
                end
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_RIGHT then
        if iYAxis > -self.FRONTEND_ANALOGUE_THRESHOLD and iYAxis < self.FRONTEND_ANALOGUE_THRESHOLD then
            if bOnlyCheckForDown then
                if iXAxis > self.FRONTEND_ANALOGUE_THRESHOLD or (IsDisabledControlPressed(2, 190) and not c_ignoreDpad) then
                    bInputTriggered = true
                end
            else
                if (self.iPreviousXAxis < self.FRONTEND_ANALOGUE_THRESHOLD and iXAxis > self.FRONTEND_ANALOGUE_THRESHOLD)
                    or (IsDisabledControlJustPressed(2, 190) and not c_ignoreDpad) then
                    bInputTriggered = true
                end
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_RUP then
        if bOnlyCheckForDown then
            if iYAxisR < -self.FRONTEND_ANALOGUE_THRESHOLD then
                bInputTriggered = true
            end
        else
            if self.iPreviousYAxisR > -self.FRONTEND_ANALOGUE_THRESHOLD and iYAxisR < -self.FRONTEND_ANALOGUE_THRESHOLD then
                bInputTriggered = true
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_RDOWN then
        if bOnlyCheckForDown then
            if iYAxisR > self.FRONTEND_ANALOGUE_THRESHOLD then
                bInputTriggered = true
            end
        else
            if self.iPreviousYAxisR < self.FRONTEND_ANALOGUE_THRESHOLD and iYAxisR > self.FRONTEND_ANALOGUE_THRESHOLD then
                bInputTriggered = true
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_RLEFT then
        if bOnlyCheckForDown then
            if iXAxisR < -self.FRONTEND_ANALOGUE_THRESHOLD then
                bInputTriggered = true
            end
        else
            if self.iPreviousXAxisR > -self.FRONTEND_ANALOGUE_THRESHOLD and iXAxisR < -self.FRONTEND_ANALOGUE_THRESHOLD then
                bInputTriggered = true
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_RRIGHT then
        if bOnlyCheckForDown then
            if iXAxisR > self.FRONTEND_ANALOGUE_THRESHOLD then
                bInputTriggered = true
            end
        else
            if self.iPreviousXAxisR < self.FRONTEND_ANALOGUE_THRESHOLD and iXAxisR > self.FRONTEND_ANALOGUE_THRESHOLD then
                bInputTriggered = true
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_ACCEPT then
        local bAcceptHasBeenPressed = false

        if bCheckForButtonJustPressed then
            if IsDisabledControlJustPressed(2, 201) then
                bAcceptHasBeenPressed = true
            end
        else
            if IsDisabledControlJustReleased(2, 201) then
                bAcceptHasBeenPressed = true
            end
        end

        if bAcceptHasBeenPressed then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_X then
        if IsDisabledControlJustReleased(2, 203) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_Y then
        if IsDisabledControlJustReleased(2, 204) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_BACK then
        if bCheckForButtonJustPressed then
            if IsDisabledControlJustPressed(2, 202) then
                bInputTriggered = true
            end
        else
            if IsDisabledControlJustReleased(2, 202) then
                bInputTriggered = true
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_CURSOR_BACK then
        if bCheckForButtonJustPressed then
            if IsDisabledControlJustPressed(0, 238) then
                bInputTriggered = true
            end
        else
            if IsDisabledControlJustReleased(0, 238) then
                bInputTriggered = true
            end
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_START then
        if IsDisabledControlJustReleased(0, 199) then
            bInputTriggered = true
        elseif IsDisabledControlJustReleased(0, 200) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_SPECIAL_UP then
        if iYAxisR < -self.FRONTEND_ANALOGUE_THRESHOLD then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_SPECIAL_DOWN then
        if iYAxisR > self.FRONTEND_ANALOGUE_THRESHOLD then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_RT_SPECIAL or input == eFRONTEND_INPUT.FRONTEND_INPUT_RT then
        if IsDisabledControlJustPressed(2, 208) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_LT_SPECIAL or input == eFRONTEND_INPUT.FRONTEND_INPUT_LT then
        if IsDisabledControlJustPressed(2, 207) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_LB then
        if IsDisabledControlJustPressed(2, 205) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_RB then
        if IsDisabledControlJustPressed(2, 206) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_RSTICK_LEFT then
        if iXAxisR > self.FRONTEND_ANALOGUE_THRESHOLD then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_RSTICK_RIGHT then
        if iXAxisR < -self.FRONTEND_ANALOGUE_THRESHOLD then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_SELECT then
        if IsDisabledControlJustReleased(2, 217) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_R3 then
        if IsDisabledControlJustReleased(2, 231) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_L3 then
        if IsDisabledControlJustReleased(2, 230) then
            bInputTriggered = true
        end
    elseif input == eFRONTEND_INPUT.FRONTEND_INPUT_CURSOR_ACCEPT then
        if IsDisabledControlJustReleased(2, 237) then
            bInputTriggered = true
        end
    end

    if bInputTriggered then
        if self.s_lastGameFrame ~= GetFrameCount() then
            self.s_pressedDownTimer = GetGameTimer()
            self.s_lastGameFrame = GetFrameCount()
            self.iPreviousXAxis = iXAxis
            self.iPreviousYAxis = iYAxis
            self.iPreviousXAxisR = iXAxisR
            self.iPreviousYAxisR = iYAxisR
        end

        -- Sound playing logic commented out
        -- if bPlaySound then
        --     PlayInputSound(input)
        -- end
    end

    return bInputTriggered
end

function TabView:ProcessControl()
    if not self:Visible() or self.TemporarilyHidden or self._isBuilding then
        return
    end

    if (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_UP, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false)) then
        self:CurrentTab():GoUp()
    elseif (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_DOWN, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false)) then
        self:CurrentTab():GoDown()
    elseif (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_LEFT, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false)) then
        if (self:FocusLevel() == 0 and not IsCorona) then
            self:Index(self.index - 1)
        else
            self:CurrentTab():GoLeft()
        end
    elseif (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_RIGHT, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false)) then
        if (self:FocusLevel() == 0 and not IsCorona) then
            self:Index(self.index + 1)
        else
            self:CurrentTab():GoRight()
        end
    elseif (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_LB, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false)
            or (IsDisabledControlJustPressed(2, 192) and IsControlPressed(2, 21) and IsUsingKeyboard(2))) then
        if (IsCorona or #self.Tabs == 1) then return end
        if (self:FocusLevel() > 0) then
            self:FocusLevel(0)
        end
        self:Index(self.index - 1)
    elseif (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_RB, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false)
            or (IsDisabledControlJustPressed(2, 192) and IsUsingKeyboard(2))) then
        if (IsCorona or #self.Tabs == 1) then return end
        if (self:FocusLevel() > 0) then
            self:FocusLevel(0)
        end
        self:Index(self.index + 1)
    elseif (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_ACCEPT, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false) or (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_CURSOR_ACCEPT, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false) and self.focusLevel == 0)) then
        if (self.focusLevel == 0) then
            self:CurrentTab():Focus()
            self:FocusLevel(1)
        else
            self:CurrentTab():Select()
        end
    elseif (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_BACK, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false) or self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_CURSOR_BACK, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, false)) then
        self:GoBack()
    elseif (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_RUP, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, true)) then
        if (not self:CurrentTab().Focused) then return end
        if (self:CurrentTab()._identifier == "Page_Simple") then
            self:CurrentTab():MouseEvent(10, 0, -1)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", 0, 8)
        elseif (self:CurrentTab()._identifier == "Page_Info") then
            if (self:CurrentTab().currentItemType == 1 or self:CurrentTab().currentItemType == 2) then
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", 1, 8)
            end
        end
    elseif (self:CheckInput(eFRONTEND_INPUT.FRONTEND_INPUT_RDOWN, false, CHECK_INPUT_OVERRIDE_FLAG.CHECK_INPUT_OVERRIDE_FLAG_NONE, true)) then
        if (not self:CurrentTab().Focused) then return end
        if (self:CurrentTab()._identifier == "Page_Simple") then
            self:CurrentTab().MouseEvent(11, 0, -1)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", 0, 9)
        elseif (self:CurrentTab()._identifier == "Page_Info") then
            if (self:CurrentTab().currentItemType == 1 or self:CurrentTab().currentItemType == 2) then
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", 1, 9)
            end
        end
    end
end
