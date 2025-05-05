SettingsItem = {}
SettingsItem.__index = SettingsItem
setmetatable(SettingsItem, { __index = PauseMenuItem })
SettingsItem.__call = function() return "SettingsItem" end


---@class SettingsItem
---@field ItemType SettingsItemType
---@field Label string
---@field Parent SettingsItem
---@field OnActivated fun(item:SettingsItem, index:number)

---Creates a new SettingsItem.
---@param label string
---@param rightLabel string?
---@return SettingsItem
function SettingsItem.New(label, rightLabel)
    local base = PauseMenuItem.New(label, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)
    base.ItemType = SettingsItemType.Basic
    base._rightLabel = rightLabel or ""
    base.enabled = true
    base.OnActivated = function()
    end
    return setmetatable(base, SettingsItem)
end

---Toggle the enabled state of the item.
---@param enabled boolean
---@return boolean
function SettingsItem:Enabled(enabled)
    if enabled ~= nil then
        self._enabled = enabled
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self._enabled
end

---Toggle the hovered state of the item.
---@param hover boolean
---@return boolean
function SettingsItem:Hovered(hover)
    if hover ~= nil then
        self._hovered = hover
    end
    return self._hovered
end

---Toggle the selected state of the item.
---@param selected boolean
---@return boolean
function SettingsItem:Selected(selected)
    if selected ~= nil then
        self._selected = selected
    end
    return self._selected
end

---Set the right label of the item.
---@param label string
---@return string
function SettingsItem:RightLabel(label)
    if label ~= nil then
        self._rightLabel = label
        if self.ParentColumn ~= nil and self.ParentColumn:visible() then
            self.ParentColumn:UpdateSlot(IndexOf(self.ParentColumn.Items, self))
        end
    end
    return self._rightLabel
end
