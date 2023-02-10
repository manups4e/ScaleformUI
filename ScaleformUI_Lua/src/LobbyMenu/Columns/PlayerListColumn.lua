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
        ParentTab = 0,
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
        if idx < 0 then
            self._currentSelection = 0
        elseif idx > #self.Items then
            self._currentSelection = #self.Items
        else
            self._currentSelection = 1000000 - (1000000 % #self.Items) + tonumber(idx)
        end
        self.Items[self:CurrentSelection()]:Selected(true)
        if self.Parent ~= nil and self.Parent:Visible() then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYERS_SELECTION", false, self:CurrentSelection()-1)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYERS_SELECTION", false, self.ParentTab, self:CurrentSelection()-1)
            end
        end
    end
end

function PlayerListColumn:AddPlayer(item)
    item.ParentColumn = self
    item.Handle = #self.Items + 1
    self.Items[item.Handle] = item
    if self.Parent ~= nil and self.Parent:Visible() then
        local Type, SubType = item()
        if SubType == "FriendItem" then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_PLAYER_ITEM", false, 1, 1, item:Label(), item:ItemColor(), item:ColoredTag(), item._iconL, item._boolL, item._iconR, item._boolR, item:Status(), item:StatusColor(), item:Rank(), item:CrewTag())
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_PLAYER_ITEM", false, self.ParentTab, 1, 1, item:Label(), item:ItemColor(), item:ColoredTag(), item._iconL, item._boolL, item._iconR, item._boolR, item:Status(), item:StatusColor(), item:Rank(), item:CrewTag())
            end
        end
        if item.Panel ~= nil then
            item.Panel:UpdatePanel(true)
        end
    end
end

function PlayerListColumn:RemovePlayer(item)
    if item == nil then
        print("^1[ERROR] PlayerListColumn:RemovePlayer() - item is nil");
        return
    end

    local id = item.Handle
    if self.Parent ~= nil and self.Parent:Visible() then
        local item = self.Items[id]
        local Type, SubType = item()
        if SubType == "FriendItem" then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("REMOVE_PLAYER_ITEM", false, id-1)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("REMOVE_PLAYERS_TAB_PLAYER_ITEM", false, self.ParentTab, id-1)
            end
        end
        if item.Panel ~= nil then
            item.Panel:UpdatePanel(true)
        end
    end
    table.remove(self.Items, id)
end