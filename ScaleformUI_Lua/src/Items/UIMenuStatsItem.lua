UIMenuStatsItem = setmetatable({}, UIMenuStatsItem)
UIMenuStatsItem.__index = UIMenuStatsItem
UIMenuStatsItem.__call = function() return "UIMenuItem", "UIMenuStatsItem" end

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
---@param Counter boolean
function UIMenuStatsItem.New(Text, Description, Index, barColor, type, mainColor, highlightColor, textColor, highlightedTextColor)
	local _UIMenuStatsItem = {
		Base = UIMenuItem.New(Text or "", Description or "", mainColor or 2, highlightColor or 1, textColor or 1, highlightedTextColor or 2),
		_Index = Index or 0,
		Panels = {},
		_Color = barColor or 116,
        _Type = type or 0,
		OnStatsChanged = function(menu, item, newindex) end,
		OnStatsSelected = function(menu, item, newindex) end,
	}
	return setmetatable(_UIMenuStatsItem, UIMenuStatsItem)
end

---SetParentMenu
---@param Menu table
function UIMenuStatsItem:SetParentMenu(Menu)
	if Menu() == "UIMenu" then
		self.Base.ParentMenu = Menu
	else
		return self.Base.ParentMenu
	end
end

---Selected
---@param bool number
function UIMenuStatsItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
	else
		return self.Base._Selected
	end
end

---Hovered
---@param bool boolean
function UIMenuStatsItem:Hovered(bool)
	if bool ~= nil then
		self.Base._Hovered = tobool(bool)
	else
		return self.Base._Hovered
	end
end

---Enabled
---@param bool boolean
function UIMenuStatsItem:Enabled(bool)
	if bool ~= nil then
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

---Description
---@param str string
function UIMenuStatsItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

---Text
---@param Text string
function UIMenuStatsItem:Label(Text)
	if tostring(Text) and Text ~= nil then
		self.Base:Label(tostring(Text))
	else
		return self.Base:Label()
	end
end

function UIMenuStatsItem:BlinkDescription(bool)
    if bool ~= nil then
		self.Base:BlinkDescription(bool)
	else
		return self.Base:BlinkDescription()
	end
end

---Index
---@param Index table
function UIMenuStatsItem:Index(Index)
	if tonumber(Index) then
		if Index > 100 then
			self._Index = 100
		elseif Index < 0 then
			self._Index = 0
		else
			self._Index = Index
		end
		self.OnStatsChanged(self._Index)
        if self.Base.ParentMenu ~= nil then
            ScaleformUI.Scaleforms._ui:CallFunction("SET_ITEM_VALUE", IndexOf(self.Base.ParentMenu.Items, self) - 1, self._Index)
        end
	else
		return self._Index
	end
end

---SetLeftBadge
function UIMenuStatsItem:SetLeftBadge()
	error("This item does not support badges")
end

---SetRightBadge
function UIMenuStatsItem:SetRightBadge()
	error("This item does not support badges")
end

---RightLabel
function UIMenuStatsItem:RightLabel()
	error("This item does not support a right label")
end