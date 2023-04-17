ScaleformUI = {}
ScaleformUI.Scaleforms = {}
ScaleformUI.Notifications = nil
ScaleformUI.Scaleforms._ui = 0
ScaleformUI.Scaleforms._pauseMenu = nil
ScaleformUI.Scaleforms.MidMessageInstance = nil
ScaleformUI.Scaleforms.PlayerListScoreboard = nil
ScaleformUI.Scaleforms.InstructionalButtons = nil
ScaleformUI.Scaleforms.BigMessageInstance = nil
ScaleformUI.Scaleforms.Warning = nil
ScaleformUI.Scaleforms.PlayerListInstance = nil
ScaleformUI.Scaleforms.JobMissionSelector = nil
ScaleformUI.Scaleforms.RankbarHandler = nil
ScaleformUI.Scaleforms.CountdownHandler = nil

ScaleformUI.Scaleforms._pauseMenu = nil

AddEventHandler("onResourceStop", function(resName)
    if resName == GetCurrentResourceName() then
        if IsPauseMenuActive() and GetCurrentFrontendMenuVersion() == -2060115030 then
            ActivateFrontendMenu(`FE_MENU_VERSION_EMPTY_NO_BACKGROUND`, true, -1)
            AnimpostfxStop("PauseMenuIn");
            AnimpostfxPlay("PauseMenuOut", 800, false);
        end
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
    ScaleformUI.Scaleforms.PlayerListScoreboard = PlayerListScoreboard.New()
    ScaleformUI.Scaleforms.JobMissionSelector = MissionSelectorHandler.New()
    ScaleformUI.Scaleforms.InstructionalButtons = ButtonsHandler.New()
    ScaleformUI.Notifications = Notifications.New()
    ScaleformUI.Scaleforms._pauseMenu = PauseMenu.New()
    ScaleformUI.Scaleforms._pauseMenu:Load()
    ScaleformUI.Scaleforms.RankbarHandler = RankbarHandler.New()
    ScaleformUI.Scaleforms.CountdownHandler = CountdownHandler.New()

    local wait = 850
    while true do
        wait = 850
        if not IsPauseMenuActive() then
            if ScaleformUI.Scaleforms.BigMessageInstance._sc ~= 0 then
                ScaleformUI.Scaleforms.BigMessageInstance:Update()
                wait = 0
            end
            if ScaleformUI.Scaleforms.MidMessageInstance._sc ~= 0 then
                ScaleformUI.Scaleforms.MidMessageInstance:Update()
                wait = 0
            end
            if ScaleformUI.Scaleforms.PlayerListScoreboard._sc ~= nil and ScaleformUI.Scaleforms.PlayerListScoreboard.Enabled then
                ScaleformUI.Scaleforms.PlayerListScoreboard:Update()
                wait = 0
            end
            if ScaleformUI.Scaleforms.JobMissionSelector.enabled and ScaleformUI.Scaleforms.JobMissionSelector._sc and ScaleformUI.Scaleforms.JobMissionSelector._sc:IsLoaded() then
                ScaleformUI.Scaleforms.JobMissionSelector:Update()
                wait = 0
            end
            if ScaleformUI.Scaleforms.Warning._sc ~= nil then
                ScaleformUI.Scaleforms.Warning:Update()
                wait = 0
            end
        end
        if (ScaleformUI.Scaleforms.InstructionalButtons._sc == nil) then
            ScaleformUI.Scaleforms.InstructionalButtons:Load()
        elseif ScaleformUI.Scaleforms.InstructionalButtons:Enabled() or ScaleformUI.Scaleforms.InstructionalButtons.IsSaving then
            ScaleformUI.Scaleforms.InstructionalButtons:Update()
            wait = 0
        end
        if ScaleformUI.Scaleforms._ui == 0 or ScaleformUI.Scaleforms._ui == nil then
            ScaleformUI.Scaleforms._ui = Scaleform.Request("scaleformui")
        end
        if not ScaleformUI.Scaleforms._pauseMenu.Loaded then
            ScaleformUI.Scaleforms._pauseMenu:Load()
        end

        if ScaleformUI.Scaleforms.BigMessageInstance._sc == 0 and
            ScaleformUI.Scaleforms.MidMessageInstance._sc == 0 and
            ScaleformUI.Scaleforms.Warning._sc == nil and
            (ScaleformUI.Scaleforms.PlayerListScoreboard._sc ~= nil and not ScaleformUI.Scaleforms.PlayerListScoreboard.Enabled) and
            (ScaleformUI.Scaleforms.JobMissionSelector.enabled or ScaleformUI.Scaleforms.JobMissionSelector._sc == nil) and
            (not ScaleformUI.Scaleforms.InstructionalButtons._enabled or (ScaleformUI.Scaleforms.InstructionalButtons.ControlButtons == nil or #ScaleformUI.Scaleforms.InstructionalButtons.ControlButtons == 0 and not ScaleformUI.Scaleforms.InstructionalButtons.IsSaving))
        then
            wait = 850
        end

        Citizen.Wait(wait)
    end
end)
