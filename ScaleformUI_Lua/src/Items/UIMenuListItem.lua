UIMenuListItem = setmetatable({}, UIMenuListItem)
UIMenuListItem.__index = UIMenuListItem
UIMenuListItem.__call = function() return "UIMenuItem", "UIMenuListItem" end

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
function UIMenuListItem.New(Text, Items, Index, Description, color, highlightColor, textColor, highlightedTextColor)
	if type(Items) ~= "table" then Items = {} end
	if Index == 0 then Index = 1 end
	local _UIMenuListItem = {
		Base = UIMenuItem.New(Text or "", Description or "", color or 117, highlightColor or 1, textColor or 1, highlightedTextColor or 2),
		Items = Items,
		_Index = tonumber(Index) or 1,
		Panels = {},
		SidePanel = nil,
		OnListChanged = function(menu, item, newindex) end,
		OnListSelected = function(menu, item, newindex) end,
	}
	return setmetatable(_UIMenuListItem, UIMenuListItem)
end

---SetParentMenu
---@param Menu table
function UIMenuListItem:SetParentMenu(Menu)
	if Menu ~= nil and Menu() == "UIMenu" then
		self.Base.ParentMenu = Menu
	else
		return self.Base.ParentMenu
	end
end

function UIMenuListItem:AddSidePanel(sidePanel)
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
function UIMenuListItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
	else
		return self.Base._Selected
	end
end

---Hovered
---@param bool boolean
function UIMenuListItem:Hovered(bool)
	if bool ~= nil then
		self.Base._Hovered = tobool(bool)
	else
		return self.Base._Hovered
	end
end

---Enabled
---@param bool boolean
function UIMenuListItem:Enabled(bool)
	if bool ~= nil then
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

---Description
---@param str string
function UIMenuListItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

function UIMenuListItem:BlinkDescription(bool)
    if bool ~= nil then
		self.Base:BlinkDescription(bool)
	else
		return self.Base:BlinkDescription()
	end
end

---Text
---@param Text string
function UIMenuListItem:Label(Text)
	if tostring(Text) and Text ~= nil then
		self.Base:Label(tostring(Text))
	else
		return self.Base:Label()
	end
end

function UIMenuListItem:MainColor(color)
    if(color)then
        self.Base._mainColor = color
        if(self.Base.ParentMenu ~= nil) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor);
        end
    else
        return self.Base._mainColor
    end
end

function UIMenuListItem:TextColor(color)
    if(color)then
        self.Base._textColor = color
        if(self.Base.ParentMenu ~= nil) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor);
        end
    else
        return self.Base._textColor
    end
end

function UIMenuListItem:HighlightColor(color)
    if(color)then
        self.Base._highlightColor = color
        if(self.Base.ParentMenu ~= nil) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor);
        end
    else
        return self.Base._highlightColor
    end
end

function UIMenuListItem:HighlightedTextColor(color)
    if(color)then
        self.Base._highlightedTextColor = color
        if(self.Base.ParentMenu ~= nil) then
            ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_COLORS", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, self.Base._mainColor, self.Base._highlightColor, self.Base._textColor, self.Base._highlightedTextColor);
        end
    else
        return self.Base._highlightedTextColor
    end
end
---Index
---@param Index table
function UIMenuListItem:Index(Index)
	if tonumber(Index) then
		local ind = Index+1
		if ind > #self.Items then
			self._Index = 1
		elseif ind < 1 then
			self._Index = #self.Items
		else
			self._Index = ind
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
---@param Index table
function UIMenuListItem:IndexToItem(Index)
	if tonumber(Index) then
		if tonumber(Index) == 0 then Index = 1 end
		if self.Items[tonumber(Index)] then
			return self.Items[tonumber(Index)]
		end
	end
end

---SetLeftBadge
function UIMenuListItem:SetLeftBadge()
	error("This item does not support badges")
end

---SetRightBadge
function UIMenuListItem:SetRightBadge()
	error("This item does not support badges")
end

---RightLabel
function UIMenuListItem:RightLabel()
	error("This item does not support a right label")
end

---AddPanel
---@param Panel table
function UIMenuListItem:AddPanel(Panel)
	if Panel() == "UIMenuPanel" then
		table.insert(self.Panels, Panel)
		Panel:SetParentItem(self)
	end
end

---RemovePanelAt
---@param Index table
function UIMenuListItem:RemovePanelAt(Index)
	if tonumber(Index) then
		if self.Panels[Index] then
			table.remove(self.Panels, tonumber(Index))
		end
	end
end

---FindPanelIndex
---@param Panel table
function UIMenuListItem:FindPanelIndex(Panel)
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
function UIMenuListItem:FindPanelItem()
	for Index = #self.Items, 1, -1 do
		if self.Items[Index].Panel then
			return Index
		end
	end
	return nil
end

function UIMenuListItem:ChangeList(list)
	if type(list) ~= "table" then return end
	self.Items = {}
	self.Items = list
    if self.Base.ParentMenu:Visible() then
    	ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_LISTITEM_LIST", false, IndexOf(self.Base.ParentMenu.Items, self) - 1, table.concat(self.Items, ","), self._Index)
    end
end