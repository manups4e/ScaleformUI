ScaleformUI = {}
ScaleformUI.Scaleforms = {}
ScaleformUI.Notifications = nil
ScaleformUI.Scaleforms._ui = nil --[[@type Scaleform]]                             -- scaleformui
ScaleformUI.Scaleforms._pauseMenu = nil --[[@type PauseMenu]]                      -- pausemenu
ScaleformUI.Scaleforms.MidMessageInstance = nil --[[@type MidMessageInstance]]     -- midmessage
ScaleformUI.Scaleforms.PlayerListScoreboard = nil --[[@type PlayerListScoreboard]] -- playerlist
ScaleformUI.Scaleforms.InstructionalButtons = nil --[[@type ButtonsHandler]]       -- buttons
ScaleformUI.Scaleforms.BigMessageInstance = nil --[[@type BigMessageInstance]]     -- bigmessage
ScaleformUI.Scaleforms.Warning = nil --[[@type WarningInstance]]                   -- warning
ScaleformUI.Scaleforms.JobMissionSelector = nil --[[@type MissionSelectorHandler]] -- missionselector
ScaleformUI.Scaleforms.RankbarHandler = nil --[[@type RankbarHandler]]             -- rankbar
ScaleformUI.Scaleforms.CountdownHandler = nil --[[@type CountdownHandler]]         -- countdown

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
    ScaleformUI.Scaleforms.BigFeed = BigFeedInstance.New()

    local wait = 850
    while true do
        wait = 850
        if not IsPauseMenuActive() then
            if ScaleformUI.Scaleforms.BigMessageInstance._sc ~= nil then
                ScaleformUI.Scaleforms.BigMessageInstance:Update()
                wait = 0
            end
            if ScaleformUI.Scaleforms.MidMessageInstance._sc ~= nil then
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
            if ScaleformUI.Scaleforms.BigFeed._sc ~= nil and ScaleformUI.Scaleforms.BigFeed._enabled then
                ScaleformUI.Scaleforms.BigFeed:Update()
                wait = 0
            end
        end
        if (ScaleformUI.Scaleforms.InstructionalButtons._sc == nil) then
            ScaleformUI.Scaleforms.InstructionalButtons:Load()
        elseif ScaleformUI.Scaleforms.InstructionalButtons:Enabled() or ScaleformUI.Scaleforms.InstructionalButtons.IsSaving then
            ScaleformUI.Scaleforms.InstructionalButtons:Update()
            wait = 0
        end
        if ScaleformUI.Scaleforms._ui == nil then
            ScaleformUI.Scaleforms._ui = Scaleform.Request("scaleformui")
        end
        if not ScaleformUI.Scaleforms._pauseMenu.Loaded then
            ScaleformUI.Scaleforms._pauseMenu:Load()
        end

        if ScaleformUI.Scaleforms.BigMessageInstance._sc == nil and
            ScaleformUI.Scaleforms.MidMessageInstance._sc == nil and
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
