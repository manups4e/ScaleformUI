PauseMenuItem = setmetatable({}, PauseMenuItem)
PauseMenuItem.__index = PauseMenuItem
PauseMenuItem.__call = function()
    return "PauseMenuItem", "PauseMenuItem"
end

---@class PauseMenuItem
---@field Label string
---@field Parent PauseMenuItem

---Creates a new PauseMenuItem.
---@param label string
---@return PauseMenuItem
function PauseMenuItem.New(label, labelFont)
    local data = {
        label = label or "",
        LabelFont = labelFont or ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        labelFont = labelFont or ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        selected = false,
        ParentTab = nil,
        PrentColumn = nil,
    }
    return setmetatable(data, PauseMenuItem)
end

function PauseMenuItem:Selected(bool)
    if bool == nil then
        return self.selected
    else
        self.selected = bool
    end
end
