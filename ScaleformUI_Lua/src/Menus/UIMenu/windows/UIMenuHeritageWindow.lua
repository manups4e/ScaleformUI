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
        id = 0,
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
    if not tonumber(Dad) then Dad = self.Dad end

    if tonumber(Mom) == -1 then
        Mom = self.Mom
    elseif tonumber(Dad) == -1 then
        Dad = self.Dad
    end

    self.Mom = Mom - 1
    self.Dad = Dad - 1

    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        self.ParentMenu:SetWindows(true)
    end
end
