UIMenuProgressItem = setmetatable({}, UIMenuProgressItem)
UIMenuProgressItem.__index = UIMenuProgressItem
UIMenuProgressItem.__call = function() return "UIMenuItem", "UIMenuProgressItem" end

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
---@param Counter boolean
function UIMenuProgressItem.New(Text, Max, Index, Description, color, highlightColor, textColor, highlightedTextColor, sliderColor, backgroundSliderColor)
	local _UIMenuProgressItem = {
		Base = UIMenuItem.New(Text or "", Description or "", color or 2, highlightColor or 1, textColor or 1, highlightedTextColor or 2),
		_Max = Max or 100,
		_Multiplier = 5,
		_Index = Index or 0,
		Panels = {},
		SliderColor = sliderColor or 116,
		BackgroundSliderColor = backgroundSliderColor or 117,
		OnProgressChanged = function(menu, item, newindex) end,
		OnProgressSelected = function(menu, item, newindex) end,
	}

	return setmetatable(_UIMenuProgressItem, UIMenuProgressItem)
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

---Selected
---@param bool number
function UIMenuProgressItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
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
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

---Description
---@param str string
function UIMenuProgressItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

---Text
---@param Text string
function UIMenuProgressItem:Label(Text)
	if tostring(Text) and Text ~= nil then
		self.Base:Label(tostring(Text))
	else
		return self.Base:Label()
	end
end

function UIMenuProgressItem:BlinkDescription(bool)
    if bool ~= nil then
		self.Base:BlinkDescription(bool)
	else
		return self.Base:BlinkDescription()
	end
end

---Index
---@param Index table
function UIMenuProgressItem:Index(Index)
	if tonumber(Index) then
		if(Index > self._Max) then
			self._Index = self._Max
		elseif (Index < 0) then
			self._Index = 0
		else
			self._Index = Index
		end
		self.OnProgressChanged(self._Index)
	else
		return self._Index
	end
end

---SetLeftBadge
function UIMenuProgressItem:SetLeftBadge()
	error("This item does not support badges")
end

---SetRightBadge
function UIMenuProgressItem:SetRightBadge()
	error("This item does not support badges")
end

---RightLabel
function UIMenuProgressItem:RightLabel()
	error("This item does not support a right label")
end