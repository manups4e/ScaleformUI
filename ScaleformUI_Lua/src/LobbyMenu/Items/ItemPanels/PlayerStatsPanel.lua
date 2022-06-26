PlayerStatsPanel = setmetatable({}, PlayerStatsPanel)
PlayerStatsPanel.__index = PlayerStatsPanel
PlayerStatsPanel.__call = function()
    return "ItemPanel", "PlayerStatsPanel"
end

function PlayerStatsPanel.New(title, titleColor)
    local _data = {
        ParentItem = nil,
        _title = title or "",
        _description = "",
        _titleColor = titleColor or 116,
        _hasPlane = false,
        _hasVehicle = false,
        _hasBoat = false,
        _hasHeli = false,
        RankInfo = UpperInformation.New(self),
        Items = {}
    }
    local retVal = setmetatable(_data, PlayerStatsPanel)
    retVal.RankInfo = UpperInformation.New(retVal)
    return retVal
end


function PlayerStatsPanel:Title(label)
    if label == nil then
        return self._title
    else
        self._title = label
        self:UpdatePanel()
    end
end

function PlayerStatsPanel:TitleColor(color)
    if color == nil then
        return self._titleColor
    else
        self._titleColor = color
        self:UpdatePanel()
    end
end

function PlayerStatsPanel:Description(label)
    if label == nil then
        return self._description
    else
        self._description = label
        self:UpdatePanel()
    end
end

function PlayerStatsPanel:HasPlane(bool)
    if bool == nil then
        return self._hasPlane
    else
        self._hasPlane = bool
        self:UpdatePanel()
    end
end

function PlayerStatsPanel:HasHeli(bool)
    if bool == nil then
        return self._hasHeli
    else
        self._hasHeli = bool
        self:UpdatePanel()
    end
end

function PlayerStatsPanel:HasBoat(bool)
    if bool == nil then
        return self._hasBoat
    else
        self._hasBoat = bool
        self:UpdatePanel()
    end
end

function PlayerStatsPanel:HasVehicle(bool)
    if bool == nil then
        return self._hasVehicle
    else
        self._hasVehicle = bool
        self:UpdatePanel()
    end
end

function PlayerStatsPanel:AddStat(statItem)
    statItem.Parent = self
    statItem.idx = #self.Items
    table.insert(self.Items, statItem)
    self:UpdatePanel()
end

function PlayerStatsPanel:UpdatePanel(override)
    if override == nil then override = false end
    if ((self.ParentItem ~= nil and self.ParentItem.ParentColumn ~= nil and self.ParentItem.ParentColumn.Parent ~= nil and self.ParentItem.ParentColumn.Parent:Visible()) or override) then
        local idx = IndexOf(self.ParentItem.ParentColumn.Items, self.ParentItem) -1
        local pSubT = self.ParentItem.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL", false, idx, 0, self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0, self:Title(), self:Description(), self:TitleColor(), self.RankInfo:RankLevel(), self:HasPlane(), self:HasHeli(), self:HasBoat(), self:HasVehicle(), 0, self.RankInfo:LowLabel(), 0, 0, self.RankInfo:MidLabel(), 0, 0, self.RankInfo:UpLabel(), 0, 0)
            if not self:Description():IsNullOrEmpty() then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL_DESCRIPTION", false, idx, self:Description(), 0, "", self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0)
            end
            for k,stat in pairs(self.Items) do
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL_STAT", false, idx, stat.idx, 0, stat:Label(), stat:Description(), stat:Value())
            end
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL", false, self.ParentItem.ParentColumn.ParentTab, idx, 0, self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0, self:Title(), self:Description(), self:TitleColor(), self.RankInfo:RankLevel(), self:HasPlane(), self:HasHeli(), self:HasBoat(), self:HasVehicle(), 0, self.RankInfo:LowLabel(), 0, 0, self.RankInfo:MidLabel(), 0, 0, self.RankInfo:UpLabel(), 0, 0)
            if not self:Description():IsNullOrEmpty() then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL_DESCRIPTION", false, self.ParentItem.ParentColumn.ParentTab, idx, self:Description(), 0, "", self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0)
            end
            for k,stat in pairs(self.Items) do
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL_STAT", false, self.ParentItem.ParentColumn.ParentTab, idx, stat.idx, 0, stat:Label(), stat:Description(), stat:Value())
            end
        end
    end
end

UpperInformation = setmetatable({}, UpperInformation)
UpperInformation.__index = UpperInformation
UpperInformation.__call = function()
    return "ItemPanel_Info", "UpperInformation"
end

function UpperInformation.New(parent)
    local _data = {
        _parent = parent,
        _rankLevel = 0;
        _upLabel = "";
        _lowLabel = "";
        _midLabel = "";
    }
    return setmetatable(_data, UpperInformation)
end

function UpperInformation:RankLevel(rank)
    if rank == nil then
        return self._rankLevel
    else
        self._rankLevel = rank
        self._parent:UpdatePanel()
    end
end

function UpperInformation:UpLabel(label)
    if label == nil then
        return self._upLabel
    else
        self._upLabel = label
        self._parent:UpdatePanel()
    end
end

function UpperInformation:MidLabel(label)
    if label == nil then
        return self._midLabel
    else
        self._midLabel = label
        self._parent:UpdatePanel()
    end
end

function UpperInformation:LowLabel(label)
    if label == nil then
        return self._lowLabel
    else
        self._lowLabel = label
        self._parent:UpdatePanel()
    end
end

PlayerStatsPanelStatItem = setmetatable({}, PlayerStatsPanelStatItem)
PlayerStatsPanelStatItem.__index = PlayerStatsPanelStatItem
PlayerStatsPanelStatItem.__call = function()
    return "ItemPanel_item", "PlayerStatsPanelStatItem"
end

function PlayerStatsPanelStatItem.New(label, desc, value)
    local _data={
        Parent = parent,
        _idx = 0,
        _value = value or 0,
        _description = desc or "",
        _label = label or ""
    }
    return setmetatable(_data, PlayerStatsPanelStatItem)
end

function PlayerStatsPanelStatItem:Label(label)
    if label == nil then
        return self._label
    else
        self._label = label
        self.Parent:UpdatePanel()
    end
end

function PlayerStatsPanelStatItem:Description(desc)
    if desc == nil then
        return self._description
    else
        self._description = desc
        self.Parent:UpdatePanel()
    end
end

function PlayerStatsPanelStatItem:Value(value)
    if value == nil then
        return self._value
    else
        self._value = value
        self.Parent:UpdatePanel()
    end
end
