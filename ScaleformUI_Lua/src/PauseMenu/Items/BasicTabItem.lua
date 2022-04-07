BasicTabItem = setmetatable({}, BasicTabItem)
BasicTabItem.__index = BasicTabItem
BasicTabItem.__call = function()
    return "BasicTabItem", "BasicTabItem"
end

function BasicTabItem.New(label)
    data = {
        Label = label or "",
        Parent = nil
    }
    return setmetatable(data, BasicTabItem)
end