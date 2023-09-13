UIMenuFreemodeDetailsItem = setmetatable({}, UIMenuFreemodeDetailsItem)
UIMenuFreemodeDetailsItem.__index = UIMenuFreemodeDetailsItem
UIMenuFreemodeDetailsItem.__call = function() return "UIMenuFreemodeDetailsItem", "UIMenuFreemodeDetailsItem" end

function UIMenuFreemodeDetailsItem.New(textLeft, textRight, seperator, icon, iconColor, tick)
    local _type
    if seperator then
        _type = 3
    elseif icon ~= nil and iconColor ~= nil then
        _type = 2
    elseif textRight == nil and seperator == nil and icon == nil and iconColor == nil and tick == nil then
        _type = 4
    else
        _type = 0
    end
    _UIMenuFreemodeDetailsItem = {
        Type = _type,
        TextLeft = textLeft,
        TextRight = textRight or "",
        Icon = icon or BadgeStyle.NONE,
        IconColor = iconColor or Colours.HUD_COLOUR_WHITE,
        Tick = tick or false,
        _labelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY,
        _rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY
    }
    return setmetatable(_UIMenuFreemodeDetailsItem, UIMenuFreemodeDetailsItem)
end

function UIMenuFreemodeDetailsItem:SetLabelsFonts(leftFont, rightFont)
    if leftFont then
        self._labelFont = leftFont
    end
    if rightFont then
        self._rightLabelFont = rightFont
    end
end