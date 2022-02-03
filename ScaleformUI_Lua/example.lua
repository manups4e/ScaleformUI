local pool = MenuPool.New()
Citizen.CreateThread(function()
	pool:RefreshIndex()
	while true do
		Wait(0)
        pool:ProcessControl()
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
        pool:ProcessMouse()
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
        pool:Draw()
	end
end)

Citizen.CreateThread(function()

	local exampleMenu = UIMenu.New("Native UI", "ScaleformUI SHOWCASE", 50, 50, true)
	pool:Add(exampleMenu)

	local ketchupItem = UIMenuCheckboxItem.New("Add ketchup?", true, 0, "Do you wish to add ketchup?")
	exampleMenu:AddItem(ketchupItem)

	local cookItem = UIMenuItem.New("Cook!", "Cook the dish with the appropiate ingredients and ketchup.")
	exampleMenu:AddItem(cookItem)
	cookItem:SetRightBadge(26)

	local colorItem = UIMenuItem.New("UIMenuItem with Colors", "~b~Look!!~r~I can be colored ~y~too!!~w~", 21, 24)
	exampleMenu:AddItem(colorItem)

	local blankItem = UIMenuItem.New("", "")
	exampleMenu:AddItem(blankItem)

	local foodsList = {"Banana", "Apple", "Pizza", "Quartilicious"}
	local colorListItem  = UIMenuListItem.New("Colored ListItem.. Really?", foodsList, 0, "~BLIP_BARBER~ ~BLIP_INFO_ICON~ ~BLIP_TANK~ ~BLIP_OFFICE~ ~BLIP_CRIM_DRUGS~ ~BLIP_WAYPOINT~ ~INPUTGROUP_MOVE~~n~You can use Blips and Inputs in description as you prefer!", 21, 24)
	exampleMenu:AddItem(colorListItem)

	local sliderItem = UIMenuSliderItem.New("Slider Item!", 100, 5, 0, false, "Cool!")
	exampleMenu:AddItem(sliderItem)
	local progressItem = UIMenuProgressItem.New("Slider Progress Item", 10, 0)
	exampleMenu:AddItem(progressItem)

	local listPanelItem1 = UIMenuItem.New("Change Color", "It can be whatever item you want it to be")
	local colorPanel = UIMenuColorPanel.New("Color Panel Example", 1, 0)
	exampleMenu:AddItem(listPanelItem1)
	listPanelItem1:AddPanel(colorPanel)

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

	colorPanel.PanelChanged = function(menu, item, newindex)
		local message = "ColorPanel index => " .. newindex + 1
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

	momListItem.OnListChanged = function(menu, item, newindex)
		heritageWindow:Index(newindex, -1)
	end

	dadListItem.OnListChanged = function(menu, item, newindex)
		heritageWindow:Index(-1, newindex)
	end

	heritageSliderItem.OnSliderChanged = function(menu, item, value)
		detailsWindow.DetailStats[1].Percentage = 100 - value
		detailsWindow.DetailStats[2].Percentage = value
		detailsWindow:UpdateStatsToWheel()
		detailsWindow:UpdateLabels("Parents resemblance", "Dad: " .. value .. "%", "Mom: " .. (100 - value) .. "%")
	end

	while true do
		Wait(0)
		if IsControlJustPressed(0, 51) then
			exampleMenu:Visible(true)
		end
		if IsControlJustPressed(0, 0) then
			ScaleformUI.Scaleforms._ui:Dispose()
			ScaleformUI.Scaleforms._ui = 0
		end
	end
end)