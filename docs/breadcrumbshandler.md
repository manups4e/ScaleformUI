---
layout: default
title: Breadcrumbs Handler
show_buttons: true
show_all_code: false
---

# Breadcrumbs Handler

It's a very basic utility used internally to keep track of menu navigation.

```c#
// MenuBase is the basic menu parent for UIMenu, RadialMenu, RadioMenu in C#.
public static bool SwitchInProgress { get; internal set; }
public static MenuBase PreviousMenu;
```

```lua
BreadcrumbsHandler:PreviousMenu()
BreadcrumbsHandler.SwitchInProgress
```