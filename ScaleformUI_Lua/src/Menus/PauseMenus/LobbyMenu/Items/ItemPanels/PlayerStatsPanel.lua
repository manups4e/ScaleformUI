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
---@field public UpdatePanel fun(self: PlayerStatsPanel, override: boolean?)
---@field public Description fun(self: PlayerStatsPanel, desc: string?): string
---@field public HasPlane fun(self: PlayerStatsPanel, bool: boolean?): boolean
---@field public HasHeli fun(self: PlayerStatsPanel, bool: boolean?): boolean
---@field public HasBoat fun(self: PlayerStatsPanel, bool: boolean?): boolean
---@field public HasVehicle fun(self: PlayerStatsPanel, bool: boolean?): boolean
---@field public HardwareVisible fun(self: PlayerStatsPanel, bool: boolean?): boolean
---@field public AddStat fun(self: PlayerStatsPanel, statItem: PlayerStatsPanelStatItem)
---@field public OnItemChanged fun(item: PlayerStatsPanelStatItem)
---@field public OnItemActivated fun(item: PlayerStatsPanelStatItem)

---Creates a new PlayerStatsPanel.
---@param title string
---@param titleColor number
---@return PlayerStatsPanel
function PlayerStatsPanel.New(title, titleColor)
    local _data = {
        ParentItem = nil,
        _hardwareVisible = true,
        _title = title or "",
        _description = "",
        _titleColor = titleColor or SColor.HUD_Freemode,
        _hasPlane = false,
        _hasVehicle = false,
        _hasBoat = false,
        _hasHeli = false,
        RankInfo = nil,
        DetailsItems = {},
        Items = {}
    }
    local retVal = setmetatable(_data, PlayerStatsPanel)
    retVal.RankInfo = UpperInformation.New(retVal)
    return retVal
end

function PlayerStatsPanel:HardwareVisible(v)
    if v == nil then 
        return self._hardwareVisible
    else
        self._hardwareVisible = v
    end
end

---Sets the title of the panel if supplied else it will return the current title.
---@param label string?
---@return string
function PlayerStatsPanel:Title(label)
    if label ~= nil then
        self._title = label
        self:UpdatePanel()
    end
    return self._title
end

---Sets the title color of the panel if supplied else it will return the current color.
---@param color SColor?
---@return SColor
function PlayerStatsPanel:TitleColor(color)
    if color ~= nil then
        self._titleColor = color
        self:UpdatePanel()
    end
    return self._titleColor
end

---Sets the description of the panel if supplied else it will return the current description.
---@param label string?
---@return string
function PlayerStatsPanel:Description(label)
    if label ~= nil then
        self._description = label
        self:UpdatePanel()
    end
    return self._description
end

---Sets whether the player has a plane or not, if parameter is nill, it will return the current value.
---@param bool boolean?
---@return boolean
function PlayerStatsPanel:HasPlane(bool)
    if bool ~= nil then
        self._hasPlane = bool
        self:UpdatePanel()
    end
    return self._hasPlane
end

---Sets whether the player has a helicopter or not, if parameter is nill, it will return the current value.
---@param bool boolean?
---@return boolean
function PlayerStatsPanel:HasHeli(bool)
    if bool ~= nil then
        self._hasHeli = bool
        self:UpdatePanel()
    end
    return self._hasHeli
end

---Sets whether the player has a boat or not, if parameter is nill, it will return the current value.
---@param bool boolean?
---@return boolean
function PlayerStatsPanel:HasBoat(bool)
    if bool ~= nil then
        self._hasBoat = bool
        self:UpdatePanel()
    end
    return self._hasBoat
end

---Sets whether the player has a vehicle or not, if parameter is nill, it will return the current value.
---@param bool boolean?
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
    statItem._idx = #self.Items
    table.insert(self.Items, statItem)
    self:UpdatePanel()
end

function PlayerStatsPanel:AddDescriptionStatItem(item)
    table.insert(self.DetailsItems, item)
    self:UpdatePanel()
end

---Triggers the panel to update.
---@param override boolean? If true, the panel will update regardless of the parent's visibility.
function PlayerStatsPanel:UpdatePanel(override)
    if override == nil then override = false end
    if ((self.ParentItem ~= nil and self.ParentItem.ParentColumn ~= nil and self.ParentItem.ParentColumn.Parent ~= nil and self.ParentItem.ParentColumn.Parent:Visible()) or override) then
        local idx = self.ParentItem.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentItem.ParentColumn.Items, self.ParentItem))
        local pSubT = self.ParentItem.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL", idx, 0, (self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0), self:Title(), self:Description(), self:TitleColor(), self.RankInfo:RankLevel(), self:HasPlane(), self:HasHeli(), self:HasBoat(), self:HasVehicle(), 0, self.RankInfo:LowLabel(), 0, 0, self.RankInfo:MidLabel(), 0, 0, self.RankInfo:UpLabel(), 0, 0, self._hardwareVisible)
            for k, stat in pairs(self.Items) do
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL_STAT", idx, stat.idx, 0, stat:Label(), stat:Description(), stat:Value())
            end
            if not self:Description():IsNullOrEmpty() then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL_DESCRIPTION", idx, self:Description(), 0, "", (self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0))
            else 
                for k, item in pairs (self.DetailsItems) do
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_PLAYER_ITEM_PANEL_DETAIL", idx, item.Type, item.TextLeft, item.TextRight, item.Icon, item.IconColor, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID)
                end
            end
        elseif pSubT == "PauseMenu" and self.ParentItem.ParentColumn.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL", idx, 0, (self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0), self:Title(), self:Description(), self:TitleColor(), self.RankInfo:RankLevel(), self:HasPlane(), self:HasHeli(), self:HasBoat(), self:HasVehicle(), 0, self.RankInfo:LowLabel(), 0, 0, self.RankInfo:MidLabel(), 0, 0, self.RankInfo:UpLabel(), 0, 0, self._hardwareVisible)
            for k, stat in pairs(self.Items) do
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL_STAT", idx, stat.idx, 0, stat:Label(), stat:Description(), stat:Value())
            end
            if not self:Description():IsNullOrEmpty() then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL_DESCRIPTION", idx, self:Description(), 0, "", (self.ParentItem.ClonePed ~= nil and self.ParentItem.ClonePed ~= 0))
            else 
                for k, item in pairs (self.DetailsItems) do
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_PLAYER_ITEM_PANEL_DETAIL", idx, item.Type, item.TextLeft, item.TextRight, item.Icon, item.IconColor, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID)
                end
            end
        end
    end
end
