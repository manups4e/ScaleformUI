TextOverlay = {}
TextOverlay.__index = TextOverlay
setmetatable(TextOverlay, { __index = MinimapOverlay })
TextOverlay.__call = function() return "TextOverlay" end

function TextOverlay.New(handle, label, x,y, fontSize, alignment, font, outline, shadow)
    local base = MinimapOverlay.New(handle, "", "", x, y, 0, 100, 100, 100, false)
    base.Text = label
    base.FontSize = fontSize or 13
    base.Alignment = alignment or 1
    base.Font = font or "$Font2"
    base.Outline = outline or true
    base.Shadow = shadow or false

    return setmetatable(base, TextOverlay)
end
