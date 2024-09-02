UIMenuCheckboxItem = setmetatable({}, UIMenuCheckboxItem)
UIMenuCheckboxItem.__index = UIMenuCheckboxItem
UIMenuCheckboxItem.__call = function() return "UIMenuItem", "UIMenuCheckboxItem" end

---@class UIMenuCheckboxItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param Check boolean
---@param Description string
function UIMenuCheckboxItem.New(Text, Check, checkStyle, Description, color, highlightColor, textColor,
                                highlightedTextColor)
    local _UIMenuCheckboxItem = {
        Base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White, textColor or SColor.HUD_White, highlightedTextColor or SColor.HUD_Black),
        _Checked = ToBool(Check),
        Panels = {},
        SidePanel = nil,
        CheckBoxStyle = checkStyle or 0,
        ItemId = 2,
        OnCheckboxChanged = function(menu, item, checked)
        end,
    }
    return setmetatable(_UIMenuCheckboxItem, UIMenuCheckboxItem)
end

function UIMenuCheckboxItem:ItemData(data)
    if data == nil then
        return self.Base._itemData
    else
        self.Base._itemData = data
    end
end

---SetParentMenu
---@param Menu table
function UIMenuCheckboxItem:SetParentMenu(Menu)
    if Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

function UIMenuCheckboxItem:AddSidePanel(sidePanel)
    if sidePanel() == "UIMissionDetailsPanel" then
        sidePanel:SetParentItem(self)
        self.SidePanel = sidePanel
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() and self.Base.ParentMenu.Pagination:IsItemVisible(IndexOf(self.Base.ParentMenu.Items, self)) then
            ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM",
                self.Base.ParentMenu.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentMenu.Items, self)), 0, sidePanel.PanelSide, sidePanel.TitleType,
                sidePanel.Title,
                sidePanel.TitleColor, sidePanel.TextureDict, sidePanel.TextureName)
        end
    elseif sidePanel() == "UIVehicleColorPickerPanel" then
        sidePanel:SetParentItem(self)
        self.SidePanel = sidePanel
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() and self.Base.ParentMenu.Pagination:IsItemVisible(IndexOf(self.Base.ParentMenu.Items, self)) then
            ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM",
                IndexOf(self.Base.ParentMenu.Items, self), 1, sidePanel.PanelSide, sidePanel.TitleType, sidePanel.Title,
                sidePanel.TitleColor)
        end
    end
end

---Selected
---@param bool boolean
function UIMenuCheckboxItem:Selected(bool)
    if bool ~= nil then
        self.Base:Selected(ToBool(bool), self)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
function UIMenuCheckboxItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = ToBool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
function UIMenuCheckboxItem:Enabled(bool)
    if bool ~= nil then
        self.Base:Enabled(bool, self)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
function UIMenuCheckboxItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base:Description(tostring(str), self)
    else
        return self.Base._Description
    end
end

function UIMenuCheckboxItem:BlinkDescription(bool)
    if bool ~= nil then
        self.Base:BlinkDescription(bool, self)
    else
        return self.Base:BlinkDescription()
    end
end

---Text
---@param Text string
function UIMenuCheckboxItem:Label(Text)
    if tostring(Text) and Text ~= nil then
        self.Base:Label(tostring(Text), self)
    else
        return self.Base:Label()
    end
end

function UIMenuCheckboxItem:MainColor(color)
    if color then
        assert(type(color) == "table", "Color must be SColor type")
        self.Base._mainColor = color
        if (self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) and self.Base.ParentMenu:Visible() and self.Base.ParentMenu.Pagination:IsItemVisible(IndexOf(self.Base.ParentMenu.Items, self)) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", self.Base.ParentMenu.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentMenu.Items, self)),
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._mainColor
    end
end

function UIMenuCheckboxItem:TextColor(color)
    if color then
        assert(type(color) == "table", "Color must be SColor type")
        self.Base._textColor = color
        if (self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) and self.Base.ParentMenu:Visible() and self.Base.ParentMenu.Pagination:IsItemVisible(IndexOf(self.Base.ParentMenu.Items, self)) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", self.Base.ParentMenu.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentMenu.Items, self)),
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._textColor
    end
end

function UIMenuCheckboxItem:HighlightColor(color)
    if color then
        assert(type(color) == "table", "Color must be SColor type")
        self.Base._highlightColor = color
        if (self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) and self.Base.ParentMenu:Visible() and self.Base.ParentMenu.Pagination:IsItemVisible(IndexOf(self.Base.ParentMenu.Items, self)) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", self.Base.ParentMenu.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentMenu.Items, self)),
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._highlightColor
    end
end

function UIMenuCheckboxItem:HighlightedTextColor(color)
    if color then
        assert(type(color) == "table", "Color must be SColor type")
        self.Base._highlightedTextColor = color
        if (self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) and self.Base.ParentMenu:Visible() and self.Base.ParentMenu.Pagination:IsItemVisible(IndexOf(self.Base.ParentMenu.Items, self)) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", self.Base.ParentMenu.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentMenu.Items, self)),
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._highlightedTextColor
    end
end

function UIMenuCheckboxItem:LabelFont(fontTable)
    if fontTable == nil then
        return self.Base:LabelFont()
    else
        self.Base:LabelFont(fontTable)
    end
end

---LeftBadge
function UIMenuCheckboxItem:LeftBadge(Badge)
    if tonumber(Badge) then
        self.Base:LeftBadge(Badge, self)
    else
        return self.Base:LeftBadge()
    end
end

---RightBadge
function UIMenuCheckboxItem:RightBadge()
    error("This item does not support badges")
end

---RightLabel
function UIMenuCheckboxItem:RightLabel()
    error("This item does not support a right label")
end

function UIMenuCheckboxItem:Checked(bool)
    if bool ~= nil then
        self._Checked = ToBool(bool)
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() and self.Base.ParentMenu.Pagination:IsItemVisible(IndexOf(self.Base.ParentMenu.Items, self)) then
            local it = self.Base.ParentMenu.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentMenu.Items, self))
            ScaleformUI.Scaleforms._ui:CallFunction("SET_ITEM_VALUE", it, self._Checked)
        end
    else
        return self._Checked
    end
end
