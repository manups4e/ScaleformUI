UIMenuProgressItem = setmetatable({}, UIMenuProgressItem)
UIMenuProgressItem.__index = UIMenuProgressItem
UIMenuProgressItem.__call = function() return "UIMenuItem", "UIMenuProgressItem" end

---@class UIMenuProgressItem : UIMenuItem
---@field public Base UIMenuItem

---New
---@param Text string
---@param Max number
---@param Index number
---@param Description string
---@param sliderColor SColor
---@param color SColor
---@param highlightColor SColor
---@param backgroundSliderColor SColor
function UIMenuProgressItem.New(Text, Max, Index, Description, sliderColor, color, highlightColor, backgroundSliderColor)
    local _UIMenuProgressItem = {
        Base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White),
        _Max = Max or 100,
        _Multiplier = 5,
        _Index = Index or 0,
        Panels = {},
        SidePanel = nil,
        _sliderColor = sliderColor or SColor.HUD_Freemode,
        BackgroundSliderColor = backgroundSliderColor or SColor.HUD_Pause_bg,
        ItemId = 4,
        OnProgressChanged = function(menu, item, newindex)
        end,
        OnProgressSelected = function(menu, item, newindex)
        end,
    }

    return setmetatable(_UIMenuProgressItem, UIMenuProgressItem)
end

function UIMenuProgressItem:ItemData(data)
    if data == nil then
        return self.Base:ItemData(data)
    else
        self.Base:ItemData()
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuProgressItem:LabelFont(itemFont)
    if itemFont == nil then
        return self.Base:LabelFont()
    end
    self.Base:LabelFont(itemFont, self)
end

-- not supported on Lobby and Pause menu yet
function UIMenuProgressItem:RightLabelFont(itemFont)
    if itemFont == nil then
        return self.Base:RightLabelFont()
    end
    self.Base:RightLabelFont(itemFont, self)
end

---Set the Parent Menu of the Item
---@param menu UIMenu
---@return UIMenu? -- returns the parent menu if no menu is passed, if a menu is passed it returns the menu if it was set successfully
function UIMenuProgressItem:SetParentMenu(menu)
    if menu == nil then
        return self.Base:SetParentMenu()
    end
    self.Base:SetParentMenu(menu)
end

function UIMenuProgressItem:Selected(bool)
    if bool == nil then
        return self.Base:Selected()
    end
    self.Base:Selected(bool, self)
end

function UIMenuProgressItem:Hovered(bool)
    if bool == nil then
        return self.Base:Hovered()
    end
    self.Base:Hovered(bool)
end

function UIMenuProgressItem:Enabled(bool)
    if bool == nil then
        return self.Base:Enabled()
    end
    self.Base:Hovered(bool, self)
end

function UIMenuProgressItem:Description(str)
    if str == nil then
        return self.Base:Description()
    end
    self.Base:Description(str, self)
end

function UIMenuProgressItem:MainColor(color)
    if color == nil then
        return self.Base:MainColor()
    end
    self.Base:MainColor(color, self)
end

function UIMenuProgressItem:HighlightColor(color)
    if color == nil then
        return self.Base:HighlightColor()
    end
    self.Base:HighlightColor(color, self)
end

function UIMenuProgressItem:Label(Text)
    if Text == nil then
        return self.Base:Label()
    end
    self.Base:Label(Text, self)
end

function UIMenuProgressItem:BlinkDescription(bool)
    if bool == nil then
        return self.Base:BlinkDescription()
    end
    self.Base:BlinkDescription(bool, self)
end

function UIMenuProgressItem:LeftBadge(Badge)
    if Badge == nil then
        return self.Base:LeftBadge()
    end
    self.Base:LeftBadge(Badge, self)
end

function UIMenuProgressItem:CustomLeftBadge(txd,txn)
    self.Base:CustomLeftBadge(txd,txn, self)
end

---RightBadge
function UIMenuProgressItem:RightBadge()
    error("This item does not support right badges")
end

function UIMenuProgressItem:CustomRightBadge()
    error("This item does not support right badges")
end

---RightLabel
function UIMenuProgressItem:RightLabel()
    error("This item does not support a right label")
end


function UIMenuProgressItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        Panel.ParentItem = self
        self.Panels[#self.Panels + 1] = Panel
    end
end

function UIMenuProgressItem:AddSidePanel(sidePanel)
    sidePanel:SetParentItem(self)
    self.SidePanel = sidePanel
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuProgressItem:RemoveSidePanel()
    self.SidePanel = nil
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuProgressItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendPanelsToItemScaleform(it)
        end
    end
end

function UIMenuProgressItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

function UIMenuProgressItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end

function UIMenuProgressItem:SliderColor(color)
    if color then
        assert(color() == "SColor", "Color must be SColor type")
        self._sliderColor = color
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            local it = IndexOf(self.Base.ParentMenu.Items, self)
            self.Base.ParentMenu:SendItemToScaleform(it, true)
        end
    else
        return self._sliderColor
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
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            local it = IndexOf(self.Base.ParentMenu.Items, self)
            self.Base.ParentMenu:SendItemToScaleform(it, true)
        end
    else
        return self._Index
    end
end
