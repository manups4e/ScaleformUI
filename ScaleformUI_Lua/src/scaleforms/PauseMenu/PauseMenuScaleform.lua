PauseMenu = setmetatable({}, PauseMenu)
PauseMenu.__index = PauseMenu
PauseMenu.__call = function()
    return "PauseMenu"
end

---@class PauseMenu

function PauseMenu.New()
    local _data = {
        _header = nil,
        _pause = nil,
        _lobby = nil,
        Loaded = false,
        _visible = false,
    }
    return setmetatable(_data, PauseMenu)
end

function PauseMenu:Visible(visible)
    if ToBool(visible) then
        self._visible = visible
    else
        return self._visible
    end
end

function PauseMenu:Load()
    if (self._header ~= nil and self._pause ~= nil and self._lobby ~= nil) then return end
    self._header = Scaleform.Request("pausemenuheader")
    self._pause = Scaleform.Request("pausemenu")
    self._lobby = Scaleform.Request("lobbymenu")
    self.Loaded = self._header:IsLoaded() and self._pause:IsLoaded() and self._lobby:IsLoaded()
end

function PauseMenu:SetHeaderTitle(title, subtitle, shiftUpHeader)
    if (subtitle == nil) then subtitle = "" end
    if (shiftUpHeader == nil) then shiftUpHeader = false end
    self._header:CallFunction("SET_HEADER_TITLE", false, title, subtitle, shiftUpHeader)
end

function PauseMenu:SetHeaderDetails(topDetail, midDetail, botDetail)
    self._header:CallFunction("SET_HEADER_DETAILS", false, topDetail, midDetail, botDetail, false)
end

function PauseMenu:ShiftCoronaDescription(shiftDesc, hideTabs)
    self._header:CallFunction("SHIFT_CORONA_DESC", false, shiftDesc, hideTabs)
end

function PauseMenu:ShowHeadingDetails(show)
    self._header:CallFunction("SHOW_HEADING_DETAILS", false, show)
end

function PauseMenu:SetHeaderCharImg(txd, charTexturePath, show)
    self._header:CallFunction("SET_HEADER_CHAR_IMG", false, txd, charTexturePath, show)
end

function PauseMenu:SetHeaderSecondaryImg(txd, charTexturePath, show)
    self._header:CallFunction("SET_HEADER_CREW_IMG", false, txd, charTexturePath, show)
end

function PauseMenu:HeaderGoRight()
    self._header:CallFunction("GO_RIGHT", false)
end

function PauseMenu:HeaderGoLeft()
    self._header:CallFunction("GO_LEFT", false)
end

function PauseMenu:AddPauseMenuTab(title, _type, _tabContentType, color)
    if color == nil then color = 116 end
    self._header:CallFunction("ADD_HEADER_TAB", false, title, _type, color)
    self._pause:CallFunction("ADD_TAB", false, _tabContentType)
end

function PauseMenu:AddLobbyMenuTab(title, _type, _tabContentType, color)
    if color == nil then color = 116 end
    self._header:CallFunction("ADD_HEADER_TAB", false, title, _type, color)
end

function PauseMenu:SelectTab(tab)
    self._header:CallFunction("SET_TAB_INDEX", false, tab)
    self._pause:CallFunction("SET_TAB_INDEX", false, tab)
end

function PauseMenu:SetFocus(focus)
    self._pause:CallFunction("SET_FOCUS", false, focus)
end

function PauseMenu:AddLeftItem(tab, _type, title, itemColor, highlightColor, enabled)
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

function PauseMenu:AddRightTitle(tab, leftItem, title)
    self._pause:CallFunction("ADD_RIGHT_TITLE", false, tab, leftItem, title)
end

function PauseMenu:AddRightListLabel(tab, leftItem, label)
    AddTextEntry("PauseMenu_" .. tab .. "_" .. leftItem, label)
    BeginScaleformMovieMethod(self._pause.handle, "ADD_RIGHT_LIST_ITEM")
    ScaleformMovieMethodAddParamInt(tab)
    ScaleformMovieMethodAddParamInt(leftItem)
    ScaleformMovieMethodAddParamInt(0)
    BeginTextCommandScaleformString("PauseMenu_" .. tab .. "_" .. leftItem)
    EndTextCommandScaleformString_2()
    EndScaleformMovieMethod()
end

function PauseMenu:AddRightStatItemLabel(tab, leftItem, label, rightLabel)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 1, 0, label, rightLabel)
end

function PauseMenu:AddRightStatItemColorBar(tab, leftItem, label, value, barColor)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 1, 1, label, value, barColor)
end

function PauseMenu:AddRightSettingsBaseItem(tab, leftItem, label, rightLabel, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 0, label, enabled, rightLabel)
end

function PauseMenu:AddRightSettingsListItem(tab, leftItem, label, items, startIndex, enabled)
    local stringList = table.concat(items, ",")
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 1, label, enabled, stringList, startIndex)
end

function PauseMenu:AddRightSettingsProgressItem(tab, leftItem, label, max, color, index, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 2, label, enabled, max, color, index)
end

function PauseMenu:AddRightSettingsProgressItemAlt(tab, leftItem, label, max, color, index, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 3, label, enabled, max, color, index)
end

function PauseMenu:AddRightSettingsSliderItem(tab, leftItem, label, max, color, index, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 5, label, enabled, max, color, index)
end

function PauseMenu:AddRightSettingsCheckboxItem(tab, leftItem, label, style, check, enabled)
    self._pause:CallFunction("ADD_RIGHT_LIST_ITEM", false, tab, leftItem, 2, 4, label, enabled, style, check)
end

function PauseMenu:AddKeymapTitle(tab, leftItem, title, rightLabel_1, rightLabel_2)
    self._pause:CallFunction("ADD_RIGHT_TITLE", false, tab, leftItem, title, rightLabel_1, rightLabel_2)
end

function PauseMenu:AddKeymapItem(tab, leftItem, label, control1, control2)
    BeginScaleformMovieMethod(self._pause.handle, "ADD_RIGHT_LIST_ITEM")
    ScaleformMovieMethodAddParamInt(tab)
    ScaleformMovieMethodAddParamInt(leftItem)
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

function PauseMenu:UpdateKeymap(tab, leftItem, rightItem, control1, control2)
    BeginScaleformMovieMethod(self._pause.handle, "UPDATE_KEYMAP_ITEM")
    ScaleformMovieMethodAddParamInt(tab)
    ScaleformMovieMethodAddParamInt(leftItem)
    ScaleformMovieMethodAddParamInt(rightItem)
    BeginTextCommandScaleformString("string")
    AddTextComponentSubstringKeyboardDisplay(control1)
    EndTextCommandScaleformString_2()
    BeginTextCommandScaleformString("string")
    AddTextComponentSubstringKeyboardDisplay(control2)
    EndTextCommandScaleformString_2()
    EndScaleformMovieMethod()
end

function PauseMenu:SetRightSettingsItemBool(tab, leftItem, rightItem, value)
    self._pause:CallFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", false, tab, leftItem, rightItem, value)
end

function PauseMenu:SetRightSettingsItemIndex(tab, leftItem, rightItem, value)
    self._pause:CallFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", false, tab, leftItem, rightItem, value)
end

function PauseMenu:SetRightSettingsItemValue(tab, leftItem, rightItem, value)
    self._pause:CallFunction("SET_RIGHT_SETTINGS_ITEM_VALUE", false, tab, leftItem, rightItem, value)
end

function PauseMenu:UpdateItemRightLabel(tab, leftItem, rightItem, label)
    self._pause:CallFunction("UPDATE_RIGHT_ITEM_RIGHT_LABEL", false, tab, leftItem, rightItem, label)
end

function PauseMenu:UpdateStatsItemBasic(tab, leftItem, rightItem, label, rightLabel)
    self._pause:CallFunction("UPDATE_RIGHT_STATS_ITEM", false, tab, leftItem, rightItem, label, rightLabel)
end

function PauseMenu:UpdateStatsItemBar(tab, leftItem, rightItem, label, value, color)
    self._pause:CallFunction("UPDATE_RIGHT_STATS_ITEM", false, tab, leftItem, rightItem, label, value, color)
end

function PauseMenu:UpdateItemColoredBar(tab, leftItem, rightItem, color)
    if (color == nil or color == Colours.NONE) then
        self._pause:CallFunction("UPDATE_COLORED_BAR_COLOR", false, tab, leftItem, rightItem, Colours.HUD_COLOUR_WHITE)
    else
        self._pause:CallFunction("UPDATE_COLORED_BAR_COLOR", false, tab, leftItem, rightItem, color)
    end
end

function PauseMenu:SendInputEvent(direction) -- to be awaited
    local return_value = self._pause:CallFunction("SET_INPUT_EVENT", true, direction) --[[@as number]]
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    return GetScaleformMovieMethodReturnValueString(return_value)
end

function PauseMenu:SendScrollEvent(direction) -- to be awaited
    self._pause:CallFunction("SET_SCROLL_EVENT", false, direction)
end

function PauseMenu:SendClickEvent() -- to be awaited
    local return_value = self._pause:CallFunction("MOUSE_CLICK_EVENT", true) --[[@as number]]
    while not IsScaleformMovieMethodReturnValueReady(return_value) do
        Citizen.Wait(0)
    end
    return GetScaleformMovieMethodReturnValueString(return_value)
end

function PauseMenu:Dispose()
    self._pause:CallFunction("CLEAR_ALL", false)
    self._header:CallFunction("CLEAR_ALL", false)
    self._lobby:CallFunction("CLEAR_ALL", false)
    self._visible = false
end

function PauseMenu:Draw(isLobby)
    if isLobby == nil then isLobby = false end
    if self._visible and GetCurrentFrontendMenuVersion() == -2060115030 then
        SetScriptGfxDrawBehindPausemenu(true)
        if IsUsingKeyboard(2) then
            SetMouseCursorActiveThisFrame()
        end
        self._header:Render2DNormal(0.501, 0.162, 0.6782, 0.145)
        if isLobby then
            self._lobby:Render2DNormal(0.6617187, 0.7226667, 1.0, 1.0)
        else
            self._pause:Render2DNormal(0.6617187, 0.7226667, 1.0, 1.0)
        end
    end
end
