SettingsListColumn = setmetatable({}, SettingsListColumn)
SettingsListColumn.__index = SettingsListColumn
SettingsListColumn.__call = function()
    return "Column", "SettingsListColumn"
end

---@class SettingsListColumn
---@field private _label string
---@field private _color number
---@field private _currentSelection number
---@field private _rightLabel string
---@field public Order number
---@field public Parent function
---@field public ParentTab number
---@field public Items table<number, UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem>
---@field public OnIndexChanged fun(index: number)
---@field public AddSettings fun(self: SettingsListColumn, item: SettingsListItem)

function SettingsListColumn.New(label, color)
    local _data = {
        _label = label or "",
        _color = color or 116,
        _currentSelection = 0,
        _rightLabel = "",
        Order = 0,
        Parent = nil,
        ParentTab = 0,
        Items = {} --[[@type table<number, UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem>]],
        OnIndexChanged = function(index)
        end
    }
    return setmetatable(_data, SettingsListColumn)
end

function SettingsListColumn:CurrentSelection(idx)
    if idx == nil then
        if #self.Items == 0 then
            return 1
        else
            if self._currentSelection % #self.Items == 0 then
                return 1
            else
                return (self._currentSelection % #self.Items) + 1
            end
        end
    else
        if #self.Items == 0 then
            self._currentSelection = 0
        end
        self.Items[self:CurrentSelection()]:Selected(false)
        self._currentSelection = 1000000 - (1000000 % #self.Items) + tonumber(idx)
        if self.Parent ~= nil and self.Parent:Visible() then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", false,
                    self:CurrentSelection() - 1)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", false,
                    self.ParentTab, self:CurrentSelection() - 1)
            end
        end
        self.Items[self:CurrentSelection()]:Selected(true)
    end
end

---Add a new item to the column.
---@param item UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem
function SettingsListColumn:AddSettings(item)
    local a,b = item()
    if b == "UIMenuItem" then
        item.ParentColumn = self
    else
        item.Base.ParentColumn = self
    end
    self.Items[#self.Items + 1] = item

    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            local it = IndexOf(self.Items, item)
            local Type, SubType = item()
            local descLabel = "menu_lobby_desc_{" .. it .. "}"
            AddTextEntry(descLabel, item:Description())

            if SubType == "UIMenuListItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 1, item.Base._formatLeftLabel,
                    descLabel, item:Enabled(), item:BlinkDescription(),
                    table.concat(item.Items, ","),
                    item:Index() - 1, item.Base._mainColor, item.Base._highlightColor, item.Base._textColor,
                    item.Base._highlightedTextColor)
            elseif SubType == "UIMenuCheckboxItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 2, item.Base._formatLeftLabel,
                    descLabel, item:Enabled(), item:BlinkDescription(), item.CheckBoxStyle,
                    item._Checked, item.Base._mainColor, item.Base._highlightColor, item.Base._textColor,
                    item.Base._highlightedTextColor)
            elseif SubType == "UIMenuSliderItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 3, item.Base._formatLeftLabel,
                    descLabel, item:Enabled(), item:BlinkDescription(), item._Max,
                    item._Multiplier,
                    item:Index(), item.Base._mainColor, item.Base._highlightColor, item.Base._textColor,
                    item.Base._highlightedTextColor, item.SliderColor, item._heritage)
            elseif SubType == "UIMenuProgressItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 4, item.Base._formatLeftLabel,
                    descLabel, item:Enabled(), item:BlinkDescription(), item._Max,
                    item._Multiplier,
                    item:Index(), item.Base._mainColor, item.Base._highlightColor, item.Base._textColor,
                    item.Base._highlightedTextColor, item.SliderColor)
            else
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, 0, item._formatLeftLabel,
                    descLabel, item:Enabled(), item:BlinkDescription(), item._mainColor,
                    item._highlightColor, item._textColor, item._highlightedTextColor)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", false, it - 1,
                    item._formatRightLabel)
                if item._rightBadge ~= BadgeStyle.NONE then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", false, it - 1,
                        item._rightBadge)
                end
            end
        
            if (SubType == "UIMenuItem" and item._leftBadge ~= BadgeStyle.NONE) or (SubType ~= "UIMenuItem" and item.Base._leftBadge ~= BadgeStyle.NONE) then
                if SubType ~= "UIMenuItem" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", false, it - 1, item.Base._leftBadge)
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", false, it - 1, item.Base._labelFont.FontName, item.Base._labelFont.FontID)
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", false, it - 1, item.Base._rightLabelFont.FontName, item.Base._rightLabelFont.FontID)
                else
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", false, it - 1, item._leftBadge)
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", false, it - 1, item._labelFont.FontName, item._labelFont.FontID)
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", false, it - 1, item._rightLabelFont.FontName, item._rightLabelFont.FontID)
                end
            end
        elseif pSubT == "PauseMenu" then
            local it = IndexOf(self.Items, item)
            local Type, SubType = item()
            local descLabel = "menu_pause_playerTab_{".. self.ParentTab .."}_{" .. it .. "}"
            AddTextEntry(descLabel, item:Description())
            if SubType == "UIMenuListItem" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                    tabIndex, 1, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                    item:BlinkDescription(), table.concat(item.Items, ","), item:Index() - 1,
                    item.Base._mainColor,
                    item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor)
            elseif SubType == "UIMenuCheckboxItem" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                    tabIndex, 2, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                    item:BlinkDescription(), item.CheckBoxStyle, item._Checked, item.Base._mainColor,
                    item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor)
            elseif SubType == "UIMenuSliderItem" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                    tabIndex, 3, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                    item:BlinkDescription(), item._Max, item._Multiplier, item:Index(), item.Base._mainColor,
                    item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor,
                    item.SliderColor, item._heritage)
            elseif SubType == "UIMenuProgressItem" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                    tabIndex, 4, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                    item:BlinkDescription(), item._Max, item._Multiplier, item:Index(), item.Base._mainColor,
                    item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor,
                    item.SliderColor)
            else
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                    tabIndex, 0, item._formatLeftLabel, descLabel, item:Enabled(),
                    item:BlinkDescription(), item._mainColor, item._highlightColor, item._textColor,
                    item._highlightedTextColor)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", false, tabIndex, it - 1, item._formatRightLabel)
                if item._rightBadge ~= BadgeStyle.NONE then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", false, tabIndex, it - 1, item._rightBadge)
                end
            end
            if (SubType == "UIMenuItem" and item._leftBadge ~= BadgeStyle.NONE) or (SubType ~= "UIMenuItem" and item.Base._leftBadge ~= BadgeStyle.NONE) then
                if SubType ~= "UIMenuItem" then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", false, tabIndex, it - 1, item.Base._leftBadge)
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", false, tabIndex, it - 1, item.Base._labelFont.FontName, item.Base._labelFont.FontID)
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", false, tabIndex, it - 1, item.Base._labelFont.FontName, item.Base._labelFont.FontID)
                else
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", false, tabIndex, it - 1, item._leftBadge)
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", false, tabIndex, it - 1, item._labelFont.FontName, item._labelFont.FontID)
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", false, tabIndex, it - 1, item._labelFont.FontName, item._labelFont.FontID)
                end
            end
        end
    end
end

function SettingsListColumn:UpdateItemLabels(index, leftLabel, rightLabel)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        self._label = leftLabel;
        self._rightLabel = rightLabel;
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABELS", false, index - 1,
                leftLabel, rightLabel)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABELS", false,
                self.ParentTab, index - 1, self._label, self._rightLabel)
        end
    end
end

function SettingsListColumn:UpdateItemBlinkDescription(index, blink)
    if blink == 1 then blink = true elseif blink == 0 then blink = false end
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_BLINK_DESC", false, index - 1,
                blink)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_BLINK_DESC", false,
                self.ParentTab, index - 1, self._label, self._rightLabel)
        end
    end
end

function SettingsListColumn:UpdateItemLabel(index, label)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        self._label = label;
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL", false, index - 1, label)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL", false,
                self.ParentTab, index - 1, self._label)
        end
    end
end

function SettingsListColumn:UpdateItemRightLabel(index, label)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        self._rightLabel = label;
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", false, index - 1,
                label)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", false,
                self.ParentTab, index - 1, self._rightLabel)
        end
    end
end

function SettingsListColumn:UpdateItemLeftBadge(index, badge)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", false, index - 1, badge)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", false,
                self.ParentTab, index - 1, badge)
        end
    end
end

function SettingsListColumn:UpdateItemRightBadge(index, badge)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", false, index - 1,
                badge)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", false,
                self.ParentTab, index - 1, badge)
        end
    end
end

function SettingsListColumn:EnableItem(index, enable)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ENABLE_SETTINGS_ITEM", false, index - 1, enable)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_PLAYERS_TAB_SETTINGS_ITEM", false,
                self.ParentTab, index - 1, enable)
        end
    end
end

function SettingsListColumn:Clear()
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_SETTINGS_COLUMN", false)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN", false, self.ParentTab)
        end
    end
end
