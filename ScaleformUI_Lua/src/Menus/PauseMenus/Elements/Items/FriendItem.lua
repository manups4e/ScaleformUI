FriendItem = {}
FriendItem.__index = FriendItem
setmetatable(FriendItem, { __index = PauseMenuItem })
FriendItem.__call = function() return "FriendItem" end

---@class FriendItem
---@field public Label string
---@field public ItemColor SColor
---@field public ColoredTag boolean
---@field public Rank number
---@field public Status string
---@field public StatusColor SColor
---@field public _crewTag CrewTag
---@field public _iconL number
---@field public _iconR number
---@field public _boolL boolean
---@field public _boolR boolean
---@field public ParentColumn PlayerListColumn
---@field public ClonePed number
---@field public Panel PlayerStatsPanel
---@field public Handle number
---@field public SetLeftIcon fun(self: FriendItem, icon: LobbyBadgeIcon|BadgeStyle, bool: boolean):nil
---@field public SetRightIcon fun(self: FriendItem, icon: LobbyBadgeIcon|BadgeStyle, bool: boolean):nil
---@field public AddPedToPauseMenu fun(self: FriendItem, ped: number):number
---@field public AddPanel fun(self: FriendItem, panel: PlayerStatsPanel)
---@field public Enabled fun(self: FriendItem, enabled: boolean):boolean

---Creates a new FriendItem.
---@param label string
---@param itemColor SColor
---@param coloredTag boolean
---@param rank number
---@param status string
---@param crewTag string
---@return FriendItem
function FriendItem.New(label, itemColor, coloredTag, rank, status, crewTag)
    if itemColor == nil then itemColor = SColor.HUD_Freemode end
    local base = PauseMenuItem.New(label)
    base.keepPanelVisible = false
    base._itemColor = itemColor or SColor.HUD_Freemode
    base._rank = rank or 0
    base._status = status or ""
    base._statusColor = itemColor or SColor.HUD_Freemode
    base._crewTag = crewTag or CrewTag.New()
    base._iconL = 0
    base._iconR = 65
    base._boolL = false
    base._boolR = false
    base._coloredTag = coloredTag or true
    base.ClonePed = 0
    base._clonePedEntity = 0
    base.Panel = nil
    base.Handle = nil
    return setmetatable(base, FriendItem)
end

--

---Sets the label of the item if supplied else it will return the current label.
---@param label string?
---@return string
function FriendItem:Label(label)
    if label ~= nil then
        self.label = label
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self.label
end

function FriendItem:KeepPanelVisible(bool)
    if bool ~= nil then
        self.keepPanelVisible = bool
        if self.Panel ~= nil then
            self.Panel:UpdatePanel()
        end
        if self.ParentColumn.CurrentSelection() == IndexOf(self.ParentColumn.Items, self) then
            if self.ParentColumn ~= nil and self.ParentColumn:visible() then
                self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
            end
       end
    else
        return self.keepPanelVisible
    end
end

---Adds a ped to the pause menu or returns the current ped.
function FriendItem:HidePed(ped)
    SetEntityVisible(ped, false, false)
    SetEntityInvincible(ped, true)
    SetEntityCollision(ped, false, false)
    FreezeEntityPosition(ped, true)
    local cc = GetEntityCoords(PlayerPedId());
    local coords = cc + vector3(0, 0, -50)
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true);
end

function FriendItem:AddPedToPauseMenu()
    if self.ClonePed == 0 then
        ClearPedInPauseMenu()
        return -1
    end
    -- delete the old ped if it exists
    if self._clonePedEntity ~= 0 then
        if DoesEntityExist(self._clonePedEntity) then
            SetEntityAsMissionEntity(self._clonePedEntity, true, true)
            DeleteEntity(self._clonePedEntity)
            self._clonePedEntity = 0
        end
    end
    if self.ParentColumn:visible() then
        if self.Panel ~= nil then
            self.Panel:UpdatePanel()
            self.Panel:ShowColumn()
            self.Panel:ColumnVisible(true)
        end
        Citizen.CreateThread(function()
            Wait(100)
            if self.ParentColumn.Items[self.ParentColumn:CurrentSelection()] == self then
                self._clonePedEntity = ClonePed(self.ClonePed, false, false, true)
                self:HidePed(self._clonePedEntity)
                FinalizeHeadBlend(self._clonePedEntity)
                GivePedToPauseMenu(self._clonePedEntity, 2)
                SetPauseMenuPedSleepState(true)
                SetPauseMenuPedLighting(true)
            end
        end)
    end
end

function FriendItem:Dispose()
    ClearPedInPauseMenu()
    if self._clonePedEntity ~= 0 then
        if DoesEntityExist(self._clonePedEntity) then
            SetEntityAsMissionEntity(self._clonePedEntity, true, true)
            DeleteEntity(self._clonePedEntity)
            self._clonePedEntity = 0
        end
    end
    if self.Panel ~= nil then
        self.Panel:ColumnVisible(false)
    end
end

---Sets the item color of the item if supplied else it will return the current item color.
function FriendItem:ItemColor(color)
    if color ~= nil then
        self._itemColor = color
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self._itemColor
end

-- Sets if the item color should be used for the crew tag, if the argument is nil it will return the current value.
---@param enableColorTag boolean
---@return boolean
function FriendItem:ColoredTag(enableColorTag)
    if enableColorTag ~= nil then
        self._coloredTag = enableColorTag
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self._coloredTag
end

---Sets the rank of the item if supplied else it will return the current rank.
---@param rank number?
---@return number
function FriendItem:Rank(rank)
    if rank ~= nil then
        self._rank = rank
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self._rank
end

---Sets the status of the item if supplied else it will return the current status.
---@param status string?
---@return string
function FriendItem:Status(status)
    if status ~= nil then
        self._status = status
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self._status
end

---Sets the status color of the item if supplied else it will return the current status color.
---@param color SColor
---@return SColor
function FriendItem:StatusColor(color)
    if color ~= nil then
        self._statusColor = color
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self._statusColor
end

---Sets the crew tag of the item if supplied else it will return the current crew tag.
---@param tag CrewTag?
---@return CrewTag | nil
function FriendItem:CrewTag(tag)
    if tag then
        self._crewTag = tag
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    else
        return self._crewTag
    end
end

---Sets the left icon of the item.
---@param icon LobbyBadgeIcon?
---@param isBadge boolean?
function FriendItem:SetLeftIcon(icon, isBadge)
    self._iconL = icon;
    self._boolL = isBadge or false;
    if self.ParentColumn ~= nil and self.ParentColumn:visible() then
        self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
    end
end

---Sets the right icon of the item.
---@param icon LobbyBadgeIcon?
---@param isBadge boolean?
function FriendItem:SetRightIcon(icon, isBadge)
    self._iconR = icon;
    self._boolR = isBadge or false;
    if self.ParentColumn ~= nil and self.ParentColumn:visible() then
        self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
    end
end

---Sets the selected state of the item if supplied else it will return the current selected state.
---@param bool boolean?
---@return boolean
function FriendItem:Selected(bool)
    if bool ~= nil then
        self._Selected = ToBool(bool)
        ClearPedInPauseMenu()
        if self._Selected then
            self:AddPedToPauseMenu()
        else
            self:Dispose()
        end
    end
    return self._Selected
end

---Sets the hovered state of the item if supplied else it will return the current hovered state.
function FriendItem:Hovered(bool)
    if bool ~= nil then
        self._Hovered = ToBool(bool)
    end
    return self._Hovered
end

---Sets the enabled state of the item if supplied else it will return the current enabled state.
function FriendItem:Enabled(bool)
    if bool ~= nil then
        self._Enabled = ToBool(bool)
    end
    return self._Enabled
end

---Adds a player stats panel to the item.
---@param panel PlayerStatsPanel
function FriendItem:AddPanel(panel)
    panel.ParentItem = self
    self.Panel = panel
    self.Panel:UpdatePanel()
end
