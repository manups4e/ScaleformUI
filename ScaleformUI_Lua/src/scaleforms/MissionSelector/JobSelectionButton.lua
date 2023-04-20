JobSelectionButton = setmetatable({}, JobSelectionButton)
JobSelectionButton.__index = JobSelectionButton
JobSelectionButton.__call = function()
    return "JobSelectionButton"
end

---@class JobSelectionButton
---@field public Text string
---@field public Description string
---@field public Details table<MissionDetailsItem>
---@field public OnButtonPressed fun(self: JobSelectionButton)

---Creates a new JobSelectionButton object
---@param title string
---@param description string
---@param details table<MissionDetailsItem>
---@return JobSelectionButton
function JobSelectionButton.New(title, description, details)
    local data = {
        Text = title,
        Description = description,
        Details = details,
        OnButtonPressed = function()
        end
    }
    return setmetatable(data, JobSelectionButton)
end
