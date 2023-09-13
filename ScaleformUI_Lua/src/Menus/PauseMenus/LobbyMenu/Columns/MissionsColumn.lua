MissionListColumn = setmetatable({}, MissionListColumn)
MissionListColumn.__index = MissionListColumn
MissionListColumn.__call = function()
    return "Column", "MissionListColumn"
end

---@class MissionListColumn
---@field private _label string
---@field private _color number
---@field private _currentSelection number
---@field public Order number
---@field public Parent function
---@field public ParentTab number
---@field public Items table<FriendItem>
---@field public OnIndexChanged fun(index: number)
---@field public AddPlayer fun(self: MissionListColumn, item: FriendItem)

---Creates a new MissionListColumn.
---@param label string
---@param color number|116
---@return table
function MissionListColumn.New(label, color)
    local _data = {
        Type = "missions",
        _label = label or "",
        _color = color or 116,
        _currentSelection = 0,
        Order = 0,
        Parent = nil,
        ParentTab = 0,
        Items = {} --[[@type table<number, FriendItem>]],
        OnIndexChanged = function(index)
        end
    }
    return setmetatable(_data, MissionListColumn)
end

---Sets or gets the current selection.
---@param idx number?
---@return number
function MissionListColumn:CurrentSelection(idx)
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
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", false,
                    self:CurrentSelection() - 1)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", false,
                    self.ParentTab, self:CurrentSelection() - 1)
            end
        end
    end
    return self:CurrentSelection() - 1;
end

---Adds a new player to the column.
---@param item MissionItem
function MissionListColumn:AddMissionItem(item)
    item.ParentColumn = self
    item.Handle = #self.Items + 1
    self.Items[item.Handle] = item
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSIONS_ITEM", false,  0, item.Label, item.MainColor, item.HighlightColor, item.LeftIcon, item.LeftIconColor, item.RightIcon, item.RightIconColor, item.RightIconChecked, item.enabled)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_MISSIONS_ITEM", false, self.ParentTab, 0, item.Label, item.MainColor, item.HighlightColor, item.LeftIcon, item.LeftIconColor, item.RightIcon, item.RightIconColor, item.RightIconChecked, item.enabled)
        end
        
    end
end

---Removes a player from the column.
---@param item FriendItem
function MissionListColumn:RemoveItem(item)
    if item == nil then
        print("^1[ERROR] MissionListColumn:RemovePlayer() - item is nil");
        return
    end

    local id = item.Handle
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("REMOVE_MISSIONS_ITEM", false, id - 1)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("REMOVE_PLAYERS_TAB_MISSIONS_ITEM", false,
                self.ParentTab, id - 1)
        end
    end
    table.remove(self.Items, id)
end

function MissionListColumn:Clear()
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_MISSIONS_COLUMN", false)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN", false, self.ParentTab)
        end
    end
    self.Items = {}
end
