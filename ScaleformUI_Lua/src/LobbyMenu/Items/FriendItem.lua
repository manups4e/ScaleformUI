FriendItem = setmetatable({}, FriendItem)
FriendItem.__index = FriendItem
FriendItem.__call = function()
    return "LobbyItem", "FriendItem"
end

---@class FriendItem
---@field public Label string
---@field public ItemColor number
---@field public ColoredTag boolean
---@field public Rank number
---@field public Status string
---@field public StatusColor number
---@field public CrewTag string
---@field public _iconL number
---@field public _iconR number
---@field public _boolL boolean
---@field public _boolR boolean
---@field public ParentColumn PlayerListColumn
---@field public ClonePed number
---@field public Panel PlayerStatsPanel
---@field public Handle number
---@field public SetLeftIcon fun(icon:number, bool:boolean):nil
---@field public SetRightIcon fun(icon:number, bool:boolean):nil
---@field public AddPedToPauseMenu fun(ped:number):number
---@field public AddPanel fun(panel: PlayerStatsPanel)
---@field public Enabled fun(enabled:boolean):boolean

---Creates a new FriendItem.
---@param label string
---@param itemColor number
---@param coloredTag boolean
---@param rank number
---@param status string
---@param crewTag string
---@return FriendItem
function FriendItem.New(label, itemColor, coloredTag, rank, status, crewTag)
    if itemColor == -1 then itemColor = 9 end
    local _data = {
        _type = 1,
        _Enabled = true,
        _Selected = false,
        _Hovered = false,
        _label = label or "",
        _itemColor = itemColor or 9,
        _rank = rank or 0,
        _status = status or "",
        _statusColor = itemColor,
        _crewTag = crewTag or "",
        _iconL = 0,
        _iconR = 65,
        _boolL = false,
        _boolR = false,
        _coloredTag = coloredTag or true,
        ParentColumn = nil,
        ClonePed = 0,
        Panel = nil,
        Handle = nil,
    }
    return setmetatable(_data, FriendItem)
end

---Sets the label of the item if supplied else it will return the current label.
---@param label string|nil
---@return string
function FriendItem:Label(label)
    if label ~= nil then
        self._label = label
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_LABEL", false, idx, self._label)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_LABEL", false,
                    self.ParentColumn.ParentTab, idx, self._label)
            end
        end
    end
    return self._label
end

---Adds a ped to the pause menu or returns the current ped.
---@param ped number|nil If the ped parameter is 0 it will clear the ped.
---@return number -- If the ped parameter is 0 it will return -1.
function FriendItem:AddPedToPauseMenu(ped)
    if ped ~= nil then
        self.ClonePed = ped
        if ped == 0 then
            ClearPedInPauseMenu()
            return -1
        end
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            if self.Panel ~= nil then
                self.Panel.UpdatePanel()
            end
            local pSubT = self.ParentColumn.Parent()
            Citizen.CreateThread(function()
                Wait(100)
                if pSubT == "LobbyMenu" then
                    if self.ParentColumn.Items[self.ParentColumn:CurrentSelection()] == self then
                        local ped = ClonePed(self.ClonePed, false, false, true)
                        FinalizeHeadBlend(ped)
                        GivePedToPauseMenu(ped, 2);
                        SetPauseMenuPedSleepState(true)
                        SetPauseMenuPedLighting(true)
                    end
                elseif pSubT == "PauseMenu" then
                    local tab = self.ParentColumn.Parent.Tabs[self.ParentColumn.Parent.Index]
                    local _, subT = tab()
                    if subT == "PlayerListTab" then
                        if self.ParentColumn.Items[self.ParentColumn:CurrentSelection()] == self then
                            local ped = ClonePed(self.ClonePed, false, false, true)
                            FinalizeHeadBlend(ped)
                            GivePedToPauseMenu(ped, 2);
                            SetPauseMenuPedSleepState(true)
                            SetPauseMenuPedLighting(self.ParentColumn.Parent:FocusLevel() ~= 0);
                        end
                    end
                end
            end)
        end
    end
    return self.ClonePed
end

---Sets the item color of the item if supplied else it will return the current item color.
function FriendItem:ItemColor(color)
    if color ~= nil then
        self._itemColor = color
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_COLOUR", false, idx,
                    self._itemColor, self._coloredTag)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_COLOUR", false,
                    self.ParentColumn.ParentTab, idx, self._itemColor, self._coloredTag)
            end
        end
    end
    return self._itemColor
end

-- Sets if the item color should be used for the crew tag, if the argument is nil it will return the current value.
---@param enableColorTag boolean
---@return boolean
function FriendItem:ColoredTag(enableColorTag)
    if enableColorTag ~= nil then
        self._coloredTag = enableColorTag
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_COLOUR", false, idx,
                    self._itemColor, self._coloredTag)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_COLOUR", false,
                    self.ParentColumn.ParentTab, idx, self._itemColor, self._coloredTag)
            end
        end
    end
    return self._coloredTag
end

---Sets the rank of the item if supplied else it will return the current rank.
---@param rank number|nil
---@return number
function FriendItem:Rank(rank)
    if rank ~= nil then
        self._rank = rank
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_RANK", false, idx, self._rank)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_RANK", false,
                    self.ParentColumn.ParentTab, idx, self._rank)
            end
        end
    end
    return self._rank
end

---Sets the status of the item if supplied else it will return the current status.
---@param status string|nil
---@return string
function FriendItem:Status(status)
    if status ~= nil then
        self._status = status
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_STATUS", false, idx, self._status,
                    self._statusColor)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_STATUS", false,
                    self.ParentColumn.ParentTab, idx, self._status, self._statusColor)
            end
        end
    end
    return self._status
end

---Sets the status color of the item if supplied else it will return the current status color.
---@param color number
---@return number
function FriendItem:StatusColor(color)
    if color ~= nil then
        self._statusColor = color
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_STATUS", false, idx, self._status,
                    self._statusColor)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_STATUS", false,
                    self.ParentColumn.ParentTab, idx, self._status, self._statusColor)
            end
        end
    end
    return self._statusColor
end

---Sets the crew tag of the item if supplied else it will return the current crew tag.
---@param tag string|nil
---@return string
function FriendItem:CrewTag(tag)
    if tag ~= nil then
        self._crewTag = tag
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_CREW", false, idx, self._crewTag)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_CREW", false,
                    self.ParentColumn.ParentTab, idx, self._crewTag)
            end
        end
    end
    return self._crewTag
end

---Sets the left icon of the item.
---@param icon string|nil
---@param isBadge boolean|nil
function FriendItem:SetLeftIcon(icon, isBadge)
    self._iconL = icon;
    self._boolL = isBadge or false;
    if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
        local idx = IndexOf(self.ParentColumn.Items, self) - 1
        local pSubT = self.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_ICON_LEFT", false, idx, self._iconL,
                self._boolL)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ICON_LEFT", false,
                self.ParentColumn.ParentTab, idx, self._iconL, self._boolL)
        end
    end
end

---Sets the right icon of the item.
---@param icon string|nil
---@param isBadge boolean|nil
function FriendItem:SetRightIcon(icon, isBadge)
    self._iconR = icon;
    self._boolR = isBadge or false;
    if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
        local idx = IndexOf(self.ParentColumn.Items, self) - 1
        local pSubT = self.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_ICON_RIGHT", false, idx, self._iconR,
                self._boolR)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ICON_RIGHT", false,
                self.ParentColumn.ParentTab, idx, self._iconR, self._boolR)
        end
    end
end

---Sets the selected state of the item if supplied else it will return the current selected state.
---@param bool boolean|nil
---@return boolean
function FriendItem:Selected(bool)
    if bool ~= nil then
        self._Selected = ToBool(bool)
    end
    return self._Selected
end

---Sets the hovered state of the item if supplied else it will return the current hovered state.
function FriendItem:Hovered(bool)
    if bool ~= nil then
        self._Hovered = ToBool(bool)
    end
    return self._Hovered
end

---Sets the enabled state of the item if supplied else it will return the current enabled state.
function FriendItem:Enabled(bool)
    if bool ~= nil then
        self._Enabled = ToBool(bool)
    end
    return self._Enabled
end

---Adds a player stats panel to the item.
---@param panel PlayerStatsPanel
function FriendItem:AddPanel(panel)
    panel.ParentItem = self
    self.Panel = panel
    self.Panel.UpdatePanel()
end
