local pool = MenuPool.New()
lobbyMenu = nil

local currentColumnId = 1
local currentSelectId = 1

local ColumnCallbackFunction = {}
ColumnCallbackFunction[1] = {}
ColumnCallbackFunction[2] = {}

local menuLoaded = false
local firstLoad = true
local function CreateLobbyMenu()
    if not lobbyMenu then
        lobbyMenu = MainView.New("name", "dec", "", "", "")
        local columns = {
            SettingsListColumn.New("COLUMN SETTINGS", Colours.HUD_COLOUR_RED),
            PlayerListColumn.New("COLUMN PLAYERS", Colours.HUD_COLOUR_ORANGE),
            MissionDetailsPanel.New("COLUMN INFO PANEL", Colours.HUD_COLOUR_GREEN),
        }
        lobbyMenu:SetupColumns(columns)
        
        CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd('ScaleformUI_Lua_duiTxd'), "LobbyHeadshot", GetDuiHandle(CreateDui("https://static.wikia.nocookie.net/gtawiki/images/4/4a/45%C2%B0-GTAO-JobImage.jpg/revision/latest?cb=20190216233424", 320, 180)))
        local mugshot = RegisterPedheadshot(PlayerPedId())
        local timer = GetGameTimer()
        while not IsPedheadshotReady(mugshot) and GetGameTimer() - timer < 1000 do
            Citizen.Wait(0)
        end
        local headshot = GetPedheadshotTxdString(mugshot)
        AddReplaceTexture("ScaleformUI_Lua_duiTxd", "LobbyHeadshot", headshot, headshot)
        lobbyMenu:HeaderPicture("ScaleformUI_Lua_duiTxd", "LobbyHeadshot") -- lobbyMenu:CrewPicture used to add a picture on the left of the HeaderPicture
        UnregisterPedheadshot(mugshot) -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform.. 
        
        pool:AddPauseMenu(lobbyMenu)
        lobbyMenu:CanPlayerCloseMenu(true)
        
        local item = UIMenuItem.New("UIMenuItem", "UIMenuItem description")
        lobbyMenu.SettingsColumn:AddSettings(item)
        
        lobbyMenu.MissionPanel:UpdatePanelPicture("scaleformui", "lobby_panelbackground")
        lobbyMenu.MissionPanel:Title("ScaleformUI - Title")
        
        local detailItem = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, Colours.HUD_COLOUR_FREEMODE)
        lobbyMenu.MissionPanel:AddItem(detailItem)
        
        local friend = FriendItem.New("", 0, 116, 0, 0, "")
        lobbyMenu.PlayersColumn:AddPlayer(friend)

        lobbyMenu.SettingsColumn.OnIndexChanged = function(idx)
            currentSelectId = idx
            currentColumnId = 1
        end

        lobbyMenu.PlayersColumn.OnIndexChanged = function(idx)
            currentSelectId = idx
            currentColumnId = 2
        end
        Wait(100)
        menuLoaded = true
        Wait(100)
        firstLoad = false
    end
end

local DataSetHeaderMenu = {}
AddEventHandler("ScaleformUI_Lua:lobbymenu:SetHeaderMenu", function(data)
    while not menuLoaded do
        Wait(0)
    end
    
    local isChange = false
    for k,v in pairs(data) do
        if not DataSetHeaderMenu[k] then
            isChange = true
            break
        else
            if DataSetHeaderMenu[k] and DataSetHeaderMenu[k] ~= v then
                isChange = true
                break
            end
            if isChange then
                break
            end
            if isChange then
                break
            end
        end
    end
    
    if isChange then
        print("ScaleformUI_Lua:lobbymenu:SetHeaderMenu")
        
        if data.Title then
            lobbyMenu.Title = data.Title
        end
        
        if data.Subtitle then
            lobbyMenu.Subtitle = data.Subtitle
        end
        
        if data.SideTop then
            lobbyMenu.SideTop = data.SideTop
        end
        
        if data.SideMid then
            lobbyMenu.SideMid = data.SideMid
        end
        
        if data.SideBot then
            lobbyMenu.SideBot = data.SideBot
        end
        
        if data.Col1 then
            lobbyMenu._listCol[1]._label = data.Col1
        end
        
        if data.Col2 then
            lobbyMenu._listCol[2]._label = data.Col2
        end
        
        if data.Col3 then
            lobbyMenu._listCol[3]._label = data.Col3
        end
        
        if data.ColColor1 then
            lobbyMenu._listCol[1]._color = data.ColColor1
        end
        
        if data.ColColor2 then
            lobbyMenu._listCol[2]._color = data.ColColor2
        end
        
        if data.ColColor3 then
            lobbyMenu._listCol[3]._color = data.ColColor3
        end
        
        DataSetHeaderMenu = data
    end
end)

local DataPlayerList = {}
local DataPlayerListUnsort = {}
AddEventHandler("ScaleformUI_Lua:lobbymenu:SetPlayerList", function(data)
    while not menuLoaded do
        Wait(0)
    end
    
    local isChange = false
    local temp = table.deepcopy(data)
    table.sort(temp, function(a,b)
        return a.name < b.name
    end)
    for k,v in pairs(temp) do
        if not DataPlayerListUnsort[k] then
            isChange = true
            break
        else
            for kk,vv in pairs(v) do
                if kk ~= "callbackFunction" and kk ~= "ped" and DataPlayerListUnsort[k][kk] and DataPlayerListUnsort[k][kk] ~= vv then
                    isChange = true
                    break
                end
            end
            if isChange then
                break
            end
        end
    end

    if isChange then
        print("ScaleformUI_Lua:lobbymenu:SetPlayerList")
        DataPlayerListUnsort = table.deepcopy(data)
        table.sort(DataPlayerListUnsort, function(a,b)
            return a.name < b.name
        end)
        
        local HostSource = -1
        for k,v in pairs(data) do
            if v.LobbyBadgeIcon == 66 then -- JoinAsSpectatorMode
                v.sortOrder = 3
            elseif v.ped then
                v.sortOrder = 2
            else
                v.sortOrder = 4
            end
        end
        table.sort(data, function(a,b)
            return a.sortOrder < b.sortOrder
        end)
        
        ColumnCallbackFunction[2] = {}
        
        for i=1, #lobbyMenu.PlayersColumn.Items do
            lobbyMenu.PlayersColumn:RemovePlayer(#lobbyMenu.PlayersColumn.Items)
            Wait(0)
        end
        Wait(1)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for k,v in pairs(data) do
            local Status = v.Status
            local Colours = v.Colours
            if HostSource == v.source then
                Status = "HOST"
                Colours = 116
            end
            
            if GetPlayerFromServerId(v.source) ~= -1 then
                v.MP0_STAMINA = Player(v.source).state.ScaleformUI_Lua_MP0_STAMINA or 0
                v.MP0_STRENGTH = Player(v.source).state.ScaleformUI_Lua_MP0_STRENGTH or 0
                v.MP0_LUNG_CAPACITY = Player(v.source).state.ScaleformUI_Lua_MP0_LUNG_CAPACITY or 0
                v.MP0_SHOOTING_ABILITY = Player(v.source).state.ScaleformUI_Lua_MP0_SHOOTING_ABILITY or 0
                v.MP0_DRIVING_ABILITY = Player(v.source).state.ScaleformUI_Lua_MP0_WHEELIE_ABILITY or 0
                v.MP0_WHEELIE_ABILITY = Player(v.source).state.ScaleformUI_Lua_MP0_WHEELIE_ABILITY or 0
                v.MP0_FLYING_ABILITY = Player(v.source).state.ScaleformUI_Lua_MP0_FLYING_ABILITY or 0
                v.MP0_STEALTH_ABILITY = Player(v.source).state.ScaleformUI_Lua_MP0_STEALTH_ABILITY or 0
                v.MPPLY_KILLS_PLAYERS = Player(v.source).state.ScaleformUI_Lua_MP0_HIGHEST_MENTAL_STATE or 0
            else
                v.MP0_STAMINA = GetRandomIntInRange(10, 100)
                v.MP0_STRENGTH = GetRandomIntInRange(10, 100)
                v.MP0_LUNG_CAPACITY = GetRandomIntInRange(10, 100)
                v.MP0_SHOOTING_ABILITY = GetRandomIntInRange(10, 100)
                v.MP0_DRIVING_ABILITY = GetRandomIntInRange(10, 100)
                v.MP0_WHEELIE_ABILITY = GetRandomIntInRange(10, 100)
                v.MP0_FLYING_ABILITY = GetRandomIntInRange(10, 100)
                v.MP0_STEALTH_ABILITY = GetRandomIntInRange(10, 100)
                v.MPPLY_KILLS_PLAYERS = GetRandomIntInRange(10, 100)
            end
            v.HasPlane = IsPedInAnyPlane(v.ped)
            v.HasHeli = IsPedInAnyHeli(v.ped)
            v.HasBoat = IsPedInAnyBoat(v.ped)
            v.HasVehicle = IsPedInAnyVehicle(v.ped)
                

            local LobbyBadge = 120
            if v.LobbyBadgeIcon then
                LobbyBadge = v.LobbyBadgeIcon
            elseif GetPlayerFromServerId(v.source) ~= -1 then
                if not Player(v.source).state.ScaleformUI_Lua_IsUsingKeyboard then
                    LobbyBadge = LobbyBadgeIcon.IS_CONSOLE_PLAYER
                end
            end
            
            local friend = FriendItem.New(v.name, Colours, v.rowColor, v.lev, Status, v.CrewTag)
            if v.ped then
                friend:SetLeftIcon(LobbyBadge, false)
                friend:AddPedToPauseMenu((v.ped or PlayerPedId())) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
                local panel = PlayerStatsPanel.New(v.name, v.rowColor)
                panel:Description("My name is "..v.name)
                panel:HasPlane(v.HasPlane)
                panel:HasHeli(v.HasHeli)
                panel:HasBoat(v.HasBoat)
                panel:HasVehicle(v.HasVehicle)
                panel.RankInfo:RankLevel(v.lev)
                panel.RankInfo:LowLabel("This is the low label")
                panel.RankInfo:MidLabel("This is the middle label")
                panel.RankInfo:UpLabel("This is the upper label")
                panel:AddStat(PlayerStatsPanelStatItem.New("Stamina", GetSkillStaminaDescription(v.MP0_STAMINA), v.MP0_STAMINA))
                panel:AddStat(PlayerStatsPanelStatItem.New("Shooting", GetSkillShootingDescription(v.MP0_SHOOTING_ABILITY), v.MP0_SHOOTING_ABILITY))
                panel:AddStat(PlayerStatsPanelStatItem.New("Strength", GetSkillStrengthDescription(v.MP0_STRENGTH), v.MP0_STRENGTH))
                panel:AddStat(PlayerStatsPanelStatItem.New("Stealth", GetSkillStealthDescription(v.MP0_STEALTH_ABILITY), v.MP0_STEALTH_ABILITY))
                panel:AddStat(PlayerStatsPanelStatItem.New("Driving", GetSkillDrivingDescription(v.MP0_DRIVING_ABILITY), v.MP0_DRIVING_ABILITY))
                panel:AddStat(PlayerStatsPanelStatItem.New("Flying", GetSkillFlyingDescription(v.MP0_FLYING_ABILITY), v.MP0_FLYING_ABILITY))
                panel:AddStat(PlayerStatsPanelStatItem.New("Mental State", GetSkillMentalStateDescription(v.MPPLY_KILLS_PLAYERS), v.MPPLY_KILLS_PLAYERS))
                friend:AddPanel(panel)
                friend:Enabled(true)
            else
                friend._iconR = 0
                friend._itemColor = 158
                friend:Enabled(false)
            end
            lobbyMenu.PlayersColumn:AddPlayer(friend)

            if v.callbackFunction then
                ColumnCallbackFunction[2][#lobbyMenu.PlayersColumn.Items] = v.callbackFunction
            end
        end
            
        DataPlayerList = table.deepcopy(data)
    end
end)

local DataSetInfo = {}
AddEventHandler("ScaleformUI_Lua:lobbymenu:SetInfo", function(data)
    while not menuLoaded do
        Wait(0)
    end
    
    local isChange = false
    for k,v in pairs(data) do
        if not DataSetInfo[k] then
            isChange = true
            break
        else
            for kk,vv in pairs(v) do
                if DataSetInfo[k][kk] and DataSetInfo[k][kk] ~= vv then
                    isChange = true
                    break
                end
            end
            if isChange then
                break
            end
        end
    end
    
    if isChange then
        print("ScaleformUI_Lua:lobbymenu:SetInfo")
    
        for i=1, #lobbyMenu.MissionPanel.Items do
            lobbyMenu.MissionPanel:RemoveItem(#lobbyMenu.MissionPanel.Items)
        end
        
        for k,v in pairs(data) do
            local detailItem = UIMenuFreemodeDetailsItem.New(v.LeftLabel, v.RightLabel, false, v.BadgeStyle, v.Colours)
            lobbyMenu.MissionPanel:AddItem(detailItem)
        end
        
        DataSetInfo = data
    end
end)

local DataSetInfoTitle = {}
AddEventHandler("ScaleformUI_Lua:lobbymenu:SetInfoTitle", function(data)
    while not menuLoaded do
        Wait(0)
    end
    
    local isChange = false
    for k,v in pairs(data) do
        if not DataSetInfoTitle[k] then
            isChange = true
            break
        else
            if DataSetInfoTitle[k] and DataSetInfoTitle[k] ~= v then
                isChange = true
                break
            end
            if isChange then
                break
            end
        end
    end
    
    if isChange then
        print("ScaleformUI_Lua:lobbymenu:SetInfoTitle")
        
        if data.Title then
            lobbyMenu.MissionPanel:Title(data.Title)
        end
        
        if data.tex and data.txd then
            lobbyMenu.MissionPanel:UpdatePanelPicture(data.tex, data.txd)
        end
        
        DataSetInfoTitle = data
    end
end)

local DataSettingsColumn = {}
AddEventHandler("ScaleformUI_Lua:lobbymenu:SettingsColumn", function(data)
    while not menuLoaded do
        Wait(0)
    end
    
    local isChange = false
    for k,v in pairs(data) do
        if not DataSettingsColumn[k] then
            isChange = true
            break
        else
            for kk,vv in pairs(v) do
                if kk ~= "callbackFunction" and DataSettingsColumn[k][kk] and DataSettingsColumn[k][kk] ~= vv then
                    isChange = true
                    break
                end
            end
            if isChange then
                break
            end
        end
    end
    
    if isChange then
        print("ScaleformUI_Lua:lobbymenu:SettingsColumn")
        
        ColumnCallbackFunction[1] = {}
        
        for i=1, #lobbyMenu.SettingsColumn.Items do
            lobbyMenu.SettingsColumn.Items[#lobbyMenu.SettingsColumn.Items] = nil
        end
        
        for k,v in pairs(data) do
            local item
            if v.type == "List" then
                item = UIMenuListItem.New(v.label, v.list, 0, v.dec, v.mainColor, v.highlightColor, v.textColor, v.highlightedTextColor)
            elseif v.type == "Checkbox" then
                item = UIMenuCheckboxItem.New(v.label, true, 1, v.dec)
            elseif v.type == "Slider" then
                item = UIMenuSliderItem.New(v.label, 100, 5, 50, false, v.dec)
            elseif v.type == "Progress" then
                item = UIMenuProgressItem.New(v.label, 10, 5, v.dec)
            else
                item = UIMenuItem.New(v.label, v.dec, v.mainColor, v.highlightColor, v.textColor, v.highlightedTextColor)
                if v.rightLabel then
                    item:RightLabel(v.rightLabel)
                end
            end
            lobbyMenu.SettingsColumn.Items[k] = item
            item:BlinkDescription(v.Blink)
            
            if v.callbackFunction then
                ColumnCallbackFunction[1][k] = v.callbackFunction
            end
        end
        
        DataSettingsColumn = data
    end
end)

AddEventHandler("ScaleformUI_Lua:lobbymenu:UpdateSettingsColumn", function(index, data)
    while not menuLoaded do
        Wait(0)
    end
    print("ScaleformUI_Lua:lobbymenu:UpdateSettingsColumn")
    
    ColumnCallbackFunction[1][index] = nil
    
    local item
    if data.type == "List" then
        item = UIMenuListItem.New(data.label, data.list, 0, data.dec)
    elseif data.type == "Checkbox" then
        item = UIMenuCheckboxItem.New(data.label, true, 1, data.dec)
    elseif data.type == "Slider" then
        item = UIMenuSliderItem.New(data.label, 100, 5, 50, false, data.dec)
    elseif data.type == "Progress" then
        item = UIMenuProgressItem.New(data.label, 10, 5, data.dec)
    else
        item = UIMenuItem.New(data.label, data.dec, data.mainColor, data.highlightColor, data.textColor, data.highlightedTextColor)
    end
    lobbyMenu.SettingsColumn.Items[index] = item
    item:BlinkDescription(data.Blink)
    
    if data.callbackFunction then
        ColumnCallbackFunction[1][index] = data.callbackFunction
    end
end)

AddEventHandler("ScaleformUI_Lua:lobbymenu:Show", function(FocusLevel, canclose, onClose)
    CreateLobbyMenu()
    
    while IsDisabledControlPressed(0, 199) or IsDisabledControlPressed(0, 200) do
        Wait(0)
    end
    
    while firstLoad do
        Wait(0)
    end
    
    if lobbyMenu:Visible() then
        lobbyMenu:Visible(false)
        -- Wait(100)
        while IsPauseMenuRestarting() or IsFrontendFading() or IsPauseMenuActive() do
            Wait(0)
        end
    end
    
    currentSelectId = 1
    currentColumnId = 1
    lobbyMenu:CanPlayerCloseMenu(canclose)

    lobbyMenu:Visible(true)
    lobbyMenu:FocusLevel(FocusLevel)
    ScaleformUI.Scaleforms.InstructionalButtons:Enabled(false)
    
    local instructional_buttons = Scaleform.Request("instructional_buttons")
    instructional_buttons:CallFunction("CLEAR_ALL")
    local buttonsID = 0
    instructional_buttons:CallFunction("SET_DATA_SLOT", buttonsID, GetControlInstructionalButton(1, 191, true), GetLabelText("HUD_INPUT2"))
    buttonsID = buttonsID+1
    if canclose then
        instructional_buttons:CallFunction("SET_DATA_SLOT", buttonsID, GetControlInstructionalButton(1, 194, true), GetLabelText("HUD_INPUT3"))
        buttonsID = buttonsID+1
    end
    instructional_buttons:CallFunction("SET_DATA_SLOT", buttonsID, "~INPUTGROUP_FRONTEND_DPAD_ALL~", GetLabelText("HUD_INPUT8"))
    buttonsID = buttonsID+1
    instructional_buttons:CallFunction("SET_BACKGROUND_COLOUR", 0, 0, 0, 80)
    instructional_buttons:CallFunction("DRAW_INSTRUCTIONAL_BUTTONS")
        
    while lobbyMenu:Visible() do
        SetScriptGfxDrawBehindPausemenu(true)
        instructional_buttons:Render2D()
        
        if IsDisabledControlJustPressed(0, 201) then
            if ColumnCallbackFunction[currentColumnId][currentSelectId] then
                ColumnCallbackFunction[currentColumnId][currentSelectId]()
            end
            
            if currentColumnId == 2 and DataPlayerList[currentSelectId] and DataPlayerList[currentSelectId].ped then
                lobbyMenu:Visible(false)
                
                while IsPauseMenuRestarting() or IsFrontendFading() or IsPauseMenuActive() do
                    Wait(0)
                end
                
                local settingList = {}
                table.insert(settingList, {
                    label = "Back",
                    dec = "",
                    callbackFunction = function()
                        playerMenu:Visible(false)
                    end,
                })
                TriggerEvent("ScaleformUI_Lua:playermenu:SettingsColumn", settingList)
                TriggerEvent("ScaleformUI_Lua:playermenu:SetInfo", DataSetInfo)
                TriggerEvent("ScaleformUI_Lua:playermenu:SetInfoTitle", {
                    Title = lobbyMenu.MissionPanel._title,
                    tex = lobbyMenu.MissionPanel.TextureDict,
                    txd = lobbyMenu.MissionPanel.TextureName,
                })
                TriggerEvent("ScaleformUI_Lua:playermenu:SetHeaderMenu", {
                    SideTop = lobbyMenu.SideTop,
                    SideMid = lobbyMenu.SideMid,
                    SideBot = lobbyMenu.SideBot,
                    ColColor1 = lobbyMenu._listCol[1]._color,
                    ColColor2 = lobbyMenu._listCol[2]._color,
                    ColColor3 = lobbyMenu._listCol[3]._color,
                })
                TriggerEvent("ScaleformUI_Lua:playermenu:SetPlayerList", DataPlayerList[currentSelectId], lobbyMenu.MissionPanel.TextureDict, lobbyMenu.MissionPanel.TextureName)
                
                TriggerEvent("ScaleformUI_Lua:playermenu:Show", 2, true, function()
                    print(111)
                    TriggerEvent("ScaleformUI_Lua:lobbymenu:Show", 1, true)
                end)
            end
        end
        Wait(0)
    end
    instructional_buttons:Dispose()
    
    if onClose then
        while IsPauseMenuRestarting() or IsFrontendFading() or IsPauseMenuActive() do
            Wait(0)
        end
        onClose()
    end
end)

AddEventHandler("ScaleformUI_Lua:lobbymenu:Hide", function()
    while not menuLoaded do
        Wait(0)
    end
    
    if lobbyMenu:Visible() then
        lobbyMenu:Visible(false)
    end
end)

--///////////////////////////////////////////////////////////--

RegisterCommand('ScaleformUILua_SetHeaderMenu', function(source, args) -- Use command before menu open.
    local WeekString = {
        [0] = "Sunday",
        [1] = "Monday",
        [2] = "Tuesday",
        [3] = "Wednesday",
        [4] = "Thursday",
        [5] = "Friday",
        [6] = "Saturday",
    }
    TriggerEvent("ScaleformUI_Lua:lobbymenu:SetHeaderMenu", {
        Title = "Lobby",
        Subtitle = "Racing",
        SideTop = GetPlayerName(PlayerId()),
        SideMid = WeekString[GetClockDayOfWeek()].." "..GetClockHours()..":"..GetClockMinutes(),
        SideBot = "BANK $"..NetworkGetVcBankBalance().." CASH $"..NetworkGetVcBalance(),
        Col1 = "🕹️  GAME",
        Col2 = "PLAYERS 1 OF 32",
        Col3 = "INFO",
        ColColor1 = 116,
        ColColor2 = 116,
        ColColor3 = 116,
    })
    
    CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd('ScaleformUI_Lua_duiTxd'), "stunt-45", GetDuiHandle(CreateDui("https://static.wikia.nocookie.net/gtawiki/images/4/4a/45%C2%B0-GTAO-JobImage.jpg/revision/latest?cb=20190216233424", 320, 180)))
    TriggerEvent("ScaleformUI_Lua:lobbymenu:SetInfoTitle", {
        Title = "Stunt - 45°",
        tex = "ScaleformUI_Lua_duiTxd",
        txd = "stunt-45"
    })
    
    local settingList = {
        {
            label = "Setting",
            dec = "Open game setting menu.",
            callbackFunction = function()
                TriggerEvent("ScaleformUI_Lua:lobbymenu:Hide")
                Wait(100)
                ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), false, 6)
            end,
        },
        {
            label = "Map",
            dec = "Open map menu.",
            callbackFunction = function()
                TriggerEvent("ScaleformUI_Lua:lobbymenu:Hide")
                Wait(100)
                ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), false, 0)
            end,
        },
        {
            label = "Leave Game",
            dec = "Leave current lobby.",
            callbackFunction = function()
                TriggerEvent("ScaleformUI_Lua:lobbymenu:Hide")
                ExecuteCommand("minigame leave")
            end,
            mainColor = 8,
            highlightColor = 6,
            textColor = 0,
            highlightedTextColor = 0,
            Blink = true,
        },
    }
    
    TriggerEvent("ScaleformUI_Lua:lobbymenu:SettingsColumn", settingList)
        
end, false)

RegisterCommand('ScaleformUILua_SetInfo', function(source, args) -- Use command before menu open.
    local infoList = {
        {
            LeftLabel = "Map",
            RightLabel = "Stunt - 45°",
            BadgeStyle = 179,
            Colours = false,
        },
        {
            LeftLabel = "Min Player",
            RightLabel = 1,
            BadgeStyle = 179,
            Colours = false,
        },
        {
            LeftLabel = "Time Left",
            RightLabel = "60 Minute",
            BadgeStyle = 179,
            Colours = false,
        },
    }
    TriggerEvent("ScaleformUI_Lua:lobbymenu:SetInfo", infoList)
end)

RegisterCommand('ScaleformUILua_SetPlayerList1', function(source, args) -- Can use command after menu open.
    local playerList = {}
    for i=1, 10 do
        table.insert(playerList, {
            source = GetPlayerServerId(PlayerId()),
            name = "Player "..i,
            rowColor = 116,
            Colours = 15,
            Status = "WAITING",
            CrewTag = "",
            lev = GetRandomIntInRange(1, 999),
            ped = PlayerPedId(),
        })
    end
    
    TriggerEvent("ScaleformUI_Lua:lobbymenu:SetPlayerList", playerList)
end)

RegisterCommand('ScaleformUILua_SetPlayerList2', function(source, args) -- Can use command after menu open.
    local playerList = {}
    for i=11, 20 do
        table.insert(playerList, {
            source = GetPlayerServerId(PlayerId()),
            name = "Player "..i,
            rowColor = 116,
            Colours = 18,
            Status = "PLAYING",
            CrewTag = "",
            lev = GetRandomIntInRange(1, 999),
            ped = PlayerPedId(),
        })
    end
    
    TriggerEvent("ScaleformUI_Lua:lobbymenu:SetPlayerList", playerList)
end)

RegisterCommand('ScaleformUILua_show', function(source, args) -- Use command before menu open.
    TriggerEvent("ScaleformUI_Lua:lobbymenu:Show", 1, true, function()
        print("lobbymenu close")
    end)
end, false)

--///////////////////////////////////////////////////////////--

function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GetSkillStaminaDescription(value)
    if value > 81 then
        return "Tri-Athlete"
    elseif value > 61 then
        return "Athlete"
    elseif value > 41 then
        return "Healthy"
    elseif value > 21 then
        return "Out of Shape"
    else
        return "Lethargic"
    end
end

function GetSkillShootingDescription(value)
    if value > 81 then
        return "Dead-Eye"
    elseif value > 61 then
        return "Military Training"
    elseif value > 41 then
        return "Police Training"
    elseif value > 21 then
        return "Spray-and-Pray"
    else
        return "Untrained"
    end
end

function GetSkillStrengthDescription(value)
    if value > 81 then
        return "Bodybuilder"
    elseif value > 61 then
        return "Tough"
    elseif value > 41 then
        return "Average"
    elseif value > 21 then
        return "Weak"
    else
        return "Fragile"
    end
end

function GetSkillStealthDescription(value)
    if value > 81 then
        return "Ninja"
    elseif value > 61 then
        return "Hunter"
    elseif value > 41 then
        return "Sneaky"
    elseif value > 21 then
        return "Loud"
    else
        return "Clumsy"
    end
end

function GetSkillFlyingDescription(value)
    if value > 81 then
        return "Ace"
    elseif value > 61 then
        return "Fighter Pilot"
    elseif value > 41 then
        return "Commercial Pilot"
    elseif value > 21 then
        return "RC Pilot"
    else
        return "Dangerous"
    end
end

function GetSkillDrivingDescription(value)
    if value > 81 then
        return "Pro-Racer"
    elseif value > 61 then
        return "Street Racer"
    elseif value > 41 then
        return "Commuter"
    elseif value > 21 then
        return "Sunday Driver"
    else
        return "Unlicensed"
    end
end

function GetSkillMentalStateDescription(value)
    if value > 81 then
        return "Psychopath"
    elseif value > 61 then
        return "Maniac"
    elseif value > 41 then
        return "Deranged"
    elseif value > 21 then
        return "Unstable"
    else
        return "Normal"
    end
end