MissionItem = setmetatable({}, MissionItem)
MissionItem.__index = MissionItem
MissionItem.__call = function()
    return "LobbyItem", "MissionItem"
end

function MissionItem.New(label, mainColor, highlightColor)
    local _data = {
        Label = label,
        Handle = nil,
        ParentColumn = nil,
        enabled = true,
        MainColor = mainColor or Colours.HUD_COLOUR_PAUSE_BG,
        HighlightColor = highlightColor or Colours.HUD_COLOUR_WHITE,
        LeftIcon = BadgeStyle.NONE,
        LeftIconColor = Colours.HUD_COLOUR_WHITE,
        RightIcon = BadgeStyle.NONE,
        RightIconColor = Colours.HUD_COLOUR_WHITE,
        RightIconChecked = false,
        _Selected = false,
        hovered = false
    }
    return setmetatable(_data, MissionItem)
end

function MissionItem:Hovered(val)
    if val == nil then
        return self.hovered
    else
        self.hovered = val
    end
end

function MissionItem:Enabled(bool)
    if bool == nil then
        return self.enabled
    else
        self.enabled = bool
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self))
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSION_ITEM_ENABLED", false, idx, bool)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSION_ITEM_ENABLED", false, self.ParentColumn.ParentTab, idx, bool)
            end
        end
    end
end

function MissionItem:SetLeftIcon(icon, color)
    self.LeftIcon = icon
    self.LeftIconColor = color
    if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
        local idx = self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self))
        local pSubT = self.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSION_ITEM_LEFT_ICON", false, idx, icon, color)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSION_ITEM_LEFT_ICON", false, self.ParentColumn.ParentTab, idx, icon, color)
        end
    end
end

function MissionItem:SetRightIcon(icon, color, checked)
    self.RightIcon = icon
    self.RightIconColor = color
    self.RightIconChecked = checked or false
    if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
        local idx = self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self))
        local pSubT = self.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSION_ITEM_RIGHT_ICON", false, idx, icon, checked, color)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSION_ITEM_RIGHT_ICON", false, self.ParentColumn.ParentTab, idx, icon, checked or false, color)
        end
    end
end

function MissionItem:Selected(bool)
    if bool == nil then
        return self._Selected
    else
        self._Selected = bool
    end
end