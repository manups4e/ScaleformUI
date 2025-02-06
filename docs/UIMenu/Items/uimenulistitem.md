---
layout: default
title: UIMenuListItem
parent: Menu Items
show_buttons: true
show_all_code: false
---

# UIMenuListItem

![image](https://user-images.githubusercontent.com/4005518/162609041-3d969294-4208-47fa-887e-3a9c3fb6b34b.png)

This item requires a list of values to be given, the menu will then scroll the items left/right.
This item has 2 events, OnListChange called everytime the user goes left/right and OnListSelect called when the user selects the item after highlighting it.
The item inherits all the UIMenuItem functions and adds some of his.

{: .warning}
> ⚠️ Warning
> 
> This item is sheduled to become obsolete and legacy in future updates of the library. It will be replaced by the more runtime friendly [UIMenuDynamicListItem](./uimenudynamiclistitem.md).


## Constructor

```c#
UIMenuListItem(string text, List<dynamic> items, int index)
UIMenuListItem(string text, List<dynamic> items, int index, string description)
UIMenuListItem(string text, List<dynamic> items, int index, string description, HudColor mainColor, HudColor higlightColor)
```

```lua
UIMenuListItem.New(Text, Items, Index, Description, mainColor, highlightColor, textColor, highlightedTextColor)
```

## Parameters

### Items
The values given in constructor are saved in the **Items** list.

```c#
List<object> Items { get; }
var values = listItem.Items;
```

```lua
local values = listitem.Items
```

### Index
Gets or Sets the current item index to show the corresponding value in the given Items list

```c#
int Index { get; set; }
```

```lua
item:Index(index)
```

## Functions

### ChangeList
This functions updates the current list of values with a new one.
A new starting index can be optionally specified.

```c#
public void ChangeList(List<dynamic> list, int index)
```

```lua
listitem::ChangeList(list)
```

## Events

### OnListChange
Triggered everytime the player goes left or right

```cs
public event ListChangedEvent OnListChange;
```

```lua
OnListChange = function(menu, item, newindex)
end
```

### OnListSelect
Triggered everytime the player selects the item after highlighting it.

```cs
public event ListSelectedEvent OnListSelect;
```

```lua
OnListSelect = function(menu, item, newindex)
end
```