MissionDetailsItem = setmetatable({}, MissionDetailsItem)
MissionDetailsItem.__index = MissionDetailsItem
MissionDetailsItem.__call = function()
    return "MissionDetailsItem"
end

---@class MissionDetailsItem
---@field public Type number
---@field public TextLeft string
---@field public TextRight string
---@field public Icon string
---@field public IconColor number
---@field public Tick boolean

function MissionDetailsItem.New(textLeft, textRight, seperator, icon, iconColor, tick)
    local _type
    if seperator == true then
        _type = 4
    elseif icon ~= nil and iconColor ~= nil then
        _type = 2
    else
        _type = 0
    end
    _MissionDetailsItem = {
        Type = _type,
        TextLeft = textLeft,
        TextRight = textRight,
        Icon = icon,
        IconColor = iconColor,
        Tick = tick or false
    }
    return setmetatable(_MissionDetailsItem, MissionDetailsItem)
end
