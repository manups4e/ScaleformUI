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

function UIMissionDetailsPanel:UpdatePanelTitle(title)
    self.Title = title

    if self.ParentItem ~= nil then
        local item = IndexOf(self.ParentItem.Base.ParentMenu.Items, self.ParentItem) - 1
        ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_SIDE_PANEL_TITLE", item, title)
    end
end

function UIMissionDetailsPanel:UpdatePanelPicture(txd, txn)
    self.TextureDict = txd
    self.TextureName = txn

    if self.ParentItem ~= nil then
        local item = IndexOf(self.ParentItem.Base.ParentMenu.Items, self.ParentItem) - 1
        ScaleformUI.Scaleforms._ui:CallFunction("UPDATE_MISSION_DETAILS_PANEL_IMG", item, txd, txn)
    end
end

function UIMissionDetailsPanel:AddItem(newitem)
    self.Items[#self.Items + 1] = newitem
    if self.ParentItem ~= nil then
        local item = IndexOf(self.ParentItem.Base.ParentMenu.Items, self.ParentItem) - 1
        ScaleformUI.Scaleforms._ui:CallFunction("ADD_MISSION_DETAILS_DESC_ITEM", item, newitem.Type,
            newitem.TextLeft, newitem.TextRight, newitem.Icon, newitem.IconColor, newitem.Tick, newitem._labelFont.FontName, newitem._labelFont.FontID,
            newitem._rightLabelFont.FontName, newitem._rightLabelFont.FontID)
    end
end

function UIMissionDetailsPanel:RemoveItemAt(index)
    table.remove(self.Items, index)
    if self.ParentItem ~= nil then
        local item = IndexOf(self.ParentItem.Base.ParentMenu.Items, self.ParentItem) - 1
        ScaleformUI.Scaleforms._ui:CallFunction("REMOVE_MISSION_DETAILS_DESC_ITEM", item, index - 1)
    end
end
