---
layout: default
title: UIMenuColorPanel
parent: Menu Panels
show_buttons: true
show_all_code: false
---

# UIMenuColorPanel

![image](https://user-images.githubusercontent.com/4005518/162625225-d415d474-7ed2-45f1-92e3-9a75f4acd00e.png)  
The first of the panels we are gonna see now is the Color panel.  
It comes in 3 different color templates:
* Makeup colors (64 colors for make up palette)
* Hair colors (64 colors for hair palette)
* Custom colors (customizable number of colors decided by the developer)

## Constructor

```c#
UIMenuColorPanel(string title, ColorPanelType ColorType, int startIndex = 0) // for the predefined palettes
UIMenuColorPanel(string title, List<SColor> colors, int startIndex = 0) // for the customizable colors
```

```lua
UIMenuColorPanel.New(title, colorType, startIndex, colors) -- colors is nil if using predefined palettes 
```

The optional `colors` parameter is a list of SColor instances allowing devs to input HUD colors and / or custom ARGB colors in the same list.

## Parameters

### CurrentSelection
Gets or Sets the panel current color selection

```c#
int CurrentSelection{ get; set; }
```

```lua
colorPanel:CurrentSelection(new_value)
```

## Events

### ColorPanelChangedEvent

```c#
ColorPanelChangedEvent OnColorPanelChange(UIMenuItem parentItem, UIMenuColorPanel panel, int newValue)
```

```lua
colorPanel.OnColorPanelChanged = function(item, panel, newindex)
end
```