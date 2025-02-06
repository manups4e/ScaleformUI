---
layout: default
title: Countdown
parent: Scaleforms API
show_buttons: true
show_all_code: false
---

# Countdown

<iframe width="420" height="315" src="https://github.com/manups4e/ScaleformUI/assets/4005518/acb4e55c-88b8-4159-b522-e3767f5c2892" frameborder="0" allowfullscreen></iframe>

```c#
Main.Countdown
```  

```lua
ScaleformUI.Scaleforms.Countdown
```

## Functions

```c#
async Task Start(int number = 3, HudColor hudColor = HudColor.HUD_COLOUR_GREEN, string countdownAudioName = "321", string countdownAudioRef = "Car_Club_Races_Pursuit_Series_Sounds", string goAudioName = "Go", string goAudioRef = "Car_Club_Races_Pursuit_Series_Sounds")
// This will start a countdown and play the audio for each step, default is 3, 2, 1, GO
// method is awaitable and will return when the countdown shows "GO"
```

```lua
:Start(number, hudColour, countdownAudioName, countdownAudioRef, goAudioName, goAudioRef)
---Starts the countdown
---@param number number? - The number to start the countdown from
---@param hudColour number? - The hud colour to use for the countdown
---@param countdownAudioName string? - The audio name to play for each number
---@param countdownAudioRef string? - The audio ref to play for each number
---@param goAudioName string? - The audio name to play when the countdown is finished
---@param goAudioRef string? - The audio ref to play when the countdown is finished
---@return promise
-- consider that:
  if number == nil then number = 3 end
  if hudColour == nil then hudColour = 18 end
  if countdownAudioName == nil then countdownAudioName = "321" end
  if countdownAudioRef == nil then countdownAudioRef = "Car_Club_Races_Pursuit_Series_Sounds" end
  if goAudioName == nil then goAudioName = "Go" end
  if goAudioRef == nil then goAudioRef = "Car_Club_Races_Pursuit_Series_Sounds" end

```
