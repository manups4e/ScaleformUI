SettingsSeparatorItem = {}
SettingsSeparatorItem.__index = SettingsSeparatorItem
setmetatable(SettingsSeparatorItem, { __index = SettingsItem })
SettingsSeparatorItem.__call = function() return "SettingsSeparatorItem" end

function SettingsSeparatorItem.New(label)
    local base = SettingsItem.New(label, "")
    if label:IsNullOrEmpty() then
        base.ItemType = SettingsItemType.Empty
    else
        base.ItemType = SettingsItemType.Separator
    end
    base.IsJumpable = false
    return setmetatable(base, SettingsSeparatorItem)
end