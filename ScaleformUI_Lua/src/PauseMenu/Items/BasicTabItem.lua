BasicTabItem = setmetatable({}, BasicTabItem)
BasicTabItem.__index = BasicTabItem
BasicTabItem.__call = function()
    return "BasicTabItem", "BasicTabItem"
end

---@class BasicTabItem
---@field Label string
---@field Parent BasicTabItem

---Creates a new BasicTabItem.
---@param label string
---@return BasicTabItem
function BasicTabItem.New(label, labelFont)
    local data = {
        Label = label or "",
        LabelFont = labelFont or ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        Parent = nil
    }
    return setmetatable(data, BasicTabItem)
end
