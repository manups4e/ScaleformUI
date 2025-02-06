---
layout: default
title: Rankbar
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Rankbar
![image](https://github.com/manups4e/ScaleformUI/assets/4005518/92dab93d-b602-42e3-b8c2-302f26b190e8)

```c#
Main.RankBarInstance
```  

```lua
ScaleformUI.Scaleforms.RankbarHandler
```

## Features

```c#
HudColor Color // Set the color of the Rank Bar when displayed
void SetScores(int limitStart, int limitEnd, int previousValue, int currentValue, int currentRank) // Shows the rank bar
/// <param name="limitStart">Floor value of experience e.g. 0</param>
/// <param name="limitEnd">Ceiling value of experience e.g. 800</param>
/// <param name="previousValue">Previous Experience value </param>
/// <param name="currentValue">New Experience value</param>
/// <param name="currentRank">Current rank</param>
void Remove()
void OverrideAnimationSpeed(int speed = 1000)
void OverrideOnscreenDuration(int duration = 4000)
```

Functions available for Lua:
```lua
---@field public SetScores fun(limitStart:number, limitEnd:number, previousValue:number, currentValue:number, currentRank:number):nil
---@field public SetColour fun(rankBarColor:number):nil
---@field public Remove fun():nil
---@field public OverrideAnimationSpeed fun(speed:number):nil
---@field public OverrideOnscreenDuration fun(duration:number):nil
```