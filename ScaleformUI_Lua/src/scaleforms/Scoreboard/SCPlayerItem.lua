SCPlayerItem = setmetatable({}, SCPlayerItem)
SCPlayerItem.__index = SCPlayerItem
SCPlayerItem.__call = function()
    return "SCPlayerItem"
end

---@class SCPlayerItem
---@field public Name string
---@field public Color Colours
---@field public RightIcon string
---@field public RightText string
---@field public FriendType number
---@field public CrewLabelText string
---@field public IconOverlayText string
---@field public JobPointsDisplayType number
---@field public JobPointsText string
---@field public ServerId number
---@field public TextureString string

---Creates a new SCPlayerItem instance
---@param label string
---@param color Colours
---@param rightIcon string
---@param rightText string
---@param friendType number
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
