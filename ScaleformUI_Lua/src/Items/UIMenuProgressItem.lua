UIMenuProgressItem = setmetatable({}, UIMenuProgressItem)
UIMenuProgressItem.__index = UIMenuProgressItem
UIMenuProgressItem.__call = function() return "UIMenuItem", "UIMenuProgressItem" end

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
---@param Counter boolean
function UIMenuProgressItem.New(Text, Max, Index, Description, sliderColor, color, highlightColor, textColor, highlightedTextColor)
	local _UIMenuProgressItem = {
		Base = UIMenuItem.New(Text or "", Description or "", color or 117, highlightColor or 1, textColor or 1, highlightedTextColor or 2),
		_Max = Max or 100,
		_Multiplier = 5,
		_Index = Index or 0,
		Panels = {},
		SidePanel = nil,
		SliderColor = sliderColor or 116,
		BackgroundSliderColor = backgroundSliderColor or 117,
		ItemId = 4,
		OnProgressChanged = function(menu, item, newindex) end,
		OnProgressSelected = function(menu, item, newindex) end,
	}

	return setmetatable(_UIMenuProgressItem, UIMenuProgressItem)
end

function UIMenuProgressItem:ItemData(data)
    if data == nil then
        return self.Base._itemData
    else
        self.Base._itemData = data
    end
end

function UIMenuProgressItem:LabelFont(fontTable)
    if fontTable == nil then
        return self.Base._labelFont
    else
        self.Base._labelFont = fontTable
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_ITEM_LABEL_FONT", false, IndexOf(self.ParentMenu.Items, item) - 1,  self.Base._labelFont[1], self.Base._labelFont[2])
        end
    end
end

---SetParentMenu
---@param Menu table
function UIMenuProgressItem:SetParentMenu(Menu)
	if Menu() == "UIMenu" then
		self.Base.ParentMenu = Menu
	else
		return self.Base.ParentMenu
	end
end

function UIMenuProgressItem:AddSidePanel(sidePanel)
    if sidePanel() == "UIMissionDetailsPanel" then
        sidePanel:SetParentItem(self)
        self.SidePanel = sidePanel
		if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
			ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, 0, sidePanel.PanelSide, sidePanel.TitleType, sidePanel.Title, sidePanel.TitleColor, sidePanel.TextureDict, sidePanel.TextureName)
		end
    elseif sidePanel() == "UIVehicleColorPickerPanel" then	
        sidePanel:SetParentItem(self)	
        self.SidePanel = sidePanel	
		if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
			ScaleformUI.Scaleforms._ui:CallFunction("ADD_SIDE_PANEL_TO_ITEM", false, IndexOf(self.ParentMenu.Items, self) - 1, 1, sidePanel.PanelSide, sidePanel.TitleType, sidePanel.Title, sidePanel.TitleColor)
		end
	end
end

---Selected
---@param bool number
function UIMenuProgressItem:Selected(bool)
	if bool ~= nil then
		self.Base:Selected(tobool(bool), self)
	else
		return self.Base._Selected
	end
end

---Hovered
---@param bool boolean
function UIMenuProgressItem:Hovered(bool)
	if bool ~= nil then
		self.Base._Hovered = tobool(bool)
	else
		return self.Base._Hovered
	end
end

---Enabled
---@param bool boolean
function UIMenuProgressItem:Enabled(bool)
	if bool ~= nil then
		self.Base:Enabled(bool, self)
	else
		return self.Base._Enabled
	end
end

---Description
---@param str string
function UIMenuProgressItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base:Description(tostring(str), self)
	else
		return self.Base._Description
	end
end

---Text
---@param Text string
function UIMenuProgressItem:Label(Text)
	if tostring(Text) and Text ~= nil then
		self.Base:Label(tostring(Text), self)
	else
		return self.Base:Label()
	end
end

function UIMenuProgressItem:MainColor(color)
    if(color)then
        self.Base._mainColor = color
        if(self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._mainColor
    end
end

function UIMenuProgressItem:TextColor(color)
    if(color)then
        self.Base._textColor = color
        if(self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._textColor
    end
end

function UIMenuProgressItem:HighlightColor(color)
    if(color)then
        self.Base._highlightColor = color
        if(self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._highlightColor
    end
end

function UIMenuProgressItem:HighlightedTextColor(color)
    if(color)then
        self.Base._highlightedTextColor = color
        if(self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor)
        end
    else
        return self.Base._highlightedTextColor
    end
end

function UIMenuProgressItem:SliderColor(color)
    if(color)then
        self.SliderColor = color
        if(self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible()) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor, self.SliderColor)
        end
    else
        return self.SliderColor
    end
end


function UIMenuProgressItem:BlinkDescription(bool)
    if bool ~= nil then
		self.Base:BlinkDescription(bool, self)
	else
		return self.Base:BlinkDescription()
	end
end

---Index
---@param Index table
function UIMenuProgressItem:Index(Index)
	if tonumber(Index) then
		if Index > self._Max then
			self._Index = self._Max
		elseif Index < 0 then
			self._Index = 0
		else
			self._Index = Index
		end
		self.OnProgressChanged(self._Index)
	else
		return self._Index
	end
end

---LeftBadge
function UIMenuProgressItem:LeftBadge(Badge)
    if tonumber(Badge) then
        self.Base:LeftBadge(Badge, self)
    else
        return self.Base:LeftBadge()
    end
end

---RightBadge
function UIMenuProgressItem:RightBadge()
	error("This item does not support badges")
end

---RightLabel
function UIMenuProgressItem:RightLabel()
	error("This item does not support a right label")
end