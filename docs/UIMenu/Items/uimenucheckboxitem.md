---
layout: default
title: UIMenuCheckboxItem
parent: Menu Items
show_buttons: true
show_all_code: false
---

# UIMenuCheckboxItem
![image](https://user-images.githubusercontent.com/4005518/162609521-a5a1f24a-9caf-4f6e-91c2-04e1916557aa.png)

Shows a CheckBox on its right side and works as a true/false switch.
This item inherits all parameters, functions and events from UIMenuItem, adding new ones for its uses.

## Constructor

```c#
UIMenuCheckboxItem(string text, bool check)
UIMenuCheckboxItem(string text, bool check, string description)
UIMenuCheckboxItem(string text, UIMenuCheckboxStyle style, bool check, string description)
UIMenuCheckboxItem(string text, UIMenuCheckboxStyle style, bool check, string description, HudColor mainColor, HudColor highlightColor)
```

```lua
function UIMenuCheckboxItem.New(Text, Check, checkStyle, Description, color, highlightColor, textColor, highlightedTextColor)
```

## Parameters

### Checkbox Style
```c#
UIMenuCheckboxStyle Style { get; }
```

```lua
local style = item.CheckBoxStyle
```

### Checked

```c#
public bool Checked {get;set;}
item.Checked = true;
```

```lua
item:Checked(bool)
```

## Events

### OnCheckboxChange
Triggered everytime a player selects the item after being highlighted, changing the checkbox value.

```c#
public event CheckboxChangeEvent CheckboxEvent;
```

```lua
OnCheckboxChanged = function(menu, item, checked)
end,
```
