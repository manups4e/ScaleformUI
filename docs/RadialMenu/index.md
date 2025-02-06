---
layout: default
title: Radial Menu
show_buttons: true
show_all_code: false
---
# Radial Menu

![image](https://github.com/manups4e/ScaleformUI/assets/4005518/ae808585-af36-4f00-a323-3b3f6036dd74)

Radial Menu is a customizable WeaponWheel menu, it's divided in 8 segments ([RadialSegment](./radialsegment.md)) that can be selected, and to each segment you can add any amount of [SegmentItem](./segmentitem.md) items you want.

## Constructor

```c#
public RadialMenu()
public RadialMenu(PointF offset)
```

```lua
RadialMenu.New(x, y)
```

## Parameters

### Visible
Gets or Sets the menu visible status. If Visible is `true` the menu is drawn on screen.

```c#
public bool Visible {get;set;}
```

```lua
radMenu:Visible(bool)
```

### CurrentSegment
Gets or Sets the current highlighted segment

```c#
public int CurrentSegment {get;set;}
```

```lua
radMenu:CurrentSegment(index)
```

### Segments
A `table` in Lua and a `List` in C#, both using only `RadialSegment` tab and max 8 items. Each item can contain int32.max items to scroll like the original `Weapon Wheel`.

```c#
public RadialSegment[] Segments
```

```lua
radMenu.Segments -- An 8 items table, each item represents a segment of the wheel (clockwise)
```

### Enable3D
Gets or Sets the 3D effect on wheel, `true` by default.

```c#
public bool Enable3D {get;set;}
```

```lua
radMenu:Enable3D(enable) -- Enables / disables the 3D effects on the wheel (default true)
```

## Instructional Buttons
This menu like all other menus have `InstructionalButtons` table / List handled automatically by ScaleformUI. Here's the functions to handle the list.

```c#
List<InstructionalButton> InstructionalButtons // the instructional buttons to show while the menu is Visible
void AddInstructionalButton(InstructionalButton button) // adds an instructional button to the current menu
void RemoveInstructionalButton(InstructionalButton button) // removes the desired instructional button
void RemoveInstructionalButton(int index) // removes the desired instructional button
```

```lua
.InstructionalButtons -- the instructional buttons to show while the menu is Visible
:AddInstructionButton(button) -- adds an instructional button to the current menu
:RemoveInstructionButton(button) -- removes the desired instructional button
```

## Events
Triggered based on player's actions.

```c#
MenuOpenedEvent(RadialMenu menu, dynamic data = null);
MenuClosedEvent(RadialMenu menu);
SegmentChanged(RadialSegment segment);
IndexChanged(RadialSegment segment, int index);
SegmentSelected(RadialSegment segment);
```

```lua
OnMenuOpen = function(menu, data)
end,
OnMenuClose = function(menu)
end,
OnSegmentHighlight = function(segment)
end,
OnSegmentIndexChange = function(segment, index)
end,
OnSegmentSelect = function(segment)
end
```
