PlayerListTab = {}
PlayerListTab.__index = PlayerListTab
setmetatable(PlayerListTab, { __index = BaseTab })
PlayerListTab.__call = function() return "PlayerListTab" end

---@enum PLT_COLUMNS
PLT_COLUMNS =
{
    SETTINGS = 0,
    PLAYERS = 1,
    MISSION = 2,
    STORE = 3,
    MISSION_DETAILS = 4,
}

---@class PlayerListTab
---@field public Base BaseTab
---@field public LeftItemList PauseMenuItem[]
---@field public Label string
---@field public TextTitle string
---@field public SettingsColumn SettingsListColumn
---@field public PlayersColumn PlayerListColumn
---@field public MissionsColumn MissionListColumn
---@field public StoreColumn StoreListColumn
---@field public Index number
---@field public Focused boolean

---Creates a new PlayerListTab.
---@param name string
---@param color SColor
---@return PlayerListTab
function PlayerListTab.New(name, color)
    local base = BaseTab.New(name, color)
    base._identifier = "Page_Multi"
    base.OnFocusChanged = function(focus)
    end
    base.order = { 0, 0, 0 }
    local meta = setmetatable(base, PlayerListTab)
    meta.Minimap = MinimapPanel.New(meta)
    meta.Minimap.HidePedBlip = true
    return meta
end

function PlayerListTab:SetupLeftColumn(column)
    column.position = 0
    self.LeftColumn = column
    self.LeftColumn.Parent = self
    self.order[1] = column.type
end

function PlayerListTab:SetupCenterColumn(column)
    column.position = 1
    self.CenterColumn = column
    self.CenterColumn.Parent = self
    self.order[2] = column.type
end

function PlayerListTab:SetupRightColumn(column)
    column.position = 2
    self.RightColumn = column
    self.RightColumn.Parent = self
    self.order[3] = column.type
end

function PlayerListTab:SelectColumn(index)
    self:SwitchColumn(index - 1)
end

function PlayerListTab:SwitchColumn(index)
    if index > 2 or self.order[index + 1] == PLT_COLUMNS.MISSION_DETAILS then return end
    local canHideShow = true
    local col = self:GetColumnAtPosition(index)
    if col == nil then
        if index < 2 then
            if index < self.CurrentColumnIndex then
                self:SwitchColumn(index - 1)
            else
                self:SwitchColumn(index + 1)
            end
        end
        return
    end


    -- we don't check for right column because
    -- if right column is players then it means there's no player panel to be shown
    if self.LeftColumn.type == PLT_COLUMNS.PLAYERS then
        if self.LeftColumn:CurrentItem():KeepPanelVisible() then
            canHideShow = false
        end
    elseif self.CenterColumn.type == PLT_COLUMNS.PLAYERS then
        if self.CenterColumn:CurrentItem():KeepPanelVisible() then
            canHideShow = false
        end
    end

    if canHideShow then
        if self.Parent ~= nil and self.Parent:Visible() then
            if col.type == PLT_COLUMNS.PLAYERS then
                if col:CurrentItem().Panel ~= nil then
                    self.RightColumn:ColumnVisible(false)
                end
            else
                -- we check that the columns before and after selected index are players columns
                -- and that its current item has KeepPanelVisible true.. 
                -- if KeepPanelVisible is true, we keep hidden the right column, else we show it.
                local show = true
                local befCol = self:GetColumnAtPosition(index - 1)
                local afterCol = self:GetColumnAtPosition(index + 1)
                if befCol ~= nil and befCol.type == PLT_COLUMNS.PLAYERS and not befCol:CurrentItem():KeepPanelVisible() then
                    befCol:CurrentItem():Dispose()
                    show = false
                end
                if afterCol ~= nil and afterCol.type == PLT_COLUMNS.PLAYERS and not afterCol:CurrentItem():KeepPanelVisible() then
                    afterCol:CurrentItem():Dispose()
                    show = false
                end
                if self.RightColumn ~= nil then
                    self.RightColumn:ColumnVisible(not show)
                end
            end
        end
    else
        if self.RightColumn ~= nil then
            self.RightColumn:ColumnVisible(true)
        end
    end

    if index == 2 and not canHideShow then return end
    self.CurrentColumnIndex = index
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_MENU_LEVEL", self.CurrentColumnIndex + 1)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("MENU_SHIFT_DEPTH", 0, true, true)
    self.Parent.focusLevel = self.CurrentColumnIndex + 1
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", col.position, col.index - 1, true, true)
    col.Items[col.index]:Selected(true)
end

function PlayerListTab:StateChange()
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("MENU_STATE", Join("", self.order))
end

function PlayerListTab:GoUp()
    if not self.Focused then return end
    local col = self:CurrentColumn()
    Citizen.CreateThread(function()
        col:GoUp()
    end)
    col:SetColumnScroll(col.index, #col.Items, col.VisibleItems, "", #col.Items < col.VisibleItems)
end

function PlayerListTab:GoDown()
    if not self.Focused then return end
    local col = self:CurrentColumn()
    Citizen.CreateThread(function()
        col:GoDown()
    end)
    col:SetColumnScroll(col.index, #col.Items, col.VisibleItems, "", #col.Items < col.VisibleItems)
end

function PlayerListTab:GoLeft()
    if not self.Focused then return end
    self:CurrentColumn():GoLeft()
end

function PlayerListTab:GoRight()
    if not self.Focused then return end
    self:CurrentColumn():GoRight()
end

function PlayerListTab:Select()
    if not self.Focused then return end
    self:CurrentColumn():Select()
end

function PlayerListTab:GoBack()
    if not self.Focused then return end
    if self.CurrentColumnIndex > 0 then
        self:CurrentColumn():CurrentItem():Selected(false)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_FOCUS", self.CurrentColumnIndex, false, false,
            false)
        self:SwitchColumn(self.CurrentColumnIndex - 1)
        if self:CurrentColumn() == nil and self.CurrentColumnIndex > 0 then
            self:GoBack()
            return
        end
        self:CurrentColumn():CurrentItem():Selected(true)
        if self:CurrentColumn().type == PLT_COLUMNS.PLAYERS then
            if self:CurrentColumn():CurrentItem().Panel ~= nil then
                local rr = self:GetColumnAtPosition(2)
                if rr ~= nil then
                    rr:ColumnVisible(false)
                end
            else
                local rr = self:GetColumnAtPosition(2)
                if rr ~= nil then
                    rr:ColumnVisible(true)
                end
            end
        end
    end
end

function PlayerListTab:MouseEvent(eventType, context, index)
    if not self.Focused then return end
    if eventType == 5 then
        if context > 999 then
            local colidx = context - 1000
            local col = self:GetColumnAtPosition(colidx)
            if index == 0 then
                col:GoLeft()
            elseif index == 1 then
                col:GoRight()
            elseif index == 2 then
                col:GoUp()
            elseif index == 3 then
                col:GoDown()
            end
            return
        end

        if self.CurrentColumnIndex == context then
            if index == self:CurrentColumn():Index() then
                self:CurrentColumn():Select()
                return
            end
            self:CurrentColumn():CurrentItem():Selected(false)
            self:CurrentColumn():Index(index)
            self:CurrentColumn():CurrentItem():Selected(true)
            if self:CurrentColumn().type == PLT_COLUMNS.SETTINGS then
                AddTextEntry("PAUSEMENU_Current_Description", self:CurrentColumn():CurrentItem():Description())
            end
        else
            local selectedCol = self:GetColumnAtPosition(context)
            self:SwitchColumn(context)
            selectedCol:CurrentItem():Selected(false)
            selectedCol:Index(index)
            selectedCol:CurrentItem():Selected(true)
            if selectedCol.type == PLT_COLUMNS.SETTINGS then
                AddTextEntry("PAUSEMENU_Current_Description", selectedCol:CurrentItem():Description())
            end
        end
    elseif eventType == 10 or eventType == 11 then
        local dir = -1
        if eventType == 11 then
            dir = 1
        end
        self:CurrentColumn():MouseScroll(dir)
    end
end

function PlayerListTab:Populate()
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_MENU_LEVEL", 1)
    self:StateChange()
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_MENU_LEVEL", 0)
    if self.LeftColumn ~= nil then
        self.LeftColumn:Populate()
    end
    if self.CenterColumn ~= nil then
        self.CenterColumn:Populate()
    end
    if self.RightColumn ~= nil then
        self.RightColumn:Populate()
    end
end

function PlayerListTab:ShowColumns()
    if self.LeftColumn ~= nil then
        self.LeftColumn:ShowColumn()
    end
    if self.CenterColumn ~= nil then
        self.CenterColumn:ShowColumn()
    end
    if self.RightColumn ~= nil then
        self.RightColumn:ShowColumn()
    end
end

function PlayerListTab:Focus()
    BaseTab.Focus(self)
    self:CurrentColumn().Focused = true
    self:CurrentColumn():CurrentItem():Selected(true)
    if self:CurrentColumn().type == PLT_COLUMNS.SETTINGS then
        AddTextEntry("PAUSEMENU_Current_Description", self:CurrentColumn():CurrentItem():Description())
    elseif self:CurrentColumn().type == PLT_COLUMNS.PLAYERS then
        ClearPedInPauseMenu()
        if self:CurrentColumn().Panel ~= nil then
            self:CurrentColumn().Panel:UpdatePanel()
            if self.RightColumn ~= nil then
                self.RightColumn:ColumnVisible(false)
            end
        elseif self.RightColumn ~= nil then
            self.RightColumn:ColumnVisible(true)
        end
    end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", self:CurrentColumn().position,
        self:CurrentColumn():Index() - 1, true, false)
end

function PlayerListTab:UnFocus()
    if self.CurrentColumnIndex > 0 then
        self:SelectColumn(1)
    end
    BaseTab.UnFocus(self)
    if self.LeftColumn then
        self.LeftColumn:CurrentItem():Selected(false)
        self.LeftColumn.Focused = false
    end
    if self.CenterColumn then
        self.CenterColumn:CurrentItem():Selected(false)
        self.CenterColumn.Focused = false
    end
    if self.RightColumn then
        self.RightColumn:CurrentItem():Selected(false)
        if not self.RightColumn:ColumnVisible() then
            self.RightColumn:ColumnVisible(true)
        end
        self.RightColumn.Focused = false
    end
    AddTextEntry("PAUSEMENU_Current_Description", "")
end
