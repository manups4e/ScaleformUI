UIMenuItem = {}
UIMenuItem.__index = UIMenuItem
setmetatable(UIMenuItem, { __index = PauseMenuItem })
UIMenuItem.__call = function() return "UIMenuItem" end


---@alias UIMenuPanel
---| '"UIMenuGridPanel"' # Add a UIMenuGridPanel to the item
---| '"UIMenuPercentagePanel"' # Add a UIMenuPercentagePanel to the item
---| '"UIMenuStatisticsPanel"' # Add a UIMenuStatisticsPanel to the item
---| '"UIMenuColorPanel"' # Add a UIMenuColorPanel to the item

---@class UIMenuItem
---@field _label string
---@field _Description string
---@field _labelFont ScaleformFonts
---@field _rightLabelFont ScaleformFonts
---@field Selected boolean
---@field _Hovered boolean
---@field _Enabled boolean
---@field blinkDescription boolean
---@field _rightLabel string
---@field _rightBadge number
---@field _leftBadge number
---@field _mainColor SColor
---@field _highlightColor SColor
---@field _textColor SColor
---@field _highlightedTextColor SColor
---@field _itemData table
---@field ParentMenu UIMenu
---@field ParentColumn MissionListColumn|PlayerListColumn|SettingsListColumn|StoreListColumn
---@field Panels table<UIMenuGridPanel|UIMenuPercentagePanel|UIMenuStatisticsPanel|UIMenuColorPanel>
---@field SidePanel UIMenuPanel -- UIMenuGridPanel, UIMenuPercentagePanel, UIMenuStatisticsPanel, UIMenuColorPanel
---@field ItemId number
---@field Activated fun(self:UIMenuItem, menu:UIMenu, item:UIMenuItem):boolean
---@field SetParentMenu fun(self:UIMenuItem, menu:UIMenu?):UIMenu?

---New
---@param text string
---@param description string
---@param color? SColor
---@param highlightColor? SColor
function UIMenuItem.New(text, description, color, highlightColor)
    local base = PauseMenuItem.New(text)
    base._Description = tostring(description) or ""
    base._rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY
    base._Hovered = false
    base._Enabled = true
    base.blinkDescription = false
    base._rightLabel = ""
    base._rightBadge = 0
    base._leftBadge = 0
    base.keepWhite = false
    base._mainColor = color or SColor.HUD_Panel_light
    base._highlightColor = highlightColor or SColor.HUD_White
    base._itemData = {}
    base.ParentMenu = nil
    base.ParentColumn = nil
    base.Panels = {}
    base.SidePanel = nil
    base.ItemId = 0
    base.customLeftIcon = { TXD = "", TXN = "" }
    base.customRightIcon = { TXD = "", TXN = "" }
    base.Activated = function(menu, item)
    end
    base.Highlighted = function(menu, item)
    end
    base.OnTabPressed = function(menu)
    end

    return setmetatable(base, UIMenuItem)
end

function UIMenuItem:ItemData(data)
    if data == nil then
        return self._itemData
    else
        self._itemData = data
    end
end

function UIMenuItem:KeepTextColorWhite(keep)
    if keep == nil then
        return self.keepWhite
    else
        self.keepWhite = ToBool(bool)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuItem:LeftLabelFont(itemFont)
    if itemFont == nil then
        return self.LabelFont
    else
        self.LabelFont = itemFont
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuItem:RightLabelFont(itemFont)
    if itemFont == nil then
        return self._rightLabelFont
    else
        self._rightLabelFont = itemFont
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    end
end

---Set the Parent Menu of the Item
---@param menu UIMenu
---@return UIMenu? -- returns the parent menu if no menu is passed, if a menu is passed it returns the menu if it was set successfully
function UIMenuItem:SetParentMenu(menu)
    if menu == nil then
        return self.ParentMenu
    end

    if menu ~= nil and menu() == "UIMenu" then
        self.ParentMenu = menu
        return self.ParentMenu
    else
        print("^1ScaleformUI Error: ^7UIMenuItem:SetParentMenu(menu) - menu passed in is not a UIMenu");
        return nil
    end
end

function UIMenuItem:Selected(bool)
    if bool ~= nil then
        self.selected = ToBool(bool)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            self.Highlighted(self.ParentMenu, item)
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            self.Highlighted(nil, item)
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self.selected
    end
end

function UIMenuItem:Hovered(bool)
    if bool ~= nil then
        self._Hovered = ToBool(bool)
    else
        return self._Hovered
    end
end

function UIMenuItem:Enabled(bool)
    if bool ~= nil then
        self._Enabled = ToBool(bool)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._Enabled
    end
end

function UIMenuItem:Description(str)
    if tostring(str) and str ~= nil then
        self._Description = tostring(str)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            AddTextEntry("UIMenu_Current_Description", str);
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            AddTextEntry("PAUSEMENU_Current_Description", str);
            self.ParentColumn:UpdateDescription();
        end
    else
        return self._Description
    end
end

function UIMenuItem:MainColor(color)
    if color then
        assert(color() == "SColor", "Color must be SColor type")
        self._mainColor = color
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._mainColor
    end
end

function UIMenuItem:HighlightColor(color)
    if color then
        assert(color() == "SColor", "Color must be SColor type")
        self._highlightColor = color
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._highlightColor
    end
end

function UIMenuItem:Label(Text)
    if tostring(Text) and Text ~= nil then
        self.label = tostring(Text)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self.label
    end
end

function UIMenuItem:RightLabel(Text)
    if tostring(Text) and Text ~= nil then
        self._rightLabel = tostring(Text)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._rightLabel
    end
end

function UIMenuItem:RightBadge(Badge)
    if tonumber(Badge) then
        self._rightBadge = tonumber(Badge)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._rightBadge
    end
end

function UIMenuItem:LeftBadge(Badge)
    if tonumber(Badge) then
        self._leftBadge = tonumber(Badge)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self._leftBadge
    end
end

function UIMenuItem:CustomRightBadge(txd, txn)
    if item == nil then item = self end
    self._rightBadge = -1
    self.customRightIcon = { TXD = txd, TXN = txn }
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendItemToScaleform(it, true)
    end
    if self.ParentColumn ~= nil then
        local it = IndexOf(self.ParentColumn.Items, self)
        self.ParentColumn:SendItemToScaleform(it, true)
    end
end

function UIMenuItem:CustomLeftBadge(txd, txn)
    if item == nil then item = self end
    self._leftBadge = -1
    self.customLeftIcon = { TXD = txd, TXN = txn }
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendItemToScaleform(it, true)
    end
    if self.ParentColumn ~= nil then
        local it = IndexOf(self.ParentColumn.Items, self)
        self.ParentColumn:SendItemToScaleform(it, true)
    end
end

function UIMenuItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        Panel.ParentItem = self
        self.Panels[#self.Panels + 1] = Panel
    end
end

function UIMenuItem:AddSidePanel(sidePanel)
    sidePanel:SetParentItem(self)
    self.SidePanel = sidePanel
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuItem:RemoveSidePanel()
    self.SidePanel = nil
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendPanelsToItemScaleform(it)
        end
    end
end

function UIMenuItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

function UIMenuItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end

function UIMenuItem:BlinkDescription(bool)
    if bool ~= nil then
        self.blinkDescription = bool
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local it = IndexOf(self.ParentColumn.Items, self)
            self.ParentColumn:SendItemToScaleform(it, true)
        end
    else
        return self.blinkDescription
    end
end
