MissionListColumn = {}
MissionListColumn.__index = MissionListColumn
setmetatable(MissionListColumn, { __index = PM_Column })
MissionListColumn.__call = function() return "MissionListColumn" end

---@class MissionListColumn
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
---@field public AddMissionItem fun(self: MissionListColumn, item: MissionItem)

---Creates a new MissionListColumn.
---@param label string the label of the column (used only on Corona/Lobby mode)
---@param _maxItems number the max number of visible items in this column.
---@return table
function MissionListColumn.New(label, _maxItems)
    local base = PM_Column.New(-1)
    base.Label = label
    base.type = PLT_COLUMNS.MISSION
    base.VisibleItems = _maxItems
    base._unfilteredItems = {} --[[@type table<number, MissionItem>]]
    base._unfilteredSelection = 1
    base.OnIndexChanged = function(index)
    end
    base.OnMissionItemActivated = function(index)
    end
    return setmetatable(base, MissionListColumn)
end

function MissionListColumn:SetVisibleItems(maxItems)
    self.VisibleItems = maxItems
    if self:visible() then
        self:Populate()
        self:ShowColumn()
    end
end

function MissionListColumn:AddItem(item)
    self:AddMissionItem(item)
end

function MissionListColumn:ShowColumn()
    if not self:visible() then return end
    PM_Column.ShowColumn(self)
    self:InitColumnScroll(#self.Items >= self.VisibleItems, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT)
    self:SetColumnScroll(self.index, #self.Items, self.VisibleItems, "", #self.Items < self.VisibleItems)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_FOCUS", self.position, self.Focused, false, false)
    if #self.Items > 0 and self:CurrentItem().type == 1 and self:CurrentItem().Jumpable then
        self:CurrentItem():Selected(false)
        self.index = self.index + 1
        if self.index > #self.Items then
            self.index = 1
        end
        self:CurrentItem():Selected(true)
    end
end

function MissionListColumn:Populate()
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
function MissionListColumn:CurrentSelection(value)
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
        if self:visible() and self.Focused then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self.position, self.index - 1, true, true)
        end
        self.OnIndexChanged(self.index)
    end
end


---Adds a new player to the column.
---@param item MissionItem
function MissionListColumn:AddMissionItem(item)
    item.ParentColumn = self
    table.insert(self.Items, item)
    if self:visible() and #self.Items < self.VisibleItems then
        local idx = #self.Items
        self:AddSlot(idx)
        self.Items[idx]:Selected(idx == self.index)
    end
end

function MissionListColumn:SetDataSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index)
    end
end
function MissionListColumn:UpdateSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index, true)
    end
end
function MissionListColumn:AddSlot(index)
    if self.index > #self.Items then return end
    if self:visible() then
        self:SendItemToScaleform(index, false, false, true)
    end
end

function MissionListColumn:AddItemAt(item, index)
    table.insert(self.Items, index, item)
    if not self:visible() then return end
    self:AddSlot(index)
    item:Selected(idx == self.index)
end

function MissionListColumn:SendItemToScaleform(i, update, newItem, isSlot)
    if i > #self.Items then return end
    local item = self.Items[i]
    local str = "SET_DATA_SLOT"
    if update then str = "UPDATE_SLOT" end
    if newItem then str = "SET_DATA_SLOT_SPLICE" end
    if isSlot then str = "ADD_SLOT" end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction(str, self.position, i, 0,i, item.type, 0, item.Enabled, item.label, item.MainColor, item.HighlightColor, item.LeftIcon, item.RightIcon, item.LeftIconColor, item.RightIconColor, item.customLeftIcon.TXD, item.customLeftIcon.TXN, item.customRightIcon.TXD, item.customRightIcon.TXN, item.RightIconChecked, item.Jumpable)
    if self.position == 0 and i == self.index then
        if item.Panel ~= nil then
            item.Panel:UpdatePanel()
        end
    end
end

---Removes a player from the column.
---@param item FriendItem
function MissionListColumn:RemoveItem(item)
    if item == nil then
        print("^1[ERROR] MissionListColumn:RemovePlayer() - item is nil")
        return
    end
    for k,v in pairs(self.Items) do
        if v:Label () == item:Label() then
            self:RemoveSlot(k)
        end
    end
end

function MissionListColumn:RemoveItemAt(index)
    if index >#self.Items or index < 1 then return end
    self:RemoveSlot(index)
end

function MissionListColumn:GoUp()
    self.Items[self:CurrentSelection()]:Selected(false)
    repeat
        Citizen.Wait(0)
        self.index = self.index - 1
        if self.index < 1 then
            self.index = #self.Items
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 1 or (self.Items[self:CurrentSelection()].ItemId == 1 and not self.Items[self:CurrentSelection()].Jumpable)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.position, 8)
    self.Items[self:CurrentSelection()]:Selected(true)
    self.OnIndexChanged(self:CurrentSelection())
end

function MissionListColumn:GoDown()
    self.Items[self:CurrentSelection()]:Selected(false)
    repeat
        Citizen.Wait(0)
        self.index = self.index + 1
        if self.index > #self.Items then
            self.index = 1
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 1 or (self.Items[self:CurrentSelection()].ItemId == 1 and not self.Items[self:CurrentSelection()].Jumpable)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.position, 9)
    self.Items[self:CurrentSelection()]:Selected(true)
    self.OnIndexChanged(self:CurrentSelection())
end

function MissionListColumn:Select()
    self:CurrentItem().Activated(self:CurrentItem())
    self:OnMissionItemActivated(self:CurrentSelection())
end

function MissionListColumn:Clear()
    self:ClearColumn()
end

function MissionListColumn:SortMissions(compare)
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

function MissionListColumn:FilterMissions(predicate)
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

function MissionListColumn:ResetFilter()
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