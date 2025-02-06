---
layout: default
title: UIMenuProgressItem
parent: Menu Items
show_buttons: true
show_all_code: false
---

# UIMenuProgressItem

![image](https://user-images.githubusercontent.com/4005518/162610832-fca01c29-e27e-46ed-97bb-36dca8d50991.png)

This item is hydentical to the [UIMenuSliderItem](./uimenuslideritem.md) and shares the same features.

## Constructor

```c#
public UIMenuProgressItem(string text, int maxCount, int startIndex)
public UIMenuProgressItem(string text, int maxCount, int startIndex, string description, bool heritage = false)
public UIMenuProgressItem(string text, int maxCount, int startIndex, string description, SColor sliderColor)
```

```lua
function UIMenuProgressItem.New(Text, Max, Index, Description, sliderColor, color, highlightColor, textColor, highlightedTextColor, backgroundSliderColor)
```

## Events

The only difference with [UIMenuSliderItem](./uimenuslideritem.md) is the changed events naming convention

### OnProgressChanged
Triggered when the player changes the progress in the item

```c#
public event ItemSliderProgressEvent OnProgressChanged;
```

```lua
OnProgressChanged = function(menu, item, newindex)
end,
```

### OnProgressSelected
Triggered when the player selectes the item after highlighting it
For C# users, the item inherits [UIMenuItem](./uimenuitem.md#itemactivatedevent) Activated event.

```c#
public event ItemActivatedEvent Activated;
```

```lua
OnProgressSelected = function(menu, item, newindex)
end,
```
