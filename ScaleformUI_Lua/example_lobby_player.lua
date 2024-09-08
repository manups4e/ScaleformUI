local PlayerMenu
local defaultSubtitle = "Template by H@mer"

local selectColumnID = 1
local selectRowID = 1

local ColumnCallbackFunction = {}
ColumnCallbackFunction[1] = {}
ColumnCallbackFunction[2] = {}

local firstLoad = true

local function CreatePlayerMenuMenu()
	if not PlayerMenu then
		local columns = {
			SettingsListColumn.New("COLUMN SETTINGS", SColor.HUD_Red),
			PlayerListColumn.New("COLUMN PLAYERS", SColor.HUD_Orange),
			MissionDetailsPanel.New("COLUMN INFO PANEL", SColor.HUD_Green),
		}
		PlayerMenu = MainView.New("Lobby Menu", defaultSubtitle, "", "", "")
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
			selectRowID = idx
			selectColumnID = 1
		end

		PlayerMenu.PlayersColumn.OnIndexChanged = function(idx)
			selectRowID = idx
			selectColumnID = 2
		end

		Citizen.Wait(100)
		firstLoad = false
	end
end

---Can't change while PlayerMenu already visible
AddEventHandler("ScaleformUI:playermenu:SetHeaderMenu", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end

	if data.Title then
		PlayerMenu.Title = data.Title
	end

	if data.Subtitle then
		PlayerMenu.Subtitle = data.Subtitle
	end

	--[[
	if data.SideTop then
		playerMenu.SideTop = data.SideTop
	end
	
	if data.SideMid then
		playerMenu.SideMid = data.SideMid
	end
	
	if data.SideBot then
		playerMenu.SideBot = data.SideBot
	end
	]]

	if data.Col1 then
		PlayerMenu.listCol[1]._label = data.Col1
	end

	if data.Col2 then
		PlayerMenu.listCol[2]._label = data.Col2
	end

	if data.Col3 then
		PlayerMenu.listCol[3]._label = data.Col3
	end

	PlayerMenu.listCol[1]._color = SColor.FromHudColor(HudColours.HUD_COLOUR_FREEMODE)
	PlayerMenu.listCol[2]._color = SColor.FromHudColor(HudColours.HUD_COLOUR_FREEMODE)
	PlayerMenu.listCol[3]._color = SColor.FromHudColor(HudColours.HUD_COLOUR_FREEMODE)
end)

local ClonePedData = {}
AddEventHandler("ScaleformUI:playermenu:SetPlayerList", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end
	if PlayerMenu:Visible() then
		Citizen.Wait(300)
	end

	ColumnCallbackFunction[2] = {}
	PlayerMenu.PlayersColumn:Clear()

	PlayerMenu.Subtitle = data.name

	local LobbyBadge = BadgeStyle.BRAND_BANSHEE
	if data.LobbyBadgeIcon then
		LobbyBadge = data.LobbyBadgeIcon
	elseif GetPlayerFromServerId(data.source) ~= -1 then
		if not Player(data.source).state.IsUsingKeyboard then
			LobbyBadge = LobbyBadgeIcon.IS_CONSOLE_PLAYER
		end
	end

	local crew = CrewTag.New(data.CrewTag, true, false, CrewHierarchy.Leader, SColor.HUD_Green)
	local friend = FriendItem.New(data.name, SColor.FromHudColor(data.Colours), true, data.level, data.Status, crew)

	friend.ClonePed = (ClonePedData[data.name] or PlayerPedId())
	friend:SetLeftIcon(LobbyBadge, false)
	friend:AddPedToPauseMenu(friend.ClonePed) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	local panel = PlayerStatsPanel.New(data.name, SColor.FromHudColor(data.rowColor or HudColours.HUD_COLOUR_VIDEO_EDITOR_AMBIENT))
	panel:Description("My name is " .. data.name)
	panel:HasPlane(data.HasPlane)
	panel:HasHeli(data.HasHeli)
	panel:HasBoat(data.HasBoat)
	panel:HasVehicle(data.HasVehicle)
	panel.RankInfo:RankLevel(data.level)
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

	if PlayerMenu:Visible() then
		PlayerMenu.PlayersColumn:refreshColumn()
	end
end)

AddEventHandler("ScaleformUI:playermenu:SetInfo", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end
	if PlayerMenu:Visible() then
		Citizen.Wait(300)
	end

	for i = 1, #PlayerMenu.MissionPanel.Items do
		PlayerMenu.MissionPanel:RemoveItem(#PlayerMenu.MissionPanel.Items)
	end

	for k, v in pairs(data) do
		local detailItem = UIMenuFreemodeDetailsItem.New(v.LeftLabel, v.RightLabel, false, v.BadgeStyle, v.Colours)
		PlayerMenu.MissionPanel:AddItem(detailItem)
	end
end)

AddEventHandler("ScaleformUI:playermenu:SetInfoTitle", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end
	if PlayerMenu:Visible() then
		Citizen.Wait(300)
	end

	if data.Title then
		PlayerMenu.MissionPanel:Title(data.Title)
	end

	if data.tex and data.txd then
		PlayerMenu.MissionPanel:UpdatePanelPicture(data.tex, data.txd)
	end
end)

AddEventHandler("ScaleformUI:playermenu:SettingsColumn", function(data)
	while firstLoad do
		Citizen.Wait(0)
	end
	if PlayerMenu:Visible() then
		Citizen.Wait(300)
	end

	ColumnCallbackFunction[1] = {}
	PlayerMenu.SettingsColumn:Clear()

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
		PlayerMenu.SettingsColumn:AddSettings(item)

		if v.callbackFunction then
			ColumnCallbackFunction[1][k] = v.callbackFunction
		end
	end

	if PlayerMenu:Visible() then
		PlayerMenu.SettingsColumn:refreshColumn()
	end
end)

AddEventHandler("ScaleformUI:playermenu:Show", function(onClose)
	CreatePlayerMenuMenu()

	if PlayerMenu:Visible() then
		PlayerMenu:Visible(false)
		Citizen.Wait(50)
	end
	while firstLoad or IsDisabledControlPressed(0, 199) or IsDisabledControlPressed(0, 200) or IsPauseMenuRestarting() or IsFrontendFading() or IsPauseMenuActive() do
		SetPauseMenuActive(false)
		SetFrontendActive(false)
		Citizen.Wait(0)
	end
	while PlayerMenu.Subtitle == defaultSubtitle do
		Citizen.Wait(0)
	end

	selectRowID = 1
	selectColumnID = 1

	PlayerMenu.InstructionalButtons = {}
	table.insert(PlayerMenu.InstructionalButtons, InstructionalButton.New(GetLabelText("HUD_INPUT2"), -1, 191, 191, -1))
	table.insert(PlayerMenu.InstructionalButtons, InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 194, 194, -1))
	table.insert(PlayerMenu.InstructionalButtons, InstructionalButton.New(GetLabelText("HUD_INPUT8"), -1, -1, -1, "INPUTGROUP_FRONTEND_DPAD_ALL"))

	PlayerMenu:Visible(true)
	Citizen.SetTimeout(50, function()
		PlayerMenu:updateFocus(2, false)
	end)

	while PlayerMenu:Visible() do
		if IsDisabledControlJustPressed(0, 201) then
			if ColumnCallbackFunction[selectColumnID][selectRowID] then
				ColumnCallbackFunction[selectColumnID][selectRowID]()
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

AddEventHandler("ScaleformUI:playermenu:Hide", function()
	if PlayerMenu then
		PlayerMenu:Visible(false)
	end
end)
