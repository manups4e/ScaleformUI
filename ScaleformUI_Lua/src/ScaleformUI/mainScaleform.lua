ScaleformUI = {}
ScaleformUI.Scaleforms = {}
ScaleformUI.Scaleforms._ui = nil --[[@type Scaleform]]                                                -- scaleformui
ScaleformUI.Scaleforms._pauseMenu = nil --[[@type PauseMenu]]                                         -- pausemenu
ScaleformUI.Scaleforms._radialMenu = nil --[[@type RadialMenu]]                                       -- radialmenu
ScaleformUI.Scaleforms._radioMenu = nil --[[@type UIRadioMenu]]                                       -- radiomenu
ScaleformUI.Scaleforms.MidMessageInstance = MidMessageInstance --[[@type MidMessageInstance]]         -- midmessage
ScaleformUI.Scaleforms.PlayerListScoreboard = PlayerListScoreboard --[[@type PlayerListScoreboard]]   -- playerlist
ScaleformUI.Scaleforms.InstructionalButtons = ButtonsHandler --[[@type ButtonsHandler]]               -- buttons
ScaleformUI.Scaleforms.BigMessageInstance = BigMessageInstance --[[@type BigMessageInstance]]         -- bigmessage
ScaleformUI.Scaleforms.Warning = WarningInstance --[[@type WarningInstance]]                          -- warning
ScaleformUI.Scaleforms.JobMissionSelector = MissionSelectorHandler --[[@type MissionSelectorHandler]] -- missionselector
ScaleformUI.Scaleforms.RankbarHandler = RankbarHandler --[[@type RankbarHandler]]                     -- rankbar
ScaleformUI.Scaleforms.SplashText = SplashTextInstance
ScaleformUI.Notifications = Notifications
ScaleformUI.Scaleforms.BigFeed = BigFeedInstance
ScaleformUI.Scaleforms.MinimapOverlays = MinimapOverlays
ScaleformUI.WaitTime = 850

ScaleformUI.Scaleforms._pauseMenu = nil

AddEventHandler("onResourceStop", function(resName)
    if resName == GetCurrentResourceName() then
        if MenuHandler:IsAnyMenuOpen() or MenuHandler:IsAnyPauseMenuOpen() then
            MenuHandler:CloseAndClearHistory()
        end
        if IsPauseMenuActive() and GetCurrentFrontendMenuVersion() == `FE_MENU_VERSION_CORONA` then
            ActivateFrontendMenu(`FE_MENU_VERSION_CORONA`, false, 0)
            AnimpostfxStop("PauseMenuIn");
            AnimpostfxPlay("PauseMenuOut", 800, false);
        end
        -- DO NOT REMOVE THIS.. THIS IS NEEDED!
        ScaleformUI.Scaleforms.MinimapOverlays:ClearAll()
        ScaleformUI.Scaleforms._pauseMenu:Dispose()
        ScaleformUI.Scaleforms._ui:CallFunction("CLEAR_ALL")
        ScaleformUI.Scaleforms._ui:Dispose()
        ScaleformUI.Scaleforms._radialMenu:CallFunction("CLEAR_ALL")
        ScaleformUI.Scaleforms._radialMenu:Dispose()
        ScaleformUI.Scaleforms._radioMenu:CallFunction("CLEAR_ALL")
        ScaleformUI.Scaleforms._radioMenu:Dispose()
        if not IsPlayerControlOn(PlayerId()) then
            SetPlayerControl(PlayerId(), true, 0)
        end
    end
end)

local function initializeScaleforms()
    ScaleformUI.Scaleforms._ui = Scaleform.RequestWidescreen("scaleformui")
    ScaleformUI.Scaleforms._radialMenu = Scaleform.RequestWidescreen("radialmenu")
    ScaleformUI.Scaleforms._radioMenu = Scaleform.RequestWidescreen("radiomenu")
    ScaleformUI.Scaleforms._pauseMenu = PauseMenu.New()
    ScaleformUI.Scaleforms._pauseMenu:Load()
    ScaleformUI.Scaleforms.MinimapOverlays:Load()
end

Citizen.CreateThread(function()
    initializeScaleforms()
    
    while true do
        -- Check if any menu is active
        if MenuHandler:IsAnyMenuOpen() or MenuHandler:IsAnyPauseMenuOpen() then
            if MenuHandler.ableToDraw and not (IsWarningMessageActive() or ScaleformUI.Scaleforms.Warning:IsShowing()) then
                -- Cache frontend menu version check
                local currentMenuVersion = GetCurrentFrontendMenuVersion()
                
                if currentMenuVersion == `FE_MENU_VERSION_CORONA` then
                    SetScriptGfxDrawBehindPausemenu(true)
                    
                    BeginScaleformMovieMethodOnFrontend("INSTRUCTIONAL_BUTTONS")
                    ScaleformMovieMethodAddParamPlayerNameString("SET_DATA_SLOT_EMPTY")
                    EndScaleformMovieMethod()
                    
                    BeginScaleformMovieMethodOnFrontendHeader("SHOW_MENU")
                    ScaleformMovieMethodAddParamBool(false)
                    EndScaleformMovieMethod()
                    
                    BeginScaleformMovieMethodOnFrontendHeader("SHOW_HEADING_DETAILS")
                    ScaleformMovieMethodAddParamBool(false)
                    EndScaleformMovieMethod()
                end
                
                MenuHandler:ProcessMenus()
            end
        end
        
        -- Update scaleforms outside menu checks
        ScaleformUI.Scaleforms.Warning:Update()
        
        if ScaleformUI.Scaleforms.SplashText ~= nil then
            ScaleformUI.Scaleforms.SplashText:Draw()
        end
        
        ScaleformUI.Scaleforms.InstructionalButtons:Update()
        
        if not IsPauseMenuActive() then
            ScaleformUI.Scaleforms.BigMessageInstance:Update()
            ScaleformUI.Scaleforms.MidMessageInstance:Update()
            ScaleformUI.Scaleforms.PlayerListScoreboard:Update()
            ScaleformUI.Scaleforms.JobMissionSelector:Update()
            ScaleformUI.Scaleforms.BigFeed:Update()
            
            -- Check for null references once per iteration
            if ScaleformUI.Scaleforms._ui == nil then
                ScaleformUI.Scaleforms._ui = Scaleform.RequestWidescreen("scaleformui")
            end
            if ScaleformUI.Scaleforms._radialMenu == nil then
                ScaleformUI.Scaleforms._radialMenu = Scaleform.RequestWidescreen("radialmenu")
            end
            if ScaleformUI.Scaleforms._radioMenu == nil then
                ScaleformUI.Scaleforms._radioMenu = Scaleform.RequestWidescreen("radiomenu")
            end
            if not ScaleformUI.Scaleforms._pauseMenu:IsLoaded() then
                ScaleformUI.Scaleforms._pauseMenu:Load()
            end
        end
        Citizen.Wait(0)
    end
end)