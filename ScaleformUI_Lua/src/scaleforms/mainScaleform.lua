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
ScaleformUI.WaitTime = 850

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
    ScaleformUI.Scaleforms._ui = Scaleform.RequestWidescreen("scaleformui")
    ScaleformUI.Scaleforms.BigMessageInstance = BigMessageInstance
    ScaleformUI.Scaleforms.MidMessageInstance = MidMessageInstance
    ScaleformUI.Scaleforms.Warning = WarningInstance
    ScaleformUI.Scaleforms.PlayerListScoreboard = PlayerListScoreboard.New()
    ScaleformUI.Scaleforms.JobMissionSelector = MissionSelectorHandler
    ScaleformUI.Scaleforms.InstructionalButtons = ButtonsHandler
    ScaleformUI.Scaleforms._pauseMenu = PauseMenu.New()
    ScaleformUI.Scaleforms._pauseMenu:Load()
    ScaleformUI.Scaleforms.RankbarHandler = RankbarHandler
    ScaleformUI.Scaleforms.CountdownHandler = CountdownHandler
    ScaleformUI.Scaleforms.BigFeed = BigFeedInstance
    ScaleformUI.Notifications = Notifications

    while true do
        ScaleformUI.WaitTime = 850
        if not IsPauseMenuActive() then
            ScaleformUI.Scaleforms.BigMessageInstance:Update()
            ScaleformUI.Scaleforms.MidMessageInstance:Update()
            ScaleformUI.Scaleforms.PlayerListScoreboard:Update()
            ScaleformUI.Scaleforms.JobMissionSelector:Update()
            ScaleformUI.Scaleforms.Warning:Update()
            ScaleformUI.Scaleforms.BigFeed:Update()
        end
        if MenuHandler.ableToDraw and not (IsWarningMessageActive() or ScaleformUI.Scaleforms.Warning:IsShowing()) then
            ScaleformUI.WaitTime = 0
            MenuHandler:ProcessMenus()
        end
        if ScaleformUI.Scaleforms._ui == nil then
            ScaleformUI.Scaleforms._ui = Scaleform.RequestWidescreen("scaleformui")
        end
        if not ScaleformUI.Scaleforms._pauseMenu.Loaded then
            ScaleformUI.Scaleforms._pauseMenu:Load()
        end
        ScaleformUI.Scaleforms.InstructionalButtons:Update()
        Citizen.Wait(ScaleformUI.WaitTime)
    end
end)
