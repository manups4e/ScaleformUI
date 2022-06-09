JobSelectionButton = setmetatable({}, JobSelectionButton)
JobSelectionButton.__index = JobSelectionButton
JobSelectionButton.__call = function()
    return "JobSelectionButton"
end

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