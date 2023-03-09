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
---@field public Items SettingsListItem[]
---@field public OnIndexChanged fun(index: number)

function SettingsListColumn.New(label, color)
    local _data = {
        _label = label or "",
        _color = color or 116,
        _currentSelection = 0,
        _rightLabel = "",
        Order = 0,
        Parent = nil,
        ParentTab = 0,
        Items = {},
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
        self.Items[self:CurrentSelection()]:Selected(true)
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
    end
end

function SettingsListColumn:AddSettings(item)
    item.ParentColumn = self
    self.Items[#self.Items + 1] = item
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
