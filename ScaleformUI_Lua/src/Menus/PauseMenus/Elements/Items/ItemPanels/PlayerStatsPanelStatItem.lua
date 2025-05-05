PlayerStatsPanelStatItem = setmetatable({}, PlayerStatsPanelStatItem)
PlayerStatsPanelStatItem.__index = PlayerStatsPanelStatItem
PlayerStatsPanelStatItem.__call = function()
    return "ItemPanel_item", "PlayerStatsPanelStatItem"
end

---@class PlayerStatsPanelStatItem
---@field Parent PlayerStatsPanel
---@field public _idx number
---@field private _value number
---@field private _description string
---@field private _label string
---@field public Label fun(self: PlayerStatsPanelStatItem, label: string?): string
---@field public Description fun(self: PlayerStatsPanelStatItem, desc: string?): string
---@field public Value fun(self: PlayerStatsPanelStatItem, value: number?): number

---Creates a new PlayerStatsPanelStatItem.
---@param label string
---@param desc string
---@param value number
---@return PlayerStatsPanelStatItem
function PlayerStatsPanelStatItem.New(label, desc, value)
    local _data = {
        Parent = nil,
        _idx = 0,
        _value = value or 0,
        _description = desc or "",
        _label = label or ""
    }
    return setmetatable(_data, PlayerStatsPanelStatItem)
end

---Sets the label of the item if supplied else it will return the current label.
---@param label string?
---@return string
function PlayerStatsPanelStatItem:Label(label)
    if label ~= nil then
        self._label = label
        self.Parent:UpdatePanel()
    end
    return self._label
end

---Sets the description of the item if supplied else it will return the current description.
---@param desc string?
---@return string
function PlayerStatsPanelStatItem:Description(desc)
    if desc ~= nil then
        self._description = desc
        self.Parent:UpdatePanel()
    end
    return self._description
end

---Sets the value of the item if supplied else it will return the current value.
---@param value number?
---@return number
function PlayerStatsPanelStatItem:Value(value)
    if value ~= nil then
        self._value = value
        self.Parent:UpdatePanel()
    end
    return self._value
end
