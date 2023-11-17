MissionDetailsPanel = setmetatable({}, MissionDetailsPanel)
MissionDetailsPanel.__index = MissionDetailsPanel
MissionDetailsPanel.__call = function()
    return "Panel", "MissionDetailsPanel"
end

---@class MissionDetailsPanel
---@field private _title string
---@field private _label string
---@field private _color SColor
---@field public Parent MissionDetailsPanel
---@field public Items table<MissionDetailsItem>
---@field public TextureDict string
---@field public TextureName string
---@field public Title fun(self: MissionDetailsPanel, label: string): string
---@field public UpdatePanelPicture fun(self: MissionDetailsPanel, txd: string, txn: string)
---@field public AddItem fun(self: MissionDetailsPanel, item: MissionDetailsItem)
---@field public OnIndexChanged fun(index: number)

function MissionDetailsPanel.New(label, color)
    local _data = {
        Type = "panel",
        ParentTab = nil,
        _title = "",
        _label = label or "",
        _color = color or SColor.HUD_Freemode,
        Parent = nil,
        Items = {} --[[@type table<MissionDetailsItem>]],
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
            local pSubT = self.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_MISSION_PANEL_TITLE", self._title)
            elseif pSubT == "PauseMenu" then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_MISSION_PANEL_TITLE", self.ParentTab, self._title)
            end
        end
    end
end

function MissionDetailsPanel:UpdatePanelPicture(txd, txn)
    self.TextureDict = txd
    self.TextureName = txn
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSION_PANEL_PICTURE", self.TextureDict, self.TextureName)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_MISSION_PANEL_PICTURE", self.ParentTab, self.TextureDict, self.TextureName)
        end
    end
end

function MissionDetailsPanel:AddItem(item)
    self.Items[#self.Items + 1] = item
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("ADD_MISSION_PANEL_ITEM", item.Type, item.TextLeft, item.TextRight, item.Icon, item.IconColor, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("ADD_PLAYERS_TAB_MISSION_PANEL_ITEM", self.ParentTab, item.Type, item.TextLeft, item.TextRight, item.Icon, item.IconColor, item.Tick, item._labelFont.FontName, item._labelFont.FontID, item._rightLabelFont.FontName, item._rightLabelFont.FontID)
        end
    end
end

function MissionDetailsPanel:RemoveItem(idx)
    table.remove(self.Items, idx)
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("REMOVE_MISSION_PANEL_ITEM", idx - 1)
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("REMOVE_PLAYERS_TAB_MISSION_PANEL_ITEM", self.ParentTab, idx - 1)
        end
    end
end

function MissionDetailsPanel:Clear()
    if self.Parent ~= nil and self.Parent:Visible() then
        local pSubT = self.Parent()
        if pSubT == "LobbyMenu" then
            ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("CLEAR_MISSION_PANEL_ITEMS")
        elseif pSubT == "PauseMenu" then
            ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("CLEAR_PLAYERS_TAB_MISSION_PANEL_ITEMS")
        end
    end
    self.Items = {}
end
