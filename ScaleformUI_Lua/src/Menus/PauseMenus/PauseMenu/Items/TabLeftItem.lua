TabLeftItem = {}
TabLeftItem.__index = TabLeftItem
setmetatable(TabLeftItem, { __index = PauseMenuItem })
TabLeftItem.__call = function()
    return "TabLeftItem"
end

---@class TabLeftItem
---@field public ItemType number
---@field public Focused boolean
---@field public MainColor SColor
---@field public HighlightColor SColor
---@field public Highlighted boolean
---@field public ItemIndex number
---@field public ItemList table<SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem>
---@field public RightTitle string
---@field private _enabled boolean
---@field private _hovered boolean
---@field private _selected boolean
---@field public KeymapRightLabel_1 string
---@field public KeymapRightLabel_2 string
---@field public Index number
---@field public AddItem fun(self:TabLeftItem, item:SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem|PauseMenuItem)
---@field public Enabled fun(self:TabLeftItem, enabled:boolean):boolean
---@field public Hovered fun(self:TabLeftItem, hover:boolean):boolean
---@field public Selected fun(self:TabLeftItem, selected:boolean):boolean
---@field public OnIndexChanged fun(item:TabLeftItem, index:number)
---@field public OnActivated fun(item:TabLeftItem, index:number)

function TabLeftItem.New(label, _type, mainColor, highlightColor, labelFont)
    local base = PauseMenuItem.New(label, labelFont)
    base.ItemType = _type
    base.Focused = false
    base.MainColor = mainColor or SColor.HUD_Pause_bg
    base.HighlightColor = highlightColor or SColor.HUD_White
    base.Highlighted = false
    base.ItemList = {} --[[@type table<SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem|PauseMenuItem>]]
    base._enabled = true
    base._hovered = false
    base._formatLeftLabel = __formatLeftLabel or ""
    base.KeymapRightLabel_1 = ""
    base.KeymapRightLabel_2 = ""
    base.TextureDict = ""
    base.TextureName = ""
    base.TextTitle = ""
    base.LeftItemBGType = 0
    base.OnActivated = function(item, index)
    end
    return setmetatable(base, TabLeftItem)
end

---Add item to the tab list
---@param item SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem|PauseMenuItem
function TabLeftItem:AddItem(item)
    item.ParentLeftItem = self
    item.ParentTab = self.ParentTab
    self.ItemList[#self.ItemList + 1] = item
end

function TabLeftItem:Label(label)
    if label ~= nil then
        self.label = label
        if self.ParentTab ~= nil and self.ParentTab.Visible then
            local leftItem = IndexOf(self.ParentTab.LeftColumn.Items, self)
            self.ParentTab.LeftColumn:UpdateSlot(leftItem)
        end
    else
        return self.label
    end
end

function TabLeftItem:Enabled(enabled)
    if enabled ~= nil then
        self._enabled = enabled
        if self.ParentTab ~= nil and self.ParentTab.Visible then
            local leftItem = IndexOf(self.ParentTab.LeftColumn.Items, self)
            self.ParentTab.LeftColumn:UpdateSlot(leftItem)
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
        if self.ParentTab ~= nil and self.ParentTab.Visible then
            local leftItem = IndexOf(self.ParentTab.LeftColumn.Items, self)
            self.ParentTab.LeftColumn:UpdateSlot(leftItem)
        end
    else
        return self._selected
    end
end

function TabLeftItem:RightTitle(rtit)
    if rtit ~= nil then
        self.TextTitle = rtit
        if self.ParentTab ~= nil and self.ParentTab.Visible then
            local leftItem = IndexOf(self.ParentTab.LeftColumn.Items, self)
            self.ParentTab.LeftColumn:UpdateSlot(leftItem)
        end
    else
        return self.TextTitle
    end
end

function TabLeftItem:KeymapRightLabel_1(rtit)
    if rtit ~= nil then
        self.KeymapRightLabel_1 = rtit
        if self.ParentTab ~= nil and self.ParentTab.Visible then
            local leftItem = IndexOf(self.ParentTab.LeftColumn.Items, self)
            self.ParentTab.LeftColumn:UpdateSlot(leftItem)
        end
    else
        return self.KeymapRightLabel_1
    end
end

function TabLeftItem:KeymapRightLabel_2(rtit)
    if rtit ~= nil then
        self.KeymapRightLabel_2 = rtit
        if self.ParentTab ~= nil and self.ParentTab.Visible then
            local leftItem = IndexOf(self.ParentTab.LeftColumn.Items, self)
            self.ParentTab.LeftColumn:UpdateSlot(leftItem)
        end
    else
        return self.KeymapRightLabel_2
    end
end

-- legacy and not supported anymore
-- function TabLeftItem:UpdateBackground(txd, txn, resizeType)
--     self.TextureDict = txd
--     self.TextureName = txn
--     self.LeftItemBGType = resizeType
--     if self.ParentTab ~= nil and self.ParentTab.Visible then
--         local leftItem = IndexOf(self.ParentTab.LeftColumn.Items, self)
--         self.ParentTab.LeftColumn:UpdateSlot(leftItem)
--     end
-- end
