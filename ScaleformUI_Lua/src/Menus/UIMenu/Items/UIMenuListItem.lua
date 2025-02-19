UIMenuListItem = setmetatable({}, UIMenuListItem)
UIMenuListItem.__index = UIMenuListItem
UIMenuListItem.__call = function() return "UIMenuItem", "UIMenuListItem" end

---@class UIMenuListItem : UIMenuItem
---@field public Base UIMenuItem
---@field public AddPanel fun(self:UIMenuListItem, item:UIMenuStatisticsPanel|UIMenuPercentagePanel|UIMenuColorPanel|UIMenuGridPanel):nil

---New
---@param Text string
---@param Items table
---@param Index number
---@param Description string
function UIMenuListItem.New(Text, Items, Index, Description, color, highlightColor)
    if type(Items) ~= "table" then Items = {} end
    if Index == 0 then Index = 1 end
    local _UIMenuListItem = {
        Base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White),
        Items = Items,
        _Index = tonumber(Index) or 1,
        Panels = {},
        SidePanel = nil,
        ItemId = 1,
        OnListChanged = function(menu, item, newindex)
        end,
        OnListSelected = function(menu, item, newindex)
        end,
    }
    return setmetatable(_UIMenuListItem, UIMenuListItem)
end

function UIMenuListItem:ItemData(data)
    if data == nil then
        return self.Base:ItemData(data)
    else
        self.Base:ItemData()
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuListItem:LabelFont(itemFont)
    if itemFont == nil then
        return self.Base:LabelFont()
    end
    self.Base:LabelFont(itemFont, self)
end

-- not supported on Lobby and Pause menu yet
function UIMenuListItem:RightLabelFont(itemFont)
    if itemFont == nil then
        return self.Base:RightLabelFont()
    end
    self.Base:RightLabelFont(itemFont, self)
end

---Set the Parent Menu of the Item
---@param menu UIMenu
---@return UIMenu? -- returns the parent menu if no menu is passed, if a menu is passed it returns the menu if it was set successfully
function UIMenuListItem:SetParentMenu(menu)
    if menu == nil then
        return self.Base:SetParentMenu()
    end
    self.Base:SetParentMenu(menu)
end

function UIMenuListItem:Selected(bool)
    if bool == nil then
        return self.Base:Selected()
    end
    self.Base:Selected(bool, self)
end

function UIMenuListItem:Hovered(bool)
    if bool == nil then
        return self.Base:Hovered()
    end
    self.Base:Hovered(bool)
end

function UIMenuListItem:Enabled(bool)
    if bool == nil then
        return self.Base:Enabled()
    end
    self.Base:Hovered(bool, self)
end

function UIMenuListItem:Description(str)
    if str == nil then
        return self.Base:Description()
    end
    self.Base:Description(str, self)
end

function UIMenuListItem:MainColor(color)
    if color == nil then
        return self.Base:MainColor()
    end
    self.Base:MainColor(color, self)
end

function UIMenuListItem:HighlightColor(color)
    if color == nil then
        return self.Base:HighlightColor()
    end
    self.Base:HighlightColor(color, self)
end

function UIMenuListItem:Label(Text)
    if Text == nil then
        return self.Base:Label()
    end
    self.Base:Label(Text, self)
end

function UIMenuListItem:BlinkDescription(bool)
    if bool == nil then
        return self.Base:BlinkDescription()
    end
    self.Base:BlinkDescription(bool, self)
end

function UIMenuListItem:LeftBadge(Badge)
    if Badge == nil then
        return self.Base:LeftBadge()
    end
    self.Base:LeftBadge(Badge, self)
end

function UIMenuListItem:CustomLeftBadge(txd,txn)
    self.Base:CustomLeftBadge(txd,txn, self)
end

---RightBadge
function UIMenuListItem:RightBadge()
    error("This item does not support right badges")
end

function UIMenuListItem:CustomRightBadge()
    error("This item does not support right badges")
end

---RightLabel
function UIMenuListItem:RightLabel()
    error("This item does not support a right label")
end

---AddPanel
---@param panel UIMenuStatisticsPanel|UIMenuPercentagePanel|UIMenuColorPanel|UIMenuGridPanel
function UIMenuListItem:AddPanel(panel)
    if panel() == "UIMenuPanel" then
        panel.ParentItem = self
        self.Panels[#self.Panels + 1] = panel
    end
end

---RemovePanelAt
---@param Index table
function UIMenuListItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
        end
    end
end

---FindPanelIndex
---@param Panel table
function UIMenuListItem:FindPanelIndex(Panel)
    if Panel() == "UIMenuPanel" then
        for Index = 1, #self.Panels do
            if self.Panels[Index] == Panel then
                return Index
            end
        end
    end
    return nil
end

---FindPanelItem
function UIMenuListItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end


function UIMenuListItem:AddSidePanel(sidePanel)
    sidePanel:SetParentItem(self)
    self.SidePanel = sidePanel
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMenuListItem:RemoveSidePanel()
    self.SidePanel = nil
    if self.ParentMenu ~= nil and self.ParentMenu:Visible() then
        local it = IndexOf(self.ParentMenu.Items, self)
        self.ParentMenu:SendSidePanelToScaleform(it)
    end
end

---Index
---@param Index number
function UIMenuListItem:Index(Index)
    if tonumber(Index) then
        if Index > #self.Items then
            self._Index = 1
        elseif Index < 1 then
            self._Index = #self.Items
        else
            self._Index = Index
        end
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            local it = IndexOf(self.Base.ParentMenu.Items, self)
            self.Base.ParentMenu:SendItemToScaleform(it, true)
        end
    else
        return self._Index
    end
end

---ItemToIndex
---@param Item table
function UIMenuListItem:ItemToIndex(Item)
    for i = 1, #self.Items do
        if type(Item) == type(self.Items[i]) and Item == self.Items[i] then
            return i
        elseif type(self.Items[i]) == "table" and (type(Item) == type(self.Items[i].Name) or type(Item) == type(self.Items[i].Value)) and (Item == self.Items[i].Name or Item == self.Items[i].Value) then
            return i
        end
    end
end

---IndexToItem
---@param Index number
function UIMenuListItem:IndexToItem(Index)
    if tonumber(Index) then
        if tonumber(Index) == 0 then Index = 1 end
        if self.Items[tonumber(Index)] then
            return self.Items[tonumber(Index)]
        end
    end
end

function UIMenuListItem:ChangeList(list)
    if type(list) ~= "table" then return end
    self.Items = {}
    self.Items = list
    local commaSep = self:createListString()

    if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
        local it = IndexOf(self.Base.ParentMenu.Items, self)
        self.Base.ParentMenu:SendItemToScaleform(it, true)
    end
    if self.Base.ParentColumn ~= nil then
        local pSubT = self.Base.ParentColumn.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_LISTITEM_LIST", self.Base.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentColumn.Items, self)), commaSep, self._Index - 1)
        elseif pSubT == "PauseMenu" and self.Base.ParentColumn.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_LISTITEM_LIST", self.Base.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentColumn.Items, self)), commaSep, self._Index - 1)
        end
    end
end

function UIMenuListItem:createListString()
    local value = tostring(self.Items[self._Index])
    if type(value) ~= "string" then
        value = tostring(v)
    end
    if not self:Enabled() then
        value = ReplaceRstarColorsWith(value, "~c~")
    else
        if not value:StartsWith("~") then
            value = "~s~" .. value
        end
        if self:Selected() then
            value = value:gsub("~w~", "~l~")
            value = value:gsub("~s~", "~l~")
        else
            value = value:gsub("~l~", "~s~")
        end
    end
    return value
end
