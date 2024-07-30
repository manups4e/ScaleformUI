StoreItem = setmetatable({}, StoreItem)
StoreItem.__index = StoreItem
StoreItem.__call = function()
    return "LobbyItem", "StoreItem"
end

---@class StoreItem
---@field public Handle number
---@field public ParentColumn StoreListColumn
---@field public TextureDictionary string
---@field public TextureName string
---@field public Description string
---@field private _Selected boolean
---@field public hovered boolean
---@field public Hovered fun(val: boolean): boolean
---@field public Enabled fun(bool: boolean): boolean
---@field public Selected fun(bool: boolean): boolean



---@param textureDictionary string
---@param textureName string
---@param description string
---@return table
function StoreItem.New(textureDictionary, textureName, description)
    local _data = {
        Handle = nil,
        ParentColumn = nil,
        enabled = true,
        TextureDictionary = textureDictionary,
        TextureName = textureName,
        Description = description or "",
        _Selected = false,
        hovered = false,
        Activated = function(item)
        end
    }
    return setmetatable(_data, StoreItem)
end

function StoreItem:Hovered(val)
    if val == nil then
        return self.hovered
    else
        self.hovered = val
    end
end

function StoreItem:Enabled(bool)
    if bool == nil then
        return self.enabled
    else
        self.enabled = bool
        if self.ParentColumn ~= nil and self.ParentColumn.Parent ~= nil and self.ParentColumn.Parent:Visible() then
            local idx = self.ParentColumn.Pagination:GetScaleformIndex(IndexOf(self.ParentColumn.Items, self))
            local pSubT = self.ParentColumn.Parent()
            if pSubT == "LobbyMenu" then
                ScaleformUI.Scaleforms._pauseMenu._lobby:CallFunction("SET_STORE_ITEM_ENABLED", idx, bool)
            elseif pSubT == "PauseMenu" and self.ParentColumn.ParentTab.Visible then
                ScaleformUI.Scaleforms._pauseMenu._pause:CallFunction("SET_PLAYERS_TAB_STORE_ITEM_ENABLED", idx, bool)
            end
        end
    end
end

function StoreItem:Selected(bool)
    if bool == nil then
        return self._Selected
    else
        self._Selected = bool
    end
end
