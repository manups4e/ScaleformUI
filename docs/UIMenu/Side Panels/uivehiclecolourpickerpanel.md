---
layout: default
title: UIVehicleColourPickerPanel
parent: Side Panels
show_buttons: true
show_all_code: false
---

# UIVehicleColourPickerPanel

![image](https://user-images.githubusercontent.com/4005518/162627553-770a84a0-7b60-469a-a5a2-88c991d3a5d8.png)  

Since the classic color panel is not enough to show all the vehicle colors available, i decided to make a new side panel only for them.  

## Constructor
```c#
public UIVehicleColourPickerPanel(PanelSide side, string title)
public UIVehicleColourPickerPanel(PanelSide side, string title, HudColor BgColor)
```

```lua
UIVehicleColorPickerPanel.New(side, title, color)
```

## Parameters
This panel is exactly the same as [UIMenuColourPickerPanel]({{ site.baseurl }}/UIMenu/Panels/uimenuvehiclecolourpickerpanel/)

```c#
string Title { get; set; }
VehicleColorPickerSelectEvent OnVehicleColorPickerSelect(UIMenuItem item, UIVehicleColourPickerPanel panel, int colorIndex)
```

```lua
:UpdatePanelTitle(title)
PickerSelect = function(item, panel, colorIndex)
```
