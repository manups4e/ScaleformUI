TabSubMenuItem = setmetatable({}, TabSubMenuItem)
TabSubMenuItem.__index = TabSubMenuItem
TabSubMenuItem.__call = function()
    return "BaseTab", "TabSubMenuItem"
end

function TabSubMenuItem.New(name)
    data = {
        Base = BaseTab.New(name or ""),
        Label = name or "",
        TextTitle = "",
        LeftItemList = {},
        Index = 0,
        Focused = false,
        Parent = nil,
    }
    return setmetatable(data, TabSubMenuItem)
end

function TabSubMenuItem:AddLeftItem(item)
    item.Parent = self
    table.insert(self.LeftItemList, item)
end