---@diagnostic disable: missing-parameter
local pool = MenuHandler.New()
PlayerMenu = nil
local currentColumnId = 1
local currentSelectId = 1
local ColumnCallbackFunction = {}
ColumnCallbackFunction[1] = {}
ColumnCallbackFunction[2] = {}

local menuLoaded = false
local firstLoad = true
local function CreatePlayerMenuMenu()
    if not PlayerMenu then
        PlayerMenu = MainView.New("Player Management", "dec", "", "", "")
        local columns = {
            SettingsListColumn.New("MANAGE", HudColours.HUD_COLOUR_RED),
            PlayerListColumn.New("PLAYER", HudColours.HUD_COLOUR_ORANGE),
            MissionDetailsPanel.New("PLAYER INFO", HudColours.HUD_COLOUR_GREEN),
        }
        PlayerMenu:SetupColumns(columns)
        PlayerMenu:HeaderPicture("ScaleformUI_Lua_duiTxd", "LobbyHeadshot") -- playerMenu:CrewPicture used to add a picture on the left of the HeaderPicture

        pool:AddPauseMenu(PlayerMenu)
        PlayerMenu:CanPlayerCloseMenu(true)

        local item = UIMenuItem.New("UIMenuItem", "UIMenuItem description")
        PlayerMenu.SettingsColumn.AddSettings(item)

        PlayerMenu.MissionPanel:UpdatePanelPicture("scaleformui", "lobby_panelbackground")
        PlayerMenu.MissionPanel:Title("ScaleformUI - Title")

        local friend = FriendItem.New("", HudColours.HUD_COLOUR_FREEMODE, false, 0, "", "")
        PlayerMenu.PlayersColumn:AddPlayer(friend)

        PlayerMenu.SettingsColumn.OnIndexChanged = function(idx)
            currentSelectId = idx
            currentColumnId = 1
        end

        PlayerMenu.PlayersColumn.OnIndexChanged = function(idx)
            currentSelectId = idx
            currentColumnId = 2
        end

        Wait(100)
        menuLoaded = true
        Wait(100)
        firstLoad = false
    end
end

AddEventHandler("ScaleformUI_Lua:playermenu:SetHeaderMenu", function(data)
    while not menuLoaded do
        Wait(0)
    end
    print("ScaleformUI_Lua:lobbymenu:UpdateSettingsColumn")

    if data.Title then
        PlayerMenu.Title = data.Title
    end

    if data.Subtitle then
        PlayerMenu.Subtitle = data.Subtitle
    end

    if data.SideTop then
        PlayerMenu.SideTop = data.SideTop
    end

    if data.SideMid then
        PlayerMenu.SideMid = data.SideMid
    end

    if data.SideBot then
        PlayerMenu.SideBot = data.SideBot
    end

    if data.Col1 then
        PlayerMenu._listCol[1]._label = data.Col1
    end

    if data.Col2 then
        PlayerMenu._listCol[2]._label = data.Col2
    end

    if data.Col3 then
        PlayerMenu._listCol[3]._label = data.Col3
    end

    if data.ColColor1 then
        PlayerMenu._listCol[1]._color = data.ColColor1
    end

    if data.ColColor2 then
        PlayerMenu._listCol[2]._color = data.ColColor2
    end

    if data.ColColor3 then
        PlayerMenu._listCol[3]._color = data.ColColor3
    end
end)

local ClonePedData = {}
AddEventHandler("ScaleformUI_Lua:playermenu:SetPlayerList", function(data, TextureDict, TextureName)
    while not menuLoaded do
        Wait(0)
    end
    print("ScaleformUI_Lua:playermenu:SetPlayerList")

    ColumnCallbackFunction[2] = {}
    PlayerMenu.MissionPanel:UpdatePanelPicture(TextureDict, TextureName)

    for i = 1, #PlayerMenu.PlayersColumn.Items do
        PlayerMenu.PlayersColumn:RemovePlayer(#PlayerMenu.PlayersColumn.Items)
        Wait(0)
    end
    Wait(1)

    PlayerMenu.Subtitle = data.name

    local LobbyBadge = 120
    if data.LobbyBadgeIcon then
        LobbyBadge = data.LobbyBadgeIcon
    elseif GetPlayerFromServerId(data.source) ~= -1 then
        if not Player(data.source).state.ScaleformUI_Lua_IsUsingKeyboard then
            LobbyBadge = LobbyBadgeIcon.IS_CONSOLE_PLAYER
        end
    end

    local friend = FriendItem.New(data.name, data.HudColours, data.colouredTag, data.lev, data.Status, data.CrewTag)
    friend:SetLeftIcon(LobbyBadge, false)
    friend:AddPedToPauseMenu((ClonePedData[data.name] or PlayerPedId())) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
    local panel = PlayerStatsPanel.New(data.name, 116)
    panel:Description("My name is " .. data.name)
    panel:HasPlane(data.HasPlane)
    panel:HasHeli(data.HasHeli)
    panel:HasBoat(data.HasBoat)
    panel:HasVehicle(data.HasVehicle)
    panel.RankInfo:RankLevel(data.lev)
    panel.RankInfo:LowLabel("This is the low label")
    panel.RankInfo:MidLabel("This is the middle label")
    panel.RankInfo:UpLabel("This is the upper label")
    panel:AddStat(PlayerStatsPanelStatItem.New("Stamina", GetSkillStaminaDescription(data.MP0_STAMINA), data.MP0_STAMINA))
    panel:AddStat(PlayerStatsPanelStatItem.New("Shooting", GetSkillShootingDescription(data.MP0_SHOOTING_ABILITY),
        data.MP0_SHOOTING_ABILITY))
    panel:AddStat(PlayerStatsPanelStatItem.New("Strength", GetSkillStrengthDescription(data.MP0_STRENGTH),
        data.MP0_STRENGTH))
    panel:AddStat(PlayerStatsPanelStatItem.New("Stealth", GetSkillStealthDescription(data.MP0_STEALTH_ABILITY),
        data.MP0_STEALTH_ABILITY))
    panel:AddStat(PlayerStatsPanelStatItem.New("Driving", GetSkillDrivingDescription(data.MP0_DRIVING_ABILITY),
        data.MP0_DRIVING_ABILITY))
    panel:AddStat(PlayerStatsPanelStatItem.New("Flying", GetSkillFlyingDescription(data.MP0_FLYING_ABILITY),
        data.MP0_FLYING_ABILITY))
    panel:AddStat(PlayerStatsPanelStatItem.New("Mental State", GetSkillMentalStateDescription(data.MPPLY_KILLS_PLAYERS),
        data.MPPLY_KILLS_PLAYERS))
    friend:AddPanel(panel)

    PlayerMenu.PlayersColumn:AddPlayer(friend)

    if data.callbackFunction then
        ColumnCallbackFunction[2][#PlayerMenu.PlayersColumn.Items] = data.callbackFunction
    end
end)

AddEventHandler("ScaleformUI_Lua:playermenu:SetInfo", function(data)
    while not menuLoaded do
        Wait(0)
    end
    print("ScaleformUI_Lua:playermenu:SetInfo")

    for i = 1, #PlayerMenu.MissionPanel.Items do
        PlayerMenu.MissionPanel:RemoveItem(#PlayerMenu.MissionPanel.Items)
    end

    for k, v in pairs(data) do
        local detailItem = UIMenuFreemodeDetailsItem.New(v.LeftLabel, v.RightLabel, false, v.BadgeStyle, v.HudColours)
        PlayerMenu.MissionPanel:AddItem(detailItem)
    end
end)

AddEventHandler("ScaleformUI_Lua:playermenu:SetInfoTitle", function(data)
    while not menuLoaded do
        Wait(0)
    end
    print("ScaleformUI_Lua:playermenu:SetInfoTitle")

    if data.Title then
        PlayerMenu.MissionPanel:Title(data.Title)
    end

    if data.tex and data.txd then
        PlayerMenu.MissionPanel:UpdatePanelPicture(data.tex, data.txd)
    end
end)

AddEventHandler("ScaleformUI_Lua:playermenu:SettingsColumn", function(data)
    while not menuLoaded do
        Wait(0)
    end
    print("ScaleformUI_Lua:playermenu:SettingsColumn")

    ColumnCallbackFunction[1] = {}

    for k, v in pairs(data) do
        local item
        if v.type == "List" then
            item = UIMenuListItem.New(v.label, v.list, 0, v.dec)
        elseif v.type == "Checkbox" then
            item = UIMenuCheckboxItem.New(v.label, true, 1, v.dec)
        elseif v.type == "Slider" then
            item = UIMenuSliderItem.New(v.label, 100, 5, 50, false, v.dec)
        elseif v.type == "Progress" then
            item = UIMenuProgressItem.New(v.label, 10, 5, v.dec)
        else
            item = UIMenuItem.New(v.label, v.dec, v.mainColor, v.highlightColor, v.textColor, v.highlightedTextColor)
        end
        PlayerMenu.SettingsColumn.Items[k] = item
        item:BlinkDescription(v.Blink)

        if v.callbackFunction then
            ColumnCallbackFunction[1][k] = v.callbackFunction
        end
    end
end)

AddEventHandler("ScaleformUI_Lua:playermenu:Show", function(FocusLevel, canclose, onClose)
    CreatePlayerMenuMenu()

    while IsDisabledControlPressed(0, 199) or IsDisabledControlPressed(0, 200) do
        Wait(0)
    end

    while firstLoad do
        Wait(0)
    end

    if PlayerMenu:Visible() then
        PlayerMenu:Visible(false)
        while IsPauseMenuRestarting() or IsFrontendFading() or IsPauseMenuActive() do
            Wait(0)
        end
    end

    currentSelectId = 1
    currentColumnId = 1
    PlayerMenu:CanPlayerCloseMenu(canclose)
    PlayerMenu:Visible(true)
    PlayerMenu:FocusLevel(FocusLevel)

    local instructional_buttons = Scaleform.Request("instructional_buttons")
    instructional_buttons:CallFunction("CLEAR_ALL")
    local buttonsID = 0
    instructional_buttons:CallFunction("SET_DATA_SLOT", buttonsID, GetControlInstructionalButton(1, 191, true),
        GetLabelText("HUD_INPUT2"))
    buttonsID = buttonsID + 1
    if canclose then
        instructional_buttons:CallFunction("SET_DATA_SLOT", buttonsID, GetControlInstructionalButton(1, 194, true),
            GetLabelText("HUD_INPUT3"))
        buttonsID = buttonsID + 1
    end
    instructional_buttons:CallFunction("SET_DATA_SLOT", buttonsID, "~INPUTGROUP_FRONTEND_DPAD_ALL~",
        GetLabelText("HUD_INPUT8"))
    buttonsID = buttonsID + 1
    instructional_buttons:CallFunction("SET_BACKGROUND_COLOUR", 0, 0, 0, 80)
    instructional_buttons:CallFunction("DRAW_INSTRUCTIONAL_BUTTONS")

    while PlayerMenu:Visible() do
        SetScriptGfxDrawBehindPausemenu(true)
        instructional_buttons:Render2D()

        if IsDisabledControlJustPressed(0, 201) then
            if ColumnCallbackFunction[currentColumnId][currentSelectId] then
                ColumnCallbackFunction[currentColumnId][currentSelectId]()
                PlayerMenu:Visible(false)
            end
        end
        Wait(0)
    end
    instructional_buttons:Dispose()

    if onClose then
        -- Wait(100)
        while IsPauseMenuRestarting() or IsFrontendFading() or IsPauseMenuActive() do
            Wait(0)
        end
        onClose()
    end
end)

AddEventHandler("ScaleformUI_Lua:playermenu:Hide", function()
    while not menuLoaded do
        Wait(0)
    end

    if PlayerMenu:Visible() then
        PlayerMenu:Visible(false)
    end
end)
