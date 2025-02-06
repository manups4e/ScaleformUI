---
layout: default
title: Radio Menu
show_buttons: true
show_all_code: false
---

# Radio Menu
![image](https://github.com/user-attachments/assets/9466c3c1-dab0-4251-8227-49166d804028)

Counterpart of the Radial Menu it emulates the Vehicle Radio menu multiple [RadioItem](./radioitem.md)s to be added to the circle.

## Constructor

```c#
public UIRadioMenu()
```

```lua
UIRadioMenu.New()
```

## Parameters

### Stations
This is the main List inside the menu, a list of [RadioItem](./radioitem.md)s 

```c#
public List<RadioItem> Stations { get; private set; }
```

```lua
menu.Stations = {}
```

### Instructional Buttons
Like [Radial Menu]({{ site.baseurl }}/RadialMenu/index) and [UIMenu]({{ site.baseurl }}/UIMenu/index) this menu allows adding and removing custom instructional buttons

```c#
public void AddInstructionalButton(InstructionalButton button){}
public void RemoveInstructionalButton(InstructionalButton button){}
public void RemoveInstructionalButton(int index){}
```

```lua
function UIRadioMenu:AddInstructionButton(button)
function UIRadioMenu:RemoveInstructionButton(button)
```

### Current Selection
Gets or Sets the current selected item in the menu.

```c#
public int CurrentSelection {get; set;}
```

```lua
function UIRadioMenu:CurrentSelection(index)
```

### Visible
Gets or Sets the visible state of the menu, if set to `true` the menu will be visible and automatically drawn on screen.

```c#
public bool Visible {get;set;}
```

```lua
function UIRadioMenu:Visible(bool)
```

### Animation Direction
The menu has animation opening and closing, you can choose between `ZoomOut` and `ZoomIn`

```c#
public AnimationDirection AnimDirection = AnimationDirection.ZoomIn;
```

```lua
function UIRadioMenu:AnimDirection(direction)
```

### Animation Duration
The time of exection for the animation where 1.0 means 1 second.

```c#
public float AnimationDuration = 1f;
```

```lua
function UIRadioMenu:AnimationDuration(time)
```

## Functions

### Add Station
Adds a [station](./radioitem.md) to the menu wheel.

```c#
public void AddStation(RadioItem station)
```

```lua
function UIRadioMenu:AddStation(station)
```

## Events
Events are triggered on player interaction with the menu.

```c#
public delegate void MenuOpenedEvent(UIRadioMenu menu, dynamic data = null);
public delegate void MenuClosedEvent(UIRadioMenu menu);
public delegate void IndexChanged(int index);
public delegate void StationSelected(RadioItem item, int index);
```

```lua
OnMenuOpen = function(menu, data)
end
OnMenuClose = function(menu)
end
OnIndexChange = function(index)
end
OnStationSelect = function(segment, index)
end
```