PlayerListTab = setmetatable({}, PlayerListTab)
PlayerListTab.__index = PlayerListTab
PlayerListTab.__call = function()
    return "BaseTab", "PlayerListTab"
end

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

function PlayerListTab:Focus(_f)
    if _f == nil then 
        return self._focus
    else
        self._focus = _f
        if self.Base.Parent ~= nil and self.Base.Parent:Visible() then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_FOCUS", false, IndexOf(self.Base.Parent.Tabs, self) - 1, self._focus)
        end
    end
end