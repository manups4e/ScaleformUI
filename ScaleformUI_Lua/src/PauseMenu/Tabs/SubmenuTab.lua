SubmenuTab = setmetatable({}, SubmenuTab)
SubmenuTab.__index = SubmenuTab
SubmenuTab.__call = function()
    return "BaseTab", "SubmenuTab"
end

function SubmenuTab.New(name)
    data = {
        Base = BaseTab.New(name or "", 1),
        Label = name or "",
        TextTitle = "",
        LeftItemList = {},
        Index = 0,
        Focused = false,
        Parent = nil,
    }
    return setmetatable(data, SubmenuTab)
end

function SubmenuTab:AddLeftItem(item)
    item.Parent = self
    table.insert(self.LeftItemList, item)
end