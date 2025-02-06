---
layout: default
title: UIMenuDetailsWindow
parent: Windows
show_buttons: true
show_all_code: false
---

# UIMenuDetailsWindow

![image](https://github.com/user-attachments/assets/0a01a12d-7dd5-4335-9c76-a149b58c1eb9)

A pie chart with detail labels.
Pie chart can be replaced with a custom texture.

## Constructor

```c#
UIMenuDetailsWindow(string top, string mid, string bot, UIDetailImage leftDetail = null)
UIMenuDetailsWindow(string top, string mid, string bot, bool statWheelEnabled, List<UIDetailStat> details)
```

```lua
UIMenuDetailsWindow.New(...)
```

## Functions

```c#
public void UpdateLabels(string top, string mid, string bot, UIDetailImage leftDetail = null)
public void AddStatsListToWheel(List<UIDetailStat> stats)
public void AddStatSingleToWheel(UIDetailStat stat)
public void UpdateStatsToWheel() // refresh
public void UpdateStatsToWheel(List<UIDetailStat> stats)
public void RemoveStatToWheel(UIDetailStat stat)
public void RemoveStatToWheel(int id)
```

```lua
UpdateLabels(top, mid, bot, leftDetail)
UIMenuDetailsWindow:AddStatsListToWheel(stats)
UIMenuDetailsWindow:AddStatSingleToWheel(stat)
UIMenuDetailsWindow:UpdateStatsToWheel()
```