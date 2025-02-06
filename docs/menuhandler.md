---
layout: default
page: default
title: Menu Handler
show_buttons: true
show_all_code: false
---

# Menu Handler

With The Gary update, MenuPool no longer exists and in its ashes, MenuHandler was born. 

MenuHandler handles the currently visible menu, and draws it for you, it also handle the switching between menus.
It doesn't need to be instantiated as it's ready to work as soon as you start ScaleformUI!

MenuHandler gives you informations about the currently visible menu or pause menu.

Here's what you can find inside it:

```c#
MenuBase CurrentMenu // returns the currently open menu, null if no menu is open
PauseMenuBase CurrentPauseMenu // returns the currently open pause menu, null if no menu is open
bool IsAnyMenuOpen // return true if any MenuBase menu is currently visible
bool IsAnyPauseMenuOpen // return true if any PauseMenuBase menu is currently visible
async Task SwitchTo(this MenuBase currentMenu, MenuBase newMenu, int newMenuCurrentSelection = 0, bool inheritOldMenuParams = false, dynamic data = null); // the unique method to switch from a menu to another
void CloseAndClearHistory() // Closes whatever menu is visible and clears the BreadcrumbHandler.
```

```lua
._currentMenu -- returns the currently open menu, null if no menu is open
._currentPauseMenu -- returns the currently open pause menu, null if no menu is open
:IsAnyMenuOpen() -- [bool] return true if any MenuBase menu is currently visible
:IsAnyPauseMenuOpen() -- [bool] return true if any PauseMenuBase menu is currently visible
:SwitchTo(currentMenu, newMenu, newMenuCurrentSelection, inheritOldMenuParams, data) -- the unique method to switch from a menu to another
:CloseAndClearHistory() -- Closes whatever menu is visible and clears the BreadcrumbHandler
```