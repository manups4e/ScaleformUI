---
layout: default
title: UIMenuItem
parent: Menu Items
show_buttons: true
show_all_code: false
nav_order: 1
---

# UIMenuItem

![UIMenuItem](https://user-images.githubusercontent.com/4005518/162608037-bc6e4c8e-a912-4465-bc8b-cfccedf6948d.png)

**UIMenuItem** is the father of all other items, this means that every other menu-item has the same functions and features of this item except for some that are disabled for design reason.

## Constructor

```c#
public UIMenuItem(string text);
public UIMenuItem(string text, string description);
public UIMenuItem(string text, uint descriptionHash);
public UIMenuItem(string text, string description, HudColor mainColor, HudColor highlightColor);
public UIMenuItem(string text, uint descriptionHash, HudColor mainColor, HudColor highlightColor);
public UIMenuItem(string text, string description, HudColor color, HudColor highlightColor, HudColor textColor, HudColor highlightedTextColor);
public UIMenuItem(string text, uint descriptionHash, HudColor color, HudColor highlightColor, HudColor textColor, HudColor highlightedTextColor);
```

```lua
UIMenuItem.New(text, description, color, highlightColor, textColor, highlightedTextColor)
```

## Parameters

### Selected
Sets or gets the selected state of the menu item, and updates the menu labels accordingly.

```c#
public bool Selected {get;set;}
item.Selected = true;
```

```lua
--- Sets or gets the selected state of the menu item, and updates the menu labels accordingly.
item:Selected(bool)
```

---

### Hovered
Sets or gets the hovered state of the menu item.

```c#
public bool Hovered {get;set;}
item.Hovered = true;
```

```lua
--- Sets or gets the hovered state of the menu item.
item:Hovered(bool)
```

---

### Enabled
Sets or gets the enabled state of the menu item, and updates the menu labels accordingly.

```c#
public bool Enabled {get;set;}
item.Enabled = true;
```

```lua
--- Sets or gets the enabled state of the menu item, and updates the menu labels accordingly.
item:Enabled(bool)
```

---

### Description
Sets or gets the description for the menu item.

```c#
public string Description {get;set;}
item.Description = "This is a description";
```

```lua
--- Sets or gets the description for the menu item.
item:Description(str)
```

---

### MainColor
Sets or gets the main color for the menu item.

```c#
public SColor MainColor {get;set;}
item.MainColor = SColor.FromArgb(255, 0, 0);
```

```lua
--- Sets or gets the main color for the menu item.
item:MainColor(color)
```

---

### TextColor
Sets or gets the text color for the menu item.

```c#
public SColor TextColor {get;set;}
item.TextColor(SColor(0, 255, 0)); -- Green color
```

```lua
--- Sets or gets the text color for the menu item.
item:TextColor(color)
```

---

### HighlightColor
Sets or gets the highlight color for the menu item.

```c#
public SColor HighlightColor {get;set;}
item.HighlightColor = SColor.FromArgb(0, 0, 255);
```

```lua
--- Sets or gets the highlight color for the menu item.
item:HighlightColor(color)
```

---

### HighlightedTextColor
Sets or gets the text color when the item is highlighted.

```c#
public SColor HighlightedTextColor {get;set;}
item.HighlightedTextColor = SColor.FromArgb(255, 255, 0);
```

```lua
--- Sets or gets the text color when the item is highlighted.
item:HighlightedTextColor(color)
```

---

### Label
Sets or gets the left label for the menu item.

```c#
public string Label {get;set;}
item.Label = "Left Label";
```

```lua
--- Sets or gets the left label for the menu item.
item:Label(Text)
```

---

### RightLabel
Sets (Lua only) or gets the right label for the menu item.

```c#
public string RightLabel {get; private set;}
var rLabel = item.RightLabel;
```

```lua
--- Sets or gets the right label for the menu item.
item:RightLabel(Text)
```

---

### RightBadge
Sets (Lua only) or gets the right badge for the menu item.

```c#
public BadgeIcon RightBadge {get;private set;}
var badge = item.RightBadge;
```

```lua
--- Sets or gets the right badge for the menu item.
item:RightBadge(Badge)
```

---

### LeftBadge
Sets (Lua only) or gets the left badge for the menu item.

```c#
void LeftBadge {get;private set;}
var lBadge = item.LeftBadge;
```

```lua
--- Sets or gets the left badge for the menu item.
item:LeftBadge(Badge)
```

## Functions

### BlinkDescription
Sets or retrieves the blinking description for a menu item. If `bool` is provided, it sets the blinking status, otherwise, it returns the current blinking status.

```c#
public bool BlinkDescription {get;set;}
item.BlinkDescription = true;
```

```lua
--- Sets or retrieves the blinking description for a menu item.
function item:BlinkDescription(bool)
```

### CustomRightBadge
Sets a custom right badge for a menu item, typically used for visual indicators such as icons.

```c#
public void SetCustomRightBadge(txd, txn)
item.SetCustomRightBadge("txd", "txn");
```

```lua
--- Sets a custom right badge for a menu item.
function item:CustomRightBadge(txd, txn)
```

### CustomLeftBadge
Sets a custom left badge for a menu item, typically used for visual indicators such as icons.

```c#
public void SetCustomLeftBadge(txd, txn)
item.SetCustomLeftBadge("txd", "txn");
```

```lua
--- Sets a custom left badge for a menu item.
function item:CustomLeftBadge(txd, txn)
```

### AddPanel
Adds a panel to a menu item.

```c#
public void AddPanel(UIMenuPanel panel)
item.AddPanel(panel)
```

```lua
--- Adds a panel to a menu item.
function item:AddPanel(Panel)
```

### AddSidePanel
Adds a side panel to a menu item, used for additional details or options.

```c#
public void AddSidePanel(sidePanel)
item.AddSidePanel(sidePanel)
```

```lua
--- Adds a side panel to a menu item.
function item:AddSidePanel(sidePanel)
```

### RemoveSidePanel
Removes the side panel from a menu item.

```c#
public void RemoveSidePanel()
item.RemoveSidePanel();
```

```lua
--- Removes the side panel from a menu item.
function item:RemoveSidePanel()
```

### RemovePanelAt
Removes a panel from a menu item by index.

```c#
void RemovePanelAt(Index)
item.RemovePanelAt(index);
```

```lua
--- Removes a panel from a menu item by index.
function item:RemovePanelAt(Index)
```

## Events

### ItemActivatedEvent
Triggered everytime a player select the item after highlighting it

```c#
public event ItemActivatedEvent Activated
```

```lua
Activated = function(menu, item)
end
```

### ItemHighlightedEvent
Triggered everytime a player highlightings an item

```c#
public event ItemHighlightedEvent Highlighted
```

```lua
Highlighted = function(menu, item)
end
```