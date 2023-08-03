ItemFont = setmetatable({}, ItemFont)

function ItemFont.New(fontName, fontId)
    if fontId == nil then fontId = 0 end
    local font = {
        FontName = fontName,
        FontID = fontId
    }
    return setmetatable(font, ItemFont)
end

function ItemFont.RegisterFont(gfxName, fontName)
    RegisterFontFile(gfxName)
    local font = {
        FontName = fontName,
        FontID = RegisterFontId(fontName)
    }
    return setmetatable(font, ItemFont)
end