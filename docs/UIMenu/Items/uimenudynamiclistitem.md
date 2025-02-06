---
layout: default
title: UIMenuDynamicListItem
parent: Menu Items
show_buttons: true
show_all_code: false
---

# UIMenuDynamicListItem
![image](https://user-images.githubusercontent.com/4005518/162609798-658d1efa-1358-4f23-9747-1b3cee3c23fb.png)

This is a runtime handled version of the more static ListItem where you don't input a predefined list to the item, the right label is outputed by the callback code called everytime left/right is inputted. 
This item can virtually output infinite values due to its runtime handling.

{: .warning}
> ⚠️ Warning
> 
> This item may change its name in future as it's scheduled for future updates to set [UIMenuListItem](./uimenulistitem.md) as Legacy and Obsolete and this as default List Item.

## Constructor

```c#
UIMenuDynamicListItem(string text, string startingItem, DynamicListItemChangeCallback changeCallback)
UIMenuDynamicListItem(string text, string description, string startingItem, DynamicListItemChangeCallback changeCallback)
```

```lua
UIMenuDynamicListItem.New(Text, Description, StartingString, callback, color, highlightColor, textColor, highlightedTextColor)
```

## Example

```c#
float dynamicvalue = 0f;
dynamicItem = new UIMenuDynamicListItem("Dynamic List Item", "Try pressing ~INPUT_FRONTEND_LEFT~ or ~INPUT_FRONTEND_RIGHT~", dynamicvalue.ToString("F3"), async (sender, direction) =>
{
	if (direction == UIMenuDynamicListItem.ChangeDirection.Left) dynamicvalue -= 0.01f;
	else dynamicvalue += 0.01f;
	return dynamicvalue.ToString("F3");
});
```

```lua
local dynamicValue = 0
local dynamicListItem = UIMenuDynamicListItem.New("Dynamic List Item", "Try pressing ~INPUT_FRONTEND_LEFT~ or ~INPUT_FRONTEND_RIGHT~", tostring(dynamicValue), function(item, direction)
	if(direction == "left") then
		dynamicValue = dynamicValue -1
	elseif(direction == "right") then
		dynamicValue = dynamicValue +1
	end
	return tostring(dynamicValue)
end)
```

## How does this item work?
This item runtime handled. 
The callback you set when instantiating it is the function called everytime left or right is pressed.
Pressing Left/Right will trigger the callback automatically, the callback **MUST** return a string that will be shown in the Right side of the item.