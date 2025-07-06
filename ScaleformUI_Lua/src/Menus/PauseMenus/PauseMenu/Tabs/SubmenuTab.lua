SubmenuTab = {}
SubmenuTab.__index = SubmenuTab
setmetatable(SubmenuTab, { __index = BaseTab })
SubmenuTab.__call = function() return "SubmenuTab" end

---@class SubmenuTab
function SubmenuTab.New(name, color)
    local data = BaseTab.New(name, color)
    data._identifier = "Page_Info"
    data.LeftColumn = SubmenuLeftColumn.New(0)
    data.CenterColumn = SubmenuCentralColumn.New(1)
    local meta = setmetatable(data, SubmenuTab)
    meta.LeftColumn.Parent = meta
    meta.CenterColumn.Parent = meta
    return meta
end

function SubmenuTab:currentItemType()
    return self.LeftColumn:currentItemType()
end

function SubmenuTab:SwitchColumn(index)
    local col = self:GetColumnAtPosition(index)
    self.CurrentColumnIndex = index
    if self.Parent ~= nil and self.Parent:Visible() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_MENU_LEVEL", self.CurrentColumnIndex + 1)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("MENU_SHIFT_DEPTH", 0, true, true)
        self.Parent.focusLevel = self.CurrentColumnIndex + 1
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_HIGHLIGHT", col.position, col:Index(), true, true)
        col.Items[col:Index()]:Selected(true)
    end
end

function SubmenuTab:AddLeftItem(item)
    item.ParentTab = self
    self.LeftColumn:AddItem(item)
end

function SubmenuTab:StateChange(state)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("MENU_STATE", self:currentItemType())
    self.CenterColumn:Clear()
    if state ~= 0 then
        for k,v in ipairs(self.LeftColumn.Items[self.LeftColumn:Index()].ItemList) do
            self.CenterColumn:AddItem(v)
        end
    end
    for k,v in pairs(self.CenterColumn.Items) do
        v.ParentColumn = self.CenterColumn
    end
    if self:currentItemType() == LeftItemType.Statistics then
        self.CenterColumn.VisibleItems = 16
        self.CenterColumn:InitColumnScroll(true, 2, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER)
        self.CenterColumn:SetColumnScroll(-1,-1,-1,"", #self.CenterColumn.Items<self.CenterColumn.VisibleItems)
    elseif self:currentItemType() == LeftItemType.Settings then
        self.CenterColumn.VisibleItems = 16
        self.CenterColumn:InitColumnScroll(true, 2, ScrollType.ALL, ScrollArrowsPosition.CENTER)
        self.CenterColumn:SetColumnScroll(self.CenterColumn:Index(),#self.CenterColumn.Items,self.CenterColumn.VisibleItems,"", #self.CenterColumn.Items<self.CenterColumn.VisibleItems)
    elseif self:currentItemType() == LeftItemType.Info then
        self.CenterColumn.VisibleItems = 10
        self.CenterColumn:InitColumnScroll(true, 2, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER)
        self.CenterColumn:SetColumnScroll(-1,-1,-1,"", #self.CenterColumn.Items<self.CenterColumn.VisibleItems)
    elseif self:currentItemType() == LeftItemType.Keymap then
        self.CenterColumn.VisibleItems = 15
        self.CenterColumn:InitColumnScroll(true, 2, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER)
        self.CenterColumn:SetColumnScroll(-1,-1,-1,"", #self.CenterColumn.Items<self.CenterColumn.VisibleItems)
    else
        self.CenterColumn.VisibleItems = 0
    end
end

function SubmenuTab:GoUp()
    if not self.Focused then return end
    if self.CurrentColumnIndex == 0 then
        self.LeftColumn:GoUp()
        self.CenterColumn:currentColumnType(self:currentItemType())
        self:StateChange()
        self:Refresh(false)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.CurrentColumnIndex, 8)
    elseif self.CurrentColumnIndex == 1 then
        self.CenterColumn:GoUp()
        if self.CenterColumn:currentColumnType() == LeftItemType.Settings then
            self.CenterColumn:SetColumnScroll(self.CenterColumn:Index(),#self.CenterColumn.Items,self.CenterColumn.VisibleItems,"", #self.CenterColumn.Items<self.CenterColumn.VisibleItems)
        end
    end
end

function SubmenuTab:GoDown()
    if not self.Focused then return end
    if self.CurrentColumnIndex == 0 then
        self.LeftColumn:GoDown()
        self.CenterColumn:currentColumnType(self:currentItemType())
        self:StateChange()
        self:Refresh(false)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.CurrentColumnIndex, 9)
    elseif self.CurrentColumnIndex == 1 then
        self.CenterColumn:GoDown()
        if self.CenterColumn:currentColumnType() == LeftItemType.Settings then
            self.CenterColumn:SetColumnScroll(self.CenterColumn:Index(),#self.CenterColumn.Items,self.CenterColumn.VisibleItems,"", #self.CenterColumn.Items<self.CenterColumn.VisibleItems)
        end
    end
end

function SubmenuTab:GoLeft()
    if not self.Focused then return end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.CurrentColumnIndex, 10)
    if self.CurrentColumnIndex == 1 then
        self.CenterColumn:GoLeft()
    end
end

function SubmenuTab:GoRight()
    if not self.Focused then return end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_INPUT_EVENT", self.CurrentColumnIndex, 11)
    if self.CurrentColumnIndex == 1 then
        self.CenterColumn:GoRight()
    end
end

function SubmenuTab:Select()
    if not self.Focused then return end
    if self.CurrentColumnIndex == 0 then
        if self:currentItemType() ~= LeftItemType.Settings then return end
        local lI = self.LeftColumn.Items[self.LeftColumn:Index()]
        if not lI:Enabled() then
            PlaySoundFrontend(-1, "ERROR","HUD_FRONTEND_DEFAULT_SOUNDSET", false)
            return
        end
        self.CurrentColumnIndex = self.CurrentColumnIndex + 1
        local ret = true
        local idx = 1
        for k,v in pairs(lI.ItemList) do
            if v.Enabled then
                ret = false
                idx = k
                break
            end
        end
        if ret then return end
        self.CenterColumn:Index(idx)
        self.Parent:FocusLevel(self.Parent.focusLevel + 1)
        self.Parent.OnColumnItemSelect(self.Parent, self, self.LeftColumn, self.LeftColumn:Index())
    elseif self.CurrentColumnIndex == 1 then
        self.CenterColumn:Select()
        self.Parent.OnColumnItemSelect(self.Parent, self, self.CenterColumn, self.CenterColumn:Index())
    end
end

function SubmenuTab:GoBack()
    if not self.Focused then return end
    if self.CurrentColumnIndex == 1 then
        self.CurrentColumnIndex = self.CurrentColumnIndex - 1
        self.Parent:FocusLevel(self.Parent.focusLevel - 1)
    end
end

function SubmenuTab:MouseEvent(eventType, context, index)
    if not self.Focused then return end
    if eventType == 5 then
        if self.CurrentColumnIndex == context then
            if self:CurrentColumn():Index() ~= index then
                if self.CurrentColumnIndex == 0 then
                    self.LeftColumn.Items[self.LeftColumn:Index()]:Selected(false)
                    self.LeftColumn:Index(index)
                    self.LeftColumn.Items[self.LeftColumn:Index()]:Selected(true)
                    self:StateChange(self:currentItemType())
                    self:Refresh(false)
                elseif self.CurrentColumnIndex == 1 then
                    self.CenterColumn.Items[self.CenterColumn:Index()]:Selected(false)
                    self.CenterColumn:Index(index)
                    self.CenterColumn.Items[self.CenterColumn:Index()]:Selected(true)
                end
                return
            end
            self:Select()
        else
            if context > self.CurrentColumnIndex then
                self.Parent:FocusLevel(self.Parent:FocusLevel() + 1)
                self.CurrentColumnIndex = self.CurrentColumnIndex + 1
            elseif context < self.CurrentColumnIndex then
                self.Parent:FocusLevel(self.Parent:FocusLevel() - 1)
                self.CurrentColumnIndex = self.CurrentColumnIndex - 1
            end
            if self.CurrentColumnIndex == 0 then
                self.LeftColumn.Items[self.LeftColumn:Index()]:Selected(false)
                self.LeftColumn:Index(index)
                self.LeftColumn.Items[self.LeftColumn:Index()]:Selected(true)
                self:StateChange(self:currentItemType())
                self:Refresh(false)
            elseif self.CurrentColumnIndex == 1 then
                self.CenterColumn.Items[self.CenterColumn:Index()]:Selected(false)
                self.CenterColumn:Index(index)
                self.CenterColumn.Items[self.CenterColumn:Index()]:Selected(true)
            end
        end
    elseif eventType == 10 or eventType == 11 then
        local dir = -1
        if eventType == 11 then
            dir = 1
        end
        self:MouseScroll(dir)
    end
end

function SubmenuTab:MouseScroll(dir)
    local col = self.Parent.hoveredColumn
    if self.CurrentColumnIndex == 0 then
        if col == 1 then
            if self:currentItemType() == LeftItemType.Info or self:currentItemType() == LeftItemType.Statistics then
                PlaySoundFrontend(-1, "NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                return
            end
        end
        if dir == -1 then
            self.LeftColumn:GoUp()
        else
            self.LeftColumn:GoDown()
        end
        self.CenterColumn:currentColumnType(self:currentItemType())
        self:StateChange(self:currentItemType())
        self:Refresh(false)
    elseif self.CurrentColumnIndex == 1 then
        if self:currentItemType() == LeftItemType.Settings then
            if dir == -1 then
                self.CenterColumn:GoUp()
            else
                self.CenterColumn:GoDown()
            end
            if self.CenterColumn:currentColumnType() == LeftItemType.Settings then
                self.CenterColumn:SetColumnScroll(self.CenterColumn:Index(),#self.CenterColumn.Items,self.CenterColumn.VisibleItems,"", #self.CenterColumn.Items<self.CenterColumn.VisibleItems)
            end
            PlaySoundFrontend(-1, "NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        end
    end
end

function SubmenuTab:Focus()
    BaseTab.Focus(self)
    self.LeftColumn:Index(self.LeftColumn.index)
    self.LeftColumn:HighlightColumn(true, false, true)
    self.LeftColumn.Items[self.LeftColumn:Index()]:Selected(true)
    self:Refresh(true)
end

function SubmenuTab:UnFocus()
    if self.CurrentColumnIndex > 0 then
        self.Parent:FocusLevel(self.Parent:FocusLevel() - 1)
        self.CurrentColumnIndex = self.CurrentColumnIndex - 1
    end
    self.LeftColumn.Items[self.LeftColumn:Index()]:Selected(false)
    BaseTab.UnFocus(self)
end

function SubmenuTab:Refresh(highlightOldIndex)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ALLOW_CLICK_FROM_COLUMN", 0, true)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_DATA_SLOT_EMPTY", 1)
    self.CenterColumn:Index(1)
    for i=1, #self.CenterColumn.Items, 1 do
        self:SetDataSlot(1, i)
    end
    if self:currentItemType() == LeftItemType.Keymap then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_TITLE", 1, self.LeftColumn.Items[self.LeftColumn:Index()].TextTitle, self.LeftColumn.Items[self.LeftColumn:Index()].KeymapRightLabel_1, self.LeftColumn.Items[self.LeftColumn:Index()].KeymapRightLabel_2)
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_FOCUS", 1, false, false, false)
    elseif self:currentItemType() == LeftItemType.Settings then
        ScaleformUI.Scaleforms._pauseMenu._pause("SET_COLUMN_HIGHLIGHT", 1, self.CenterColumn:Index() - 1, true, true)
    end
    self.CenterColumn:ShowColumn()
end

function SubmenuTab:Populate()
    local item = self.LeftColumn.Items[self.LeftColumn:Index()]
    item:Selected(true)
    self.CenterColumn:Clear()
    if self:currentItemType() ~= LeftItemType.Empty then
        for k,v in ipairs(self.LeftColumn.Items[self.LeftColumn:Index()].ItemList) do
            v.ParentColumn = self.CenterColumn
            self.CenterColumn:AddItem(v)
        end
    end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_MENU_LEVEL", 1)
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("MENU_STATE", self:currentItemType())
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_MENU_LEVEL", 0)
    for i=1, #self.LeftColumn.Items, 1 do
        self:SetDataSlot(0, i)
    end
    for i=1, #self.CenterColumn.Items, 1 do
        self:SetDataSlot(1, i)
    end
end

function SubmenuTab:ShowColumns()
    self.LeftColumn:ShowColumn()
    self.CenterColumn:ShowColumn()
    if self:currentItemType() == LeftItemType.Settings then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_STATE", 0)
    end
    ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_COLUMN_FOCUS", 0, false, false, false)
    self.LeftColumn:InitColumnScroll(true, 1, ScrollType.UP_DOWN, ScrollArrowsPosition.RIGHT)
    self.LeftColumn:SetColumnScroll(self.LeftColumn:Index(), #self.LeftColumn.Items, 16, "", #self.LeftColumn.Items < 16)
end

function SubmenuTab:SetDataSlot(slot, index)
    if slot == 0 then
        self.LeftColumn:SetDataSlot(index)
    elseif slot == 1 then
        self.CenterColumn:SetDataSlot(index)
    end
end

function SubmenuTab:UpdateSlot(slot, index)
    if slot == 0 then
        self.LeftColumn:UpdateSlot(index)
    elseif slot == 1 then
        self.CenterColumn:UpdateSlot(index)
    end
end