PauseMenu = {}

local Pause = {}
Pause = setmetatable({}, Pause)

Pause.__call = function()
    return true
end
Pause.__index = Pause


function PauseMenu.New()
    local _data = {
        _header = nil,
        _pause = nil,
        _lobby = nil,
        Loaded = false,
        _visible = false,
    }
    return setmetatable(_data, Pause)
end

function Pause:Visible(visible)
    if tobool(visible) then
        self._visible = visible
    else
        return self._visible
    end
end

function Pause:Load()
    if(self._header ~= nil and self._pause ~= nil and self._lobby ~= nil) then return end
    self._header = Scaleform.Request("pausemenuheader")
    self._pause = Scaleform.Request("pausemenu")
    self._lobby = Scaleform.Request("lobbymenu")
    self.Loaded = self._header:IsLoaded() and self._pause:IsLoaded() and self._lobby:IsLoaded()
end

function Pause:SetHeaderTitle(title, subtitle, shiftUpHeader)
    if(subtitle == nil) then subtitle = "" end
    if(shiftUpHeader == nil) then shiftUpHeader = false end
    self._header:CallFunction("SET_HEADER_TITLE", false, title, subtitle, shiftUpHeader)
end

function Pause:SetHeaderDetails(topDetail, midDetail, botDetail)
    self._header:CallFunction("SET_HEADER_DETAILS", false, topDetail, midDetail, botDetail, false)
end

function Pause:ShiftCoronaDescription(shiftDesc, hideTabs)
    self._header:CallFunction("SHIFT_CORONA_DESC", false, shiftDesc, hideTabs)
end

function Pause:ShowHeadingDetails(show)
    self._header:CallFunction("SHOW_HEADING_DETAILS", false, show)
end

function Pause:SetHeaderCharImg(txd, charTexturePath, show)
    self._header:CallFunction("SET_HEADER_CHAR_IMG", false, txd, charTexturePath, show)
end

function Pause:SetHeaderSecondaryImg(txd, charTexturePath, show)
    self._header:CallFunction("SET_HEADER_CREW_IMG", false, txd, charTexturePath, show)
end

function Pause:HeaderGoRight()
    self._header:CallFunction("GO_RIGHT", false)
end

function Pause:HeaderGoLeft()
    self._header:CallFunction("GO_LEFT", false)
end

function Pause:AddPauseMenuTab(title, _type, _tabContentType, color)
    if color == nil then color = 116 end
    self._header:CallFunction("ADD_HEADER_TAB", false, title, _type, color)
    self._pause:CallFunction("ADD_TAB", false, _tabContentType)
end

function Pause:AddLobbyMenuTab(title, _type, _tabContentType, color)
    if color == nil then color = 116 end
    self._header:CallFunction("ADD_HEADER_TAB", false, title, _type, color)
end

function Pause:SelectTab(tab)
    self._header:CallFunction("SET_TAB_INDEX", false, tab)
    self._pause:CallFunction("SET_TAB_INDEX", false, tab)
end

function Pause:SetFocus(focus)
    self._pause:CallFunction("SET_FOCUS", false, focus)
end

function Pause:AddLeftItem(tab, _type, title, itemColor, highlightColor, enabled)
    if itemColor == nil then itemColor = Colours.NONE end
    if highlightColor == nil then highlightColor = Colours.NONE end

    if itemColor ~= Colours.NONE and highlightColor == Colours.NONE then
        self._pause:CallFunction("ADD_LEFT_ITEM", false, tab, _type, title, enabled, itemColor)
    elseif (itemColor ~= Colours.NONE and highlightColor ~= Colours.NONE) then
        self._pause:CallFunction("ADD_LEFT_ITEM", false, tab, _type, title, enabled, itemColor, highlightColor)
    else
        self._pause:CallFunction("ADD_LEFT_ITEM", false, tab, _type, title, enabled)
    end

end

function Pause:AddRightTitle(tab, leftItem, title)
    self._pause:CallFunction("ADD_RIGHT_TITLE", false, tab, leftItem, title)
end

function Pause:AddRightListLabel(tab, leftItem, label)
    AddTextEntry("PauseMenu_"..tab.."_"..leftItem, label)
    BeginScaleformMovieMethod(self._pause.handle, "ADD_RIGHT_LIST_ITEM")
    ScaleformMovieMethodAddParamInt(tab)
    ScaleformMovieMethodAddParamInt(leftItem)
    ScaleformMovieMethodAddParamInt(0)
    BeginTextCommandScaleformString("PauseMenu_"..tab.."_"..leftItem)
    EndTextCommandScaleformString_2()
    EndScaleformMovieMethod()
end

function Pause:AddRightStatItemLabel(tab, leftItem, label, rightLabel)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 1, 0, label, rightLabel)
end

function Pause:AddRightStatItemColorBar(tab, leftItem, label, value, barColor)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 1, 1, label, value, barColor)
end

function Pause:AddRightSettingsBaseItem(tab, leftItem, label, rightLabel, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 0, label, enabled, rightLabel)
end

function Pause:AddRightSettingsListItem(tab, leftItem, label, items, startIndex, enabled)
    local stringList = table.concat(items, ",")
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 1, label, enabled, stringList, startIndex)
end

function Pause:AddRightSettingsProgressItem(tab, leftItem, label, max, color, index, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 2, label, enabled, max, color, index)
end

function Pause:AddRightSettingsProgressItemAlt(tab, leftItem, label, max, color, index, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 3, label, enabled, max, color, index)
end

function Pause:AddRightSettingsSliderItem(tab, leftItem, label, max, color, index, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 5, label, enabled, max, color, index)
end

function Pause:AddRightSettingsCheckboxItem(tab, leftItem, label, style, check, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 4, label, enabled, style, check)
end

function Pause:AddKeymapTitle(tab, leftItem, title, rightLabel_1, rightLabel_2)
    self._pause:CallFunction("ADD_RIGHT_TITLE", false, tab, leftItem, title, rightLabel_1, rightLabel_2)
end

function Pause:AddKeymapItem(tab, leftItem, label, control1, control2)
    BeginScaleformMovieMethod(self._pause.handle, "ADD_RIGHT_LIST_ITEM")
    ScaleformMovieMethodAddParamInt(tab)
    ScaleformMovieMethodAddParamInt(leftItem)
    ScaleformMovieMethodAddParamInt(3)
    PushScaleformMovieFunctionParameterString(label)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(control1)
    EndTextCommandScaleformString_2()
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(control2)
    EndTextCommandScaleformString_2()
    EndScaleformMovieMethod()
end

function Pause:UpdateKeymap(tab, leftItem, rightItem, control1, control2)
    BeginScaleformMovieMethod(self._pause.handle, "UPDATE_KEYMAP_ITEM")
    ScaleformMovieMethodAddParamInt(tab)
    ScaleformMovieMethodAddParamInt(leftItem)
    ScaleformMovieMethodAddParamInt(rightItem)
    BeginTextCommandScaleformString("string")
    AddTextComponentScaleform(control1)
    EndTextCommandScaleformString_2()
    BeginTextCommandScaleformString("string")
    AddTextComponentScaleform(control2)
    EndTextCommandScaleformString_2()
    EndScaleformMovieMethod()
end

function Pause:SetRightSettingsItemBool(tab, leftItem, rightItem, value)
    self._pause:CallFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", false, tab, leftItem, rightItem, value)
end

function Pause:SetRightSettingsItemIndex(tab, leftItem, rightItem, value)
    self._pause:CallFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", false, tab, leftItem, rightItem, value)
end

function Pause:SetRightSettingsItemValue(tab, leftItem, rightItem, value)
    self._pause:CallFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", false, tab, leftItem, rightItem, value)
end

function Pause:UpdateItemRightLabel(tab, leftItem, rightItem, label)
    self._pause:CallFunction("UPDATE_RIGHT_ITEM_RIGHT_LABEL", false, tab, leftItem, rightItem, label)
end

function Pause:UpdateStatsItemBasic(tab, leftItem, rightItem, label, rightLabel)
    self._pause:CallFunction("UPDATE_RIGHT_STATS_ITEM", false, tab, leftItem, rightItem, label, rightLabel)
end

function Pause:UpdateStatsItemBar(tab, leftItem, rightItem, label, value, color)
    self._pause:CallFunction("UPDATE_RIGHT_STATS_ITEM", false, tab, leftItem, rightItem, label, value, color)
end

function Pause:UpdateItemColoredBar(tab, leftItem, rightItem, color)
    if(color == nil or color == Colours.NONE) then
        self._pause:CallFunction("UPDATE_COLORED_BAR_COLOR", false, tab, leftItem, rightItem, Colours.HUD_COLOUR_WHITE)
    else
        self._pause:CallFunction("UPDATE_COLORED_BAR_COLOR", false, tab, leftItem, rightItem, color)
    end
end

function Pause:SendInputEvent(direction) -- to be awaited
    local return_value = self._pause:CallFunction("SET_INPUT_EVENT", true, direction)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Wait(0)
    end
    return GetScaleformMovieFunctionReturnString(return_value)
end

function Pause:SendScrollEvent(direction) -- to be awaited
    self._pause:CallFunction("SET_SCROLL_EVENT", false, direction)
end

function Pause:SendClickEvent() -- to be awaited
    local return_value = self._pause:CallFunction("MOUSE_CLICK_EVENT", true)
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Wait(0)
    end
    return GetScaleformMovieFunctionReturnString(return_value)
end

function Pause:Dispose()
    self._pause:CallFunction("CLEAR_ALL", false)
    self._header:CallFunction("CLEAR_ALL", false)
    self._lobby:CallFunction("CLEAR_ALL", false)
    self._visible = false
end

function Pause:Draw(isLobby)
    if isLobby == nil then isLobby = false end
    if self._visible and GetCurrentFrontendMenuVersion() == -2060115030 then
        SetScriptGfxDrawBehindPausemenu(true)
        if IsInputDisabled(2) then
            ShowCursorThisFrame()
        end
        self._header:Render2DNormal(0.501, 0.162, 0.6782, 0.145)
        if isLobby then
            self._lobby:Render2DNormal(0.6617187, 0.7226667, 1.0, 1.0)
        else
            self._pause:Render2DNormal(0.6617187, 0.7226667, 1.0, 1.0)
        end
    end
end