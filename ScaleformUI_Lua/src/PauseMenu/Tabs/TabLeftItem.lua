TabLeftItem = setmetatable({}, TabLeftItem)
TabLeftItem.__index = TabLeftItem
TabLeftItem.__call = function()
    return "TabLeftItem", "TabLeftItem"
end

function TabLeftItem.New(label, _type, mainColor, highlightColor)
    data = {
        Label = label or "",
        ItemType = _type,
        Focused = false,
        MainColor = mainColor or Colours.NONE, 
        HighlightColor = highlightColor or Colours.NONE,
        Highlighted = false,
        ItemIndex = 0,
        ItemList = {},
        TextTitle = "",
        KeymapRightLabel_1 = "",
        KeymapRightLabel_2 = "",
        OnIndexChanged = function(item, index) end,
        OnActivated = function(item, index) end,
        Index = 0,
        Parent = nil
    }
    return setmetatable(data, TabLeftItem)
end

function TabLeftItem:AddItem(item)
    item.Parent = self
    table.insert(self.ItemList, item)
end