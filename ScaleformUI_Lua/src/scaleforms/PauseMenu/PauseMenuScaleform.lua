PauseMenu = setmetatable({}, PauseMenu)
PauseMenu.__index = PauseMenu
PauseMenu.__call = function()
    return "PauseMenu"
end

---@class PauseMenu
---@field public _header Scaleform
---@field public _pause Scaleform
---@field public _lobby Scaleform
---@field public _pauseBG Scaleform
---@field public Loaded boolean
---@field public _visible boolean
---@field public Visible fun(self:PauseMenu, visible:boolean):boolean
---@field public SetHeaderTitle fun(self:PauseMenu, title:string, subtitle:string | nil, shiftUpHeader:boolean | nil):nil
---@field public SetHeaderDetails fun(self:PauseMenu, topDetail:string, midDetail:string, botDetail:string):nil
---@field public ShiftCoronaDescription fun(self:PauseMenu, shiftDesc:boolean, hideTabs:boolean):nil
---@field public ShowHeaderDetails fun(self:PauseMenu, show:boolean):nil
---@field public SetHeaderCharImg fun(self:PauseMenu, txd:string, charTexturePath:string, show:boolean):nil
---@field public SetHeaderSecondaryImg fun(self:PauseMenu, txd:string, charTexturePath:string, show:boolean):nil
---@field public HeaderGoRight fun(self:PauseMenu):nil
---@field public HeaderGoLeft fun(self:PauseMenu):nil
---@field public AddPauseMenuTab fun(self:PauseMenu, title:string, _type:number, _tabContentType:number, color:SColor | nil):nil
---@field public AddLobbyMenuTab fun(self:PauseMenu, title:string, _type:number, _tabContentType:number, color:SColor | nil):nil
---@field public SelectTab fun(self:PauseMenu, tab:number):nil
---@field public SetFocus fun(self:PauseMenu, focus:number):nil
---@field public AddLeftItem fun(self:PauseMenu, tab:number, title:string, _type:number, _tabContentType:number, color:SColor, enabled:boolean):nil
---@field public AddRightTitle fun(self:PauseMenu, tab:number, leftItemIndex:number, title:string):nil
---@field public AddRightListLabel fun(self:PauseMenu, tab:number, leftItemIndex:number, title:string, fontName:string, fontId:number):nil
---@field public AddRightStatItemLabel fun(self:PauseMenu, tab:number, leftItemIndex:number, label:string, rightLabel:string, labelFont:Font, rLabelFont:Font):nil
---@field public AddRightStatItemColorBar fun(self:PauseMenu, tab:number, leftItemIndex:number, label:string, value:number, color:SColor, labelFont:Font):nil
---@field public AddRightSettingsBaseItem fun(self:PauseMenu, tab:number, leftItemIndex:number, label:string, rightLabel:string, enabled:boolean):nil
---@field public AddRightSettingsListItem fun(self:PauseMenu, tab:number, leftItemIndex:number, label:string, items:table, startIndex:number, enabled:boolean):nil
---@field public AddRightSettingsProgressItem fun(self:PauseMenu, tab:number, leftItemIndex:number, label:string, max:number, colour:SColor, index:number, enabled:boolean):nil
---@field public AddRightSettingsProgressItemAlt fun(self:PauseMenu, tab:number, leftItemIndex:number, label:string, max:number, colour:SColor, index:number, enabled:boolean):nil
---@field public AddRightSettingsSliderItem fun(self:PauseMenu, tab:number, leftItemIndex:number, label:string, max:number, colour:SColor, index:number, enabled:boolean):nil
---@field public AddRightSettingsCheckboxItem fun(self:PauseMenu, tab:number, leftItemIndex:number, label:string, style:number, check:boolean, enabled:boolean):nil
---@field public AddKeymapTitle fun(self:PauseMenu, tab:number, leftItemIndex:number, title:string, rightLabel:string, rightLabel2:string):nil
---@field public AddKeymapItem fun(self:PauseMenu, tab:number, leftItemIndex:number, label:string, control:string, control2:string):nil
---@field public UpdateKeymap fun(self:PauseMenu, tab:number, leftItemIndex:number, rightIndex:number, control:string, control2:string):nil
---@field public SetRightSettingsItemBool fun(self:PauseMenu, tab:number, leftItemIndex:number, rightItemIndex:number, check:boolean):nil
---@field public SetRightSettingsItemIndex fun(self:PauseMenu, tab:number, leftItemIndex:number, rightItemIndex:number, value:number):nil
---@field public SetRightSettingsItemValue fun(self:PauseMenu, tab:number, leftItemIndex:number, rightItemIndex:number, value:number):nil
---@field public UpdateItemRightLabel fun(self:PauseMenu, tab:number, leftItemIndex:number, rightItemIndex:number, rightLabel:string):nil
---@field public UpdateStatsItemBasic fun(self:PauseMenu, tab:number, leftItemIndex:number, rightItemIndex:number, label:string, rightLabel:string):nil
---@field public UpdateStatsItemBar fun(self:PauseMenu, tab:number, leftItemIndex:number, rightItemIndex:number, label:string, value:number, color:SColor):nil
---@field public UpdateItemColoredBar fun(self:PauseMenu, tab:number, leftItemIndex:number, rightItemIndex:number, colour:SColor):nil
---@field public SendInputEvent fun(self:PauseMenu, inputEvent:string):nil
---@field public SendScrollEvent fun(self:PauseMenu, scrollEvent:number):nil
---@field public SendClickEvent fun(self:PauseMenu):nil
---@field public Dispose fun(self:PauseMenu):nil
---@field public Draw fun(self:PauseMenu, isLobby:boolean | nil):nil
---@field public Load fun(self:PauseMenu):nil
---@field public IsLoaded fun(self:PauseMenu):boolean

---Creates a new instance of the pause menu
---@return PauseMenu
function PauseMenu.New()
    local _data = {
        _header = nil,
        _pause = nil,
        _lobby = nil,
        _pauseBG = nil,
        BGEnabled = false,
        Loaded = false,
        _visible = false,
        firstTick = true,
    }
    return setmetatable(_data, PauseMenu)
end

---Toggle the visibility of the pause menu
---@param visible boolean
---@return boolean
function PauseMenu:Visible(visible)
    if ToBool(visible) then
        self._visible = visible
    end
    return self._visible
end

---Load the pause menu scaleforms
function PauseMenu:Load()
    if (self._header ~= nil and self._pause ~= nil and self._lobby ~= nil and self._pauseBG ~= nil) then return end
    self._header = Scaleform.RequestWidescreen("pausemenuheader")
    self._pause = Scaleform.RequestWidescreen("pausemenu")
    self._lobby = Scaleform.RequestWidescreen("lobbymenu")
    self._pauseBG = Scaleform.RequestWidescreen("store_background")
    self.Loaded = self._header:IsLoaded() and self._pause:IsLoaded() and self._lobby:IsLoaded() and self._pauseBG:IsLoaded()
end

function PauseMenu:FadeInMenus()
    self._header:CallFunction("DRAW_MENU")
    self._pause:CallFunction("DRAW_MENU")
    self._lobby:CallFunction("DRAW_MENU")
end

function PauseMenu:IsLoaded()
    return self._header:IsLoaded() and self._pause:IsLoaded() and self._lobby:IsLoaded() and self._pauseBG:IsLoaded()
end

---Set the header title and subtitle text of the pause menu header
---@param title string
---@param subtitle string | nil
---@param shiftUpHeader boolean | nil
function PauseMenu:SetHeaderTitle(title, subtitle, shiftUpHeader)
    if (subtitle == nil) then subtitle = "" end
    if (shiftUpHeader == nil) then shiftUpHeader = false end
    self._header:CallFunction("SET_HEADER_TITLE", title, subtitle, shiftUpHeader)
end

---Set the header details of the pause menu header
---@param topDetail string
---@param midDetail string
---@param botDetail string
function PauseMenu:SetHeaderDetails(topDetail, midDetail, botDetail)
    self._header:CallFunction("SET_HEADER_DETAILS", topDetail, midDetail, botDetail, false)
end

---Shift the corona description of the pause menu header
---@param shiftDesc boolean
---@param hideTabs boolean
function PauseMenu:ShiftCoronaDescription(shiftDesc, hideTabs)
    self._header:CallFunction("SHIFT_CORONA_DESC", shiftDesc, hideTabs)
end

---Toggle the header details of the pause menu header
---@param show boolean
function PauseMenu:ShowHeadingDetails(show)
    self._header:CallFunction("SHOW_HEADING_DETAILS", show)
end

---Set the header character headshot of the pause menu header
---@param txd string
---@param charTexturePath string
---@param show boolean
function PauseMenu:SetHeaderCharImg(txd, charTexturePath, show)
    self._header:CallFunction("SET_HEADER_CHAR_IMG", txd, charTexturePath, show)
end

---Set the header secondary image of the pause menu header
---@param txd string
---@param charTexturePath string
---@param show boolean
function PauseMenu:SetHeaderSecondaryImg(txd, charTexturePath, show)
    self._header:CallFunction("SET_HEADER_CREW_IMG", txd, charTexturePath, show)
end

---Move selection of the header to the right
function PauseMenu:HeaderGoRight()
    self._header:CallFunction("GO_RIGHT")
end

---Move selection of the header to the left
function PauseMenu:HeaderGoLeft()
    self._header:CallFunction("GO_LEFT")
end

---Add a tab to the pause menu
---@param title string
---@param _type number
---@param _tabContentType number
---@param color HudColours | nil Sets the color of the tab (default: SColor.HUD_Freemode)
function PauseMenu:AddPauseMenuTab(title, _type, _tabContentType, color)
    if color == nil then color = 116 end
    self._header:CallFunction("ADD_HEADER_TAB", title, _type, color)
end

---Add a tab to the lobby menu
---@param title string
---@param _type number
---@param color SColor | nil Sets the color of the tab (default: 116)
function PauseMenu:AddLobbyMenuTab(title, _type, color)
    print(color)
    if color == nil then color = SColor.HUD_Freemode end
    self._header:CallFunction("ADD_HEADER_TAB", title, _type, color)
end

---Select a tab in the pause menu
function PauseMenu:SelectTab(tab)
    self._header:CallFunction("SET_TAB_INDEX", tab)
end

---Set the focued item of the pause menu
---@param focus number
function PauseMenu:SetFocus(focus)
    self._pause:CallFunction("SET_FOCUS", focus)
end

---Add a left item to the pause menu
---@param _type number
---@param title string
---@param itemColor SColor | nil Sets the color of the item (default: SColor.HUD_Pause_bg)
---@param highlightColor SColor | nil Sets the color of the item when highlighted (default: SColor.HUD_White)
---@param enabled boolean | nil Sets the item to be enabled or disabled
function PauseMenu:AddLeftItem(_type, title, itemColor, highlightColor, enabled)
    if itemColor == nil then itemColor = SColor.HUD_Pause_bg end
    if highlightColor == nil then highlightColor = SColor.HUD_White end
    
    if (itemColor ~= SColor.HUD_None and highlightColor ~= SColor.HUD_None) then
        self._pause:CallFunction("ADD_LEFT_ITEM", _type, title, enabled, itemColor, highlightColor)
    elseif itemColor ~= SColor.HUD_None and highlightColor == SColor.HUD_None then
        self._pause:CallFunction("ADD_LEFT_ITEM", _type, title, enabled, itemColor)
    else
        self._pause:CallFunction("ADD_LEFT_ITEM", _type, title, enabled)
    end
end

---Add a right title to a tab and left item
---@param leftItemIndex number
---@param title string
function PauseMenu:AddRightTitle(leftItemIndex, title)
    self._pause:CallFunction("ADD_RIGHT_TITLE", leftItemIndex, title)
end

---Add a right list label to a tab and left item
---@param leftItemIndex number
---@param label string
function PauseMenu:AddRightListLabel(leftItemIndex, label, fontName, fontId)
    AddTextEntry("PauseMenu_" .. leftItemIndex, label)
    BeginScaleformMovieMethod(self._pause.handle, "ADD_RIGHT_LIST_ITEM")
    ScaleformMovieMethodAddParamInt(leftItemIndex)
    ScaleformMovieMethodAddParamInt(0)
    BeginTextCommandScaleformString("PauseMenu_" .. leftItemIndex)
    EndTextCommandScaleformString_2()
    ScaleformMovieMethodAddParamPlayerNameString(fontName)
    ScaleformMovieMethodAddParamInt(fontId)
    EndScaleformMovieMethod()
end

---Add a right stat item to a tab and left item
---@param leftItemIndex number
---@param label string
---@param rightLabel string
function PauseMenu:AddRightStatItemLabel(leftItemIndex, label, rightLabel, labelFont, rLabelFont)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", leftItemIndex, 1, 0, label, rightLabel, -1, labelFont.FontName, labelFont.FontID, rLabelFont.FontName, rLabelFont.FontID)
end

---Add a right stat item colour bar to a tab and left item
---@param leftItemIndex number
---@param label string
---@param value number
---@param barColor SColor | nil Sets the color of the bar (default: SColor.HUD_Freemode)
function PauseMenu:AddRightStatItemColorBar(leftItemIndex, label, value, barColor, labelFont)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", leftItemIndex, 1, 1, label, value, barColor, labelFont.FontName, labelFont.FontID)
end

---Add a right settings base item to a tab and left item
---@param leftItemIndex number
---@param label string
---@param rightLabel string
---@param enabled boolean | nil Sets the item to be enabled or disabled
function PauseMenu:AddRightSettingsBaseItem(leftItemIndex, label, rightLabel, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", leftItemIndex, 2, 0, label, enabled, rightLabel)
end

---Add a right settings list item to a tab and left item
---@param leftItemIndex number
---@param label string
---@param items table
---@param startIndex number
---@param enabled boolean | nil Sets the item to be enabled or disabled
function PauseMenu:AddRightSettingsListItem(leftItemIndex, label, items, startIndex, enabled)
    local stringList = table.concat(items, ",")
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", leftItemIndex, 2, 1, label, enabled, stringList,
        startIndex)
end

---Add a right settings progress item to a tab and left item
---@param leftItemIndex number
---@param label string
---@param max number
---@param color SColor | nil Sets the color of the bar (default: SColor.HUD_Freemode)
---@param index number
---@param enabled boolean | nil Sets the item to be enabled or disabled
function PauseMenu:AddRightSettingsProgressItem(leftItemIndex, label, max, color, index, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", leftItemIndex, 2, 2, label, enabled, max, color, index)
end

---Add a right settings progress item to a tab and left item
---@param leftItemIndex number
---@param label string
---@param max number
---@param color SColor | nil Sets the color of the bar (default: SColor.HUD_Freemode)
---@param index number
---@param enabled boolean | nil Sets the item to be enabled or disabled
function PauseMenu:AddRightSettingsProgressItemAlt(leftItemIndex, label, max, color, index, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", leftItemIndex, 2, 3, label, enabled, max, color, index)
end

---Add a right settings slider item to a tab and left item
---@param leftItemIndex number
---@param label string
---@param max number
---@param color SColor | nil Sets the color of the bar (default: SColor.HUD_Freemode)
---@param index number
---@param enabled boolean | nil Sets the item to be enabled or disabled
function PauseMenu:AddRightSettingsSliderItem(leftItemIndex, label, max, color, index, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", leftItemIndex, 2, 5, label, enabled, max, color, index)
end

---Add a right settings checkbox item to a tab and left item
---@param leftItemIndex number
---@param label string
---@param style number
---@param check boolean
---@param enabled boolean | nil Sets the item to be enabled or disabled
function PauseMenu:AddRightSettingsCheckboxItem(leftItemIndex, label, style, check, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", leftItemIndex, 2, 4, label, enabled, style, check)
end

---Add a key map title to a tab and left item
---@param leftItemIndex number
---@param title string
---@param rightLabel_1 string
---@param rightLabel_2 string
function PauseMenu:AddKeymapTitle(leftItemIndex, title, rightLabel_1, rightLabel_2)
    self._pause:CallFunction("ADD_RIGHT_TITLE", leftItemIndex, title, rightLabel_1, rightLabel_2)
end

---Add a key map item to a tab and left item
---@param leftItemIndex number
---@param label string
---@param control1 string
---@param control2 string
function PauseMenu:AddKeymapItem(leftItemIndex, label, control1, control2)
    BeginScaleformMovieMethod(self._pause.handle, "ADD_RIGHT_LIST_ITEM")
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
end

---Update a key map item
---@param leftItemIndex number
---@param rightItem number
---@param control1 string
---@param control2 string
function PauseMenu:UpdateKeymap(leftItemIndex, rightItem, control1, control2)
    BeginScaleformMovieMethod(self._pause.handle, "UPDATE_KEYMAP_ITEM")
    ScaleformMovieMethodAddParamInt(leftItemIndex)
    ScaleformMovieMethodAddParamInt(rightItem)
    BeginTextCommandScaleformString("string")
    AddTextComponentSubstringKeyboardDisplay(control1)
    EndTextCommandScaleformString_2()
    BeginTextCommandScaleformString("string")
    AddTextComponentSubstringKeyboardDisplay(control2)
    EndTextCommandScaleformString_2()
    EndScaleformMovieMethod()
end

---Set right settings item boolean value
---@param leftItemIndex number
---@param rightItem number
---@param value boolean
function PauseMenu:SetRightSettingsItemBool(leftItemIndex, rightItem, value)
    self._pause:CallFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", leftItemIndex, rightItem, value)
end

---Set right settings item index
---@param leftItemIndex number
---@param rightItem number
---@param value number
function PauseMenu:SetRightSettingsItemIndex(leftItemIndex, rightItem, value)
    self._pause:CallFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", leftItemIndex, rightItem, value)
end

---Set right settings item value
---@param leftItemIndex number
---@param rightItem number
---@param value number
function PauseMenu:SetRightSettingsItemValue(leftItemIndex, rightItem, value)
    self._pause:CallFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", leftItemIndex, rightItem, value)
end

---Update right settings item label
---@param leftItemIndex number
---@param rightItem number
---@param label string
function PauseMenu:UpdateItemRightLabel(leftItemIndex, rightItem, label)
    self._pause:CallFunction("UPDATE_RIGHT_ITEM_RIGHT_LABEL", leftItemIndex, rightItem, label)
end

---Update Stats Item Basic
---@param leftItemIndex number
---@param rightItem number
---@param label string
---@param rightLabel string
function PauseMenu:UpdateStatsItemBasic(leftItemIndex, rightItem, label, rightLabel)
    self._pause:CallFunction("UPDATE_RIGHT_STATS_ITEM", leftItemIndex, rightItem, label, rightLabel)
end

---Update Stats Item Bar
---@param leftItemIndex number
---@param rightItem number
---@param label string
---@param value number
---@param color SColor | nil Sets the color of the bar (default: SColor.HUD_Freemode)
function PauseMenu:UpdateStatsItemBar(leftItemIndex, rightItem, label, value, color)
    self._pause:CallFunction("UPDATE_RIGHT_STATS_ITEM", leftItemIndex, rightItem, label, value, color)
end

---Update Item Colored Bar
---@param leftItemIndex number
---@param rightItem number
---@param color SColor | nil Sets the color of the bar (default: SColor.HUD_Freemode)
function PauseMenu:UpdateItemColoredBar(leftItemIndex, rightItem, color)
    if (color == nil or color == SColor.HUD_None) then
        self._pause:CallFunction("UPDATE_COLORED_BAR_COLOR", leftItemIndex, rightItem, SColor.HUD_Freemode)
    else
        self._pause:CallFunction("UPDATE_COLORED_BAR_COLOR", leftItemIndex, rightItem, color)
    end
end

---Send an input event to the pause menu
---@param direction any
---@return string
function PauseMenu:SendInputEvent(direction) -- to be awaited
    return self._pause:CallFunctionAsyncReturnString("SET_INPUT_EVENT", direction)
end

---Send a scroll event to the pause menu
---@param direction number
function PauseMenu:SendScrollEvent(direction)
    self._pause:CallFunction("SET_SCROLL_EVENT", direction)
end

---Send a click event to the pause menu
---@return string
function PauseMenu:SendClickEvent() -- to be awaited
    return self._pause:CallFunctionAsyncReturnString("MOUSE_CLICK_EVENT")
end

---Dispose the pause menu
function PauseMenu:Dispose()
    self._pause:CallFunction("CLEAR_ALL")
    self._header:CallFunction("CLEAR_ALL")
    self._lobby:CallFunction("CLEAR_ALL")
    self._pause:Dispose()
    self._header:Dispose()
    self._lobby:Dispose()
    --self._pauseBG:Dispose()
    self._visible = false
    self.firstTick = true;
end

---Draw the pause menu
---@param isLobby boolean|nil
function PauseMenu:Draw(isLobby)
    if isLobby == nil then isLobby = false end
    if self._visible then
        if IsFrontendReadyForControl() then
            SetScriptGfxDrawBehindPausemenu(true);
            if IsUsingKeyboard(2) then
                SetMouseCursorActiveThisFrame()
            end
            if self.firstTick then
                self:FadeInMenus()
                self.firstTick = false;
            end
            if self.BGEnabled then
                self._pauseBG:Render2D()
            end
            self._header:Render2DNormal(0.501, 0.162, 0.6782, 0.145)
            if isLobby then
                self._lobby:Render2DNormal(0.6617187, 0.7226667, 1.0, 1.0)
            else
                self._pause:Render2DNormal(0.6617187, 0.7226667, 1.0, 1.0)
            end
        end
    end
end
