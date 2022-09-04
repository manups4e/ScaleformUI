SettingsListColumn = setmetatable({}, SettingsListColumn)
SettingsListColumn.__index = SettingsListColumn
SettingsListColumn.__call = function()
    return "Column", "SettingsListColumn"
end

function SettingsListColumn.New(label, color)
    local _data = {
        _label = label or "",
        _color = color or 116,
        _currentSelection = 0,
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
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", false, self:CurrentSelection()-1)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", false, self.ParentTab, self:CurrentSelection()-1)
            end
        end
    end
end

function SettingsListColumn:AddSettings(item)
    item.ParentColumn = self
    self.Items[#self.Items + 1] = item
end

