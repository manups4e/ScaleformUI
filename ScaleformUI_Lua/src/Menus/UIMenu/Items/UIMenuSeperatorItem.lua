UIMenuSeparatorItem = {}
UIMenuSeparatorItem.__index = UIMenuSeparatorItem
setmetatable(UIMenuSeparatorItem, { __index = UIMenuItem })
UIMenuSeparatorItem.__call = function() return "UIMenuSeparatorItem" end

---@class UIMenuSeparatorItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param jumpable boolean
---@param mainColor? SColor
---@param highlightColor? SColor
---@param textColor? SColor
---@param highlightedTextColor? SColor
function UIMenuSeparatorItem.New(Text, jumpable, mainColor, highlightColor, textColor, highlightedTextColor)
    local base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White)
    base.Jumpable = jumpable
    base.ItemId = 6
    return setmetatable(base, UIMenuSeparatorItem)
end

function UIMenuSeparatorItem:RightLabelFont(itemFont)
    error("UIMenuSeparatorItem does not support a right label")
end
---LeftBadge
function UIMenuSeparatorItem:LeftBadge()
    error("UIMenuSeparatorItem does not support badges")
end

---RightBadge
function UIMenuSeparatorItem:RightBadge()
    error("UIMenuSeparatorItem does not support badges")
end

function UIMenuSeparatorItem:CustomLeftBadge()
    error("UIMenuSeparatorItem does not support badges")
end

---RightBadge
function UIMenuSeparatorItem:CustomRightBadge()
    error("UIMenuSeparatorItem does not support badges")
end

---RightLabel
function UIMenuSeparatorItem:RightLabel()
    error("UIMenuSeparatorItem does not support a right label")
end