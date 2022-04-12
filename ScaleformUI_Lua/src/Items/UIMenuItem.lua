UIMenuItem = setmetatable({}, UIMenuItem)
UIMenuItem.__index = UIMenuItem
UIMenuItem.__call = function()
    return "UIMenuItem", "UIMenuItem"
end

function UIMenuItem.New(text, description, color, highlightColor, textColor, highlightedTextColor)
    _UIMenuItem = {
        _label = tostring(text) or "",
        _Description = tostring(description) or "",
        _Selected = false,
        _Hovered = false,
        _Enabled = true,
        blinkDescription = false,
        _formatLeftLabel = tostring(text) or "",
        _rightLabel = "",
        _formatRightLabel = "",
        _rightBadge = 0,
        _leftBadge = 0,
        _mainColor = color or 117,
        _highlightColor = highlightColor or 1,
        _textColor = textColor or 1,
        _highlightedTextColor = highlightedTextColor or 2,
        ParentMenu = nil,
        Panels = {},
        SidePanel = nil,
        Activated = function(menu, item)
        end,
    }
    return setmetatable(_UIMenuItem, UIMenuItem)
end

function UIMenuItem:SetParentMenu(Menu)
    if Menu ~= nil and Menu() == "UIMenu" then
        self.ParentMenu = Menu
    else
        return self.ParentMenu
    end
end

function UIMenuItem:Selected(bool, item)
    if bool ~= nil then
        if item == nil then item = self end
       
        self._Selected = tobool(bool)
        if self._Selected then
            if(self._highlightedTextColor == 2) then
                if not self._formatLeftLabel:StartsWith("~") then
                    self._formatLeftLabel = self._formatLeftLabel:Insert(0, "~l~")
                end
                if self._formatLeftLabel:find("~", 1, true) then
                    self._formatLeftLabel = self._formatLeftLabel:gsub("~w~", "~l~")
                    self._formatLeftLabel = self._formatLeftLabel:gsub("~s~", "~l~")
                end
                if not string.IsNullOrEmpty(self._formatRightLabel) then
                    if not self._formatRightLabel:StartsWith("~") then
                        self._formatRightLabel = self._formatRightLabel:Insert(0, "~l~")
                    end
                    if self._formatRightLabel:find("~", 1, true) then
                        self._formatRightLabel = self._formatRightLabel:gsub("~w~", "~l~")
                        self._formatRightLabel = self._formatRightLabel:gsub("~s~", "~l~")
                    end
                end
            end
        else
            if(self._textColor == 1) then
                self._formatLeftLabel = self._formatLeftLabel:gsub("~l~", "~s~")
                if not self._formatLeftLabel:StartsWith("~") then
                    self._formatLeftLabel = self._formatLeftLabel:Insert(0, "~s~")
                end
                if not string.IsNullOrEmpty(self._formatRightLabel) then
                    self._formatRightLabel = self._formatRightLabel:gsub("~l~", "~s~")
                    if not self._formatRightLabel:StartsWith("~") then
                        self._formatRightLabel = self._formatRightLabel:Insert(0, "~s~")
                    end
                end
            end
        end
        if self.ParentMenu ~= nil and self._textColor == 1 and self._highlightedTextColor == 2 and self.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_ITEM_LABELS", false, IndexOf(self.ParentMenu.Items, item) - 1,  self._formatLeftLabel, self._formatRightLabel)
        end
    else
        return self._Selected
    end
end

function UIMenuItem:Hovered(bool)
    if bool ~= nil then
        self._Hovered = tobool(bool)
    else
        return self._Hovered
    end
end

function UIMenuItem:Enabled(bool, item)
    if bool ~= nil then
        if item == nil then item = self end
        self._Enabled = tobool(bool)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("ENABLE_ITEM", false, IndexOf(self.ParentMenu.Items, item) - 1,  self._Enabled)
        end
    else
        return self._Enabled
    end
end

function UIMenuItem:Activated(menu, item)
    self.Activated(menu, item)
end

function UIMenuItem:Description(str, item)
    if tostring(str) and str ~= nil then
        if item == nil then item = self end
        self._Description = tostring(str)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            AddTextEntry("desc_{" .. IndexOf(self.ParentMenu.Items, item) .."}", str)
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_ITEM_DESCRIPTION", false, IndexOf(self.ParentMenu.Items, item) - 1, "desc_{" .. IndexOf(self.ParentMenu.Items, self) .."}")
        end
    else
        return self._Description
    end
end

function UIMenuItem:MainColor(color, item)
    if(color)then
        if item == nil then item = self end
        self._mainColor = color
        if(self.ParentMenu ~= nil and self.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.ParentMenu.Items, item) - 1, self._mainColor, self._highlightColor, self._textColor, self._highlightedTextColor);
        end
    else
        return self._mainColor
    end
end

function UIMenuItem:TextColor(color, item)
    if(color)then
        if item == nil then item = self end
        self._textColor = color
        if(self.ParentMenu ~= nil and self.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.ParentMenu.Items, item) - 1, self._mainColor, self._highlightColor, self._textColor, self._highlightedTextColor);
        end
    else
        return self._textColor
    end
end

function UIMenuItem:HighlightColor(color, item)
    if(color)then
        if item == nil then item = self end
        self._highlightColor = color
        if(self.ParentMenu ~= nil and self.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.ParentMenu.Items, item) - 1, self._mainColor, self._highlightColor, self._textColor, self._highlightedTextColor);
        end
    else
        return self._highlightColor
    end
end

function UIMenuItem:HighlightedTextColor(color, item)
    if(color)then
        if item == nil then item = self end
        self._highlightedTextColor = color
        if(self.ParentMenu ~= nil and self.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.ParentMenu.Items, item) - 1, self._mainColor, self._highlightColor, self._textColor, self._highlightedTextColor);
        end
    else
        return self._highlightedTextColor
    end
end

function UIMenuItem:Label(Text, item)
    if tostring(Text) and Text ~= nil then
        if item == nil then item = self end
        self._label = (tostring(Text))
        self._formatLeftLabel = (tostring(Text))
        if self:Selected() then
            if(self._highlightedTextColor == 2) then
                if self._formatLeftLabel:find("~") then
                    self._formatLeftLabel = self._formatLeftLabel:gsub("~w~", "~l~")
                    self._formatLeftLabel = self._formatLeftLabel:gsub("~s~", "~l~")
                    if not self._formatLeftLabel:StartsWith("~") then
                        self._formatLeftLabel = self._formatLeftLabel:Insert(0, "~l~")
                    end
                end
            end
        else
            if(self._textColor == 1) then
                self._formatLeftLabel = self._formatLeftLabel:gsub("~l~", "~s~")
                if not self._formatLeftLabel:StartsWith("~") then
                    self._formatLeftLabel = self._formatLeftLabel:Insert(0, "~s~")
                end
            end
        end
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() and self._textColor == 1 and self._highlightedTextColor == 2 then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_LEFT_LABEL", false, IndexOf(self.ParentMenu.Items, item) - 1,  self._formatLeftLabel)
        end
    else
        return self._label
    end
end

function UIMenuItem:RightLabel(Text)
    if tostring(Text) and Text ~= nil then
        self._rightLabel = tostring(Text)
        self._formatRightLabel = tostring(Text)
        if self:Selected() then
            if(self._highlightedTextColor == 2) then
                if self._formatRightLabel:find("~") then
                    self._formatRightLabel = self._formatRightLabel:gsub("~w~", "~l~")
                    self._formatRightLabel = self._formatRightLabel:gsub("~s~", "~l~")
                    if not self._formatRightLabel:StartsWith("~") then
                        self._formatRightLabel = self._formatRightLabel:Insert(0, "~l~")
                    end
                end
            end
        else
            if(self._textColor == 1) then
                self._formatRightLabel = self._formatRightLabel:gsub("~l~", "~s~")
                if not self._formatRightLabel:StartsWith("~") then
                    self._formatRightLabel = self._formatRightLabel:Insert(0, "~s~")
                end
            end
        end
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() and self._textColor == 1 and self._highlightedTextColor == 2 then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_RIGHT_LABEL", false, IndexOf(self.ParentMenu.Items, self) - 1,  self._formatRightLabel)
        end
    else
        return self._rightLabel
    end
end

function UIMenuItem:RightBadge(Badge, item)
    if tonumber(Badge) then
        if item == nil then item = self end
        self._rightBadge = tonumber(Badge)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_RIGHT_BADGE", false, IndexOf(self.ParentMenu.Items, item) - 1, self._rightBadge)
        end
    else
        return self._rightBadge
    end
end

function UIMenuItem:LeftBadge(Badge, item)
    if tonumber(Badge) then
        if item == nil then item = self end
        self._leftBadge = tonumber(Badge)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_LEFT_BADGE", false, IndexOf(self.ParentMenu.Items, item) - 1, self._leftBadge)
        end
    else
        return self._leftBadge
    end
end

function UIMenuItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        table.insert(self.Panels, Panel)
        Panel:SetParentItem(self)
    end
end

function UIMenuItem:AddSidePanel(sidePanel)
    if sidePanel() == "UIMissionDetailsPanel" then
        sidePanel:SetParentItem(self)
        self.SidePanel = sidePanel
		if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false, IndexOf(self.ParentMenu.Items, self) - 1, 0, sidePanel.PanelSide, sidePanel.TitleType, sidePanel.Title, sidePanel.TitleColor, sidePanel.TextureDict, sidePanel.TextureName)
        end
    elseif sidePanel() == "UIVehicleColorPickerPanel" then
        sidePanel:SetParentItem(self)
        self.SidePanel = sidePanel
		if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false, IndexOf(self.ParentMenu.Items, self) - 1, 1, sidePanel.PanelSide, sidePanel.TitleType, sidePanel.Title, sidePanel.TitleColor)
        end
    end
end

function UIMenuItem:RemoveSidePanel()
    self.SidePanel = nil
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        ScaleformUI.Scaleforms._ui:CallFunction("REMOVE_SIDE_PANEL_TO_ITEM", false, IndexOf(self.ParentMenu.Items, self) - 1);
    end
end


function UIMenuItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
        end
    end
end

function UIMenuItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

function UIMenuItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end

function UIMenuItem:BlinkDescription(bool, item)
    if bool ~= nil then
        if item == nil then item = self end
        self.blinkDescription = bool
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_BLINK_DESC", false, IndexOf(self.ParentMenu.Items, item) - 1, self.blinkDescription)
        end
    else
        return self.blinkDescription
    end
end