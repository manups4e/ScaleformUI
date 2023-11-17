MainView = setmetatable({}, MainView)
MainView.__index = MainView
MainView.__call = function()
    return "LobbyMenu"
end
MainView.SoundId = GetSoundId()

---@class MainView
---@field public Title string
---@field public Subtitle string
---@field public SideTop string
---@field public SideMid string
---@field public SideBot string
---@field public SettingsColumn SettingsListColumn
---@field public PlayersColumn PlayerListColumn
---@field public MissionPanel MissionDetailsPanel
---@field public InstructionalButtons InstructionalButton[]
---@field public OnLobbyMenuOpen fun(menu: MainView)
---@field public OnLobbyMenuClose fun(menu: MainView)
---@field public TemporarilyHidden boolean
---@field public controller boolean
---@field public _focus number

function MainView.New(title, subtitle, sideTop, sideMid, sideBot, newStyle)
    local _data = {
        Title = title or "",
        Subtitle = subtitle or "",
        SideTop = sideTop or "",
        SideMid = sideMid or "",
        SideBot = sideBot or "",
        ParentPool = nil,
        _headerPicture = {},
        _newStyle = newStyle or true,
        _crewPicture = {},
        _visible = false,
        SettingsColumn = nil --[[@type SettingsListColumn]],
        PlayersColumn = nil --[[@type PlayerListColumn]],
        MissionsColumns = nil --[[@type MissionListColumn]],
        MissionPanel = nil --[[@type MissionDetailsPanel]],
        _focus = 1,
        TemporarilyHidden = false,
        controller = false,
        _loaded = false,
        _timer = 0,
        _time = 0,
        _times = 0,
        _delay = 150,
        listCol = {},
        _firstTick = true,
        _canHe = true,
        _isBuilding = false,
        InstructionalButtons = {
            InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 176, 176, -1),
            InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 177, 177, -1),
        },
        OnLobbyMenuOpen = function(menu)
        end,
        OnLobbyMenuClose = function(menu)
        end
        --[[
        OnLeftItemChange = function(menu, leftItem, index)
        end,
        OnRightItemChange = function(menu, rightItem, index)
        end,
        OnLeftItemSelect = function(menu, leftItem, index)
        end,
        OnRightItemSelect = function(menu, rightItem, index)
        end
        ]]
    }
    return setmetatable(_data, MainView)
end

function MainView:Focus()
    return self._focus
end

function MainView:CanPlayerCloseMenu(canHe)
    if canHe == nil then
        return self._canHe
    else
        self._canHe = canHe
    end
end

function MainView:Visible(visible)
    if visible ~= nil then
        self._visible = visible
        ScaleformUI.Scaleforms._pauseMenu:Visible(visible)
        if visible == true then
            if not IsPauseMenuActive() then
                self._focus = 1
                PlaySoundFrontend(self.SoundId, "Hit_In", "PLAYER_SWITCH_CUSTOM_SOUNDSET", true)
                ActivateFrontendMenu(`FE_MENU_VERSION_EMPTY_NO_BACKGROUND`, true, -1)
                self:BuildPauseMenu()
                self.OnLobbyMenuOpen(self)
                AnimpostfxPlay("PauseMenuIn", 800, true)
                ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
                SetPlayerControl(PlayerId(), false, 0)
                self._firstTick = true
                MenuHandler._currentPauseMenu = self
                MenuHandler.ableToDraw = true;
            end
        else
            MenuHandler.ableToDraw = false;
            MenuHandler._currentPauseMenu = nil
            ScaleformUI.Scaleforms._pauseMenu:Dispose()
            ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList()
            AnimpostfxStop("PauseMenuIn")
            AnimpostfxPlay("PauseMenuOut", 800, false)
            self.OnLobbyMenuClose(self)
            SetPlayerControl(PlayerId(), true, 0)
            if IsPauseMenuActive() then
                PlaySoundFrontend(self.SoundId, "Hit_Out", "PLAYER_SWITCH_CUSTOM_SOUNDSET", true)
                ActivateFrontendMenu(`FE_MENU_VERSION_EMPTY_NO_BACKGROUND`, false, -1)
            end
            SetFrontendActive(false)
        end
    else
        return self._visible
    end
end

function MainView:HeaderPicture(Txd, Txn)
    if (Txd ~= nil and Txn ~= nil) then
        self._headerPicture = { txd = Txd, txn = Txn }
    else
        return self._headerPicture
    end
end

function MainView:CrewPicture(Txd, Txn)
    if (Txd ~= nil and Txn ~= nil) then
        self._crewPicture = { txd = Txd, txn = Txn }
    else
        return self._crewPicture
    end
end

function MainView:SelectColumn(column)
    local val = 0
    if type(column) == "table" then
        val = column.Order
    elseif type(column) == "number" then
        val = column
    end
    if val > #self.listCol then
        val  = 1
    elseif val  < 1 then
        val = #self.listCol
    end
    self:updateFocus(val)
end

function MainView:updateFocus(value, isMouse)
    if isMouse == nil then isMouse = false end
    local goingLeft = value < self._focus

    local val = value

    if val > #self.listCol then
        val  = 1
    elseif val  < 1 then
        val = #self.listCol
    end

    if self.listCol[val].Type ~= "players" then
        if (self.PlayersColumn ~= nil and #self.PlayersColumn.Items > 0) and not self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:KeepPanelVisible() then
            ClearPedInPauseMenu()
        end
    end
    self._focus = val

    if self.listCol[self._focus].Type == "panel" then
        if goingLeft then
            self:updateFocus(self._focus - 1)
        else
            self:updateFocus(self._focus + 1)
        end
        return
    end

    if self:Visible() then
        local idx = ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunctionAsyncReturnInt("SET_FOCUS", self._focus-1)
        if not isMouse then
            local _id = self.listCol[self._focus].Pagination:GetMenuIndexFromScaleformIndex(idx)
            if not goingLeft or self._newStyle then
                self.listCol[self._focus]:CurrentSelection(_id)
                self.listCol[self._focus].OnIndexChanged(_id)
            end
        end
    end
end

function MainView:SetupColumns(columns)
    assert(type(columns) == "table", "^1ScaleformUI [ERROR]: SetupColumns, Table expected^7")
    assert(#columns <= 3, "^1ScaleformUI [ERROR]: SetupColumns, You must have max 3 columns^7")
    assert(not(#columns == 3 and columns[3].Type == "players"), "For panel designs reasons, you can't have Players list in 3rd column!")

    self.listCol = columns
    for k, v in ipairs(columns) do
        if v.Type == "settings" then
            self.SettingsColumn = v
            self.SettingsColumn.Parent = self
            self.SettingsColumn.Order = k
        elseif v.Type == "missions" then
            self.MissionsColumn = v
            self.MissionsColumn.Parent = self
            self.MissionsColumn.Order = k
        elseif v.Type == "players" then
            self.PlayersColumn = v
            self.PlayersColumn.Parent = self
            self.PlayersColumn.Order = k
        elseif v.Type == "panel" then
            self.MissionPanel = v
            self.MissionPanel.Parent = self
            self.MissionPanel.Order = k
        end
    end
end

function MainView:ShowHeader()
    if self.Subtitle:IsNullOrEmpty() then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderTitle(self.Title)
    else
        ScaleformUI.Scaleforms._pauseMenu:ShiftCoronaDescription(true, false)
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderTitle(self.Title, self.Subtitle .. "\n\n\n\n\n\n\n\n\n\n\n")
    end
    if (self:HeaderPicture() ~= nil) then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderCharImg(self:HeaderPicture().txd, self:HeaderPicture().txn, true)
    end
    if (self:CrewPicture() ~= nil) then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderSecondaryImg(self:CrewPicture().txd, self:CrewPicture().txn, true)
    end
    ScaleformUI.Scaleforms._pauseMenu:SetHeaderDetails(self.SideTop, self.SideMid, self.SideBot)
    ScaleformUI.Scaleforms._pauseMenu:AddLobbyMenuTab(self.listCol[1]._label, 2, self.listCol[1]._color)
    ScaleformUI.Scaleforms._pauseMenu:AddLobbyMenuTab(self.listCol[2]._label, 2, self.listCol[2]._color)
    ScaleformUI.Scaleforms._pauseMenu:AddLobbyMenuTab(self.listCol[3]._label, 2, self.listCol[3]._color)
    ScaleformUI.Scaleforms._pauseMenu._header:CallFunction("SET_ALL_HIGHLIGHTS", true, 117);
    self._loaded = true
end

function MainView:BuildPauseMenu()
    self._isBuilding = true
    self:ShowHeader()
    if #self.listCol == 1 then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CREATE_MENU", self.listCol[1].Type)
    elseif #self.listCol == 2 then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CREATE_MENU", self.listCol[1].Type, self.listCol[2].Type)
    elseif #self.listCol == 3 then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CREATE_MENU", self.listCol[1].Type, self.listCol[2].Type, self.listCol[3].Type)
    end
    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_NEWSTYLE", self._newStyle)

    for i,col in pairs(self.listCol) do
        col.Parent = self
        if col.Type == "settings" then
            self:buildSettings()
        elseif col.Type == "players" then
            self:buildPlayers()
        elseif col.Type == "missions" then
            self:buildMissions()
        elseif col.Type == "panel" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSION_PANEL_PICTURE", self.MissionPanel.TextureDict, self.MissionPanel.TextureName);
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSION_PANEL_TITLE", self.MissionPanel:Title());
            for k, item in pairs(self.MissionPanel.Items) do
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSION_PANEL_ITEM", item.Type, item.TextLeft,
                    item.TextRight, item.Icon or 0, item.IconColor or SColor.HUD_Pure_white, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID)
            end
        end
    end

    while self.SettingsColumn ~= nil and self.SettingsColumn._isBuilding or self.PlayerColumn ~= nil and self.PlayerColumn._isBuilding or self.MissionsColumn ~= nil and self.MissionsColumn._isBuilding do
        Citizen.Wait(0)
    end

    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("LOAD_MENU")
    Citizen.Wait(250)
    self:updateFocus(1)
    local containsPlayers = false

    for i,col in pairs(self.listCol) do
        if col.Type == "players" then
            containsPlayers = true
            break
        end
    end
    if self.listCol[1].Type == "players" or (containsPlayers and self.PlayersColumn.Items[1]:KeepPanelVisible()) then
        if self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= nil and self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
            self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
        end
    end
    self._isBuilding = false
end

function MainView:buildSettings(tab, tabIndex)
    Citizen.CreateThread(function()
        self.SettingsColumn._isBuilding = true
        local i = 1
        local max = self.SettingsColumn.Pagination:ItemsPerPage()
        if #self.SettingsColumn.Items < max then
            max = #self.SettingsColumn.Items
        end
        self.SettingsColumn.Pagination:MinItem(self.SettingsColumn.Pagination:CurrentPageStartIndex())

        if self.SettingsColumn.scrollingType == MenuScrollingType.CLASSIC and self.SettingsColumn.Pagination:TotalPages() > 1 then
            local missingItems = self.SettingsColumn.Pagination:GetMissingItems()
            if missingItems > 0 then
                self.SettingsColumn.Pagination:ScaleformIndex(self.SettingsColumn.Pagination:GetPageIndexFromMenuIndex(self.SettingsColumn.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                self.SettingsColumn.Pagination.minItem = self.SettingsColumn.Pagination:CurrentPageStartIndex() - missingItems
            end
        end

        self.SettingsColumn.Pagination:MaxItem(self.SettingsColumn.Pagination:CurrentPageEndIndex())

        while i <= max do
            Citizen.Wait(0)
            if not self:Visible() then return end
            self.SettingsColumn:_itemCreation(self.SettingsColumn.Pagination:CurrentPage(), i, false, true)
            i = i + 1
        end

        self.SettingsColumn:CurrentSelection(1)
        self.SettingsColumn.Pagination:ScaleformIndex(self.SettingsColumn.Pagination:GetScaleformIndex(self.SettingsColumn:CurrentSelection()))
        self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()]:Selected(false)

        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", self.SettingsColumn.Pagination:GetScaleformIndex(self.SettingsColumn.Pagination:CurrentMenuIndex()))
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_QTTY", self.SettingsColumn:CurrentSelection(), #self.SettingsColumn.Items)

        local Item = self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()]
        local _, subtype = Item()
        if subtype == "UIMenuSeparatorItem" then
            if (self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()].Jumpable) then
                self.SettingsColumn:GoDown()
            end
        end

        self.SettingsColumn._isBuilding = false
    end)
end

function MainView:buildPlayers(tab, tabIndex)
    Citizen.CreateThread(function()
        self.PlayersColumn._isBuilding = true
        local i = 1
        local max = self.PlayersColumn.Pagination:ItemsPerPage()
        if #self.PlayersColumn.Items < max then
            max = #self.PlayersColumn.Items
        end
        self.PlayersColumn.Pagination:MinItem(self.PlayersColumn.Pagination:CurrentPageStartIndex())

        if self.PlayersColumn.scrollingType == MenuScrollingType.CLASSIC and self.PlayersColumn.Pagination:TotalPages() > 1 then
            local missingItems = self.PlayersColumn.Pagination:GetMissingItems()
            if missingItems > 0 then
                self.PlayersColumn.Pagination:ScaleformIndex(self.PlayersColumn.Pagination:GetPageIndexFromMenuIndex(self.PlayersColumn.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                self.PlayersColumn.Pagination.minItem = self.PlayersColumn.Pagination:CurrentPageStartIndex() - missingItems
            end
        end

        self.PlayersColumn.Pagination:MaxItem(self.PlayersColumn.Pagination:CurrentPageEndIndex())

        while i <= max do
            Citizen.Wait(0)
            if not self:Visible() then return end
            self.PlayersColumn:_itemCreation(self.PlayersColumn.Pagination:CurrentPage(), i, false, true)
            i = i + 1
        end

        self.PlayersColumn:CurrentSelection(1)
        self.PlayersColumn.Pagination:ScaleformIndex(self.PlayersColumn.Pagination:GetScaleformIndex(self.PlayersColumn:CurrentSelection()))
        self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:Selected(false)

        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYERS_SELECTION", self.PlayersColumn.Pagination:GetScaleformIndex(self.PlayersColumn.Pagination:CurrentMenuIndex()))
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYERS_QTTY", self.PlayersColumn:CurrentSelection(), #self.PlayersColumn.Items)

        self.PlayersColumn._isBuilding = false
    end)
end

function MainView:buildMissions(tab, tabIndex)
    Citizen.CreateThread(function()
        self.MissionsColumn._isBuilding = true
        local i = 1
        local max = self.MissionsColumn.Pagination:ItemsPerPage()
        if #self.MissionsColumn.Items < max then
            max = #self.MissionsColumn.Items
        end
        self.MissionsColumn.Pagination:MinItem(self.MissionsColumn.Pagination:CurrentPageStartIndex())

        if self.MissionsColumn.scrollingType == MenuScrollingType.CLASSIC and self.MissionsColumn.Pagination:TotalPages() > 1 then
            local missingItems = self.MissionsColumn.Pagination:GetMissingItems()
            if missingItems > 0 then
                self.MissionsColumn.Pagination:ScaleformIndex(self.MissionsColumn.Pagination:GetPageIndexFromMenuIndex(self.MissionsColumn.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                self.MissionsColumn.Pagination.minItem = self.MissionsColumn.Pagination:CurrentPageStartIndex() - missingItems
            end
        end

        self.MissionsColumn.Pagination:MaxItem(self.MissionsColumn.Pagination:CurrentPageEndIndex())

        while i <= max do
            Citizen.Wait(0)
            if not self:Visible() then return end
            self.MissionsColumn:_itemCreation(self.MissionsColumn.Pagination:CurrentPage(), i, false, true)
            i = i + 1
        end

        self.MissionsColumn:CurrentSelection(1)
        self.MissionsColumn.Pagination:ScaleformIndex(self.MissionsColumn.Pagination:GetScaleformIndex(self.MissionsColumn:CurrentSelection()))
        self.MissionsColumn.Items[self.MissionsColumn:CurrentSelection()]:Selected(false)

        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", self.MissionsColumn.Pagination:GetScaleformIndex(self.MissionsColumn.Pagination:CurrentMenuIndex()))
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_QTTY", self.MissionsColumn:CurrentSelection(), #self.MissionsColumn.Items)

        self.MissionsColumn._isBuilding = false
    end)
end

function MainView:Draw()
    if not self:Visible() or self.TemporarilyHidden or self._isBuilding then
        return
    end
    DisableControlAction(0, 199, true)
    DisableControlAction(0, 200, true)
    DisableControlAction(1, 199, true)
    DisableControlAction(1, 200, true)
    DisableControlAction(2, 199, true)
    DisableControlAction(2, 200, true)
    ScaleformUI.Scaleforms._pauseMenu:Draw(true)
    if self._firstTick then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("FADE_IN")
        self._firstTick = false
    end
end

local success, event_type, context, item_id

function MainView:ProcessMouse()
    if not IsUsingKeyboard(2) then
        return
    end
    SetMouseCursorActiveThisFrame()
    SetInputExclusive(2, 239)
    SetInputExclusive(2, 240)
    SetInputExclusive(2, 237)
    SetInputExclusive(2, 238)

    success, event_type, context, item_id = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms._pauseMenu._lobby
        .handle)
    if success then
        if event_type == 5 then
            local foc = self:Focus()
            local curSel = 1
            if tab._newStyle then
                curSel = tab.listCol[foc]:CurrentSelection()
            end
            for k,v in pairs(self.listCol) do
                if v.Type == "settings" then
                    curSel = self.SettingsColumn:CurrentSelection()
                elseif v.Type == "missions" then
                    curSel = self.MissionsColumn:CurrentSelection()
                elseif v.Type == "players" then
                    curSel = self.PlayersColumn:CurrentSelection()
                end
            end
            if context+1 ~= foc then
                self.listCol[foc].Items[self.listCol[foc]:CurrentSelection()]:Selected(false)
                self:updateFocus(context+1, true)
                self.listCol[context+1]:CurrentSelection(self.listCol[context+1].Pagination:GetMenuIndexFromScaleformIndex(item_id-1))
                self.listCol[context+1].OnIndexChanged(self.listCol[context+1]:CurrentSelection())
                if curSel ~= self.listCol[context+1]:CurrentSelection() then
                    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                end
            else
                self.listCol[foc]:CurrentSelection(self.listCol[context+1].Pagination:GetMenuIndexFromScaleformIndex(item_id-1))
            end
            if foc == self:Focus() and curSel == self.listCol[context+1]:CurrentSelection() then
                self:Select()
            end
            return
        elseif event_type == 8 then
            self.listCol[context+1].Items[item_id]:Hovered(false)
        elseif event_type == 9 then
            self.listCol[context+1].Items[item_id]:Hovered(true)
        end
    end
end

function MainView:ProcessControl()
    if not self:Visible() or self.TemporarilyHidden then
        return
    end

    if (IsControlPressed(2, 172)) then
        if GlobalGameTimer - self._time > self._delay then
            self:ButtonDelay()
            Citizen.CreateThread(function()
                self:GoUp()
                return
            end)
        end
    end
    if (IsControlPressed(2, 173)) then
        if GlobalGameTimer - self._time > self._delay then
            self:ButtonDelay()
            Citizen.CreateThread(function()
                self:GoDown()
                return
            end)
        end
    end
    if (IsControlPressed(2, 174)) then
        if GlobalGameTimer - self._time > self._delay then
            self:ButtonDelay()
            Citizen.CreateThread(function()
                self:GoLeft()
                return
            end)
        end
    end
    if (IsControlPressed(2, 175)) then
        if GlobalGameTimer - self._time > self._delay then
            self:ButtonDelay()
            Citizen.CreateThread(function()
                self:GoRight()
                return
            end)
        end
    end

    if (IsControlJustPressed(2, 201)) then
        Citizen.CreateThread(function()
            self:Select()
        end)
    end
    if (IsDisabledControlJustReleased(2, 177)) then
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

    if (IsControlJustReleased(0, 172) or IsControlJustReleased(1, 172) or IsControlJustReleased(2, 172)) or
        (IsControlJustReleased(0, 173) or IsControlJustReleased(1, 173) or IsControlJustReleased(2, 173)) or
        (IsControlJustReleased(0, 174) or IsControlJustReleased(1, 174) or IsControlJustReleased(2, 174)) or
        (IsControlJustReleased(0, 175) or IsControlJustReleased(1, 175) or IsControlJustReleased(2, 175))
    then
        self._times = 0
        self._delay = 150
    end
end

function MainView:ButtonDelay()
    self._times = self._times + 1
    if self._times % 5 == 0 then
        self._delay = self._delay - 10
        if self._delay < 50 then
            self._delay = 50
        end
    end
    self._time = GlobalGameTimer
end

function MainView:Select()
    local retVal = ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunctionAsyncReturnString("SET_INPUT_EVENT", 16)

    local selection = self._focus
    if tab._newStyle then
        selection = 1
    end
    local splitted = Split(retVal, ",")
    if self.listCol[selection].Type == "settings" then
        local item = self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()]
        local type, subtype = item()
        if not item:Enabled() then
            PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            return
        end
        if subtype == "UIMenuCheckboxItem" then
            item:Checked(not item:Checked())
            item.OnCheckboxChanged(nil, item, item:Checked())
        elseif subtype == "UIMenuListItem" then
            item.OnListSelected(nil, item, item._Index)
            self.SettingsColumn.OnSettingItemActivated(self.SettingsColumn:CurrentSelection())
        elseif subtype == "UIMenuSliderItem" then
            item.OnSliderSelected(nil, item, item._Index)
            self.SettingsColumn.OnSettingItemActivated(self.SettingsColumn:CurrentSelection())
        elseif subtype == "UIMenuProgressItem" then
            item.OnProgressSelected(nil, item, item._Index)
            self.SettingsColumn.OnSettingItemActivated(self.SettingsColumn:CurrentSelection())
        else
            item.Activated(nil, item)
            self.SettingsColumn.OnSettingItemActivated(self.SettingsColumn:CurrentSelection())
        end
    elseif self.listCol[selection].Type == "players" then
        self.PlayersColumn.OnPlayerItemActivated(self.PlayersColumn:CurrentSelection())
    elseif self.listCol[selection].Type == "missions" then
        self.MissionsColumn.OnMissionItemActivated(self.MissionsColumn:CurrentSelection())
    end
end

function MainView:GoBack()
    if self._newStyle then
        if self:CanPlayerCloseMenu() then
            self:Visible(false)
        end
    else
        self.listCol[self._focus].Items[self.listCol[self._focus]:CurrentSelection()]:Selected(false)
        if self._focus > 1 then
            if self:CanPlayerCloseMenu() then
                self:Visible(false)
            end
            return
        end
        self:updateFocus(self._focus - 1)
    end
end

function MainView:GoUp()
    self.listCol[self._focus]:GoUp()
end

function MainView:GoDown()
    self.listCol[self._focus]:GoDown()
end

function MainView:GoLeft()
    local retVal = ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunctionAsyncReturnString("SET_INPUT_EVENT", 10, self._delay)

    local splitted = Split(retVal, ",")

    if self._newStyle then
        for k,v in pairs(self.listCol) do
            if v.Type == "settings" then
                self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()]:Selected(false)
            elseif v.Type == "missions" then
                self.MissionsColumn.Items[self.MissionsColumn:CurrentSelection()]:Selected(false)
            elseif v.Type == "players" then
                self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:Selected(false)
                if k == 1 or self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:KeepPanelVisible() then
                    if self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= nil and self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
                        self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
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

    if self.listCol[self._focus].Type == "settings" then
        ClearPedInPauseMenu();
        local item = self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()];
        if not item:Enabled() then
            if self._newStyle then
                item:Selected(false)
                self:updateFocus(self._focus - 1)
            else
                PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
            return
        end
        local type, subtype = item()
        if subtype == "UIMenuListItem" then
            item:Index(tonumber(splitted[3]))
            item.OnListChanged(self, item, item._Index)
        elseif subtype == "UIMenuSliderItem" then
            item:Index(tonumber(splitted[3]))
            item.OnSliderChanged(self, item, item._Index)
        elseif subtype == "UIMenuProgressItem" then
            item:Index(tonumber(splitted[3]))
            item.OnProgressChanged(self, item, item:Index())
        else
            if self._newStyle then
                item:Selected(false)
                self:updateFocus(self._focus - 1)
            end
        end
    elseif self.listCol[self._focus].Type == "players" then
        if self._newStyle then
            self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()]:Selected(false)
            self:updateFocus(self._focus - 1)
        else
            if self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= nil and self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
                self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
            end
        end
    elseif self.listCol[self._focus].Type == "missions" then
        if self._newStyle then
            self.MissionsColumn.Items[self.MissionsColumn:CurrentSelection()]:Selected(false)
            self:updateFocus(self._focus - 1)
        end
    elseif self.listCol[self._focus].Type == "panel" then
        self:updateFocus(self._focus - 1)
    end
end

function MainView:GoRight()
    local retVal = ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunctionAsyncReturnString("SET_INPUT_EVENT", 11, self._delay)

    local splitted = Split(retVal, ",")

    if self._newStyle then
        for k,v in pairs(self.listCol) do
            if v.Type == "settings" then
                self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()]:Selected(false)
            elseif v.Type == "missions" then
                self.MissionsColumn.Items[self.MissionsColumn:CurrentSelection()]:Selected(false)
            elseif v.Type == "players" then
                self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:Selected(false)
                if k == 1 or self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:KeepPanelVisible() then
                    if self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= nil and self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
                        self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
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

    if self.listCol[self._focus].Type == "settings" then
        ClearPedInPauseMenu();
        local item = self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()];
        if not item:Enabled() then
            if self._newStyle then
                item:Selected(false)
                self:updateFocus(self._focus + 1)
            else
                PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
           return
        end
        local type, subtype = item()
        if subtype == "UIMenuListItem" then
            item:Index(tonumber(splitted[3]))
            item.OnListChanged(self, item, item._Index)
        elseif subtype == "UIMenuSliderItem" then
            item:Index(tonumber(splitted[3]))
            item.OnSliderChanged(self, item, item._Index)
        elseif subtype == "UIMenuProgressItem" then
            item:Index(tonumber(splitted[3]))
            item.OnProgressChanged(self, item, item:Index())
        else
            if self._newStyle then
                item:Selected(false)
                self:updateFocus(self._focus + 1)
            end
        end
    elseif self.listCol[self._focus].Type == "players" then
        if self._newStyle then
            self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()]:Selected(false)
            self:updateFocus(self._focus + 1)
        else
            if self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= nil and self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()].ClonePed ~= 0 then
                self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:AddPedToPauseMenu()
            end
        end
    elseif self.listCol[self._focus].Type == "missions" then
        if self._newStyle then
            self.MissionsColumn.Items[self.MissionsColumn:CurrentSelection()]:Selected(false)
            self:updateFocus(self._focus + 1)
        end
    elseif self.listCol[self._focus].Type == "panel" then
        self:updateFocus(self._focus + 1)
    end
end
