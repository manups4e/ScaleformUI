UIMenuCheckboxItem = setmetatable({}, UIMenuCheckboxItem)
UIMenuCheckboxItem.__index = UIMenuCheckboxItem
UIMenuCheckboxItem.__call = function() return "UIMenuItem", "UIMenuCheckboxItem" end

---New
---@param Text string
---@param Check boolean
---@param Description string
function UIMenuCheckboxItem.New(Text, Check, checkStyle, Description, color, highlightColor, textColor, highlightedTextColor)
	local _UIMenuCheckboxItem = {
		Base = UIMenuItem.New(Text or "", Description or "", color or 117, highlightColor or 1, textColor or 1, highlightedTextColor or 2),
		_Checked = tobool(Check),
		Panels = {},
		SidePanel = nil,
		CheckBoxStyle = checkStyle or 0,
		OnCheckboxChanged = function(menu, item, checked) end,
	}
	return setmetatable(_UIMenuCheckboxItem, UIMenuCheckboxItem)
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
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, 0, sidePanel.PanelSide, sidePanel.TitleType, sidePanel.Title, sidePanel.TitleColor, sidePanel.TextureDict, sidePanel.TextureName)
    elseif sidePanel() == "UIVehicleColorPickerPanel" then	
        sidePanel:SetParentItem(self)	
        self.SidePanel = sidePanel	
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false, IndexOf(self.ParentMenu.Items, self) - 1, 1, sidePanel.PanelSide, sidePanel.TitleType, sidePanel.Title, sidePanel.TitleColor)
	end
end

---Selected
---@param bool boolean
function UIMenuCheckboxItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
	else
		return self.Base._Selected
	end
end

---Hovered
---@param bool boolean
function UIMenuCheckboxItem:Hovered(bool)
	if bool ~= nil then
		self.Base._Hovered = tobool(bool)
	else
		return self.Base._Hovered
	end
end

---Enabled
---@param bool boolean
function UIMenuCheckboxItem:Enabled(bool)
	if bool ~= nil then
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

---Description
---@param str string
function UIMenuCheckboxItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

function UIMenuCheckboxItem:BlinkDescription(bool)
    if bool ~= nil then
		self.Base:BlinkDescription(bool)
	else
		return self.Base:BlinkDescription()
	end
end

---Text
---@param Text string
function UIMenuCheckboxItem:Label(Text)
	if tostring(Text) and Text ~= nil then
		self.Base:Label(tostring(Text))
	else
		return self.Base:Label()
	end
end

function UIMenuCheckboxItem:MainColor(color)
    if(color)then
        self.Base._mainColor = color
        if(self.Base.ParentMenu ~= nil) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor);
        end
    else
        return self.Base._mainColor
    end
end

function UIMenuCheckboxItem:TextColor(color)
    if(color)then
        self.Base._textColor = color
        if(self.Base.ParentMenu ~= nil) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor);
        end
    else
        return self.Base._textColor
    end
end

function UIMenuCheckboxItem:HighlightColor(color)
    if(color)then
        self.Base._highlightColor = color
        if(self.Base.ParentMenu ~= nil) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor);
        end
    else
        return self.Base._highlightColor
    end
end

function UIMenuCheckboxItem:HighlightedTextColor(color)
    if(color)then
        self.Base._highlightedTextColor = color
        if(self.Base.ParentMenu ~= nil) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor);
        end
    else
        return self.Base._highlightedTextColor
    end
end

---SetLeftBadge
function UIMenuCheckboxItem:SetLeftBadge()
	error("This item does not support badges")
end

---SetRightBadge
function UIMenuCheckboxItem:SetRightBadge()
	error("This item does not support badges")
end

---RightLabel
function UIMenuCheckboxItem:RightLabel()
	error("This item does not support a right label")
end

function UIMenuCheckboxItem:Checked(bool)
	if bool ~= nil then
		self._Checked = tobool(bool)
		local it = IndexOf(self.Base.ParentMenu.Items, self) - 1
		ScaleformUI.Scaleforms._ui:CallFunction("SET_INPUT_EVENT", false, 16, it, self._Checked)
	else
		return self._Checked
	end
end