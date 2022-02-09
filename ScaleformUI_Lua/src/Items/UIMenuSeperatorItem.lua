UIMenuSeperatorItem = setmetatable({}, UIMenuSeperatorItem)
UIMenuSeperatorItem.__index = UIMenuSeperatorItem
UIMenuSeperatorItem.__call = function() return "UIMenuItem", "UIMenuSeperatorItem" end

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
---@param Counter boolean
function UIMenuSeperatorItem.New(Text, jumpable , mainColor, highlightColor, textColor, highlightedTextColor)
	local _UIMenuSeperatorItem = {
		Base = UIMenuItem.New(Text or "", "", mainColor or 117, highlightColor or 1, textColor or 1, highlightedTextColor or 2),
		Panels = {},
		SidePanel = nil,
        Jumpable = jumpable
	}
	return setmetatable(_UIMenuSeperatorItem, UIMenuSeperatorItem)
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

---Description
---@param str string
function UIMenuSeperatorItem:Description(str)
	if tostring(str) and str ~= nil then
		self.Base._Description = tostring(str)
	else
		return self.Base._Description
	end
end

---Text
---@param Text string
function UIMenuSeperatorItem:Label(Text)
	if tostring(Text) and Text ~= nil then
		self.Base:Label(tostring(Text))
	else
		return self.Base:Label()
	end
end

---Selected
---@param bool number
function UIMenuSeperatorItem:Selected(bool)
	if bool ~= nil then
		self.Base._Selected = tobool(bool)
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
		self.Base._Enabled = tobool(bool)
	else
		return self.Base._Enabled
	end
end

function UIMenuSeperatorItem:BlinkDescription(bool)
    if bool ~= nil then
		self.Base:BlinkDescription(bool)
	else
		return self.Base:BlinkDescription()
	end
end