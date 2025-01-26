import { BaseMenu } from "menus/menu.base";
import { PaginationHandler } from "./pagination-handler";
import { SColor } from "elements/scolor";
import { UIMenuItem } from "./items/uimenuitem";
import { MenuAnimationType, MenuBuildingAnimation } from "elements/animations";
import { MenuScrollingType } from "elements/scrolling-type";
import { ItemFont } from "elements/ItemFont";
import { ScaleformFonts } from "elements/scaleform-fonts";
import {
    IndexChangedEventBuilder,
    ListChangedEventBuilder,
    SliderChangedEventBuilder,
    ListSelectedEventBuilder,
    CheckboxChangeEventBuilder,
    ItemSelectEventBuilder,
    ItemActivatedEventBuilder,
    OnProgressChangedBuilder,
    OnProgressSelectedBuilder,
    StatItemProgressChangeBuilder,
    ColorPanelChangedEventBuilder,
    VehicleColorPickerSelectEventBuilder,
    PercentagePanelChangedEventBuilder,
    GridPanelChangedEventBuilder,
    MenuOpenedEventBuilder,
    MenuClosedEventBuilder,
    IndexChangedEvent,
    ListChangedEvent,
    ListSelectedEvent,
    CheckboxChangeEvent,
    ItemSelectEvent,
    OnProgressChanged,
    OnProgressSelected,
    ColorPanelChangedEvent,
    PercentagePanelChangedEvent,
    GridPanelChangedEvent,
    MenuOpenedEvent,
    MenuClosedEvent,
    StatItemProgressChange,
} from "./emitters/emitters";
import { Scaleform } from "scaleforms/scaleform";
import { Delay } from "helpers/loaders";
import { ScaleformUI } from "scaleforms/scaleformui/main";
import { BreadcrumbsHandler } from "menus/breadcrumbs-handler";
import { Controls } from "elements/controls";
import { UIMenuSeparatorItem } from "./items/uimenuseparatoritem";
import { UIMenuListItem } from "./items/uimenulistitem";
import { UIMenuSliderItem } from "./items/uimenuslideritem";
import { UIMenuProgressItem } from './items/uimenuprogressitem';
import { ScreenTools } from "math/screen-tools";
import { MenuHandler } from "menus/menu-handler";
import { Countdown } from '../../scaleforms/countdown/countdown';
import { ChangeDirection, UIMenuDynamicListItem } from "./items/uimenudynamiclistitem";
import { UIMenuStatsItem } from "./items/uimenustatsitem";
import { BadgeStyle } from "elements/badge";
import { UIMenuCheckboxItem } from "./items/uimenucheckboxitem";
import { UIMenuColorPanel, ColorPanelType } from './panels/uimenucolorpanel';
import { UIMenuPanel } from "./panels/uimenupanel";
import { UIMenuPercentagePanel } from "./panels/uimenupercentagepanel";
import { UIMenuGridPanel } from "./panels/uimenugridpanel";
import { StatisticsForPanel, UIMenuStatisticsPanel } from "./panels/uimenustatisticspanel";
import { UIMissionDetailsPanel } from "./sidepanels/DetailsPanel/uimissiondetailspanel";
import { UIFreemodeDetailsItem } from "./sidepanels/DetailsPanel/uifreemodedetailsitem";
import { UIVehicleColourPickerPanel } from "./sidepanels/ColorPicker/uivehiclecolourpickerpanel";
import { Vector2 } from "math/vector2";
import { UIMenuWindow } from "./windows/uimenuwindow";
import { UIMenuHeritageWindow } from "./windows/uimenuheritagewindow";
import { UIDetailStat, UIMenuDetailsWindow } from "./windows/uimenudetailswindow";
import { InstructionalButton } from "scaleforms/instructional-buttons/instructionalbutton";

export enum MenuControls {
    Up,
    Down,
    Left,
    Right,
    Select,
    Back
}

export class UIMenu extends BaseMenu {
    _visible: boolean = false;
    _justOpened: boolean = true;
    _itemsDirty: boolean = false;
    Pagination: PaginationHandler;
    _customTexture: [string, string];
    canPlayerCloseMenu: boolean = true;
    mouseWheelControlEnabled: boolean = true;
    menuSound: number = 0;
    _changed: boolean = true;
    keyboard: boolean = false;
    _menuGlare: Scaleform;
    isBuilding: boolean = false;
    title: string = "";
    subtitle: string = "";
    counterColor: SColor = SColor.HUD_Freemode;
    static readonly _selectTextLocalized: string = GetLabelText("HUD_INPUT2");
    static readonly _backTextLocalized: string = GetLabelText("HUD_INPUT3");
    readonly resolution: [number, number] = ScreenTools.ResolutionMaintainRatio();
    time: number = 0;
    times: number = 0;
    delay: number = 100;
    delayBeforeOverflow: number = 350;
    timeBeforeOverflow: number = 0;
    enabled3DAnimations: boolean = false;
    leftClickEnabled: boolean = false;
    public ResetCursorOnOpen: boolean = true;
    private mouseControlsEnabled: boolean = true;
    public AlternativeTitle: boolean = false;
    canBuild: boolean = true;
    isFading: boolean = false;
    fadingTime: number = 0.1;
    itemless: boolean = false;
    Windows: UIMenuWindow[] = [];
    Offset: Vector2;
    enableAnimation: boolean = false;
    animationType: MenuAnimationType = MenuAnimationType.BACK_INOUT;
    buildingAnimation: MenuBuildingAnimation = MenuBuildingAnimation.LEFT_RIGHT;
    descriptionFont: ItemFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY;
    MouseWheelControlsEnabled: boolean = true;

    public Glare: boolean;
    public AUDIO_LIBRARY: string = "HUD_FRONTEND_DEFAULT_SOUNDSET";
    public AUDIO_UPDOWN: string = "NAV_UP_DOWN";
    public AUDIO_LEFTRIGHT: string = "NAV_LEFT_RIGHT";
    public AUDIO_SELECT: string = "SELECT";
    public AUDIO_BACK: string = "BACK";
    public AUDIO_ERROR: string = "ERROR";
    public Items: UIMenuItem[] = [];
    public _unfilteredItems: UIMenuItem[] = [];
    public MouseEdgeEnabled: boolean = true;
    public ControlDisablingEnabled: boolean = true;

    _keyDictionary: Map<MenuControls, Array<number>> = new Map();


    public set MaxItemsOnScreen(value: number) {
        this.Pagination.ItemsPerPage = value;
    }
    public get MaxItemsOnScreen(): number {
        return this.Pagination.ItemsPerPage;
    }

    public set EnableAnimation(value: boolean) {
        this.enableAnimation = value;
        if (this.Visible) {
            ScaleformUI.Scaleforms._ui?.callFunction("ENABLE_SCROLLING_ANIMATION", this.enableAnimation);
        }
    }
    public get EnableAnimation(): boolean {
        return this.enableAnimation;
    }

    public set Enabled3DAnimations(value: boolean) {
        this.enabled3DAnimations = value;
        if (this.Visible) {
            ScaleformUI.Scaleforms._ui?.callFunction("ENABLE_3D_ANIMATIONS", this.enabled3DAnimations);
        }
    }
    public get Enabled3DAnimations(): boolean {
        return this.enabled3DAnimations;
    }

    public set AnimationType(value: MenuAnimationType) {
        this.animationType = value;
        if (this.Visible) {
            ScaleformUI.Scaleforms._ui?.callFunction("CHANGE_SCROLLING_ANIMATION_TYPE", this.animationType);
        }
    }
    public get AnimationType(): MenuAnimationType {
        return this.animationType;
    }

    public set BuildingAnimation(value: MenuBuildingAnimation) {
        this.buildingAnimation = value;
        if (this.Visible) {
            ScaleformUI.Scaleforms._ui?.callFunction("CHANGE_BUILDING_ANIMATION_TYPE", this.buildingAnimation);
        }
    }
    public get BuildingAnimation(): MenuBuildingAnimation {
        return this.buildingAnimation;
    }

    public set ScrollingType(value: MenuScrollingType) {
        this.Pagination.scrollType = value;
    }
    public get ScrollingType(): MenuScrollingType {
        return this.Pagination.scrollType;
    }

    public set MouseWheelControlEnabled(value: boolean) {
        this.mouseWheelControlEnabled = value;
    }
    public get MouseWheelControlEnabled(): boolean {
        return this.mouseWheelControlEnabled;
    }

    public set DescriptionFont(font: ItemFont) {
        this.descriptionFont = font;
        if (this.Visible) {
            ScaleformUI.Scaleforms._ui?.callFunction("SET_DESC_FONT", this.descriptionFont.fontName, this.descriptionFont.fontId);
        }
    }
    public get DescriptionFont(): ItemFont {
        return this.descriptionFont;
    }

    public set MouseControlsEnabled(value: boolean) {
        this.mouseControlsEnabled = value;
        if (this.Visible) {
            ScaleformUI.Scaleforms._ui?.callFunction("ENABLE_MOUSE", value);
        }
    }
    public get MouseControlsEnabled(): boolean {
        return this.mouseControlsEnabled;
    }

    _IndexChanged: IndexChangedEventBuilder = new IndexChangedEventBuilder();
    _ListChanged: ListChangedEventBuilder = new ListChangedEventBuilder();
    _ListSelected: ListSelectedEventBuilder = new ListSelectedEventBuilder();
    _CheckboxChanged: CheckboxChangeEventBuilder = new CheckboxChangeEventBuilder();
    _ItemSelected: ItemSelectEventBuilder = new ItemSelectEventBuilder();
    _OnProgressChanged: OnProgressChangedBuilder = new OnProgressChangedBuilder();
    _OnProgressSelected: OnProgressSelectedBuilder = new OnProgressSelectedBuilder();
    _ColorPanelChanged: ColorPanelChangedEventBuilder = new ColorPanelChangedEventBuilder();
    _PercentagePanelChanged: PercentagePanelChangedEventBuilder = new PercentagePanelChangedEventBuilder();
    _GridPanelChanged: GridPanelChangedEventBuilder = new GridPanelChangedEventBuilder();
    _MenuOpened: MenuOpenedEventBuilder = new MenuOpenedEventBuilder();
    _MenuClosed: MenuClosedEventBuilder = new MenuClosedEventBuilder();
    _StatItemProgressChange: StatItemProgressChangeBuilder = new StatItemProgressChangeBuilder();
    _SliderChange: SliderChangedEventBuilder = new SliderChangedEventBuilder();

    public onIndexChange(delegate: IndexChangedEvent) {
        this._IndexChanged.add(delegate);
    }

    public onListChange(delegate: ListChangedEvent) {
        this._ListChanged.add(delegate);
    }

    public onListSelect(delegate: ListSelectedEvent) {
        this._ListSelected.add(delegate);
    }

    public onCheckboxChange(delegate: CheckboxChangeEvent) {
        this._CheckboxChanged.add(delegate);
    }

    public onItemSelect(delegate: ItemSelectEvent) {
        this._ItemSelected.add(delegate);
    }

    public onProgressChange(delegate: OnProgressChanged) {
        this._OnProgressChanged.add(delegate);
    }

    public onProgressSelect(delegate: OnProgressSelected) {
        this._OnProgressSelected.add(delegate);
    }

    public onColorPanelChange(delegate: ColorPanelChangedEvent) {
        this._ColorPanelChanged.add(delegate);
    }

    public onPercentagePanelChange(delegate: PercentagePanelChangedEvent) {
        this._PercentagePanelChanged.add(delegate);
    }

    public onGridPanelChange(delegate: GridPanelChangedEvent) {
        this._GridPanelChanged.add(delegate);
    }

    public onMenuOpen(delegate: MenuOpenedEvent) {
        this._MenuOpened.add(delegate);
    }

    public onMenuClose(delegate: MenuClosedEvent) {
        this._MenuClosed.add(delegate);
    }

    public onStatsItemChanged(delegate: StatItemProgressChange) {
        this._StatItemProgressChange.add(delegate);
    }

    constructor(title: string, subtitle: string, offset: Vector2, spriteLibrary: string, spriteName: string, glare: boolean = false, alternativeTitle: boolean = false, fadingTime: number = 0.1, longdesc: string) {
        super();
        this._customTexture = [spriteLibrary, spriteName];
        this.Offset = offset;
        this.Glare = glare;
        this._menuGlare = Scaleform.requestWideScreen("mp_menu_glare");
        this.Title = title;
        this.Subtitle = subtitle;
        this.AlternativeTitle = alternativeTitle;
        this.MouseWheelControlsEnabled = true;
        this.Pagination = new PaginationHandler();
        this.Pagination.ItemsPerPage = 7;
        this.fadingTime = fadingTime;
        this.instructionalButtons = [
            new InstructionalButton(UIMenu._selectTextLocalized, -1, 176, 176, -1),
            new InstructionalButton(UIMenu._backTextLocalized, -1, 177, 177, -1)
        ];
        if (!isNullOrWhiteSpace(longdesc)) {
            AddTextEntry("ScaleformUILongDesc", longdesc)
            this.itemless = true;
        }
    }

    public SetKeyControl(control: MenuControls, controlIndex: number) {
        if (this._keyDictionary.has(control)) {
            (this._keyDictionary.get(control) as Array<number>).push(controlIndex);
        } else {
            this._keyDictionary.set(control, [controlIndex]);
        }
    }

    public SetKey(control: MenuControls) {
        this.SetKeyControl(control, 0);
        this.SetKeyControl(control, 1);
        this.SetKeyControl(control, 2);
    }

    public ResetKey(control: MenuControls) {
        if (this._keyDictionary.has(control)) {
            (this._keyDictionary.get(control) as Array<number>).length = 0;
        }
    }

    public HasControlJustBeenPressed(control: MenuControls): boolean {
        let tmpControls: Array<number> = [...(this._keyDictionary.get(control) as Array<number>)];
        return tmpControls.some(index => IsControlJustPressed(index, control));
    }

    public HasControlJustBeenReleased(control: MenuControls): boolean {
        let tmpControls: Array<number> = [...(this._keyDictionary.get(control) as Array<number>)];
        return tmpControls.some(index => IsControlJustReleased(index, control));
    }

    private _controlCounter: number = 0;
    public IsControlBeingPressed(control: MenuControls): boolean {
        let tmpControls: Array<number> = [...(this._keyDictionary.get(control) as Array<number>)];
        if (this.HasControlJustBeenReleased(control)) this._controlCounter = 0;
        return tmpControls.some(index => IsControlPressed(index, control));
    }

    public async fadeInMenu() {
        ScaleformUI.Scaleforms._ui?.callFunction("FADE_IN_MENU")
        do {
            await Delay(0)
            this.isFading = await ScaleformUI.Scaleforms._ui?.callFunctionReturnBool("GET_IS_FADING");
        } while (this.isFading)
    }
    public async fadeOutMenu() {
        ScaleformUI.Scaleforms._ui?.callFunction("FADE_OUT_MENU")
        do {
            await Delay(0)
            this.isFading = await ScaleformUI.Scaleforms._ui?.callFunctionReturnBool("GET_IS_FADING");
        } while (this.isFading)
    }
    public async fadeOutItems() {
        ScaleformUI.Scaleforms._ui?.callFunction("FADE_OUT_ITEMS")
        do {
            await Delay(0)
            this.isFading = await ScaleformUI.Scaleforms._ui?.callFunctionReturnBool("GET_IS_FADING");
        } while (this.isFading)
    }
    public async fadeInItems() {
        ScaleformUI.Scaleforms._ui?.callFunction("FADE_IN_ITEMS")
        do {
            await Delay(0)
            this.isFading = await ScaleformUI.Scaleforms._ui?.callFunctionReturnBool("GET_IS_FADING");
        } while (this.isFading)
    }

    public AddInstructionalButton(button: InstructionalButton) {
        this.instructionalButtons.push(button);
        if (this.Visible && !(ScaleformUI.Scaleforms.Warning.IsShowing || ScaleformUI.Scaleforms.Warning.IsShowingWithButtons))
            ScaleformUI.Scaleforms.InstructionalButtons.SetInstructionalButtons(this.instructionalButtons);
    }

    public RemoveInstructionalButton(button: InstructionalButton) {
        this.RemoveInstructionalButtonAt(this.instructionalButtons.indexOf(button));
    }

    public RemoveInstructionalButtonAt(index: number) {
        if (this.instructionalButtons.length >= index) {
            this.instructionalButtons.splice(index, 1);
            if (this.Visible && !(ScaleformUI.Scaleforms.Warning.IsShowing || ScaleformUI.Scaleforms.Warning.IsShowingWithButtons))
                ScaleformUI.Scaleforms.InstructionalButtons.SetInstructionalButtons(this.instructionalButtons);
        }
    }

    public AddItem(item: UIMenuItem) {
        if (!this.itemless) {
            let selectedItem = this.CurrentSelection;
            item.Parent = this;
            this.Items.push(item);
            if (this.Visible) {
                this.CurrentSelection = selectedItem;
            }
            this.Pagination.TotalItems = this.Items.length;
        } else {
            throw new Error("ScaleformUI - You cannot add items to an itemless menu, only a long description");
        }
    }

    public AddWindow(window: UIMenuWindow) {
        if (!this.itemless) {
            window.ParentMenu = this;
            this.Windows.push(window);
        } else {
            throw new Error("ScaleformUI - You cannot add windows to an itemless menu, only a long description");
        }
    }

    public RemoveWindow(window: UIMenuWindow) {
        this.RemoveWindowAt(this.Windows.indexOf(window));
    }

    public RemoveWindowAt(index: number) {
        if (this.Windows.length >= index) {
            this.Windows.splice(index, 1);
        }
    }

    public UpdateDescription() {
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._ui?.handle, "UPDATE_ITEM_DESCRIPTION");
        ScaleformMovieMethodAddParamInt(this.Pagination.GetScaleformIndex(this.CurrentSelection));
        BeginTextCommandScaleformString(`menu_${BreadcrumbsHandler.CurrentDepth}_desc_${this.CurrentSelection}`);
        EndTextCommandScaleformString_2();
        EndScaleformMovieMethod();
    }

    public RemoveItemAt(index: number) {
        let selectedItem = this.CurrentSelection;
        this.Items.splice(index, 1);
        if (this.Visible) {
            ScaleformUI.Scaleforms._ui?.callFunction("REMOVE_ITEM", index);
        }
        this.Pagination.TotalItems = this.Items.length;
        this.CurrentSelection = selectedItem;
    }

    public RemoveItem(item: UIMenuItem) {
        this.RemoveItemAt(this.Items.indexOf(item));
    }

    public Clear() {
        ScaleformUI.Scaleforms._ui?.callFunction("CLEAR_ITEMS");
        this.Items.length = 0;
        this.Pagination.Reset();
    }

    public async GoBack(playSound: boolean = true) {
        if (this.CanPlayerCloseMenu) {
            if (playSound) {
                PlaySoundFrontend(-1, this.AUDIO_BACK, this.AUDIO_LIBRARY, true);
            }
            await this.fadeOutMenu();
            if (BreadcrumbsHandler.CurrentDepth == 0) {
                this.Visible = false;
                BreadcrumbsHandler.Clear();
                ScaleformUI.Scaleforms.InstructionalButtons.ClearButtonList();
            } else {
                BreadcrumbsHandler.SwitchInProgress = true;
                let prevMenu = null;
                if (BreadcrumbsHandler.CurrentDepth > 0) {
                    prevMenu = BreadcrumbsHandler.PreviousMenu;
                    if (prevMenu instanceof UIMenu) {
                        let uimenu = prevMenu as UIMenu;
                        if (uimenu.Items.length == 0) {
                            MenuHandler.CloseAndClearHistory();
                            throw new Error(`UIMenu ${this.Title} previous menu is empty... Closing and clearing history.`);
                        }
                    }
                    BreadcrumbsHandler.Backwards();
                }
                this.Visible = false;
                if (prevMenu != null)
                    prevMenu.Visible = true;
                BreadcrumbsHandler.SwitchInProgress = false;
            }
        }
    }

    public async GoUp() {
        if (this.isBuilding) return;
        this.Items[this.CurrentSelection].Selected = false;
        do {
            await Delay(0);
            let overflow = this.CurrentSelection == 0 && this.Pagination.TotalPages > 1;
            if (this.Pagination.GoUp()) {
                if (this.ScrollingType == MenuScrollingType.ENDLESS || (this.ScrollingType == MenuScrollingType.CLASSIC && !overflow)) {
                    this._itemCreation(this.Pagination.GetPage(this.CurrentSelection), this.Pagination.CurrentPageIndex, true);
                    ScaleformUI.Scaleforms._ui?.callFunction("SET_INPUT_EVENT", 8, this.delay);
                }
                else if (this.ScrollingType == MenuScrollingType.PAGINATED || (this.ScrollingType == MenuScrollingType.CLASSIC && overflow)) {
                    this.isBuilding = true;
                    await this.fadeOutItems();
                    this.isFading = true;
                    ScaleformUI.Scaleforms._ui?.callFunction("CLEAR_ITEMS");
                    let max = this.Pagination.ItemsPerPage;
                    for (let i = 0; i < max; i++) {
                        if (!this.Visible) return;
                        this._itemCreation(this.Pagination.CurrentPage, i, false, true);
                    }
                    this.isBuilding = false;
                }
            }
        }
        while (this.Items[this.CurrentSelection] instanceof UIMenuSeparatorItem && (this.Items[this.CurrentSelection] as UIMenuSeparatorItem).Jumpable);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_CURRENT_ITEM", this.Pagination.ScaleformIndex);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_COUNTER_QTTY", this.CurrentSelection + 1, this.Items.length);
        this.Items[this.CurrentSelection].Selected = true;
        if (this.isFading)
            await this.fadeInItems();
        this.IndexChange(this.CurrentSelection);
    }

    public async GoDown() {
        if (this.isBuilding) return;
        this.Items[this.CurrentSelection].Selected = false;
        do {
            await Delay(0);
            let overflow = this.CurrentSelection == 0 && this.Pagination.TotalPages > 1;
            if (this.Pagination.GoDown()) {
                if (this.ScrollingType == MenuScrollingType.ENDLESS || (this.ScrollingType == MenuScrollingType.CLASSIC && !overflow)) {
                    this._itemCreation(this.Pagination.GetPage(this.CurrentSelection), this.Pagination.CurrentPageIndex, true);
                    ScaleformUI.Scaleforms._ui?.callFunction("SET_INPUT_EVENT", 9, this.delay);
                }
                else if (this.ScrollingType == MenuScrollingType.PAGINATED || (this.ScrollingType == MenuScrollingType.CLASSIC && overflow)) {
                    this.isBuilding = true;
                    await this.fadeOutItems();
                    this.isFading = true;
                    ScaleformUI.Scaleforms._ui?.callFunction("CLEAR_ITEMS");
                    let max = this.Pagination.ItemsPerPage;
                    for (let i = 0; i < max; i++) {
                        if (!this.Visible) return;
                        this._itemCreation(this.Pagination.CurrentPage, i, false, true);
                    }
                    this.isBuilding = false;
                }
            }
        }
        while (this.Items[this.CurrentSelection] instanceof UIMenuSeparatorItem && (this.Items[this.CurrentSelection] as UIMenuSeparatorItem).Jumpable);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_CURRENT_ITEM", this.Pagination.ScaleformIndex);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_COUNTER_QTTY", this.CurrentSelection + 1, this.Items.length);
        this.Items[this.CurrentSelection].Selected = true;
        if (this.isFading)
            await this.fadeInItems();
        this.IndexChange(this.CurrentSelection);
    }

    public async GoLeft() {
        if (!this.CurrentItem.Enabled) {
            PlaySoundFrontend(-1, this.AUDIO_ERROR, this.AUDIO_LIBRARY, true);
            return;
        }
        let res = await ScaleformUI.Scaleforms._ui?.callFunctionReturnInt("SET_INPUT_EVENT", 10);
        switch (true) {
            case this.CurrentItem instanceof UIMenuListItem:
                {
                    let it = this.CurrentItem as UIMenuListItem;
                    it.Index = res;
                    this.ListChange(it, it.Index);
                    it.listChangedEmit();
                    break;
                }
            case this.CurrentItem instanceof UIMenuDynamicListItem:
                {
                    let it = this.CurrentItem as UIMenuDynamicListItem;
                    let newItem = await it.callback.toDelegate()(it, ChangeDirection.Left);
                    it.CurrentListItem = newItem;
                    break;
                }
            case this.CurrentItem instanceof UIMenuSliderItem:
                {
                    let it = this.CurrentItem as UIMenuSliderItem;
                    it.Value = res;
                    this.SliderChange(it, it.Value);
                    break;
                }
            case this.CurrentItem instanceof UIMenuProgressItem:
                {
                    let it = this.CurrentItem as UIMenuProgressItem;
                    it.Value = res;
                    this.ProgressChange(it, it.Value);
                    break;
                }
            case this.CurrentItem instanceof UIMenuStatsItem:
                {
                    let it = this.CurrentItem as UIMenuStatsItem;
                    it.Value = res;
                    this.StatItemChange(it, it.Value);
                    break;
                }
        }
    }

    public async GoRight() {
        if (!this.CurrentItem.Enabled) {
            PlaySoundFrontend(-1, this.AUDIO_ERROR, this.AUDIO_LIBRARY, true);
            return;
        }
        let res = await ScaleformUI.Scaleforms._ui?.callFunctionReturnInt("SET_INPUT_EVENT", 11);
        switch (true) {
            case this.CurrentItem instanceof UIMenuListItem:
                {
                    let it = this.CurrentItem as UIMenuListItem;
                    it.Index = res;
                    this.ListChange(it, it.Index);
                    it.listChangedEmit();
                    break;
                }
            case this.CurrentItem instanceof UIMenuDynamicListItem:
                {
                    let it = this.CurrentItem as UIMenuDynamicListItem;
                    let newItem = await it.callback.toDelegate()(it, ChangeDirection.Left);
                    it.CurrentListItem = newItem;
                    break;
                }
            case this.CurrentItem instanceof UIMenuSliderItem:
                {
                    let it = this.CurrentItem as UIMenuSliderItem;
                    it.Value = res;
                    this.SliderChange(it, it.Value);
                    break;
                }
            case this.CurrentItem instanceof UIMenuProgressItem:
                {
                    let it = this.CurrentItem as UIMenuProgressItem;
                    it.Value = res;
                    this.ProgressChange(it, it.Value);
                    break;
                }
            case this.CurrentItem instanceof UIMenuStatsItem:
                {
                    let it = this.CurrentItem as UIMenuStatsItem;
                    it.Value = res;
                    this.StatItemChange(it, it.Value);
                    break;
                }
        }
    }

    public Select(playSound: boolean) {
        if (!this.CurrentItem.Enabled) {
            PlaySoundFrontend(-1, this.AUDIO_ERROR, this.AUDIO_LIBRARY, true);
            return;
        }

        if (playSound) PlaySoundFrontend(-1, this.AUDIO_SELECT, this.AUDIO_LIBRARY, true);

        switch (true) {
            case this.CurrentItem instanceof UIMenuCheckboxItem:
                {
                    let it = this.CurrentItem as UIMenuCheckboxItem;
                    it.Checked = !it.Checked;
                    this.CheckboxChange(it, it.Checked);
                    it.checkEmit();
                    break;
                }

            case this.CurrentItem instanceof UIMenuListItem:
                {
                    let it = this.CurrentItem as UIMenuListItem;
                    this.ListSelect(it, it.Index);
                    it.listSelectedEmit();
                    break;
                }

            default:
                this.ItemSelect(this.CurrentItem, this.CurrentSelection);
                this.CurrentItem.activatedEmit();
                break;
        }
    }


    cursorPressed: boolean = false;
    async processMouse() {
        if (!this.Visible || this._justOpened || this.Items.length == 0 || !IsUsingKeyboard(2) || !this.MouseControlsEnabled) {
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 1, true)
            EnableControlAction(1, 2, true)
            EnableControlAction(1, 1, true)
            EnableControlAction(2, 2, true)
            EnableControlAction(2, 1, true)
            if (this._itemsDirty) {
                this.Items.forEach(x => {
                    x.Hovered = false
                });
            }
            return;
        }

        SetMouseCursorActiveThisFrame();
        SetInputExclusive(2, 239);
        SetInputExclusive(2, 240);
        SetInputExclusive(2, 237);
        SetInputExclusive(2, 238);

        let [success, eventType, itemId, context, unused] = GetScaleformMovieCursorSelection(ScaleformUI.Scaleforms._ui?.handle)
        if (success && !this.isBuilding) {
            switch (eventType) {
                case 5:
                    switch (context) {
                        case 0:
                            let item = this.Items[itemId];
                            if ((item instanceof UIMenuSeparatorItem && (item as UIMenuSeparatorItem).Jumpable) || !this.Items[itemId].Enabled) {
                                PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                                return;
                            }
                            if (item.Selected) {
                                switch (item._itemId) {
                                    case 0:
                                    case 2:
                                        this.Select(false);
                                        break;
                                    case 1:
                                    case 3:
                                    case 4:
                                        let value = await ScaleformUI.Scaleforms._ui?.callFunctionReturnInt("SELECT_ITEM", this.Pagination.GetScaleformIndex(this.CurrentSelection));
                                        switch (true) {
                                            case this.Items[this.CurrentSelection] instanceof UIMenuListItem: {
                                                let it = this.Items[this.CurrentSelection] as UIMenuListItem;
                                                if (it.Index != value) {
                                                    it.Index = value;
                                                    this.ListChange(it, it.Index);
                                                    it.listChangedEmit();
                                                } else {
                                                    it.listSelectedEmit();
                                                    it.activatedEmit();
                                                    this.ListSelect(it, value);
                                                }
                                                break;
                                            }
                                            case this.Items[this.CurrentSelection] instanceof UIMenuSliderItem: {
                                                let it = this.Items[this.CurrentSelection] as UIMenuSliderItem;
                                                if (it.Value != value) {
                                                    it.Value = value;
                                                    it.sliderChanged(it.Value);
                                                    this.SliderChange(it, it.Value);
                                                } else {
                                                    it.activatedEmit();
                                                    this.ItemSelect(it, this.CurrentSelection);
                                                }
                                                break;
                                            }
                                            case this.Items[this.CurrentSelection] instanceof UIMenuProgressItem: {
                                                let it = this.Items[this.CurrentSelection] as UIMenuProgressItem;
                                                if (it.Value != value) {
                                                    it.Value = value;
                                                    it.progressChanged(it.Value);
                                                    this.ProgressChange(it, it.Value);
                                                } else {
                                                    it.activatedEmit();
                                                    this.ItemSelect(it, this.CurrentSelection);
                                                }
                                                break;
                                            }
                                        }
                                        break;
                                }
                            }
                            return;
                    }
                    this.CurrentSelection = itemId;
                    ScaleformUI.Scaleforms._ui?.callFunction("SET_COUNTER_QTTY", this.CurrentSelection + 1, this.Items.length);
                    PlaySoundFrontend(-1, this.AUDIO_SELECT, this.AUDIO_LIBRARY, true)
                    break;
                case 10: {
                    let res = await ScaleformUI.Scaleforms._ui?.callFunctionReturnString("SELECT_PANEL", this.Pagination.GetScaleformIndex(this.CurrentSelection));
                    let split = res?.split(",");
                    let panel = this.Items[this.CurrentSelection].Panels[Number(split[0])] as UIMenuColorPanel
                    panel._value = Number(split[1]);
                    this.ColorPanelChange(panel.ParentItem, panel, panel.CurrentSelection);
                    panel.PanelChanged();
                }
                    break;
                case 11: // panels (11 => context 1, panel_type 1) // PercentagePanel
                    this.cursorPressed = true;
                    break;
                case 12: // panels (12 => context 1, panel_type 2) // GridPanel
                    this.cursorPressed = true;
                    break;
                case 2: {
                    let panel = this.Items[this.CurrentSelection].SidePanel as UIVehicleColourPickerPanel;
                    if (itemId != -1) {
                        panel._value = itemId;
                        panel.PickerSelect();
                        PlaySoundFrontend(-1, this.AUDIO_SELECT, this.AUDIO_LIBRARY, true)
                    }
                }
                    break;
                case 6: // on click released
                    this.cursorPressed = false;
                    break;
                case 7: // on click released ouside
                    this.cursorPressed = false;
                    SetMouseCursorSprite(1);
                    break;
                case 8: // on not hover
                    this.cursorPressed = false;
                    if (context == 0) {
                        this.Items[itemId].Hovered = false;
                    }
                    SetMouseCursorSprite(1);
                    break;
                case 9: // on hovered
                    if (context == 0) {
                        this.Items[itemId].Hovered = true;
                    }
                    SetMouseCursorSprite(5);
                    break;
                case 0: // dragged outside
                    this.cursorPressed = false;
                    break;
                case 1: // dragged inside
                    this.cursorPressed = true;
                    break;

            }
        }
        if (this.cursorPressed) {
            if (HasSoundFinished(this.menuSound)) {
                this.menuSound = GetSoundId();
                PlaySoundFrontend(this.menuSound, "CONTINUOUS_SLIDER", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
            }
            let res: string = await ScaleformUI.Scaleforms._ui?.callFunctionReturnString("SET_INPUT_MOUSE_EVENT_CONTINUE");
            let split = res.split(',');
            let selection = Number(split[0]);
            let panel: UIMenuPanel = this.Items[this.CurrentSelection].Panels[selection];
            switch (true) {
                case panel instanceof UIMenuGridPanel:
                    let grid = panel as UIMenuGridPanel;
                    grid._value = new Vector2(Number(split[1]), Number(split[2]));
                    this.GridPanelChange(panel.ParentItem, grid, grid.CirclePosition)
                    break;
                case panel instanceof UIMenuPercentagePanel:
                    let perc = panel as UIMenuPercentagePanel;
                    perc._value = Number(split[1]);
                    this.PercentagePanelChange(panel.ParentItem, perc, perc.Percentage)
                    perc.PercentagePanelChange();
                    break;
            }
        } else {
            if (!HasSoundFinished(this.menuSound)) {
                await Delay(1);
                StopSound(this.menuSound);
                ReleaseSoundId(this.menuSound)
            }
        }

        if (this.MouseEdgeEnabled) {
            let mouseVariance = GetDisabledControlNormal(2, 239);
            if (ScreenTools.IsMouseInBounds(0, 0, 30, 1080)) {
                if (mouseVariance < (0.05 * 0.75)) {
                    let mouseSpeed = 0.05 - (1 - mouseVariance);
                    if (mouseSpeed > 0.05) {
                        mouseSpeed = 0.05;
                    }
                    SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + (70 * mouseSpeed))
                    SetMouseCursorSprite(6);
                }
            } else if (ScreenTools.IsMouseInBounds(1920 - 30, 0, 30, 1080)) {
                if (mouseVariance > (1 - (0.05 * 0.75))) {
                    let mouseSpeed = 0.05 - (1 - mouseVariance)
                    if (mouseSpeed > 0.05) {
                        mouseSpeed = 0.05
                    }
                    SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + (70 * mouseSpeed))
                    SetMouseCursorSprite(7);
                }
            } else {
                SetMouseCursorSprite(1);
            }
        } else {
            SetMouseCursorSprite(1);
        }
    }

    processControl() {
        if (!this._visible) return;
        if (this._justOpened) {
            this._justOpened = false;
            return;
        }

        if (UpdateOnscreenKeyboard() == 0 || IsWarningMessageActive() || ScaleformUI.Scaleforms.Warning.isShowing || BreadcrumbsHandler.SwitchInProgress || this.isFading) {
            return;
        }

        if (this.HasControlJustBeenReleased(MenuControls.Back)) {
            this.GoBack();
        }

        if (this.isBuilding || this.Items.length == 0) {
            return;
        }

        if (this.HasControlJustBeenPressed(MenuControls.Up)) {
            this.GoUp();
            this.timeBeforeOverflow = GetGameTimer();
        } else if (this.IsControlBeingPressed(MenuControls.Up) && GetGameTimer() - this.timeBeforeOverflow > this.delayBeforeOverflow) {
            if (GetGameTimer() - this.time > this.delay) {
                this.buttonDelay();
                this.GoUp();
            }
        }

        if (this.HasControlJustBeenPressed(MenuControls.Down)) {
            this.GoDown();
            this.timeBeforeOverflow = GetGameTimer();
        } else if (this.IsControlBeingPressed(MenuControls.Down) && GetGameTimer() - this.timeBeforeOverflow > this.delayBeforeOverflow) {
            if (GetGameTimer() - this.time > this.delay) {
                this.buttonDelay();
                this.GoDown();
            }
        }

        if (this.HasControlJustBeenPressed(MenuControls.Left)) {
            this.GoLeft();
            this.timeBeforeOverflow = GetGameTimer();
        } else if (this.IsControlBeingPressed(MenuControls.Left) && GetGameTimer() - this.timeBeforeOverflow > this.delayBeforeOverflow) {
            if (GetGameTimer() - this.time > this.delay) {
                this.buttonDelay();
                this.GoLeft();
            }
        }

        if (this.HasControlJustBeenPressed(MenuControls.Right)) {
            this.GoRight();
            this.timeBeforeOverflow = GetGameTimer();
        } else if (this.IsControlBeingPressed(MenuControls.Right) && GetGameTimer() - this.timeBeforeOverflow > this.delayBeforeOverflow) {
            if (GetGameTimer() - this.time > this.delay) {
                this.buttonDelay();
                this.GoRight();
            }
        }

        if (this.HasControlJustBeenPressed(MenuControls.Select)) {
            this.Select(true)
        }

        if (this.HasControlJustBeenReleased(MenuControls.Up) || this.HasControlJustBeenReleased(MenuControls.Down) || this.HasControlJustBeenReleased(MenuControls.Left) || this.HasControlJustBeenReleased(MenuControls.Right)) {
            this.times = 0;
            this.delay = 100;
        }
    }

    private buttonDelay() {
        // Increment the "changed indexes" counter
        this.times++;

        // Each time "times" is a multiple of 5 we decrease the delay.
        // Min delay for the scaleform is 50.. less won't change due to the
        // awaiting time for the scaleform itself.
        if (this.times % 5 == 0) {
            this.delay -= 10;
            if (this.delay < 50) this.delay = 50;
        }
        // Reset the time to the current game timer.
        this.time = GetGameTimer();
    }

    public override async draw() {
        if (!this.Visible || ScaleformUI.Scaleforms.Warning.IsShowing)
            return;
        while (!ScaleformUI.Scaleforms._ui?.isLoaded)
            await Delay(0);
        HideHudComponentThisFrame(19);
        Controls.toggleAll(!this.ControlDisablingEnabled);
        ScaleformUI.Scaleforms._ui?.render2d();
        if (this.Glare) {
            this._menuGlare.callFunction("SET_DATA_SLOT", GetGameplayCamRelativeHeading());
            let x = (this.Offset.x / 1280) + 0.4499;
            let y = (this.Offset.y / 720) + 0.449;

            DrawScaleformMovie(this._menuGlare.handle, x, y, 1.0, 1.0, 255, 255, 255, 255, 0);
        }

        if (!IsUsingKeyboard(2)) {
            if (this.keyboard) {
                this.keyboard = false;
                this._changed = true;
            }
        }
        else {
            if (!this.keyboard) {
                this.keyboard = true;
                this._changed = true;
            }
        }
        if (this._changed) {
            this.UpdateDescription();
            this._changed = false;
        }
    }

    public set Visible(value: boolean) {
        this._visible = value;
        this._justOpened = value;
        this._itemsDirty = value;
        if (value) {
            if (!this.itemless && this.Items.length == 0) {
                MenuHandler.CloseAndClearHistory();
                throw new Error(`UIMenu ${this.Title} menu is empty... Closing and clearing history.`);
            }

            ScaleformUI.Scaleforms.InstructionalButtons.SetInstructionalButtons(this.instructionalButtons);
            this.canBuild = true;
            MenuHandler._currentMenu = this;
            MenuHandler.ableToDraw = true;
            this.buildUpMenuAsync();
            this.MenuOpenEv(this, null);
            this.timeBeforeOverflow = GetGameTimer();
            if (BreadcrumbsHandler.Count == 0)
                BreadcrumbsHandler.Forward(this, null);
        }
        else {
            ScaleformUI.Scaleforms.InstructionalButtons.ClearButtonList();
            this.canBuild = false;
            this.MenuCloseEv(this);
            MenuHandler.ableToDraw = false;
            MenuHandler._currentMenu = null;
            this._unfilteredItems.length = 0;
            ScaleformUI.Scaleforms._ui?.callFunction("CLEAR_ALL");
        }
        if (!value) return;
        if (!this.ResetCursorOnOpen) return;
        SetCursorLocation(0.5, 0.5);
        SetCursorSprite(1);
    }

    private async buildUpMenuAsync(itemsOnly: boolean = false) {
        this.isBuilding = true;
        let _animEnabled = this.EnableAnimation;
        if (this.itemless) {
            this.EnableAnimation = false;
            while (!ScaleformUI.Scaleforms._ui?.isLoaded) { await Delay(0); }
            BeginScaleformMovieMethod(ScaleformUI.Scaleforms._ui?.handle, "CREATE_MENU");
            PushScaleformMovieMethodParameterString(this.Title);
            PushScaleformMovieMethodParameterString(this.Subtitle);
            PushScaleformMovieMethodParameterFloat(this.Offset.x);
            PushScaleformMovieMethodParameterFloat(this.Offset.y);
            PushScaleformMovieMethodParameterBool(this.AlternativeTitle);
            PushScaleformMovieMethodParameterString(this._customTexture[0]);
            PushScaleformMovieMethodParameterString(this._customTexture[1]);
            PushScaleformMovieFunctionParameterInt(this.MaxItemsOnScreen);
            PushScaleformMovieFunctionParameterInt(this.Items.length);
            PushScaleformMovieFunctionParameterBool(this.EnableAnimation);
            PushScaleformMovieFunctionParameterInt(this.AnimationType);
            PushScaleformMovieFunctionParameterInt(this.buildingAnimation);
            PushScaleformMovieFunctionParameterInt(this.counterColor.toArgb());
            PushScaleformMovieMethodParameterString(this.descriptionFont.fontName);
            PushScaleformMovieFunctionParameterInt(this.descriptionFont.fontId);
            PushScaleformMovieMethodParameterFloat(this.fadingTime);
            PushScaleformMovieFunctionParameterBool(true);
            BeginTextCommandScaleformString("ScaleformUILongDesc");
            EndTextCommandScaleformString_2();
            EndScaleformMovieMethod();
            await this.fadeInMenu();
            this.isBuilding = false;
            return;
        }
        if (!itemsOnly) {
            this.EnableAnimation = false;
            while (!ScaleformUI.Scaleforms._ui?.isLoaded) { await Delay(0); }
            ScaleformUI.Scaleforms._ui?.callFunction("CREATE_MENU",
                this.Title, this.Subtitle, this.Offset.x, this.Offset.y,
                this.AlternativeTitle, this._customTexture[0], this._customTexture[1],
                this.MaxItemsOnScreen, this.Items.length, this.EnableAnimation,
                this.AnimationType, this.buildingAnimation, this.counterColor.toArgb(),
                this.descriptionFont.fontName, this.descriptionFont.fontId, this.fadingTime, false);

            if (this.Windows.length > 0) {
                this.Windows.forEach((wind: UIMenuWindow) => {
                    if (wind instanceof UIMenuHeritageWindow) {
                        let her = wind as UIMenuHeritageWindow;
                        ScaleformUI.Scaleforms._ui?.callFunction("ADD_WINDOW", her.id, her.Mom, her.Dad);
                    } else if (wind instanceof UIMenuDetailsWindow) {
                        let det = wind as UIMenuDetailsWindow;
                        ScaleformUI.Scaleforms._ui?.callFunction("ADD_WINDOW", det.id, det.DetailBottom, det.DetailMid, det.DetailTop, det.DetailLeft.Txd, det.DetailLeft.Txn, det.DetailLeft.Pos.x, det.DetailLeft.Pos.y, det.DetailLeft.Size.x, det.DetailLeft.Size.y);
                        if (det.StatWheelEnabled) {
                            det.DetailStats.forEach((stat: UIDetailStat) => {
                                ScaleformUI.Scaleforms._ui?.callFunction("ADD_STATS_DETAILS_WINDOW_STATWHEEL", this.Windows.indexOf(det), stat.Percentage, stat.HudColor);
                            });
                        }
                    }
                });
            }

            let timer = GetGameTimer();
            if (this.Items.length == 0) {
                while (this.Items.length == 0) {
                    await Delay(0)
                    if (GetGameTimer() - timer > 150) {
                        ScaleformUI.Scaleforms._ui?.callFunction("SET_CURRENT_ITEM", this.Pagination.GetPageIndexFromMenuIndex(this.CurrentSelection));
                    }
                }
            }
        }

        let i = 0;
        let max = this.Pagination.ItemsPerPage;
        if (this.Items.length < max) {
            max = this.Items.length;
        }
        this.Pagination.MinItem = this.Pagination.CurrentPageStartIndex;
        if (this.ScrollingType == MenuScrollingType.CLASSIC && this.Pagination.TotalPages > 1) {
            let missingItems = this.Pagination.GetMissingItems();
            if (missingItems > 0) {
                this.Pagination.ScaleformIndex = this.Pagination.GetPageIndexFromMenuIndex(this.Pagination.CurrentPageEndIndex) + missingItems;
                this.Pagination.MinItem = this.Pagination.CurrentPageStartIndex - missingItems;
            }
        }

        this.Pagination.MaxItem = this.Pagination.CurrentPageEndIndex;
        while (i < max) {
            await Delay(0)
            if (!this.Visible) return;
            this._itemCreation(this.Pagination.CurrentPage, i, false, true);
            i++;
        }
        this.Pagination.ScaleformIndex = this.Pagination.GetScaleformIndex(this.CurrentSelection);
        this.Items[this.CurrentSelection].Selected = true;
        ScaleformUI.Scaleforms._ui?.callFunction("SET_CURRENT_ITEM", this.Pagination.ScaleformIndex);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_COUNTER_QTTY", this.CurrentSelection + 1, this.Items.length);

        if (this.Items[this.CurrentSelection] instanceof UIMenuSeparatorItem) {
            if ((this.Items[this.CurrentSelection] as UIMenuSeparatorItem).Jumpable) {
                this.GoDown();
            }
        }
        ScaleformUI.Scaleforms._ui?.callFunction("ENABLE_MOUSE", this.MouseControlsEnabled);
        ScaleformUI.Scaleforms._ui?.callFunction("ENABLE_3D_ANIMATIONS", this.enabled3DAnimations);
        this.EnableAnimation = _animEnabled;
        await this.fadeInMenu();
        this.isBuilding = false;
    }

    public SetMouse(enableMouseControls: boolean, enableEdge: boolean, isWheelEnabled: boolean, resetCursorOnOpen: boolean, leftClickSelect: boolean) {
        this.MouseControlsEnabled = enableMouseControls;
        this.MouseEdgeEnabled = enableEdge;
        this.MouseWheelControlEnabled = isWheelEnabled;
        this.ResetCursorOnOpen = resetCursorOnOpen;
        this.leftClickEnabled = leftClickSelect;
        if (leftClickSelect && !this.MouseControlsEnabled) {
            this.SetKeyControl(MenuControls.Select, 24);

        }
        else {
            this.ResetKey(MenuControls.Select);
            this.SetKeyControl(MenuControls.Select, 201);
        }
    }

    public sortMenuItems(compare: (a: UIMenuItem, b: UIMenuItem) => number): void {
        if (this.itemless) throw new Error("ScaleformUI - You can't compare or sort an itemless menu");
        this.Items[this.CurrentSelection].Selected = false;
        this._unfilteredItems = [...this.Items];
        this.Clear();
        let list: UIMenuItem[] = [...this._unfilteredItems];
        list.sort(compare);
        this.Items = [...list];
        this.Pagination.TotalItems = this.Items.length;
        this.buildUpMenuAsync(true);
    }

    /**
     * Filters menu items based on the desired predicate
     * @param predicate - The predicate function to apply to each menu item
     */
    public filterMenuItems(predicate: (item: UIMenuItem) => boolean): void {
        if (this.itemless) throw new Error("ScaleformUI - You can't compare or sort an itemless menu");
        this.Items[this.CurrentSelection].Selected = false;
        this._unfilteredItems = [...this.Items];
        this.Clear();
        this.Items = this._unfilteredItems.filter(predicate);
        this.Pagination.TotalItems = this.Items.length;
        this.buildUpMenuAsync(true);
    }

    public resetFilter(): void {
        if (this.itemless) throw new Error("ScaleformUI - You can't compare or sort an itemless menu");
        this.Items[this.CurrentSelection].Selected = false;
        this.Clear();
        this.Items = [...this._unfilteredItems];
        this.Pagination.TotalItems = this.Items.length;
        this.buildUpMenuAsync(true);
    }

    private _itemCreation(page: number, pageIndex: number, before: boolean, isOverflow: boolean = false) {
        if (this.itemless) throw new Error("ScaleformUI - You can't add items to an itemless menu");
        let menuIndex = this.Pagination.GetMenuIndexFromPageIndex(page, pageIndex);
        let missing = false;
        if (!before) {
            if (this.Pagination.GetPageItemsCount(page) < this.Pagination.ItemsPerPage && this.Pagination.TotalPages > 1) {
                if (this.ScrollingType == MenuScrollingType.ENDLESS) {
                    if (menuIndex > this.Pagination.TotalItems - 1) {
                        menuIndex -= this.Pagination.TotalItems
                        this.Pagination.MaxItem = menuIndex;
                        missing = true;
                    }
                } else if (this.ScrollingType == MenuScrollingType.CLASSIC && isOverflow) {
                    let missingItems = this.Pagination.ItemsPerPage - this.Pagination.GetPageItemsCount(page);
                    menuIndex -= missingItems;
                } else if (this.ScrollingType == MenuScrollingType.PAGINATED) {
                    if (menuIndex >= this.Items.length) return;
                }
            }
        }

        let scaleformIndex = this.Pagination.GetScaleformIndex(menuIndex);
        if (this.ScrollingType == MenuScrollingType.ENDLESS && missing) {
            scaleformIndex = menuIndex + this.Pagination.GetScaleformIndex(this.Pagination.TotalItems);
        }

        let item = this.Items[menuIndex];
        AddTextEntry(`menu_${BreadcrumbsHandler.CurrentDepth}_desc_${menuIndex}`, item.Description);

        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._ui?.handle, "ADD_ITEM");
        PushScaleformMovieFunctionParameterBool(before);
        PushScaleformMovieFunctionParameterInt(item._itemId);
        PushScaleformMovieFunctionParameterInt(menuIndex);
        PushScaleformMovieMethodParameterString(item._formatLeftLabel);
        BeginTextCommandScaleformString(`menu_${BreadcrumbsHandler.CurrentDepth}_desc_${menuIndex}`);
        EndTextCommandScaleformString_2();
        PushScaleformMovieFunctionParameterBool(item.Enabled);
        PushScaleformMovieFunctionParameterBool(item.BlinkDescription);

        switch (true) {
            case item instanceof UIMenuDynamicListItem:
                let dit = item as UIMenuDynamicListItem
                PushScaleformMovieMethodParameterString(dit.CurrentListItem);
                PushScaleformMovieFunctionParameterInt(0);
                PushScaleformMovieFunctionParameterInt(dit.MainColor.toArgb());
                PushScaleformMovieFunctionParameterInt(dit.HighlightColor.toArgb());
                PushScaleformMovieFunctionParameterInt(dit.TextColor.toArgb());
                PushScaleformMovieFunctionParameterInt(dit.HighlightedTextColor.toArgb());
                EndScaleformMovieMethod();
                break;
            case item instanceof UIMenuListItem:
                let it = item as UIMenuListItem
                AddTextEntry(`listitem_${menuIndex}_list`, it.Items.join(","));
                BeginTextCommandScaleformString(`listitem_${menuIndex}_list`);
                EndTextCommandScaleformString();
                PushScaleformMovieFunctionParameterInt(it.Index);
                PushScaleformMovieFunctionParameterInt(it.MainColor.toArgb());
                PushScaleformMovieFunctionParameterInt(it.HighlightColor.toArgb());
                PushScaleformMovieFunctionParameterInt(it.TextColor.toArgb());
                PushScaleformMovieFunctionParameterInt(it.HighlightedTextColor.toArgb());
                EndScaleformMovieMethod();
                break;
            case item instanceof UIMenuSliderItem:
                let prItem = item as UIMenuSliderItem;
                PushScaleformMovieFunctionParameterInt(prItem._max);
                PushScaleformMovieFunctionParameterInt(prItem._multiplier);
                PushScaleformMovieFunctionParameterInt(prItem.Value);
                PushScaleformMovieFunctionParameterInt(prItem.MainColor.toArgb());
                PushScaleformMovieFunctionParameterInt(prItem.HighlightColor.toArgb());
                PushScaleformMovieFunctionParameterInt(prItem.TextColor.toArgb());
                PushScaleformMovieFunctionParameterInt(prItem.HighlightedTextColor.toArgb());
                PushScaleformMovieFunctionParameterInt(prItem.SliderColor.toArgb());
                PushScaleformMovieFunctionParameterBool(prItem._heritage);
                EndScaleformMovieMethod();
                break;
            case item instanceof UIMenuProgressItem:
                let slItem = item as UIMenuProgressItem;
                PushScaleformMovieFunctionParameterInt(slItem._max);
                PushScaleformMovieFunctionParameterInt(slItem._multiplier);
                PushScaleformMovieFunctionParameterInt(slItem.Value);
                PushScaleformMovieFunctionParameterInt(slItem.MainColor.toArgb());
                PushScaleformMovieFunctionParameterInt(slItem.HighlightColor.toArgb());
                PushScaleformMovieFunctionParameterInt(slItem.TextColor.toArgb());
                PushScaleformMovieFunctionParameterInt(slItem.HighlightedTextColor.toArgb());
                PushScaleformMovieFunctionParameterInt(slItem.SliderColor.toArgb());
                EndScaleformMovieMethod();
                break;
            case item instanceof UIMenuStatsItem:
                let statsItem = item as UIMenuStatsItem;
                PushScaleformMovieFunctionParameterInt(statsItem.Value);
                PushScaleformMovieFunctionParameterInt(statsItem.Type);
                PushScaleformMovieFunctionParameterInt(statsItem.sliderColor.toArgb());
                PushScaleformMovieFunctionParameterInt(statsItem.MainColor.toArgb());
                PushScaleformMovieFunctionParameterInt(statsItem.HighlightColor.toArgb());
                PushScaleformMovieFunctionParameterInt(statsItem.TextColor.toArgb());
                PushScaleformMovieFunctionParameterInt(statsItem.HighlightedTextColor.toArgb());
                EndScaleformMovieMethod();
                break;
            case item instanceof UIMenuSeparatorItem:
                let separatorItem = item as UIMenuSeparatorItem;
                PushScaleformMovieFunctionParameterBool(separatorItem.Jumpable);
                PushScaleformMovieFunctionParameterInt(item.MainColor.toArgb());
                PushScaleformMovieFunctionParameterInt(item.HighlightColor.toArgb());
                PushScaleformMovieFunctionParameterInt(item.TextColor.toArgb());
                PushScaleformMovieFunctionParameterInt(item.HighlightedTextColor.toArgb());
                EndScaleformMovieMethod();
                break;
            default:
                PushScaleformMovieFunctionParameterInt(item.MainColor.toArgb());
                PushScaleformMovieFunctionParameterInt(item.HighlightColor.toArgb());
                PushScaleformMovieFunctionParameterInt(item.TextColor.toArgb());
                PushScaleformMovieFunctionParameterInt(item.HighlightedTextColor.toArgb());
                EndScaleformMovieMethod();
                ScaleformUI.Scaleforms._ui?.callFunction("SET_RIGHT_LABEL", scaleformIndex, item._formatRightLabel);
                if (item.RightBadge != BadgeStyle.NONE)
                    ScaleformUI.Scaleforms._ui?.callFunction("SET_RIGHT_BADGE", scaleformIndex, item.RightBadge);
                break;
        }
        ScaleformUI.Scaleforms._ui?.callFunction("SET_ITEM_LABEL_FONT", scaleformIndex, item.labelFont.fontName, item.labelFont.fontId);
        ScaleformUI.Scaleforms._ui?.callFunction("SET_ITEM_RIGHT_LABEL_FONT", scaleformIndex, item.rightLabelFont.fontName, item.rightLabelFont.fontId);
        if (item.LeftBadge != BadgeStyle.NONE)
            ScaleformUI.Scaleforms._ui?.callFunction("SET_LEFT_BADGE", scaleformIndex, item.LeftBadge);
        if (item.SidePanel != null) {
            switch (true) {
                case item.SidePanel instanceof UIMissionDetailsPanel:
                    let mis = item.SidePanel as UIMissionDetailsPanel;
                    ScaleformUI.Scaleforms._ui?.callFunction("ADD_SIDE_PANEL_TO_ITEM", scaleformIndex, 0, mis.PanelSide, mis.TitleType, mis.Title, mis.TitleColor, mis.TextureDict, mis.TextureName);
                    mis.Items.forEach((_it: UIFreemodeDetailsItem) => {
                        ScaleformUI.Scaleforms._ui?.callFunction("ADD_MISSION_DETAILS_DESC_ITEM", scaleformIndex, _it.Type, _it.TextLeft, _it.TextRight, _it.Icon, _it.IconColor, _it.Tick, _it._labelFont.fontName, _it._labelFont.fontId, _it._rightLabelFont.fontName, _it._rightLabelFont.fontId);
                    });
                    break;
                case item.SidePanel instanceof UIVehicleColourPickerPanel:
                    let cp = item.SidePanel as UIVehicleColourPickerPanel;
                    ScaleformUI.Scaleforms._ui?.callFunction("ADD_SIDE_PANEL_TO_ITEM", scaleformIndex, 1, cp.PanelSide, cp._titleType, cp.Title, cp.TitleColor);
                    break;
            }
        }
        if (item.Panels.length == 0) return;

        item.Panels.forEach((panel: UIMenuPanel) => {
            let pan = item.Panels.indexOf(panel);
            switch (true) {
                case panel instanceof UIMenuColorPanel:
                    let cp = panel as UIMenuColorPanel;
                    ScaleformUI.Scaleforms._ui?.callFunction("ADD_PANEL", scaleformIndex, 0, cp.Title, cp.PanelColorType, cp.CurrentSelection, cp.CustomColors != null ? cp.CustomColors.map((x: SColor) => x.toArgb()).join(",") : "");
                    break;
                case panel instanceof UIMenuPercentagePanel:
                    let pp = panel as UIMenuPercentagePanel;
                    ScaleformUI.Scaleforms._ui?.callFunction("ADD_PANEL", scaleformIndex, 1, pp.Title, pp.Min, pp.Max, pp.Percentage);
                    break;
                case panel instanceof UIMenuGridPanel:
                    let gp = panel as UIMenuGridPanel;
                    ScaleformUI.Scaleforms._ui?.callFunction("ADD_PANEL", scaleformIndex, 2, gp.TopLabel, gp.RightLabel, gp.LeftLabel, gp.BottomLabel, gp.CirclePosition.x, gp.CirclePosition.y, true, gp.Type);
                    break;
                case panel instanceof UIMenuStatisticsPanel:
                    let sp = panel as UIMenuStatisticsPanel;
                    ScaleformUI.Scaleforms._ui?.callFunction("ADD_PANEL", scaleformIndex, 3);
                    if (sp.Items.length > 0) {
                        sp.Items.forEach((stat: StatisticsForPanel) => {
                            ScaleformUI.Scaleforms._ui?.callFunction("ADD_STATISTIC_TO_PANEL", scaleformIndex, pan, stat.Text, stat.Value);
                        });
                    }
                    break;
            }
        });
    }

    public set CurrentSelection(value: number) {
        if (value < 0) {
            this.Pagination.CurrentMenuIndex = 0;
        }
        else if (value >= this.Items.length) {
            this.Pagination.CurrentMenuIndex = this.Items.length - 1;
        }
        this.Items[this.CurrentSelection].Selected = false;

        this.Pagination.CurrentMenuIndex = value;
        this.Pagination.CurrentPage = this.Pagination.GetPage(this.Pagination.CurrentMenuIndex);
        this.Pagination.CurrentPageIndex = value;
        this.Pagination.ScaleformIndex = this.Pagination.GetScaleformIndex(value);

        if (this._visible)
            ScaleformUI.Scaleforms._ui?.callFunction("SET_CURRENT_ITEM", this.Pagination.GetScaleformIndex(this.Pagination.CurrentMenuIndex));

        this.Items[this.CurrentSelection].Selected = true;
    }
    public get CurrentSelection(): number {
        return this.Items.length == 0 ? 0 : this.Pagination.CurrentMenuIndex;
    }

    public set CurrentItem(item: UIMenuItem) {
        this.CurrentSelection = this.Items.includes(item) ? this.Items.indexOf(item) : 0;
    }
    public get CurrentItem(): UIMenuItem {
        return this.Items[this.CurrentSelection];
    }

    public set Title(value: string) {
        this.title = value;
        if (this._visible)
            ScaleformUI.Scaleforms._ui?.callFunction("UPDATE_TITLE_SUBTITLE", this.title, this.subtitle, this.AlternativeTitle);
    }
    public get Title(): string {
        return this.title;
    }

    public set Subtitle(value: string) {
        this.subtitle = value;
        if (this._visible)
            ScaleformUI.Scaleforms._ui?.callFunction("UPDATE_TITLE_SUBTITLE", this.title, this.subtitle, this.AlternativeTitle);
    }
    public get Subtitle(): string {
        return this.subtitle;
    }

    public set CounterColor(value: SColor) {
        this.counterColor = value;
        if (this._visible)
            ScaleformUI.Scaleforms._ui?.callFunction("SET_COUNTER_COLOR", this.counterColor);
    }
    public get CounterColor(): SColor {
        return this.counterColor;
    }


    public set CanPlayerCloseMenu(value: boolean) {
        this.canPlayerCloseMenu = value;
        if (value) {
            this.instructionalButtons = [
                new InstructionalButton(UIMenu._selectTextLocalized, -1, 176, 176, -1),
                new InstructionalButton(UIMenu._backTextLocalized, -1, 177, 177, -1)
            ];
        } else {
            this.instructionalButtons = [
                new InstructionalButton(UIMenu._selectTextLocalized, -1, 176, 176, -1),
            ];
        }
        if (this.Visible) {
            ScaleformUI.Scaleforms.InstructionalButtons.SetInstructionalButtons(this.instructionalButtons);
        }
    }
    public get CanPlayerCloseMenu(): boolean {
        return this.canPlayerCloseMenu;
    }

    private IndexChange(newindex: number) {
        this._IndexChanged.toDelegate()(this, newindex);
    }

    ListChange(sender: UIMenuListItem, newindex: number) {
        this._ListChanged.toDelegate()(this, sender, newindex);
    }

    ProgressChange(sender: UIMenuProgressItem, newindex: number) {
        this._OnProgressChanged.toDelegate()(this, sender, newindex);
    }

    private ListSelect(sender: UIMenuListItem, newindex: number) {
        this._ListSelected.toDelegate()(this, sender, newindex);
    }

    private SliderChange(sender: UIMenuSliderItem, newindex: number) {
        this._SliderChange.toDelegate()(this, sender, newindex);
    }

    private ItemSelect(selecteditem: UIMenuItem, index: number) {
        this._ItemSelected.toDelegate()(this, selecteditem, index);
    }

    private CheckboxChange(sender: UIMenuCheckboxItem, Checked: boolean) {
        this._CheckboxChanged.toDelegate()(this, sender, Checked);
    }

    private StatItemChange(item: UIMenuStatsItem, value: number) {
        this._StatItemProgressChange.toDelegate()(this, item, value);
    }

    private MenuOpenEv(menu: UIMenu, data: any) {
        this._MenuOpened.toDelegate()(menu, data);
    }

    private MenuCloseEv(menu: UIMenu) {
        this._MenuClosed.toDelegate()(menu);
    }

    private ColorPanelChange(item: UIMenuItem, panel: UIMenuColorPanel, index: number) {
        this._ColorPanelChanged.toDelegate()(item, panel, index);
    }
    private PercentagePanelChange(item: UIMenuItem, panel: UIMenuPercentagePanel, index: number) {
        this._PercentagePanelChanged.toDelegate()(item, panel, index);
    }
    private GridPanelChange(item: UIMenuItem, panel: UIMenuGridPanel, index: Vector2) {
        this._GridPanelChanged.toDelegate()(item, panel, index);
    }
}