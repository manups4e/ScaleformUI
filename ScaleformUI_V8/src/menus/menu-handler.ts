import { BreadcrumbsHandler } from "./breadcrumbs-handler";
import { BaseMenu } from "./menu.base";

export class MenuHandler {
    static _currentMenu: BaseMenu | null = null;
    static _currentPauseMenu: BaseMenu | null = null;
    static ableToDraw = false;

    static SwitchTo(currentMenu: BaseMenu, newMenu: BaseMenu, newMenuCurrentSelection?: number, inheritOldMenuParams?: boolean, data?: any) {
        if (currentMenu == null)
            throw ("The menu you're switching from cannot be null");
        if (currentMenu != this._currentMenu)
            throw ("The menu you're switching from must be opened");
        if (newMenu == null)
            throw ("The menu you're switching to cannot be null");
        if (newMenu == currentMenu)
            throw ("You cannot switch a menu to itself");
        if (newMenu instanceof UIMenu && newMenu.Items.length === 0)
            throw ("You cannot switch to an empty menu");
        if (newMenu.Visible)
            throw ("The menu you're switching to is already open");

        if (BreadcrumbsHandler.SwitchInProgress)
            return;
        BreadcrumbsHandler.SwitchInProgress = true;

        if (newMenuCurrentSelection === null)
            newMenuCurrentSelection = 0;
        if (currentMenu instanceof UIMenu && newMenu instanceof UIMenu) {
            let new: UIMenu = newMenu as UIMenu;
            let old: UIMenu = currentMenu as UIMenu;
            if (inheritOldMenuParams == null) {
                inheritOldMenuParams = false
            }
            if (inheritOldMenuParams) {
                if (old.TxtDictionary != null && old.TxtDictionary != "" && old.TxtName != null && old.TxtName != "") {
                    new.TxtDictionary = old.TxtDictionary;
                    new.TxtName = old.TxtName;
                }
                new.Position = old.Position;
                if (old.Logo != null)
                    new.Logo = old.Logo;
                else {
                    new.Logo = null
                    new.Banner = old.Banner;
                }

                new.Glare = old.Glare;
                new.MaxItemsOnScreen = old.MaxItemsOnScreen;
                new.AnimationEnabled = old.AnimationEnabled;
                new.AnimationType = old.AnimationType;
                new.BuildingAnimation = old.BuildingAnimation;
                new.ScrollingType = old.ScrollingType;
                new.MouseSettings(old.MouseControlsEnabled, old.MouseEdgeEnabled, old.MouseWheelControlEnabled, old.ResetCursorOnOpen, old.leftClickEnabled)
                new.enabled3DAnimations = old.enabled3DAnimations
                new.fadingTime = old.fadingTime
            }
        }
        newMenu.CurrentSelection = newMenuCurrentSelection
        if (currentMenu instanceof UIMenu) {
            currentMenu.FadeOutMenu()
        }
        currentMenu.Visible = false;
        newMenu.Visible = true;
        if (newMenu instanceof UIMenu) {
            newMenu.FadeInItems();
        }
        BreadcrumbsHandler.Forward(newMenu, data);
        BreadcrumbsHandler.SwitchInProgress = false;
    }

    static ProcessMenus() {
        this.Draw();
        this.ProcessControl();
    }

    static ProcessControl() {
        if (this._currentMenu !== null) {
            this._currentMenu.processControl();
            this._currentMenu.processMouse();
        }

        if (this._currentPauseMenu !== null) {
            this._currentPauseMenu.processControl();
            this._currentPauseMenu.processMouse();
        }
    }

    static Draw() {
        if (this._currentMenu !== null) {
            this._currentMenu.draw();
        }
        if (this._currentPauseMenu !== null) {
            this._currentPauseMenu.draw();
        }
    }

    static CloseAndClearHistory() {
        this.ableToDraw = false;
        if (this._currentMenu !== null && this._currentMenu.Visible) {
            this._currentMenu.Visible = false
        }
        if (this._currentPauseMenu !== null && this._currentPauseMenu.Visible) {
            this._currentPauseMenu.Visible = false
        }
        BreadcrumbsHandler.Clear()
        //ScaleformUI.Scaleforms.InstructionalButtons:ClearButtonList() to be handled 🤔🤔
    }

    static get IsAnyMenuOpen(): boolean {
        return this._currentMenu != null && this._currentMenu.Visible || BreadcrumbsHandler.Count() > 0;
    }

    static IsAnyPauseMenuOpen(): boolean {
        return this._currentPauseMenu !== null && this._currentPauseMenu.Visible;
    }
}