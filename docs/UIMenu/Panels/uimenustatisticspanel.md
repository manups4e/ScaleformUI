---
layout: default
title: UIMenuStatisticsPanel
parent: Menu Panels
show_buttons: true
show_all_code: false
---

### UIMenuStatisticsPanel

![image](https://user-images.githubusercontent.com/4005518/162627026-10065394-a185-463b-a3d2-cdff6720a0bd.png)  

This panel is not interactable by user input, it will only show given infos.  

## Constructor

```c#
UIMenuStatisticsPanel()
```
Lua:
```lua
UIMenuStatisticsPanel.New(items)
```

## Functions

### Add Statistics

```c#
public void AddStatistics(string Name, float val)
```

```lua
statsPanel:AddStatistic(name, value)
```

## Functions

### Get Percentage
Retrieve the current percentage from one of the listed statistics.
```c#
public float GetPercentage(int ItemId)
```

```lua
statsPanel:GetPercentage(id) -- returns a statistic value
```

### Set Percentage
Sets or updates a statistic value

```c#
public void SetPercentage(int ItemId, float number)
```

```lua
statsPanel:UpdateStatistic(id, value)
```