---
layout: default
title: UIMenuFreemodeDetailsItem
parent: UIMissionDetailsPanel
show_buttons: true
show_all_code: false
---

# UIMenuFreemodeDetailsItem

The item used to fill the MissionDetailPanel and other components in Pause Menus / Lobby Menus info panel.

## Constructor

```c#
UIFreemodeDetailsItem(string textLeft, string textRight, bool separator)
UIFreemodeDetailsItem(string textLeft, string textRight, BadgeIcon icon, HudColor iconColor = HudColor.HUD_COLOUR_FREEMODE, bool tick = false)
```

```lua
-- If icon and iconColor are specified, then separator will be ignored, also icon is a Badge.. the same used for normal UIMenuItems
UIMenuFreemodeDetailsItem.New(textLeft, textRight, seperator, icon, iconColor, tick) 
```
