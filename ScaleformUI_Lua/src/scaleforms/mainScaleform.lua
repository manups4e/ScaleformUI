ScaleformUI = {}
ScaleformUI.Scaleforms = {}
ScaleformUI.Notifications = nil
ScaleformUI.Scaleforms._ui = 0
ScaleformUI.Scaleforms.PauseMenu = nil
ScaleformUI.Scaleforms.MidMessageInstance = nil
ScaleformUI.Scaleforms.InstructionalButtons = nil
ScaleformUI.Scaleforms.BigMessageInstance = nil
ScaleformUI.Scaleforms.Warning = nil
ScaleformUI.Scaleforms.PlayerListInstance = nil
ScaleformUI.Scaleforms._pauseMenu = nil

AddEventHandler("onResourceStop", function(resName) 
    if resName == GetCurrentResourceName() then
        ScaleformUI.Scaleforms._pauseMenu:Dispose()
        ScaleformUI.Scaleforms._ui:CallFunction("CLEAR_ALL", false)
        ScaleformUI.Scaleforms._ui:Dispose()
        if not IsPlayerControlOn(PlayerId()) then
            SetPlayerControl(PlayerId(), true, 0)
        end
    end
end)

Citizen.CreateThread(function()
    ScaleformUI.Scaleforms._ui = Scaleform.Request("scaleformui")
    ScaleformUI.Scaleforms.BigMessageInstance = BigMessageInstance.New()
    ScaleformUI.Scaleforms.MidMessageInstance = MidMessageInstance.New()
    ScaleformUI.Scaleforms.Warning = WarningInstance.New()
    ScaleformUI.Scaleforms.InstructionalButtons = ButtonsHandler.New()
    ScaleformUI.Notifications = Notifications.New()
    ScaleformUI.Scaleforms._pauseMenu = PauseMenu.New()
    ScaleformUI.Scaleforms._pauseMenu:Load()
    
    while true do
        Wait(0)
        ScaleformUI.Scaleforms.BigMessageInstance:Update()
        ScaleformUI.Scaleforms.MidMessageInstance:Update()
        ScaleformUI.Scaleforms.InstructionalButtons:Update()
        ScaleformUI.Scaleforms.Warning:Update()
        if ScaleformUI.Scaleforms._ui == 0 or ScaleformUI.Scaleforms._ui == nil then
            ScaleformUI.Scaleforms._ui = Scaleform.Request("scaleformui")
        end
        if not ScaleformUI.Scaleforms._pauseMenu.Loaded then
            ScaleformUI.Scaleforms._pauseMenu:Load()
        end
    end
end)