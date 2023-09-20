SubmenuTab = setmetatable({}, SubmenuTab)
SubmenuTab.__index = SubmenuTab
SubmenuTab.__call = function()
    return "BaseTab", "SubmenuTab"
end

---@class SubmenuTab

function SubmenuTab.New(name, color)
    local data = {
        Base = BaseTab.New(name or "", 1, color),
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
    self.LeftItemList[#self.LeftItemList + 1] = item
end
