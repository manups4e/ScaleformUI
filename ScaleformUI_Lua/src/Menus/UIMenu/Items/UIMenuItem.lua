UIMenuItem = setmetatable({}, UIMenuItem)
UIMenuItem.__index = UIMenuItem
UIMenuItem.__call = function()
    return "UIMenuItem", "UIMenuItem"
end

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
---@field _Selected boolean
---@field _Hovered boolean
---@field _Enabled boolean
---@field blinkDescription boolean
---@field _formatLeftLabel string
---@field _rightLabel string
---@field _formatRightLabel string
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
    local __formatLeftLabel = (tostring(text))
    if not __formatLeftLabel:StartsWith("~") then
        __formatLeftLabel = "~s~" .. __formatLeftLabel
    end

    _UIMenuItem = {
        _label = tostring(text) or "",
        _Description = tostring(description) or "",
        _labelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        _rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        _Selected = false,
        _Hovered = false,
        _Enabled = true,
        blinkDescription = false,
        _formatLeftLabel = __formatLeftLabel or "",
        _rightLabel = "",
        _formatRightLabel = "",
        _rightBadge = 0,
        _leftBadge = 0,
        _mainColor = color or SColor.HUD_Panel_light,
        _highlightColor = highlightColor or SColor.HUD_White,
        _itemData = {},
        ParentMenu = nil,
        ParentColumn = nil,
        Panels = {},
        SidePanel = nil,
        ItemId = 0,
        customLeftIcon = {TXD="",TXN=""},
        customRightIcon = {TXD="",TXN=""},
        Activated = function(menu, item)
        end,
        Highlighted = function(menu, item)
        end,
        OnTabPressed = function(menu)
        end
    }
    return setmetatable(_UIMenuItem, UIMenuItem)
end

function UIMenuItem:ItemData(data, item)
    if data == nil then
        return self._itemData
    else
        self._itemData = data
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuItem:LabelFont(itemFont, item)
    if itemFont == nil then
        return self._labelFont
    else
        self._labelFont = itemFont
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, self)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self)), self._labelFont.FontName, self._labelFont.FontID)
            elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self)), self._labelFont.FontName, self._labelFont.FontID)
            end
        end
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuItem:RightLabelFont(itemFont, item)
    if itemFont == nil then
        return self._rightLabelFont
    else
        if item == nil then item = self end
        self._rightLabelFont = itemFont
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_RIGHT_LABEL_FONT", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self)), self._rightLabelFont.FontName, self._rightLabelFont.FontID)
            elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self)), self._rightLabelFont.FontName, self._rightLabelFont.FontID)
            end
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

function UIMenuItem:Selected(bool, item)
    if bool ~= nil then
        if item == nil then item = self end

        self._Selected = ToBool(bool)
        if self._Selected then
            self._formatLeftLabel = self._formatLeftLabel:gsub("~w~", "~l~")
            self._formatLeftLabel = self._formatLeftLabel:gsub("~s~", "~l~")
            if not string.IsNullOrEmpty(self._formatRightLabel) then
                self._formatRightLabel = self._formatRightLabel:gsub("~w~", "~l~")
                self._formatRightLabel = self._formatRightLabel:gsub("~s~", "~l~")
            end
            self.Highlighted(self.ParentMenu, item)
        else
            self._formatLeftLabel = self._formatLeftLabel:gsub("~l~", "~s~")
            if not string.IsNullOrEmpty(self._formatRightLabel) then
                self._formatRightLabel = self._formatRightLabel:gsub("~l~", "~s~")
            end
        end
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABELS", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._formatLeftLabel, self._formatRightLabel)
            elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABELS", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._formatLeftLabel, self._formatRightLabel)
            end
        end
    else
        return self._Selected
    end
end

function UIMenuItem:Hovered(bool)
    if bool ~= nil then
        self._Hovered = ToBool(bool)
    else
        return self._Hovered
    end
end

function UIMenuItem:Enabled(bool, item)
    if bool ~= nil then
        if item == nil then item = self end
        self._Enabled = ToBool(bool)
        if not self._Enabled then
            self._formatLeftLabel = ReplaceRstarColorsWith(self._formatLeftLabel, "~c~")
            self._formatRightLabel = ReplaceRstarColorsWith(self._formatRightLabel, "~c~")
        else
            self:Label(self._label, item)
            self:RightLabel(self._rightLabel, item)
        end
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABELS", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._formatLeftLabel, self._formatRightLabel)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ENABLE_SETTINGS_ITEM", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._enabled)
            elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABELS", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._formatLeftLabel, self._formatRightLabel)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_PLAYERS_TAB_SETTINGS_ITEM", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._enabled)
            end
        end
    else
        return self._Enabled
    end
end

function UIMenuItem:Description(str, item)
    if tostring(str) and str ~= nil then
        if item == nil then item = self end
        self._Description = tostring(str)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            AddTextEntry("UIMenu_Current_Description", str);
            local it = IndexOf(self.ParentMenu.Items, item)
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

function UIMenuItem:MainColor(color, item)
    if color then
        assert(color() == "SColor", "Color must be SColor type")
        if item == nil then item = self end
        self._mainColor = color
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
    else
        return self._mainColor
    end
end

function UIMenuItem:HighlightColor(color, item)
    if color then
        assert(color() == "SColor", "Color must be SColor type")
        if item == nil then item = self end
        self._highlightColor = color
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
    else
        return self._highlightColor
    end
end

function UIMenuItem:Label(Text, item)
    if tostring(Text) and Text ~= nil then
        if item == nil then item = self end
        self._label = tostring(Text)
        self._formatLeftLabel = tostring(Text)
        if not self._formatLeftLabel:StartsWith("~") then
            self._formatLeftLabel = "~s~" .. self._formatLeftLabel
        end
        if not self:Enabled() then
            self._formatLeftLabel = ReplaceRstarColorsWith(self._formatLeftLabel, "~c~")
        end
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._formatLeftLabel)
            elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._formatLeftLabel)
            end
        end
    else
        return self._label
    end
end

function UIMenuItem:RightLabel(Text, item)
    if tostring(Text) and Text ~= nil then
        if item == nil then item = self end
        self._rightLabel = tostring(Text)
        self._formatRightLabel = tostring(Text)
        if not self._formatRightLabel:StartsWith("~") then
            self._formatRightLabel = "~s~" .. self._formatRightLabel
        end
        if self:Selected() then
            self._formatRightLabel = self._formatRightLabel:gsub("~w~", "~l~")
            self._formatRightLabel = self._formatRightLabel:gsub("~s~", "~l~")
        else
            self._formatRightLabel = self._formatRightLabel:gsub("~l~", "~s~")
        end
        if not self:Enabled() then
            self._formatRightLabel = ReplaceRstarColorsWith(self._formatRightLabel, "~c~")
        end
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self)), self._formatRightLabel)
            elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self)), self._formatRightLabel)
            end
        end
    else
        return self._rightLabel
    end
end

function UIMenuItem:RightBadge(Badge, item)
    if tonumber(Badge) then
        if item == nil then item = self end
        self._rightBadge = tonumber(Badge)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._rightBadge)
            elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._rightBadge)
            end
        end
    else
        return self._rightBadge
    end
end

function UIMenuItem:LeftBadge(Badge, item)
    if tonumber(Badge) then
        if item == nil then item = self end
        self._leftBadge = tonumber(Badge)
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.ParentColumn ~= nil then
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._leftBadge)
            elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), self._leftBadge)
            end
        end
    else
        return self._leftBadge
    end
end

function UIMenuItem:CustomRightBadge(txd,txn, item)
    if item == nil then item = self end
    self._rightBadge = -1
    self.customRightIcon = {TXD=txd, TXN=txn}
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, item)
        self.ParentMenu:SendItemToScaleform(it, true)
    end
if self.ParentColumn ~= nil then
        local pSubT = self.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_CUSTOM_RIGHT_BADGE", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), txd, txn)
        elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_CUSTOM_RIGHT_BADGE", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)), txd, txn)
        end
    end
end

function UIMenuItem:CustomLeftBadge(txd,txn, item)
    if item == nil then item = self end
    self._leftBadge = -1
    self.customLeftIcon = {TXD=txd, TXN=txn}
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, item)
        self.ParentMenu:SendItemToScaleform(it, true)
    end
if self.ParentColumn ~= nil then
        local pSubT = self.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_CUSTOM_LEFT_BADGE", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)),  txd, txn)
        elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_CUSTOM_LEFT_BADGE", self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, item)),  txd, txn)
        end
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

function UIMenuItem:BlinkDescription(bool, item)
    if bool ~= nil then
        if item == nil then item = self end
        self.blinkDescription = bool
        if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
            local it = IndexOf(self.ParentMenu.Items, item)
            self.ParentMenu:SendItemToScaleform(it, true)
        end
    else
        return self.blinkDescription
    end
end