---
layout: default
title: UIMissionDetailsPanel
parent: Side Panels
show_buttons: true
show_all_code: false
---

# UIMissionDetailsPanel

![image](https://user-images.githubusercontent.com/4005518/162627871-fad1dac4-7055-4187-819c-e21dfd8d865f.png)  

## Constructor

```c#
public UIMissionDetailsPanel(PanelSide side, string title, bool inside, string txd = "", string txn = "")
public UIMissionDetailsPanel(PanelSide side, string title, HudColor color, string txd = "", string txn = "")
```

```lua
UIMissionDetailsPanel.New(side, title, color, inside, txd, txn)
```

This panel is a bit more complex as it needs 1 more item to work, for each item in the side panel we must initialize a new [UIMenuFreemodeDetailsItem](./uimenufreemodedetailsitem.md)  

## Parameters

### Title
Gets or Sets the panel title.

```c#
string Title { get; set; }
```

```lua
:UpdatePanelTitle(title)
```

### Update panel background

```c#
UpdatePanelPicture(string txd, string txn)
```

```lua
:UpdatePanelPicture(txd, txn)
```

### Add / Remove Item

```c#
AddItem(UIFreemodeDetailsItem item)
RemoveItem(int idx)
```

```lua
:AddItem(newitem)
:RemoveItemAt(index)
```