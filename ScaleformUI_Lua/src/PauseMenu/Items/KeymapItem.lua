KeymapItem = setmetatable({}, KeymapItem)
KeymapItem.__index = KeymapItem
KeymapItem.__call = function()
    return "BasicTabItem", "KeymapItem"
end

---@class KeymapItem
---@field public Label string
---@field public PrimaryKeyboard string
---@field public PrimaryGamepad string
---@field public SecondaryKeyboard string
---@field public SecondaryGamepad string

---Creates a new KeymapItem.
---@param title string
---@param primaryKeyboard string|nil
---@param primaryGamepad string|nil
---@param secondaryKeyboard string|nil
---@param secondaryGamepad string|nil
---@return table
function KeymapItem.New(title, primaryKeyboard, primaryGamepad, secondaryKeyboard, secondaryGamepad)
    local data = {}
    if secondaryKeyboard == nil and secondaryGamepad == nil then
        data = {
            Label = title,
            PrimaryKeyboard = primaryKeyboard,
            PrimaryGamepad = primaryGamepad,
            SecondaryKeyboard = "",
            SecondaryGamepad = "",
        }
    else
        data = {
            Label = title,
            PrimaryKeyboard = primaryKeyboard or "",
            PrimaryGamepad = primaryGamepad or "",
            SecondaryKeyboard = secondaryKeyboard or "",
            SecondaryGamepad = secondaryGamepad or "",
        }
    end
    return setmetatable(data, KeymapItem)
end
