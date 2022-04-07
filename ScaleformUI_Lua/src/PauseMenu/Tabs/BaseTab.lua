BaseTab = setmetatable({}, BaseTab)
BaseTab.__index = BaseTab
BaseTab.__call = function()
    return "BaseTab", "BaseTab"
end

function BaseTab.New(title)
    data = {
        Title = title or "",
        Visible = false,
        Focused = false,
        Active = false,
        Parent = nil,
        LeftItemList = {},
        Activated = function(item) end
    }
    return setmetatable(data, BaseTab)
end