--[[
F8 Command

slua_show -- Open example lobby menu
slua_setheader -- Set menu header
slua_setinfo -- Set menu info
slua_setplayer_1 -- Set menu plaayer list template 1
slua_setplayer_2 -- Set menu plaayer list template 2
slua_setmappanel -- Set checkpoint route map panel
]]

-- CreateThread(function()
-- while true do
-- DisableControlAction(0, 200, true)
-- DisableControlAction(0, 199, true)
-- Citizen.Wait(0)
-- end
-- end)

local LobbyMenu
local defaultSubtitle = "Template by H@mer"
local DuiObject

local selectColumnID = 1
local selectRowID = 1

local ColumnCallbackFunction = {}
ColumnCallbackFunction[1] = {}
ColumnCallbackFunction[2] = {}

local minimapLobbyEnabled = false
local firstLoad = true
local DataSet = {
	HeaderMenu = {},
	PlayerList = {},
	SettingsColumn = {},
	InfoTitle = {},
	Info = {},
}

local function CreateLobbyMenu()
	if not LobbyMenu then
		local columns = {
			SettingsListColumn.New("COLUMN SETTINGS", SColor.HUD_Red),
			PlayerListColumn.New("COLUMN PLAYERS", SColor.HUD_Orange),
			MissionDetailsPanel.New("COLUMN INFO PANEL", SColor.HUD_Green),
		}
		LobbyMenu = MainView.New("Lobby Menu", defaultSubtitle, "", "", "")
		-- LobbyMenu:ShowStoreBackground(true)
		-- LobbyMenu:StoreBackgroundAnimationSpeed(50)
		LobbyMenu:SetupColumns(columns)

		--[[
		RequestStreamedTextureDictC("ScaleformUI")
		local mugshot = RegisterPedheadshot(PlayerPedId())
		local timer = GetGameTimer()
		while not IsPedheadshotReady(mugshot) and GetGameTimer() - timer < 1000 do
			Citizen.Wait(0)
		end
		local headshot = GetPedheadshotTxdString(mugshot)
		AddReplaceTexture("ScaleformUI", "LobbyHeadshot", headshot, headshot)
		LobbyMenu:HeaderPicture("ScaleformUI", "LobbyHeadshot") -- lobbyMenu:CrewPicture used to add a picture on the left of the HeaderPicture
		UnregisterPedheadshot(mugshot) -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform.. 
		]]

		DuiObject = CreateDui("https://i.imgur.com/mH0Y65C.gif", 320, 180)
		local timeout = GetNetworkTime()
		while not IsDuiAvailable(DuiObject) and GetNetworkTime()-timeout < 6000 do
			Citizen.Wait(0)
		end
		CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd('scaleformui'), "lobby_panelbackground", GetDuiHandle(DuiObject))
		
		LobbyMenu:CanPlayerCloseMenu(true)
		-- this is just an example..CanPlayerCloseMenu is always defaulted to true.. if you set this to false.. be sure to give the players a way out of your menu!!!

		local item = UIMenuItem.New("UIMenuItem", "UIMenuItem description")
		item:BlinkDescription(true)
		LobbyMenu.SettingsColumn:AddSettings(item)

		local crew = CrewTag.New("", true, false, CrewHierarchy.Leader, SColor.HUD_Green)
		local friend = FriendItem.New("Name", SColor.FromHudColor(HudColours.HUD_COLOUR_FREEMODE), true, HudColours.HUD_COLOUR_FREEMODE, "BLANK", crew)
		LobbyMenu.PlayersColumn:AddPlayer(friend)

		LobbyMenu.MissionPanel:UpdatePanelPicture("scaleformui", "lobby_panelbackground")
		LobbyMenu.MissionPanel:Title("ScaleformUI - Title")

		local detailItem = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, SColor.HUD_Freemode)
		LobbyMenu.MissionPanel:AddItem(detailItem)

		LobbyMenu.SettingsColumn.OnIndexChanged = function(idx)
			selectRowID = idx
			selectColumnID = 1
		end

		LobbyMenu.PlayersColumn.OnIndexChanged = function(idx)
			selectRowID = idx
			selectColumnID = 2
		end

		--[[ -- EXAMPLE OF FILTERING, SORTING AND RESET TO ORIGINAL
		Citizen.Wait(3000)
		lobbyMenu.SettingsColumn:SortSettings(function(a, b)
			return a:Label() < b:Label()
		end)
		Citizen.Wait(3000)
		lobbyMenu.SettingsColumn:FilterSettings(function(x)
			return x:Label() == "UIMenuItem"
		end)
		Citizen.Wait(3000)
		lobbyMenu.SettingsColumn:ResetFilter()
		]]
		Citizen.Wait(100)
		firstLoad = false
	end
end

---Can't change while LobbyMenu already visible
AddEventHandler("ScaleformUI:lobbymenu:SetHeaderMenu", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end

	local isChange = false
	if #data ~= #DataSet.HeaderMenu then
		isChange = true
	else
		for k,v in pairs(data) do
			if not DataSet.HeaderMenu[k] then
				isChange = true
				break
			else
				if DataSet.HeaderMenu[k] and DataSet.HeaderMenu[k] ~= v then
					isChange = true
					break
				end
			end
		end
	end
	
	if isChange then
		if data.Title then
			LobbyMenu.Title = data.Title
		end

		if data.Subtitle then
			LobbyMenu.Subtitle = data.Subtitle
		end

		--[[
		if data.SideTop then
			lobbyMenu.SideTop = data.SideTop
		end
		
		if data.SideMid then
			lobbyMenu.SideMid = data.SideMid
		end
		
		if data.SideBot then
			lobbyMenu.SideBot = data.SideBot
		end
		]]

		if data.Col1 then
			LobbyMenu.listCol[1]._label = data.Col1
		end

		if data.Col2 then
			LobbyMenu.listCol[2]._label = data.Col2
		end

		if data.Col3 then
			LobbyMenu.listCol[3]._label = data.Col3
		end

		if data.ColColor1 then
			LobbyMenu.listCol[1]._color = SColor.FromHudColor(data.ColColor1)
		end

		if data.ColColor2 then
			LobbyMenu.listCol[2]._color = SColor.FromHudColor(data.ColColor2)
		end

		if data.ColColor3 then
			LobbyMenu.listCol[3]._color = SColor.FromHudColor(data.ColColor3)
		end

		DataSet.HeaderMenu = data
	end
end)

AddEventHandler("ScaleformUI:lobbymenu:SetPlayerList", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end
	if LobbyMenu:Visible() then
		Citizen.Wait(300)
	end

	local isChange = false
	if #data ~= #DataSet.PlayerList then
		isChange = true
	else
		for k,v in pairs(data) do
			if not DataSet.PlayerList[k] then
				isChange = true
				break
			else
				for kk,vv in pairs(v) do
					if kk ~= "callbackFunction" and kk ~= "ped" and DataSet.PlayerList[k][kk] and DataSet.PlayerList[k][kk] ~= vv then
						isChange = true
						break
					end
				end
				if isChange then
					break
				end
			end
		end
	end

	if isChange then
		ColumnCallbackFunction[2] = {}
		LobbyMenu.PlayersColumn:Clear()
		
		local HostSource = -1
		for k, v in pairs(data) do
			if not v.sortScore then
				if HostSource == v.source then
					v.sortScore = 1
				elseif v.LobbyBadgeIcon == ScoreRightIconType.SPECTATOR then -- JoinAsSpectatorMode
					v.sortScore = 3
				elseif v.ped then
					v.sortScore = 2
				else
					v.sortScore = 4
				end
			end
		end
		table.sort(data, function(a, b)
			return a.sortScore < b.sortScore
		end)

		for k, v in pairs(data) do
			local Status = v.Status
			local Colours = v.Colours

			if GetPlayerFromServerId(v.source) ~= -1 then
				v.MP0_STAMINA = Player(v.source).state.ArenaLobby_MP0_STAMINA or 0
				v.MP0_STRENGTH = Player(v.source).state.ArenaLobby_MP0_STRENGTH or 0
				v.MP0_LUNG_CAPACITY = Player(v.source).state.ArenaLobby_MP0_LUNG_CAPACITY or 0
				v.MP0_SHOOTING_ABILITY = Player(v.source).state.ArenaLobby_MP0_SHOOTING_ABILITY or 0
				v.MP0_DRIVING_ABILITY = Player(v.source).state.ArenaLobby_MP0_WHEELIE_ABILITY or 0
				v.MP0_WHEELIE_ABILITY = Player(v.source).state.ArenaLobby_MP0_WHEELIE_ABILITY or 0
				v.MP0_FLYING_ABILITY = Player(v.source).state.ArenaLobby_MP0_FLYING_ABILITY or 0
				v.MP0_STEALTH_ABILITY = Player(v.source).state.ArenaLobby_MP0_STEALTH_ABILITY or 0
				v.MPPLY_KILLS_PLAYERS = Player(v.source).state.ArenaLobby_MP0_HIGHEST_MENTAL_STATE or 0
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
			v.HasVehicle = IsPedInAnyVehicle(v.ped, false)

			local LobbyBadge = LobbyBadgeIcon.IS_PC_PLAYER
			if v.LobbyBadgeIcon then
				LobbyBadge = v.LobbyBadgeIcon
			elseif GetPlayerFromServerId(v.source) ~= -1 then
				if not Player(v.source).state.IsUsingKeyboard then
					LobbyBadge = LobbyBadgeIcon.IS_CONSOLE_PLAYER
				end
			end

			local crew = CrewTag.New(v.CrewTag, true, false, CrewHierarchy.Leader, SColor.HUD_Green)
			local friend = FriendItem.New(v.name, SColor.FromHudColor(Colours), true, v.level, Status, crew)
			
			friend.ClonePed = v.ped
			local panel = PlayerStatsPanel.New(v.name, SColor.FromHudColor(v.rowColor or HudColours.HUD_COLOUR_PAUSE_DESELECT))
			panel:HasPlane(v.HasPlane)
			panel:HasHeli(v.HasHeli)
			panel:HasBoat(v.HasBoat)
			panel:HasVehicle(v.HasVehicle)
			panel.RankInfo:RankLevel(v.level)
			-- panel.RankInfo:LowLabel("This is the low label")
			-- panel.RankInfo:MidLabel("This is the middle label")
			-- panel.RankInfo:UpLabel("This is the upper label")
			panel:AddStat(PlayerStatsPanelStatItem.New("Stamina", GetSkillStaminaDescription(v.MP0_STAMINA), v.MP0_STAMINA))
			panel:AddStat(PlayerStatsPanelStatItem.New("Shooting", GetSkillShootingDescription(v.MP0_SHOOTING_ABILITY), v.MP0_SHOOTING_ABILITY))
			panel:AddStat(PlayerStatsPanelStatItem.New("Strength", GetSkillStrengthDescription(v.MP0_STRENGTH), v.MP0_STRENGTH))
			panel:AddStat(PlayerStatsPanelStatItem.New("Stealth", GetSkillStealthDescription(v.MP0_STEALTH_ABILITY), v.MP0_STEALTH_ABILITY))
			panel:AddStat(PlayerStatsPanelStatItem.New("Driving", GetSkillDrivingDescription(v.MP0_DRIVING_ABILITY), v.MP0_DRIVING_ABILITY))
			panel:AddStat(PlayerStatsPanelStatItem.New("Flying", GetSkillFlyingDescription(v.MP0_FLYING_ABILITY), v.MP0_FLYING_ABILITY))
			panel:AddStat(PlayerStatsPanelStatItem.New("Mental State", GetSkillMentalStateDescription(v.MPPLY_KILLS_PLAYERS), v.MPPLY_KILLS_PLAYERS))
			friend:AddPanel(panel)
			
			if v.ped then
				friend:Enabled(true)
				panel:Description("My name is "..tostring(v.name))
				friend:SetLeftIcon(LobbyBadge, false)
				friend:SetRightIcon(BadgeStyle.INV_MISSION, false)
			else
				friend:Enabled(false)
				panel:Description("Empty")
				friend:SetLeftIcon(BadgeStyle.NONE, false)
				friend:SetRightIcon(BadgeStyle.NONE, false)
			end

			LobbyMenu.PlayersColumn:AddPlayer(friend)

			if v.callbackFunction then
				ColumnCallbackFunction[2][#LobbyMenu.PlayersColumn.Items] = v.callbackFunction
			end
		end

		if LobbyMenu:Visible() then
			LobbyMenu.PlayersColumn:refreshColumn()
		end
		DataSet.PlayerList = table.deepcopy(data)
	end
end)

AddEventHandler("ScaleformUI:lobbymenu:SetInfo", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end
	if LobbyMenu:Visible() then
		Citizen.Wait(300)
	end

	local isChange = false
	if #data ~= #DataSet.Info then
		isChange = true
	else
		for k,v in pairs(data) do
			if not DataSet.Info[k] then
				isChange = true
				break
			else
				for kk,vv in pairs(v) do
					if DataSet.Info[k][kk] and DataSet.Info[k][kk] ~= vv then
						isChange = true
						break
					end
				end
				if isChange then
					break
				end
			end
		end
	end
	
	if isChange then
		for i=1, #LobbyMenu.MissionPanel.Items do
			LobbyMenu.MissionPanel:RemoveItem(#LobbyMenu.MissionPanel.Items)
		end

		for k,v in pairs(data) do
			local detailItem = UIMenuFreemodeDetailsItem.New(v.LeftLabel, v.RightLabel, false, v.BadgeStyle, v.Colours)
			LobbyMenu.MissionPanel:AddItem(detailItem)
		end

		DataSet.Info = table.deepcopy(data)
	end
end)

AddEventHandler("ScaleformUI:lobbymenu:SetInfoTitle", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end
	if LobbyMenu:Visible() then
		Citizen.Wait(300)
	end

	local isChange = false
	if #data ~= #DataSet.InfoTitle then
		isChange = true
	else
		for k,v in pairs(data) do
			if not DataSet.InfoTitle[k] then
				isChange = true
				break
			else
				if DataSet.InfoTitle[k] and DataSet.InfoTitle[k] ~= v then
					isChange = true
					break
				end
			end
		end
	end
	
	if isChange then
		if data.Title then
			LobbyMenu.MissionPanel:Title(data.Title)
		end

		if data.tex and data.txd then
			LobbyMenu.MissionPanel:UpdatePanelPicture(data.tex, data.txd)
			SetDuiUrl(DuiObject, "https://images8.alphacoders.com/132/1322626.png")
		end
		DataSet.InfoTitle = data
	end
end)

AddEventHandler("ScaleformUI:lobbymenu:SettingsColumn", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end
	if LobbyMenu:Visible() then
		Citizen.Wait(300)
	end
	
	local isChange = false
	if #data ~= #DataSet.SettingsColumn then
		isChange = true
	else
		for k,v in pairs(data) do
			if not DataSet.SettingsColumn[k] then
				isChange = true
				break
			else
				for kk,vv in pairs(v) do
					if kk ~= "callbackFunction" and DataSet.SettingsColumn[k][kk] and DataSet.SettingsColumn[k][kk] ~= vv then
						isChange = true
						break
					end
				end
				if isChange then
					break
				end
			end
		end
	end
	
	if isChange then
		ColumnCallbackFunction[1] = {}
		LobbyMenu.SettingsColumn:Clear()
		
		for k,v in pairs(data) do
			local item
			if v.type == "List" then
				item = UIMenuListItem.New(v.label, v.list, 0, v.dec, SColor.FromHudColor(v.mainColor or HudColours.HUD_COLOUR_PURE_WHITE), SColor.FromHudColor(v.highlightColor or HudColours.HUD_COLOUR_PURE_WHITE), SColor.FromHudColor(v.textColor or HudColours.HUD_COLOUR_PURE_WHITE), SColor.FromHudColor(v.highlightedTextColor or HudColours.HUD_COLOUR_PURE_WHITE))
			elseif v.type == "Checkbox" then
				item = UIMenuCheckboxItem.New(v.label, true, 1, v.dec)
			elseif v.type == "Slider" then
				item = UIMenuSliderItem.New(v.label, 100, 5, 50, false, v.dec)
			elseif v.type == "Progress" then
				item = UIMenuProgressItem.New(v.label, 10, 5, v.dec)
			else
				item = UIMenuItem.New(v.label, v.dec, SColor.FromHudColor(v.mainColor or HudColours.HUD_COLOUR_PURE_WHITE), SColor.FromHudColor(v.highlightColor or HudColours.HUD_COLOUR_PURE_WHITE), SColor.FromHudColor(v.textColor or HudColours.HUD_COLOUR_PURE_WHITE), SColor.FromHudColor(v.highlightedTextColor or HudColours.HUD_COLOUR_PURE_WHITE))
				if v.rightLabel then
					item:RightLabel(v.rightLabel)
				end
			end
			item:BlinkDescription(v.Blink)
			LobbyMenu.SettingsColumn:AddSettings(item)

			if v.callbackFunction then
				ColumnCallbackFunction[1][k] = v.callbackFunction
			end
		end

		if LobbyMenu:Visible() then
			LobbyMenu.SettingsColumn:refreshColumn()
		end
		DataSet.SettingsColumn = table.deepcopy(data)
	end
end)

AddEventHandler("ScaleformUI:lobbymenu:MapPanel", function(data)
	while not LobbyMenu do
		Citizen.Wait(0)
	end

	LobbyMenu.MinimapButton = nil
	LobbyMenu.hasMapPanel = true

	minimapLobbyEnabled = false
	LobbyMenu.Minimap:Enabled(false) -- Force refresh map position
	LobbyMenu.MinimapButton = InstructionalButton.New("Toggle Map Panel", -1, 203, 203, -1)
	LobbyMenu.MinimapButton.OnControlSelected = function(control)
		minimapLobbyEnabled = not minimapLobbyEnabled
		if minimapLobbyEnabled then
			LobbyMenu.Minimap.MinimapRoute.RouteColor = HudColours.HUD_COLOUR_YELLOW
			LobbyMenu.Minimap.MinimapRoute.MapThickness = 17
			for k,v in pairs(data) do
				local blipColor = 5
				if v.path == 2 then
					blipColor = 3
				elseif v.path == 3 then
					blipColor = 29
				elseif v.path == 4 then
					blipColor = 17
				elseif v.path == 5 then
					blipColor = 8
				elseif v.path == 6 then
					blipColor = 23
				end
				if k == 1 then
					LobbyMenu.Minimap.MinimapRoute.StartPoint = MinimapRaceCheckpoint.New(309, vector3(v.x, v.y, v.z), blipColor, 0.8)
				elseif k == #data then
					LobbyMenu.Minimap.MinimapRoute.EndPoint = MinimapRaceCheckpoint.New(38, vector3(v.x, v.y, v.z), blipColor, 0.8)
				else
					table.insert(LobbyMenu.Minimap.MinimapRoute.CheckPoints, MinimapRaceCheckpoint.New(271, vector3(v.x, v.y, v.z), 5, 0.8))
				end
			end
		else
			LobbyMenu.Minimap:ClearMinimap()
		end
		LobbyMenu.Minimap:Enabled(minimapLobbyEnabled)
	end
end)

AddEventHandler("ScaleformUI:lobbymenu:Show", function(focusColume, canClose, onClose)
	CreateLobbyMenu()

	if LobbyMenu:Visible() then
		LobbyMenu:Visible(false)
		Citizen.Wait(50)
	end
	while firstLoad or IsDisabledControlPressed(0, 199) or IsDisabledControlPressed(0, 200) or IsPauseMenuRestarting() or IsFrontendFading() or IsPauseMenuActive() do
		SetPauseMenuActive(false)
		SetFrontendActive(false)
		Citizen.Wait(0)
	end
	while LobbyMenu.Subtitle == defaultSubtitle do
		Citizen.Wait(0)
	end

	LobbyMenu.InstructionalButtons = {}
	table.insert(LobbyMenu.InstructionalButtons, InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 191, 191, -1))
	if canClose then
		table.insert(LobbyMenu.InstructionalButtons, InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 194, 194, -1))
	end
	table.insert(LobbyMenu.InstructionalButtons, InstructionalButton.New(GetLabelText("HUD_INPUT8"), -1, -1, -1, "INPUTGROUP_FRONTEND_DPAD_ALL"))

	if LobbyMenu.hasMapPanel then
		while not LobbyMenu.MinimapButton do
			Citizen.Wait(0)
		end
		table.insert(LobbyMenu.InstructionalButtons, LobbyMenu.MinimapButton)
	end

	selectRowID = 1
	selectColumnID = 1
	LobbyMenu:CanPlayerCloseMenu(canClose)
	LobbyMenu:Visible(true)
	Citizen.SetTimeout(50, function()
		LobbyMenu:updateFocus(focusColume, false)
	end)

	while LobbyMenu:Visible() do
		if IsDisabledControlJustPressed(2, 201) then
			-- Select setting row
			if ColumnCallbackFunction[selectColumnID][selectRowID] then
				ColumnCallbackFunction[selectColumnID][selectRowID]()
			end

			-- Host select player row
			if selectColumnID == 2 and DataSet.PlayerList[selectRowID] and DataSet.PlayerList[selectRowID].ped then
				local targetSource = DataSet.PlayerList[selectRowID].source
				local settingList = {}

				table.insert(settingList, {
					label = "Back",
					dec = "",
					callbackFunction = function()
						TriggerEvent("ScaleformUI:playermenu:Hide")
					end,
				})

					table.insert(settingList, {
						label = "<font color='#c8423b'>Kick</font",
						dec = "Kick player from current lobby.",
						HudColours.HUD_COLOUR_RED,
						highlightColor = HudColours.HUD_COLOUR_REDDARK,
						textColor = HudColours.HUD_COLOUR_PURE_WHITE,
						highlightedTextColor = HudColours.HUD_COLOUR_PURE_WHITE,
						Blink = true,
						callbackFunction = function()
							PlaySoundFrontend(-1, "MP_IDLE_KICK", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("ScaleformUI:lobbymenu:KickPlayer", targetSource)
							TriggerEvent("ScaleformUI:playermenu:Hide")
						end,
					})
				
				TriggerEvent("ScaleformUI:playermenu:SettingsColumn", settingList)
				TriggerEvent("ScaleformUI:playermenu:SetInfo", DataSet.Info)
				TriggerEvent("ScaleformUI:playermenu:SetInfoTitle", {
					Title = LobbyMenu.MissionPanel._title,
					tex = LobbyMenu.MissionPanel.TextureDict,
					txd = LobbyMenu.MissionPanel.TextureName,
				})

				TriggerEvent("ScaleformUI:playermenu:SetHeaderMenu", {
					SideTop = LobbyMenu.SideTop,
					SideMid = LobbyMenu.SideMid,
					SideBot = LobbyMenu.SideBot,
					ColColor1 = LobbyMenu.listCol[1]._color,
					ColColor2 = LobbyMenu.listCol[2]._color,
					ColColor3 = LobbyMenu.listCol[3]._color,
				})

				TriggerEvent("ScaleformUI:playermenu:SetPlayerList", DataSet.PlayerList[selectRowID])

				LobbyMenu:Visible(false)
				TriggerEvent("ScaleformUI:playermenu:Show", function()
					TriggerEvent("ScaleformUI:lobbymenu:Show", 2, true)
				end)
			end
		end

		Citizen.Wait(0)
	end

	if onClose then
		while IsPauseMenuRestarting() or IsFrontendFading() or IsPauseMenuActive() do
			Citizen.Wait(0)
		end
		onClose()
	end
end)

AddEventHandler("ScaleformUI:lobbymenu:Hide", function()
	if LobbyMenu then
		LobbyMenu:Visible(false)
	end
end)

RegisterNetEvent("ScaleformUI:lobbymenu:leaveLobby")
AddEventHandler("ScaleformUI:lobbymenu:leaveLobby", function()
	ExecuteCommand("minigame leave")
	if LobbyMenu then
		LobbyMenu:Visible(false)
	end
end)



--/////////////////////// Command ///////////////////////////////////--

RegisterCommand('slua_setheader', function(source, args) -- Use command before menu open.
    local WeekString = {
        [0] = "Sunday",
        [1] = "Monday",
        [2] = "Tuesday",
        [3] = "Wednesday",
        [4] = "Thursday",
        [5] = "Friday",
        [6] = "Saturday",
    }
    TriggerEvent("ScaleformUI:lobbymenu:SetHeaderMenu", {
        Title = "Lobby",
        Subtitle = "Racing",
        SideTop = GetPlayerName(PlayerId()),
        SideMid = WeekString[GetClockDayOfWeek()] .. " " .. GetClockHours() .. ":" .. GetClockMinutes(),
        SideBot = "BANK $" .. NetworkGetVcBankBalance() .. " CASH $" .. NetworkGetVcBalance(),
        Col1 = "🕹️  GAME",
        Col2 = "PLAYERS 1 OF 32",
        Col3 = "INFO",
        ColColor1 = 116,
        ColColor2 = 116,
        ColColor3 = 116,
    })

    CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd('ScaleformUI_Lua_duiTxd'), "stunt-45",
	GetDuiHandle(CreateDui("https://static.wikia.nocookie.net/gtawiki/images/4/4a/45%C2%B0-GTAO-JobImage.jpg/revision/latest?cb=20190216233424", 320, 180)))
    TriggerEvent("ScaleformUI:lobbymenu:SetInfoTitle", {
		Title = "Stunt - 45°",
		tex = "scaleformui",
		txd = "lobby_panelbackground"
    })

    local settingList = {
        {
            label = "Setting",
            dec = "Open game setting menu.",
            callbackFunction = function()
                TriggerEvent("ScaleformUI:lobbymenu:Hide")
                Wait(100)
                ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), false, 6)
            end,
        },
        {
            label = "Map",
            dec = "Open map menu.",
            callbackFunction = function()
                TriggerEvent("ScaleformUI:lobbymenu:Hide")
                Wait(100)
                ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), false, 0)
            end,
        },
        {
            label = "Leave Game",
            dec = "Leave current lobby.",
            callbackFunction = function()
                TriggerEvent("ScaleformUI:lobbymenu:Hide")
                ExecuteCommand("minigame leave")
            end,
            mainColor = 8,
            highlightColor = 6,
            textColor = 0,
            highlightedTextColor = 0,
            Blink = true,
        },
    }

    TriggerEvent("ScaleformUI:lobbymenu:SettingsColumn", settingList)
end, false)

RegisterCommand('slua_setinfo', function(source, args)
    local infoList = {
        {
            LeftLabel = "Map",
            RightLabel = "Stunt - 45°",
            BadgeStyle = 179,
            HudColours = false,
        },
        {
            LeftLabel = "Min Player",
            RightLabel = 1,
            BadgeStyle = 179,
            HudColours = false,
        },
        {
            LeftLabel = "Time Left",
            RightLabel = "60 Minute",
            BadgeStyle = 179,
            HudColours = false,
        },
    }
    TriggerEvent("ScaleformUI:lobbymenu:SetInfo", infoList)
end, false)

RegisterCommand('slua_setplayer_1', function(source, args)
    local playerList = {}
    for i = 1, 10 do
        table.insert(playerList, {
            source = GetPlayerServerId(PlayerId()),
            name = "Player " .. i,
            Colours = 116,
            rowColor = 116,
            HudColours = 15,
            Status = "WAITING",
            CrewTag = "",
            lev = GetRandomIntInRange(1, 999),
            ped = PlayerPedId(),
        })
    end

    TriggerEvent("ScaleformUI:lobbymenu:SetPlayerList", playerList)
end, false)

RegisterCommand('slua_setplayer_2', function(source, args)
    local playerList = {}
    for i = 11, 20 do
        table.insert(playerList, {
            source = GetPlayerServerId(PlayerId()),
            name = "Player " .. i,
            Colours = 119,
            rowColor = 119,
            HudColours = 18,
            Status = "PLAYING",
            CrewTag = "",
            lev = GetRandomIntInRange(1, 999),
            ped = PlayerPedId(),
        })
    end

    TriggerEvent("ScaleformUI:lobbymenu:SetPlayerList", playerList)
end, false)

RegisterCommand('slua_setmappanel', function(source, args)
    local data = GetEntityCoords(PlayerPedId())+vector3(0.0, 0.0, 100.0)
    local route = {}
	for i=1, 10 do
        if i%2 == 0 then
            data = data+vector3(i*10, 0.0, 0.0)
        else
            data = data+vector3(0.0, i*10, 0.0)
        end
        table.insert(route, {order=i, path=1, x=data.x, y=data.y, z=data.z})
    end
	TriggerEvent("ScaleformUI:lobbymenu:MapPanel", route)
end, false)

RegisterCommand('slua_show', function(source, args)
	StatSetBool(GetHashKey("MP0_DEFAULT_STATS_SET"), true, true)
	StatSetBool(GetHashKey("MP1_DEFAULT_STATS_SET"), true, true)

	LocalPlayer.state:set("ScaleformUI_Lua_IsUsingKeyboard", IsUsingKeyboard(0), true)
	LocalPlayer.state:set("ScaleformUI_Lua_MP0_STAMINA", table.pack(StatGetInt(`MP0_STAMINA`))[2], true)
	LocalPlayer.state:set("ScaleformUI_Lua_MP0_STRENGTH", table.pack(StatGetInt(`MP0_STRENGTH`))[2], true)
	LocalPlayer.state:set("ScaleformUI_Lua_MP0_LUNG_CAPACITY", table.pack(StatGetInt(`MP0_LUNG_CAPACITY`))[2], true)
	LocalPlayer.state:set("ScaleformUI_Lua_MP0_SHOOTING_ABILITY", table.pack(StatGetInt(`MP0_SHOOTING_ABILITY`))[2], true)
	LocalPlayer.state:set("ScaleformUI_Lua_MP0_WHEELIE_ABILITY", table.pack(StatGetInt(`MP0_WHEELIE_ABILITY`))[2], true)
	LocalPlayer.state:set("ScaleformUI_Lua_MP0_FLYING_ABILITY", table.pack(StatGetInt(`MP0_FLYING_ABILITY`))[2], true)
	LocalPlayer.state:set("ScaleformUI_Lua_MP0_STEALTH_ABILITY", table.pack(StatGetInt(`MP0_STEALTH_ABILITY`))[2], true)
	LocalPlayer.state:set("ScaleformUI_Lua_MP0_HIGHEST_MENTAL_STATE", table.pack(StatGetInt(`MP0_HIGHEST_MENTAL_STATE`))[2], true)

	ExecuteCommand("slua_setheader")
	ExecuteCommand("slua_setinfo")
	ExecuteCommand("slua_setplayer_1")
	TriggerEvent("ScaleformUI:lobbymenu:Show", 1, true, function()
		print("lobbymenu close")
	end)
	ExecuteCommand("slua_setmappanel")
end, false)

--/////////////////////// Function ////////////////////////////////////--

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
