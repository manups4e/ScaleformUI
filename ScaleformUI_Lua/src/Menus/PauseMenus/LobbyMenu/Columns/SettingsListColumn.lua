SettingsListColumn = setmetatable({}, SettingsListColumn)
SettingsListColumn.__index = SettingsListColumn
SettingsListColumn.__call = function()
    return "Column", "SettingsListColumn"
end

---@class SettingsListColumn
---@field private _label string
---@field private _color number
---@field private _currentSelection number
---@field private _rightLabel string
---@field public Order number
---@field public Parent function
---@field public ParentTab number
---@field public Items table<number, UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem>
---@field public OnIndexChanged fun(index: number)
---@field public AddSettings fun(self: SettingsListColumn, item: SettingsListItem)

function SettingsListColumn.New(label, color, scrollType)
    local handler = PaginationHandler.New()
    handler:ItemsPerPage(12)
    handler.scrollType = scrollType or MenuScrollingType.CLASSIC
    local _data = {
        _isBuilding = false,
        Type = "settings",
        _label = label or "",
        _color = color or 116,
        _currentSelection = 0,
        _rightLabel = "",
        scrollingType = scrollType or MenuScrollingType.CLASSIC,
        Pagination = handler,
        Order = 0,
        Parent = nil,
        ParentTab = 0,
        Items = {} --[[@type table<number, UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem>]],
        OnIndexChanged = function(index)
        end
    }
    return setmetatable(_data, SettingsListColumn)
end

function SettingsListColumn:ScrollingType(type)
    if type == nil then
        return self.scrollingType
    else
        self.scrollingType = type
    end
end

function SettingsListColumn:CurrentSelection(value)
    if value == nil then
        return self.Pagination:CurrentMenuIndex()
    else
        if value < 1 then
            self.Pagination:CurrentMenuIndex(1)
        elseif value > #self.Items then
            self.Pagination:CurrentMenuIndex(#self.Items)
        end
        self.Items[self:CurrentSelection()]:Selected(false)
        self.Pagination:CurrentMenuIndex(value);
        self.Pagination:CurrentPage(self.Pagination:GetPage(self.Pagination:CurrentMenuIndex()));
        self.Pagination:CurrentPageIndex(value);
        self.Pagination:ScaleformIndex(self.Pagination:GetScaleformIndex(self.Pagination:CurrentMenuIndex()));
        self.Items[self:CurrentSelection()]:Selected(true)
        if self.Parent ~= nil and self.Parent:Visible() then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", false, self.Pagination:ScaleformIndex()) --[[@as number]]
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_QTTY", false, self:CurrentSelection(), #self.Items) --[[@as number]]
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", false, self.ParentTab, self.Pagination:ScaleformIndex()) --[[@as number]]
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", false, self.ParentTab, self:CurrentSelection(), #self.Items) --[[@as number]]
            end
        end
    end
end

---Add a new item to the column.
---@param item UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem
function SettingsListColumn:AddSettings(item)
    local a,b = item()
    if b == "UIMenuItem" then
        item.ParentColumn = self
    else
        item.Base.ParentColumn = self
    end
    self.Items[#self.Items + 1] = item
    self.Pagination:TotalItems(#self.Items)
    if self.Parent ~= nil and self.Parent:Visible() then
        if self.Pagination:TotalItems() < self.Pagination:ItemsPerPage() then
            local sel = self:CurrentSelection()
            self:_itemCreation(0, #self.Items, false)
            local pSubT = self.Parent()
            if pSubT == "PauseMenu" then
                if self.Parent.Tabs[self.ParentTab+1].listCol[self.Parent.Tabs[self.ParentTab+1]:Focus()] == self then
                    self:CurrentSelection(sel)
                end
            end
        end
    end
end

function SettingsListColumn:_itemCreation(page, pageIndex, before, overflow)
    local menuIndex = self.Pagination:GetMenuIndexFromPageIndex(page, pageIndex)
    if not before then
        if self.Pagination:GetPageItemsCount(page) < self.Pagination:ItemsPerPage() and self.Pagination:TotalPages() > 1 then
            if self.scrollingType == MenuScrollingType.ENDLESS then
                if menuIndex > #self.Items then
                    menuIndex = menuIndex - #self.Items
                    self.Pagination:MaxItem(menuIndex)
                end
            elseif self.scrollingType == MenuScrollingType.CLASSIC and overflow then
                local missingItems = self.Pagination:ItemsPerPage() - self.Pagination:GetPageItemsCount(page)
                menuIndex = menuIndex - missingItems
            elseif self.scrollingType == MenuScrollingType.PAGINATED then
                if menuIndex > #self.Items then return end
            end
        end
    end

    local scaleformIndex = self.Pagination:GetScaleformIndex(menuIndex)
    local item = self.Items[menuIndex]
    local pSubT = self.Parent()

    if pSubT == "LobbyMenu" then
        local Type, SubType = item()
        local descLabel = "menu_lobby_desc_{" .. menuIndex .. "}"
        AddTextEntry(descLabel, item:Description())

        if SubType == "UIMenuListItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, before, menuIndex, 1, item.Base._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(),
                table.concat(item.Items, ","),
                item:Index() - 1, item.Base._mainColor, item.Base._highlightColor, item.Base._textColor,
                item.Base._highlightedTextColor)
        elseif SubType == "UIMenuCheckboxItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, before, menuIndex, 2, item.Base._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(), item.CheckBoxStyle,
                item._Checked, item.Base._mainColor, item.Base._highlightColor, item.Base._textColor,
                item.Base._highlightedTextColor)
        elseif SubType == "UIMenuSliderItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, before, menuIndex, 3, item.Base._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(), item._Max,
                item._Multiplier,
                item:Index(), item.Base._mainColor, item.Base._highlightColor, item.Base._textColor,
                item.Base._highlightedTextColor, item.SliderColor, item._heritage)
        elseif SubType == "UIMenuProgressItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, before, menuIndex, 4, item.Base._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(), item._Max,
                item._Multiplier,
                item:Index(), item.Base._mainColor, item.Base._highlightColor, item.Base._textColor,
                item.Base._highlightedTextColor, item.SliderColor)
        elseif SubType == "UIMenuSeparatorItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, before, menuIndex, 6, item.Base._formatLeftLabel,
                textEntry,
                item:Enabled(), item:BlinkDescription(), item.Jumpable, item.Base._mainColor,
                item.Base._highlightColor,
                item.Base._textColor, item.Base._highlightedTextColor)
        else
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", false, before, menuIndex, 0, item._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(), item._mainColor,
                item._highlightColor, item._textColor, item._highlightedTextColor)
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", false, scaleformIndex,
                item._formatRightLabel)
            if item._rightBadge ~= BadgeStyle.NONE then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", false, scaleformIndex,
                    item._rightBadge)
            end
        end
    
        if (SubType == "UIMenuItem" and item._leftBadge ~= BadgeStyle.NONE) or (SubType ~= "UIMenuItem" and item.Base._leftBadge ~= BadgeStyle.NONE) then
            if SubType ~= "UIMenuItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", false, scaleformIndex, item.Base._leftBadge)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", false, scaleformIndex, item.Base._labelFont.FontName, item.Base._labelFont.FontID)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", false, scaleformIndex, item.Base._rightLabelFont.FontName, item.Base._rightLabelFont.FontID)
            else
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", false, scaleformIndex, item._leftBadge)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", false, scaleformIndex, item._labelFont.FontName, item._labelFont.FontID)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", false, scaleformIndex, item._rightLabelFont.FontName, item._rightLabelFont.FontID)
            end
        end
    elseif pSubT == "PauseMenu" then
        local Type, SubType = item()
        local descLabel = "menu_pause_playerTab_{".. self.ParentTab .."}_{" .. menuIndex .. "}"
        AddTextEntry(descLabel, item:Description())
        if SubType == "UIMenuListItem" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                self.ParentTab, before, menuIndex, 1, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), table.concat(item.Items, ","), item:Index() - 1,
                item.Base._mainColor,
                item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor)
        elseif SubType == "UIMenuCheckboxItem" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                self.ParentTab, before, menuIndex, 2, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), item.CheckBoxStyle, item._Checked, item.Base._mainColor,
                item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor)
        elseif SubType == "UIMenuSliderItem" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                self.ParentTab, before, menuIndex, 3, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), item._Max, item._Multiplier, item:Index(), item.Base._mainColor,
                item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor,
                item.SliderColor, item._heritage)
        elseif SubType == "UIMenuProgressItem" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                self.ParentTab, before, menuIndex, 4, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), item._Max, item._Multiplier, item:Index(), item.Base._mainColor,
                item.Base._highlightColor, item.Base._textColor, item.Base._highlightedTextColor,
                item.SliderColor)
        else
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM", false,
                self.ParentTab, before, menuIndex, 0, item._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), item._mainColor, item._highlightColor, item._textColor,
                item._highlightedTextColor)
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", false, self.ParentTab, scaleformIndex, item._formatRightLabel)
            if item._rightBadge ~= BadgeStyle.NONE then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", false, self.ParentTab, scaleformIndex, item._rightBadge)
            end
        end
        if (SubType == "UIMenuItem" and item._leftBadge ~= BadgeStyle.NONE) or (SubType ~= "UIMenuItem" and item.Base._leftBadge ~= BadgeStyle.NONE) then
            if SubType ~= "UIMenuItem" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", false, self.ParentTab, scaleformIndex, item.Base._leftBadge)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", false, self.ParentTab, scaleformIndex, item.Base._labelFont.FontName, item.Base._labelFont.FontID)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", false, self.ParentTab, scaleformIndex, item.Base._labelFont.FontName, item.Base._labelFont.FontID)
            else
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", false, self.ParentTab, scaleformIndex, item._leftBadge)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", false, self.ParentTab, scaleformIndex, item._labelFont.FontName, item._labelFont.FontID)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", false, self.ParentTab, scaleformIndex, item._labelFont.FontName, item._labelFont.FontID)
            end
        end
    end
end

function SettingsListColumn:GoUp()
    self.Items[self:CurrentSelection()]:Selected(false)
    repeat
        Citizen.Wait(0)
        local overflow = self:CurrentSelection() == 1 and self.Pagination:TotalPages() > 1
        if self.Pagination:GoUp() then
            if self.scrollingType == MenuScrollingType.ENDLESS or (self.scrollingType == MenuScrollingType.CLASSIC and not overflow) then
                self:_itemCreation(self.Pagination:GetPage(self:CurrentSelection()), self.Pagination:CurrentPageIndex(), true, false)
                    local pSubT = self.Parent()
                    if pSubT == "LobbyMenu" then
                        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", false, 8, self._delay) --[[@as number]]
                    elseif pSubT == "PauseMenu" then
                        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", false, 8, self._delay) --[[@as number]]
                    end
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_SETTINGS_COLUMN", false) --[[@as number]]
                elseif pSubT == "PauseMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN", false, self.ParentTab) --[[@as number]]
                end
                local i = 1
                local max = self.Pagination:ItemsPerPage()
                while i <= max do
                    Citizen.Wait(0)
                    if not self:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
                    i = i + 1
                end
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 6 or (self.Items[self:CurrentSelection()].ItemId == 6 and not self.Items[self:CurrentSelection()].Jumpable)
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", false, self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_QTTY", false, self:CurrentSelection(), #self.Items) --[[@as number]]
    elseif pSubT == "PauseMenu" then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", false, self.ParentTab, self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", false, self.ParentTab, self:CurrentSelection(), #self.Items) --[[@as number]]
    end
    self.Items[self:CurrentSelection()]:Selected(true)
    self.OnIndexChanged(self:CurrentSelection())
end

function SettingsListColumn:GoDown()
    self.Items[self:CurrentSelection()]:Selected(false)
    repeat
        Citizen.Wait(0)
        local overflow = self:CurrentSelection() == #self.Items and self.Pagination:TotalPages() > 1
        if self.Pagination:GoDown() then
            if self.scrollingType == MenuScrollingType.ENDLESS or (self.scrollingType == MenuScrollingType.CLASSIC and not overflow) then
                self:_itemCreation(self.Pagination:GetPage(self:CurrentSelection()), self.Pagination:CurrentPageIndex(), false, false)
                    local pSubT = self.Parent()
                    if pSubT == "LobbyMenu" then
                        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", false, 9, self._delay) --[[@as number]]
                    elseif pSubT == "PauseMenu" then
                        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", false, 9, self._delay) --[[@as number]]
                    end
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_SETTINGS_COLUMN", false) --[[@as number]]
                elseif pSubT == "PauseMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN", false, self.ParentTab) --[[@as number]]
                end
                local i = 1
                local max = self.Pagination:ItemsPerPage()
                while i <= max do
                    Citizen.Wait(0)
                    if not self:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
                    i = i + 1
                end
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 6 or (self.Items[self:CurrentSelection()].ItemId == 6 and not self.Items[self:CurrentSelection()].Jumpable)
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", false, self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_QTTY", false, self:CurrentSelection(), #self.Items) --[[@as number]]
    elseif pSubT == "PauseMenu" then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", false, self.ParentTab, self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", false, self.ParentTab, self:CurrentSelection(), #self.Items) --[[@as number]]
    end
    self.Items[self:CurrentSelection()]:Selected(true)
    self.OnIndexChanged(self:CurrentSelection())
end

function SettingsListColumn:UpdateItemLabels(index, leftLabel, rightLabel)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        self._label = leftLabel;
        self._rightLabel = rightLabel;
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABELS", false, self.Pagination:GetScaleformIndex(index), leftLabel, rightLabel)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABELS", false, self.ParentTab, self.Pagination:GetScaleformIndex(index), self._label, self._rightLabel)
        end
    end
end

function SettingsListColumn:UpdateItemBlinkDescription(index, blink)
    if blink == 1 then blink = true elseif blink == 0 then blink = false end
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_BLINK_DESC", false, self.Pagination:GetScaleformIndex(index), blink)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_BLINK_DESC", false, self.ParentTab, self.Pagination:GetScaleformIndex(index), self._label, self._rightLabel)
        end
    end
end

function SettingsListColumn:UpdateItemLabel(index, label)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        self._label = label;
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL", false, self.Pagination:GetScaleformIndex(index), label)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL", false, self.ParentTab, self.Pagination:GetScaleformIndex(index), self._label)
        end
    end
end

function SettingsListColumn:UpdateItemRightLabel(index, label)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        self._rightLabel = label;
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", false, self.Pagination:GetScaleformIndex(index), label)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", false, self.ParentTab, self.Pagination:GetScaleformIndex(index), self._rightLabel)
        end
    end
end

function SettingsListColumn:UpdateItemLeftBadge(index, badge)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", false, self.Pagination:GetScaleformIndex(index), badge)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", false, self.ParentTab, self.Pagination:GetScaleformIndex(index), badge)
        end
    end
end

function SettingsListColumn:UpdateItemRightBadge(index, badge)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", false, self.Pagination:GetScaleformIndex(index),
                badge)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", false, self.ParentTab, self.Pagination:GetScaleformIndex(index), badge)
        end
    end
end

function SettingsListColumn:EnableItem(index, enable)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ENABLE_SETTINGS_ITEM", false, self.Pagination:GetScaleformIndex(index), enable)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_PLAYERS_TAB_SETTINGS_ITEM", false, self.ParentTab, self.Pagination:GetScaleformIndex(index), enable)
        end
    end
end

function SettingsListColumn:Clear()
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_SETTINGS_COLUMN", false)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN", false, self.ParentTab)
        end
    end
    self.Items = {}
    self.Pagination:Reset()
end
