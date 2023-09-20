JobSelectionCard = setmetatable({}, JobSelectionCard)
JobSelectionCard.__index = JobSelectionCard
JobSelectionCard.__call = function()
    return "JobSelectionCard"
end

---@class JobSelectionCard
---@field public Title string
---@field public Description string
---@field public Txd string
---@field public Txn string
---@field public RpMultiplier number
---@field public CashMultiplier number
---@field public Icon JobSelectionCardIcon
---@field public IconColor HudColours
---@field public ApMultiplier number
---@field public Details table<MissionDetailsItem>

---Creates a new JobSelectionCard object
---@param title string
---@param description string
---@param txd string
---@param txn string
---@param rpMult number
---@param cashMult number
---@param icon JobSelectionCardIcon
---@param iconColor HudColours
---@param apMultiplier number
---@param details table<MissionDetailsItem>
---@return JobSelectionCard
function JobSelectionCard.New(title, description, txd, txn, rpMult, cashMult, icon, iconColor, apMultiplier, details)
    local data = {
        Title = title,
        Description = description,
        Txd = txd,
        Txn = txn,
        RpMultiplier = rpMult,
        CashMultiplier = cashMult,
        Icon = icon,
        IconColor = iconColor,
        ApMultiplier = apMultiplier,
        Details = details,
        OnCardPressed = function()
        end,
    }
    return setmetatable(data, JobSelectionCard)
end
