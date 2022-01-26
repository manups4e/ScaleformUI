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
	local menu = UIMenu.New("test", "test", 50, 50)
	pool:Add(menu)
	local item = UIMenuItem.New("Item", "Description")
	local aa = {"ciao", "ciao 2", "ciao 3", 12343}
	local check = UIMenuCheckboxItem.New("Checkbox", true, 0, "Checkbox description")
	local list = UIMenuListItem.New("List", aa, 0, "List Description")
	local slide = UIMenuSliderItem.New("Slider", 100, 5, 0, false, "Slider Description")
	local heritage = UIMenuSliderItem.New("Slider", 100, 5, 0, true, "Slider Description")
	local progress = UIMenuProgressItem.New("Progress", 100, 0, "Progress Description")
	local stats = UIMenuStatsItem.New("Stats", "Stats Description", 50)
	local colorPanel = UIMenuColorPanel.New("TEST TITLE", 0, 0)
	local gridPanel = UIMenuGridPanel.New()
	local percentagePanel = UIMenuPercentagePanel.New()
	local statisticsPanel = UIMenuStatisticsPanel.New()
	statisticsPanel:AddStatistic("NAME #1", 50.0)
	statisticsPanel:AddStatistic("NAME #2", 150.0)
	statisticsPanel:AddStatistic("NAME #3", 13.37)
	statisticsPanel:AddStatistic("NAME #4", -10.0)

	item:BlinkDescription(true)
	menu:AddItem(item)
	menu:AddItem(check)
	menu:AddItem(list)
	menu:AddItem(slide)
	menu:AddItem(heritage)
	menu:AddItem(progress)
	menu:AddItem(stats)

	item:AddPanel(colorPanel)
	item:AddPanel(gridPanel)
	item:AddPanel(percentagePanel)
	item:AddPanel(statisticsPanel)

	menu.OnMenuChanged = function(old, new, type)
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

	while true do
		Wait(0)
		if IsControlJustPressed(0, 51) then
			menu:Visible(true)
		end
		if IsControlJustPressed(0, 0) then
			ScaleformUI.Scaleforms._ui:Dispose()
			ScaleformUI.Scaleforms._ui = 0
		end
	end
end)