ScaleformUI = {}
ScaleformUI.Scaleforms = {}
ScaleformUI.Scaleforms._ui = nil --[[@type Scaleform]]                                                -- scaleformui
ScaleformUI.Scaleforms._pauseMenu = nil --[[@type PauseMenu]]                                         -- pausemenu
ScaleformUI.Scaleforms._radialMenu = nil --[[@type RadialMenu]]                                       -- radialmenu
ScaleformUI.Scaleforms.MidMessageInstance = MidMessageInstance --[[@type MidMessageInstance]]         -- midmessage
ScaleformUI.Scaleforms.PlayerListScoreboard = PlayerListScoreboard --[[@type PlayerListScoreboard]]   -- playerlist
ScaleformUI.Scaleforms.InstructionalButtons = ButtonsHandler --[[@type ButtonsHandler]]               -- buttons
ScaleformUI.Scaleforms.BigMessageInstance = BigMessageInstance --[[@type BigMessageInstance]]         -- bigmessage
ScaleformUI.Scaleforms.Warning = WarningInstance --[[@type WarningInstance]]                          -- warning
ScaleformUI.Scaleforms.JobMissionSelector = MissionSelectorHandler --[[@type MissionSelectorHandler]] -- missionselector
ScaleformUI.Scaleforms.RankbarHandler = RankbarHandler --[[@type RankbarHandler]]                     -- rankbar
ScaleformUI.Notifications = Notifications
ScaleformUI.Scaleforms.BigFeed = BigFeedInstance
ScaleformUI.Scaleforms.MinimapOverlays = MinimapOverlays
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
        ScaleformUI.Scaleforms._radialMenu:CallFunction("CLEAR_ALL", false)
        ScaleformUI.Scaleforms._radialMenu:Dispose()
        if not IsPlayerControlOn(PlayerId()) then
            SetPlayerControl(PlayerId(), true, 0)
        end
    end
end)

Citizen.CreateThread(function()
    ScaleformUI.Scaleforms._ui = Scaleform.RequestWidescreen("scaleformui")
    ScaleformUI.Scaleforms._radialMenu = Scaleform.RequestWidescreen("radialmenu")
    ScaleformUI.Scaleforms._pauseMenu = PauseMenu.New()
    ScaleformUI.Scaleforms._pauseMenu:Load()

    while true do
        ScaleformUI.WaitTime = 850
        if MenuHandler.ableToDraw and not (IsWarningMessageActive() or ScaleformUI.Scaleforms.Warning:IsShowing()) then
            ScaleformUI.WaitTime = 0
            MenuHandler:ProcessMenus()
        end
        ScaleformUI.Scaleforms.Warning:Update()
        ScaleformUI.Scaleforms.InstructionalButtons:Update()
        if IsPauseMenuActive() then return end
        ScaleformUI.Scaleforms.BigMessageInstance:Update()
        ScaleformUI.Scaleforms.MidMessageInstance:Update()
        ScaleformUI.Scaleforms.PlayerListScoreboard:Update()
        ScaleformUI.Scaleforms.JobMissionSelector:Update()
        ScaleformUI.Scaleforms.BigFeed:Update()
        if ScaleformUI.Scaleforms._ui == nil then
            ScaleformUI.Scaleforms._ui = Scaleform.RequestWidescreen("scaleformui")
        end
        if ScaleformUI.Scaleforms._radialMenu == nil then
            ScaleformUI.Scaleforms._radialMenu = Scaleform.RequestWidescreen("radialmenu")
        end
        if not ScaleformUI.Scaleforms._pauseMenu.Loaded then
            ScaleformUI.Scaleforms._pauseMenu:Load()
        end
        Citizen.Wait(ScaleformUI.WaitTime)
    end
end)
