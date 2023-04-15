PlayerStatsPanel = setmetatable({}, PlayerStatsPanel)
PlayerStatsPanel.__index = PlayerStatsPanel
PlayerStatsPanel.__call = function()
    return "ItemPanel", "PlayerStatsPanel"
end

---@class PlayerStatsPanel
---@field private _title string
---@field private _description string
---@field private _titleColor number
---@field private _hasPlane boolean
---@field private _hasVehicle boolean
---@field private _hasBoat boolean
---@field private _hasHeli boolean
---@field public ParentItem FriendItem
---@field public RankInfo UpperInformation
---@field public Items PlayerStatsPanelStatItem[]
---@field public UpdatePanel fun(override: boolean|nil)
---@field public OnItemChanged fun(item: PlayerStatsPanelStatItem)
---@field public OnItemActivated fun(item: PlayerStatsPanelStatItem)
---@field public Description fun(desc: string|nil): string
---@field public HasPlane fun(bool: boolean|nil): boolean
---@field public HasHeli fun(bool: boolean|nil): boolean
---@field public HasBoat fun(bool: boolean|nil): boolean
---@field public HasVehicle fun(bool: boolean|nil): boolean
---@field public AddStat fun(statItem: PlayerStatsPanelStatItem)

---Creates a new PlayerStatsPanel.
---@param title string
---@param titleColor number
---@return PlayerStatsPanel
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
        RankInfo = nil,
        Items = {}
    }
    local retVal = setmetatable(_data, PlayerStatsPanel)
    retVal.RankInfo = UpperInformation.New(retVal)
    return retVal
end

---Sets the title of the panel if supplied else it will return the current title.
---@param label string|nil
---@return string
function PlayerStatsPanel:Title(label)
    if label ~= nil then
        self._title = label
        self:UpdatePanel()
    end
    return self._title
end

---Sets the title color of the panel if supplied else it will return the current color.
---@param color number|nil
---@return number
function PlayerStatsPanel:TitleColor(color)
    if color ~= nil then
        self._titleColor = color
        self:UpdatePanel()
    end
    return self._titleColor
end

---Sets the description of the panel if supplied else it will return the current description.
---@param label string|nil
---@return string
function PlayerStatsPanel:Description(label)
    if label ~= nil then
        self._description = label
        self:UpdatePanel()
    end
    return self._description
end

---Sets whether the player has a plane or not, if parameter is nill, it will return the current value.
---@param bool boolean|nil
---@return boolean
function PlayerStatsPanel:HasPlane(bool)
    if bool ~= nil then
        self._hasPlane = bool
        self:UpdatePanel()
    end
    return self._hasPlane
end

---Sets whether the player has a helicopter or not, if parameter is nill, it will return the current value.
---@param bool boolean|nil
---@return boolean
function PlayerStatsPanel:HasHeli(bool)
    if bool ~= nil then
        self._hasHeli = bool
        self:UpdatePanel()
    end
    return self._hasHeli
end

---Sets whether the player has a boat or not, if parameter is nill, it will return the current value.
---@param bool boolean|nil
---@return boolean
function PlayerStatsPanel:HasBoat(bool)
    if bool ~= nil then
        self._hasBoat = bool
        self:UpdatePanel()
    end
    return self._hasBoat
end

---Sets whether the player has a vehicle or not, if parameter is nill, it will return the current value.
---@param bool boolean|nil
---@return boolean
function PlayerStatsPanel:HasVehicle(bool)
    if bool ~= nil then
        self._hasVehicle = bool
        self:UpdatePanel()
    end
    return self._hasVehicle
end

---Adds a new stat item to the panel.
---@param statItem PlayerStatsPanelStatItem
function PlayerStatsPanel:AddStat(statItem)
    statItem.Parent = self
    statItem.idx = #self.Items
    self.Items[#self.Items + 1] = statItem
    self:UpdatePanel()
end

---Triggers the panel to update.
---@param override boolean|nil If true, the panel will update regardless of the parent's visibility.
function PlayerStatsPanel:UpdatePanel(override)
    if override == nil then override = false end
    if ((self.ParentItem ~= nil and self.ParentItem.ParentColumn ~= nil and self.ParentItem.ParentColumn.Parent ~= nil and self.ParentItem.ParentColumn.Parent:Visible()) or override) then
        local idx = IndexOf(self.ParentItem.ParentColumn.Items, self.ParentItem) - 1
        local pSubT = self.ParentItem.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL", false, idx, 0,
                self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0, self:Title(), self:Description(),
                self:TitleColor(), self.RankInfo:RankLevel(), self:HasPlane(), self:HasHeli(), self:HasBoat(),
                self:HasVehicle(), 0, self.RankInfo:LowLabel(), 0, 0, self.RankInfo:MidLabel(), 0, 0,
                self.RankInfo:UpLabel(),
                0, 0)
            if not self:Description():IsNullOrEmpty() then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL_DESCRIPTION", false, idx,
                    self:Description(), 0, "", self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0)
            end
            for k, stat in pairs(self.Items) do
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL_STAT", false, idx, stat.idx,
                    0, stat:Label(), stat:Description(), stat:Value())
            end
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL", false,
                self.ParentItem.ParentColumn.ParentTab, idx, 0,
                self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0, self:Title(), self:Description(),
                self:TitleColor(), self.RankInfo:RankLevel(), self:HasPlane(), self:HasHeli(), self:HasBoat(),
                self:HasVehicle(), 0, self.RankInfo:LowLabel(), 0, 0, self.RankInfo:MidLabel(), 0, 0,
                self.RankInfo:UpLabel(),
                0, 0)
            if not self:Description():IsNullOrEmpty() then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL_DESCRIPTION",
                    false, self.ParentItem.ParentColumn.ParentTab, idx, self:Description(), 0, "",
                    self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0)
            end
            for k, stat in pairs(self.Items) do
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL_STAT", false,
                    self.ParentItem.ParentColumn.ParentTab, idx, stat.idx, 0, stat:Label(), stat:Description(),
                    stat:Value())
            end
        end
    end
end
