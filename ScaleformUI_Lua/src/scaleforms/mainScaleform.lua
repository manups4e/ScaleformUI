ScaleformUI = {}
ScaleformUI.Scaleforms = {}
ScaleformUI.Scaleforms._ui = 0
ScaleformUI.Scaleforms.PauseMenu = nil
ScaleformUI.Scaleforms.MidMessageInstance = nil
ScaleformUI.Scaleforms.InstructionalButtons = nil
ScaleformUI.Scaleforms.BigMessageInstance = nil
ScaleformUI.Scaleforms.Warning = nil
ScaleformUI.Scaleforms.PlayerListInstance = nil

Citizen.CreateThread(function()
    ScaleformUI.Scaleforms._ui = Scaleform.Request("scaleformui")
    ScaleformUI.Scaleforms.BigMessageInstance = BigMessageInstance.New()
    ScaleformUI.Scaleforms.MidMessageInstance = MidMessageInstance.New()
    ScaleformUI.Scaleforms.Warning = WarningInstance.New()
    ScaleformUI.Scaleforms.InstructionalButtons = ButtonsHandler.New()
    while(true)do
        Wait(0)
        ScaleformUI.Scaleforms.BigMessageInstance:Update()
        ScaleformUI.Scaleforms.MidMessageInstance:Update()
        ScaleformUI.Scaleforms.InstructionalButtons:Update()
        ScaleformUI.Scaleforms.Warning:Update()
        if (ScaleformUI.Scaleforms._ui == 0 or ScaleformUI.Scaleforms._ui == nil) then
            ScaleformUI.Scaleforms._ui = Scaleform.Request("scaleformui")
        end
    end
end)

Citizen.CreateThread(function()
    while(true)do
        Wait(0)
        if(IsControlJustPressed(0, 47)) then
            -- INSTRUCTIONAL BUTTONS
            --[[ 
            local bts = {
                InstructionalButton.New("Button 1", -1, 51, 51, -1),
                InstructionalButton.New("Button 2", -1, -1, -1, "INPUTGROUP_LOOK"),
                InstructionalButton.New("Button 3", -1, 51, 47, -1),
                InstructionalButton.New("Button 4", -1, {32, 34, 33, 35}, {20, 52, 48, 51}, -1),
            }
            ScaleformUI.Scaleforms.InstructionalButtons:SetInstructionalButtons(bts)
            ScaleformUI.Scaleforms.InstructionalButtons:Enabled(true)
            Citizen.Wait(5000)
            ScaleformUI.Scaleforms.InstructionalButtons:Enabled(false)
            ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList()
            ]]
            -- WARNING
            ScaleformUI.Scaleforms.Warning:ShowWarning("Title", "subtitle", "prompt", "errorMsg", 0)
            Citizen.Wait(5000)
            ScaleformUI.Scaleforms.Warning:Dispose()
        end
    end
end)
