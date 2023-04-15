TabLeftItem = setmetatable({}, TabLeftItem)
TabLeftItem.__index = TabLeftItem
TabLeftItem.__call = function()
    return "TabLeftItem", "TabLeftItem"
end

---@class TabLeftItem
---@field public Label string
---@field public ItemType number
---@field public Focused boolean
---@field public MainColor number
---@field public HighlightColor number
---@field public Highlighted boolean
---@field public ItemIndex number
---@field public ItemList table<SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem>
---@field public TextTitle string
---@field private _enabled boolean
---@field private _hovered boolean
---@field private _selected boolean
---@field public KeymapRightLabel_1 string
---@field public KeymapRightLabel_2 string
---@field public OnIndexChanged fun(item:TabLeftItem, index:number)
---@field public OnActivated fun(item:TabLeftItem, index:number)
---@field public Index number
---@field public AddItem fun(item:SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem)
---@field public Enabled fun(enabled:boolean):boolean
---@field public Hovered fun(hover:boolean):boolean
---@field public Selected fun(selected:boolean):boolean

function TabLeftItem.New(label, _type, mainColor, highlightColor)
    local data = {
        Label = label or "",
        ItemType = _type,
        Focused = false,
        MainColor = mainColor or Colours.NONE,
        HighlightColor = highlightColor or Colours.NONE,
        Highlighted = false,
        ItemIndex = 0,
        ItemList = {} --[[@type table<SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem>]],
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

---Add item to the tab list
---@param item SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem
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
