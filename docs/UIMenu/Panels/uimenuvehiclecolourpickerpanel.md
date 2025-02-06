---
layout: default
title: UIMenuVehicleColourPickerPanel
parent: Menu Panels
show_buttons: true
show_all_code: false
---

# UIMenuColourPickerPanel

![image](https://github.com/user-attachments/assets/a57a3c76-6bc4-45a2-9d53-e4c4a56c0ffd)

An _under menu_ version of the same side panel.

## Constructor 

```c#
UIMenuColourPickePanel(ColorPickerType panelType)
```

```lua
UIMenuVehicleColourPickerPanel.New()
```

## Parameters

### Current Value
Gets or Sets the current picker value

```c#
public int Value {get;set;}
```

```lua
panel:Value(val)
```

### Color
Returns the SColor instance of the current selected value

```c#
public SColor Color {get;}
```

```lua
panel:Color()
```

## Events

### PickerSelect

```c#
VehicleColorPickerSelectEvent(UIMenuItem menu, UIVehicleColourPickerPanel panel, int index, SColor color)
```

```lua
PickerSelect = function(value, color)
end
```

### PickerHovered

```c#
VehicleColorPickerHoverEvent(int index, SColor color)
```

```lua
PickerHovered = function(value, color)
end
```

### PickerRollout

```c#
// not an error, same delegate, different name
VehicleColorPickerHoverEvent(int index, SColor color);
panel.OnColorRollOut += (index, color) =>
{
    // code here
}
```

```lua
PickerRollOut = function(value, color)
end
```