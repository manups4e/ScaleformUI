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
        SettingsColumn = SettingsListColumn.New("", -1),
        PlayersColumn = PlayerListColumn.New("", -1),
        Index = 0,
        Focused = false,
        _focus = 0,
    }
    return setmetatable(data, PlayerListTab)
end

---Sets the focus of the tab.
---@param _f number
---@return number
function PlayerListTab:Focus(_f)
    if _f ~= nil then
        self._focus = _f
        if self.Base.Parent ~= nil and self.Base.Parent:Visible() then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_FOCUS", false,
                IndexOf(self.Base.Parent.Tabs, self) - 1, self._focus)
        end
    end
    return self._focus
end
