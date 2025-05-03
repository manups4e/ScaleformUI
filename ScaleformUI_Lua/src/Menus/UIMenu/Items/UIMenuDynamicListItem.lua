UIMenuDynamicListItem = {}
UIMenuDynamicListItem.__index = UIMenuDynamicListItem
setmetatable(UIMenuDynamicListItem, { __index = UIMenuItem })
UIMenuDynamicListItem.__call = function() return "UIMenuDynamicListItem" end

---@class UIMenuDynamicListItem : UIMenuItem
---@field Base UIMenuItem
---@field Panels table
---@field SidePanel table
---@field _currentItem string
---@field Callback function
---@field ItemId number
---@field OnListSelected function

---New
---@param Text string
---@param Description string
---@param StartingItem string
---@param callback function
---@param color SColor
---@param highlightColor SColor
function UIMenuDynamicListItem.New(Text, Description, StartingItem, callback, color, highlightColor)
    local base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light,
        highlightColor or SColor.HUD_White)
    base._currentItem = StartingItem
    base.Callback = callback
    base.ItemId = 1
    base.OnListSelected = function(menu, item, newindex)
    end
    return setmetatable(base, UIMenuDynamicListItem)
end

-- not supported on Lobby and Pause menu yet
function UIMenuDynamicListItem:RightLabelFont(itemFont)
    error("UIMenuDynamicListItem does not support a right label")
end

---RightBadge
function UIMenuDynamicListItem:RightBadge()
    error("UIMenuDynamicListItem does not support right badges")
end

function UIMenuDynamicListItem:CustomRightBadge()
    error("UIMenuDynamicListItem does not support right badges")
end

---RightLabel
function UIMenuDynamicListItem:RightLabel()
    error("UIMenuDynamicListItem does not support a right label")
end

function UIMenuDynamicListItem:CurrentListItem(item)
    if item == nil then
        return tostring(self._currentItem)
    else
        self._currentItem = item
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    end
end

function UIMenuDynamicListItem:createListString()
    local value = self._currentItem
    if type(value) ~= "string" then
        value = tostring(v)
    end
    if not value:StartsWith("~") then
        value = "~s~" .. value
    end
    if self:Selected() then
        value = value:gsub("~w~", "~l~")
        value = value:gsub("~s~", "~l~")
    else
        value = value:gsub("~l~", "~s~")
    end
    if not self:Enabled() then
        value = ReplaceRstarColorsWith(value, "~c~")
    end
    return value
end
