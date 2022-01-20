UIMenuHeritageWindow = setmetatable({}, UIMenuHeritageWindow)
UIMenuHeritageWindow.__index = UIMenuHeritageWindow
UIMenuHeritageWindow.__call = function() return "UIMenuWindow", "UIMenuHeritageWindow" end

---New
---@param Mom number
---@param Dad number
function UIMenuHeritageWindow.New(Mom, Dad)
	if not tonumber(Mom) then Mom = 0 end
	if not (Mom >= 0 and Mom <= 21) then Mom = 0 end
	if not tonumber(Dad) then Dad = 0 end
	if not (Dad >= 0 and Dad <= 23) then Dad = 0 end
	_UIMenuHeritageWindow = {
		Mom = Mom,
		Dad = Dad,
		ParentMenu = nil, -- required
	}
	return setmetatable(_UIMenuHeritageWindow, UIMenuHeritageWindow)
end

---SetParentMenu
---@param Menu table
function UIMenuHeritageWindow:SetParentMenu(Menu) -- required
	if Menu() == "UIMenu" then
		self.ParentMenu = Menu
	else
		return self.ParentMenu
	end
end

function UIMenuHeritageWindow:Index(Mom, Dad)
	if not tonumber(Mom) then Mom = self.Mom end
	if not (Mom >= 0 and Mom <= 21) then Mom = self.Mom end
	if not tonumber(Dad) then Dad = self.Dad end
	if not (Dad >= 0 and Dad <= 23) then Dad = self.Dad end

	self.Mom = Mom
	self.Dad = Dad

	while (not HasStreamedTextureDictLoaded("char_creator_portraits")) do
		Citizen.Wait(0)
		RequestStreamedTextureDict("char_creator_portraits", true)
	end
	local wid = IndexOf(self.ParentMenu.Items, self) - 1
	ScaleformUI.Scaleforms._ui.CallFunction("UPDATE_HERITAGE_WINDOW", wid, self.Mom, self.Dad)
	SetStreamedTextureDictAsNoLongerNeeded("char_creator_portraits")
end