UIMenuListItem = {}
UIMenuListItem.__index = UIMenuListItem
setmetatable(UIMenuListItem, { __index = UIMenuDynamicListItem })
UIMenuListItem.__call = function() return "UIMenuListItem" end

---@class UIMenuListItem : UIMenuDynamicListItem
---@field public AddPanel fun(self:UIMenuListItem, item:UIMenuStatisticsPanel|UIMenuPercentagePanel|UIMenuColorPanel|UIMenuGridPanel):nil

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
function UIMenuListItem.New(Text, Items, Index, Description, color, highlightColor)
    if type(Items) ~= "table" then Items = {} end
    if Index == 0 then Index = 1 end

    local cb = function(sender, dir)
        if dir == "left" then
            self._Index = self._Index - 1
            if self._Index < 1 then
                self._Index = #self.Items
            end
        elseif dir == "right" then
            self._Index = self._Index + 1
            if self._Index > #self.Items then
                self._Index = 1
            end
        end
        return tostring(self.Items[self._Index])
    end

    local base = UIMenuDynamicListItem.New(Text or "", Description or "", "", cb, color or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White)
    base.Items = Items
    base._Index = tonumber(Index) or 1
    base.OnListChanged = function(menu, item, newindex)
    end
    base.OnListSelected = function(menu, item, newindex)
    end
    if #base.Items > 0 then
        base:CurrentListItem(tostring(base.Items[base._Index]))
    else
        base:CurrentListItem("")
    end
    return setmetatable(base, UIMenuListItem)
end

---Index
---@param Index number
function UIMenuListItem:Index(Index)
    if tonumber(Index) then
        if Index > #self.Items then
            self._Index = 1
        elseif Index < 1 then
            self._Index = #self.Items
        else
            self._Index = Index
        end
        if #self.Items > 0 then
            self:CurrentListItem(tostring(self.Items[self._Index]))
        else
            self:CurrentListItem("")
        end
    else
        return self._Index
    end
end

---ItemToIndex
---@param Item table
function UIMenuListItem:ItemToIndex(Item)
    for i = 1, #self.Items do
        if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
            return i
        elseif type(self.Items[i]) == "table" and (type(Item) == type(self.Items[i].Name) or type(Item) == type(self.Items[i].Value)) and (Item == self.Items[i].Name or Item == self.Items[i].Value) then
            return i
        end
    end
end

---IndexToItem
---@param Index number
function UIMenuListItem:IndexToItem(Index)
    if tonumber(Index) then
        if tonumber(Index) == 0 then Index = 1 end
        if self.Items[tonumber(Index)] then
            return self.Items[tonumber(Index)]
        end
    end
end

function UIMenuListItem:ChangeList(list, index)
    if index == nil or index < 1 or index > #list or self._Index > #list then index = 1 end
    if type(list) ~= "table" then return end
    self.Items = {}
    self.Items = list
    self:Index(index)

    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendItemToScaleform(it, true)
    end
    if self.ParentColumn ~= nil then
        local it = IndexOf(self.ParentColumn.Items, self)
        self.ParentColumn:SendItemToScaleform(it, true)
    end
end