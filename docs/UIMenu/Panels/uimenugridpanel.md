---
layout: default
title: UIMenuGridPanel
parent: Menu Panels
show_buttons: true
show_all_code: false
---

# UIMenuGridPanel

![image](https://user-images.githubusercontent.com/4005518/162626688-4af59182-8f4d-4798-922b-f1065da67f2d.png)  

* This panel comes 2 variants: full / horizontal.
* It's value is a Vector2 in Lua and a PointF in C#, both X and Y go from 0.0 to 1.0 this means that a value of 0.5 is the center of the grid.

## Constructor
```c#
UIMenuGridPanel(string TopText, string LeftText, string RightText, string BottomText, PointF circlePosition) // full grid
UIMenuGridPanel(string LeftText, string RightText, PointF circlePosition) // half grid
```

```lua
UIMenuGridPanel.New(topText, leftText, rightText, bottomText, circlePosition, gridType) -- set gridType to 0 for the full grid or 1 for the horizontal grid
```

## Parameters

### Circle Position
Gets or Sets the current position of the circle in the grid.

```c#
PointF CirclePosition { get; set; }
```
Lua:
```lua
gridPanel.:CirclePosition(position)
```

## Events

### GridPanelChangedEvent
```c#
GridPanelChangedEvent OnGridPanelChange(UIMenuItem item, UIMenuGridPanel panel, PointF newPosition)
```

```lua
gridPanel.OnGridPanelChanged = function(item, panel, newPosition) 
```

