PlayerListColumn = {}
PlayerListColumn.__index = PlayerListColumn
setmetatable(PlayerListColumn, { __index = PM_Column })
PlayerListColumn.__call = function() return "PlayerListColumn" end


---@class PlayerListColumn
---@field private _label string
---@field private _color SColor
---@field private _isBuilding boolean
---@field private _currentSelection number
---@field private _unfilteredItems table<FriendItem>
---@field public Order number
---@field public Parent function
---@field public ParentTab number
---@field public Items table<FriendItem>
---@field public OnIndexChanged fun(index: number)
---@field public AddPlayer fun(self: PlayerListColumn, item: FriendItem)

---Creates a new PlayerListColumn.
---@param label string
---@return table
function PlayerListColumn.New(label, _maxItems)
    local base = PM_Column.New(-1)
    base.Label = label
    base.type = PLT_COLUMNS.PLAYERS
    base.VisibleItems = _maxItems
    base._unfilteredItems = {} --[[@type table<number, FriendItem>]]
    base._unfilteredSelection = 1
    base.OnIndexChanged = function(index)
    end
    base.OnPlayerItemActivated = function(index)
    end
    local meta = setmetatable(base, PlayerListColumn)
    return meta
end

function PlayerListColumn:SetVisibleItems(maxItems)
    self.VisibleItems = maxItems
    if self:visible() then
        self:Populate()
        self:ShowColumn()
    end
end

function PlayerListColumn:AddItem(item)
    self:AddPlayer(item)
end

function PlayerListColumn:ShowColumn()
    if not self:visible() then return end
    PM_Column.ShowColumn(self)
    self:InitColumnScroll(#self.Items >= self.VisibleItems, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT)
    self:SetColumnScroll(self.index, #self.Items, self.VisibleItems, "", #self.Items < self.VisibleItems)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_FOCUS", self.position, self.Focused, false, false)
end

function PlayerListColumn:Populate()
    if not self:visible() then return end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT_EMPTY", self.position)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_MAX_ITEMS", self.position, self.VisibleItems)
    for i=1, #self.Items, 1 do
        self:SetDataSlot(i)
    end
end

---Sets or gets the current selection.
---@param value? number
---@return number | nil
function PlayerListColumn:CurrentSelection(value)
    if value == nil then
        return self.index
    else
        self:CurrentItem():Selected(false)
        self.index = value
        if self.index < 1 then
            self.index = #self.Items
        elseif self.index > #self.Items then
            self.index = 1
        end
        self:CurrentItem():Selected(true)
        self:CurrentItem():AddPedToPauseMenu()
        if self:CurrentItem().Panel ~= nil then
            self:CurrentItem().Panel:UpdatePanel()
        end
        if self:visible() and self.Focused then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position, self.index - 1, true, true)
        end
        self.OnIndexChanged(self.index)
    end
end

---Adds a new player to the column.
---@param item FriendItem
function PlayerListColumn:AddPlayer(item)
    item.ParentColumn = self
    table.insert(self.Items, item)
    if self:visible() and #self.Items < self.VisibleItems then
        local idx = #self.Items
        self:AddSlot(idx)
        self.Items[idx]:Selected(idx == self.index)
    end
end

function PlayerListColumn:SetDataSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index)
    end
end
function PlayerListColumn:UpdateSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index, true)
    end
end
function PlayerListColumn:AddSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index, false, false, true)
    end
end

function PlayerListColumn:AddItemAt(item, index)
    table.insert(self.Items, index, item)
    if not self:visible() then return end
    self:AddSlot(index)
    item:Selected(idx == self.index)
end

function PlayerListColumn:SendItemToScaleform(i, update, newItem, isSlot)
    if i > #self.Items then return end
    local item = self.Items[i]
    local str = "SET_DATA_SLOT"
    if update then str = "UPDATE_SLOT" end
    if newItem then str = "SET_DATA_SLOT_SPLICE" end
    if isSlot then str = "ADD_SLOT" end

-- item:Label(), item:ItemColor(), item:ColoredTag(), item._iconL, item._boolL, item._iconR, item._boolR, item:Status(), item:StatusColor(), item:Rank(), item:CrewTag().TAG, item:KeepPanelVisible()
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction(str, self.position, i - 1, 0, i - 1, 2, item:Rank(), true, item.label, item:ItemColor(), item:ColoredTag(), item._iconL, item._boolL, item._iconR, item._boolR, item:Status(), item:StatusColor(), item:CrewTag().TAG)
    if self.position == 0 and i == self.index then
        if item.Panel ~= nil then
            item.Panel:UpdatePanel()
        end
    end
end

---Removes a player from the column.
---@param item FriendItem
function PlayerListColumn:RemovePlayer(item)
    if item == nil then
        print("^1[ERROR] PlayerListColumn:RemovePlayer() - item is nil")
        return
    end
    for k,v in pairs(self.Items) do
        if v:Label () == item:Label() then
            self:RemoveSlot(k)
        end
    end
end

function PlayerListColumn:RemoveItemAt(index)
    if index >#self.Items or index < 1 then return end
    self:RemoveSlot(index)
end

function PlayerListColumn:RemoveSlot(idx)
    self:CurrentItem():Dispose()
    PM_Column.RemoveSlot(self, idx)
end

function PlayerListColumn:GoUp()
    ClearPedInPauseMenu()
    self.Items[self:CurrentSelection()]:Selected(false)
    self.index = self.index - 1
    if self.index < 1 then
        self.index = #self.Items
    end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.position, 8)
    self.Items[self:CurrentSelection()]:Selected(true)
    self.OnIndexChanged(self:CurrentSelection())
end

function PlayerListColumn:GoDown()
    ClearPedInPauseMenu()
    self.Items[self:CurrentSelection()]:Selected(false)
    self.index = self.index + 1
    if self.index > #self.Items then
        self.index = 1
    end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.position, 9)
    self.Items[self:CurrentSelection()]:Selected(true)
    self.OnIndexChanged(self:CurrentSelection())
end

function PlayerListColumn:Select()
    if not self:visible() then return end
    self.OnPlayerItemActivated(self:Index())
end

function PlayerListColumn:SortPlayers(compare)
    if not self:visible() then return end
    self.Items[self:CurrentSelection()]:Selected(false)
    if self._unfilteredItems == nil or #self._unfilteredItems == 0 then
        for i, item in ipairs(self.Items) do
            table.insert(self._unfilteredItems, item)
        end
    end
    self._unfilteredSelection = self:Index()
    self:Clear()
    local list = self._unfilteredItems
    table.sort(list, compare)
    self.Items = list
    if self:visible() then
        self:Populate()
        self:ShowColumn()
    end
end

function PlayerListColumn:FilterPlayers(predicate)
    self.Items[self:CurrentSelection()]:Selected(false)
    if self._unfilteredItems == nil or #self._unfilteredItems == 0 then
        for i, item in ipairs(self.Items) do
            table.insert(self._unfilteredItems, item)
        end
    end
    self._unfilteredSelection = self:Index()
    self:Clear()
    local filteredItems = {}
    for i, item in ipairs(self._unfilteredItems) do
        if predicate(item) then
            table.insert(filteredItems, item)
        end
    end
    self.Items = filteredItems
    if self:visible() then
        self:Populate()
        self:ShowColumn()
    end
end

function PlayerListColumn:ResetFilter()
    if self._unfilteredItems ~= nil and #self._unfilteredItems > 0 then
        self.Items[self:CurrentSelection()]:Selected(false)
        self:Clear()
        self.Items = self._unfilteredItems
        self:Index(self._unfilteredSelection)
        self._unfilteredItems = {}
        self._unfilteredSelection = 1
        if self:visible() then
            self:Populate()
            self:ShowColumn()
        end
    end
end

function PlayerListColumn:Clear()
    self:ClearColumn()
end

function PlayerListColumn:ClearColumn()
    PM_Column.ClearColumn(self)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT_EMPTY", 3)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT_EMPTY", 4)
end