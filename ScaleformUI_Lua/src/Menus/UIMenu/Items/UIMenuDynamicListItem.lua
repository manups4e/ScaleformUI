UIMenuDynamicListItem = setmetatable({}, UIMenuDynamicListItem)
UIMenuDynamicListItem.__index = UIMenuDynamicListItem
UIMenuDynamicListItem.__call = function() return "UIMenuItem", "UIMenuDynamicListItem" end

---@class UIMenuDynamicListItem : UIMenuItem
---@field Base UIMenuItem
---@field Panels table
---@field SidePanel table
---@field _currentItem string
---@field Callback function
---@field ItemId number
---@field OnListSelected function

---New
---@param Text string
---@param Description string
---@param StartingItem string
---@param callback function
---@param color SColor
---@param highlightColor SColor
function UIMenuDynamicListItem.New(Text, Description, StartingItem, callback, color, highlightColor)
    local _UIMenuDynamicListItem = {
        Base = UIMenuItem.New(Text or "", Description or "", color or SColor.HUD_Panel_light, highlightColor or SColor.HUD_White),
        Panels = {},
        SidePanel = nil,
        _currentItem = StartingItem,
        Callback = callback,
        ItemId = 1,
        OnListSelected = function(menu, item, newindex)
        end,
    }
    return setmetatable(_UIMenuDynamicListItem, UIMenuDynamicListItem)
end

function UIMenuDynamicListItem:ItemData(data)
    if data == nil then
        return self.Base:ItemData(data)
    else
        self.Base:ItemData()
    end
end

-- not supported on Lobby and Pause menu yet
function UIMenuDynamicListItem:LabelFont(itemFont)
    if itemFont == nil then
        return self.Base:LabelFont()
    end
    self.Base:LabelFont(itemFont, self)
end

-- not supported on Lobby and Pause menu yet
function UIMenuDynamicListItem:RightLabelFont(itemFont)
    if itemFont == nil then
        return self.Base:RightLabelFont()
    end
    self.Base:RightLabelFont(itemFont, self)
end

---Set the Parent Menu of the Item
---@param menu UIMenu
---@return UIMenu? -- returns the parent menu if no menu is passed, if a menu is passed it returns the menu if it was set successfully
function UIMenuDynamicListItem:SetParentMenu(menu)
    if menu == nil then
        return self.Base:SetParentMenu()
    end
    self.Base:SetParentMenu(menu)
end

function UIMenuDynamicListItem:Selected(bool)
    if bool == nil then
        return self.Base:Selected()
    end
    self.Base:Selected(bool, self)
end

function UIMenuDynamicListItem:Hovered(bool)
    if bool == nil then
        return self.Base:Hovered()
    end
    self.Base:Hovered(bool)
end

function UIMenuDynamicListItem:Enabled(bool)
    if bool == nil then
        return self.Base:Enabled()
    end
    self.Base:Hovered(bool, self)
end

function UIMenuDynamicListItem:Description(str)
    if str == nil then
        return self.Base:Description()
    end
    self.Base:Description(str, self)
end

function UIMenuDynamicListItem:MainColor(color)
    if color == nil then
        return self.Base:MainColor()
    end
    self.Base:MainColor(color, self)
end

function UIMenuDynamicListItem:HighlightColor(color)
    if color == nil then
        return self.Base:HighlightColor()
    end
    self.Base:HighlightColor(color, self)
end

function UIMenuDynamicListItem:Label(Text)
    if Text == nil then
        return self.Base:Label()
    end
    self.Base:Label(Text, self)
end

function UIMenuDynamicListItem:BlinkDescription(bool)
    if bool == nil then
        return self.Base:BlinkDescription()
    end
    self.Base:BlinkDescription(bool, self)
end

function UIMenuDynamicListItem:LeftBadge(Badge)
    if Badge == nil then
        return self.Base:LeftBadge()
    end
    self.Base:LeftBadge(Badge, self)
end

function UIMenuDynamicListItem:CustomLeftBadge(txd,txn)
    self.Base:CustomLeftBadge(txd,txn, self)
end

---RightBadge
function UIMenuDynamicListItem:RightBadge()
    error("This item does not support right badges")
end

function UIMenuDynamicListItem:CustomRightBadge()
    error("This item does not support right badges")
end

---RightLabel
function UIMenuDynamicListItem:RightLabel()
    error("This item does not support a right label")
end

---AddPanel
---@param Panel table
function UIMenuDynamicListItem:AddPanel(Panel)
    if Panel() == "UIMenuPanel" then
        self.Panels[#self.Panels + 1] = Panel
        Panel:SetParentItem(self)
    end
end

---RemovePanelAt
---@param Index number
function UIMenuDynamicListItem:RemovePanelAt(Index)
    if tonumber(Index) then
        if self.Panels[Index] then
            table.remove(self.Panels, tonumber(Index))
        end
    end
end

---FindPanelIndex
---@param Panel table
function UIMenuDynamicListItem:FindPanelIndex(Panel)
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
function UIMenuDynamicListItem:FindPanelItem()
    for Index = #self.Items, 1, -1 do
        if self.Items[Index].Panel then
            return Index
        end
    end
    return nil
end

function UIMenuDynamicListItem:CurrentListItem(item, _item)
    if item == nil then
        return tostring(self._currentItem)
    else
        self._currentItem = item
        if _item == nil then _item = self end
        local str = self:createListString()
        if self.Base.ParentMenu ~= nil and self.Base.ParentMenu:Visible() then
            local it = IndexOf(self.Base.ParentMenu.Items, _item)
            self.Base.ParentMenu:SendItemToScaleform(it, true)
        end
        if self.Base.ParentColumn ~= nil then
            local pSubT = self.Base.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_LISTITEM_LIST", self.Base.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentColumn.Items, self)), str, self._Index - 1)
            elseif pSubT == "PauseMenu" and self.Base.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_LISTITEM_LIST", self.Base.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.Base.ParentColumn.Items, self)), str, self._Index - 1)
            end
        end
    end
end

function UIMenuDynamicListItem:createListString()
    local list = {}
    local value = self._currentItem
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