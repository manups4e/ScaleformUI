UIMissionDetailsPanel = setmetatable({}, UIMissionDetailsPanel)
UIMissionDetailsPanel.__index = UIMissionDetailsPanel
UIMissionDetailsPanel.__call = function() return "UIMissionDetailsPanel", "UIMissionDetailsPanel" end

function UIMissionDetailsPanel.New(side, title, color, inside, txd, txn)
    local _titleType, _titleColor
    if inside == -1 then
        _titleType = 1
    elseif inside then
        _titleType = 2
    else
        _titleType = 0
    end

    if color ~= SColor.HUD_None then
        _titleColor = color
    else
        _titleColor = SColor.HUD_None
    end

    _UIMissionDetailsPanel = {
        PanelSide = side,
        Title = title,
        TitleColor = _titleColor,
        TitleType = _titleType,
        TextureDict = txd or "",
        TextureName = txn or "",
        Items = {},
        ParentItem = nil
    }
    return setmetatable(_UIMissionDetailsPanel, UIMissionDetailsPanel)
end

function UIMissionDetailsPanel:SetParentItem(Item) -- required
    if Item() == "UIMenuItem" then
        self.ParentItem = Item
    else
        return self.ParentItem
    end
end

function UIMissionDetailsPanel:Clear()
    self.Title = ""
    self.TextureDict  = ""
    self.TextureName  = ""
    self.Items  = {}
    if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
        ScaleformUI.Scaleforms._ui:CallFunction("SET_SIDE_PANEL_DATA_SLOT_EMPTY")
    end
end

function UIMissionDetailsPanel:Refresh()
    if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
        local it = IndexOf(self.ParentItem.ParentMenu.Items, self.ParentItem)
        self.ParentItem.ParentMenu:SendSidePanelToScaleform(it)
    end
end

function UIMissionDetailsPanel:UpdatePanelTitle(title)
    self.Title = title
    if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
        local it = IndexOf(self.ParentItem.ParentMenu.Items, self.ParentItem)
        self.ParentItem.ParentMenu:SendSidePanelToScaleform(it, true)
    end
end

function UIMissionDetailsPanel:UpdatePanelPicture(txd, txn)
    self.TextureDict = txd
    self.TextureName = txn

    if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
        local it = IndexOf(self.ParentItem.ParentMenu.Items, self.ParentItem)
        self.ParentItem.ParentMenu:SendSidePanelToScaleform(it, true)
    end
end

function UIMissionDetailsPanel:AddItem(newitem)
    self.Items[#self.Items + 1] = newitem
    if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
        local it = IndexOf(self.ParentItem.ParentMenu.Items, self.ParentItem)
        self.ParentItem.ParentMenu:SendSidePanelToScaleform(it, true)
    end
end

function UIMissionDetailsPanel:RemoveItemAt(index)
    table.remove(self.Items, index)
    if self.ParentItem ~= nil and self.ParentItem:SetParentMenu() ~= nil and self.ParentItem:SetParentMenu():Visible() then
        local it = IndexOf(self.ParentItem.ParentMenu.Items, self.ParentItem)
        self.ParentItem.ParentMenu:SendSidePanelToScaleform(it, true)
    end
end
