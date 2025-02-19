UIMenuStatsItem = setmetatable({}, UIMenuStatsItem)
UIMenuStatsItem.__index = UIMenuStatsItem
UIMenuStatsItem.__call = function() return "UIMenuItem", "UIMenuStatsItem" end

---@class UIMenuStatsItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param Description string
---@param Index number|0
---@param barColor SColor
---@param type number|0
---@param mainColor SColor
---@param highlightColor SColor
function UIMenuStatsItem.New(Text, Description, Index, barColor, type, mainColor, highlightColor)
    local _UIMenuStatsItem = {
        Base = UIMenuItem.New(Text or "", Description or "", SColor.HUD_Panel_light, highlightColor or SColor.HUD_White),
        _Index = Index or 0,
        Panels = {},
        SidePanel = nil,
        _Color = barColor or SColor.HUD_Freemode,
        _Type = type or 0,
        ItemId = 5,
        OnStatsChanged = function(menu, item, newindex)
        end,
        OnStatsSelected = function(menu, item, newindex)
        end,
    }
    return setmetatable(_UIMenuStatsItem, UIMenuStatsItem)
end

function UIMenuStatsItem:ItemData(data)
    if data == nil then
        return self.Base:ItemData(data)
    else
        self.Base:ItemData()
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuStatsItem:LabelFont(itemFont)
    if itemFont == nil then
        return self.Base:LabelFont()
    end
    self.Base:LabelFont(itemFont, self)
end

-- not supported on Lobby and Pause menu yet
function UIMenuStatsItem:RightLabelFont(itemFont)
    if itemFont == nil then
        return self.Base:RightLabelFont()
    end
    self.Base:RightLabelFont(itemFont, self)
end

---Set the Parent Menu of the Item
---@param menu UIMenu
---@return UIMenu? -- returns the parent menu if no menu is passed, if a menu is passed it returns the menu if it was set successfully
function UIMenuStatsItem:SetParentMenu(menu)
    if menu == nil then
        return self.Base:SetParentMenu()
    end
    self.Base:SetParentMenu(menu)
end

function UIMenuStatsItem:Selected(bool)
    if bool == nil then
        return self.Base:Selected()
    end
    self.Base:Selected(bool, self)
end

function UIMenuStatsItem:Hovered(bool)
    if bool == nil then
        return self.Base:Hovered()
    end
    self.Base:Hovered(bool)
end

function UIMenuStatsItem:Enabled(bool)
    if bool == nil then
        return self.Base:Enabled()
    end
    self.Base:Hovered(bool, self)
end

function UIMenuStatsItem:Description(str)
    if str == nil then
        return self.Base:Description()
    end
    self.Base:Description(str, self)
end

function UIMenuStatsItem:MainColor(color)
    if color == nil then
        return self.Base:MainColor()
    end
    self.Base:MainColor(color, self)
end

function UIMenuStatsItem:HighlightColor(color)
    if color == nil then
        return self.Base:HighlightColor()
    end
    self.Base:HighlightColor(color, self)
end

function UIMenuStatsItem:Label(Text)
    if Text == nil then
        return self.Base:Label()
    end
    self.Base:Label(Text, self)
end

function UIMenuStatsItem:BlinkDescription(bool)
    if bool == nil then
        return self.Base:BlinkDescription()
    end
    self.Base:BlinkDescription(bool, self)
end

---LeftBadge
function UIMenuStatsItem:LeftBadge()
    error("This item does not support badges")
end

---RightBadge
function UIMenuStatsItem:RightBadge()
    error("This item does not support badges")
end

function UIMenuStatsItem:CustomLeftBadge()
    error("This item does not support badges")
end

function UIMenuStatsItem:CustomRightBadge()
    error("This item does not support badges")
end

---RightLabel
function UIMenuStatsItem:RightLabel()
    error("This item does not support a right label")
end


function UIMenuStatsItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        Panel.ParentItem = self
        self.Panels[#self.Panels + 1] = Panel
    end
end

function UIMenuStatsItem:AddSidePanel(sidePanel)
    sidePanel:SetParentItem(self)
    self.SidePanel = sidePanel
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuStatsItem:RemoveSidePanel()
    self.SidePanel = nil
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuStatsItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendPanelsToItemScaleform(it)
        end
    end
end

function UIMenuStatsItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

function UIMenuStatsItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end

function UIMenuStatsItem:SliderColor(color)
    if color then
        assert(color() == "SColor", "Color must be SColor type")
        self._Color = color
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            local it = IndexOf(self.Base.ParentMenu.Items, self)
            self.Base.ParentMenu:SendItemToScaleform(it, true)
        end
    else
        return self._Color
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
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            local it = IndexOf(self.Base.ParentMenu.Items, self)
            self.Base.ParentMenu:SendItemToScaleform(it, true)
        end
    else
        return self._Index
    end
end