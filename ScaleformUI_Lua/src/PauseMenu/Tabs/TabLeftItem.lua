TabLeftItem = setmetatable({}, TabLeftItem)
TabLeftItem.__index = TabLeftItem
TabLeftItem.__call = function()
    return "TabLeftItem", "TabLeftItem"
end

---@class TabLeftItem

function TabLeftItem.New(label, _type, mainColor, highlightColor)
    local data = {
        Label = label or "",
        ItemType = _type,
        Focused = false,
        MainColor = mainColor or Colours.NONE,
        HighlightColor = highlightColor or Colours.NONE,
        Highlighted = false,
        ItemIndex = 0,
        ItemList = {},
        TextTitle = "",
        _enabled = true,
        _hovered = false,
        _selected = false,
        KeymapRightLabel_1 = "",
        KeymapRightLabel_2 = "",
        OnIndexChanged = function(item, index)
        end,
        OnActivated = function(item, index)
        end,
        Index = 0,
        Parent = nil
    }
    return setmetatable(data, TabLeftItem)
end

function TabLeftItem:AddItem(item)
    item.Parent = self
    self.ItemList[#self.ItemList + 1] = item
end

function TabLeftItem:Enabled(enabled)
    if enabled ~= nil then
        self._enabled = enabled
        if self.Parent ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() then
            local tab = IndexOf(self.Parent.Base.Parent.Tabs, self.Parent) - 1
            local leftItem = IndexOf(self.Parent.LeftItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_LEFT_ITEM", false, tab, leftItem, self
                ._enabled)
        end
    else
        return self._enabled
    end
end

function TabLeftItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    else
        return self._hovered
    end
end

function TabLeftItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    else
        return self._selected
    end
end
