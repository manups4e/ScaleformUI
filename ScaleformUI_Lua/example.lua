local pool = MenuPool.New()
Citizen.CreateThread(function()
	pool:RefreshIndex()
	while true do
		Citizen.Wait(0)
        pool:ProcessMenus()
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
	item:BlinkDescription(true)
	menu:AddItem(item)
	menu:AddItem(check)
	menu:AddItem(list)
	menu:AddItem(slide)
	menu:AddItem(heritage)
	menu:AddItem(progress)
	menu:AddItem(stats)

	menu.OnMenuChanged = function(old, new, type)
		if type == "opened" then
			print("Menu opened!")
		elseif(type == "closed")then
			print("Menu closed!")
		elseif(type == "backwards") then
			print("Menu going backwards!")
		elseif(type == "forwards") then
			print("Menu going forwards!")
		end
	end

	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 51) then
			menu:Visible(true)
		end
		if IsControlJustPressed(0, 0) then
			ScaleformUI.Scaleforms._ui:Dispose()
			ScaleformUI.Scaleforms._ui = 0
		end
	end
end)