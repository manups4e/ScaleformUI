UIMenuFreemodeDetailsImageItem = setmetatable({}, UIMenuFreemodeDetailsImageItem)
UIMenuFreemodeDetailsImageItem.__index = UIMenuFreemodeDetailsImageItem
UIMenuFreemodeDetailsImageItem.__call = function() return "UIMenuFreemodeDetailsItem", "UIMenuFreemodeDetailsImageItem" end

function UIMenuFreemodeDetailsImageItem.New(textLeft, textRight, icon, iconColor, tick)
	_UIMenuFreemodeDetailsImageItem = {
                Type = 2,
                TextLeft = textLeft,
                TextRight = textRight,
                Icon = icon,
                IconColor = iconColor,
                Tick = tick
	}
	return setmetatable(_UIMenuFreemodeDetailsImageItem, UIMenuFreemodeDetailsImageItem)
end