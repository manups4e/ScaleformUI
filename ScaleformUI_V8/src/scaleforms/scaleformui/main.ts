import { MenuHandler } from "menus/menu-handler";
import { InstructionalButtonsHandler } from "scaleforms/instructional-buttons/instructionalbuttonshandler";
import { MinimapOverlays } from "scaleforms/minimap/minimap";
import { PauseMenuHandler } from "scaleforms/pausemenu/pausemenu-handler";
import { Scaleform } from "scaleforms/scaleform";

class Main {
    public Scaleforms: Scaleforms;
    public Notifications: Notifications; // Replace with actual type
    constructor() {
        this.Scaleforms = new Scaleforms();
        this.Notifications = new Notifications();
    }
}

class Scaleforms {
    _ui: Scaleform;
    _pauseMenu: PauseMenuHandler;
    _radialMenu: Scaleform;
    _radioMenu: Scaleform;
    MidMessageInstance: any; // Replace with actual type
    PlayerListScoreboard: any; // Replace with actual type
    InstructionalButtons: InstructionalButtonsHandler;
    BigMessageInstance: any; // Replace with actual type
    Warning: any; // Replace with actual type
    JobMissionSelector: any; // Replace with actual type
    RankbarHandler: any; // Replace with actual type
    SplashText: any; // Replace with actual type
    BigFeed: any; // Replace with actual type
    MinimapOverlays: MinimapOverlays;

    constructor() {
        this._ui = Scaleform.requestWideScreen("scaleformui")
        this._radialMenu = Scaleform.requestWideScreen("radialmenu")
        this._radioMenu = Scaleform.requestWideScreen("radiomenu")
        this._pauseMenu = new PauseMenuHandler()
        this.InstructionalButtons = new InstructionalButtonsHandler();
        this._pauseMenu.load()
        this.MinimapOverlays = new MinimapOverlays();
        this.MinimapOverlays.load()
    }
}

export const ScaleformUI = new Main();
ScaleformUI.Scaleforms = new Scaleforms();



// Add event handler for "onResourceStop"
on('onResourceStop', (resName: string) => {
    if (resName === GetCurrentResourceName()) {
        if (IsPauseMenuActive() && GetCurrentFrontendMenuVersion() == -2060115030) {
            ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY_NO_BACKGROUND"), true, -1)
            AnimpostfxStop("PauseMenuIn");
            AnimpostfxPlay("PauseMenuOut", 800, false);
        }
        ScaleformUI.Scaleforms._pauseMenu?.dispose()
        ScaleformUI.Scaleforms._ui?.callFunction("CLEAR_ALL")
        ScaleformUI.Scaleforms._ui?.dispose()
        ScaleformUI.Scaleforms._radialMenu?.callFunction("CLEAR_ALL")
        ScaleformUI.Scaleforms._radialMenu?.dispose()
        ScaleformUI.Scaleforms._radioMenu?.callFunction("CLEAR_ALL")
        ScaleformUI.Scaleforms._radioMenu?.dispose()
        if (!IsPlayerControlOn(PlayerId()))
            SetPlayerControl(PlayerId(), true, 0)
    }
});

setTick(() => {
    if (MenuHandler.ableToDraw && !(IsWarningMessageActive() || ScaleformUI.Scaleforms.Warning.IsShowing)) {
        MenuHandler.ProcessMenus();
    }
    /*
    ScaleformUI.Scaleforms.Warning.update();
    if (ScaleformUI.Scaleforms.SplashText != null) {
        ScaleformUI.Scaleforms.SplashText.draw();
    }
    */
    ScaleformUI.Scaleforms.InstructionalButtons.Update();
    if (!IsPauseMenuActive()) {
        //ScaleformUI.Scaleforms.MidMessageInstance.update()
        //ScaleformUI.Scaleforms.PlayerListScoreboard.update()
        //ScaleformUI.Scaleforms.JobMissionSelector.update()
        //ScaleformUI.Scaleforms.BigFeed.update()
        if (ScaleformUI.Scaleforms._ui == null)
            ScaleformUI.Scaleforms._ui = Scaleform.requestWideScreen("scaleformui")
        if (ScaleformUI.Scaleforms._radialMenu == null)
            ScaleformUI.Scaleforms._radialMenu = Scaleform.requestWideScreen("radialmenu")
        if (ScaleformUI.Scaleforms._radioMenu == null)
            ScaleformUI.Scaleforms._radioMenu = Scaleform.requestWideScreen("radiomenu")
        if (!ScaleformUI.Scaleforms._pauseMenu?.Loaded)
            ScaleformUI.Scaleforms._pauseMenu?.load()
    }
});

