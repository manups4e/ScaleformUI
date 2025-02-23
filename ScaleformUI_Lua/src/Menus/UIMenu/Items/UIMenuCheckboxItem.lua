UIMenuCheckboxItem = setmetatable({}, UIMenuCheckboxItem)
UIMenuCheckboxItem.__index = UIMenuCheckboxItem
UIMenuCheckboxItem.__call = function() return "UIMenuItem", "UIMenuCheckboxItem" end

---@class UIMenuCheckboxItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param Check boolean
---@param Description string
function UIMenuCheckboxItem.New(Text, Check, checkStyle, Description, color, highlightColor)
    local _UIMenuCheckboxItem = {
        Base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White),
        _Checked = ToBool(Check),
        Panels = {},
        SidePanel = nil,
        CheckBoxStyle = checkStyle or 0,
        ItemId = 2,
        OnCheckboxChanged = function(menu, item, checked)
        end,
    }
    return setmetatable(_UIMenuCheckboxItem, UIMenuCheckboxItem)
end

function UIMenuCheckboxItem:ItemData(data)
    if data == nil then
        return self.Base:ItemData(data)
    else
        self.Base:ItemData()
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuCheckboxItem:LabelFont(itemFont)
    if itemFont == nil then
        return self.Base:LabelFont()
    end
    self.Base:LabelFont(itemFont, self)
end

-- not supported on Lobby and Pause menu yet
function UIMenuCheckboxItem:RightLabelFont(itemFont)
    if itemFont == nil then
        return self.Base:RightLabelFont()
    end
    self.Base:RightLabelFont(itemFont, self)
end

---Set the Parent Menu of the Item
---@param menu UIMenu
---@return UIMenu? -- returns the parent menu if no menu is passed, if a menu is passed it returns the menu if it was set successfully
function UIMenuCheckboxItem:SetParentMenu(menu)
    if menu == nil then
        return self.Base:SetParentMenu()
    end
    self.Base:SetParentMenu(menu)
end

function UIMenuCheckboxItem:Selected(bool)
    if bool == nil then
        return self.Base:Selected()
    end
    self.Base:Selected(bool, self)
end

function UIMenuCheckboxItem:Hovered(bool)
    if bool == nil then
        return self.Base:Hovered()
    end
    self.Base:Hovered(bool)
end

function UIMenuCheckboxItem:Enabled(bool)
    if bool == nil then
        return self.Base:Enabled()
    end
    self.Base:Hovered(bool, self)
end

function UIMenuCheckboxItem:Description(str)
    if str == nil then
        return self.Base:Description()
    end
    self.Base:Description(str, self)
end

function UIMenuCheckboxItem:MainColor(color)
    if color == nil then
        return self.Base:MainColor()
    end
    self.Base:MainColor(color, self)
end

function UIMenuCheckboxItem:HighlightColor(color)
    if color == nil then
        return self.Base:HighlightColor()
    end
    self.Base:HighlightColor(color, self)
end

function UIMenuCheckboxItem:Label(Text)
    if Text == nil then
        return self.Base:Label()
    end
    self.Base:Label(Text, self)
end

function UIMenuCheckboxItem:LeftBadge(Badge)
    if Badge == nil then
        return self.Base:LeftBadge()
    end
    self.Base:LeftBadge(Badge, self)
end

function UIMenuCheckboxItem:CustomLeftBadge(txd,txn)
    self.Base:CustomLeftBadge(txd,txn, self)
end


function UIMenuCheckboxItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        Panel.ParentItem = self
        self.Panels[#self.Panels + 1] = Panel
    end
end

function UIMenuCheckboxItem:AddSidePanel(sidePanel)
    sidePanel:SetParentItem(self)
    self.SidePanel = sidePanel
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuCheckboxItem:RemoveSidePanel()
    self.SidePanel = nil
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuCheckboxItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendPanelsToItemScaleform(it)
        end
    end
end

function UIMenuCheckboxItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

function UIMenuCheckboxItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end

function UIMenuCheckboxItem:BlinkDescription(bool)
    if bool == nil then
        return self.Base:BlinkDescription()
    end
    self.Base:BlinkDescription(bool, self)
end

---RightBadge
function UIMenuCheckboxItem:RightBadge()
    error("This item does not support right badges")
end

function UIMenuCheckboxItem:CustomRightBadge()
    error("This item does not support right badges")
end

---RightLabel
function UIMenuCheckboxItem:RightLabel()
    error("This item does not support a right label")
end

function UIMenuCheckboxItem:Checked(bool)
    if bool ~= nil then
        self._Checked = ToBool(bool)
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            local it = IndexOf(self.Base.ParentMenu.Items, self)
            self.Base.ParentMenu:SendItemToScaleform(it, true)
        end
    else
        return self._Checked
    end
end
