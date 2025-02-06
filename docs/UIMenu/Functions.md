---
layout: default
title: Functions
parent: UIMenu
show_buttons: true
show_all_code: false
---

# Functions
This section will show you UIMenu public functions and the use you can do with them. Examples are shown in C# and in Lua.

## Set Menu Offset
Sets the position offset for the menu.

{: .warning}
> ⚠️ Warning
> 
> Position is safezone dependant and positive values will shift the menu to the **right when Left aligned** and to the **left when Right aligned**!

```c#
void SetMenuOffset(Vector2 position) 

Vector2 position = new Vector2(0, 0);
menu.SetMenuOffset(position);
```

```lua
---Sets the position offset for the menu.
---@param x number
---@param y number
menu:SetMenuOffset(x, y)
```

## Refresh Menu
Refreshes the menu, optionally keeping the current selection index.

```c#
void RefreshMenu(bool keepIndex) 
menu.RefreshMenu(keepIndex)
```

```lua
---Refreshes the menu, optionally keeping the current selection index.
---@param keepIndex boolean
menu:RefreshMenu(keepIndex)
```

## Set Banner Sprite
Sets the banner sprite using a dictionary and name.

```c#
void SetBannerSprite(KeyValuePair<string, string> spriteInfo) 
menu.SetBannerSprite(new KeyValuePair<string, string>("txtDictionary", "txtName"))
```

```lua
---Sets the banner sprite using a dictionary and name.
---@param txtDictionary string
---@param txtName string
menu:SetBannerSprite(txtDictionary, txtName)
```

## Set Banner Color
Sets the banner color for the menu.

```c#
void SetBannerColor(SColor color) 
menu.SetBannerColor(color)
```

```lua
---Sets the banner color for the menu.
---@param color SColor
menu:SetBannerColor(color)
```

## Set Animations
Handles all the menu animations in one place.

```c#
void SetAnimations(bool enableScrollingAnim, bool enable3DAnim, MenuAnimationType scrollingAnimation, MenuBuildingAnimation buildingAnimation, float fadingTime) 
menu.SetAnimations(enableScrollingAnim, enable3DAnim, scrollingAnimation, buildingAnimation, fadingTime)
```

```lua
---Handles all the menu animations in one place.
---@param enableScrollingAnim boolean
---@param enable3DAnim boolean
---@param scrollingAnimation MenuAnimationType
---@param buildingAnimation MenuBuildingAnimation
---@param fadingTime number
menu:SetMenuAnimations(enableScrollingAnim, enable3DAnim, scrollingAnimation, buildingAnimation, fadingTime)
```

## Add Window
Adds a window to the menu, only if the menu is not itemless.

```c#
void AddWindow(UIMenuWindow window) 
menu.AddWindow(window)
```

```lua
---Adds a window to the menu, only if the menu is not itemless.
---@param window table
menu:AddWindow(window)
```

## Remove Window At
Removes a window from the menu at a specified index.

```c#
void RemoveWindowAt(int index) 
menu.RemoveWindowAt(index)
```

```lua
---Removes a window from the menu at a specified index.
---@param Index number
menu:RemoveWindowAt(Index)
```

## Add Item
Adds a new item to the menu.

```c#
void AddItem(UIMenuItem item) 
menu.AddItem(item)
```

```lua
--- Adds a new item to the menu.
---@param item UIMenuItem
---@see UIMenuItem
menu:AddItem(item)
```

## Add Item At
Adds an item at a specified index in the menu.

```c#
void AddItemAt(UIMenuItem item, int index) 
menu.AddItemAt(item, index)
```

```lua
--- Adds an item at a specified index in the menu.
---@param item UIMenuItem
---@param index number
menu:AddItemAt(item, index)
```

## Remove Item At
Removes an item from the menu at a specified index.

```c#
void RemoveItemAt(int index) 
menu.RemoveItemAt(index)
```

```lua
--- Removes an item from the menu at a specified index.
---@param index number
menu:RemoveItemAt(index)
```

## Remove Item
Removes an item from the menu by matching its label.

```c#
void RemoveItem(UIMenuItem item) 
menu.RemoveItem(item)
```

```lua
--- Removes an item from the menu by matching its label.
---@param item UIMenuItem
menu:RemoveItem(item)
```

## Clear
Removes all items from the menu.

```c#
void Clear() 
menu.Clear()
```

```lua
--- Removes all items from the menu.
menu:Clear()
```

## Switch To
Switches from the current menu to a new menu.

```c#
void SwitchTo(UIMenu newMenu, int newMenuCurrentSelection = 1, bool inheritOldMenuParams = true)
menu.SwitchTo(newMenu, newMenuCurrentSelection, inheritOldMenuParams)
```

```lua
--- Switches from the current menu to a new menu.
---@param newMenu UIMenu
---@param newMenuCurrentSelection number|nil
---@param inheritOldMenuParams boolean|nil
menu:SwitchTo(newMenu, newMenuCurrentSelection, inheritOldMenuParams)
```

## Set Mouse
Configures mouse settings for the menu.

```c#
void SetMouse(bool enableMouseControls, bool enableEdge, bool isWheelEnabled, bool resetCursorOnOpen, bool leftClickSelect)
menu.SetMouse(enableMouseControls, enableEdge, isWheelEnabled, resetCursorOnOpen, leftClickSelect)
```

```lua
--- Configures mouse settings for the menu.
---@param enableMouseControls boolean
---@param enableEdge boolean
---@param isWheelEnabled boolean
---@param resetCursorOnOpen boolean
---@param leftClickSelect boolean
menu:MouseSettings(enableMouseControls, enableEdge, isWheelEnabled, resetCursorOnOpen, leftClickSelect)
```

## Filter Menu Items
Filters menu items based on a predicate.

```c#
void FilterMenuItems(Func<UIMenuItem, bool> predicate)
menu.FilterMenuItems(predicate);
```

```lua
--- Filters menu items based on a predicate.
---@param predicate function A function that returns true to keep an item.
---@param fail function A function that executes if no items match the filter.
menu:FilterMenuItems(predicate, fail)
```

---

## Sort Menu Items
Sorts menu items using a custom comparison function.

```c#
void SortMenuItems(Comparison<UIMenuItem> compare)
menu.SortMenuItems(compare);
```

```lua
--- Sorts menu items using a custom comparison function.
---@param compare function A function to compare two items.
menu:SortMenuItems(compare)
```

---

## Reset Filter
Resets the filtering/sorting of items, restoring the original order.

```c#
void ResetFilter()
menu.ResetFilter();
```

```lua
--- Resets the filtering/sorting of items, restoring the original order.
menu:ResetFilter()
```

## Update Description
Refreshes the menu description in case of changes without updating via Scaleform.

```c#
void UpdateDescription()
menu.UpdateDescription();
```

```lua
--- Refreshes the menu description in case of changes without updating via Scaleform.
function UIMenu:UpdateDescription()
```

## Instructional Buttons Management

### AddInstructionButton
Adds an instructional button to the menu.

```c#
void AddInstructionalButton(InstructionalButton button)
menu.AddInstructionalButton(button);
```

```lua
--- Adds an instructional button to the menu.
---@param button InstructionalButton
function UIMenu:AddInstructionButton(button)
```

---

### RemoveInstructionButton
Removes an instructional button from the menu.

```c#
void RemoveInstructionalButton(InstructionalButton button)
menu.RemoveInstructionalButton(button);

void RemoveInstructionalButton(int index)
menu.RemoveInstructionalButton(index);
```

```lua
--- Removes an instructional button from the menu.
---@param button table
function UIMenu:RemoveInstructionButton(button)
```

---

### ClearInstructionalButtons
Clears all instructional buttons from the menu.

```c#
void ClearInstructionalButtons()
menu.ClearInstructionalButtons();
```

```lua
--- Clears all instructional buttons from the menu.
function UIMenu:ClearInstructionalButtons()
    self.InstructionalButtons = {}
end
```
