local pool = MenuPool.New()
local animEnabled = true
local timerBarPool = TimerBarPool.New()

function CreateMenu()
	local txd = CreateRuntimeTxd("scaleformui")
	local dui = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "sidepanel", GetDuiHandle(dui))
	
	local exampleMenu = UIMenu.New("ScaleformUI UI", "ScaleformUI SHOWCASE", 50, 50, true, nil, nil, true)
	exampleMenu:MaxItemsOnScreen(7)
	exampleMenu:BuildAsync(true) -- set to false to build in a sync way (might freeze game for a couple ms for high N of items in menus)
	exampleMenu:BuildingAnimation(MenuBuildingAnimation.LEFT_RIGHT)
	exampleMenu:AnimationType(MenuAnimationType.CUBIC_INOUT)
	pool:Add(exampleMenu)

	local ketchupItem = UIMenuCheckboxItem.New("Scrolling animation enabled?", animEnabled, 1, "Do you wish to enable the scrolling animation?")
	ketchupItem:LeftBadge(BadgeStyle.STAR)
	local sidePanel = UIMissionDetailsPanel.New(1, "Side Panel", 6, true, "scaleformui", "sidepanel")
	local detailItem1 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, Colours.HUD_COLOUR_FREEMODE)
	local detailItem2 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.STAR, Colours.HUD_COLOUR_GOLD)
	local detailItem3 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.ARMOR, Colours.HUD_COLOUR_PURPLE)
	local detailItem4 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRAND_DILETTANTE, Colours.HUD_COLOUR_GREEN)
	local detailItem5 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.COUNTRY_GERMANY, Colours.HUD_COLOUR_WHITE, true)
	local detailItem6 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", true)
	local detailItem7 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false)

	sidePanel:AddItem(detailItem1)
	sidePanel:AddItem(detailItem2)
	sidePanel:AddItem(detailItem3)
	sidePanel:AddItem(detailItem4)
	sidePanel:AddItem(detailItem5)
	sidePanel:AddItem(detailItem6)
	sidePanel:AddItem(detailItem7)

	ketchupItem:AddSidePanel(sidePanel)
	exampleMenu:AddItem(ketchupItem)

	local animations = {}
	for k,v in pairs(MenuAnimationType) do
		-- table.insert(animations, k) -- Instead of this , use it like below (learn more here : https://springrts.com/wiki/Lua_Performance#TEST_12:_Adding_Table_Items_.28table.insert_vs._.5B_.5D.29)
		animations[#animations + 1] = k
	end

	local scrollingItem = UIMenuListItem.New("Choose the scrolling animation", animations, exampleMenu:AnimationType(), "~BLIP_BARBER~ ~BLIP_INFO_ICON~ ~BLIP_TANK~ ~BLIP_OFFICE~ ~BLIP_CRIM_DRUGS~ ~BLIP_WAYPOINT~ ~INPUTGROUP_MOVE~~n~You can use Blips and Inputs in description as you prefer!~n~⚠ 🐌 ❤️ 🥺 💪🏻 You can use Emojis too!", Colours.HUD_COLOUR_FREEMODE_DARK, Colours.HUD_COLOUR_FREEMODE)
	scrollingItem:BlinkDescription(true)
	exampleMenu:AddItem(scrollingItem)

	local cookItem = UIMenuItem.New("Cook!", "Cook the dish with the appropiate ingredients and ketchup.")
	exampleMenu:AddItem(cookItem)
	cookItem:RightBadge(BadgeStyle.STAR)
	cookItem:LeftBadge(BadgeStyle.STAR)


	local colorItem = UIMenuItem.New("UIMenuItem with Colors", "~b~Look!!~r~I can be colored ~y~too!!~w~", 21, 24)
	colorItem:LeftBadge(BadgeStyle.STAR)
	exampleMenu:AddItem(colorItem)
	local sidePanelVehicleColor = UIVehicleColorPickerPanel.New(1, "ColorPicker", 6)
	colorItem:AddSidePanel(sidePanelVehicleColor)

	local dynamicValue = 0
	local dynamicListItem = UIMenuDynamicListItem.New("Dynamic List Item", "Try pressing ~INPUT_FRONTEND_LEFT~ or ~INPUT_FRONTEND_RIGHT~", tostring(dynamicValue), function(item, direction)
		if(direction == "left") then
			dynamicValue = dynamicValue -1
		elseif(direction == "right") then
			dynamicValue = dynamicValue +1
		end
		return tostring(dynamicValue)
	end)
	exampleMenu:AddItem(dynamicListItem)
	dynamicListItem:LeftBadge(BadgeStyle.STAR)

	local seperatorItem1 = UIMenuSeperatorItem.New("Separator (Jumped)", true)
	local seperatorItem2 = UIMenuSeperatorItem.New("Separator (not Jumped)", false)
	exampleMenu:AddItem(seperatorItem1)
	exampleMenu:AddItem(seperatorItem2)

	local foodsList = {"Banana", "Apple", "Pizza", "Quartilicious"}
	local colorListItem  = UIMenuListItem.New("Colored ListItem.. Really?", foodsList, 0, "~BLIP_BARBER~ ~BLIP_INFO_ICON~ ~BLIP_TANK~ ~BLIP_OFFICE~ ~BLIP_CRIM_DRUGS~ ~BLIP_WAYPOINT~ ~INPUTGROUP_MOVE~~n~You can use Blips and Inputs in description as you prefer!", 21, 24)
	exampleMenu:AddItem(colorListItem)

	local sliderItem = UIMenuSliderItem.New("Slider Item!", 100, 5, 50, false, "Cool!")
	exampleMenu:AddItem(sliderItem)
	local progressItem = UIMenuProgressItem.New("Slider Progress Item", 10, 5)
	exampleMenu:AddItem(progressItem)

	local listPanelItem1 = UIMenuItem.New("Change Color", "It can be whatever item you want it to be")
	local colorPanel = UIMenuColorPanel.New("Color Panel Example", 1, 0)
	local colorPanel2 = UIMenuColorPanel.New("Custom Palette Example", 1, 0, {"HUD_COLOUR_GREEN", "HUD_COLOUR_RED", "HUD_COLOUR_FREEMODE", "HUD_COLOUR_PURPLE", "HUD_COLOUR_TREVOR"})
	exampleMenu:AddItem(listPanelItem1)
	listPanelItem1:AddPanel(colorPanel)
	listPanelItem1:AddPanel(colorPanel2)

	local listPanelItem2 = UIMenuItem.New("Change Percentage", "It can be whatever item you want it to be")
	local percentagePanel = UIMenuPercentagePanel.New("Percentage Panel Example", "0%", "100%")
	exampleMenu:AddItem(listPanelItem2)
	listPanelItem2:AddPanel(percentagePanel)

	local listPanelItem3 = UIMenuItem.New("Change Grid Position", "It can be whatever item you want it to be")
	local gridPanel = UIMenuGridPanel.New("Up", "Left", "Right", "Down", vector2(0.5, 0.5), 0)
	local horizontalGridPanel = UIMenuGridPanel.New("", "Left", "Right", "", vector2(0.5, 0.5), 1)
	exampleMenu:AddItem(listPanelItem3)
	listPanelItem3:AddPanel(gridPanel)
	listPanelItem3:AddPanel(horizontalGridPanel)

	local listPanelItem4 = UIMenuListItem.New("Look at Statistics", {"Example", "example2"}, 0)
	local statisticsPanel = UIMenuStatisticsPanel.New()
	statisticsPanel:AddStatistic("Look at this!", 10.0)
	statisticsPanel:AddStatistic("I'm a statistic too!", 50.0)
	statisticsPanel:AddStatistic("Am i not?!", 100.0)
	exampleMenu:AddItem(listPanelItem4)
	listPanelItem4:AddPanel(statisticsPanel)

	--[[
		2 ways to add submenus.. 
		- the old way => local submenu = pool:AddSubMenu(parent, ...)
		- way.New => 
			local subMenu = UIMenu.New()
			parent:AddSubMenu(subMenu, itemText, itemDescription, offset, KeepBanner)
	]]
	local windowSubmenu = UIMenu.New("Windows Submenu", "Windows Subtitle")
	exampleMenu:AddSubMenu(windowSubmenu, "Windows Menu", "separate descriptions yeeeeah", nil, true)
	local heritageWindow = UIMenuHeritageWindow.New(0, 0)
	local detailsWindow = UIMenuDetailsWindow.New("Parents resemblance", "Dad:", "Mom:", true, {})
	windowSubmenu:AddWindow(heritageWindow)
	windowSubmenu:AddWindow(detailsWindow)
	local momNames = {"Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camilla", "Violet", "Sophia", "Eveline", "Nicole", "Ashley", "Grace", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma", "Misty"}
	local dadNames = {"Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Joan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony", "Claude", "Niko", "John"}

	local momListItem  = UIMenuListItem.New("Mom", momNames, 0)
	local dadListItem  = UIMenuListItem.New("Dad", dadNames, 0)
	local heritageSliderItem = UIMenuSliderItem.New("Heritage Slider", 100, 5, 0, true, "This is Useful on heritage")
	windowSubmenu:AddItem(momListItem)
	windowSubmenu:AddItem(dadListItem)
	windowSubmenu:AddItem(heritageSliderItem)

	detailsWindow.DetailMid = "Dad: " .. heritageSliderItem:Index() .. "%"
	detailsWindow.DetailBottom = "Mom: " .. (100 - heritageSliderItem:Index()) .. "%"
	detailsWindow.DetailStats = {
		{
			Percentage = 100,
			HudColor = 6
		},
		{
			Percentage = 0,
			HudColor = 50
		}
	}

	detailsWindow:UpdateStatsToWheel()

	exampleMenu.OnMenuChanged = function(old, new, type)
		if type == "opened" then
			print("Menu opened!")
		elseif type == "closed" then
			print("Menu closed!")
		elseif type == "backwards" then
			print("Menu going backwards!")
		elseif type == "forwards" then
			print("Menu going forwards!")
		end
	end

	ketchupItem.OnCheckboxChanged = function(menu, item, checked)
		sidePanel:UpdatePanelTitle(tostring(checked))
		menu:AnimationEnabled(checked)
		scrollingItem:Enabled(checked)
		if checked then
			scrollingItem:LeftBadge(BadgeStyle.NONE)
		else
			scrollingItem:LeftBadge(1)
		end
	end

	scrollingItem.OnListChanged = function(menu, item, index)
		menu:AnimationType(index)
	end

	colorPanel.OnColorPanelChanged = function(menu, item, newindex)
		print(newindex)
		local message = "ColorPanel index => " .. newindex + 1
		AddTextEntry("ScaleformUINotification", message)
		BeginTextCommandThefeedPost("ScaleformUINotification")
		EndTextCommandThefeedPostTicker(false, true)
	end

	colorPanel2.OnColorPanelChanged = function(menu, item, newindex)
		local message = "ColorPanel2 index => " .. newindex + 1
		AddTextEntry("ScaleformUINotification", message)
		BeginTextCommandThefeedPost("ScaleformUINotification")
		EndTextCommandThefeedPostTicker(false, true)
	end

	percentagePanel.OnPercentagePanelChange = function(menu, item, newpercentage)
		local message = "PercentagePanel => " .. newpercentage
		ScaleformUI.Notifications:ShowSubtitle(message)
	end

	gridPanel.OnGridPanelChanged = function(menu, item, newposition)
		local message = "PercentagePanel => " .. newposition
		ScaleformUI.Notifications:ShowSubtitle(message)
	end

	horizontalGridPanel.OnGridPanelChanged = function(menu, item, newposition)
		local message = "PercentagePanel => " .. newposition
		ScaleformUI.Notifications:ShowSubtitle(message)
	end

	sidePanelVehicleColor.PickerSelect = function(menu, item, newindex)
		local message = "ColorPanel index => " .. newindex + 1
		ScaleformUI.Notifications:ShowNotification(message)
	end

	local MomIndex = 0
	local DadIndex = 0

	windowSubmenu.OnListChange = function(menu, item, newindex)
		if (item == momListItem) then
			MomIndex = newindex
		elseif (item == dadListItem) then
			DadIndex = newindex
		end
		heritageWindow:Index(MomIndex, DadIndex)
	end

	heritageSliderItem.OnSliderChanged = function(menu, item, value)
		detailsWindow.DetailStats[1].Percentage = 100 - value
		detailsWindow.DetailStats[2].Percentage = value
		detailsWindow:UpdateStatsToWheel()
		detailsWindow:UpdateLabels("Parents resemblance", "Dad: " .. value .. "%", "Mom: " .. (100 - value) .. "%")
	end

	exampleMenu:Visible(true)
end

function CreatePauseMenu()
	local pauseMenuExample = TabView.New("ScaleformUI LUA", "THE LUA API", GetPlayerName(PlayerId()), "String middle", "String bottom")

	local handle = RegisterPedheadshot(PlayerPedId())
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Wait(0) end
    local txd = GetPedheadshotTxdString(handle)
	pauseMenuExample:HeaderPicture(txd, txd) 	-- pauseMenuExample:CrewPicture used to add a picture on the left of the HeaderPicture
	print("PedHandle => " .. handle)
	UnregisterPedheadshot(handle) -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform.. 

	pool:AddPauseMenu(pauseMenuExample)

	local basicTab = TextTab.New("TEXTTAB", "This is the Title!")
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~r~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~b~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~g~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~r~Use the mouse wheel to scroll the text!!"))
	pauseMenuExample:AddTab(basicTab)

	local multiItemTab = SubmenuTab.New("SUBMENUTAB") -- this is the tab with multiple sub menus in it.. each submenu has a different purpose
	pauseMenuExample:AddTab(multiItemTab)
	local first = TabLeftItem.New("1 - Empty", LeftItemType.Empty) -- empty item.. 
	local second = TabLeftItem.New("2 - Info", LeftItemType.Info) -- info (like briefings..)
	local third = TabLeftItem.New("3 - Statistics", LeftItemType.Statistics) -- for statistics
	local fourth = TabLeftItem.New("4 - Settings", LeftItemType.Settings) -- well.. settings..
	local fifth = TabLeftItem.New("5 - Keymaps", LeftItemType.Keymap) -- keymaps for custom keymapping 
	first:Enabled(false)
	multiItemTab:AddLeftItem(first)
	multiItemTab:AddLeftItem(second)
	multiItemTab:AddLeftItem(third)
	multiItemTab:AddLeftItem(fourth)
	multiItemTab:AddLeftItem(fifth)

	second.TextTitle = "Info Title!!"
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~r~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~b~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~g~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(BasicTabItem.New("~BLIP_INFO_ICON~ ~r~Use the mouse wheel to scroll the text!!"))

	local _labelStatItem = StatsTabItem.NewBasic("Item's Label", "Item's right label")
	local _coloredBarStatItem0 = StatsTabItem.NewBar("Item's Label", 0, Colours.HUD_COLOUR_ORANGE)
	local _coloredBarStatItem1 = StatsTabItem.NewBar("Item's Label", 25, Colours.HUD_COLOUR_RED)
	local _coloredBarStatItem2 = StatsTabItem.NewBar("Item's Label", 50, Colours.HUD_COLOUR_BLUE)
	local _coloredBarStatItem3 = StatsTabItem.NewBar("Item's Label", 75, Colours.HUD_COLOUR_GREEN)
	local _coloredBarStatItem4 = StatsTabItem.NewBar("Item's Label", 100, Colours.HUD_COLOUR_PURPLE)

	third:AddItem(_labelStatItem)
	third:AddItem(_coloredBarStatItem0)
	third:AddItem(_coloredBarStatItem1)
	third:AddItem(_coloredBarStatItem2)
	third:AddItem(_coloredBarStatItem3)
	third:AddItem(_coloredBarStatItem4)

	local itemList = { "This", "Is", "The", "List", "Super", "Power", "Wooow" }
	local _settings1 = SettingsItem.New("Item's Label", "Item's right Label") 
	local _settings2 = SettingsListItem.New("Item's Label", itemList, 0)
	local _settings3 = SettingsProgressItem.New("Item's Label", 100, 25, false, Colours.HUD_COLOUR_FREEMODE)
	local _settings4 = SettingsProgressItem.New("Item's Label", 100, 75, true, Colours.HUD_COLOUR_PINK)
	local _settings5 = SettingsCheckboxItem.New("Item's Label", 1, true) -- 0 = cross / 1 = tick
	local _settings6 = SettingsSliderItem.New("Item's Label", 100, 50, Colours.HUD_COLOUR_RED)
	fourth:AddItem(_settings1)
	fourth:AddItem(_settings2)
	fourth:AddItem(_settings3)
	fourth:AddItem(_settings4)
	fourth:AddItem(_settings5)
	fourth:AddItem(_settings6)

	fifth.TextTitle = "ACTION"
	fifth.KeymapRightLabel_1 = "PRIMARY"
	fifth.KeymapRightLabel_2 = "SECONDARY"
	local key1 = KeymapItem.New("Simple Keymap", "~INPUT_FRONTEND_ACCEPT~", "~INPUT_VEH_EXIT~")
	local key2 = KeymapItem.New("Advanced Keymap", "~INPUT_SPRINT~ + ~INPUT_CONTEXT~", "", "", "~INPUTGROUP_FRONTEND_TRIGGERS~")
	fifth:AddItem(key1)
	fifth:AddItem(key2)
	fifth:AddItem(key1)
	fifth:AddItem(key2)
	fifth:AddItem(key1)
	fifth:AddItem(key2)
	fifth:AddItem(key1)
	fifth:AddItem(key2)

	local playersTab = PlayerListTab.New("PLAYERLISTTAB")
	pauseMenuExample:AddTab(playersTab)

	local item = UIMenuItem.New("UIMenuItem", "UIMenuItem description")
	local item1 = UIMenuListItem.New("UIMenuListItem", { "This", "is", "a", "Test"}, 0, "UIMenuListItem description")
	local item2 = UIMenuCheckboxItem.New("UIMenuCheckboxItem", true, 1, "UIMenuCheckboxItem description")
	local item3 = UIMenuSliderItem.New("UIMenuSliderItem", 100, 5, 50, false, "UIMenuSliderItem description")
	local item4 = UIMenuProgressItem.New("UIMenuProgressItem", 10, 5, "UIMenuProgressItem description")
	item:BlinkDescription(true)

	playersTab.SettingsColumn:AddSettings(item)
	playersTab.SettingsColumn:AddSettings(item1)
	playersTab.SettingsColumn:AddSettings(item2)
	playersTab.SettingsColumn:AddSettings(item3)
	playersTab.SettingsColumn:AddSettings(item4)

	local friend = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_GREEN, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
	local friend1 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_MENU_YELLOW, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
	local friend2 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_PINK, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
	local friend3 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_BLUE, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
	local friend4 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_ORANGE, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
	local friend5 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_RED, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
	friend:SetLeftIcon(LobbyBadgeIcon.IS_CONSOLE_PLAYER, false)
	friend1:SetLeftIcon(LobbyBadgeIcon.IS_PC_PLAYER, false)
	friend2:SetLeftIcon(LobbyBadgeIcon.SPECTATOR, false)
	friend3:SetLeftIcon(LobbyBadgeIcon.INACTIVE_HEADSET, false)
	friend4:SetLeftIcon(BadgeStyle.COUNTRY_ITALY, true)
	friend5:SetLeftIcon(BadgeStyle.CASTLE, true)

	friend:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	friend1:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	friend2:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	friend3:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	friend4:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	friend5:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu

	local panel = PlayerStatsPanel.New("Player 1", Colours.HUD_COLOUR_GREEN)
	panel:Description("This is the description for Player 1!!")
	panel:HasPlane(true)
	panel:HasHeli(true)
	panel.RankInfo:RankLevel(150)
	panel.RankInfo:LowLabel("This is the low label")
	panel.RankInfo:MidLabel("This is the middle label")
	panel.RankInfo:UpLabel("This is the upper label")
	panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
	panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
	panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
	panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
	panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
	friend:AddPanel(panel)

	local panel1 = PlayerStatsPanel.New("Player 2", Colours.HUD_COLOUR_MENU_YELLOW)
	panel1:Description("This is the description for Player 2!!")
	panel1:HasPlane(true)
	panel1:HasVehicle(true)
	panel1.RankInfo:RankLevel(70)
	panel1.RankInfo:LowLabel("This is the low label")
	panel1.RankInfo:MidLabel("This is the middle label")
	panel1.RankInfo:UpLabel("This is the upper label")
	panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
	panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
	panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
	panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
	panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
	friend1:AddPanel(panel1)

	local panel2 = PlayerStatsPanel.New("Player 3", Colours.HUD_COLOUR_PINK)
	panel2:Description("This is the description for Player 3!!")
	panel2:HasPlane(true)
	panel2:HasHeli(true)
	panel2:HasVehicle(true)
	panel2.RankInfo:RankLevel(15)
	panel2.RankInfo:LowLabel("This is the low label")
	panel2.RankInfo:MidLabel("This is the middle label")
	panel2.RankInfo:UpLabel("This is the upper label")
	panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
	panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
	panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
	panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
	panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
	friend2:AddPanel(panel2)

	local panel3 = PlayerStatsPanel.New("Player 4", Colours.HUD_COLOUR_FREEMODE)
	panel3:Description("This is the description for Player 4!!")
	panel3:HasPlane(true)
	panel3:HasHeli(true)
	panel3:HasBoat(true)
	panel3.RankInfo:RankLevel(10)
	panel3.RankInfo:LowLabel("This is the low label")
	panel3.RankInfo:MidLabel("This is the middle label")
	panel3.RankInfo:UpLabel("This is the upper label")
	panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
	panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
	panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
	panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
	panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
	friend3:AddPanel(panel3)

	local panel4 = PlayerStatsPanel.New("Player 5", Colours.HUD_COLOUR_ORANGE)
	panel4:Description("This is the description for Player 5!!")
	panel4:HasPlane(true)
	panel4:HasHeli(true)
	panel4.RankInfo:RankLevel(1000)
	panel4.RankInfo:LowLabel("This is the low label")
	panel4.RankInfo:MidLabel("This is the middle label")
	panel4.RankInfo:UpLabel("This is the upper label")
	panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
	panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
	panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
	panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
	panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
	friend4:AddPanel(panel4)

	local panel5 = PlayerStatsPanel.New("Player 6", Colours.HUD_COLOUR_RED)
	panel5:Description("This is the description for Player 6!!")
	panel5:HasPlane(true)
	panel5:HasHeli(true)
	panel5.RankInfo:RankLevel(22)
	panel5.RankInfo:LowLabel("This is the low label")
	panel5.RankInfo:MidLabel("This is the middle label")
	panel5.RankInfo:UpLabel("This is the upper label")
	panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
	panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
	panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
	panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
	panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
	friend5:AddPanel(panel5)

	playersTab.PlayersColumn:AddPlayer(friend)
	playersTab.PlayersColumn:AddPlayer(friend1)
	playersTab.PlayersColumn:AddPlayer(friend2)
	playersTab.PlayersColumn:AddPlayer(friend3)
	playersTab.PlayersColumn:AddPlayer(friend4)
	playersTab.PlayersColumn:AddPlayer(friend5)

	
	playersTab.PlayersColumn.OnIndexChanged = function(idx)
		ScaleformUI.Notifications:ShowSubtitle("PlayersColumn index =>~b~ ".. idx .. "~w~.")
	end
	playersTab.SettingsColumn.OnIndexChanged = function(idx)
		ScaleformUI.Notifications:ShowSubtitle("SettingsColumn index =>~b~ ".. idx .. "~w~.")
	end

	pauseMenuExample.OnPauseMenuOpen = function(menu)
		Notifications:ShowSubtitle(menu.Title .. " Opened!")
	end

	pauseMenuExample.OnPauseMenuClose = function(menu)
		Notifications:ShowSubtitle(menu.Title .. " Closed!")
	end

	pauseMenuExample.OnPauseMenuTabChanged = function(menu, tab, tabIndex)
		Notifications:ShowSubtitle(tab.Label .. " Selected!")
	end

	pauseMenuExample.OnPauseMenuFocusChanged = function(menu, tab, focusLevel)
		Notifications:ShowSubtitle(tab.Label .. " Focus at level =>~y~ " .. focusLevel .. " ~w~~s~!")
		if focusLevel == 1 then
			local _, subType = tab()
			if subType == "TextTab" then
				local buttons = {
					InstructionalButton.New(GetLabelText("HUD_INPUT3"), -1, 177, 177, -1),
					InstructionalButton.New("Scroll text", 0, 2, -1, -1),
					InstructionalButton.New("Scroll text", 1, -1, -1, "INPUTGROUP_CURSOR_SCROLL")
					-- cannot make difference between controller / keyboard here in 1 line because we are using the InputGroup for keyboard
				}
				ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(buttons)
			end 
		elseif focusLevel == 0 then
			ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(menu.InstructionalButtons)
		end
	end

	pauseMenuExample.OnLeftItemChange = function(menu, item, leftItemIndex)
		Notifications:ShowSubtitle("OnLeftItemChange:"..menu.Tabs[menu.Index].Label .. " Focus at level =>~y~ " .. menu.focusLevel .. "~s~~w~, and left Item ~o~N° " .. leftItemIndex .. "~w~ selected!")
	end

	pauseMenuExample.OnRightItemChange = function (menu, item, rightItemIndex)
		Notifications:ShowSubtitle(menu.Tabs[menu.Index].Label .. " Focus at level => ~y~ " .. menu:FocusLevel() .. "~w~, left Item ~o~N° " .. menu:LeftItemIndex() .. "~w~ and right Item ~b~N° " .. rightItemIndex .. "~w~ selected!")
	end

	pauseMenuExample:Visible(true)
end

function CreateLobbyMenu()
		local lobbyMenu = MainView.New("Lobby Menu", "ScaleformUI for you by Manups4e!", "Detail 1", "Detail 2", "Detail 3")
		local columns = {
			SettingsListColumn.New("COLUMN SETTINGS", Colours.HUD_COLOUR_RED),
			PlayerListColumn.New("COLUMN PLAYERS", Colours.HUD_COLOUR_ORANGE),
			MissionDetailsPanel.New("COLUMN INFO PANEL", Colours.HUD_COLOUR_GREEN),
		}
		lobbyMenu:SetupColumns(columns)

		local handle = RegisterPedheadshot(PlayerPedId())
		while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Wait(0) end
		local txd = GetPedheadshotTxdString(handle)
		lobbyMenu:HeaderPicture(txd, txd) 	-- lobbyMenu:CrewPicture used to add a picture on the left of the HeaderPicture

		UnregisterPedheadshot(handle) -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform.. 

		pool:AddPauseMenu(lobbyMenu)
		lobbyMenu:CanPlayerCloseMenu(true)
		-- this is just an example..CanPlayerCloseMenu is always defaulted to true.. if you set this to false.. be sure to give the players a way out of your menu!!! 
		local item = UIMenuItem.New("UIMenuItem", "UIMenuItem description")
		local item1 = UIMenuListItem.New("UIMenuListItem", { "This", "is", "a", "Test"}, 0, "UIMenuListItem description")
		local item2 = UIMenuCheckboxItem.New("UIMenuCheckboxItem", true, 1, "UIMenuCheckboxItem description")
		local item3 = UIMenuSliderItem.New("UIMenuSliderItem", 100, 5, 50, false, "UIMenuSliderItem description")
		local item4 = UIMenuProgressItem.New("UIMenuProgressItem", 10, 5, "UIMenuProgressItem description")
		item:BlinkDescription(true)
		lobbyMenu.SettingsColumn:AddSettings(item)
		lobbyMenu.SettingsColumn:AddSettings(item1)
		lobbyMenu.SettingsColumn:AddSettings(item2)
		lobbyMenu.SettingsColumn:AddSettings(item3)
		lobbyMenu.SettingsColumn:AddSettings(item4)

		local friend = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_GREEN, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
		local friend1 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_MENU_YELLOW, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
		local friend2 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_PINK, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
		local friend3 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_BLUE, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
		local friend4 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_ORANGE, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
		local friend5 = FriendItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_RED, true, GetRandomIntInRange(15, 55), "Status", "CrewTag")
		friend:SetLeftIcon(LobbyBadgeIcon.IS_CONSOLE_PLAYER, false)
		friend1:SetLeftIcon(LobbyBadgeIcon.IS_PC_PLAYER, false)
		friend2:SetLeftIcon(LobbyBadgeIcon.SPECTATOR, false)
		friend3:SetLeftIcon(LobbyBadgeIcon.INACTIVE_HEADSET, false)
		friend4:SetLeftIcon(BadgeStyle.COUNTRY_ITALY, true)
		friend5:SetLeftIcon(BadgeStyle.CASTLE, true)

		friend:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
		friend1:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
		friend2:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
		friend3:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
		friend4:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
		friend5:AddPedToPauseMenu(PlayerPedId()) -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	
		local panel = PlayerStatsPanel.New("Player 1", Colours.HUD_COLOUR_GREEN)
		panel:Description("This is the description for Player 1!!")
		panel:HasPlane(true)
		panel:HasHeli(true)
		panel.RankInfo:RankLevel(150)
		panel.RankInfo:LowLabel("This is the low label")
		panel.RankInfo:MidLabel("This is the middle label")
		panel.RankInfo:UpLabel("This is the upper label")
		panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
		panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
		panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
		panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
		panel:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
		friend:AddPanel(panel)
	
		local panel1 = PlayerStatsPanel.New("Player 2", Colours.HUD_COLOUR_MENU_YELLOW)
		panel1:Description("This is the description for Player 2!!")
		panel1:HasPlane(true)
		panel1:HasVehicle(true)
		panel1.RankInfo:RankLevel(70)
		panel1.RankInfo:LowLabel("This is the low label")
		panel1.RankInfo:MidLabel("This is the middle label")
		panel1.RankInfo:UpLabel("This is the upper label")
		panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
		panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
		panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
		panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
		panel1:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
		friend1:AddPanel(panel1)
	
		local panel2 = PlayerStatsPanel.New("Player 3", Colours.HUD_COLOUR_PINK)
		panel2:Description("This is the description for Player 3!!")
		panel2:HasPlane(true)
		panel2:HasHeli(true)
		panel2:HasVehicle(true)
		panel2.RankInfo:RankLevel(15)
		panel2.RankInfo:LowLabel("This is the low label")
		panel2.RankInfo:MidLabel("This is the middle label")
		panel2.RankInfo:UpLabel("This is the upper label")
		panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
		panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
		panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
		panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
		panel2:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
		friend2:AddPanel(panel2)
	
		local panel3 = PlayerStatsPanel.New("Player 4", Colours.HUD_COLOUR_FREEMODE)
		panel3:Description("This is the description for Player 4!!")
		panel3:HasPlane(true)
		panel3:HasHeli(true)
		panel3:HasBoat(true)
		panel3.RankInfo:RankLevel(10)
		panel3.RankInfo:LowLabel("This is the low label")
		panel3.RankInfo:MidLabel("This is the middle label")
		panel3.RankInfo:UpLabel("This is the upper label")
		panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
		panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
		panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
		panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
		panel3:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
		friend3:AddPanel(panel3)
	
		local panel4 = PlayerStatsPanel.New("Player 5", Colours.HUD_COLOUR_ORANGE)
		panel4:Description("This is the description for Player 5!!")
		panel4:HasPlane(true)
		panel4:HasHeli(true)
		panel4.RankInfo:RankLevel(1000)
		panel4.RankInfo:LowLabel("This is the low label")
		panel4.RankInfo:MidLabel("This is the middle label")
		panel4.RankInfo:UpLabel("This is the upper label")
		panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
		panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
		panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
		panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
		panel4:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
		friend4:AddPanel(panel4)
	
		local panel5 = PlayerStatsPanel.New("Player 6", Colours.HUD_COLOUR_RED)
		panel5:Description("This is the description for Player 6!!")
		panel5:HasPlane(true)
		panel5:HasHeli(true)
		panel5.RankInfo:RankLevel(22)
		panel5.RankInfo:LowLabel("This is the low label")
		panel5.RankInfo:MidLabel("This is the middle label")
		panel5.RankInfo:UpLabel("This is the upper label")
		panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 1", "Description 1", GetRandomIntInRange(30, 150)))
		panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 2", "Description 2", GetRandomIntInRange(30, 150)))
		panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 3", "Description 3", GetRandomIntInRange(30, 150)))
		panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 4", "Description 4", GetRandomIntInRange(30, 150)))
		panel5:AddStat(PlayerStatsPanelStatItem.New("Statistic 5", "Description 5", GetRandomIntInRange(30, 150)))
		friend5:AddPanel(panel5)
	
		lobbyMenu.PlayersColumn:AddPlayer(friend)
		lobbyMenu.PlayersColumn:AddPlayer(friend1)
		lobbyMenu.PlayersColumn:AddPlayer(friend2)
		lobbyMenu.PlayersColumn:AddPlayer(friend3)
		lobbyMenu.PlayersColumn:AddPlayer(friend4)
		lobbyMenu.PlayersColumn:AddPlayer(friend5)

		
		local txd = CreateRuntimeTxd("scaleformui");
		local _paneldui = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
		CreateRuntimeTextureFromDuiHandle(txd, "lobby_panelbackground", GetDuiHandle(_paneldui))

		lobbyMenu.MissionPanel:UpdatePanelPicture("scaleformui", "lobby_panelbackground")
		lobbyMenu.MissionPanel:Title("ScaleformUI - Title")
		local detailItem1 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, Colours.HUD_COLOUR_FREEMODE)
		local detailItem2 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.STAR, Colours.HUD_COLOUR_GOLD)
		local detailItem3 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.ARMOR, Colours.HUD_COLOUR_PURPLE)
		local detailItem4 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRAND_DILETTANTE, Colours.HUD_COLOUR_GREEN)
		local detailItem5 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.COUNTRY_ITALY, Colours.HUD_COLOUR_WHITE, true)
		local detailItem6 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", true)
		local detailItem7 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false)
		--local missionItem4 = new("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "", false)
		lobbyMenu.MissionPanel:AddItem(detailItem1)
		lobbyMenu.MissionPanel:AddItem(detailItem2)
		lobbyMenu.MissionPanel:AddItem(detailItem3)
		lobbyMenu.MissionPanel:AddItem(detailItem4)
		lobbyMenu.MissionPanel:AddItem(detailItem5)
		lobbyMenu.MissionPanel:AddItem(detailItem6)
		lobbyMenu.MissionPanel:AddItem(detailItem7)

		lobbyMenu.SettingsColumn.OnIndexChanged = function(idx)
			ScaleformUI.Notifications:ShowSubtitle("SettingsColumn index =>~b~ ".. idx .. "~w~.")
		end

		lobbyMenu.PlayersColumn.OnIndexChanged = function(idx)
			ScaleformUI.Notifications:ShowSubtitle("PlayersColumn index =>~b~ ".. idx .. "~w~.")
		end

		lobbyMenu:Visible(true)
end

local MissionSelectorVisible = false
function CreateMissionSelectorMenu()

	MissionSelectorVisible = not MissionSelectorVisible

	if not MissionSelectorVisible then 
		ScaleformUI.Scaleforms.JobMissionSelector:Enabled(false) 
		return
	end

	local txd = CreateRuntimeTxd("test");
	local _paneldui = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160);
	CreateRuntimeTextureFromDuiHandle(txd, "panelbackground", GetDuiHandle(_paneldui));

	ScaleformUI.Scaleforms.JobMissionSelector:SetTitle("MISSION SELECTOR")
	ScaleformUI.Scaleforms.JobMissionSelector.MaxVotes = 3
	ScaleformUI.Scaleforms.JobMissionSelector:SetVotes(0, "VOTED")
	ScaleformUI.Scaleforms.JobMissionSelector.Cards = {}

	local card = JobSelectionCard.New("Test 1", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card)

	local card1 = JobSelectionCard.New("Test 2", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card1)

	local card2 = JobSelectionCard.New("Test 3", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card2)

	local card3 = JobSelectionCard.New("Test 4", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card3)

	local card4 = JobSelectionCard.New("Test 5", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card4)

	local card5 = JobSelectionCard.New("Test 6", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, Colours.HUD_COLOUR_FREEMODE, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card5)

	ScaleformUI.Scaleforms.JobMissionSelector.Buttons = {
		JobSelectionButton.New("Button 1", "description test", {
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
		}),
		JobSelectionButton.New("Button 2", "description test", {
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
		}),
		JobSelectionButton.New("Button 3", "description test", {
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, Colours.HUD_COLOUR_FREEMODE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, Colours.HUD_COLOUR_GOLD),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, Colours.HUD_COLOUR_PURPLE),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, Colours.HUD_COLOUR_GREEN),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, Colours.HUD_COLOUR_WHITE, true),
		}),
	}
	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[1].Selectable = false
	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[2].Selectable = false
	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[3].Selectable = true

	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[1].OnButtonPressed = function()
		ScaleformUI.Notifications:ShowSubtitle("Button Pressed => " .. ScaleformUI.Scaleforms.JobMissionSelector.Buttons[1].Text)
	end
	ScaleformUI.Scaleforms.JobMissionSelector:Enabled(true)
	
	Wait(1000)
	ScaleformUI.Scaleforms.JobMissionSelector:ShowPlayerVote(3, "PlayerName", Colours.HUD_COLOUR_GREEN, true, true)
end

CreateThread(function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	--type, position, scale, distance, color, placeOnGround, bobUpDown, rotate, faceCamera, checkZ
	local marker = Marker.New(1, pos, vector3(2,2,2), 100.0, {R=0, G= 100, B=50, A=255}, true, false, false, false, true)

	-- example for working timerBars.. you can disable them by setting :Enabled(false).. to hide and show them while drawing :)
	local textBar = TextTimerBar.New("Label", "Caption")
	local progrBar = ProgressTimerBar.New("Label")
	progrBar:Percentage(0.5) -- goes from 0.0 to 1.0
	timerBarPool:AddBar(textBar)
	timerBarPool:AddBar(progrBar)

	while true do
		Wait(0)
		marker:Draw()
		ScaleformUI.Notifications:DrawText(0.3, 0.9, "Ped is in Range => " .. tostring(marker:IsInRange()))
		ScaleformUI.Notifications:DrawText(0.3, 0.925, "Ped is in Marker =>" .. tostring(marker.IsInMarker))
		ScaleformUI.Notifications:DrawText(0.3, 0.95, "pool menu count =>" .. (#pool.Menus+#pool.PauseMenus))

		-- TIMER BARS FOR THE MOMENT ARE A SET OF SPRITES TEXTS AND RECTS, DRAWING THEM WILL INCREASE A LOT SCALEFORMUI'S CPU TIME!
		timerBarPool:Draw()

		if IsControlJustPressed(0, 166) and not pool:IsAnyMenuOpen() then -- F5
			CreateMenu()
		end
		if IsControlJustPressed(0, 167) and not pool:IsAnyMenuOpen() then -- F6
			CreatePauseMenu()
		end
		if IsControlJustPressed(0, 168) and not pool:IsAnyMenuOpen() then -- F7
			CreateLobbyMenu()
		end

		if IsControlJustPressed(0, 170) or IsDisabledControlJustPressed(0, 170) and not pool:IsAnyMenuOpen() then -- F3
			CreateMissionSelectorMenu()
		end
		
		if IsControlJustPressed(0, 56) and not pool:IsAnyMenuOpen() then -- F9
			local handle = RegisterPedheadshot(PlayerPedId())
			while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Wait(0) end
			local txd = GetPedheadshotTxdString(handle)
				
			ScaleformUI.Scaleforms.PlayerListScoreboard:SetTitle("Title", "leftLabel", 2)

			local row1 = SCPlayerItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_GREEN, 65, 50, "", "hello", "", 0, "", 1, txd)
			local row2 = SCPlayerItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_RED, 65, 100, "", "hello", "", 0, "", 1, txd)
			local row3 = SCPlayerItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_BLUE, 65, 200, "", "hello", "", 0, "", 1, txd)
			local row4 = SCPlayerItem.New(GetPlayerName(PlayerId()), Colours.HUD_COLOUR_PURPLE, 65, 250, "", "hello", "", 0, "", 1, txd)
			ScaleformUI.Scaleforms.PlayerListScoreboard:AddRow(row1)
			ScaleformUI.Scaleforms.PlayerListScoreboard:AddRow(row2)
			ScaleformUI.Scaleforms.PlayerListScoreboard:AddRow(row3)
			ScaleformUI.Scaleforms.PlayerListScoreboard:AddRow(row4)

			ScaleformUI.Scaleforms.PlayerListScoreboard:CurrentPage(1)
			ScaleformUI.Scaleforms.PlayerListScoreboard.Enabled = true
			UnregisterPedheadshot(handle) -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform.. 

		end

		-- this is used to free memory from all the menus in the MenuPool emptying its tables.
		-- YOU WILL NEED TO REBUILD YOUR MENUS IN CODE TO MAKE THEM WORK AGAIN!
		if IsControlJustPressed(0, 47) then -- G
			pool:FlushAllMenus()
		end
	end
end)