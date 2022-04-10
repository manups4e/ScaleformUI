local pool = MenuPool.New()
local animEnabled = true

-- to handle controls and inputs to the menu
Citizen.CreateThread(function()
	while true do
		Wait(0)
		pool:ProcessControl()
	end
end)

-- to draw the menu... since the controls await response from the Scaleform..
-- drawing in the same thread of the controls would lead to a blinking menu everytime a control is pressed.
Citizen.CreateThread(function()
	while true do
		Wait(0)
        pool:Draw()
	end
end)

function CreateMenu()
	local txd = CreateRuntimeTxd("scaleformui")
	local dui = CreateDui("https://sleeping-tears.xyz/img/gta5/hiccup_racing.png", 288, 160)
	local sidepanel_txn = CreateRuntimeTextureFromDuiHandle(txd, "sidepanel", GetDuiHandle(dui))

	local exampleMenu = UIMenu.New("ScaleformUI UI", "ScaleformUI SHOWCASE", 50, 50, true, nil, nil, true)
	exampleMenu:MaxItemsOnScreen(4)
	pool:Add(exampleMenu)

	local ketchupItem = UIMenuCheckboxItem.New("Scrolling animation enabled?", animEnabled, 1, "Do you wish to enable the scrolling animation?")
	ketchupItem:LeftBadge(BadgeStyle.STAR)
	local sidePanel = UIMissionDetailsPanel.New(1, "Side Panel", 6, true, "scaleformui", "sidepanel")
	local detailItem1 = UIMenuFreemodeDetailsImageItem.New("Left Label", "Right Label", BadgeStyle.BRIEFCASE, Colours.HUD_COLOUR_FREEMODE)
	local detailItem2 = UIMenuFreemodeDetailsImageItem.New("Left Label", "Right Label", BadgeStyle.STAR, Colours.HUD_COLOUR_GOLD)
	local detailItem3 = UIMenuFreemodeDetailsImageItem.New("Left Label", "Right Label", BadgeStyle.ARMOR, Colours.HUD_COLOUR_PURPLE)
	local detailItem4 = UIMenuFreemodeDetailsImageItem.New("Left Label", "Right Label", BadgeStyle.BRAND_DILETTANTE, Colours.HUD_COLOUR_GREEN)
	local detailItem5 = UIMenuFreemodeDetailsImageItem.New("Left Label", "Right Label", BadgeStyle.COUNTRY_GERMANY, Colours.HUD_COLOUR_WHITE, true)
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
		table.insert(animations, k)
	end

	local scrollingItem = UIMenuListItem.New("Choose the scrolling animation", animations, exampleMenu:AnimationType(), "~BLIP_BARBER~ ~BLIP_INFO_ICON~ ~BLIP_TANK~ ~BLIP_OFFICE~ ~BLIP_CRIM_DRUGS~ ~BLIP_WAYPOINT~ ~INPUTGROUP_MOVE~~n~You can use Blips and Inputs in description as you prefer!~n~⚠ 🐌 ❤️ 🥺 💪🏻 You can use Emojis too!", Colours.HUD_COLOUR_FREEMODE_DARK, Colours.HUD_COLOUR_FREEMODE);
	scrollingItem:BlinkDescription(true);
	exampleMenu:AddItem(scrollingItem);

	local cookItem = UIMenuItem.New("Cook!", "Cook the dish with the appropiate ingredients and ketchup.")
	exampleMenu:AddItem(cookItem)
	cookItem:RightBadge(BadgeStyle.STAR)
	cookItem:LeftBadge(BadgeStyle.STAR)


	local colorItem = UIMenuItem.New("UIMenuItem with Colors", "~b~Look!!~r~I can be colored ~y~too!!~w~", 21, 24)
	colorItem:LeftBadge(BadgeStyle.STAR)
	exampleMenu:AddItem(colorItem)
	local sidePanelVehicleColor = UIVehicleColorPickerPanel.New(1, "ColorPicker", 6)

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

	local sliderItem = UIMenuSliderItem.New("Slider Item!", 100, 5, 0, false, "Cool!")
	exampleMenu:AddItem(sliderItem)
	local progressItem = UIMenuProgressItem.New("Slider Progress Item", 10, 0)
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

	local windowSubmenu = pool:AddSubMenu(exampleMenu, "Heritage Menu", "", true, true)
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

	colorPanel.PanelChanged = function(menu, item, newindex)
		local message = "ColorPanel index => " .. newindex + 1
		AddTextEntry("ScaleformUINotification", message)
		BeginTextCommandThefeedPost("ScaleformUINotification")
		EndTextCommandThefeedPostTicker(false, true)
	end

	colorPanel2.PanelChanged = function(menu, item, newindex)
		local message = "ColorPanel2 index => " .. newindex + 1
		AddTextEntry("ScaleformUINotification", message)
		BeginTextCommandThefeedPost("ScaleformUINotification")
		EndTextCommandThefeedPostTicker(false, true)
	end

	percentagePanel.PanelChanged = function(menu, item, newpercentage)
		local message = "PercentagePanel => " .. newpercentage
		AddTextEntry("ScaleformUINotification", message)
		BeginTextCommandThefeedPost("ScaleformUINotification")
		EndTextCommandThefeedPostTicker(false, true)
	end

	gridPanel.PanelChanged = function(menu, item, newposition)
		print(newposition)
	end

	horizontalGridPanel.PanelChanged = function(menu, item, newposition)
		print(newposition)
	end

	sidePanelVehicleColor.PickerSelect = function(menu, item, newindex)
		local message = "ColorPanel index => " .. newindex + 1
		AddTextEntry("ScaleformUINotification", message)
		BeginTextCommandThefeedPost("ScaleformUINotification")
		EndTextCommandThefeedPostTicker(false, true)
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
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Citizen.Wait(0) end
    local txd = GetPedheadshotTxdString(handle)
	pauseMenuExample:HeaderPicture(txd, txd) 	-- pauseMenuExample:CrewPicture used to add a picture on the left of the HeaderPicture
	print("PedHandle => " .. handle)
	UnregisterPedheadshot(handle) -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform.. 

	pool:AddPauseMenu(pauseMenuExample)

	local basicTab = TabTextItem.New("TABTEXTITEM", "This is the Title!")
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

	local multiItemTab = TabSubMenuItem.New("TabSubMenu") -- this is the tab with multiple sub menus in it.. each submenu has a different purpose
	pauseMenuExample:AddTab(multiItemTab)
	local first = TabLeftItem.New("1 - Empty", LeftItemType.Empty) -- empty item.. 
	local second = TabLeftItem.New("2 - Info", LeftItemType.Info) -- info (like briefings..)
	local third = TabLeftItem.New("3 - Statistics", LeftItemType.Statistics) -- for statistics
	local fourth = TabLeftItem.New("4 - Settings", LeftItemType.Settings) -- well.. settings..
	local fifth = TabLeftItem.New("5 - Keymaps", LeftItemType.Keymap) -- keymaps for custom keymapping 
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
	-- different New for each type of setting
	local _settings1 = SettingsTabItem.NewBasic("Item's Label", "Item's right Label") 
	local _settings2 = SettingsTabItem.NewList("Item's Label", itemList, 0)
	local _settings3 = SettingsTabItem.NewProgress("Item's Label", 100, 25, false, Colours.HUD_COLOUR_FREEMODE)
	local _settings4 = SettingsTabItem.NewProgress("Item's Label", 100, 75, true, Colours.HUD_COLOUR_PINK)
	local _settings5 = SettingsTabItem.NewCheckbox("Item's Label", 1, true) -- 0 = cross / 1 = tick
	local _settings6 = SettingsTabItem.NewSlider("Item's Label", 100, 50, Colours.HUD_COLOUR_RED)
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

	pauseMenuExample.OnPauseMenuOpen = function(menu)
		Notifications:ShowSubtitle(menu.Title .. " Opened!")
	end

	pauseMenuExample.OnPauseMenuClose = function(menu)
		Notifications:ShowSubtitle(menu.Title .. " Closed!")
	end

	pauseMenuExample.OnPauseMenuTabChanged = function(menu, tab, tabIndex)
		Notifications:ShowSubtitle(tab.Label .. " Selected!")
	end

	pauseMenuExample.OnPauseMenuFocusChanged = function(menu, tab, focusLevel, leftItemIndex)
		Notifications:ShowSubtitle(tab.Label .. " Focus at level =>~y~ " .. focusLevel .. " ~w~~s~!")
		if focusLevel == 1 then
			local _, subType = tab()
			if subType == "TabTextItem" then
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

	pauseMenuExample.OnLeftItemChange = function(menu, tabIndex, focusLevel, leftItemIndex)
		Notifications:ShowSubtitle(menu.Tabs[tabIndex].Label .. " Focus at level => ~y~" .. focusLevel .. "~w~, and left Item ~o~N° " .. leftItemIndex .. "~w~ selected!")
	end

	pauseMenuExample.OnRightItemChange = function (menu, tabIndex, focusLevel, leftItemIndex, rightItemIndex)
		Notifications:ShowSubtitle(menuTabs[tabIndex].Label .. " Focus at level => ~y~" .. focusLevel .. "~w~, left Item ~o~N° " .. leftItemIndex .. "~w~ and right Item ~b~N° " .. rightItemIndex .. "~w~ selected!")
	end

	pauseMenuExample:Visible(true)
end

Citizen.CreateThread(function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	--type, position, scale, distance, color, placeOnGround, bobUpDown, rotate, faceCamera, checkZ
	local marker = Marker.New(1, pos, vector3(2,2,2), 100.0, {R=0, G= 100, B=50, A=255}, true, false, false, false, true)

	while true do
		Wait(0)
		marker:Draw()
		ScaleformUI.Notifications:DrawText(0.3, 0.7, "Ped is in Range => " .. tostring(marker:IsInRange()))
		ScaleformUI.Notifications:DrawText(0.3, 0.725, "Ped is in Marker =>" .. tostring(marker.IsInMarker))
		if IsControlJustPressed(0, 166) and not pool:IsAnyMenuOpen() then
			CreateMenu()
		end
		if IsControlJustPressed(0, 167) and not pool:IsAnyMenuOpen() then
			CreatePauseMenu()
		end
	end
end)