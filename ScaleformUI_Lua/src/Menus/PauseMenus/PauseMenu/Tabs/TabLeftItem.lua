TabLeftItem = setmetatable({}, TabLeftItem)
TabLeftItem.__index = TabLeftItem
TabLeftItem.__call = function()
    return "TabLeftItem", "TabLeftItem"
end

---@class TabLeftItem
---@field public Label string
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
---@field public AddItem fun(self:TabLeftItem, item:SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem|BasicTabItem)
---@field public Enabled fun(self:TabLeftItem, enabled:boolean):boolean
---@field public Hovered fun(self:TabLeftItem, hover:boolean):boolean
---@field public Selected fun(self:TabLeftItem, selected:boolean):boolean
---@field public OnIndexChanged fun(item:TabLeftItem, index:number)
---@field public OnActivated fun(item:TabLeftItem, index:number)

function TabLeftItem.New(label, _type, mainColor, highlightColor, labelFont)
    local __formatLeftLabel = (tostring(label))
    if not __formatLeftLabel:StartsWith("~") then
        __formatLeftLabel = "~s~" .. __formatLeftLabel
    end
    local data = {
        Label = label or "",
        ItemType = _type,
        Focused = false,
        MainColor = mainColor or SColor.HUD_Pause_bg,
        HighlightColor = highlightColor or SColor.HUD_White,
        Highlighted = false,
        ItemIndex = 0,
        ItemList = {} --[[@type table<SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem|BasicTabItem>]],
        RightTitle = "",
        _enabled = true,
        _hovered = false,
        _selected = false,
        _formatLeftLabel = __formatLeftLabel or "",
        KeymapRightLabel_1 = "",
        KeymapRightLabel_2 = "",
        TextureDict = "",
        TextureName = "",
        LeftItemBGType = 0,
        _labelFont = labelFont or ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        --_rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
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
---@param item SettingsItem|SettingsListItem|SettingsProgressItem|SettingsCheckboxItem|SettingsSliderItem|KeymapItem|BasicTabItem
function TabLeftItem:AddItem(item)
    item.Parent = self
    self.ItemList[#self.ItemList + 1] = item
end

function TabLeftItem:Label(label)
    if label ~= nil then
        self.Label = label
        self._formatLeftLabel = tostring(Text)
        if not self._formatLeftLabel:StartsWith("~") then
            self._formatLeftLabel = "~s~" .. self._formatLeftLabel
        end
        if self:Selected() then
            self._formatLeftLabel = self._formatLeftLabel:gsub("~w~", "~l~")
            self._formatLeftLabel = self._formatLeftLabel:gsub("~s~", "~l~")
        else
            self._formatLeftLabel = self._formatLeftLabel:gsub("~l~", "~s~")
        end
        if self.Parent ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() then
            local tab = IndexOf(self.Parent.Base.Parent.Tabs, self.Parent) - 1
            local leftItem = IndexOf(self.Parent.LeftItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_LEFT_ITEM_LABEL", tab, leftItem, self._formatLeftLabel)
        end
    else
        return self.Label
    end
end 

function TabLeftItem:Enabled(enabled)
    if enabled ~= nil then
        self._enabled = enabled
        if not self._Enabled then
            self._formatLeftLabel = ReplaceRstarColorsWith(self._formatLeftLabel, "~c~")
        else
            self:Label(self._label)
        end
        if self.Parent ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() then
            local tab = IndexOf(self.Parent.Base.Parent.Tabs, self.Parent) - 1
            local leftItem = IndexOf(self.Parent.LeftItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_LEFT_ITEM", tab, leftItem, self._enabled)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_LEFT_ITEM_LABEL", tab, leftItem, self._formatLeftLabel)
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
        if self._selected then
            self._formatLeftLabel = self._formatLeftLabel:gsub("~w~", "~l~")
            self._formatLeftLabel = self._formatLeftLabel:gsub("~s~", "~l~")
        else
            self._formatLeftLabel = self._formatLeftLabel:gsub("~l~", "~s~")
        end
        if self.Parent ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() then
            local tab = IndexOf(self.Parent.Base.Parent.Tabs, self.Parent) - 1
            local leftItem = IndexOf(self.Parent.LeftItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_LEFT_ITEM_LABEL", tab, leftItem, self._formatLeftLabel)
        end
    else
        return self._selected
    end
end

function TabLeftItem:RightTitle(rtit)
    if rtit ~= nil then
        self.RightTitle = rtit
        if self.Parent ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() then
            local tab = IndexOf(self.Parent.Base.Parent.Tabs, self.Parent) - 1
            local leftItem = IndexOf(self.Parent.LeftItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_RIGHT_TITLE", tab, leftItem, self.RightTitle, self.keymapRightLabel_1, self.KeymapRightLabel_2)
        end
    else
        return self.RightLabel
    end
end

function TabLeftItem:KeymapRightLabel_1(rtit)
    if rtit ~= nil then
        self.KeymapRightLabel_1 = rtit
        if self.Parent ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() then
            local tab = IndexOf(self.Parent.Base.Parent.Tabs, self.Parent) - 1
            local leftItem = IndexOf(self.Parent.LeftItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_RIGHT_TITLE", tab, leftItem, self.RightTitle, self.keymapRightLabel_1, self.KeymapRightLabel_2)
        end
    else
        return self.KeymapRightLabel_1
    end
end

function TabLeftItem:KeymapRightLabel_2(rtit)
    if rtit ~= nil then
        self.KeymapRightLabel_2 = rtit
        if self.Parent ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() then
            local tab = IndexOf(self.Parent.Base.Parent.Tabs, self.Parent) - 1
            local leftItem = IndexOf(self.Parent.LeftItemList, self) - 1
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_RIGHT_TITLE", tab, leftItem, self.RightTitle, self.keymapRightLabel_1, self.KeymapRightLabel_2)
        end
    else
        return self.KeymapRightLabel_2
    end
end

function TabLeftItem:UpdateBackground(txd, txn, resizeType)
    self.TextureDict = txd
    self.TextureName = txn
    self.LeftItemBGType = resizeType
    if self.Parent ~= nil and self.Parent.Base.Parent ~= nil and self.Parent.Base.Parent:Visible() then
        local tab = IndexOf(self.Parent.Base.Parent.Tabs, self.Parent) - 1
        local leftItem = IndexOf(self.Parent.LeftItemList, self) - 1
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_LEFT_ITEM_RIGHT_BACKGROUND", tab, leftItem, txd, txn, resizeType)
    end
end