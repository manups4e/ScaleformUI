TextTab = {}
TextTab.__index = TextTab
setmetatable(TextTab, { __index = BaseTab })
TextTab.__call = function() return "TextTab" end

---@class TextTab

function TextTab.New(name, _title, color)
    local base = BaseTab.New(name, color)
    base._identifier = "Page_Simple"
    base.TextTitle = _title or "" -- unused atm because of new pause implementation
    base.BGTextureDict = ""
    base.BGTextureName = ""
    base.RightTextureDict = ""
    base.RightTextureName = ""
    base.LeftColumn = TextColumn.New(0)
    local meta = setmetatable(base, TextTab)
    meta.LeftColumn.Parent = meta
    return meta
end

function TextTab:AddTitle(title)
    if not title:IsNullOrEmpty() then
        self.TextTitle = title
    end
end

function TextTab:AddItem(item)
    self.LeftColumn:AddItem(item)
end

function TextTab:Populate()
    for i = 1, #self.LeftColumn.Items, 1 do
        self:SetDataSlot(self.LeftColumn.position, i)
    end
    if not self.BGTextureDict:IsNullOrEmpty() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CALL_CUSTOM_COLUMN_FUNCTION", self.LeftColumn.position,
            "SET_BACKGROUND", self.BGTextureDict, self.BGTextureName)
    end
    if not self.RightTextureDict:IsNullOrEmpty() then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CALL_CUSTOM_COLUMN_FUNCTION", self.LeftColumn.position,
            "SET_RIGHT_PICTURE", self.RightTextureDict, self.RightTextureName)
    end
end

function TextTab:ShowColumns()
    self.LeftColumn:ShowColumn()
    self.LeftColumn:InitColumnScroll(true, 3, ScrollType.UP_DOWN, ScrollArrowsPosition.CENTER)
    self.LeftColumn:SetColumnScroll(-1, -1, -1, "", #self.LeftColumn.Items < self.LeftColumn.VisibleItems)
    self.LeftColumn:HighlightColumn(true, false, true)
end

function TextTab:Focus()
    BaseTab.Focus(self)
    self.LeftColumn:HighlightColumn(true, false, true)
end

function TextTab:UpdateBackground(txd, txn)
    self.BGTextureDict = txd
    self.BGTextureName = txn
    if self.Parent ~= nil and self.Parent:Visible() and self.Parent:CurrentTab() == self then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CALL_CUSTOM_COLUMN_FUNCTION", self.LeftColumn.position,
            "SET_BACKGROUND", txd, txn)
    end
end

function TextTab:SetDataSlot(slot, index)
    self.LeftColumn:SetDataSlot(index)
end

function TextTab:AddPicture(txd, txn)
    self.RightTextureDict = txd
    self.RightTextureName = txn
    if self.Parent ~= nil and self.Parent:Visible() and self.Parent:CurrentTab() == self then
        ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CALL_CUSTOM_COLUMN_FUNCTION", self.LeftColumn.position,
            "SET_RIGHT_PICTURE", txd, txn)
    end
end