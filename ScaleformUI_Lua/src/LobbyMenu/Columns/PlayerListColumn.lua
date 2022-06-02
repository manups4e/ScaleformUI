PlayerListColumn = setmetatable({}, PlayerListColumn)
PlayerListColumn.__index = PlayerListColumn
PlayerListColumn.__call = function()
    return "Column", "PlayerListColumn"
end

function PlayerListColumn.New(label, color)
    local _data = {
        _label = label or "",
        _color = color or 116,
        _currentSelection = 0,
        Order = 0,
        Parent = nil,
        Items = {},
        OnIndexChanged = function(index)
        end
    }
    return setmetatable(_data, PlayerListColumn)
end

function PlayerListColumn:CurrentSelection(idx)
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
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYERS_SELECTION", false, self:CurrentSelection()-1)
        end
    end
end

function PlayerListColumn:AddPlayer(item)
    item.ParentColumn = self
    table.insert(self.Items, item)
    if self.Parent ~= nil and self.Parent:Visible() then
        local Type, SubType = item()
        if SubType == "FriendItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_PLAYER_ITEM", false, 1, 1, item:Label(), item:ItemColor(), item:ColoredTag(), item._iconL, item._boolL, item._iconR, item._boolR, item:Status(), item:StatusColor(), item:Rank(), item:CrewTag())
        end
        if item.Panel ~= nil then
            item.Panel:UpdatePanel(true)
        end
    end
end

function PlayerListColumn:RemovePlayer(id)
    table.remove(self.Items, id)
    if self.Parent ~= nil and self.Parent:Visible() then
        local Type, SubType = item()
        if SubType == "FriendItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("REMOVE_PLAYER_ITEM", id)
        end
    end
end