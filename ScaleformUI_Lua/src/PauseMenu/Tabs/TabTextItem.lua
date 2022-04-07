TabTextItem = setmetatable({}, TabTextItem)
TabTextItem.__index = TabTextItem
TabTextItem.__call = function()
    return "BaseTab", "TabTextItem"
end

function TabTextItem.New(name, _title)
    data = {
        Base = BaseTab.New(name or ""),
        Label = name,
        TextTitle = _title or "",
        LabelsList = {},
        Index = 0,
        Focused = false,
        Parent = nil
    }
    return setmetatable(data, TabTextItem)
end

function TabTextItem:AddTitle(title)
    if not title:IsNullOrEmpty() then
        self.TextTitle = title
    end
end

function TabTextItem:AddItem(item)
    table.insert(self.LabelsList, item)
end
