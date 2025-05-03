local animEnabled = true
local timerBarPool = TimerBarPool.New()

function CreateMenu()
	local txd = CreateRuntimeTxd("scaleformui")
	local duiPanel = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "sidepanel", GetDuiHandle(duiPanel))
	local duiBanner = CreateDui("https://i.imgur.com/3yrFYbF.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "menuBanner", GetDuiHandle(duiBanner))

	local exampleMenu = UIMenu.New("ScaleformUI", "ScaleformUI SHOWCASE", 50, 50, true, "scaleformui", "menubanner", true)
	exampleMenu:MaxItemsOnScreen(7)
	exampleMenu:BuildingAnimation(MenuBuildingAnimation.LEFT_RIGHT)
	exampleMenu:CounterColor(SColor.HUD_Yellow)

	local currentTransition = "TRANSITION_OUT"
	local bigMessageItem = UIMenuItem.New("Big Message Example", "Big Message Examples")
	exampleMenu:AddItem(bigMessageItem)
	local bigMessageExampleMenu = UIMenu.New("Big Message Example", "Big Message Examples", 50, 50, true, "", "", true)

	local uiItemTransitionList = UIMenuListItem.New("Transition",
		{ "TRANSITION_OUT", "TRANSITION_UP", "TRANSITION_DOWN" },
		1,
		"Transition type for the big message")
	bigMessageExampleMenu:AddItem(uiItemTransitionList)

	local uiItemBigMessageManualDispose = UIMenuCheckboxItem.New("Manual Dispose", false, 1,
		"Manually dispose the big message")
	bigMessageExampleMenu:AddItem(uiItemBigMessageManualDispose)

	local uiItemMessageType = UIMenuListItem.New("Message Type",
		{ "Mission Passed", "Coloured Shard", "Old Message", "Simple Shard", "Rank Up", "MP Message Large",
			"MP Wasted Message" }, 1,
		"Message type for the big message, press ~INPUT_FRONTEND_ACCEPT~ to show the message")
	bigMessageExampleMenu:AddItem(uiItemMessageType)

	local uiItemDisposeBigMessage = UIMenuItem.New("Dispose Big Message", "Dispose the big message")
	uiItemDisposeBigMessage:Enabled(uiItemBigMessageManualDispose:Checked())
	bigMessageExampleMenu:AddItem(uiItemDisposeBigMessage)

	local manuallyDisposeBigMessage = false

	bigMessageExampleMenu.OnCheckboxChange = function(sender, item, checked_)
		if item == uiItemBigMessageManualDispose then
			uiItemDisposeBigMessage:Enabled(checked_)
			manuallyDisposeBigMessage = checked_
		end
	end

	bigMessageExampleMenu.OnItemSelect = function(sender, item, index)
		if item == uiItemDisposeBigMessage then
			ScaleformUI.Scaleforms.BigMessageInstance:Dispose()
		end
	end

	bigMessageExampleMenu.OnListSelect = function(sender, item, index)
		if item == uiItemTransitionList then
			currentTransition = item:IndexToItem(index)
			ScaleformUI.Notifications:ShowNotification(string.format("Transition set to %s", currentTransition))
		elseif item == uiItemMessageType then
			if index == 1 then
				ScaleformUI.Scaleforms.BigMessageInstance:ShowMissionPassedMessage("Mission Passed", 5000,
					manuallyDisposeBigMessage)
			elseif index == 2 then
				ScaleformUI.Scaleforms.BigMessageInstance:ShowColoredShard("Coloured Shard", "Description",
					SColor.HUD_White,
					SColor.HUD_Freemode, 5000, manuallyDisposeBigMessage)
			elseif index == 3 then
				ScaleformUI.Scaleforms.BigMessageInstance:ShowOldMessage("Old Message", 5000, manuallyDisposeBigMessage)
			elseif index == 4 then
				ScaleformUI.Scaleforms.BigMessageInstance:ShowSimpleShard("Simple Shard", "Simple Shard Subtitle", 5000,
					manuallyDisposeBigMessage)
			elseif index == 5 then
				ScaleformUI.Scaleforms.BigMessageInstance:ShowRankupMessage("Rank Up", "Rank Up Subtitle", 10, 5000,
					manuallyDisposeBigMessage)
			elseif index == 6 then
				ScaleformUI.Scaleforms.BigMessageInstance:ShowMpMessageLarge("MP Message Large", 5000,
					manuallyDisposeBigMessage)
			elseif index == 7 then
				ScaleformUI.Scaleforms.BigMessageInstance:ShowMpWastedMessage("MP Wasted Message", "Subtitle", 5000,
					manuallyDisposeBigMessage)
			end
			ScaleformUI.Scaleforms.BigMessageInstance:SetTransition(currentTransition, 0.4, true)
		end
	end

	-- the new "SwitchTo" method will give your menus the ability to fly
	-- parameters are: UIMenu:SwitchTo([UIMenu]newMenu, [number]newMenuInitialIndex, [bool]inheritPrevMenuParams)
	-- if not specified, the last to parameters will always be [1, false] to allow every menu to be rendered separately
	bigMessageItem.Activated = function(menu, item)
		menu:SwitchTo(bigMessageExampleMenu, 1, true)
	end

	local ketchupItem = UIMenuCheckboxItem.New("~g~Scrolling ~w~animation ~r~enabled?", animEnabled, 1,
		"Do you wish to enable the scrolling animation?")
	ketchupItem:LeftBadge(BadgeStyle.STAR)
	local sidePanel = UIMissionDetailsPanel.New(1, "Side Panel", 6, true, "scaleformui", "sidepanel")
	local detailItem1 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, SColor.HUD_Freemode, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem2 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.STAR, SColor.HUD_Gold, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem3 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.ARMOR, SColor.HUD_Purple, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem4 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRAND_DILETTANTE, SColor.HUD_Green, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem5 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.COUNTRY_GERMANY, SColor.HUD_White, true, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem6 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", true)
	local detailItem7 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false)
	local detailDesc = UIMenuFreemodeDetailsItem.New("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat")
	detailItem1:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem2:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem3:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem4:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem5:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem6:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailItem7:SetLabelsFonts(ScaleformFonts.ROCKSTAR_TAG, ScaleformFonts.STENCIL_STD)
	detailDesc:SetLabelsFonts(ScaleformFonts.SIGNPAINTER_HOUSESCRIPT)

	sidePanel:AddItem(detailItem1)
	sidePanel:AddItem(detailItem2)
	sidePanel:AddItem(detailItem3)
	sidePanel:AddItem(detailItem4)
	sidePanel:AddItem(detailItem5)
	sidePanel:AddItem(detailItem6)
	sidePanel:AddItem(detailItem7)
	sidePanel:AddItem(detailDesc)


	ketchupItem:AddSidePanel(sidePanel)
	exampleMenu:AddItem(ketchupItem)

	local animations = {}
	for k, v in pairs(MenuAnimationType) do
		-- table.insert(animations, k) -- Instead of this , use it like below (learn more here : https://springrts.com/wiki/Lua_Performance#TEST_12:_Adding_Table_Items_.28table.insert_vs._.5B_.5D.29)
		animations[#animations + 1] = k
	end

	local scrollingAnimationItem = UIMenuListItem.New("Choose the scrolling animation", animations, exampleMenu:AnimationType(),
		"~BLIP_BARBER~ ~BLIP_INFO_ICON~ ~BLIP_TANK~ ~BLIP_OFFICE~ ~BLIP_CRIM_DRUGS~ ~BLIP_WAYPOINT~ ~INPUTGROUP_MOVE~~n~You can use Blips and Inputs in description as you prefer!~n~⚠ 🐌 ❤️ 🥺 💪🏻 You can use Emojis too!"
		, SColor.HUD_Freemode_dark, SColor.HUD_Freemode)
	scrollingAnimationItem:BlinkDescription(true)
	exampleMenu:AddItem(scrollingAnimationItem)

	local scrollItem = UIMenuListItem.New("Choose how this menu will ~o~scroll~s~!", { "CLASSIC", "PAGINATED", "ENDLESS" }, exampleMenu:ScrollingType())
	exampleMenu:AddItem(scrollItem)

	scrollItem.OnListChanged = function(menu, item, index)
		menu:ScrollingType(index)
	end

	local cookItem = UIMenuItem.New("Cook!", "Cook the dish with the appropiate ingredients and ketchup.")
	exampleMenu:AddItem(cookItem)
	cookItem:LeftBadge(BadgeStyle.STAR)
	cookItem:RightLabel("RightLabel in GTA font")
	cookItem:LabelFont(ScaleformFonts.ENGRAVERS_OLD_ENGLISH_MT_STD)
	cookItem:RightLabelFont(ScaleformFonts.PRICEDOWN_GTAV_INT)

	exampleMenu.OnItemSelect = function(menu, item, index)
		if (item == cookItem) then
			ScaleformUI.Notifications:ShowNotification("We're cooking Jessie!")
		end
		ScaleformUI.Notifications:ShowNotification("Item with label '" .. item:Label() .. "' was clicked.")
	end

	local colorItem = UIMenuItem.New("~HUD_COLOUR_FREEMODE~UIMenuItem ~w~with ~HUD_COLOUR_ORANGELIGHT~Colors", "~b~Look!!~r~I can be colored ~y~too!!~w~", SColor.FromHudColor(21), SColor.FromHudColor(24))
	colorItem:LeftBadge(BadgeStyle.STAR)
	exampleMenu:AddItem(colorItem)
	local sidePanelVehicleColor = UIVehicleColorPickerPanel.New(1, "ColorPicker", 6)
	colorItem:AddSidePanel(sidePanelVehicleColor)

	local dynamicValue = 0
	local dynamicListItem = UIMenuDynamicListItem.New("Dynamic List Item",
		"Try pressing ~INPUT_FRONTEND_LEFT~ or ~INPUT_FRONTEND_RIGHT~", tostring(dynamicValue),
		function(item, direction)
			if (direction == "left") then
				dynamicValue = dynamicValue - 1
			elseif (direction == "right") then
				dynamicValue = dynamicValue + 1
			end
			return tostring(dynamicValue)
		end)
	exampleMenu:AddItem(dynamicListItem)
	dynamicListItem:LeftBadge(BadgeStyle.STAR)

	local seperatorItem1 = UIMenuSeparatorItem.New("Separator (Jumped)", true)
	local seperatorItem2 = UIMenuSeparatorItem.New("Separator (not Jumped)", false)
	exampleMenu:AddItem(seperatorItem1)
	exampleMenu:AddItem(seperatorItem2)

	local foodsList     = { "Banana", "<C>Apple</C>", "Pizza", "Quartilicious" }
	local colorListItem = UIMenuListItem.New("Colored ListItem.. Really?", foodsList, 0,
		"~BLIP_BARBER~ ~BLIP_INFO_ICON~ ~BLIP_TANK~ ~BLIP_OFFICE~ ~BLIP_CRIM_DRUGS~ ~BLIP_WAYPOINT~ ~INPUTGROUP_MOVE~~n~You can use Blips and Inputs in description as you prefer!"
		, SColor.FromHudColor(21), SColor.FromHudColor(24))
	exampleMenu:AddItem(colorListItem)

	local sliderItem = UIMenuSliderItem.New("Slider Item!", 100, 5, 50, false, "Cool!")
	exampleMenu:AddItem(sliderItem)
	local progressItem = UIMenuProgressItem.New("Slider Progress Item", 10, 5)
	exampleMenu:AddItem(progressItem)

	local listPanelItem1 = UIMenuItem.New("Change Color", "It can be whatever item you want it to be")
	local colorPanel = UIMenuColorPanel.New("Color Panel Example", 1, 0)
	local colorPanel2 = UIMenuColorPanel.New("Custom Palette Example", 1, 0,
		{ SColor.FromRandomValues(), SColor.FromRandomValues(), SColor.FromRandomValues(), SColor.FromRandomValues(), SColor.FromRandomValues() })
	exampleMenu:AddItem(listPanelItem1)
	listPanelItem1:AddPanel(colorPanel)
	listPanelItem1:AddPanel(colorPanel2)
	uiItemTransitionList:AddPanel(colorPanel)
	uiItemTransitionList:AddSidePanel(sidePanelVehicleColor)


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

	local listPanelItem4 = UIMenuListItem.New("Look at Statistics", { "Example", "example2" }, 0)
	local statisticsPanel = UIMenuStatisticsPanel.New()
	statisticsPanel:AddStatistic("Look at this!", 10.0)
	statisticsPanel:AddStatistic("I'm a statistic too!", 50.0)
	statisticsPanel:AddStatistic("Am i not?!", 100.0)
	exampleMenu:AddItem(listPanelItem4)
	listPanelItem4:AddPanel(statisticsPanel)

	listPanelItem4.OnListChanged = function(menu, item, newIndex)
		if (newIndex == 1) then
			ScaleformUI.Notifications:ShowNotification("Update Statistics Panel Item 1")
			statisticsPanel:UpdateStatistic(1, 10.0)
			statisticsPanel:UpdateStatistic(2, 50.0)
			statisticsPanel:UpdateStatistic(3, 100.0)
		elseif (newIndex == 2) then
			ScaleformUI.Notifications:ShowNotification("Update Statistics Panel Item 2")
			statisticsPanel:UpdateStatistic(1, 100.0)
			statisticsPanel:UpdateStatistic(2, 75.0)
			statisticsPanel:UpdateStatistic(3, 25.0)
		end
	end

	local windowMenu = UIMenu.New("Windows Submenu", "it is a totally separated menu now")
	local windowItem = UIMenuItem.New("Windows item", "Yeah created on its own and handled on item selection")
	windowItem:RightLabel("~HUD_COLOUR_DEGEN_CYAN~>>>")
	exampleMenu:AddItem(windowItem)
	local heritageWindow = UIMenuHeritageWindow.New(0, 0)
	local detailsWindow = UIMenuDetailsWindow.New("Parents resemblance", "Dad:", "Mom:", true, {})
	windowMenu:AddWindow(heritageWindow)
	windowMenu:AddWindow(detailsWindow)
	local momNames           = { "Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camilla",
		"Violet",
		"Sophia", "Eveline", "Nicole", "Ashley", "Grace", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte",
		"Emma", "Misty" }
	local dadNames           = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Joan", "Alex", "Isaac", "Evan",
		"Ethan",
		"Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony",
		"Claude", "Niko", "John" }

	local momListItem        = UIMenuListItem.New("Mom", momNames, 0)
	local dadListItem        = UIMenuListItem.New("Dad", dadNames, 0)
	local heritageSliderItem = UIMenuSliderItem.New("Heritage Slider", 100, 5, 0, true, "This is Useful on heritage")
	windowMenu:AddItem(momListItem)
	windowMenu:AddItem(dadListItem)
	windowMenu:AddItem(heritageSliderItem)

	detailsWindow.DetailMid = "Dad: " .. heritageSliderItem:Index() .. "%"
	detailsWindow.DetailBottom = "Mom: " .. (100 - heritageSliderItem:Index()) .. "%"
	detailsWindow.DetailStats = {
		{
			Percentage = 100,
			HudColor = SColor.FromHudColor(6)
		},
		{
			Percentage = 0,
			HudColor = SColor.FromHudColor(50)
		}
	}

	detailsWindow:UpdateStatsToWheel()

	-- parameters are: UIMenu:SwitchTo([UIMenu]newMenu, [number]newMenuInitialIndex, [bool]inheritPrevMenuParams)
	-- if not specified, the last to parameters will always be [1, false] to allow every menu to be rendered separately
	windowItem.Activated = function(menu, item)
		menu:SwitchTo(windowMenu, 1, true)
	end

	exampleMenu.OnMenuOpen = function(menu)
		print("Menu opened!")
	end
	exampleMenu.OnMenuClose = function(menu)
		print("Menu closed!")
	end

	ketchupItem.OnCheckboxChanged = function(menu, item, checked)
		sidePanel:UpdatePanelTitle(tostring(checked))
		menu:AnimationEnabled(checked)
		scrollingAnimationItem:Enabled(checked)
		if checked then
			scrollingAnimationItem:LeftBadge(BadgeStyle.NONE)
		else
			scrollingAnimationItem:LeftBadge(1)
		end
	end

	scrollingAnimationItem.OnListChanged = function(menu, item, index)
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

	windowMenu.OnListChange = function(menu, item, newindex)
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
	--exampleMenu:Title("Scaleform~HUD_COLOUR_PURPLE~UI")
	exampleMenu:Subtitle("~p~Colored ~HUD_COLOUR_ORANGE~Subtitle")
	RegisterCommand('settext', function(source, args)
		bigMessageItem:RightLabel(args[1])
	end, false)
end

function CreateRadialMenu()
	local radialMenu = RadialMenu.New()
	local txd = CreateRuntimeTxd("scaleformui")

	local imgdui = CreateDui("https://giphy.com/embed/ckT59CvStmUsU", 64, 64)
	CreateRuntimeTextureFromDuiHandle(txd, "item1", GetDuiHandle(imgdui))

	local imgdui1 = CreateDui("https://giphy.com/embed/10bTCLE8GtHHS8", 96, 64)
	CreateRuntimeTextureFromDuiHandle(txd, "item2", GetDuiHandle(imgdui1))

	local imgdui2 = CreateDui("https://giphy.com/embed/nHyZigjdO4hEodq9fv", 64, 64)
	CreateRuntimeTextureFromDuiHandle(txd, "item3", GetDuiHandle(imgdui2))

	local item1 = SegmentItem.New("This is the label!", "~BLIP_INFO_ICON~ This is the description.. it's multiline so it can be very long!", "scaleformui", "item1", 64, 64, SColor.HUD_Freemode)
	local item2 = SegmentItem.New("It's so long it scrolls automatically! Isn't this amazing?", "~BLIP_INFO_ICON~ This is the description.. it's multiline so it can be very long!", "scaleformui", "item2", 96, 64, SColor.HUD_Green)
	local item3 = SegmentItem.New("Label 3", "~BLIP_INFO_ICON~ This is the description.. it's multiline so it can be very long!", "scaleformui", "item3", 64, 64, SColor.HUD_Red)

	item1:SetQuantity(8000, 9999)
	item2:SetQuantity(50, 100)
	item3:SetQuantity(5000)

	for i = 1, 8 do
		radialMenu.Segments[i]:AddItem(item1)
		radialMenu.Segments[i]:AddItem(item2)
		radialMenu.Segments[i]:AddItem(item3)
	end

	radialMenu.OnMenuOpen = function(menu, _)
		ScaleformUI.Notifications:ShowSubtitle("Radial Menu opened!")
	end

	radialMenu.OnMenuClose = function(menu)
		ScaleformUI.Notifications:ShowSubtitle("Radial Menu closed!")
	end

	radialMenu.OnSegmentHighlight = function(segment)
		ScaleformUI.Notifications:ShowSubtitle("Segment " .. segment.Index .. " highlighted!")
	end

	radialMenu.OnSegmentIndexChange = function(segment, index)
		ScaleformUI.Notifications:ShowSubtitle("Segment " .. segment.Index .. ", index changed to " .. index .. "!")
	end

	radialMenu.OnSegmentSelect = function(segment)
		ScaleformUI.Notifications:ShowSubtitle("Segment " .. segment.Index .. " selected!")
	end

	radialMenu:Visible(true)
end

function CreateRadioMenu()
	local txd = CreateRuntimeTxd("scaleformui")
	local imgdui1 = CreateDui("https://giphy.com/embed/10bTCLE8GtHHS8", 96, 64)
	CreateRuntimeTextureFromDuiHandle(txd, "item2", GetDuiHandle(imgdui1))
	local menu = UIRadioMenu.New()
	menu:AnimationDuration(1.0)
	menu:AnimDirection(-1)
	for i = 1, 25, 1 do
		local item = RadioItem.New("Station " .. i, "Artist " .. i, "Track " .. i, "scaleformui", "item2")
		menu:AddStation(item)
	end
	menu.OnMenuOpen = function(menu, _)
		ScaleformUI.Notifications:ShowSubtitle("Radio Menu opened!")
	end

	menu.OnMenuClose = function(menu)
		ScaleformUI.Notifications:ShowSubtitle("Radio Menu closed!")
	end

	menu.OnIndexChange = function(index)
		ScaleformUI.Notifications:ShowSubtitle("Index " .. index .. " highlighted!")
	end

	menu.OnStationSelect = function(station, index)
		ScaleformUI.Notifications:ShowSubtitle("Selected station with index" .. index .. "!")
	end

	menu:Visible(true)
end

function Input(TextEntry, ExampleText, MaxStringLength)
	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLength	-->	Maximum String Length

	AddTextEntry('FMlprp_KEY_TIP1', TextEntry)                                               --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(1, "FMlprp_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength) --Actually calls the Keyboard Input
	blockinput = true                                                                        --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do                 --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(250)                    --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false                   --This unblocks new Input when typing is done
		return result                        --Returns the result
	else
		Citizen.Wait(250)                    --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false                   --This unblocks new Input when typing is done
		return 'Invalid'                     --Returns false if the typing got aborted
	end
end

function CreatePauseMenu()
	local pauseMenuExample = TabView.New("ScaleformUI LUA", "THE LUA API", GetPlayerName(PlayerId()), "String middle", "String bottom")

	local handle = RegisterPedheadshot(PlayerPedId())
	while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Citizen.Wait(0) end
	local txd = GetPedheadshotTxdString(handle)
	pauseMenuExample:HeaderPicture(txd, txd) -- pauseMenuExample:CrewPicture used to add a picture on the left of the HeaderPicture
	print("PedHandle => " .. handle)
	UnregisterPedheadshot(handle)         -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform..

	local _pauseDict = CreateRuntimeTxd("pausemenu")

	local bg_dui = CreateDui("https://giphy.com/embed/sxwk9hGlsULcYm6hDX", 1280, 720)
	CreateRuntimeTextureFromDuiHandle(_pauseDict, "pausebigbg", GetDuiHandle(bg_dui))
	local _bginfo = CreateDui("https://giphy.com/embed/bG1oRM2Qp2kN3MTZCO", 480, 480)
	CreateRuntimeTextureFromDuiHandle(_pauseDict, "pauseinfobg", GetDuiHandle(_bginfo))
	local _bgstats = CreateDui("https://giphy.com/embed/xT9IgsHTiYHILDGDM4", 480, 480)
	CreateRuntimeTextureFromDuiHandle(_pauseDict, "pausestatsbg", GetDuiHandle(_bgstats))
	local _bgsets = CreateDui("https://giphy.com/embed/xT9IgsHTiYHILDGDM4", 480, 480)
	CreateRuntimeTextureFromDuiHandle(_pauseDict, "pausesetsbg", GetDuiHandle(_bgsets))



	local basicTab = TextTab.New("TEXTTAB", "This is the Title!")
	basicTab:UpdateBackground("pausemenu", "pausebigbg")
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~r~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~b~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~g~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	basicTab:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~r~Use the mouse wheel to scroll the text!!"))
	pauseMenuExample:AddTab(basicTab)

	local multiItemTab = SubmenuTab.New("SUBMENUTAB")                     -- this is the tab with multiple sub menus in it.. each submenu has a different purpose
	pauseMenuExample:AddTab(multiItemTab)
	local first = TabLeftItem.New("1 - Empty", LeftItemType.Empty)        -- empty item..
	local second = TabLeftItem.New("2 - Info", LeftItemType.Info)         -- info (like briefings..)
	local third = TabLeftItem.New("3 - Statistics", LeftItemType.Statistics) -- for statistics
	local fourth = TabLeftItem.New("4 - Settings", LeftItemType.Settings) -- well.. settings..
	local fifth = TabLeftItem.New("5 - Keymaps", LeftItemType.Keymap)     -- keymaps for custom keymapping

	second:UpdateBackground("pausemenu", "pauseinfobg", 0)                --(full)
	third:UpdateBackground("pausemenu", "pausestatsbg", 1)                --(masked)
	fourth:UpdateBackground("pausemenu", "pausesetsbg", 2)                --(resized)

	first:Enabled(false)
	multiItemTab:AddLeftItem(first)
	multiItemTab:AddLeftItem(second)
	multiItemTab:AddLeftItem(third)
	multiItemTab:AddLeftItem(fourth)
	multiItemTab:AddLeftItem(fifth)

	second.TextTitle = "Info Title!!"
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~r~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~b~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~g~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~p~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"))
	second:AddItem(PauseMenuItem.New("~BLIP_INFO_ICON~ ~r~Use the mouse wheel to scroll the text!!"))

	local _labelStatItem = StatsTabItem.NewBasic("Item's Label", "Item's right label")
	local _coloredBarStatItem0 = StatsTabItem.NewBar("Item's Label", 0, SColor.HUD_Orange)
	local _coloredBarStatItem1 = StatsTabItem.NewBar("Item's Label", 25, SColor.HUD_Red)
	local _coloredBarStatItem2 = StatsTabItem.NewBar("Item's Label", 50, SColor.HUD_Blue)
	local _coloredBarStatItem3 = StatsTabItem.NewBar("Item's Label", 75, SColor.HUD_Green)
	local _coloredBarStatItem4 = StatsTabItem.NewBar("Item's Label", 100, SColor.HUD_Purple)

	third:AddItem(_labelStatItem)
	third:AddItem(_coloredBarStatItem0)
	third:AddItem(_coloredBarStatItem1)
	third:AddItem(_coloredBarStatItem2)
	third:AddItem(_coloredBarStatItem3)
	third:AddItem(_coloredBarStatItem4)

	local itemList = { "This", "Is", "The", "List", "Super", "Power", "Wooow" }
	local _settings1 = SettingsItem.New("Item's Label", "Item's right Label")
	local _settings2 = SettingsListItem.New("Item's Label", itemList, 0)
	local _settings3 = SettingsProgressItem.New("Item's Label", 100, 25, false, SColor.HUD_Freemode)
	local _settings4 = SettingsProgressItem.New("Item's Label", 100, 75, true, SColor.HUD_Pink)
	local _settings5 = SettingsCheckboxItem.New("Item's Label", 1, true) -- 0 = cross / 1 = tick
	local _settings6 = SettingsSliderItem.New("Item's Label", 100, 50, SColor.HUD_Red)
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

	local playersTab = PlayerListTab.New("PLAYERLIST TAB", SColor.HUD_Freemode, false)
	local cols = {
		SettingsListColumn.New("", -1, MenuScrollingType.ENDLESS),
		--PlayerListColumn.New("Players", -1),
		MissionListColumn.New("", -1, MenuScrollingType.PAGINATED),
		MissionDetailsPanel.New("", -1)
	}
	playersTab:SetUpColumns(cols)
	pauseMenuExample:AddTab(playersTab)

	local item = UIMenuItem.New("UIMenuItem", "UIMenuItem description")
	local item1 = UIMenuListItem.New("UIMenuListItem", { "This", "is", "a", "Test" }, 0, "UIMenuListItem description")
	local item2 = UIMenuCheckboxItem.New("UIMenuCheckboxItem", true, 1, "UIMenuCheckboxItem description")
	local item3 = UIMenuSliderItem.New("UIMenuSliderItem", 100, 5, 50, false, "UIMenuSliderItem description")
	local item4 = UIMenuProgressItem.New("UIMenuProgressItem", 10, 5, "UIMenuProgressItem description")
	item:BlinkDescription(true)

	item.Activated = function(menu, item)
		playersTab:SelectColumn(2)
	end

	playersTab.SettingsColumn:AddSettings(item)
	playersTab.SettingsColumn:AddSettings(item1)
	playersTab.SettingsColumn:AddSettings(item2)
	playersTab.SettingsColumn:AddSettings(item3)
	playersTab.SettingsColumn:AddSettings(item4)


	local mission1 = MissionItem.New("Mission number 1")
	local mission2 = MissionItem.New("Mission number 2")
	local mission3 = MissionItem.New("Mission number 3")
	local mission4 = MissionItem.New("Mission number 4")
	local mission5 = MissionItem.New("Mission number 5")
	local mission6 = MissionItem.New("Mission number 6")

	mission1:SetLeftIcon(BadgeStyle.ROCKSTAR, SColor.HUD_White)
	mission2:SetLeftIcon(BadgeStyle.ROCKSTAR, SColor.HUD_White)
	mission3:SetLeftIcon(BadgeStyle.ROCKSTAR, SColor.HUD_White)
	mission4:SetLeftIcon(BadgeStyle.ROCKSTAR, SColor.HUD_White)
	mission5:SetLeftIcon(BadgeStyle.ROCKSTAR, SColor.HUD_White)
	mission6:SetLeftIcon(BadgeStyle.ROCKSTAR, SColor.HUD_White)

	mission1:SetRightIcon(BadgeStyle.MISSION_STAR, SColor.HUD_Freemode, true)
	mission2:SetRightIcon(BadgeStyle.MISSION_STAR, SColor.HUD_Freemode)
	mission3:SetRightIcon(BadgeStyle.MISSION_STAR, SColor.HUD_Freemode, true)
	mission4:SetRightIcon(BadgeStyle.MISSION_STAR, SColor.HUD_Freemode)
	mission5:SetRightIcon(BadgeStyle.MISSION_STAR, SColor.HUD_Freemode, true)
	mission6:SetRightIcon(BadgeStyle.MISSION_STAR, SColor.HUD_Freemode)

	playersTab.MissionsColumn:AddMissionItem(mission1)
	playersTab.MissionsColumn:AddMissionItem(mission2)
	playersTab.MissionsColumn:AddMissionItem(mission3)
	playersTab.MissionsColumn:AddMissionItem(mission4)
	playersTab.MissionsColumn:AddMissionItem(mission5)
	playersTab.MissionsColumn:AddMissionItem(mission6)
	--[[

	local crew1 = CrewTag.New("hello", false, false, CrewHierarchy.Leader, SColor.HUD_Green)
	local crew2 = CrewTag.New("evry1", false, false, CrewHierarchy.Commissioner, SColor.HUD_Pink)
	local crew3 = CrewTag.New("look", false, false, CrewHierarchy.Liutenant, SColor.HUD_Blue)
	local crew4 = CrewTag.New("at", false, false, CrewHierarchy.Representative, SColor.HUD_Orange)
	local crew5 = CrewTag.New("this", false, false, CrewHierarchy.Muscle, SColor.HUD_Red)


	local friend = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Green, true, GetRandomIntInRange(15, 55), "Status", crew1)
	local friend2 = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Pink, true, GetRandomIntInRange(15, 55), "Status", crew2)
	local friend3 = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Blue, true, GetRandomIntInRange(15, 55), "Status", crew3)
	local friend4 = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Orange, true, GetRandomIntInRange(15, 55), "Status", crew4)
	local friend5 = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Red, true, GetRandomIntInRange(15, 55), "Status", crew5)
	friend:SetLeftIcon(LobbyBadgeIcon.IS_CONSOLE_PLAYER, false)
	friend1:SetLeftIcon(LobbyBadgeIcon.IS_PC_PLAYER, false)
	friend2:SetLeftIcon(LobbyBadgeIcon.SPECTATOR, false)
	friend3:SetLeftIcon(LobbyBadgeIcon.INACTIVE_HEADSET, false)
	friend4:SetLeftIcon(BadgeStyle.COUNTRY_ITALY, true)
	friend5:SetLeftIcon(BadgeStyle.CASTLE, true)

	friend.ClonePed = PlayerPedId()
	friend2.ClonePed = PlayerPedId()
	friend3.ClonePed = PlayerPedId()
	friend4.ClonePed = PlayerPedId()
	friend5.ClonePed = PlayerPedId()

	local panel = PlayerStatsPanel.New("Player 1", SColor.HUD_Green)
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

	local panel2 = PlayerStatsPanel.New("Player 3", SColor.HUD_Pink)
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

	local panel3 = PlayerStatsPanel.New("Player 4", SColor.HUD_Freemode)
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

	local panel4 = PlayerStatsPanel.New("Player 5", SColor.HUD_Orange)
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

	local panel5 = PlayerStatsPanel.New("Player 6", SColor.HUD_Red)
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
	]]

	local txd = CreateRuntimeTxd("scaleformui")
	local _paneldui = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "lobby_panelbackground", GetDuiHandle(_paneldui))

	playersTab.MissionPanel:Title("This is the title!!")
	playersTab.MissionPanel:UpdatePanelPicture("scaleformui", "lobby_panelbackground")
	local detailItem1 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, SColor.HUD_Freemode, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem2 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.STAR, SColor.HUD_Gold, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem3 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.ARMOR, SColor.HUD_Purple, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem4 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRAND_DILETTANTE, SColor.HUD_Green, false, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem5 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.COUNTRY_GERMANY, SColor.HUD_White, true, ScaleformFonts.SIGNPAINTER_HOUSESCRIPT, ScaleformFonts.STENCIL_STD)
	local detailItem6 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", true)
	local detailItem7 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false)
	local detailDesc = UIMenuFreemodeDetailsItem.New("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat")
	playersTab.MissionPanel:AddItem(detailItem1)
	playersTab.MissionPanel:AddItem(detailItem2)
	playersTab.MissionPanel:AddItem(detailItem3)
	playersTab.MissionPanel:AddItem(detailItem4)
	playersTab.MissionPanel:AddItem(detailItem5)
	playersTab.MissionPanel:AddItem(detailItem6)
	playersTab.MissionPanel:AddItem(detailItem7)
	playersTab.MissionPanel:AddItem(detailDesc)

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
		Notifications:ShowSubtitle("OnLeftItemChange:" .. menu.Tabs[menu:Index()].Label .. " Focus at level =>~y~ " .. menu.focusLevel .. "~s~~w~, and left Item ~o~N° " .. leftItemIndex .. "~w~ selected!")
	end

	pauseMenuExample.OnRightItemChange = function(menu, item, rightItemIndex)
		Notifications:ShowSubtitle(menu.Tabs[menu:Index()].Label .. " Focus at level => ~y~ " .. menu:FocusLevel() .. "~w~, left Item ~o~N° " .. menu:LeftItemIndex() .. "~w~ and right Item ~b~N° " .. rightItemIndex .. "~w~ selected!")
	end

	pauseMenuExample.OnPauseMenuTabChanged = function(menu, tab, tabIndex)
		print(menu, tab, tabIndex)
	end

	pauseMenuExample:Visible(true)
end

function CreateLobbyMenu()
	local lobbyMenu = MainView.New("Lobby Menu", "ScaleformUI for you by Manups4e!", "Detail 1", "Detail 2", "Detail 3")
	local columns = {
		SettingsListColumn.New("COLUMN SETTINGS", SColor.HUD_Red),
		PlayerListColumn.New("COLUMN PLAYERS", SColor.HUD_Orange),
		MissionDetailsPanel.New("COLUMN INFO PANEL", SColor.HUD_Green),
	}
	lobbyMenu:SetupColumns(columns)

	local handle = RegisterPedheadshot(PlayerPedId())
	while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Citizen.Wait(0) end
	local txd = GetPedheadshotTxdString(handle)
	lobbyMenu:HeaderPicture(txd, txd) -- lobbyMenu:CrewPicture used to add a picture on the left of the HeaderPicture

	UnregisterPedheadshot(handle)  -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform..

	lobbyMenu:CanPlayerCloseMenu(true)
	-- this is just an example..CanPlayerCloseMenu is always defaulted to true.. if you set this to false.. be sure to give the players a way out of your menu!!!

	local item = UIMenuItem.New("UIMenuItem", "UIMenuItem description")
	local item1 = UIMenuListItem.New("UIMenuListItem", { "This", "is", "a", "Test" }, 0, "UIMenuListItem description")
	local item2 = UIMenuCheckboxItem.New("UIMenuCheckboxItem", true, 1, "UIMenuCheckboxItem description")
	local item3 = UIMenuSliderItem.New("UIMenuSliderItem", 100, 5, 50, false, "UIMenuSliderItem description")
	local item4 = UIMenuProgressItem.New("UIMenuProgressItem", 10, 5, "UIMenuProgressItem description")
	item:BlinkDescription(true)
	lobbyMenu.SettingsColumn:AddSettings(item)
	lobbyMenu.SettingsColumn:AddSettings(item1)
	lobbyMenu.SettingsColumn:AddSettings(item2)
	lobbyMenu.SettingsColumn:AddSettings(item3)
	lobbyMenu.SettingsColumn:AddSettings(item4)

	local crew1 = CrewTag.New("hello", true, false, CrewHierarchy.Leader, SColor.HUD_Green)
	local crew2 = CrewTag.New("evry1", true, false, CrewHierarchy.Commissioner, SColor.HUD_Pink)
	local crew3 = CrewTag.New("look", true, false, CrewHierarchy.Liutenant, SColor.HUD_Blue)
	local crew4 = CrewTag.New("at", true, false, CrewHierarchy.Representative, SColor.HUD_Orange)
	local crew5 = CrewTag.New("this", true, false, CrewHierarchy.Muscle, SColor.HUD_Red)

	local friend = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Green, true, GetRandomIntInRange(15, 55), "Status", crew1)
	local friend2 = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Pink, true, GetRandomIntInRange(15, 55), "Status", crew2)
	local friend3 = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Blue, true, GetRandomIntInRange(15, 55), "Status", crew3)
	local friend4 = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Orange, true, GetRandomIntInRange(15, 55), "Status", crew4)
	local friend5 = FriendItem.New(GetPlayerName(PlayerId()), SColor.HUD_Red, true, GetRandomIntInRange(15, 55), "Status", crew5)
	friend:SetLeftIcon(LobbyBadgeIcon.IS_CONSOLE_PLAYER, false)
	friend2:SetLeftIcon(LobbyBadgeIcon.SPECTATOR, false)
	friend3:SetLeftIcon(LobbyBadgeIcon.INACTIVE_HEADSET, false)
	friend4:SetLeftIcon(BadgeStyle.COUNTRY_ITALY, true)
	friend5:SetLeftIcon(BadgeStyle.CASTLE, true)

	friend.ClonePed = PlayerPedId() -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	friend2.ClonePed = PlayerPedId() -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	friend3.ClonePed = PlayerPedId() -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	friend4.ClonePed = PlayerPedId() -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu
	friend5.ClonePed = PlayerPedId() -- defaulted to 0 if you set it to nil / 0 the ped will be removed from the pause menu

	local panel = PlayerStatsPanel.New("Player 1", SColor.HUD_Green)
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

	local panel2 = PlayerStatsPanel.New("Player 3", SColor.HUD_Pink)
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

	local panel3 = PlayerStatsPanel.New("Player 4", SColor.HUD_Freemode)
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

	local panel4 = PlayerStatsPanel.New("Player 5", SColor.HUD_Orange)
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

	local panel5 = PlayerStatsPanel.New("Player 6", SColor.HUD_Red)
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
	lobbyMenu.PlayersColumn:AddPlayer(friend2)
	lobbyMenu.PlayersColumn:AddPlayer(friend3)
	lobbyMenu.PlayersColumn:AddPlayer(friend4)
	lobbyMenu.PlayersColumn:AddPlayer(friend5)


	local txd = CreateRuntimeTxd("scaleformui")
	local _paneldui = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "lobby_panelbackground", GetDuiHandle(_paneldui))

	lobbyMenu.MissionPanel:UpdatePanelPicture("scaleformui", "lobby_panelbackground")
	lobbyMenu.MissionPanel:Title("ScaleformUI - Title")
	local detailItem1 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRIEFCASE, SColor.HUD_Freemode)
	local detailItem2 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.STAR, SColor.HUD_Gold)
	local detailItem3 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.ARMOR, SColor.HUD_Purple)
	local detailItem4 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.BRAND_DILETTANTE, SColor.HUD_Green)
	local detailItem5 = UIMenuFreemodeDetailsItem.New("Left Label", "Right Label", false, BadgeStyle.COUNTRY_ITALY, SColor.HUD_White, true)
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
		ScaleformUI.Notifications:ShowSubtitle("SettingsColumn index =>~b~ " .. idx .. "~w~.")
	end

	lobbyMenu.PlayersColumn.OnIndexChanged = function(idx)
		ScaleformUI.Notifications:ShowSubtitle("PlayersColumn index =>~b~ " .. idx .. "~w~.")
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

	local txd = CreateRuntimeTxd("test")
	local _paneldui = CreateDui("https://i.imgur.com/mH0Y65C.gif", 288, 160)
	CreateRuntimeTextureFromDuiHandle(txd, "panelbackground", GetDuiHandle(_paneldui))

	ScaleformUI.Scaleforms.JobMissionSelector:SetTitle("MISSION SELECTOR")
	ScaleformUI.Scaleforms.JobMissionSelector.MaxVotes = 3
	ScaleformUI.Scaleforms.JobMissionSelector:SetVotes(0, "VOTED")
	ScaleformUI.Scaleforms.JobMissionSelector.Cards = {}

	local card = JobSelectionCard.New("Test 1", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, SColor.HUD_Freemode, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, SColor.HUD_Freemode),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, SColor.HUD_Gold),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, SColor.HUD_Purple),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, SColor.HUD_Green),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, SColor.HUD_White, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card)

	local card1 = JobSelectionCard.New("Test 2", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, SColor.HUD_Freemode, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, SColor.HUD_Freemode),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, SColor.HUD_Gold),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, SColor.HUD_Purple),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, SColor.HUD_Green),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, SColor.HUD_White, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card1)

	local card2 = JobSelectionCard.New("Test 3", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, SColor.HUD_Freemode, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, SColor.HUD_Freemode),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, SColor.HUD_Gold),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, SColor.HUD_Purple),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, SColor.HUD_Green),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, SColor.HUD_White, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card2)

	local card3 = JobSelectionCard.New("Test 4", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, SColor.HUD_Freemode, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, SColor.HUD_Freemode),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, SColor.HUD_Gold),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, SColor.HUD_Purple),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, SColor.HUD_Green),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, SColor.HUD_White, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card3)

	local card4 = JobSelectionCard.New("Test 5", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, SColor.HUD_Freemode, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, SColor.HUD_Freemode),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, SColor.HUD_Gold),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, SColor.HUD_Purple),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, SColor.HUD_Green),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, SColor.HUD_White, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card4)

	local card5 = JobSelectionCard.New("Test 6", "~y~Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat", "test", "panelbackground", 12, 15, JobSelectionCardIcon.BASE_JUMPING, SColor.HUD_Freemode, 2, {
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, SColor.HUD_Freemode),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, SColor.HUD_Gold),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, SColor.HUD_Purple),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, SColor.HUD_Green),
		MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, SColor.HUD_White, true),
	})
	ScaleformUI.Scaleforms.JobMissionSelector:AddCard(card5)

	ScaleformUI.Scaleforms.JobMissionSelector.Buttons = {
		JobSelectionButton.New("Button 1", "description test", {
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, SColor.HUD_Freemode),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, SColor.HUD_Gold),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, SColor.HUD_Purple),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, SColor.HUD_Green),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, SColor.HUD_White, true),
		}),
		JobSelectionButton.New("Button 2", "description test", {
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, SColor.HUD_Freemode),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, SColor.HUD_Gold),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, SColor.HUD_Purple),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, SColor.HUD_Green),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, SColor.HUD_White, true),
		}),
		JobSelectionButton.New("Button 3", "description test", {
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOMission, SColor.HUD_Freemode),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.Deathmatch, SColor.HUD_Gold),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.RaceFinish, SColor.HUD_Purple),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.GTAOSurvival, SColor.HUD_Green),
			MissionDetailsItem.New("Left Label", "Right Label", false, JobIcon.TeamDeathmatch, SColor.HUD_White, true),
		}),
	}
	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[1].Selectable = false
	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[2].Selectable = false
	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[3].Selectable = true

	ScaleformUI.Scaleforms.JobMissionSelector.Buttons[1].OnButtonPressed = function()
		ScaleformUI.Notifications:ShowSubtitle("Button Pressed => " .. ScaleformUI.Scaleforms.JobMissionSelector.Buttons[1].Text)
	end
	ScaleformUI.Scaleforms.JobMissionSelector:Enabled(true)

	Citizen.Wait(1000)
	ScaleformUI.Scaleforms.JobMissionSelector:ShowPlayerVote(3, "PlayerName", SColor.HUD_Green, true, true)
end

Citizen.CreateThread(function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	--type, position, scale, distance, color, placeOnGround, bobUpDown, rotate, faceCamera, checkZ
	local marker = Marker.New(1, pos, vector3(2, 2, 2), 100.0, { R = 0, G = 100, B = 50, A = 255 }, true, false, false, false, true)

	-- example for working timerBars.. you can disable them by setting :Enabled(false).. to hide and show them while drawing :)
	local textBar = TextTimerBar.New("Label", "Caption")
	local progrBar = ProgressTimerBar.New("Label", nil, nil, 1, 10000)
	timerBarPool:AddBar(textBar)
	timerBarPool:AddBar(progrBar)
	-- Usage example
	print("Brighness: " .. color:GetBrightness())
	print("Hue: " .. color:GetHue())
	print("Saturation: " .. color:GetSaturation())
	while true do
		Wait(0)
		marker:Draw()
		if marker:IsInRange() then
			if IsControlJustPressed(0, 51) and not MenuHandler:IsAnyMenuOpen() then
				CreateMenu()
			end
		end
		--ScaleformUI.Notifications:DrawText(0.3, 0.9, "Ped is in Range => " .. tostring(marker:IsInRange()))
		--ScaleformUI.Notifications:DrawText(0.3, 0.925, "Ped is in Marker =>" .. tostring(marker.IsInMarker))

		-- TIMER BARS FOR THE MOMENT ARE A SET OF SPRITES TEXTS AND RECTS, DRAWING THEM WILL INCREASE A LOT SCALEFORMUI'S CPU TIME!
		timerBarPool:Draw()

		if IsControlJustPressed(0, 166) and not MenuHandler:IsAnyMenuOpen() then -- F5
			CreateMenu()
		end
		if IsControlJustPressed(0, 167) and not MenuHandler:IsAnyMenuOpen() then -- F6
			CreatePauseMenu()
		end
		if IsControlJustPressed(0, 168) and not MenuHandler:IsAnyMenuOpen() then -- F7
			CreateLobbyMenu()
		end

		if IsControlJustPressed(0, 170) or IsDisabledControlJustPressed(0, 170) and not MenuHandler:IsAnyMenuOpen() then -- F3
			CreateMissionSelectorMenu()
		end

		if IsControlJustPressed(0, 58) then
			CreateRadioMenu()
		end
		if (IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21)) then
			if (IsControlJustPressed(0, 57) or IsDisabledControlJustPressed(0, 57)) and not MenuHandler:IsAnyMenuOpen() then -- F10
			end
		else
			if IsControlJustPressed(0, 57) and not IsControlPressed(0, 21) and not MenuHandler:IsAnyMenuOpen() then -- F10
				CreateRadialMenu()
			end
		end

		if IsControlJustPressed(0, 56) and not MenuHandler:IsAnyMenuOpen() then -- F9
			local handle = RegisterPedheadshot(PlayerPedId())
			while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Citizen.Wait(0) end
			local txd = GetPedheadshotTxdString(handle)

			ScaleformUI.Scaleforms.PlayerListScoreboard:SetTitle("Title", "leftLabel", 2)

			local row1 = SCPlayerItem.New(GetPlayerName(PlayerId()), SColor.HUD_Green, 65, 50, "", "hello", "", 0, "", 1, txd)
			local row2 = SCPlayerItem.New(GetPlayerName(PlayerId()), SColor.HUD_Red, 65, 100, "", "hello", "", 0, "", 1, txd)
			local row3 = SCPlayerItem.New(GetPlayerName(PlayerId()), SColor.HUD_Blue, 65, 200, "", "hello", "", 0, "", 1, txd)
			local row4 = SCPlayerItem.New(GetPlayerName(PlayerId()), SColor.HUD_Purple, 65, 250, "", "hello", "", 0, "", 1, txd)
			ScaleformUI.Scaleforms.PlayerListScoreboard:AddRow(row1)
			ScaleformUI.Scaleforms.PlayerListScoreboard:AddRow(row2)
			ScaleformUI.Scaleforms.PlayerListScoreboard:AddRow(row3)
			ScaleformUI.Scaleforms.PlayerListScoreboard:AddRow(row4)

			ScaleformUI.Scaleforms.PlayerListScoreboard:CurrentPage(1)
			ScaleformUI.Scaleforms.PlayerListScoreboard.Enabled = true
			UnregisterPedheadshot(handle) -- call it right after adding the menu.. this way the txd will be loaded correctly by the scaleform..
		end

		if IsControlJustPressed(0, 58) or IsDisabledControlJustPressed(0, 58) and not MenuHandler:IsAnyMenuOpen() then
			local txd = CreateRuntimeTxd("testui")
			local _wallp = CreateDui("https://images8.alphacoders.com/132/1322626.png", 2560, 1440)
			CreateRuntimeTextureFromDuiHandle(txd, "wallp", GetDuiHandle(_wallp))
			Citizen.Wait(100)
			local pos = GetEntityCoords(PlayerPedId())
			local overlay2 = ScaleformUI.Scaleforms.MinimapOverlays:AddScaledOverlayToMap("libertycity", "libertycity", 0, 0, 0, 400, 400, 100, true)
		end

		--[[
		if IsControlJustPressed(0, 47) then -- G
			local Enter = InstructionalButton.New('Enter', -1, 191, 191, -1)
			ScaleformUI.Scaleforms.Warning:ShowWarningWithButtons("Title", "Subtitle", "Prompt", {Enter}, "Error message", 0)
			ScaleformUI.Scaleforms.Warning.OnButtonPressed = function(button)
				print(button.Text .. " button has been pressed.")
			end
			--ScaleformUI.Scaleforms.Warning:ShowWarning("This is the title", "This is the subtitle", "This is the prompt.. you have 6 seconds left", "This is the error message, ScaleformUI Ver. 3.0", 0, false)
		end
		]]
	end
end)
