UIMenuSeperatorItem = setmetatable({}, UIMenuSeperatorItem)
UIMenuSeperatorItem.__index = UIMenuSeperatorItem
UIMenuSeperatorItem.__call = function() return "UIMenuItem", "UIMenuSeperatorItem" end

---New
---@param Text string
---@param jumpable boolean
---@param mainColor number|117
---@param highlightColor number|1
---@param textColor number|1
---@param highlightedTextColor number|2
function UIMenuSeperatorItem.New(Text, jumpable, mainColor, highlightColor, textColor, highlightedTextColor)
    local _UIMenuSeperatorItem = {
        Base = UIMenuItem.New(Text or "", "", mainColor or 117, highlightColor or 1, textColor or 1,
            highlightedTextColor or 2),
        Panels = {},
        SidePanel = nil,
        Jumpable = jumpable,
        ItemId = 6
    }
    return setmetatable(_UIMenuSeperatorItem, UIMenuSeperatorItem)
end

function UIMenuSeperatorItem:ItemData(data)
    if data == nil then
        return self.Base._itemData
    else
        self.Base._itemData = data
    end
end

---SetParentMenu
---@param Menu table
function UIMenuSeperatorItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

function UIMenuSeperatorItem:LabelFont(fontTable)
    if fontTable == nil then
        return self.Base._labelFont
    else
        self.Base._labelFont = fontTable
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_ITEM_LABEL_FONT", false,
                IndexOf(self.ParentMenu.Items, self) - 1, self.Base._labelFont[1], self.Base._labelFont[2])
        end
    end
end

---Description
---@param str string
function UIMenuSeperatorItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base:Description(tostring(str), self)
    else
        return self.Base._Description
    end
end

---Text
---@param Text string
function UIMenuSeperatorItem:Label(Text)
    if tostring(Text) and Text ~= nil then
        self.Base:Label(tostring(Text), self)
    else
        return self.Base:Label()
    end
end

function UIMenuSeperatorItem:MainColor(color)
    if color ~= nil then
        self.Base._mainColor = color
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1,
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._mainColor
    end
end

function UIMenuSeperatorItem:TextColor(color)
    if color ~= nil then
        self.Base._textColor = color
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1,
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._textColor
    end
end

function UIMenuSeperatorItem:HighlightColor(color)
    if color ~= nil then
        self.Base._highlightColor = color
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1,
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._highlightColor
    end
end

function UIMenuSeperatorItem:HighlightedTextColor(color)
    if color ~= nil then
        self.Base._highlightedTextColor = color
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1,
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._highlightedTextColor
    end
end

---Selected
---@param bool number
function UIMenuSeperatorItem:Selected(bool)
    if bool ~= nil then
        self.Base:Selected(tobool(bool), self)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
function UIMenuSeperatorItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = tobool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
function UIMenuSeperatorItem:Enabled(bool)
    if bool ~= nil then
        self.Base:Enabled(bool, self)
    else
        return self.Base._Enabled
    end
end

function UIMenuSeperatorItem:BlinkDescription(bool)
    if bool ~= nil then
        self.Base:BlinkDescription(bool, self)
    else
        return self.Base:BlinkDescription()
    end
end

---LeftBadge
function UIMenuSeperatorItem:LeftBadge()
    error("This item does not support badges")
end

---RightBadge
function UIMenuSeperatorItem:RightBadge()
    error("This item does not support badges")
end

---RightLabel
function UIMenuSeperatorItem:RightLabel()
    error("This item does not support a right label")
end
