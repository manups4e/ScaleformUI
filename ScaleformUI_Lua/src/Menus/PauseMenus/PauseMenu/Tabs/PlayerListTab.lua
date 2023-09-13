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
---@return PlayerListTab
function PlayerListTab.New(name)
    local data = {
        Base = BaseTab.New(name or "", 2),
        LeftItemList = {},
        Label = name or "",
        TextTitle = "",
        listCol = {},
        SettingsColumn = nil,
        PlayersColumn = nil,
        MissionsColumn = nil,
        MissionPanel = nil,
        Index = 0,
        Focused = false,
        _focus = 0,
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

function PlayerListTab:UpdateFocus(_f, isMouse)
    if isMouse == nil then isMouse = false end
    local goingLeft = _f < self._focus

    for k,v in pairs(self.listCol) do
        if v.Type == "players" then
            if (self.PlayersColumn ~= nil and #self.PlayersColumn.Items > 0) and not self.PlayersColumn.Items[self.PlayersColumn:CurrentSelection()]:KeepPanelVisible() then
                ClearPedInPauseMenu()
            end
        end
    end

    self._focus = _f
    if self._focus > #self.listCol then
        self._focus = 1
    elseif self._focus < 1 then
        self._focus = #self.listCol
    end

    if self.listCol[self._focus].Type == "panel" then
        if goingLeft then
            self:UpdateFocus(self._focus - 1)
        else
            self:UpdateFocus(self._focus + 1)
        end
        return
    end

    if self.Base.Parent ~= nil and self.Base.Parent:Visible() then
        local __idx = ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_FOCUS", true, IndexOf(self.Base.Parent.Tabs, self) - 1, self._focus-1)
        while not IsScaleformMovieMethodReturnValueReady(__idx) do
            Citizen.Wait(0)
        end
        local idx = GetScaleformMovieMethodReturnValueInt(__idx)
        if not isMouse then
            if self.listCol[self._focus].Type == "settings" then
                self.SettingsColumn:CurrentSelection(idx)
                self.SettingsColumn.OnIndexChanged(idx+1)
            elseif self.listCol[self._focus].Type == "players" then
                self.PlayersColumn:CurrentSelection(idx)
                self.PlayersColumn.OnIndexChanged(idx+1)
            elseif self.listCol[self._focus].Type == "missions" then
                self.MissionsColumn:CurrentSelection(idx)
                self.MissionsColumn.OnIndexChanged(idx+1)
            end
        end
    end
end

---returns the focus of the tab.
---@return number
function PlayerListTab:Focus()
    return self._focus
end
