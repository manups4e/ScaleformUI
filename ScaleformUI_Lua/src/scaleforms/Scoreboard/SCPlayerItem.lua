SCPlayerItem = setmetatable({}, SCPlayerItem)
SCPlayerItem.__index = SCPlayerItem
SCPlayerItem.__call = function()
    return "SCPlayerItem"
end

---@class SCPlayerItem
---@field public Name string
---@field public Color HudColours
---@field public RightIcon number
---@field public RightText number
---@field public FriendType string
---@field public CrewLabelText string
---@field public IconOverlayText string
---@field public JobPointsDisplayType number
---@field public JobPointsText string
---@field public ServerId number
---@field public TextureString string

---Creates a new SCPlayerItem instance
---@param label string
---@param color HudColours
---@param rightIcon number
---@param rightText number
---@param friendType string
---@param crewLabel string
---@param iconText string
---@param jobPointsType number
---@param jobPointsText string
---@param serverId number
---@param txd string
---@return SCPlayerItem
function SCPlayerItem.New(label, color, rightIcon, rightText, friendType, crewLabel, iconText, jobPointsType,
                          jobPointsText, serverId, txd)
    local data = {
        Name = label,
        Color = color,
        RightIcon = rightIcon,
        RightText = rightText,
        FriendType = friendType,
        CrewLabelText = crewLabel,
        IconOverlayText = iconText,
        JobPointsDisplayType = jobPointsType,
        JobPointsText = jobPointsText,
        ServerId = serverId,
        TextureString = txd,
    }
    return setmetatable(data, SCPlayerItem)
end
