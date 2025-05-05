UIMenuCheckboxItem = {}
UIMenuCheckboxItem.__index = UIMenuCheckboxItem
setmetatable(UIMenuCheckboxItem, { __index = UIMenuItem })
UIMenuCheckboxItem.__call = function() return "UIMenuCheckboxItem" end

---@class UIMenuCheckboxItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param Check boolean
---@param Description string
function UIMenuCheckboxItem.New(Text, Check, checkStyle, Description, color, highlightColor)
    local base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light,
    highlightColor or SColor.HUD_White)
    base._Checked = ToBool(Check)
    base.CheckBoxStyle = checkStyle or 0
    base.ItemId = 2
    base.OnCheckboxChanged = function(menu, item, checked)
    end
    return setmetatable(base, UIMenuCheckboxItem)
end

-- not supported on Lobby and Pause menu yet
function UIMenuCheckboxItem:RightLabelFont(itemFont)
    error("UIMenuCheckboxItem does not support a right label")
end

---RightBadge
function UIMenuCheckboxItem:RightBadge()
    error("UIMenuCheckboxItem does not support right badges")
end

function UIMenuCheckboxItem:CustomRightBadge()
    error("UIMenuCheckboxItem does not support right badges")
end

---RightLabel
function UIMenuCheckboxItem:RightLabel()
    error("UIMenuCheckboxItem does not support a right label")
end

function UIMenuCheckboxItem:Checked(bool)
    if bool ~= nil then
        self._Checked = ToBool(bool)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._Checked
    end
end
