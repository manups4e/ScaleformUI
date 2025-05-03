BottomInformation = setmetatable({}, BottomInformation)
BottomInformation.__index = BottomInformation
BottomInformation.__call = function()
    return "ItemPanel_Info", "BottomInformation"
end

---@class BottomInformation
---@field private _parent BottomInformation
---@field private _rankLevel number
---@field private _upLabel string
---@field private _lowLabel string
---@field private _midLabel string
---@field public RankLevel fun(self: BottomInformation, rank: number?): number
---@field public UpLabel fun(self: BottomInformation, label: string?): string
---@field public MidLabel fun(self: BottomInformation, label: string?): string
---@field public LowLabel fun(self: BottomInformation, label: string?): string

---Creates a new BottomInformation.
---@param parent BottomInformation
---@return BottomInformation
function BottomInformation.New(parent)
    local _data = {
        _parent = parent,
        crewName = "",
        rankName = "",
        crewDict = "",
        crewTxtr = "",
        crewtag = "",
        crewColor = SColor.HUD_Pure_white
    }
    return setmetatable(_data, BottomInformation)
end

function BottomInformation:IsFilled()
    return not self:CrewName():IsNullOrEmpty() and not self:RankName():IsNullOrEmpty() and not self:CrewDict():IsNullOrEmpty() and not self:CrewTxtr():IsNullOrEmpty() and not self:CrewTag():IsNullOrEmpty()
end

function BottomInformation:CrewName(val)
    if val == nil then return self.crewName end
    self.crewName = val
    if self.Parent ~= nil and self.Parent:visible() then
        self.Parent:UpdatePanel()
    end
end
function BottomInformation:RankName(val)
    if val == nil then return self.rankName end
    self.rankName = val
    if self.Parent ~= nil and self.Parent:visible() then
        self.Parent:UpdatePanel()
    end
end
function BottomInformation:CrewDict(val)
    if val == nil then return self.crewDict end
    self.crewDict = val
    if self.Parent ~= nil and self.Parent:visible() then
        self.Parent:UpdatePanel()
    end
end
function BottomInformation:CrewTxtr(val)
    if val == nil then return self.crewTxtr end
    self.crewTxtr = val
    if self.Parent ~= nil and self.Parent:visible() then
        self.Parent:UpdatePanel()
    end
end
function BottomInformation:CrewColor(val)
    if val == nil then return self.crewColor end
    self.crewColor = val
    if self.Parent ~= nil and self.Parent:visible() then
        self.Parent:UpdatePanel()
    end
end
function BottomInformation:CrewTag(val)
    if val == nil then return self.crewTag end
    self.crewTag = val
    if self.Parent ~= nil and self.Parent:visible() then
        self.Parent:UpdatePanel()
    end
end
