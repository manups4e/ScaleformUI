import { ItemFont } from "elements/ItemFont";
import { SColor } from "elements/scolor";
import { Scaleform } from "scaleforms/scaleform"

export class PauseMenuHandler {
    _header: Scaleform | null;
    _pause: Scaleform | null;
    _lobby: Scaleform | null;
    _pauseBG: Scaleform | null;
    BGEnabled: boolean = false
    Loaded: boolean = false
    _visible: boolean = false

    constructor() {
        this._header = null;
        this._pause = null;
        this._lobby = null;
        this._pauseBG = null;
        this.BGEnabled = false;
        this.Loaded = false;
        this._visible = false;
    }

    public set Visible(_v: boolean) {
        this._visible = _v;
    }
    public get Visible() {
        return this._visible;
    }

    load() {
        if (this._header != null && this._pause != null && this._lobby != null)
            return;
        this._header = Scaleform.requestWideScreen("pausemenuheader")
        this._pause = Scaleform.requestWideScreen("pausemenu")
        this._lobby = Scaleform.requestWideScreen("lobbymenu")
        this._pauseBG = Scaleform.requestWideScreen("store_background")
        this.Loaded = this._header.isLoaded() && this._pause.isLoaded() && this._lobby.isLoaded()
    }

    setHeaderTitle(title: string, subtitle: string, shiftUpHeader: boolean) {
        if (subtitle == null)
            subtitle = "";
        if (shiftUpHeader == null)
            shiftUpHeader = false;
        this._header?.callFunction("SET_HEADER_TITLE", title, subtitle, shiftUpHeader)
    }


    setHeaderDetails(topDetail: string, midDetail: string, botDetail: string) {
        this._header?.callFunction("SET_HEADER_DETAILS", topDetail, midDetail, botDetail, false)
    }

    shiftCoronaDescription(shiftDesc: boolean, hideTabs: boolean) {
        this._header?.callFunction("SHIFT_CORONA_DESC", shiftDesc, hideTabs)
    }

    showHeadingDetails(show: boolean) {
        this._header?.callFunction("SHOW_HEADING_DETAILS", show)
    }

    setHeaderCharImg(txd: string, charTexturePath: string, show: boolean) {
        this._header?.callFunction("SET_HEADER_CHAR_IMG", txd, charTexturePath, show)
    }

    setHeaderSecondaryImg(txd: string, charTexturePath: string, show: boolean) {
        this._header?.callFunction("SET_HEADER_CREW_IMG", txd, charTexturePath, show)
    }

    headerGoRight() {
        this._header?.callFunction("GO_RIGHT")
    }

    headerGoLeft() {
        this._header?.callFunction("GO_LEFT")
    }

    addPauseMenuTab(title: string, _type: number, _tabContentType: number, color: SColor) {
        if (color == null)
            color = SColor.HUD_Freemode
        this._header?.callFunction("ADD_HEADER_TAB", title, _type, color)
        this._pause?.callFunction("ADD_TAB", _tabContentType)
    }

    addLobbyMenuTab(title: string, _type: number, color: SColor) {
        if (color == null)
            color = SColor.HUD_Freemode
        this._header?.callFunction("ADD_HEADER_TAB", title, _type, color)
    }

    selectTab(tab: number) {
        this._header?.callFunction("SET_TAB_INDEX", tab)
        this._pause?.callFunction("SET_TAB_INDEX", tab)
    }

    setFocus(focusLevel: number) {
        this._pause?.callFunction("SET_FOCUS", focusLevel)
    }

    addLeftItem(tab: number, _type: number, title: string, itemColor: SColor, highlightColor: SColor, enabled: boolean) {
        if (itemColor == null)
            itemColor = SColor.HUD_Pause_bg
        if (highlightColor == null)
            highlightColor = SColor.HUD_White
        if (itemColor !== SColor.HUD_None && highlightColor !== SColor.HUD_None)
            this._pause?.callFunction("ADD_LEFT_ITEM", tab, _type, title, enabled, itemColor, highlightColor)
        else if (itemColor !== SColor.HUD_None && highlightColor == SColor.HUD_None)
            this._pause?.callFunction("ADD_LEFT_ITEM", tab, _type, title, enabled, itemColor)
        else
            this._pause?.callFunction("ADD_LEFT_ITEM", tab, _type, title, enabled)
    }

    addRightTitle(tab: number, leftItemIndex: number, title: string) {
        this._pause?.callFunction("ADD_RIGHT_TITLE", tab, leftItemIndex, title)
    }

    addRightListLabel(tab: number, leftItemIndex: number, label: string, fontName: string, fontId: number) {
        AddTextEntry("PauseMenu_" + tab + "_" + leftItemIndex, label)
        BeginScaleformMovieMethod(this._pause?.handle, "ADD_RIGHT_LIST_ITEM")
        ScaleformMovieMethodAddParamInt(tab)
        ScaleformMovieMethodAddParamInt(leftItemIndex)
        ScaleformMovieMethodAddParamInt(0)
        BeginTextCommandScaleformString("PauseMenu_" + tab + "_" + leftItemIndex)
        EndTextCommandScaleformString_2()
        ScaleformMovieMethodAddParamPlayerNameString(fontName)
        ScaleformMovieMethodAddParamInt(fontId)
        EndScaleformMovieMethod()
    }

    addRightStatItemLabel(tab: number, leftItemIndex: number, label: string, rightLabel: string, labelFont: ItemFont, rLabelFont: ItemFont) {
        this._pause?.callFunction("ADD_RIGHT_LIST_ITEM", tab, leftItemIndex, 1, 0, label, rightLabel, -1, labelFont.fontName, labelFont.fontId, rLabelFont.fontName, rLabelFont.fontId)
    }

    addRightStatItemColorBar(tab: number, leftItemIndex: number, label: string, value: number, barColor: SColor, labelFont: ItemFont) {
        this._pause?.callFunction("ADD_RIGHT_LIST_ITEM", tab, leftItemIndex, 1, 1, label, value, barColor, labelFont.fontName, labelFont.fontId)
    }

    addRightSettingsBaseItem(tab: number, leftItemIndex: number, label: string, rightLabel: string, enabled: boolean) {
        this._pause?.callFunction("ADD_RIGHT_LIST_ITEM", tab, leftItemIndex, 2, 0, label, enabled, rightLabel)
    }

    addRightSettingsListItem(tab: number, leftItemIndex: number, label: string, items: any[], startIndex: number, enabled: number) {
        let stringList = items.join(",")
        this._pause?.callFunction("ADD_RIGHT_LIST_ITEM", tab, leftItemIndex, 2, 1, label, enabled, stringList,
            startIndex)
    }

    addRightSettingsProgressItem(tab: number, leftItemIndex: number, label: string, max: number, color: SColor, index: number, enabled: boolean) {
        this._pause?.callFunction("ADD_RIGHT_LIST_ITEM", tab, leftItemIndex, 2, 2, label, enabled, max, color, index)
    }

    addRightSettingsProgressItemAlt(tab: number, leftItemIndex: number, label: string, max: number, color: SColor, index: number, enabled: boolean) {
        this._pause?.callFunction("ADD_RIGHT_LIST_ITEM", tab, leftItemIndex, 2, 3, label, enabled, max, color, index)
    }

    addRightSettingsSliderItem(tab: number, leftItemIndex: number, label: string, max: number, color: SColor, index: number, enabled: boolean) {
        this._pause?.callFunction("ADD_RIGHT_LIST_ITEM", tab, leftItemIndex, 2, 5, label, enabled, max, color, index)
    }

    addRightSettingsCheckboxItem(tab: number, leftItemIndex: number, label: string, style: number, check: boolean, enabled: boolean) {
        this._pause?.callFunction("ADD_RIGHT_LIST_ITEM", tab, leftItemIndex, 2, 4, label, enabled, style, check)
    }

    addKeymapTitle(tab: number, leftItemIndex: number, title: string, rightLabel_1: string, rightLabel_2: string) {
        this._pause?.callFunction("ADD_RIGHT_TITLE", tab, leftItemIndex, title, rightLabel_1, rightLabel_2)
    }

    addKeymapItem(tab: number, leftItemIndex: number, label: string, control1: string, control2: string) {
        BeginScaleformMovieMethod(this._pause?.handle, "ADD_RIGHT_LIST_ITEM")
        ScaleformMovieMethodAddParamInt(tab)
        ScaleformMovieMethodAddParamInt(leftItemIndex)
        ScaleformMovieMethodAddParamInt(3)
        ScaleformMovieMethodAddParamTextureNameString(label)
        BeginTextCommandScaleformString("STRING")
        AddTextComponentSubstringKeyboardDisplay(control1)
        EndTextCommandScaleformString_2()
        BeginTextCommandScaleformString("STRING")
        AddTextComponentSubstringKeyboardDisplay(control2)
        EndTextCommandScaleformString_2()
        EndScaleformMovieMethod()
    }

    updateKeymap(tab: number, leftItemIndex: number, rightItem: number, control1: string, control2: string) {
        BeginScaleformMovieMethod(this._pause?.handle, "UPDATE_KEYMAP_ITEM")
        ScaleformMovieMethodAddParamInt(tab)
        ScaleformMovieMethodAddParamInt(leftItemIndex)
        ScaleformMovieMethodAddParamInt(rightItem)
        BeginTextCommandScaleformString("string")
        AddTextComponentSubstringKeyboardDisplay(control1)
        EndTextCommandScaleformString_2()
        BeginTextCommandScaleformString("string")
        AddTextComponentSubstringKeyboardDisplay(control2)
        EndTextCommandScaleformString_2()
        EndScaleformMovieMethod()
    }

    setRightSettingsItemBool(tab: number, leftItemIndex: number, rightItem: number, value: boolean) {
        this._pause?.callFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", tab, leftItemIndex, rightItem, value)
    }

    setRightSettingsItemIndex(tab: number, leftItemIndex: number, rightItem: number, value: number) {
        this._pause?.callFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", tab, leftItemIndex, rightItem, value)
    }

    setRightSettingsItemValue(tab: number, leftItemIndex: number, rightItem: number, value: number) {
        this._pause?.callFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", tab, leftItemIndex, rightItem, value)
    }

    updateItemRightLabel(tab: number, leftItemIndex: number, rightItem: number, label: string) {
        this._pause?.callFunction("UPDATE_RIGHT_ITEM_RIGHT_LABEL", tab, leftItemIndex, rightItem, label)
    }

    updateStatsItemBasic(tab: number, leftItemIndex: number, rightItem: number, label: string, rightLabel: string) {
        this._pause?.callFunction("UPDATE_RIGHT_STATS_ITEM", tab, leftItemIndex, rightItem, label, rightLabel)
    }

    updateStatsItemBar(tab: number, leftItemIndex: number, rightItem: number, label: string, value: number, color: SColor) {
        this._pause?.callFunction("UPDATE_RIGHT_STATS_ITEM", tab, leftItemIndex, rightItem, label, value, color)
    }

    updateItemColoredBar(tab: number, leftItemIndex: number, rightItem: number, color: SColor) {
        if (color == null || color == SColor.HUD_None)
            this._pause?.callFunction("UPDATE_COLORED_BAR_COLOR", tab, leftItemIndex, rightItem, SColor.HUD_Freemode)
        else
            this._pause?.callFunction("UPDATE_COLORED_BAR_COLOR", tab, leftItemIndex, rightItem, color)
    }

    sendInputEvent(direction: number) {
        return this._pause?.callFunctionReturnString("SET_INPUT_EVENT", direction)
    }

    sendScrollEvent(direction: number) {
        this._pause?.callFunction("SET_SCROLL_EVENT", direction)
    }

    sendClickEvent() {
        return this._pause?.callFunctionReturnString("MOUSE_CLICK_EVENT")
    }

    dispose() {
        this._pause?.callFunction("CLEAR_ALL")
        this._header?.callFunction("CLEAR_ALL")
        this._lobby?.callFunction("CLEAR_ALL")
        this._visible = false
    }

    draw(isLobby: boolean) {
        if (isLobby == null)
            isLobby = false
        if (this._visible && GetCurrentFrontendMenuVersion() == -2060115030) {
            SetScriptGfxDrawBehindPausemenu(true)
            if (IsUsingKeyboard(2))
                SetMouseCursorActiveThisFrame()
            if (this.BGEnabled)
                this._pauseBG?.render2d()
            this._header?.render2dNormal(0.501, 0.162, 0.6782, 0.145)
            if (isLobby)
                this._lobby?.render2dNormal(0.6617187, 0.7226667, 1.0, 1.0)
            else
                this._pause?.render2dNormal(0.6617187, 0.7226667, 1.0, 1.0)
        }
    }
}