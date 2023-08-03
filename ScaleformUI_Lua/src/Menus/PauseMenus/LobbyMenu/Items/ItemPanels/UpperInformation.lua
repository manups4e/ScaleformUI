UpperInformation = setmetatable({}, UpperInformation)
UpperInformation.__index = UpperInformation
UpperInformation.__call = function()
    return "ItemPanel_Info", "UpperInformation"
end

---@class UpperInformation
---@field private _parent UpperInformation
---@field private _rankLevel number
---@field private _upLabel string
---@field private _lowLabel string
---@field private _midLabel string
---@field public RankLevel fun(self: UpperInformation, rank: number?): number
---@field public UpLabel fun(self: UpperInformation, label: string?): string
---@field public MidLabel fun(self: UpperInformation, label: string?): string
---@field public LowLabel fun(self: UpperInformation, label: string?): string

---Creates a new UpperInformation.
---@param parent UpperInformation
---@return UpperInformation
function UpperInformation.New(parent)
    local _data = {
        _parent = parent,
        _rankLevel = 0,
        _upLabel = "",
        _lowLabel = "",
        _midLabel = "",
    }
    return setmetatable(_data, UpperInformation)
end

---Sets the rank level of the item if supplied else it will return the current rank level.
---@param rank number?
---@return number
function UpperInformation:RankLevel(rank)
    if rank ~= nil then
        self._rankLevel = rank
        self._parent:UpdatePanel()
    end
    return self._rankLevel
end

---Sets the up label of the item if supplied else it will return the current up label.
---@param label string?
---@return string
function UpperInformation:UpLabel(label)
    if label ~= nil then
        self._upLabel = label
        self._parent:UpdatePanel()
    end
    return self._upLabel
end

---Sets the middle label of the item if supplied else it will return the current middle label.
---@param label string?
---@return string
function UpperInformation:MidLabel(label)
    if label ~= nil then
        self._midLabel = label
        self._parent:UpdatePanel()
    end
    return self._midLabel
end

---Sets the low label of the item if supplied else it will return the current low label.
---@param label string?
---@return string
function UpperInformation:LowLabel(label)
    if label ~= nil then
        self._lowLabel = label
        self._parent:UpdatePanel()
    end
    return self._lowLabel
end
