BaseTab = setmetatable({}, BaseTab)
BaseTab.__index = BaseTab
BaseTab.__call = function()
    return "BaseTab", "BaseTab"
end

function BaseTab.New(title, type)
    local data = {
        Title = title or "",
        Type = type or 1,
        Visible = false,
        Focused = false,
        Active = false,
        Parent = nil,
        LeftItemList = {},
        Activated = function(item) end
    }
    return setmetatable(data, BaseTab)
end