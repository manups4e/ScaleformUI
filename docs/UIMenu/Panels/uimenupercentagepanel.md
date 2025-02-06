---
layout: default
title: UIMenuPercentagePanel
parent: Menu Panels
show_buttons: true
show_all_code: false
---

# UIMenuPercentagePanel

![image](https://user-images.githubusercontent.com/4005518/162625751-100d9360-b0c3-4376-9657-729722298a05.png)  

This panel is a progressive panel value is float and goes from `0.0` to `100.0`.

## Constructor

```c#
public UIMenuPercentagePanel(string title, string MinText = "0%", string MaxText = "100%", float initialValue = 0)
```

```lua
UIMenuPercentagePanel.New(title, minText, maxText, initialValue)
```

## Parameters

### Percentage 
Gets or Sets the panel current percentage.

```c#
float Percentage { get; set; }
```

```lua
percPanel:Percentage(value)
```

## Events

### 

```c#
PercentagePanelChangedEvent OnPercentagePanelChange(UIMenuItem item, UIMenuPercentagePanel panel, float value)
```

```lua
percPanel.OnPercentagePanelChange = function(item, panel, value)
end
```