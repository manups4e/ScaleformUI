---
layout: default
title: Segment Item
parent: Radial Menu
show_buttons: true
show_all_code: false
---

# Segment Item
Each of the 8 [RadialSegment](./radialsegment.md)s can have multiple instances of this item.

## Constructor

```c#
public SegmentItem(string label, string desc, string txd, string txn, int txwidth, int txheight, SColor color)
```

```lua
SegmentItem.New(_label, _desc, _txd, _txn, _txwidth, _txheight, _color)
```

## Parameters

###  Label 

```c#
public string Label {get; set;}
```

```lua
segItem:Label(lbl)
```

###  Description 

```c#
public string Description {get; set;}
```

```lua
segItem:Description(desc)
```

###  TextureDict 

```c#
public string TextureDict {get; set;}
```

```lua
segItem:TextureDict(txd)
```

###  TextureName 

```c#
public string TextureName {get; set;}
```

```lua
segItem:TextureName(txn)
```

###  TextureWidth 

```c#
public int TextureWidth {get; set;}
```

```lua
segItem:TextureWidth(width)
```

###  TextureHeight 

```c#
public int TextureHeight {get; set;}
```

```lua
segItem:TextureHeight(height)
```

###  Color 

```c#
public SColor Color {get; set;}
```

```lua
segItem:Color(color)
```

## Functions

### Set Quantity
Set the quantity of this item, if max == 0 then the quantity will be centered

```c#
public void SetQuantity(int qtty, int max = 0)
```

```lua
segItem:SetQuantity(qtty, max)
```
