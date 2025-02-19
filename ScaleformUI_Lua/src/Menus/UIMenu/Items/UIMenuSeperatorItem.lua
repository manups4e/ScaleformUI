UIMenuSeparatorItem = setmetatable({}, UIMenuSeparatorItem)
UIMenuSeparatorItem.__index = UIMenuSeparatorItem
UIMenuSeparatorItem.__call = function() return "UIMenuItem", "UIMenuSeparatorItem" end

---@class UIMenuSeparatorItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param jumpable boolean
---@param mainColor? SColor
---@param highlightColor? SColor
---@param textColor? SColor
---@param highlightedTextColor? SColor
function UIMenuSeparatorItem.New(Text, jumpable, mainColor, highlightColor, textColor, highlightedTextColor)
    local _UIMenuSeparatorItem = {
        Base = UIMenuItem.New(Text or "", "", mainColor or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White),
        Panels = {},
        SidePanel = nil,
        Jumpable = jumpable,
        ItemId = 6
    }
    return setmetatable(_UIMenuSeparatorItem, UIMenuSeparatorItem)
end

function UIMenuSeparatorItem:ItemData(data)
    if data == nil then
        return self.Base:ItemData(data)
    else
        self.Base:ItemData()
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuSeparatorItem:LabelFont(itemFont)
    if itemFont == nil then
        return self.Base:LabelFont()
    end
    self.Base:LabelFont(itemFont, self)
end

-- not supported on Lobby and Pause menu yet
function UIMenuSeparatorItem:RightLabelFont(itemFont)
    if itemFont == nil then
        return self.Base:RightLabelFont()
    end
    self.Base:RightLabelFont(itemFont, self)
end

---Set the Parent Menu of the Item
---@param menu UIMenu
---@return UIMenu? -- returns the parent menu if no menu is passed, if a menu is passed it returns the menu if it was set successfully
function UIMenuSeparatorItem:SetParentMenu(menu)
    if menu == nil then
        return self.Base:SetParentMenu()
    end
    self.Base:SetParentMenu(menu)
end

function UIMenuSeparatorItem:Selected(bool)
    if bool == nil then
        return self.Base:Selected()
    end
    self.Base:Selected(bool, self)
end

function UIMenuSeparatorItem:Hovered(bool)
    if bool == nil then
        return self.Base:Hovered()
    end
    self.Base:Hovered(bool)
end

function UIMenuSeparatorItem:Enabled(bool)
    if bool == nil then
        return self.Base:Enabled()
    end
    self.Base:Hovered(bool, self)
end

function UIMenuSeparatorItem:Description(str)
    if str == nil then
        return self.Base:Description()
    end
    self.Base:Description(str, self)
end

function UIMenuSeparatorItem:MainColor(color)
    if color == nil then
        return self.Base:MainColor()
    end
    self.Base:MainColor(color, self)
end

function UIMenuSeparatorItem:HighlightColor(color)
    if color == nil then
        return self.Base:HighlightColor()
    end
    self.Base:HighlightColor(color, self)
end

function UIMenuSeparatorItem:Label(Text)
    if Text == nil then
        return self.Base:Label()
    end
    self.Base:Label(Text, self)
end

function UIMenuSeparatorItem:BlinkDescription(bool)
    if bool == nil then
        return self.Base:BlinkDescription()
    end
    self.Base:BlinkDescription(bool, self)
end


function UIMenuSeparatorItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        Panel.ParentItem = self
        self.Panels[#self.Panels + 1] = Panel
    end
end

function UIMenuSeparatorItem:AddSidePanel(sidePanel)
    sidePanel:SetParentItem(self)
    self.SidePanel = sidePanel
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuSeparatorItem:RemoveSidePanel()
    self.SidePanel = nil
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuSeparatorItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendPanelsToItemScaleform(it)
        end
    end
end

function UIMenuSeparatorItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

function UIMenuSeparatorItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end

---LeftBadge
function UIMenuSeparatorItem:LeftBadge()
    error("This item does not support badges")
end

---RightBadge
function UIMenuSeparatorItem:RightBadge()
    error("This item does not support badges")
end

function UIMenuSeparatorItem:CustomLeftBadge()
    error("This item does not support badges")
end

---RightBadge
function UIMenuSeparatorItem:CustomRightBadge()
    error("This item does not support badges")
end

---RightLabel
function UIMenuSeparatorItem:RightLabel()
    error("This item does not support a right label")
end