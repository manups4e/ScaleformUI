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
function MissionListColumn.New(label, color, scrollType)
    local handler = PaginationHandler.New()
    handler:ItemsPerPage(12)
    handler.scrollType = scrollType or MenuScrollingType.CLASSIC
    local _data = {
        _isBuilding = false,
        Type = "missions",
        _label = label or "",
        _color = color or 116,
        _currentSelection = 0,
        scrollingType = scrollType or MenuScrollingType.CLASSIC,
        Pagination = handler,
        Order = 0,
        Parent = nil,
        ParentTab = 0,
        Items = {} --[[@type table<number, FriendItem>]],
        OnIndexChanged = function(index)
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
---@param value number?
---@return number
function MissionListColumn:CurrentSelection(value)
    if value == nil then
        return self.Pagination:CurrentMenuIndex()
    else
        if value < 1 then
            self.Pagination:CurrentMenuIndex(1)
        elseif value > #self.Items then
            self.Pagination:CurrentMenuIndex(#self.Items)
        end

        self.Items[self:CurrentSelection()]:Selected(false)
        self.Pagination:CurrentMenuIndex(value);
        self.Pagination:CurrentPage(self.Pagination:GetPage(self.Pagination:CurrentMenuIndex()));
        self.Pagination:CurrentPageIndex(value);
        self.Pagination:ScaleformIndex(self.Pagination:GetScaleformIndex(self.Pagination:CurrentMenuIndex()));
        self.Items[self:CurrentSelection()]:Selected(true)
        if self.Parent ~= nil and self.Parent:Visible() then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", false, self.Pagination:ScaleformIndex()) --[[@as number]]
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_QTTY", false, self:CurrentSelection(), #self.Items) --[[@as number]]
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", false, self.ParentTab, self.Pagination:ScaleformIndex()) --[[@as number]]
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", false, self.ParentTab, self:CurrentSelection(), #self.Items) --[[@as number]]
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
            self:_itemCreation(0, #self.Items, false)
            local pSubT = self.Parent()
            if pSubT == "PauseMenu" then
                if self.Parent.Tabs[self.ParentTab+1].listCol[self.Parent.Tabs[self.ParentTab+1]:Focus()] == self then
                    self:CurrentSelection(sel)
                end
            end
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
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSIONS_ITEM", false, before, menuIndex, 0, item.Label, item.MainColor, item.HighlightColor, item.LeftIcon, item.LeftIconColor, item.RightIcon, item.RightIconColor, item.RightIconChecked, item.enabled)
    elseif pSubT == "PauseMenu" then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_MISSIONS_ITEM", false, self.ParentTab, before, menuIndex, 0, item.Label, item.MainColor, item.HighlightColor, item.LeftIcon, item.LeftIconColor, item.RightIcon, item.RightIconColor, item.RightIconChecked, item.enabled)
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
                        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", false, 8, self._delay) --[[@as number]]
                    elseif pSubT == "PauseMenu" then
                        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", false, 8, self._delay) --[[@as number]]
                    end
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_MISSIONS_COLUMN", false) --[[@as number]]
                elseif pSubT == "PauseMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN", false, self.ParentTab) --[[@as number]]
                end
                local i = 1
                local max = self.Pagination:ItemsPerPage()
                while i <= max do
                    Citizen.Wait(0)
                    if not self:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
                    i = i + 1
                end
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 6 or (self.Items[self:CurrentSelection()].ItemId == 6 and not self.Items[self:CurrentSelection()].Jumpable)
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", false, self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_QTTY", false, self:CurrentSelection(), #self.Items) --[[@as number]]
    elseif pSubT == "PauseMenu" then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", false, self.ParentTab, self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", false, self.ParentTab, self:CurrentSelection(), #self.Items) --[[@as number]]
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
                        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", false, 9, self._delay) --[[@as number]]
                    elseif pSubT == "PauseMenu" then
                        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", false, 9, self._delay) --[[@as number]]
                    end
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_MISSIONS_COLUMN", false) --[[@as number]]
                elseif pSubT == "PauseMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_MISSIONS_COLUMN", false, self.ParentTab) --[[@as number]]
                end
                local i = 1
                local max = self.Pagination:ItemsPerPage()
                while i <= max do
                    Citizen.Wait(0)
                    if not self:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
                    i = i + 1
                end
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 6 or (self.Items[self:CurrentSelection()].ItemId == 6 and not self.Items[self:CurrentSelection()].Jumpable)
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_SELECTION", false, self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSIONS_QTTY", false, self:CurrentSelection(), #self.Items) --[[@as number]]
    elseif pSubT == "PauseMenu" then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_SELECTION", false, self.ParentTab, self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_MISSIONS_QTTY", false, self.ParentTab, self:CurrentSelection(), #self.Items) --[[@as number]]
    end
    self.Items[self:CurrentSelection()]:Selected(true)
    self.OnIndexChanged(self:CurrentSelection())
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
    self.Pagination:Reset()
end
