UIMenuFreemodeDetailsItem = setmetatable({}, UIMenuFreemodeDetailsItem)
UIMenuFreemodeDetailsItem.__index = UIMenuFreemodeDetailsItem
UIMenuFreemodeDetailsItem.__call = function() return "UIMenuFreemodeDetailsItem", "UIMenuFreemodeDetailsItem" end

function UIMenuFreemodeDetailsItem.New(textLeft, textRight, seperator, icon, iconColor, tick)
    if seperator then
        _type = 3
    elseif icon ~= nil and iconColor ~= nil then
        _type = 2
    else
        _type = 0
    end
    _UIMenuFreemodeDetailsItem = {
        Type = _type,
        TextLeft = textLeft,
        TextRight = textRight,
        Icon = icon,
        IconColor = iconColor,
        Tick = tick or false
	}
	return setmetatable(_UIMenuFreemodeDetailsItem, UIMenuFreemodeDetailsItem)
end