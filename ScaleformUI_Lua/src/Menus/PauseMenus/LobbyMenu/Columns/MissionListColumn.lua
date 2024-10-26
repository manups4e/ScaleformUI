MissionListColumn = setmetatable({}, MissionListColumn)
MissionListColumn.__index = MissionListColumn
MissionListColumn.__call = function()
    return "Column", "MissionListColumn"
end

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
---@field public AddPlayer fun(self: MissionListColumn, item: FriendItem)

---Creates a new MissionListColumn.
---@param label string
---@param color SColor
---@return table
function MissionListColumn.New(label, color, scrollType, _maxItems)
    local handler = PaginationHandler.New()
    handler:ItemsPerPage(_maxItems or 16)
    handler.scrollType = scrollType or MenuScrollingType.CLASSIC
    local _data = {
        _isBuilding = false,
        Type = "missions",
        _label = label or "",
        _color = color or SColor.HUD_Freemode,
        _currentSelection = 0,
        scrollingType = scrollType or MenuScrollingType.CLASSIC,
        Pagination = handler,
        Order = 0,
        Parent = nil,
        ParentTab = nil,
        Items = {} --[[@type table<number, FriendItem>]],
        _unfilteredItems = {} --[[@type table<number, FriendItem>]],
        OnIndexChanged = function(index)
        end,
        OnMissionItemActivated = function(index)
        end
    }
    return setmetatable(_data, MissionListColumn)
end

function MissionListColumn:ScrollingType(type)
    if type == nil then
        return self.scrollingType
    else
        self.scrollingType = type
    end
end

---Sets or gets the current selection.
---@param value? number
---@return number | nil
function MissionListColumn:CurrentSelection(value)
    if value == nil then
        return self.Pagination:CurrentMenuIndex()
    else
        if value == self.Pagination:CurrentMenuIndex() then
            return
        end
        if value < 1 then
            self.Pagination:CurrentMenuIndex(1)
        elseif value > #self.Items then
            self.Pagination:CurrentMenuIndex(#self.Items)
        end

        self.Items[self:CurrentSelection()]:Selected(false)
        self.Pagination:CurrentMenuIndex(value)
        self.Pagination:CurrentPage(self.Pagination:GetPage(self.Pagination:CurrentMenuIndex()))
        self.Pagination:CurrentPageIndex(value)
        self.Pagination:ScaleformIndex(self.Pagination:GetScaleformIndex(self.Pagination:CurrentMenuIndex()))
        if value > self.Pagination:MaxItem() or value < self.Pagination:MinItem() then
            self:refreshColumn()
        end
        if self.Parent ~= nil and self.Parent:Visible() then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
                self.Items[self:CurrentSelection()]:Selected(true)
            elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
                if self.Parent:Index() == IndexOf(self.Parent.Tabs, self.ParentTab) and self.Parent:FocusLevel() == 1 then
                    self.Items[self:CurrentSelection()]:Selected(true)
                end
            end
        end
    end
end

---Adds a new player to the column.
---@param item MissionItem
function MissionListColumn:AddMissionItem(item)
    item.ParentColumn = self
    item.Handle = #self.Items + 1
    self.Items[item.Handle] = item
    self.Pagination:TotalItems(#self.Items)
    if self.Parent ~= nil and self.Parent:Visible() then
        if self.Pagination:TotalItems() < self.Pagination:ItemsPerPage() then
            local sel = self:CurrentSelection()
            self.Pagination:MinItem(self.Pagination:CurrentPageStartIndex())

            if self.scrollingType == MenuScrollingType.CLASSIC and self.Pagination:TotalPages() > 1 then
                local missingItems = self.Pagination:GetMissingItems()
                if missingItems > 0 then
                    self.Pagination:ScaleformIndex(self.Pagination:GetPageIndexFromMenuIndex(self.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                    self.Pagination.minItem = self.Pagination:CurrentPageStartIndex() - missingItems
                end
            end

            self.Pagination:MaxItem(self.Pagination:CurrentPageEndIndex())
            self:_itemCreation(self.Pagination:CurrentPage(), #self.Items, false)
            local pSubT = self.Parent()
            if pSubT == "PauseMenu" and self.ParentTab.Visible then
                if self.ParentTab.listCol[self.ParentTab:Focus()] == self then
                    self:CurrentSelection(sel)
                end
            end
        end
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
        end
    end
end

function MissionListColumn:_itemCreation(page, pageIndex, before, overflow)
    local menuIndex = self.Pagination:GetMenuIndexFromPageIndex(page, pageIndex)
    if not before then
        if self.Pagination:GetPageItemsCount(page) < self.Pagination:ItemsPerPage() and self.Pagination:TotalPages() > 1 then
            if self.scrollingType == MenuScrollingType.ENDLESS then
                if menuIndex > #self.Items then
                    menuIndex = menuIndex - #self.Items
                    self.Pagination:MaxItem(menuIndex)
                end
            elseif self.scrollingType == MenuScrollingType.CLASSIC and overflow then
                local missingItems = self.Pagination:ItemsPerPage() - self.Pagination:GetPageItemsCount(page)
                menuIndex = menuIndex - missingItems
            elseif self.scrollingType == MenuScrollingType.PAGINATED then
                if menuIndex > #self.Items then return end
            end
        end
    end

    local item = self.Items[menuIndex]
    local scIndex = self.Pagination:GetScaleformIndex(menuIndex)
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSIONS_ITEM", before, menuIndex, item.type, item.Label, item.MainColor, item.HighlightColor, item.LeftIcon, item.LeftIconColor, item.RightIcon, item.RightIconColor, item.RightIconChecked, item.enabled)
    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_MISSIONS_ITEM", before, menuIndex, item.type, item.Label, item.MainColor, item.HighlightColor, item.LeftIcon, item.LeftIconColor, item.RightIcon, item.RightIconColor, item.RightIconChecked, item.enabled)
    end

    if item.LeftIcon == BadgeStyle.CUSTOM then
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSION_ITEM_CUSTOM_LEFT_ICON", scIndex, item.customLeftIcon.TXD, item.customLeftIcon.TXN)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSION_ITEM_CUSTOM_LEFT_ICON", scIndex, item.customLeftIcon.TXD, item.customLeftIcon.TXN)
        end
    end

    if item.RightIcon == BadgeStyle.CUSTOM then
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSION_ITEM_CUSTOM_RIGHT_ICON", scIndex, item.customRightIcon.TXD, item.customRightIcon.TXN)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSION_ITEM_CUSTOM_RIGHT_ICON", scIndex, item.customRightIcon.TXD, item.customRightIcon.TXN)
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

    local id = item.Handle
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("REMOVE_MISSIONS_ITEM", id - 1)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("REMOVE_PLAYERS_TAB_MISSIONS_ITEM", id - 1)
        end
    end
    table.remove(self.Items, id)
end

function MissionListColumn:GoUp()
    self.Items[self:CurrentSelection()]:Selected(false)
    repeat
        Citizen.Wait(0)
        local overflow = self:CurrentSelection() == 1 and self.Pagination:TotalPages() > 1
        if self.Pagination:GoUp() then
            if self.scrollingType == MenuScrollingType.ENDLESS or (self.scrollingType == MenuScrollingType.CLASSIC and not overflow) then
                self:_itemCreation(self.Pagination:GetPage(self:CurrentSelection()), self.Pagination:CurrentPageIndex(), true, false)
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", 8, self._delay) --[[@as number]]
                elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", 8, self._delay) --[[@as number]]
                end
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_MISSIONS_COLUMN") --[[@as number]]
                elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN") --[[@as number]]
                end
                local max = self.Pagination:ItemsPerPage()
                for i = 1, max, 1 do
                    if not self.Parent:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
                end
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 1 or (self.Items[self:CurrentSelection()].ItemId == 1 and not self.Items[self:CurrentSelection()].Jumpable)
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
    end
    self.Items[self:CurrentSelection()]:Selected(true)
    self.OnIndexChanged(self:CurrentSelection())
end

function MissionListColumn:GoDown()
    self.Items[self:CurrentSelection()]:Selected(false)
    repeat
        Citizen.Wait(0)
        local overflow = self:CurrentSelection() == #self.Items and self.Pagination:TotalPages() > 1
        if self.Pagination:GoDown() then
            if self.scrollingType == MenuScrollingType.ENDLESS or (self.scrollingType == MenuScrollingType.CLASSIC and not overflow) then
                self:_itemCreation(self.Pagination:GetPage(self:CurrentSelection()), self.Pagination:CurrentPageIndex(), false, false)
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", 9, self._delay) --[[@as number]]
                elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", 9, self._delay) --[[@as number]]
                end
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_MISSIONS_COLUMN") --[[@as number]]
                elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN") --[[@as number]]
                end
                local max = self.Pagination:ItemsPerPage()
                for i = 1, max, 1 do
                    if not self.Parent:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
                end
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 1 or (self.Items[self:CurrentSelection()].ItemId == 1 and not self.Items[self:CurrentSelection()].Jumpable)
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
    end
    self.Items[self:CurrentSelection()]:Selected(true)
    self.OnIndexChanged(self:CurrentSelection())
end

function MissionListColumn:Clear()
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_MISSIONS_COLUMN")
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN")
        end
    end
    self.Items = {}
    self.Pagination:Reset()
end

function MissionListColumn:SortMissions(compare)
    self.Items[self:CurrentSelection()]:Selected(false)
    if self._unfilteredItems == nil or #self._unfilteredItems == 0 then
        for i, item in ipairs(self.Items) do
            table.insert(self._unfilteredItems, item)
        end
    end
    self:Clear()
    local list = self._unfilteredItems
    table.sort(list, compare)
    self.Items = list
    self.Pagination:TotalItems(#self.Items)
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            self.Parent:buildMissions()
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            self.Parent:buildMissions(self.Parent.Tabs[self.ParentTab])
        end
    end
end

function MissionListColumn:FilterMissions(predicate)
    self.Items[self:CurrentSelection()]:Selected(false)
    if self._unfilteredItems == nil or #self._unfilteredItems == 0 then
        for i, item in ipairs(self.Items) do
            table.insert(self._unfilteredItems, item)
        end
    end
    self:Clear()
    local filteredItems = {}
    for i, item in ipairs(self._unfilteredItems) do
        if predicate(item) then
            table.insert(filteredItems, item)
        end
    end
    self.Items = filteredItems
    self.Pagination:TotalItems(#self.Items)
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            self.Parent:buildMissions()
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            self.Parent:buildMissions(self.ParentTab)
        end
    end
end

function MissionListColumn:ResetFilter()
    if self._unfilteredItems ~= nil and #self._unfilteredItems > 0 then
        self.Items[self:CurrentSelection()]:Selected(false)
        self:Clear()
        self.Items = self._unfilteredItems
        self.Pagination:TotalItems(#self.Items)
        if self.Parent ~= nil and self.Parent:Visible() then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                self.Parent:buildMissions()
            elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                self.Parent:buildMissions(self.Parent.Tabs[self.ParentTab])
            end
        end
    end
end

function MissionListColumn:refreshColumn()
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_MISSIONS_COLUMN")
    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN")
    end
    if #self.Items > 0 then
        self._isBuilding = true
        local max = self.Pagination:ItemsPerPage()
        if #self.Items < max then
            max = #self.Items
        end
        self.Pagination:MinItem(self.Pagination:CurrentPageStartIndex())

        if self.scrollingType == MenuScrollingType.CLASSIC and self.Pagination:TotalPages() > 1 then
            local missingItems = self.Pagination:GetMissingItems()
            if missingItems > 0 then
                self.Pagination:ScaleformIndex(self.Pagination:GetPageIndexFromMenuIndex(self.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                self.Pagination.minItem = self.Pagination:CurrentPageStartIndex() - missingItems
            end
        end

        self.Pagination:MaxItem(self.Pagination:CurrentPageEndIndex())

        for i = 1, max, 1 do
            if not self.Parent:Visible() then return end
            self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
        end
        self.Pagination:ScaleformIndex(self.Pagination:GetScaleformIndex(self:CurrentSelection()))
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
        end
        self._isBuilding = false
    end
end
