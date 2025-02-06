---
layout: default
title: Parameters
parent: UIMenu
show_buttons: true
show_all_code: false
---
# Parameters
This section will show you **UIMenu** public parameters and the use you can do with them.
Examples are shown in C# and in Lua.

## Title
The title of the menu is shown onto the banner texture.
You can set it in constructor and get/set it using:

```c#
string Title {get;set;}
menu.Title
```

```lua
---Getter / Setter for the menu title.
---@param title string
---@return string | nil
menu:Title(title) -- if empty it returns the current title.
```

## Subtitle
The Subtitle is shown right after the banner and is always sided by the item count.
You can set it in constructor and get/set it using:

```c#
string Subtitle {get;set;} 
menu.Subtitle
```

```lua
---Getter / Setter for the subtitle.
---@param sub string
---@return string | nil
menu:Subtitle(subtitle)
```

## Description Font
Getter / Setter for the description font.

```c#
ItemFont DescriptionFont { get; set; } 
menu.DescriptionFont
```

```lua
---Getter / Setter for the description font.
---@param fontTable ItemFont
---@return ItemFont
menu:DescriptionFont(fontTable)
```

## Counter Color
Getter / Setter for the counter color.

```c#
SColor CounterColor { get; set; } 
menu.CounterColor
```

```lua
---Getter / Setter for the counter color.
---@param color SColor
---@return any
menu:CounterColor(color)
```

## Subtitle Color
Getter / Setter for the subtitle color.

```c#
HudColour SubtitleColor { get; set; } 
menu.SubtitleColor
```

```lua
---Getter / Setter for the subtitle color.
---@param color HudColours
---@return any
menu:SubtitleColor(color)
```

## Menu Alignment
Getter / Setter for the menu alignment.

```c#
MenuAlignment MenuAlignment { get; set; } 
menu.MenuAlignment
```

```lua
---Getter / Setter for the Menu Alignment.
---@param align MenuAlignment
---@return MenuAlignment | nil
menu:MenuAlignment(align)
```

## Disable Game Controls
Enable/disable non-menu game controls.

```c#
bool DisableGameControls { get; set; } 
menu.DisableGameControls
```

```lua
---Enable/disable non-menu game controls.
---@param bool? boolean
---@return boolean | nil
menu:DisableGameControls(bool)
```

## Instructional Buttons
Enable/disable instructional buttons.

```c#
bool HasInstructionalButtons { get; set; } 
menu.HasInstructionalButtons
```

```lua
---Enable/disable instructional buttons.
---@param enabled boolean|nil
---@return boolean
menu:HasInstructionalButtons(enabled)
```

## Can Player Close Menu
Sets if the menu can be closed by the player.

```c#
bool CanPlayerCloseMenu { get; set; } 
menu.CanPlayerCloseMenu
```

```lua
---Sets if the menu can be closed by the player.
---@param playerCanCloseMenu boolean|nil
---@return boolean
menu:CanPlayerCloseMenu(playerCanCloseMenu)
```

## Mouse Edge Enabled
Sets if the camera can be rotated when the mouse cursor is near the edges of the screen.

```c#
bool MouseEdgeEnabled { get; set; } 
menu.MouseEdgeEnabled
```

```lua
---Sets if the camera can be rotated when the mouse cursor is near the edges of the screen.
---@param enabled boolean|nil
---@return boolean
menu:MouseEdgeEnabled(enabled)
```

## Mouse Controls Enabled
Enables or disables mouse controls for the menu.

```c#
bool MouseControlsEnabled { get; set; } 
menu.MouseControlsEnabled
```

```lua
---Enables or disables mouse controls for the menu.
---@param enabled boolean|nil
---@return boolean
menu:MouseControlsEnabled(enabled)
```

## Animation Enabled
Enable or disable scrolling animation.

```c#
bool AnimationEnabled { get; set; } 
menu.AnimationEnabled
```

```lua
---Enable or disable scrolling animation.
---@param enable boolean|nil
---@return boolean
menu:AnimationEnabled(enable)
```

## 3D Animations Enabled
Enable or disable 3D animations.

```c#
bool Enabled3DAnimations { get; set; } 
menu.Enabled3DAnimations
```

```lua
---Enable or disable 3D animations.
---@param enable boolean|nil
---@return boolean
menu:Enabled3DAnimations(enable)
```

## Animation Type
Sets the menu's scrolling animation type while the menu is visible.

```c#
MenuAnimationType AnimationType { get; set; } 
menu.AnimationType
```

```lua
---Sets the menu's scrolling animation type while the menu is visible.
---@param menuAnimationType MenuAnimationType|nil
---@return number MenuAnimationType
---@see MenuAnimationType
menu:AnimationType(menuAnimationType)
```

## Building Animation
Enables or disables the menu's building animation type.

```c#
MenuBuildingAnimation BuildingAnimation { get; set; } 
menu.BuildingAnimation
```

```lua
---Enables or disables the menu's building animation type.
---@param buildingAnimationType MenuBuildingAnimation|nil
---@return MenuBuildingAnimation
---@see MenuBuildingAnimation
menu:BuildingAnimation(buildingAnimationType)
```

## Scrolling Type
Decides how the menu behaves on scrolling and overflowing.

```c#
MenuScrollingType ScrollingType { get; set; } 
menu.ScrollingType
```

```lua
---Decides how the menu behaves on scrolling and overflowing.
---@param scrollType MenuScrollingType|nil
---@return MenuScrollingType
---@see MenuScrollingType
menu:ScrollingType(scrollType)
```

## Current Selection
Gets or sets the currently selected item index in the menu.

```c#
int CurrentSelection { get; set; } 
menu.CurrentSelection
```

```lua
---Gets or sets the currently selected item index in the menu.
---@param value number|nil
---@return number
menu:CurrentSelection(value)
```

## Max Items On Screen
Gets or sets the maximum number of items visible on the screen.

```c#
int MaxItemsOnScreen { get; set; } 
menu.MaxItemsOnScreen
```

```lua
---Gets or sets the maximum number of items visible on the screen.
---@param max number|nil
---@return number
menu:MaxItemsOnScreen(max)
```


## Visible
This is maybe the **most important parameter of the menu**.
Gets or sets the visibility state of the menu drawing it or stopping the draw.

```c#
bool Visible { get; set; } 
menu.Visible
```

```lua
---Gets or sets the visibility state of the menu.
---@param bool boolean|nil
---@return boolean
menu:Visible(bool)
```

## Is Mouse Over The Menu
Checks if the mouse is currently over the menu.

```c#
bool IsMouseOverTheMenu() 
menu.IsMouseOverTheMenu()
```

```lua
---Checks if the mouse is currently over the menu.
---@return boolean
menu:IsMouseOverTheMenu()
```
