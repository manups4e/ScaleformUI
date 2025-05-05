UIMenuFreemodeDetailsItem = {}
UIMenuFreemodeDetailsItem.__index = UIMenuFreemodeDetailsItem
setmetatable(UIMenuFreemodeDetailsItem, { __index = PauseMenuItem })
UIMenuFreemodeDetailsItem.__call = function() return "UIMenuFreemodeDetailsItem" end

function UIMenuFreemodeDetailsItem.New(textLeft, textRight, seperator, icon, iconColor, tick, crewTag)
    local _type
    if seperator then
        _type = 4
    elseif icon ~= nil and iconColor ~= nil then
        _type = 2
    elseif crewTag ~= nil then
        _type = 3
    elseif textRight == nil and seperator == nil and icon == nil and iconColor == nil and tick == nil then
        _type = 5
    else
        _type = 0
    end
   
    local base = PauseMenuItem.New(textLeft)
    base.Type = _type
    base.TextRight = textRight or ""
    base.Icon = icon or BadgeStyle.NONE
    base.IconColor = iconColor or SColor.HUD_White
    base.Tick = tick or false
    base.CrewTag = crewTag
    base._rightLabelFont = ScaleformFonts.CHALET_LONDON_NINETEENSIXTY

    return setmetatable(base, UIMenuFreemodeDetailsItem)
end

function UIMenuFreemodeDetailsItem:SetLabelsFonts(leftFont, rightFont)
    if leftFont then
        self.LabelFont = leftFont
    end
    if rightFont then
        self._rightLabelFont = rightFont
    end
end
