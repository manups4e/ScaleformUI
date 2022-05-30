MainView = setmetatable({}, MainView)
MainView.__index = MainView
MainView.__call = function()
    return "PauseMenu"
end

function MainView.New(title, subtitle, sideTop, sideMid, sideBot)
    local _data = {
        Title = title or "",
        Subtitle = subtitle or "",
        SideTop = sideTop or "",
        SideMid = sideMid or "",
        SideBot = sideBot or "",
        _headerPicture = {},
        _crewPicture = {},
        _visible = false,
        _internalpool = nil,
        SettingsColumn = {},
        PlayersColumn = {},
        MissionPanel = {},
        focusLevel = 0,
        TemporarilyHidden = false,
        controller = false,
        _loaded = false,
        _timer = 0,
        _time = 0,
        _times = 0,
        _delay = 150,
        _listCol = {},
        _firstTick = true,
        _canHe = true,
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

function MainView:FocusLevel(index)
    if index ~= nil then
        self.focusLevel = index
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_FOCUS", false, index-1)
    else
        return self.focusLevel
    end
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
        ScaleformUI.Scaleforms.InstructionalButtons:Enabled(visible)
        ScaleformUI.Scaleforms._pauseMenu:Visible(visible)
        if visible == true then
            self:BuildPauseMenu()
            self.OnLobbyMenuOpen(self)
            DontRenderInGameUi(true)
            AnimpostfxPlay("PauseMenuIn", 800, true)
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(self.InstructionalButtons)
            SetPlayerControl(PlayerId(), false, 0)
            self._firstTick = true
            self._internalpool:ProcessMenus(true)
        else
            ScaleformUI.Scaleforms._pauseMenu:Dispose()
            DontRenderInGameUi(false)
            AnimpostfxStop("PauseMenuIn")
            AnimpostfxPlay("PauseMenuOut", 800, false)
            self.OnLobbyMenuClose(self)
            SetPlayerControl(PlayerId(), true, 0)
            self._internalpool:ProcessMenus(false)
        end
    else
        return self._visible
    end
end

function MainView:HeaderPicture(Txd, Txn)
    if(Txd ~= nil and Txn ~= nil) then
        self._headerPicture = {txd = Txd, txn = Txn}
    else
        return self._headerPicture
    end
end
function MainView:CrewPicture(Txd, Txn)
    if(Txd ~= nil and Txn ~= nil) then
        self._crewPicture = {txd = Txd, txn = Txn}
    else
        return self._crewPicture
    end
end

function MainView:SetupColumns(columns)
    assert(type(columns) == "table", "^1ScaleformUI [ERROR]: SetupColumns, Table expected^7")
    assert(#columns == 3, "^1ScaleformUI [ERROR]: SetupColumns, you must add 3 columns^7")
    self._listCol = columns
    for k,v in ipairs(columns) do
        local _, subT = v()
        if subT == "SettingsListColumn" then
            self.SettingsColumn = v
            self.SettingsColumn.Parent = self
            self.SettingsColumn.Order = k
        elseif subT == "PlayerListColumn" then
            self.PlayersColumn = v
            self.PlayersColumn.Parent = self
            self.PlayersColumn.Order = k
        elseif subT == "MissionDetailsPanel" then
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
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderTitle(self.Title, self.Subtitle)
    end
    if (self:HeaderPicture() ~= nil) then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderCharImg(self:HeaderPicture().txd, self:HeaderPicture().txn, true)
    end
    if (self:CrewPicture() ~= nil) then
        ScaleformUI.Scaleforms._pauseMenu:SetHeaderSecondaryImg(self:CrewPicture().txd, self:CrewPicture().txn, true)
    end
    ScaleformUI.Scaleforms._pauseMenu:SetHeaderDetails(self.SideTop, self.SideMid, self.SideBot)
    ScaleformUI.Scaleforms._pauseMenu:AddLobbyMenuTab(self._listCol[1]._label, 2, 0, self._listCol[1]._color)
    ScaleformUI.Scaleforms._pauseMenu:AddLobbyMenuTab(self._listCol[2]._label, 2, 0, self._listCol[2]._color)
    ScaleformUI.Scaleforms._pauseMenu:AddLobbyMenuTab(self._listCol[3]._label, 2, 0, self._listCol[3]._color)
    ScaleformUI.Scaleforms._pauseMenu._header:CallFunction("SET_ALL_HIGHLIGHTS", false, true, 117);
    self._loaded = true
end

function MainView:BuildPauseMenu()
    self:ShowHeader()
    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CREATE_MENU", false, self.SettingsColumn.Order-1, self.PlayersColumn.Order-1, self.MissionPanel.Order-1);
    Citizen.CreateThread(function()
        local items = self.SettingsColumn.Items
        local it = 1
        while it <= #items do
            Citizen.Wait(1)
            local item = items[it]
            local Type, SubType = item()
            AddTextEntry("menu_lobby_desc_{" .. it .."}", item:Description())
    
            if SubType == "UIMenuListItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 1, item:Label(), "menu_lobby_desc_{" .. it .."}", item:Enabled(), item:BlinkDescription(), table.concat(item.Items, ","), item:Index()-1, item.Base._mainColor, item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor)
            elseif SubType == "UIMenuCheckboxItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 2, item:Label(), "menu_lobby_desc_{" .. it .."}", item:Enabled(), item:BlinkDescription(), item.CheckBoxStyle, item._Checked, item.Base._mainColor, item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor)
            elseif SubType == "UIMenuSliderItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 3, item:Label(), "menu_lobby_desc_{" .. it .."}", item:Enabled(), item:BlinkDescription(), item._Max, item._Multiplier, item:Index(), item.Base._mainColor, item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor, item.SliderColor, item._heritage)
            elseif SubType == "UIMenuProgressItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 4, item:Label(), "menu_lobby_desc_{" .. it .."}", item:Enabled(), item:BlinkDescription(), item._Max, item._Multiplier, item:Index(), item.Base._mainColor, item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor, item.SliderColor)
            else
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 0, item:Label(), "menu_lobby_desc_{" .. it .."}", item:Enabled(), item:BlinkDescription(), item._mainColor, item._highlightColor, item._textColor, item._highlightedTextColor)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SETTINGS_SET_RIGHT_LABEL", false, it - 1, item:RightLabel())
                if item._rightBadge ~= BadgeStyle.NONE then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SETTINGS_SET_RIGHT_BADGE", false, it - 1, item._rightBadge)
                end
            end
        
            if (SubType == "UIMenuItem" and item._leftBadge ~= BadgeStyle.NONE) or (SubType ~= "UIMenuItem" and item.Base._leftBadge ~= BadgeStyle.NONE) then
                if SubType ~= "UIMenuItem" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SETTINGS_SET_LEFT_BADGE", false, it - 1, item.Base._leftBadge)
                else
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SETTINGS_SET_LEFT_BADGE", false, it - 1, item._leftBadge)
                end
            end
    
            it = it+1
        end
        self.SettingsColumn:CurrentSelection(0)
    end)
    Citizen.CreateThread(function()
        local items = self.PlayersColumn.Items
        local it = 1
        while it <= #items do
            Citizen.Wait(1)
            local item = items[it]
            local Type, SubType = item()
            if SubType == "FriendItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_PLAYER_ITEM", false, 1, 1, item:Label(), item:ItemColor(), item:ColoredTag(), item._iconL, item._boolL, item._iconR, item._boolR, item:Status(), item:StatusColor(), item:Rank(), item:CrewTag());
            end
            if item.Panel ~= nil then
                item.Panel:UpdatePanel(true)
            end
            it = it+1
        end
        self.PlayersColumn:CurrentSelection(0)
    end)
    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSION_PANEL_PICTURE", false, self.MissionPanel.TextureDict, self.MissionPanel.TextureName);
    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSION_PANEL_TITLE", false, self.MissionPanel:Title());
    for k,item in pairs(self.MissionPanel.Items) do
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSION_PANEL_ITEM", false, item.Type, item.TextLeft, item.TextRight, item.Icon, item.IconColor, item.Tick);
    end
end

function MainView:Draw()
    if not self:Visible() or self.TemporarilyHidden then
        return 
    end
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

    success, event_type, context, item_id = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms._pauseMenu._lobby.handle)
    if success then
        if event_type == 5 then
            if self.focusLevel ~= context+1 then
                self:FocusLevel(context + 1)
            end
            local col = self._listCol[context+1]
            local Type, SubType = col()
            if SubType == "SettingsListColumn" then
                for k,v in pairs(self.PlayersColumn.Items) do v:Selected(false) end
                if not col.Items[col:CurrentSelection()]:Enabled() then
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    return
                end
                if col.Items[item_id+1]:Selected() then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", false, 16)
                    local item = col.Items[item_id+1]
                    local _type, _subType = item()
                    if _subType == "UIMenuCheckboxItem" then
                        item:Checked(not item:Checked())
                        item.OnCheckboxChanged(nil, item, item:Checked())
                    elseif _subType == "UIMenuItem" then
                       item.Activated(nil, item)
                    end
                    return
                end
                col:CurrentSelection(item_id)
                col.OnIndexChanged(item_id+1)
            elseif SubType == "PlayerListColumn" then
                for k,v in pairs(self.SettingsColumn.Items) do v:Selected(false) end
                if not col.Items[col:CurrentSelection()]:Enabled() then
                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    return
                end
                if col.Items[item_id+1]:Selected() then
                    return
                end
                col:CurrentSelection(item_id)
                col.OnIndexChanged(item_id+1)
            end
        end
    end
end

function MainView:ProcessControl()
    if not self:Visible() or self.TemporarilyHidden then
        return 
    end

    if (IsControlPressed(2, 172)) then
        if GetGameTimer() - self._time > self._delay then
            self:ButtonDelay()
            Citizen.CreateThread(function()
                self:GoUp()
                return
            end)
        end
    end
    if (IsControlPressed(2, 173)) then
        if GetGameTimer() - self._time > self._delay then
            self:ButtonDelay()
            Citizen.CreateThread(function()
                self:GoDown()
                return
            end)
        end
    end
    if (IsControlPressed(2, 174)) then
        if GetGameTimer() - self._time > self._delay then
            self:ButtonDelay()
            Citizen.CreateThread(function()
                self:GoLeft()
                return
            end)
        end
    end
    if (IsControlPressed(2, 175)) then
        if GetGameTimer() - self._time > self._delay then
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
    if (IsDisabledControlJustPressed(2, 177)) then
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
    self._time = GetGameTimer()
end

function MainView:Select()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", true, 16)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueString(return_value)

    local splitted = split(retVal, ",")
    if self:FocusLevel() == self.SettingsColumn.Order then
        local item = self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()]
        local type, subtype = item()
        if not item:Enabled() then
            PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            return   
        end
        if subtype == "UIMenuCheckboxItem" then
            item:Checked(not item:Checked())
            item.OnCheckboxChanged(nil, item, item:Checked())
        else
            item.Activated(nil, item)
        end
    elseif self:FocusLevel() == self.PlayersColumn.Order then
    end
end

function MainView:GoBack()
    if self:CanPlayerCloseMenu() then
        PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        self:Visible(false)
    end
end

function MainView:GoUp()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", true, 8,self._delay)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueString(return_value)

    local splitted = split(retVal, ",")

    if self:FocusLevel() == self.SettingsColumn.Order then
        self.SettingsColumn:CurrentSelection(tonumber(splitted[2]))
        self.SettingsColumn.OnIndexChanged(self.SettingsColumn:CurrentSelection())
    elseif self:FocusLevel() == self.PlayersColumn.Order then
        self.PlayersColumn:CurrentSelection(tonumber(splitted[2]))
        self.PlayersColumn.OnIndexChanged(self.PlayersColumn:CurrentSelection())
    end
end

function MainView:GoDown()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", true, 9,self._delay)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueString(return_value)

    local splitted = split(retVal, ",")

    if self:FocusLevel() == self.SettingsColumn.Order then
        self.SettingsColumn:CurrentSelection(tonumber(splitted[2]))
        self.SettingsColumn.OnIndexChanged(self.SettingsColumn:CurrentSelection())
    elseif self:FocusLevel() == self.PlayersColumn.Order then
        self.PlayersColumn:CurrentSelection(tonumber(splitted[2]))
        self.PlayersColumn.OnIndexChanged(self.PlayersColumn:CurrentSelection())
    end
end

function MainView:GoLeft()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", true, 10,self._delay)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueString(return_value)

    local splitted = split(retVal, ",")

    if tonumber(splitted[3]) == -1 then
        self:FocusLevel(tonumber(splitted[1])+1)
        if self:FocusLevel() == self.SettingsColumn.Order then
            self.SettingsColumn:CurrentSelection(tonumber(splitted[2]))
            self.SettingsColumn.OnIndexChanged(self.SettingsColumn:CurrentSelection());
        elseif self:FocusLevel() == self.PlayersColumn.Order then
            self.PlayersColumn:CurrentSelection(tonumber(splitted[2]))
        self.PlayersColumn.OnIndexChanged(self.PlayersColumn:CurrentSelection())
        end
    else
        local item = self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()];
        if not item:Enabled() then
            PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
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
        end
        --PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end

function MainView:GoRight()
    local return_value = ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", true, 11,self._delay)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    local retVal = GetScaleformMovieMethodReturnValueString(return_value)

    local splitted = split(retVal, ",")

    if tonumber(splitted[3]) == -1 then
        self:FocusLevel(tonumber(splitted[1])+1)
        if self:FocusLevel() == self.SettingsColumn.Order then
            self.SettingsColumn:CurrentSelection(tonumber(splitted[2]))
            self.SettingsColumn.OnIndexChanged(self.SettingsColumn:CurrentSelection());
        elseif self:FocusLevel() == self.PlayersColumn.Order then
            self.PlayersColumn:CurrentSelection(tonumber(splitted[2]))
            self.PlayersColumn.OnIndexChanged(self.PlayersColumn:CurrentSelection())
        end
    else
        local item = self.SettingsColumn.Items[self.SettingsColumn:CurrentSelection()];
        if not item:Enabled() then
            PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
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
        end
        --PlaySoundFrontend(-1, self.Settings.Audio.LeftRight, "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end