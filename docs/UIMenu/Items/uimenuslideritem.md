---
layout: default
title: UIMenuSliderItem
parent: Menu Items
show_buttons: true
show_all_code: false
---
# UIMenuSliderItem

![image](https://user-images.githubusercontent.com/4005518/162610316-5d6decde-bc5b-46ea-925f-5b8c18b2f918.png)

A slider, a section of a progress item that slides in a predefined space.

- It comes with Mom and Dad icons too, simply set Heritage value to true!
- This item works with integer values only
- You can specify the slider color.

## Constructor 

```c#
UIMenuSliderItem(string text)
UIMenuSliderItem(string text, string description)
UIMenuSliderItem(string text, string description, bool heritage)
UIMenuSliderItem(string text, string description, int max, int mult, int startVal, bool heritage)
UIMenuSliderItem(string text, string description, int max, int mult, int startVal, HudColor sliderColor, bool heritage = false)
```

```lua
function UIMenuSliderItem.New(Text, Max, Multiplier, Index, Heritage, Description, sliderColor, color, highlightColor, textColor, highlightedTextColor)
```

## Parameters

### SliderColor
Gets or Sets the slider color after initialization or on runtime.

```c#
HudColor SliderColor { get; set; }
```

```lua
sliderItem:SliderColor(color)
```

### CurrentValue
Gets or Sets the current value or position of the slider.

```c#
int Value { get; set; }
```

```lua
sliderItem:Index(Index)
```

## Events

### OnSliderChanged 

```c#
ItemSliderEvent OnSliderChanged(UIMenuSliderItem item, int newIndex)
```

```lua
sliderItem.OnSliderChanged = function(menu, item, newindex)
end
```

### OnSliderSelected 
For C# users, the item inherits [UIMenuItem](./uimenuitem.md#itemactivatedevent) Activated event.

```c#
public event ItemActivatedEvent Activated
```

```lua
sliderItem.OnSliderSelected = function(menu, item, newindex)
end
```