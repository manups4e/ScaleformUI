UIMenuDynamicListItem = setmetatable({}, UIMenuDynamicListItem)
UIMenuDynamicListItem.__index = UIMenuDynamicListItem
UIMenuDynamicListItem.__call = function() return "UIMenuItem", "UIMenuDynamicListItem" end

---New
---@param Text string
---@param Description string
---@param StartingItem string
---@param callback function
---@param color number|117
---@param highlightColor number|1
---@param textColor number|1
---@param highlightedTextColor number|2
function UIMenuDynamicListItem.New(Text, Description, StartingItem, callback, color, highlightColor, textColor,
                                   highlightedTextColor)
    local _UIMenuDynamicListItem = {
        Base = UIMenuItem.New(Text or "", Description or "", color or 117, highlightColor or 1, textColor or 1,
            highlightedTextColor or 2),
        Panels = {},
        SidePanel = nil,
        _currentItem = StartingItem,
        Callback = callback,
        ItemId = 1,
        OnListSelected = function(menu, item, newindex)
        end,
    }
    return setmetatable(_UIMenuDynamicListItem, UIMenuDynamicListItem)
end

function UIMenuDynamicListItem:ItemData(data)
    if data == nil then
        return self.Base._itemData
    else
        self.Base._itemData = data
    end
end

function UIMenuDynamicListItem:LabelFont(fontTable)
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

function UIMenuDynamicListItem:CurrentListItem(item)
    if item == nil then
        return tostring(self._currentItem)
    else
        self._currentItem = item
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_LISTITEM_LIST", false,
                IndexOf(self.Base.ParentMenu.Items, self) - 1, tostring(self._currentItem), 0)
        end
    end
end

---SetParentMenu
---@param Menu table
function UIMenuDynamicListItem:SetParentMenu(Menu)
    if Menu ~= nil and Menu() == "UIMenu" then
        self.Base.ParentMenu = Menu
    else
        return self.Base.ParentMenu
    end
end

function UIMenuDynamicListItem:AddSidePanel(sidePanel)
    if sidePanel() == "UIMissionDetailsPanel" then
        sidePanel:SetParentItem(self)
        self.SidePanel = sidePanel
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false,
                IndexOf(self.Base.ParentMenu.Items, self) - 1, 0, sidePanel.PanelSide, sidePanel.TitleType,
                sidePanel.Title,
                sidePanel.TitleColor, sidePanel.TextureDict, sidePanel.TextureName)
        end
    elseif sidePanel() == "UIVehicleColorPickerPanel" then
        sidePanel:SetParentItem(self)
        self.SidePanel = sidePanel
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false,
                IndexOf(self.ParentMenu.Items, self) - 1, 1, sidePanel.PanelSide, sidePanel.TitleType, sidePanel.Title,
                sidePanel.TitleColor)
        end
    end
end

---Selected
---@param bool boolean
function UIMenuDynamicListItem:Selected(bool)
    if bool ~= nil then
        self.Base:Selected(ToBool(bool), self)
    else
        return self.Base._Selected
    end
end

---Hovered
---@param bool boolean
function UIMenuDynamicListItem:Hovered(bool)
    if bool ~= nil then
        self.Base._Hovered = ToBool(bool)
    else
        return self.Base._Hovered
    end
end

---Enabled
---@param bool boolean
function UIMenuDynamicListItem:Enabled(bool)
    if bool ~= nil then
        self.Base:Enabled(bool, self)
    else
        return self.Base._Enabled
    end
end

---Description
---@param str string
function UIMenuDynamicListItem:Description(str)
    if tostring(str) and str ~= nil then
        self.Base:Description(tostring(str), self)
    else
        return self.Base._Description
    end
end

function UIMenuDynamicListItem:BlinkDescription(bool)
    if bool ~= nil then
        self.Base:BlinkDescription(bool, self)
    else
        return self.Base:BlinkDescription()
    end
end

---Text
---@param Text string
function UIMenuDynamicListItem:Label(Text)
    if tostring(Text) and Text ~= nil then
        self.Base:Label(tostring(Text), self)
    else
        return self.Base:Label()
    end
end

function UIMenuDynamicListItem:MainColor(color)
    if (color) then
        self.Base._mainColor = color
        if (self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1,
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._mainColor
    end
end

function UIMenuDynamicListItem:TextColor(color)
    if (color) then
        self.Base._textColor = color
        if (self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1,
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._textColor
    end
end

function UIMenuDynamicListItem:HighlightColor(color)
    if (color) then
        self.Base._highlightColor = color
        if (self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1,
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._highlightColor
    end
end

function UIMenuDynamicListItem:HighlightedTextColor(color)
    if (color) then
        self.Base._highlightedTextColor = color
        if (self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1,
                self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._highlightedTextColor
    end
end

---LeftBadge
function UIMenuDynamicListItem:LeftBadge(Badge)
    if tonumber(Badge) then
        self.Base:LeftBadge(Badge, self)
    else
        return self.Base:LeftBadge()
    end
end

---RightBadge
function UIMenuDynamicListItem:RightBadge()
    error("This item does not support badges")
end

---RightLabel
function UIMenuDynamicListItem:RightLabel()
    error("This item does not support a right label")
end

---AddPanel
---@param Panel table
function UIMenuDynamicListItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        self.Panels[#self.Panels + 1] = Panel
        Panel:SetParentItem(self)
    end
end

---RemovePanelAt
---@param Index table
function UIMenuDynamicListItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
        end
    end
end

---FindPanelIndex
---@param Panel table
function UIMenuDynamicListItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

---FindPanelItem
function UIMenuDynamicListItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end
