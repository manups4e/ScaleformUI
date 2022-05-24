FriendItem = setmetatable({}, FriendItem)
FriendItem.__index = FriendItem
FriendItem.__call = function()
    return "LobbyItem", "FriendItem"
end

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
        _coloredTag = true,
        ParentColumn = nil,
        Panel = nil
    }
    return setmetatable(_data, FriendItem)
end

function FriendItem:Label(label)
    if label == nil then
        return self._label
    else
        self._label = label
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            ScaleformUI.Scaleforms.PauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_LABEL", false, idx, self._label)
        end
    end
end

function FriendItem:ItemColor(color)
    if color == nil then
        return self._itemColor
    else
        self._itemColor = color
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            ScaleformUI.Scaleforms.PauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_COLOUR", false, idx, self._itemColor, self._coloredTag)
        end
    end
end

function FriendItem:ColoredTag(bool)
    if bool == nil then
        return self._coloredTag
    else
        self._coloredTag = bool
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            ScaleformUI.Scaleforms.PauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_COLOUR", false, idx, self._itemColor, self._coloredTag)
        end
    end
end

function FriendItem:Rank(rank)
    if rank == nil then
        return self._rank
    else
        self._rank = rank
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            ScaleformUI.Scaleforms.PauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_RANK", false, idx, self._rank)
        end
    end
end

function FriendItem:Status(status)
    if status == nil then
        return self._status
    else
        self._status = status
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            ScaleformUI.Scaleforms.PauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_STATUS", false, idx, self._status, self._statusColor)
        end
    end
end

function FriendItem:StatusColor(color)
    if color == nil then
        return self._statusColor
    else
        self._statusColor = color
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            ScaleformUI.Scaleforms.PauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_STATUS", false, idx, self._status, self._statusColor)
        end
    end
end

function FriendItem:CrewTag(tag)
    if tag == nil then
        return self._crewTag
    else
        self._crewTag = tag
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = IndexOf(self.ParentColumn.Items, self) - 1
            ScaleformUI.Scaleforms.PauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_CREW", false, idx, self._crewTag)
        end
    end
end

function FriendItem:SetLeftIcon(icon, isBadge)
    self._iconL = icon;
    self._boolL = isBadge or false;
    if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
        local idx = IndexOf(self.ParentColumn.Items, self) - 1
        ScaleformUI.Scaleforms.PauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_ICON_LEFT", false, idx, self._iconL, self._boolL)
    end
end

function FriendItem:SetRightIcon(icon, isBadge)
    self._iconR = icon;
    self._boolR = isBadge or false;
    if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
        local idx = IndexOf(self.ParentColumn.Items, self) - 1
        ScaleformUI.Scaleforms.PauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_ICON_RIGHT", false, idx, self._iconR, self._boolR)
    end
end

function FriendItem:Selected(bool, item)
    if bool ~= nil then
        self._Selected = tobool(bool)
    else
        return self._Selected
    end
end

function FriendItem:Hovered(bool)
    if bool ~= nil then
        self._Hovered = tobool(bool)
    else
        return self._Hovered
    end
end

function FriendItem:Enabled(bool, item)
    if bool ~= nil then
        self._Enabled = tobool(bool)
    else
        return self._Enabled
    end
end

function FriendItem:AddPanel(panel)
    panel.ParentItem = self
    self.Panel = panel
end
