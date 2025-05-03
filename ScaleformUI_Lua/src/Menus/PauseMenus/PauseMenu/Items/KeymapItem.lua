KeymapItem = {}
KeymapItem.__index = KeymapItem
setmetatable(KeymapItem, { __index = PauseMenuItem })
KeymapItem.__call = function() return "KeymapItem" end

---@class KeymapItem
---@field public Label string
---@field public PrimaryKeyboard string
---@field public PrimaryGamepad string
---@field public SecondaryKeyboard string?
---@field public SecondaryGamepad string?

---Creates a new KeymapItem.
---@param title string
---@param primaryKeyboard string
---@param primaryGamepad string
---@param secondaryKeyboard string?
---@param secondaryGamepad string?
---@return table
function KeymapItem.New(title, primaryKeyboard, primaryGamepad, secondaryKeyboard, secondaryGamepad)
    local base = PauseMenuItem.New(title, ScaleformFonts.CHALET_LONDON_NINETEENSIXTY)
    base.PrimaryKeyboard = primaryKeyboard or ""
    base.PrimaryGamepad = primaryGamepad or ""
    base.SecondaryKeyboard = secondaryKeyboard or ""
    base.SecondaryGamepad = secondaryGamepad or ""
    return setmetatable(base, KeymapItem)
end

function KeymapItem:Selected(bool)
    if bool == nil then
        return self.selected
    else
        self.selected = bool
    end
end
