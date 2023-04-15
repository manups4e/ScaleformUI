TextTab = setmetatable({}, TextTab)
TextTab.__index = TextTab
TextTab.__call = function()
    return "BaseTab", "TextTab"
end

---@class TextTab

function TextTab.New(name, _title)
    local data = {
        Base = BaseTab.New(name or "", 0),
        Label = name,
        TextTitle = _title or "",
        LabelsList = {},
        LeftItemList = {},
        Index = 0,
        Focused = false,
        Parent = nil
    }
    return setmetatable(data, TextTab)
end

function TextTab:AddTitle(title)
    if not title:IsNullOrEmpty() then
        self.TextTitle = title
    end
end

function TextTab:AddItem(item)
    self.LabelsList[#self.LabelsList + 1] = item
end
