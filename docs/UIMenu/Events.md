---
layout: default
title: Events
parent: UIMenu
show_buttons: true
show_all_code: false
---

# Menu Events
Menu events in **ScaleformUI** are specific triggers that allow developers to execute actions in response to user interactions with the menu. These events ensure that the menu system stays dynamic and responsive, improving the user experience.

## OnIndexChange
Triggered when the user presses up or down, changing the current selection.

```c#
public event IndexChangedEvent OnIndexChange;
```

```lua
--- Triggered when the user presses up or down, changing the current selection.
menu.OnIndexChange = function(menu, newindex)
end
```

---

## OnListChange
Triggered when the user presses left or right, changing a list position.

```c#
public event ListChangedEvent OnListChange;
```

```lua
--- Triggered when the user presses left or right, changing a list position.
menu.OnListChange = function(menu, list, newindex)
end
```

---

## OnSliderChange
Triggered when the user presses left or right, changing a slider position.

```c#
public event SliderChangedEvent OnSliderChange;
```

```lua
--- Triggered when the user presses left or right, changing a slider position.
menu.OnSliderChange = function(menu, slider, newindex)
end
```

---

## OnProgressChange
Triggered when the user changes the value of a progress item.

```c#
public event OnProgressChanged OnProgressChange;
```

```lua
--- Triggered when the user changes the value of a progress item.
menu.OnProgressChange = function(menu, progress, newindex)
end
```

---

## OnCheckboxChange
Triggered when the user presses enter on a checkbox item.

```c#
public event CheckboxChangeEvent OnCheckboxChange;
```

```lua
--- Triggered when the user presses enter on a checkbox item.
menu.OnCheckboxChange = function(menu, item, checked)
end
```

---

## OnListSelect
Triggered when the user selects a list item.

```c#
public event ListSelectedEvent OnListSelect;
```

```lua
--- Triggered when the user selects a list item.
menu.OnListSelect = function(menu, list, index)
end
```

---

## OnSliderSelect
Triggered when the user selects a slider item.

```c#
public event SliderSelectedEvent OnSliderSelect;
```

```lua
--- Triggered when the user selects a slider item.
menu.OnSliderSelect = function(menu, slider, index)
end
```

---

## OnProgressSelect
Triggered when the user selects a progress item.

```c#
public event OnProgressSelected OnProgressSelect;
```

```lua
--- Triggered when the user selects a progress item.
menu.OnProgressSelect = function(menu, progress, index)
end
```

---

## OnStatsSelect
Triggered when the user selects a stats item.

```c#
public event StatItemProgressChange OnStatsItemChanged;
```

```lua
--- Triggered when the user selects a stats item.
menu.OnStatsSelect = function(menu, progress, index)
end
```

---

## OnItemSelect
Triggered when the user selects a simple item.

```c#
public event ItemSelectEvent OnItemSelect;
```

```lua
--- Triggered when the user selects a simple item.
menu.OnItemSelect = function(menu, item, index)
end
```

---

## OnMenuOpen
Triggered when the menu is opened.

```c#
public event MenuOpenedEvent OnMenuOpen;
```

```lua
--- Triggered when the menu is opened.
menu.OnMenuOpen = function(menu)
end
```

---

## OnMenuClose
Triggered when the menu is closed.

```c#
public event MenuClosedEvent OnMenuClose;
```

```lua
--- Triggered when the menu is closed.
menu.OnMenuClose = function(menu)
end
```

---

## OnColorPanelChanged
Triggered when the user changes the index of a color panel.

```c#
public event ColorPanelChangedEvent OnColorPanelChange;
```

```lua
--- Triggered when the user changes the index of a color panel.
menu.OnColorPanelChanged = function(menu, item, index)
end
```

---

## OnPercentagePanelChanged
Triggered when the user changes the value of a percentage panel.

```c#
public event PercentagePanelChangedEvent OnPercentagePanelChange;
```

```lua
--- Triggered when the user changes the value of a percentage panel.
menu.OnPercentagePanelChanged = function(menu, item, index)
end
```

---

## OnGridPanelChanged
Triggered when the user changes the value of a grid panel.

```c#
public event GridPanelChangedEvent OnGridPanelChange;
```

```lua
--- Triggered when the user changes the value of a grid panel.
menu.OnGridPanelChanged = function(menu, item, index)
end
```

---

## ExtensionMethod
Triggered to run a custom method for extending the menu behavior.

```c#
public event ExtensionMethodEvent ExtensionMethod;
```

```lua
--- Triggered to run a custom method for extending the menu behavior.
menu.ExtensionMethod = function(menu)
end
```
