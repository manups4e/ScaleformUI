PlayerListTab = setmetatable({}, PlayerListTab)
PlayerListTab.__index = PlayerListTab
PlayerListTab.__call = function()
    return "BaseTab", "PlayerListTab"
end

---@class PlayerListTab
---@field public Base BaseTab
---@field public LeftItemList BasicTabItem[]
---@field public Label string
---@field public TextTitle string
---@field public SettingsColumn SettingsListColumn
---@field public PlayersColumn PlayerListColumn
---@field public Index number
---@field public Focused boolean

---Creates a new PlayerListTab.
---@param name string
---@param color SColor
---@param newStyle boolean
---@return PlayerListTab
function PlayerListTab.New(name, color, newStyle)
    if newStyle == nil then newStyle = true end
    local data = {
        Base = BaseTab.New(name or "", 2, color),
        LeftItemList = {},
        Label = name or "",
        TextTitle = "",
        listCol = {},
        _newStyle = newStyle,
        SettingsColumn = nil,
        PlayersColumn = nil,
        MissionsColumn = nil,
        MissionPanel = nil,
        Index = 0,
        Focused = false,
        _focus = 0,
        OnFocusChanged = function(focus)
        end
    }
    return setmetatable(data, PlayerListTab)
end

---@param columns table
function PlayerListTab:SetUpColumns(columns)
    assert(#columns <= 3, "You must have 3 columns!")
    assert(not(#columns == 3 and columns[3].Type == "players"), "For panel designs reasons, you can't have Players list in 3rd column!")
    self.listCol = columns
    for k,v in pairs (columns) do
        if self.Base.Parent ~= nil then
            v.Parent = self.Base.Parent
            v.ParentTab = IndexOf(self.Base.Parent.Tabs, self)
        end

        if v.Type == "settings" then
            self.SettingsColumn = v
            self.SettingsColumn.Order = k
        elseif v.Type == "players" then
            self.PlayersColumn = v
            self.PlayersColumn.Order = k
        elseif v.Type == "missions" then
            self.MissionsColumn = v
            self.MissionsColumn.Order = k
        elseif v.Type == "panel" then
            self.MissionPanel = v
            self.MissionPanel.Order = k
        end
    end
end

function PlayerListTab:SelectColumn(column)
    local val = 0
    if type(column) == "table" then
        val = column.Order
    elseif type(column) == "number" then
        val = column
    end
    if val > #self.listCol then
        val  = 1
    elseif val  < 1 then
        val = #self.listCol
    end
    self:updateFocus(val)
end


function PlayerListTab:updateFocus(_f, isMouse)
    if isMouse == nil then isMouse = false end
    local goingLeft = _f < self._focus
    local val = _f

    if val > #self.listCol then
        val  = 1
    elseif val  < 1 then
        val = #self.listCol
    end

    if self.listCol[val].Type ~= "players" then
        if (self.PlayersColumn ~= nil and #self.PlayersColumn.Items > 0) and not self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:KeepPanelVisible() then
            ClearPedInPauseMenu()
        end
    end

    self._focus = val
    if self.listCol[self._focus].Type == "panel" then
        if goingLeft then
            self:updateFocus(self._focus - 1)
        else
            self:updateFocus(self._focus + 1)
        end
        return
    end

    if self.Base.Parent ~= nil and self.Base.Parent:Visible() then
        local idx = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunctionAsyncReturnInt("SET_PLAYERS_TAB_FOCUS", IndexOf(self.Base.Parent.Tabs, self) - 1, self._focus-1)
        if not isMouse then
            local _id = self.listCol[self._focus].Pagination:GetMenuIndexFromScaleformIndex(idx)
            self.listCol[self._focus]:CurrentSelection(_id)
            if not goingLeft or self._newStyle then
                self.listCol[self._focus].OnIndexChanged(_id)
            end
        end
    end
    self.OnFocusChanged(self:Focus())
end

---returns the focus of the tab.
---@return number
function PlayerListTab:Focus()
    return self._focus
end
