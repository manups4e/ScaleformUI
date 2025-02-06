---
layout: default
title: Radial Segment
parent: Radial Menu
show_buttons: true
show_all_code: false
---

# Radial Segment
Only 8 of them exist, and usually they're already available on menu open. You can access them directly by the Segments List in Clockwise order 

## Parameters

### CurrentSelection
Gets or Sets the current segment selection scrolling its internal items

```c#
int CurrentSelection { get; set; } 
```

```lua
radMenu.Segments[currSeg]:CurrentSelection()
```

## Functions

### Add Item
Adds a [SegmentItem](./segmentitem.md) to the list of this Segment

```c#
public void AddItem(SegmentItem item)
```

```lua
radMenu.Segments[curSeg]:AddItem(item)
```

### RemoveItem and RemoveItemAt
Removes an item from the list

```c#
public void RemoveItemAt(int index){}
public void RemoveItem(SegmentItem item){}
```

```lua
function RadialSegment:RemoveItem(item)
```