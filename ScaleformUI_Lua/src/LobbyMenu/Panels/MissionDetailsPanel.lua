MissionDetailsPanel = setmetatable({}, MissionDetailsPanel)
MissionDetailsPanel.__index = MissionDetailsPanel
MissionDetailsPanel.__call = function()
    return "Panel", "MissionDetailsPanel"
end

function MissionDetailsPanel.New(label, color)
    local _data = {
        _title = "",
        _label = label or "",
        _color = color or 116,
        Parent = nil,
        Items = {},
        TextureDict = "",
        TextureName = "",
        OnIndexChanged = function(index)
        end
    }
    return setmetatable(_data, MissionDetailsPanel)
end

function MissionDetailsPanel:Title(label)
    if label == nil then
        return self._title
    else
        self._title = label
        if self.Parent ~= nil and self.Parent:Visible() then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSION_PANEL_TITLE", false, self._title)
        end
    end
end

function MissionDetailsPanel:UpdatePanelPicture(txd, txn)
    self.TextureDict = txd
    self.TextureName = txn
    if self.Parent ~= nil and self.Parent:Visible() then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSION_PANEL_PICTURE", false, self.TextureDict,
        self.TextureName)
    end
end

function MissionDetailsPanel:AddItem(item)
    self.Items[#self.Items + 1] = item
    if self.Parent ~= nil and self.Parent:Visible() then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSION_PANEL_ITEM", false, item.Type, item.TextLeft,
        item.TextRight, item.Icon, item.IconColor, item.Tick)
    end
end

function MissionDetailsPanel:RemoveItem(idx)
    table.remove(self.Items, idx)
    if self.Parent ~= nil and self.Parent:Visible() then
        ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("REMOVE_MISSION_PANEL_ITEM", false, idx - 1)
    end
end
