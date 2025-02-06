---
layout: default
title: UIMenuStatsItem
parent: Menu Items
show_buttons: true
show_all_code: false
---

# UIMenuStatsItem

![image](https://user-images.githubusercontent.com/4005518/162611147-6ad025a7-f018-44b9-909f-f7f2996cf016.png)

This item is logically hydentical to the [UIMenuProgressItem](./uimenuprogressitem.md)

## Constructor

```c#
public UIMenuStatsItem(string text) : this(text, "", 0, SColor.HUD_Freemode)
public UIMenuStatsItem(string text, string subtitle, int value, SColor color) : base(text, subtitle)
```

```lua
function UIMenuStatsItem.New(Text, Description, Index, barColor, type, mainColor, highlightColor, textColor, highlightedTextColor)
```


## Events
This item events are hydentical to the [UIMenuProgressItem](./uimenuprogressitem.md) one but with different names.

```c#
public event ItemActivatedEvent Activated;
public event StatChanged OnStatChanged;
```

```lua
OnStatsChanged = function(menu, item, newindex)
end,
OnStatsSelected = function(menu, item, newindex)
end,
```