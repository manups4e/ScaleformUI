SettingsListColumn = setmetatable({}, SettingsListColumn)
SettingsListColumn.__index = SettingsListColumn
SettingsListColumn.__call = function()
    return "Column", "SettingsListColumn"
end

---@class SettingsListColumn
---@field private _label string
---@field private _color SColor
---@field private _isBuilding boolean
---@field private _currentSelection number
---@field private _unfilteredItems table
---@field private _rightLabel string
---@field public Order number
---@field public Parent function
---@field public ParentTab number
---@field public Items table<number, UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem>
---@field public OnIndexChanged fun(index: number)
---@field public AddSettings fun(self: SettingsListColumn, item: SettingsListItem)

function SettingsListColumn.New(label, color, scrollType,_maxItems)
    local handler = PaginationHandler.New()
    handler:ItemsPerPage(_maxItems or 16)
    handler.scrollType = scrollType or MenuScrollingType.CLASSIC
    local _data = {
        _isBuilding = false,
        Type = "settings",
        _label = label or "",
        _color = color or SColor.HUD_Freemode,
        _currentSelection = 0,
        _rightLabel = "",
        scrollingType = scrollType or MenuScrollingType.CLASSIC,
        Pagination = handler,
        Order = 0,
        Parent = nil,
        ParentTab = nil,
        Items = {} --[[@type table<number, UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem>]],
        _unfilteredItems = {} --[[@type table<number, UIMenuItem|UIMenuListItem|UIMenuCheckboxItem|UIMenuSliderItem|UIMenuProgressItem>]],
        OnIndexChanged = function(index)
        end,
        OnSettingItemActivated = function(index)
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
        if value > self.Pagination:MaxItem() or value < self.Pagination:MinItem() then
            self:refreshColumn()
        end
        if self.Parent ~= nil and self.Parent:Visible() then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
                self.Items[self:CurrentSelection()]:Selected(true)
            elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
                if self.Parent:Index() == IndexOf(self.Parent.Tabs, self.ParentTab) and self.Parent:FocusLevel() == 1 then
                    self.Items[self:CurrentSelection()]:Selected(true)
                end
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
            self.Pagination:MinItem(self.Pagination:CurrentPageStartIndex())

            if self.scrollingType == MenuScrollingType.CLASSIC and self.Pagination:TotalPages() > 1 then
                local missingItems = self.Pagination:GetMissingItems()
                if missingItems > 0 then
                    self.Pagination:ScaleformIndex(self.Pagination:GetPageIndexFromMenuIndex(self.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                    self.Pagination.minItem = self.Pagination:CurrentPageStartIndex() - missingItems
                end
            end

            self.Pagination:MaxItem(self.Pagination:CurrentPageEndIndex())
            self:_itemCreation(self.Pagination:CurrentPage(), #self.Items, false)
            local pSubT = self.Parent()
            if pSubT == "PauseMenu" and self.ParentTab.Visible then
                if self.ParentTab.listCol[self.ParentTab:Focus()] == self then
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

    item:MainColor(SColor.HUD_Pause_bg)

    if pSubT == "LobbyMenu" then
        local Type, SubType = item()
        local descLabel = "menu_lobby_desc_{" .. menuIndex .. "}"
        AddTextEntry(descLabel, item:Description())

        if SubType == "UIMenuListItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", before, menuIndex, 1, item.Base._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(),
                table.concat(item.Items, ","),
                item:Index() - 1, item.Base._mainColor:ToArgb(), item.Base._highlightColor:ToArgb(), item.Base._textColor:ToArgb(),
                item.Base._highlightedTextColor:ToArgb())
        elseif SubType == "UIMenuCheckboxItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", before, menuIndex, 2, item.Base._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(), item.CheckBoxStyle,
                item._Checked, item.Base._mainColor:ToArgb(), item.Base._highlightColor:ToArgb(), item.Base._textColor:ToArgb(),
                item.Base._highlightedTextColor:ToArgb())
        elseif SubType == "UIMenuSliderItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", before, menuIndex, 3, item.Base._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(), item._Max,
                item._Multiplier,
                item:Index(), item.Base._mainColor:ToArgb(), item.Base._highlightColor:ToArgb(), item.Base._textColor:ToArgb(),
                item.Base._highlightedTextColor:ToArgb(), item.SliderColor:ToArgb(), item._heritage)
        elseif SubType == "UIMenuProgressItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", before, menuIndex, 4, item.Base._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(), item._Max,
                item._Multiplier,
                item:Index(), item.Base._mainColor:ToArgb(), item.Base._highlightColor:ToArgb(), item.Base._textColor:ToArgb(),
                item.Base._highlightedTextColor:ToArgb(), item.SliderColor:ToArgb())
        elseif SubType == "UIMenuSeparatorItem" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", before, menuIndex, 6, item.Base._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(), item.Jumpable, item.Base._mainColor:ToArgb(),
                item.Base._highlightColor:ToArgb(),
                item.Base._textColor:ToArgb(), item.Base._highlightedTextColor:ToArgb())
        else
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_LEFT_ITEM", before, menuIndex, 0, item._formatLeftLabel,
                descLabel, item:Enabled(), item:BlinkDescription(), item._mainColor:ToArgb(),
                item._highlightColor:ToArgb(), item._textColor:ToArgb(), item._highlightedTextColor:ToArgb())
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", scaleformIndex,
                item._formatRightLabel)
            if item._rightBadge ~= BadgeStyle.NONE then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", scaleformIndex,
                    item._rightBadge)
            end
        end

        if (SubType == "UIMenuItem" and item._leftBadge ~= BadgeStyle.NONE) or (SubType ~= "UIMenuItem" and item.Base._leftBadge ~= BadgeStyle.NONE) then
            if SubType ~= "UIMenuItem" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", scaleformIndex, item.Base._leftBadge)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", scaleformIndex, item.Base._labelFont.FontName, item.Base._labelFont.FontID)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", scaleformIndex, item.Base._rightLabelFont.FontName, item.Base._rightLabelFont.FontID)
            else
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", scaleformIndex, item._leftBadge)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", scaleformIndex, item._labelFont.FontName, item._labelFont.FontID)
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LABEL_FONT", scaleformIndex, item._rightLabelFont.FontName, item._rightLabelFont.FontID)
            end
        end
    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
        local Type, SubType = item()
        local descLabel = "menu_pause_playerTab_{" .. menuIndex .. "}"
        AddTextEntry(descLabel, item:Description())
        if SubType == "UIMenuListItem" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM",
                before, menuIndex, 1, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), table.concat(item.Items, ","), item:Index() - 1,
                item.Base._mainColor:ToArgb(),
                item.Base._highlightColor:ToArgb(), item.Base._textColor:ToArgb(), item.Base._highlightedTextColor:ToArgb())
        elseif SubType == "UIMenuCheckboxItem" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM",
                before, menuIndex, 2, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), item.CheckBoxStyle, item._Checked, item.Base._mainColor:ToArgb(),
                item.Base._highlightColor:ToArgb(), item.Base._textColor:ToArgb(), item.Base._highlightedTextColor:ToArgb())
        elseif SubType == "UIMenuSliderItem" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM",
                before, menuIndex, 3, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), item._Max, item._Multiplier, item:Index(), item.Base._mainColor:ToArgb(),
                item.Base._highlightColor:ToArgb(), item.Base._textColor:ToArgb(), item.Base._highlightedTextColor:ToArgb(),
                item.SliderColor:ToArgb(), item._heritage)
        elseif SubType == "UIMenuProgressItem" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM",
                before, menuIndex, 4, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), item._Max, item._Multiplier, item:Index(), item.Base._mainColor:ToArgb(),
                item.Base._highlightColor:ToArgb(), item.Base._textColor:ToArgb(), item.Base._highlightedTextColor:ToArgb(),
                item.SliderColor:ToArgb())
        elseif SubType == "UIMenuSeparatorItem" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM",
                before, menuIndex, 6, item.Base._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), item.Jumpable, item.Base._mainColor:ToArgb(),
                item.Base._highlightColor:ToArgb(), item.Base._textColor:ToArgb(), item.Base._highlightedTextColor:ToArgb(),
                item.SliderColor:ToArgb())
        else
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_SETTINGS_ITEM",
                before, menuIndex, 0, item._formatLeftLabel, descLabel, item:Enabled(),
                item:BlinkDescription(), item._mainColor:ToArgb(), item._highlightColor:ToArgb(), item._textColor:ToArgb(),
                item._highlightedTextColor:ToArgb())
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", scaleformIndex, item._formatRightLabel)
            if item._rightBadge ~= BadgeStyle.NONE then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", scaleformIndex, item._rightBadge)
            end
        end
        if (SubType == "UIMenuItem" and item._leftBadge ~= BadgeStyle.NONE) or (SubType ~= "UIMenuItem" and item.Base._leftBadge ~= BadgeStyle.NONE) then
            if SubType ~= "UIMenuItem" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", scaleformIndex, item.Base._leftBadge)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", scaleformIndex, item.Base._labelFont.FontName, item.Base._labelFont.FontID)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", scaleformIndex, item.Base._labelFont.FontName, item.Base._labelFont.FontID)
            else
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", scaleformIndex, item._leftBadge)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LABEL_FONT", scaleformIndex, item._labelFont.FontName, item._labelFont.FontID)
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_LABEL_FONT", scaleformIndex, item._labelFont.FontName, item._labelFont.FontID)
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
                        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", 8, self._delay) --[[@as number]]
                    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", 8, self._delay) --[[@as number]]
                    end
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_SETTINGS_COLUMN") --[[@as number]]
                elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN") --[[@as number]]
                end
                local max = self.Pagination:ItemsPerPage()
                for i=1, max, 1 do
                    if not self.Parent:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
                end
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 6 or (self.Items[self:CurrentSelection()].ItemId == 6 and not self.Items[self:CurrentSelection()].Jumpable)
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
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
                        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_INPUT_EVENT", 9, self._delay) --[[@as number]]
                    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_INPUT_EVENT", 9, self._delay) --[[@as number]]
                    end
            elseif self.scrollingType == MenuScrollingType.PAGINATED or (self.scrollingType == MenuScrollingType.CLASSIC and overflow) then
                local pSubT = self.Parent()
                if pSubT == "LobbyMenu" then
                    ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_SETTINGS_COLUMN") --[[@as number]]
                elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN") --[[@as number]]
                end
                local max = self.Pagination:ItemsPerPage()
                for i=1, max, 1 do
                    if not self.Parent:Visible() then return end
                    self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
                end
            end
        end
    until self.Items[self:CurrentSelection()].ItemId ~= 6 or (self.Items[self:CurrentSelection()].ItemId == 6 and not self.Items[self:CurrentSelection()].Jumpable)
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
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
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABELS", self.Pagination:GetScaleformIndex(index), leftLabel, rightLabel)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABELS", self.Pagination:GetScaleformIndex(index), self._label, self._rightLabel)
        end
    end
end

function SettingsListColumn:UpdateItemBlinkDescription(index, blink)
    if blink == 1 then blink = true elseif blink == 0 then blink = false end
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_BLINK_DESC", self.Pagination:GetScaleformIndex(index), blink)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_BLINK_DESC", self.Pagination:GetScaleformIndex(index), self._label, self._rightLabel)
        end
    end
end

function SettingsListColumn:UpdateItemLabel(index, label)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        self._label = label;
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL", self.Pagination:GetScaleformIndex(index), label)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL", self.Pagination:GetScaleformIndex(index), self._label)
        end
    end
end

function SettingsListColumn:UpdateItemRightLabel(index, label)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        self._rightLabel = label;
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("UPDATE_SETTINGS_ITEM_LABEL_RIGHT", self.Pagination:GetScaleformIndex(index), label)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("UPDATE_PLAYERS_TAB_SETTINGS_ITEM_LABEL_RIGHT", self.Pagination:GetScaleformIndex(index), self._rightLabel)
        end
    end
end

function SettingsListColumn:UpdateItemLeftBadge(index, badge)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_LEFT_BADGE", self.Pagination:GetScaleformIndex(index), badge)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_LEFT_BADGE", self.Pagination:GetScaleformIndex(index), badge)
        end
    end
end

function SettingsListColumn:UpdateItemRightBadge(index, badge)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_ITEM_RIGHT_BADGE", self.Pagination:GetScaleformIndex(index),
                badge)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_ITEM_RIGHT_BADGE", self.Pagination:GetScaleformIndex(index), badge)
        end
    end
end

function SettingsListColumn:EnableItem(index, enable)
    if self.Parent ~= nil then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ENABLE_SETTINGS_ITEM", self.Pagination:GetScaleformIndex(index), enable)
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ENABLE_PLAYERS_TAB_SETTINGS_ITEM", self.Pagination:GetScaleformIndex(index), enable)
        end
    end
end

function SettingsListColumn:Clear()
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_SETTINGS_COLUMN")
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN")
        end
    end
    self.Items = {}
    self.Pagination:Reset()
end

function SettingsListColumn:SortSettings(compare)
    self.Items[self:CurrentSelection()]:Selected(false)
    if self._unfilteredItems == nil or #self._unfilteredItems == 0 then
        for i, item in ipairs(self.Items) do
            table.insert(self._unfilteredItems, item)
        end
    end
    self:Clear()
    local list = self._unfilteredItems
    table.sort(list, compare)
    self.Items = list
    self.Pagination:TotalItems(#self.Items)
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            self.Parent:buildSettings()
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            self.Parent:buildSettings(self.Parent.Tabs[self.ParentTab])
        end
    end
end

function SettingsListColumn:FilterSettings(predicate)
    self.Items[self:CurrentSelection()]:Selected(false)
    if self._unfilteredItems == nil or #self._unfilteredItems == 0 then
        for i, item in ipairs(self.Items) do
            table.insert(self._unfilteredItems, item)
        end
    end
    self:Clear()
    local filteredItems = {}
    for i, item in ipairs(self._unfilteredItems) do
        if predicate(item) then
            table.insert(filteredItems, item)
        end
    end
    self.Items = filteredItems
    self.Pagination:TotalItems(#self.Items)
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            self.Parent:buildSettings()
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            self.Parent:buildSettings(self.Parent.Tabs[self.ParentTab])
        end
    end
end

function SettingsListColumn:ResetFilter()
    if self._unfilteredItems ~= nil and #self._unfilteredItems > 0 then
        self.Items[self:CurrentSelection()]:Selected(false)
        self:Clear()
        self.Items = self._unfilteredItems
        self.Pagination:TotalItems(#self.Items)
        if self.Parent ~= nil and self.Parent:Visible() then
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                self.Parent:buildSettings()
            elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
                self.Parent:buildSettings(self.Parent.Tabs[self.ParentTab])
            end
        end
    end
end

function SettingsListColumn:refreshColumn()
    local pSubT = self.Parent()
    if pSubT == "LobbyMenu" then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_SETTINGS_COLUMN")
    elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_SETTINGS_COLUMN")
    end
    if #self.Items > 0 then
        self._isBuilding = true
        local max = self.Pagination:ItemsPerPage()
        if #self.Items < max then
            max = #self.Items
        end
        self.Pagination:MinItem(self.Pagination:CurrentPageStartIndex())

        if self.scrollingType == MenuScrollingType.CLASSIC and self.Pagination:TotalPages() > 1 then
            local missingItems = self.Pagination:GetMissingItems()
            if missingItems > 0 then
                self.Pagination:ScaleformIndex(self.Pagination:GetPageIndexFromMenuIndex(self.Pagination:CurrentPageEndIndex()) + missingItems - 1)
                self.Pagination.minItem = self.Pagination:CurrentPageStartIndex() - missingItems
            end
        end

        self.Pagination:MaxItem(self.Pagination:CurrentPageEndIndex())

        for i=1, max, 1 do
            if not self.Parent:Visible() then return end
            self:_itemCreation(self.Pagination:CurrentPage(), i, false, true)
        end
        self.Pagination:ScaleformIndex(self.Pagination:GetScaleformIndex(self:CurrentSelection()))
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_SETTINGS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
        elseif pSubT == "PauseMenu" and self.ParentTab.Visible then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_SELECTION", self.Pagination:ScaleformIndex()) --[[@as number]]
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_SETTINGS_QTTY", self:CurrentSelection(), #self.Items) --[[@as number]]
        end
        self._isBuilding = false
    end
end