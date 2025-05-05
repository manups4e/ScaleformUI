MissionItem = {}
MissionItem.__index = MissionItem
setmetatable(MissionItem, { __index = PauseMenuItem })
MissionItem.__call = function() return "MissionItem" end

---@class MissionItem
---@field Label string
---@field ParentColumn MissionListColumn
---@field enabled boolean
---@field MainColor SColor
---@field HighlightColor SColor
---@field LeftIcon BadgeStyle
---@field LeftIconColor SColor
---@field RightIcon BadgeStyle
---@field RightIconColor SColor
---@field RightIconChecked boolean
---@field _Selected boolean
---@field hovered boolean
---@field Activated fun(item:MissionItem)
---@field Hovered fun(val:boolean)
---@field Enabled fun(bool:boolean)
---@field SetLeftIcon fun(icon:BadgeStyle, color:SColor)
---@field SetRightIcon fun(icon:BadgeStyle, color:SColor, checked:boolean)


---@param label string
---@param mainColor SColor | nil
---@param highlightColor SColor | nil
---@return table
function MissionItem.New(label, mainColor, highlightColor)
    local base = PauseMenuItem.New(label)
    base.type = 0
    base.enabled = true
    base.MainColor = mainColor or SColor.HUD_Pause_bg
    base.HighlightColor = highlightColor or SColor.HUD_White
    base.LeftIcon = BadgeStyle.NONE
    base.LeftIconColor = SColor.HUD_White
    base.RightIcon = BadgeStyle.NONE
    base.RightIconColor = SColor.HUD_White
    base.RightIconChecked = false
    base._Selected = false
    base.hovered = false
    base.customLeftIcon = {TXD="",TXN=""}
    base.customRightIcon = {TXD="",TXN=""}
    base.Activated = function(item)
    end
    return setmetatable(base, MissionItem)
end

function MissionItem:Hovered(val)
    if val == nil then
        return self.hovered
    else
        self.hovered = val
    end
end

function MissionItem:Enabled(bool)
    if bool == nil then
        return self.enabled
    else
        self.enabled = bool
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
end

function MissionItem:SetLeftIcon(icon, color)
    self.LeftIcon = icon
    self.LeftIconColor = color
    if self.ParentColumn ~= nil and self.ParentColumn:visible() then
        self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
    end
end

function MissionItem:SetRightIcon(icon, color, checked)
    self.RightIcon = icon
    self.RightIconColor = color
    self.RightIconChecked = checked or false
    if self.ParentColumn ~= nil and self.ParentColumn:visible() then
        self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
    end
end

function MissionItem:SetCustomLeftIcon(txd, txn)
    self.LeftIcon = BadgeStyle.CUSTOM
    self.customLeftIcon = {TXD=txd, TXN=txn}
    if self.ParentColumn ~= nil and self.ParentColumn:visible() then
        self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
    end
end
function MissionItem:SetCustomRightIcon(txd, txn, checked)
    self.RightIcon = BadgeStyle.CUSTOM
    self.RightIconChecked = checked or false
    self.customRightIcon = {TXD=txd, TXN=txn}
    if self.ParentColumn ~= nil and self.ParentColumn:visible() then
        self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
    end
end

function MissionItem:Selected(bool)
    if bool == nil then
        return self._Selected
    else
        self._Selected = bool
    end
end
