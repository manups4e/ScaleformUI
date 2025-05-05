PlayerStatsPanel = {}
PlayerStatsPanel.__index = PlayerStatsPanel
setmetatable(PlayerStatsPanel, { __index = PM_Column })
PlayerStatsPanel.__call = function() return "PlayerStatsPanel" end

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
    local base = PM_Column.New(3)
    base.VisibleItems = 10
    base.ParentItem = nil
    base._hardwareVisible = true
    base._title = title or ""
    base._description = ""
    base._titleColor = titleColor or SColor.HUD_Freemode
    base._hasPlane = false
    base._hasVehicle = false
    base._hasBoat = false
    base._hasHeli = false
    base.RankInfo = nil
    base.DetailsItems = {}
    local retVal = setmetatable(base, PlayerStatsPanel)
    retVal.RankInfo = UpperInformation.New(retVal)
    retVal.CrewInfo = BottomInformation.New(retVal)
    return retVal
end

function PlayerStatsPanel:visible()
    return PM_Column.visible(self)
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
    if self:visible() then
        self:UpdatePanel()
    end
end

function PlayerStatsPanel:AddDescriptionStatItem(item)
    table.insert(self.DetailsItems, item)
    if self:visible() then
        self:UpdatePanel()
    end
end

---Triggers the panel to update.
---@param override boolean? If true, the panel will update regardless of the parent's visibility.
function PlayerStatsPanel:UpdatePanel(override)
    if ((self.ParentItem ~= nil and self.ParentItem.ParentColumn ~= nil and self.ParentItem.ParentColumn:visible()) or override) then
        if self.ParentItem.ClonePed == 0 then
            self.position = 3
        else
            self.position = 4
        end
        self.Parent = self.ParentItem.ParentColumn.Parent
        self:Populate()
        self:ShowColumn()
    end
end

function PlayerStatsPanel:Populate()
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT_EMPTY", self.position)
    if self.CrewInfo:IsFilled() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_TITLE", self.position, self._title,
            self.CrewInfo:CrewName(), self:TitleColor(), "", self.CrewInfo:RankName(), ParentItem.CrewTag,
            self.CrewInfo:CrewDict(), self.CrewInfo:CrewTxtr(), self.CrewInfo:CrewTag().TAG, self.CrewInfo:CrewColor().R,
            self.CrewInfo:CrewColor().G, self.CrewInfo:CrewColor().B, 0, "")
    else
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_TITLE", self.position, self._title, "",
            self:TitleColor(), "", "", self.ParentItem:CrewTag().TAG, "", "", "", 0, 0, 0, 0, "")
    end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT", self.position, 0, 0, 0, 0, self:HasPlane(),
        self:HasHeli(), self:HasBoat(), self:HasVehicle(), 0, self.RankInfo:RankLevel(), self.RankInfo:LowLabel(), 0, 0,
        self.RankInfo:MidLabel(), 0, 0, self.RankInfo:UpLabel(), 0, 0, self:HardwareVisible())
    for i = 1, #self.Items, 1 do
        local stat = self.Items[i]
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT", self.position, 1, i - 1, 0, stat:Label(),
            stat:Description(), stat:Value())
    end
    if #self.DetailsItems > 0 and self.position == 3 then
        for i = 1, #self.DetailsItems, 1 do
            local item = self.DetailsItems[i]
            BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(self.position)
            PushScaleformMovieFunctionParameterInt(2)
            PushScaleformMovieFunctionParameterInt(i - 1)
            PushScaleformMovieFunctionParameterInt(0)
            PushScaleformMovieFunctionParameterInt(0)
            PushScaleformMovieFunctionParameterInt(item.Type)
            PushScaleformMovieFunctionParameterInt(0)
            PushScaleformMovieFunctionParameterBool(true)
            local labels = item.label:SplitLabel()
            BeginTextCommandScaleformString("CELL_EMAIL_BCON")
            for j = 1, #labels, 1 do
                AddTextComponentScaleform(labels[j])
            end
            EndTextCommandScaleformString_2()
            PushScaleformMovieFunctionParameterString(item.TextRight)
            if item.Type == 2 then
                PushScaleformMovieFunctionParameterInt(item.Icon)
                PushScaleformMovieFunctionParameterInt(item.IconColor:ToArgb())
                PushScaleformMovieFunctionParameterBool(item.Tick)
            elseif item.Type == 3 then
                PushScaleformMovieFunctionParameterString(item.CrewTag.TAG)
                PushScaleformMovieFunctionParameterBool(false)
            end
            PushScaleformMovieFunctionParameterString(item.LabelFont.FontName)
            PushScaleformMovieFunctionParameterString(item._rightLabelFont.FontName)
            EndScaleformMovieMethod()
        end
    elseif not self:Description():IsNullOrEmpty() and not self.CrewInfo:IsFilled() then
        BeginScaleformMovieMethod(ScaleformUI.Scaleforms._pauseMenu._pause.handle, "SET_DESCRIPTION")
        PushScaleformMovieFunctionParameterInt(self.position)
        local labels = self:Description():SplitLabel()
        BeginTextCommandScaleformString("CELL_EMAIL_BCON")
        for j = 1, #labels, 1 do
            AddTextComponentScaleform(labels[j])
        end
        EndTextCommandScaleformString_2()
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterString(self.ParentItem:CrewTag().TAG)
        PushScaleformMovieFunctionParameterBool(ToBool(self.ParentItem.ClonePed ~= 0))
        EndScaleformMovieMethod()
    end
end

function PlayerStatsPanel:SetDataSlot(index)
    self:Populate()
end

function PlayerStatsPanel:UpdateSlot(index)
    if index > #self.Items then return end
    if self:visible() then
        self:Populate()
    end
end
function PlayerStatsPanel:AddSlot(index)
    if index > #self.Items then return end
    if self:visible() then
        self:Populate()
    end
end