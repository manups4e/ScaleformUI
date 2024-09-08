local PlayerMenu

local currentColumnId = 1
local currentSelectId = 1

local ColumnCallbackFunction = {}
ColumnCallbackFunction[1] = {}
ColumnCallbackFunction[2] = {}

local menuLoaded = false
local firstLoad = true

local function CreatePlayerMenuMenu()
	if not PlayerMenu then
		local columns = {
			SettingsListColumn.New("COLUMN SETTINGS", SColor.HUD_Red),
			PlayerListColumn.New("COLUMN PLAYERS", SColor.HUD_Orange),
			MissionDetailsPanel.New("COLUMN INFO PANEL", SColor.HUD_Green),
		}
		PlayerMenu = MainView.New("Lobby Menu", "ScaleformUI for you by Manups4e!", "", "", "")
		PlayerMenu:SetupColumns(columns)
		PlayerMenu:CanPlayerCloseMenu(true)

		local item = UIMenuItem.New("UIMenuItem", "UIMenuItem description")
		item:BlinkDescription(true)
		PlayerMenu.SettingsColumn:AddSettings(item)

		PlayerMenu.MissionPanel:UpdatePanelPicture("scaleformui", "lobby_panelbackground")
		PlayerMenu.MissionPanel:Title("ScaleformUI - Title")
		
		local detailItem = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, SColor.HUD_Freemode)
		PlayerMenu.MissionPanel:AddItem(detailItem)

		PlayerMenu.SettingsColumn.OnIndexChanged = function(idx)
			currentSelectId = idx
			currentColumnId = 1
		end

		PlayerMenu.PlayersColumn.OnIndexChanged = function(idx)
			currentSelectId = idx
			currentColumnId = 2
		end

		Citizen.Wait(50)
		menuLoaded = true
		Citizen.Wait(50)
		firstLoad = false
	end
end

AddEventHandler("ScaleformUI_Lua:playermenu:SetHeaderMenu", function(data)
	while not menuLoaded do
		Citizen.Wait(0)
	end

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
		PlayerMenu.listCol[1]._label = data.Col1
	end

	if data.Col2 then
		PlayerMenu.listCol[2]._label = data.Col2
	end

	if data.Col3 then
		PlayerMenu.listCol[3]._label = data.Col3
	end

	PlayerMenu.listCol[1]._color = SColor.FromHudColor(116)
	PlayerMenu.listCol[2]._color = SColor.FromHudColor(116)
	PlayerMenu.listCol[3]._color = SColor.FromHudColor(116)
end)

local ClonePedData = {}
AddEventHandler("ScaleformUI_Lua:playermenu:SetPlayerList", function(data, TextureDict, TextureName)
	while not menuLoaded do
		Citizen.Wait(0)
	end

	ColumnCallbackFunction[2] = {}
	PlayerMenu.MissionPanel:UpdatePanelPicture(TextureDict, TextureName)
	PlayerMenu.PlayersColumn:Clear()
	PlayerMenu.PlayersColumn:refreshColumn()

	PlayerMenu.Subtitle = data.name

	local LobbyBadge = 120
	if data.LobbyBadgeIcon then
		LobbyBadge = data.LobbyBadgeIcon
	elseif GetPlayerFromServerId(data.source) ~= -1 then
		if not Player(data.source).state.ScaleformUI_Lua_IsUsingKeyboard then
			LobbyBadge = LobbyBadgeIcon.IS_CONSOLE_PLAYER
		end
	end

	local crew = CrewTag.New(data.CrewTag, true, false, CrewHierarchy.Leader, SColor.HUD_Green)
	local friend = FriendItem.New(data.name, SColor.FromHudColor(data.Colours), true, data.lev, data.Status, crew)

	friend.ClonePed = (ClonePedData[data.name] or PlayerPedId())
	friend:SetLeftIcon(LobbyBadge, false)
	friend:AddPedToPauseMenu(friend.ClonePed) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	local panel = PlayerStatsPanel.New(data.name, SColor.FromHudColor(data.rowColor or 158))
	panel:Description("My name is " .. data.name)
	panel:HasPlane(data.HasPlane)
	panel:HasHeli(data.HasHeli)
	panel:HasBoat(data.HasBoat)
	panel:HasVehicle(data.HasVehicle)
	panel.RankInfo:RankLevel(data.lev)
	-- panel.RankInfo:LowLabel("This is the low label")
	-- panel.RankInfo:MidLabel("This is the middle label")
	-- panel.RankInfo:UpLabel("This is the upper label")
	panel:AddStat(PlayerStatsPanelStatItem.New("Stamina", GetSkillStaminaDescription(data.MP0_STAMINA), data.MP0_STAMINA))
	panel:AddStat(PlayerStatsPanelStatItem.New("Shooting", GetSkillShootingDescription(data.MP0_SHOOTING_ABILITY), data.MP0_SHOOTING_ABILITY))
	panel:AddStat(PlayerStatsPanelStatItem.New("Strength", GetSkillStrengthDescription(data.MP0_STRENGTH), data.MP0_STRENGTH))
	panel:AddStat(PlayerStatsPanelStatItem.New("Stealth", GetSkillStealthDescription(data.MP0_STEALTH_ABILITY), data.MP0_STEALTH_ABILITY))
	panel:AddStat(PlayerStatsPanelStatItem.New("Driving", GetSkillDrivingDescription(data.MP0_DRIVING_ABILITY), data.MP0_DRIVING_ABILITY))
	panel:AddStat(PlayerStatsPanelStatItem.New("Flying", GetSkillFlyingDescription(data.MP0_FLYING_ABILITY), data.MP0_FLYING_ABILITY))
	panel:AddStat(PlayerStatsPanelStatItem.New("Mental State", GetSkillMentalStateDescription(data.MPPLY_KILLS_PLAYERS), data.MPPLY_KILLS_PLAYERS))
	friend:AddPanel(panel)

	PlayerMenu.PlayersColumn:AddPlayer(friend)

	if data.callbackFunction then
		ColumnCallbackFunction[2][#PlayerMenu.PlayersColumn.Items] = data.callbackFunction
	end
end)

AddEventHandler("ScaleformUI_Lua:playermenu:SetInfo", function(data)
	while not menuLoaded do
		Citizen.Wait(0)
	end

	for i = 1, #PlayerMenu.MissionPanel.Items do
		PlayerMenu.MissionPanel:RemoveItem(#PlayerMenu.MissionPanel.Items)
	end

	for k, v in pairs(data) do
		local detailItem = UIMenuFreemodeDetailsItem.New(v.LeftLabel, v.RightLabel, false, v.BadgeStyle, v.Colours)
		PlayerMenu.MissionPanel:AddItem(detailItem)
	end
end)

AddEventHandler("ScaleformUI_Lua:playermenu:SetInfoTitle", function(data)
	while not menuLoaded do
		Citizen.Wait(0)
	end

	if data.Title then
		PlayerMenu.MissionPanel:Title(data.Title)
	end

	if data.tex and data.txd then
		PlayerMenu.MissionPanel:UpdatePanelPicture(data.tex, data.txd)
	end
end)

AddEventHandler("ScaleformUI_Lua:playermenu:SettingsColumn", function(data)
	while not menuLoaded do
		Citizen.Wait(0)
	end

	ColumnCallbackFunction[1] = {}
	PlayerMenu.SettingsColumn:Clear()
	PlayerMenu.SettingsColumn:refreshColumn()

	for k,v in pairs(data) do
		local item
		if v.type == "List" then
			item = UIMenuListItem.New(v.label, v.list, 0, v.dec, SColor.FromHudColor(v.mainColor or 0), SColor.FromHudColor(v.highlightColor or 0), SColor.FromHudColor(v.textColor or 0), SColor.FromHudColor(v.highlightedTextColor or 0))
		elseif v.type == "Checkbox" then
			item = UIMenuCheckboxItem.New(v.label, true, 1, v.dec)
		elseif v.type == "Slider" then
			item = UIMenuSliderItem.New(v.label, 100, 5, 50, false, v.dec)
		elseif v.type == "Progress" then
			item = UIMenuProgressItem.New(v.label, 10, 5, v.dec)
		else
			item = UIMenuItem.New(v.label, v.dec, SColor.FromHudColor(v.mainColor or 0), SColor.FromHudColor(v.highlightColor or 0), SColor.FromHudColor(v.textColor or 0), SColor.FromHudColor(v.highlightedTextColor or 0))
			if v.rightLabel then
				item:RightLabel(v.rightLabel)
			end
		end
		item:BlinkDescription(v.Blink)
		PlayerMenu.SettingsColumn:AddSettings(item)

		if v.callbackFunction then
			ColumnCallbackFunction[1][k] = v.callbackFunction
		end
	end
end)

AddEventHandler("ScaleformUI_Lua:playermenu:Show", function(onClose)
	CreatePlayerMenuMenu()

	if PlayerMenu:Visible() then
		PlayerMenu:Visible(false)
	end
	while firstLoad or IsDisabledControlPressed(0, 199) or IsDisabledControlPressed(0, 200) or IsPauseMenuRestarting() or IsFrontendFading() or IsPauseMenuActive() do
		SetPauseMenuActive(false)
		SetFrontendActive(false)
		Citizen.Wait(0)
	end

	currentSelectId = 1
	currentColumnId = 1

	PlayerMenu.InstructionalButtons = {}
	table.insert(PlayerMenu.InstructionalButtons, InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 191, 191, -1))
	table.insert(PlayerMenu.InstructionalButtons, InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 194, 194, -1))
	table.insert(PlayerMenu.InstructionalButtons, InstructionalButton.New(GetLabelText("HUD_INPUT8"), -1, -1, -1, "INPUTGROUP_FRONTEND_DPAD_ALL"))

	PlayerMenu:Visible(true)
	Citizen.SetTimeout(50, function()
		PlayerMenu:updateFocus(1, true)
	end)

	while PlayerMenu:Visible() do
		if IsDisabledControlJustPressed(0, 201) then
			if ColumnCallbackFunction[currentColumnId][currentSelectId] then
				ColumnCallbackFunction[currentColumnId][currentSelectId]()
				PlayerMenu:Visible(false)
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

AddEventHandler("ScaleformUI_Lua:playermenu:Hide", function()
	if PlayerMenu then
		PlayerMenu:Visible(false)
	end
end)
